package br.com.palpiteiro.app;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Toast;
import android.view.WindowInsets;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public class MainActivity extends Activity {

    private HistoryDbHelper database;
    private WebView view;

    @SuppressLint({"SetJavaScriptEnabled", "AddJavascriptInterface"})
    @Override
    public void onCreate(Bundle state) {
        super.onCreate(state);

        database = new HistoryDbHelper(this);

        importInitialHistory();

        view = new WebView(this);

        WebSettings settings = view.getSettings();

        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);

        /*
         * Permite que o WebView carregue os arquivos
         * existentes dentro de android_asset.
         */
        settings.setAllowFileAccess(true);
        settings.setAllowContentAccess(true);

        view.addJavascriptInterface(
                new DatabaseBridge(),
                "AndroidDB"
        );

        view.loadUrl(
                "file:///android_asset/index.html"
        );

        view.setOnApplyWindowInsetsListener((v, insets) -> {
            v.setPadding(
                    insets.getSystemWindowInsetLeft(),
                    insets.getSystemWindowInsetTop(),
                    insets.getSystemWindowInsetRight(),
                    insets.getSystemWindowInsetBottom()
            );
            return insets;
        });

        setContentView(view);

        /*
         * Verifica se o aplicativo foi aberto
         * atravÃ©s do callback do Google.
         */
        handleDeepLink(getIntent());
    }


    /*
     * =========================
     * DEEP LINK / GOOGLE LOGIN
     * =========================
     */

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        setIntent(intent);

        handleDeepLink(intent);
    }


    private void handleDeepLink(Intent intent) {

        if (intent == null) {
            return;
        }

        Uri uri = intent.getData();

        if (uri == null) {
            return;
        }

        /*
         * Esperamos:
         *
         * brasileirao://login-callback
         *
         * com os parÃ¢metros retornados pelo Supabase.
         */
        if (
                "brasileirao".equalsIgnoreCase(uri.getScheme())
                        &&
                "login-callback".equalsIgnoreCase(uri.getHost())
        ) {

            String callbackUrl = uri.toString();

            android.util.Log.d(
                    "BRASILEIRAO_OAUTH",
                    "Callback recebido: scheme=" + uri.getScheme()
                            + ", host=" + uri.getHost()
                            + ", path=" + uri.getPath()
                            + ", hasCode=" + (uri.getQueryParameter("code") != null)
                            + ", hasAccessToken=" + (uri.getQueryParameter("access_token") != null)
                            + ", hasRefreshToken=" + (uri.getQueryParameter("refresh_token") != null)
            );

            /*
             * Aguarda o WebView estar carregado antes
             * de enviar o callback para o JavaScript.
             */
            if (view != null) {

                view.postDelayed(
                        () -> {

                            String escapedUrl =
                                    JSONObject.quote(callbackUrl);

                            view.evaluateJavascript(
                                    "window.handleGoogleCallback(" +
                                            escapedUrl +
                                            ");",
                                    null
                            );

                        },
                        500
                );
            }
        }
    }


    /*
     * =========================
     * IMPORTAR HISTÃ“RICO
     * =========================
     */

    private void importInitialHistory() {

        if (!database.isEmpty()) {
            return;
        }

        try (
                InputStream input =
                        getAssets().open("historico.json")
        ) {

            ByteArrayOutputStream output =
                    new ByteArrayOutputStream();

            byte[] buffer =
                    new byte[8192];

            int read;

            while (
                    (read = input.read(buffer)) != -1
            ) {

                output.write(
                        buffer,
                        0,
                        read
                );
            }

            JSONObject history =
                    new JSONObject(
                            output.toString(
                                    StandardCharsets.UTF_8.name()
                            )
                    );

            database.importHistory(history);

        } catch (Exception e) {

            Toast.makeText(
                    this,
                    "NÃ£o foi possÃ­vel importar o histÃ³rico.",
                    Toast.LENGTH_LONG
            ).show();
        }
    }


    /*
     * =========================
     * PONTE JAVASCRIPT
     * =========================
     */

    public class DatabaseBridge {

        /*
         * =========================
         * HISTÃ“RICO
         * =========================
         */

        @JavascriptInterface
        public String getHistory() {

            return database.exportHistoryJson();
        }


        @JavascriptInterface
        public boolean saveResponse(
                String data,
                String email,
                String predictionsJson
        ) {

            try {

                JSONArray predictions =
                        new JSONArray(
                                predictionsJson == null
                                        ? "[]"
                                        : predictionsJson
                        );

                database.insertResponse(
                        data,
                        email,
                        predictions
                );

                return true;

            } catch (Exception e) {

                return false;
            }
        }


        /*
         * =========================
         * CADASTRO
         * =========================
         */

        @JavascriptInterface
        public boolean createUser(
                String email,
                String password,
                String club
        ) {

            return database.createUser(
                    email,
                    password,
                    club
            );
        }


        /*
         * =========================
         * VERIFICAR USUÃRIO
         * =========================
         */

        @JavascriptInterface
        public boolean userExists(
                String email
        ) {

            return database.userExists(email);
        }


        /*
         * =========================
         * LOGIN
         * =========================
         */

        @JavascriptInterface
        public String loginUser(
                String email,
                String password
        ) {

            return database.loginUser(
                    email,
                    password
            );
        }
    }


    /*
     * =========================
     * ENCERRAMENTO
     * =========================
     */

    @Override
    protected void onDestroy() {

        if (database != null) {
            database.close();
        }

        super.onDestroy();
    }
}



