package com.filmstreamer;

import android.content.Context;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import java.io.ByteArrayInputStream;
import java.util.HashSet;
import java.util.Set;

public class AdBlockWebViewClient extends WebViewClient {

    private Set<String> adHosts = new HashSet<>();
    private Context context;

    public AdBlockWebViewClient(Context context) {
        this.context = context;
        loadAdHosts();
    }

    private void loadAdHosts() {
        adHosts.add("doubleclick.net");
        adHosts.add("googleadservices.com");
        adHosts.add("googlesyndication.com");
        adHosts.add("google-analytics.com");
        adHosts.add("adservice.google");
        adHosts.add("facebook.com/tr");
        adHosts.add("facebook.net");
        adHosts.add("connect.facebook");
        adHosts.add("criteo.com");
        adHosts.add("outbrain.com");
        adHosts.add("taboola.com");
        adHosts.add("advertising.com");
        adHosts.add("adnxs.com");
        adHosts.add("adsafeprotected.com");
        adHosts.add("adtechus.com");
        adHosts.add("amazon-adsystem.com");
        adHosts.add("bizographics.com");
        adHosts.add("casalemedia.com");
        adHosts.add("exoclick.com");
        adHosts.add("popads.net");
        adHosts.add("popcash.net");
        adHosts.add("propellerads.com");
        adHosts.add("revcontent.com");
        adHosts.add("scorecardresearch.com");
        adHosts.add("serving-sys.com");
        adHosts.add("sharethis.com");
        adHosts.add("tapad.com");
        adHosts.add("viglink.com");
        adHosts.add("zedo.com");
        adHosts.add("adcolony.com");
        adHosts.add("admob.com");
        adHosts.add("inmobi.com");
        adHosts.add("mopub.com");
        adHosts.add("chartbeat.com");
        adHosts.add("clicktripz.com");
        adHosts.add("quantserve.com");
        adHosts.add("rubiconproject.com");
        adHosts.add("yieldmo.com");
        adHosts.add("pubmatic.com");
        adHosts.add("openx.net");
        adHosts.add("indexww.com");
        adHosts.add("smartadserver.com");
        adHosts.add("advertising.com");
        adHosts.add("newrelic.com");
        adHosts.add("hotjar.com");
        adHosts.add("mouseflow.com");
        adHosts.add("inspectlet.com");
    }

    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
        String url = request.getUrl().toString();

        if (isAdUrl(url)) {
            return createEmptyResponse();
        }

        return super.shouldInterceptRequest(view, request);
    }

    private boolean isAdUrl(String url) {
        for (String adHost : adHosts) {
            if (url.contains(adHost)) {
                return true;
            }
        }

        if (url.contains("/ads/") || url.contains("/adv/") ||
            url.contains("/advertisement/") || url.contains("/banner/") ||
            url.contains("_ads.") || url.contains("-ads.") ||
            url.contains("adserver") || url.contains("ad-delivery") ||
            url.contains("popup") || url.contains("popunder")) {
            return true;
        }

        return false;
    }

    private WebResourceResponse createEmptyResponse() {
        return new WebResourceResponse("text/plain", "utf-8",
            new ByteArrayInputStream("".getBytes()));
    }
}
