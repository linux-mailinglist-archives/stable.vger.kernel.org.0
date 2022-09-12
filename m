Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED4A5B5FAF
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 19:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiILR7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 13:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiILR7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 13:59:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FC92717C
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 10:59:06 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id r12so9945482ljg.10
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 10:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=gY3yxu1ESuLTH+rFoedO2iickM2TO6Q0hqHsiCe2Ku4=;
        b=wYpcprvARNdYcXgSJt3ZWMMwP1MsNWeiJhjE1d1nRwLzuWDJzFFJ9P5TPtcaRAsgvi
         8rBqiBy05mg1wceEso9dDYtdMo1v+zDsFdbISALDSwEv+z8A6pcfkeQn+pbUAsEOlveJ
         F1YxtO90PtnKuD02p2YH/uI7JJhkAxR5DBSXQ3aFOrGZ3myQO2Gh3ShInwLxQFoJnDkW
         SBmbgKTzmBLaCv7uwIge4yGuMx8yq2qYiOVPyNkT8QoOWUK+BKtZeR6zerNogFU66zRz
         9H91hFfyr4WABE3FE7mmqbv4/7S/Qw7u7p926bvMROK4uuLpPcjO/xMF0eCSoplyHOME
         8AMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=gY3yxu1ESuLTH+rFoedO2iickM2TO6Q0hqHsiCe2Ku4=;
        b=nPM0Dti5seRl0zNPOL9rOMOD666+dx8wcDox9tj9PSbGBmQoF2Try5mgGizV+5FGFq
         3VuwFWOcNCM5nkteRjRS8DDfJ+cP69FsCEyJ8n/rgRRi6NsKgqTK62Na9V88NJyEel9I
         e2CP2f67OV/JNfGXnF1CuvMKWdb45XoSNZn8eJsHy4e29+QzNaGqAVrsSNsxIwCa0gFI
         IXyxSUm8+rbOz8SeIbP6XrIMsTbtXzogUJXbRXXnQrdIDAFu4X1BR9SA/9d7dHg7WwmQ
         +w6/niMQkqvCD1VVRRtMn5+qWkaWP1y/pJA1nsU/gCejvEZ5sYReZVnMtXy9QSJx6OZw
         jMIA==
X-Gm-Message-State: ACgBeo36kIKb7udfmo1M62zUrEzwtQ53coO9mRcf3j0QkDVEY/RpOXBr
        ZSaUkwqidO74xl2etdrxHIl0EA==
X-Google-Smtp-Source: AA6agR4VksOY8OzBgoRlszD2ydAjq5P8zmjOf9DeDDMq1Ex1NRMA9d8g9FQjBRLjWR/w5X/3ahn7Dg==
X-Received: by 2002:a2e:9681:0:b0:261:c515:2b13 with SMTP id q1-20020a2e9681000000b00261c5152b13mr8229151lji.210.1663005544796;
        Mon, 12 Sep 2022 10:59:04 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id b2-20020a05651c032200b002618e5c2664sm1176437ljp.103.2022.09.12.10.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 10:59:04 -0700 (PDT)
Message-ID: <5aac31ea-fdf0-268e-5c6a-bd89b3dad79a@linaro.org>
Date:   Mon, 12 Sep 2022 20:59:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 6/7] drm/msm/hdmi: fix IRQ lifetime
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
 <20220912154046.12900-7-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220912154046.12900-7-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
> This is specifically true for the HDMI IRQ, which will otherwise remain
> requested so that the next bind attempt fails when requesting the IRQ a
> second time.
> 
> Fix this by tying the device-managed lifetime of the HDMI IRQ to the DRM
> device so that it is released when bind fails.
> 
> Fixes: 067fef372c73 ("drm/msm/hdmi: refactor bind/init")
> Cc: stable@vger.kernel.org      # 3.19
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>   drivers/gpu/drm/msm/hdmi/hdmi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
> index a0ed6aa8e4e1..f28fb21e3891 100644
> --- a/drivers/gpu/drm/msm/hdmi/hdmi.c
> +++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
> @@ -344,7 +344,7 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
>   		goto fail;
>   	}
>   
> -	ret = devm_request_irq(&pdev->dev, hdmi->irq,
> +	ret = devm_request_irq(dev->dev, hdmi->irq,
>   			msm_hdmi_irq, IRQF_TRIGGER_HIGH,
>   			"hdmi_isr", hdmi);
>   	if (ret < 0) {

-- 
With best wishes
Dmitry

