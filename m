Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650526E415E
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 09:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjDQHkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 03:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDQHkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 03:40:52 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B855253
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 00:40:27 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n43-20020a05600c502b00b003f17466a9c1so658931wmr.2
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 00:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681717220; x=1684309220;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3y8aPQgOvoJwSTlB16np8gZ7mEu48SprWU1OLM7t2EY=;
        b=Q0kUWkbBARCqihzYfC7ynvUsdGTkhMsyh5fm7/hrg/kyLi3UR04bgDIUB4ijsOVsof
         n4+aUNm6adB+iF9ilW/GhfMexNEp8a6+yj+45qlIP0UQOaC4h14EgODg+Mcs1vIZmiOq
         4dvC4rT2aC0Fy8WAlHsfX5bhRvN5iPkAiNgKRZI/h2Q+ttwC7rOfSXXAZOPkx2lnXbHQ
         uRnyTChkbe2DvC9PM9DWYIsDFd0KvSj1L9DAVyjgbeeyw+wgLM8Te5vqk9cF4qE7kiPs
         znPe2LOvB1Gr6+UrxctYlyUDU80t4YcwCJSjCwGT13vzrmTKQL4I07XxekurnFx+WMG3
         Xt3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681717220; x=1684309220;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3y8aPQgOvoJwSTlB16np8gZ7mEu48SprWU1OLM7t2EY=;
        b=VGSOJeH6SwCI9nIUz4mE7c7icAfwQBjbhYUSS1ZRKQFI22BKZ6H6eozDmI2UE1UYDR
         Y/fJmNShCqGe30WMzOmjKPiisV1ncNnX2ad6CH9yoJJDwKFtCjSWBsT7UEWyLL7/cKdY
         eI6SG6R1q17PVc5gqNEbwsKCStS7Vz5CjEl6k5xGWZhKOY7d54mCiE1G85MVc+Q01XUV
         m97WVYd6lKjn+t1nL1o8CROJezlsPeD6ilQznm8iNpzKCZ2dCxkPyoZEun/AZBmK/GBq
         gKr/ghEzPzxb6y3B31z3VwkczACUdMM0r9CH+jp04Kwl9o7N7FikTLO7qDsmqM48+BRH
         8H5A==
X-Gm-Message-State: AAQBX9c3xCz6E8MvFw/VUfxxKgelI9vgObpL8c6ouqk6d2um9MX2N7ea
        ldYKJ/KSWvzB1ZKMFhhgn70aTw==
X-Google-Smtp-Source: AKy350bC5HsSl1Rn6Xmxt8XlYpLz2a7Ubqu4/u6z89XV16jAKStdTlpNZTICilRh9Bz+VJLGEzgGLw==
X-Received: by 2002:a05:600c:22c7:b0:3eb:3945:d405 with SMTP id 7-20020a05600c22c700b003eb3945d405mr10243498wmg.38.1681717220686;
        Mon, 17 Apr 2023 00:40:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:a1e1:81a8:1acc:2b91? ([2a01:e0a:982:cbb0:a1e1:81a8:1acc:2b91])
        by smtp.gmail.com with ESMTPSA id g2-20020a05600c000200b003f0aa490336sm10481002wmc.26.2023.04.17.00.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 00:40:20 -0700 (PDT)
Message-ID: <661a2ac6-adfe-dec9-5b7b-b006f2f31a90@linaro.org>
Date:   Mon, 17 Apr 2023 09:40:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [RESEND PATCH] drm/panel: otm8009a: Set backlight parent to panel
 device
Content-Language: en-US
To:     James Cowgill <james.cowgill@blaize.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Philippe CORNU <philippe.cornu@st.com>,
        Thierry Reding <treding@nvidia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230412173450.199592-1-james.cowgill@blaize.com>
Organization: Linaro Developer Services
In-Reply-To: <20230412173450.199592-1-james.cowgill@blaize.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/04/2023 19:35, James Cowgill wrote:
> This is the logical place to put the backlight device, and it also
> fixes a kernel crash if the MIPI host is removed. Previously the
> backlight device would be unregistered twice when this happened - once
> as a child of the MIPI host through `mipi_dsi_host_unregister`, and
> once when the panel device is destroyed.
> 
> Fixes: 12a6cbd4f3f1 ("drm/panel: otm8009a: Use new backlight API")
> Signed-off-by: James Cowgill <james.cowgill@blaize.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/panel/panel-orisetech-otm8009a.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c b/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
> index b4729a94c34a8..898b892f11439 100644
> --- a/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
> +++ b/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
> @@ -471,7 +471,7 @@ static int otm8009a_probe(struct mipi_dsi_device *dsi)
>   		       DRM_MODE_CONNECTOR_DSI);
>   
>   	ctx->bl_dev = devm_backlight_device_register(dev, dev_name(dev),
> -						     dsi->host->dev, ctx,
> +						     dev, ctx,
>   						     &otm8009a_backlight_ops,
>   						     NULL);
>   	if (IS_ERR(ctx->bl_dev)) {

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
