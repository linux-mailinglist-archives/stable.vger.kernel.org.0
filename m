Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672EC6C350C
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCUPGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 11:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjCUPGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 11:06:31 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8174ECDC
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 08:06:29 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id e21so3245854ljn.7
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 08:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679411187;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FiHy9zm4LtANP3nP8u7ZmP1cRrMSZ1F7M7tdsLnmL5c=;
        b=WVxB8OnWOd82MsZge6qyZe78WYMa2VOUhdSVwMf3MO1ts2efmgCXrK7E+I183v5A2n
         wafE6+D1bTvLkU05rFTK8YrVEGqojO5lVkhDjzhuQoMa2yuJehT4diwB7sqHX97KFmK7
         Wy8n+S49oALnfBvUtGOjNpT4gzttfgzwZyimCUmun85ePPSwKwdXXSz2MqZjk3dTamwy
         Rb2d3JESU3vv2o9p/lMpvyVXGq6JCa3N6vdYnNjMVngtRu3NPx4rlEudBTU3CLp5S/IG
         4myTBrJo6qPEpVhoYmopspUmjFuBdAiCQWFUoEzzfuDE4hVuKaPlVh4krCKX9R/IRLTP
         y8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679411187;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FiHy9zm4LtANP3nP8u7ZmP1cRrMSZ1F7M7tdsLnmL5c=;
        b=Q6eZSPzxYSL1j3ufTxpWwloaxAvAV1REkMfmujAQahlX5YvS+31o0LEKtIki+yQNY7
         WwtIHf7mdIikRQ7DXklEbrtueyUcquVX6C+pdl0XUMsIIWr2aO1BJlSw4bcsdk+IC3lA
         AY8AuuLU8xWbdguJcLW3iqYQIogUjVxnKfXOIe4JkqO+TuPchA0UDdZa1r0j4W8QgVgM
         +TsIwzhIjO9PaI4Uktd24DXzruxDAhg0fYsGdVAxXqSCDz4hFddgfrYmXK9ef36J2vkW
         PbirCn1aiQisreF8RTfFni6cpeX2NQRoBK0xRf2qBbghCGyEhFN6VsfJ1JRxx0stgWzT
         EGpw==
X-Gm-Message-State: AO0yUKXlry/7z4DBQh9aVmChXCJpfxJ3NWWiTUrP04Md1Z+5BodAtIKk
        oO2dh+ZgD+NO6NjuGRBUOG2KvA==
X-Google-Smtp-Source: AK7set+e5ls0OWebGd/IN1tP2tPlzD51sw/ZlRWK0EpUUVd/5kDr0H3DXsUwYYPYx8qvcnam7pB+jw==
X-Received: by 2002:a05:651c:144:b0:298:acea:d261 with SMTP id c4-20020a05651c014400b00298acead261mr1128029ljd.21.1679411187677;
        Tue, 21 Mar 2023 08:06:27 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id y22-20020a2e3216000000b0029e84187ce2sm725080ljy.139.2023.03.21.08.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 08:06:27 -0700 (PDT)
Message-ID: <c0ac71a0-4407-de19-ef7a-05004c3e0a2b@linaro.org>
Date:   Tue, 21 Mar 2023 17:06:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 03/10] drm/msm: fix NULL-deref on snapshot tear down
Content-Language: en-GB
To:     Johan Hovold <johan+linaro@kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc:     Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230306100722.28485-1-johan+linaro@kernel.org>
 <20230306100722.28485-4-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230306100722.28485-4-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/03/2023 12:07, Johan Hovold wrote:
> In case of early initialisation errors and on platforms that do not use
> the DPU controller, the deinitilisation code can be called with the kms
> pointer set to NULL.
> 
> Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
> Cc: stable@vger.kernel.org      # 5.14
> Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>   drivers/gpu/drm/msm/msm_drv.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
> index 9ded384acba4..17a59d73fe01 100644
> --- a/drivers/gpu/drm/msm/msm_drv.c
> +++ b/drivers/gpu/drm/msm/msm_drv.c
> @@ -242,7 +242,8 @@ static int msm_drm_uninit(struct device *dev)
>   		msm_fbdev_free(ddev);
>   #endif
>   
> -	msm_disp_snapshot_destroy(ddev);
> +	if (kms)
> +		msm_disp_snapshot_destroy(ddev);
>   
>   	drm_mode_config_cleanup(ddev);
>   

-- 
With best wishes
Dmitry

