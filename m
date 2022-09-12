Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0953E5B5FF5
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 20:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiILSLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 14:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiILSLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 14:11:18 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0530941D06
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 11:11:12 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s10so10912121ljp.5
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 11:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=svtvmckgsYFdMY08rsKItgup1eFeNNMS18fXK1hp66E=;
        b=AoFIEtHDHD4hpTZCOqlLzU2TQD+HdICYhbIBWNKx52yIiE9oaKvktDi0T89regh44I
         kRdc8nPGc6t1zHNic+8Lgsi9MvlWwSSnmMmq+5nbcQH8W7JoUSnVLQ4bllAPqmcZyq4j
         cqeCqhBWnTjraAzZcd0BlT2zWVxcJliL5mQ+HyUKPpA7J5m59uy7ViYv3E6H1NEaS++4
         PD1et0+flfvh+XvYkrLv/JGkBnDTXgF+lS4S9WSK+GUFIl/FBK5MDQFG1hWliEg3bgWH
         Sidrcc8IhjVd6dhyjBtXn8/j3ijCJm5wy80V1D09j/UFSJIR0mopNtT9AgS+yndKKaw6
         outw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=svtvmckgsYFdMY08rsKItgup1eFeNNMS18fXK1hp66E=;
        b=oK9H+/Ib1Ol+K3uXpcxFUM8IJhiydYICae6c3huDJgDOCBjc/pebzyAlXouZQi3Uxz
         UM1wC4lzTISUFo75F1xoxaouFPdP8BbH0gFPAzKDgzxCYUo5FBV4cGoiZsWQ+lxOld49
         BxShSpZoSdi7HexdLTiN7HcpjIYZYYl5guZCM7AUTL+ZfRKoX1HalLHUrMM5S4Vv4Uab
         8bmnvGz5Z+JITWv5SnycCbRCyBKA89x2ZLmGpHH/NogbzcBxS9QN9KYgn1LdO6ZEh2YF
         u4AakvlzNRgFuJTDXj+sVDx/PD3sibL2g5+2KfU4smHYeElk7DH3YMU04tctiB/vDbbf
         ZeJg==
X-Gm-Message-State: ACgBeo1mUr7haKSi8Hl9KJtKFxSNgC11wYMbZM66/aSgNfoN8jx7qDan
        tLENh4PCvZ9Vcsgye2TxVPI4pQ==
X-Google-Smtp-Source: AA6agR5MdYOsAHV0xTW6UI5WZTq5FY2Oa2CfhbJX4nzqV7j3wNaZCke1O+5Fm1Xam32l3i3sy3WrsQ==
X-Received: by 2002:a05:651c:1587:b0:261:b558:b6ab with SMTP id h7-20020a05651c158700b00261b558b6abmr7936511ljq.204.1663006270513;
        Mon, 12 Sep 2022 11:11:10 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id a18-20020a2eb172000000b0025ebaef9570sm1225602ljm.40.2022.09.12.11.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 11:11:10 -0700 (PDT)
Message-ID: <75540907-6981-5798-efe3-04fe0466da31@linaro.org>
Date:   Mon, 12 Sep 2022 21:11:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5/7] drm/msm/dp: fix bridge lifetime
Content-Language: en-GB
To:     Johan Hovold <johan+linaro@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@gmail.com>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220912154046.12900-1-johan+linaro@kernel.org>
 <20220912154046.12900-6-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220912154046.12900-6-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/09/2022 18:40, Johan Hovold wrote:
> Device-managed resources allocated post component bind must be tied to
> the lifetime of the aggregate DRM device or they will not necessarily be
> released when binding of the aggregate device is deferred.
> 
> This can lead resource leaks or failure to bind the aggregate device
> when binding is later retried and a second attempt to allocate the
> resources is made.
> 
> For the DP bridges, previously allocated bridges will leak on probe
> deferral.
> 
> Fix this by amending the DP parser interface and tying the lifetime of
> the bridge device to the DRM device rather than DP platform device.
> 
> Fixes: c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
> Cc: stable@vger.kernel.org      # 5.19
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Seems logical enough.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>   drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
>   drivers/gpu/drm/msm/dp/dp_parser.c  | 6 +++---
>   drivers/gpu/drm/msm/dp/dp_parser.h  | 5 +++--
>   3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
> index e1aa6355bbf6..393af1ea9ed8 100644
> --- a/drivers/gpu/drm/msm/dp/dp_display.c
> +++ b/drivers/gpu/drm/msm/dp/dp_display.c
> @@ -1576,7 +1576,7 @@ static int dp_display_get_next_bridge(struct msm_dp *dp)
>   	 * For DisplayPort interfaces external bridges are optional, so
>   	 * silently ignore an error if one is not present (-ENODEV).
>   	 */
> -	rc = dp_parser_find_next_bridge(dp_priv->parser);
> +	rc = devm_dp_parser_find_next_bridge(dp->drm_dev->dev, dp_priv->parser);
>   	if (!dp->is_edp && rc == -ENODEV)
>   		return 0;
>   
> diff --git a/drivers/gpu/drm/msm/dp/dp_parser.c b/drivers/gpu/drm/msm/dp/dp_parser.c
> index dd732215d55b..dcbe893d66d7 100644
> --- a/drivers/gpu/drm/msm/dp/dp_parser.c
> +++ b/drivers/gpu/drm/msm/dp/dp_parser.c
> @@ -240,12 +240,12 @@ static int dp_parser_clock(struct dp_parser *parser)
>   	return 0;
>   }
>   
> -int dp_parser_find_next_bridge(struct dp_parser *parser)
> +int devm_dp_parser_find_next_bridge(struct device *dev, struct dp_parser *parser)
>   {
> -	struct device *dev = &parser->pdev->dev;
> +	struct platform_device *pdev = parser->pdev;
>   	struct drm_bridge *bridge;
>   
> -	bridge = devm_drm_of_get_bridge(dev, dev->of_node, 1, 0);
> +	bridge = devm_drm_of_get_bridge(dev, pdev->dev.of_node, 1, 0);
>   	if (IS_ERR(bridge))
>   		return PTR_ERR(bridge);
>   
> diff --git a/drivers/gpu/drm/msm/dp/dp_parser.h b/drivers/gpu/drm/msm/dp/dp_parser.h
> index 866c1a82bf1a..d30ab773db46 100644
> --- a/drivers/gpu/drm/msm/dp/dp_parser.h
> +++ b/drivers/gpu/drm/msm/dp/dp_parser.h
> @@ -138,8 +138,9 @@ struct dp_parser {
>   struct dp_parser *dp_parser_get(struct platform_device *pdev);
>   
>   /**
> - * dp_parser_find_next_bridge() - find an additional bridge to DP
> + * devm_dp_parser_find_next_bridge() - find an additional bridge to DP
>    *
> + * @dev: device to tie bridge lifetime to
>    * @parser: dp_parser data from client
>    *
>    * This function is used to find any additional bridge attached to
> @@ -147,6 +148,6 @@ struct dp_parser *dp_parser_get(struct platform_device *pdev);
>    *
>    * Return: 0 if able to get the bridge, otherwise negative errno for failure.
>    */
> -int dp_parser_find_next_bridge(struct dp_parser *parser);
> +int devm_dp_parser_find_next_bridge(struct device *dev, struct dp_parser *parser);
>   
>   #endif

-- 
With best wishes
Dmitry

