package br.com.palpiteiro.app;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import org.json.JSONArray;
import org.json.JSONObject;

/** SQLite local database for users and prediction history. */
public class HistoryDbHelper extends SQLiteOpenHelper {

    private static final String DB_NAME = "palpiteiro.db";
    private static final int DB_VERSION = 2;

    public HistoryDbHelper(Context context) {
        super(context, DB_NAME, null, DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

        db.execSQL("CREATE TABLE users (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "email TEXT NOT NULL UNIQUE," +
                "password TEXT NOT NULL," +
                "club TEXT NOT NULL)");

        db.execSQL("CREATE TABLE responses (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "data TEXT NOT NULL," +
                "email TEXT NOT NULL)");

        db.execSQL("CREATE TABLE predictions (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "response_id INTEGER NOT NULL," +
                "position INTEGER NOT NULL," +
                "winner TEXT NOT NULL," +
                "score TEXT NOT NULL," +
                "FOREIGN KEY(response_id) REFERENCES responses(id) ON DELETE CASCADE)");

        db.execSQL("CREATE INDEX idx_predictions_response ON predictions(response_id)");
        db.execSQL("CREATE INDEX idx_responses_email ON responses(email)");
        db.execSQL("CREATE INDEX idx_users_email ON users(email)");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

        if (oldVersion < 2) {
            db.execSQL("CREATE TABLE users (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                    "email TEXT NOT NULL UNIQUE," +
                    "password TEXT NOT NULL," +
                    "club TEXT NOT NULL)");

            db.execSQL("CREATE INDEX idx_users_email ON users(email)");
        }
    }

    /* =========================
       USUÁRIOS
    ========================= */

    public boolean createUser(String email, String password, String club) {

        if (email == null || password == null || club == null) {
            return false;
        }

        email = email.trim().toLowerCase();

        if (email.isEmpty() || password.isEmpty() || club.isEmpty()) {
            return false;
        }

        SQLiteDatabase db = getWritableDatabase();

        ContentValues values = new ContentValues();
        values.put("email", email);
        values.put("password", password);
        values.put("club", club);

        try {
            long id = db.insertOrThrow("users", null, values);
            return id != -1;
        } catch (Exception e) {
            return false;
        }
    }

    public String loginUser(String email, String password) {

        if (email == null || password == null) {
            return "";
        }

        email = email.trim().toLowerCase();

        SQLiteDatabase db = getReadableDatabase();

        Cursor cursor = db.query(
                "users",
                new String[]{"email", "club"},
                "email = ? AND password = ?",
                new String[]{email, password},
                null,
                null,
                null
        );

        try {

            if (!cursor.moveToFirst()) {
                return "";
            }

            JSONObject user = new JSONObject();

            user.put("email", cursor.getString(0));
            user.put("club", cursor.getString(1));

            return user.toString();

        } catch (Exception e) {

            return "";

        } finally {

            cursor.close();

        }
    }

    public boolean userExists(String email) {

        if (email == null) {
            return false;
        }

        email = email.trim().toLowerCase();

        SQLiteDatabase db = getReadableDatabase();

        Cursor cursor = db.rawQuery(
                "SELECT COUNT(*) FROM users WHERE email = ?",
                new String[]{email}
        );

        try {

            return cursor.moveToFirst() && cursor.getInt(0) > 0;

        } finally {

            cursor.close();

        }
    }

    /* =========================
       HISTÓRICO
    ========================= */

    public boolean isEmpty() {

        SQLiteDatabase db = getReadableDatabase();

        Cursor c = db.rawQuery(
                "SELECT COUNT(*) FROM responses",
                null
        );

        try {

            return !c.moveToFirst() || c.getInt(0) == 0;

        } finally {

            c.close();

        }
    }

    public void importHistory(JSONObject history) {

        if (!isEmpty()) return;

        JSONArray responses =
                history.optJSONArray("respostas");

        if (responses == null) return;

        SQLiteDatabase db = getWritableDatabase();

        db.beginTransaction();

        try {

            for (int i = 0; i < responses.length(); i++) {

                JSONObject item =
                        responses.optJSONObject(i);

                if (item == null) continue;

                ContentValues response =
                        new ContentValues();

                response.put(
                        "data",
                        item.optString("data", "")
                );

                response.put(
                        "email",
                        item.optString("email", "")
                );

                long responseId =
                        db.insertOrThrow(
                                "responses",
                                null,
                                response
                        );

                JSONArray predictions =
                        item.optJSONArray("palpites");

                if (predictions == null) continue;

                for (
                        int position = 0;
                        position < predictions.length();
                        position++
                ) {

                    JSONObject prediction =
                            predictions.optJSONObject(position);

                    if (prediction == null) continue;

                    ContentValues values =
                            new ContentValues();

                    values.put(
                            "response_id",
                            responseId
                    );

                    values.put(
                            "position",
                            position
                    );

                    values.put(
                            "winner",
                            prediction.optString(
                                    "vencedor",
                                    ""
                            )
                    );

                    values.put(
                            "score",
                            prediction.optString(
                                    "placar",
                                    ""
                            )
                    );

                    db.insertOrThrow(
                            "predictions",
                            null,
                            values
                    );
                }
            }

            db.setTransactionSuccessful();

        } finally {

            db.endTransaction();

        }
    }

    public String exportHistoryJson() {

        SQLiteDatabase db =
                getReadableDatabase();

        JSONObject root =
                new JSONObject();

        JSONArray responses =
                new JSONArray();

        try {

            Cursor rc =
                    db.query(
                            "responses",
                            new String[]{
                                    "id",
                                    "data",
                                    "email"
                            },
                            null,
                            null,
                            null,
                            null,
                            "id ASC"
                    );

            try {

                while (rc.moveToNext()) {

                    long responseId =
                            rc.getLong(0);

                    JSONObject item =
                            new JSONObject();

                    item.put(
                            "data",
                            rc.getString(1)
                    );

                    item.put(
                            "email",
                            rc.getString(2)
                    );

                    JSONArray predictions =
                            new JSONArray();

                    Cursor pc =
                            db.query(
                                    "predictions",
                                    new String[]{
                                            "winner",
                                            "score"
                                    },
                                    "response_id = ?",
                                    new String[]{
                                            String.valueOf(responseId)
                                    },
                                    null,
                                    null,
                                    "position ASC"
                            );

                    try {

                        while (pc.moveToNext()) {

                            JSONObject prediction =
                                    new JSONObject();

                            prediction.put(
                                    "vencedor",
                                    pc.getString(0)
                            );

                            prediction.put(
                                    "placar",
                                    pc.getString(1)
                            );

                            predictions.put(prediction);
                        }

                    } finally {

                        pc.close();

                    }

                    item.put(
                            "palpites",
                            predictions
                    );

                    responses.put(item);
                }

            } finally {

                rc.close();

            }

            root.put(
                    "respostas",
                    responses
            );

            root.put(
                    "fonte",
                    "SQLite local (palpiteiro.db)"
            );

            root.put(
                    "observacao",
                    "Histórico armazenado no banco de dados local do aplicativo."
            );

        } catch (Exception e) {

            return "{\"respostas\":[],\"erro\":\"Falha ao consultar o banco\"}";

        }

        return root.toString();
    }

    public long insertResponse(
            String data,
            String email,
            JSONArray predictions
    ) {

        SQLiteDatabase db =
                getWritableDatabase();

        db.beginTransaction();

        try {

            ContentValues response =
                    new ContentValues();

            response.put(
                    "data",
                    data == null ? "" : data
            );

            response.put(
                    "email",
                    email == null ? "" : email
            );

            long responseId =
                    db.insertOrThrow(
                            "responses",
                            null,
                            response
                    );

            if (predictions != null) {

                for (
                        int position = 0;
                        position < predictions.length();
                        position++
                ) {

                    JSONObject prediction =
                            predictions.optJSONObject(position);

                    if (prediction == null) continue;

                    ContentValues values =
                            new ContentValues();

                    values.put(
                            "response_id",
                            responseId
                    );

                    values.put(
                            "position",
                            position
                    );

                    values.put(
                            "winner",
                            prediction.optString(
                                    "vencedor",
                                    ""
                            )
                    );

                    values.put(
                            "score",
                            prediction.optString(
                                    "placar",
                                    ""
                            )
                    );

                    db.insertOrThrow(
                            "predictions",
                            null,
                            values
                    );
                }
            }

            db.setTransactionSuccessful();

            return responseId;

        } finally {

            db.endTransaction();

        }
    }
}