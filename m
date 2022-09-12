Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C335B631F
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 23:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiILV4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 17:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiILV4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 17:56:08 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620E44D241
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:56:06 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1278a61bd57so27050908fac.7
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=cLLzL9vbrWOmXEMD5t4FcHNyuufYLeZfdASc1WjWjII=;
        b=Aajun28E2jbV3q6QZZCZGGP6KuCziXvmeYsaOeiaf7yhSJdtBHSpKt4Z0FmZaF2gD4
         6yOkUwVyvjt9Htp5jPmm9YbdsQPbPAW8OE8Q8VCL1S/Roh++pQvj4wStZQ+PuN8TaAoU
         2X1W+zltFgSFvaxDqn4JtYNPI+ICtl8k15k8IU8+OGzPS7gHgnE8i6UrxFXHwdNO6vxA
         16XK4CbbPFQO2aWWB10YysxHdVIphwVHa1M2Bk2ZaR8qwPmhTqcv/+vDII6CdJtqPey3
         cF98dDIstCia36oYbP1Ruo9AouGtrlvs1VL+W4h3KWWEN2IpNdOOUcnVcwugQSwT6x1/
         QidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=cLLzL9vbrWOmXEMD5t4FcHNyuufYLeZfdASc1WjWjII=;
        b=G3QQcAGVdwYxfOAI/C+29yy3fcRol2QXoBMdCD+TaDyWLT8XKLxQYEdAba5W+J1fkJ
         HbMJxC/+8S3vtS4LzN6+w0IABGoyoZ9J8r/HWqOjFgfbQX8sTJF3WR16mrhDZnBo8dad
         dXCd8Kb/ynoXn/ub/6WyDZoa2L2WZY7I6bgY7qkqOGLtj6rripK3Uf7Uka2cSRJQVHJy
         FXAf42QO0A3ww3fiGxIiiT4Y+MeXwEfTnCI7kYRRV4WE7iyANU9mKDATCLnbqrWpC/dB
         /ccyPR4Lf6WCao2KsCxAv/ZjVfi0YbjbZC+tMoSt9to24S7nA4HWzDRea6MnAIE8USUl
         K5Vg==
X-Gm-Message-State: ACgBeo1wwxIIQgYFBLdL6mqkeS8PWgtJDcY9Oj0Zr1p/D6DeW2ExApJk
        5nsKCm0H+MF7wtSdgAN0pKV2nw==
X-Google-Smtp-Source: AA6agR7rNeCdm2/Yxkrqxs/SGMhUcYmEcNl/SkoT6344JEdtaxUrI+SevtXMnWUIAgrc5WE9MhE2sA==
X-Received: by 2002:a05:6808:148e:b0:343:77fc:b7d2 with SMTP id e14-20020a056808148e00b0034377fcb7d2mr185362oiw.128.1663019765587;
        Mon, 12 Sep 2022 14:56:05 -0700 (PDT)
Received: from [192.168.11.16] (cpe-173-173-107-246.satx.res.rr.com. [173.173.107.246])
        by smtp.gmail.com with ESMTPSA id k6-20020a4ad106000000b00448a3ecdc9dsm4643175oor.22.2022.09.12.14.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 14:56:05 -0700 (PDT)
Message-ID: <69526798-93df-a4f9-c385-c9bf490cc709@kali.org>
Date:   Mon, 12 Sep 2022 16:55:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 4/7] drm/msm/dp: fix aux-bus EP lifetime
Content-Language: en-US
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
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
 <20220912154046.12900-5-johan+linaro@kernel.org>
 <e60f0053-3801-bf33-5841-69f16215fa00@linaro.org>
From:   Steev Klimaszewski <steev@kali.org>
In-Reply-To: <e60f0053-3801-bf33-5841-69f16215fa00@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/12/22 1:10 PM, Dmitry Baryshkov wrote:
> On 12/09/2022 18:40, Johan Hovold wrote:
>> Device-managed resources allocated post component bind must be tied to
>> the lifetime of the aggregate DRM device or they will not necessarily be
>> released when binding of the aggregate device is deferred.
>>
>> This can lead resource leaks or failure to bind the aggregate device
>> when binding is later retried and a second attempt to allocate the
>> resources is made.
>>
>> For the DP aux-bus, an attempt to populate the bus a second time will
>> simply fail ("DP AUX EP device already populated").
>>
>> Fix this by amending the DP aux interface and tying the lifetime of the
>> EP device to the DRM device rather than DP controller platform device.
>
> Doug, could you please take a look?
>
> For me this is another reminder/pressure point that we should populate 
> the AUX BUS from the probe(), before binding the components together.
>
>>
>> Fixes: c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
>> Cc: stable@vger.kernel.org      # 5.19
>> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> ---
>>   drivers/gpu/drm/bridge/parade-ps8640.c   | 2 +-
>>   drivers/gpu/drm/display/drm_dp_aux_bus.c | 5 +++--
>>   drivers/gpu/drm/msm/dp/dp_display.c      | 3 ++-
>>   include/drm/display/drm_dp_aux_bus.h     | 6 +++---
>>   4 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/bridge/parade-ps8640.c 
>> b/drivers/gpu/drm/bridge/parade-ps8640.c
>> index d7483c13c569..6127979370cb 100644
>> --- a/drivers/gpu/drm/bridge/parade-ps8640.c
>> +++ b/drivers/gpu/drm/bridge/parade-ps8640.c
>> @@ -719,7 +719,7 @@ static int ps8640_probe(struct i2c_client *client)
>>       if (ret)
>>           return ret;
>>   -    ret = devm_of_dp_aux_populate_bus(&ps_bridge->aux, 
>> ps8640_bridge_link_panel);
>> +    ret = devm_of_dp_aux_populate_bus(dev, &ps_bridge->aux, 
>> ps8640_bridge_link_panel);
>>         /*
>>        * If devm_of_dp_aux_populate_bus() returns -ENODEV then it's 
>> up to
>> diff --git a/drivers/gpu/drm/display/drm_dp_aux_bus.c 
>> b/drivers/gpu/drm/display/drm_dp_aux_bus.c
>> index f5741b45ca07..2706f2cf82f7 100644
>> --- a/drivers/gpu/drm/display/drm_dp_aux_bus.c
>> +++ b/drivers/gpu/drm/display/drm_dp_aux_bus.c
>> @@ -322,6 +322,7 @@ static void of_dp_aux_depopulate_bus_void(void 
>> *data)
>>     /**
>>    * devm_of_dp_aux_populate_bus() - devm wrapper for 
>> of_dp_aux_populate_bus()
>> + * @dev: Device to tie the lifetime of the EP devices to
>>    * @aux: The AUX channel whose device we want to populate
>>    * @done_probing: Callback functions to call after EP device 
>> finishes probing.
>>    *                Will not be called if there are no EP devices and 
>> this
>> @@ -333,7 +334,7 @@ static void of_dp_aux_depopulate_bus_void(void 
>> *data)
>>    *         no children. The done_probing() function won't be called 
>> in that
>>    *         case.
>>    */
>> -int devm_of_dp_aux_populate_bus(struct drm_dp_aux *aux,
>> +int devm_of_dp_aux_populate_bus(struct device *dev, struct 
>> drm_dp_aux *aux,
>>                   int (*done_probing)(struct drm_dp_aux *aux))
>>   {
>>       int ret;
>> @@ -342,7 +343,7 @@ int devm_of_dp_aux_populate_bus(struct drm_dp_aux 
>> *aux,
>>       if (ret)
>>           return ret;
>>   -    return devm_add_action_or_reset(aux->dev,
>> +    return devm_add_action_or_reset(dev,
>>                       of_dp_aux_depopulate_bus_void, aux);
>>   }
>>   EXPORT_SYMBOL_GPL(devm_of_dp_aux_populate_bus);
>> diff --git a/drivers/gpu/drm/msm/dp/dp_display.c 
>> b/drivers/gpu/drm/msm/dp/dp_display.c
>> index ba557328710a..e1aa6355bbf6 100644
>> --- a/drivers/gpu/drm/msm/dp/dp_display.c
>> +++ b/drivers/gpu/drm/msm/dp/dp_display.c
>> @@ -1559,7 +1559,8 @@ static int dp_display_get_next_bridge(struct 
>> msm_dp *dp)
>>            * panel driver is probed asynchronously but is the best we
>>            * can do without a bigger driver reorganization.
>>            */
>> -        rc = devm_of_dp_aux_populate_ep_devices(dp_priv->aux);
>> +        rc = devm_of_dp_aux_populate_ep_devices(dp->drm_dev->dev,
>> +                            dp_priv->aux);
>>           of_node_put(aux_bus);
>>           if (rc)
>>               goto error;
>> diff --git a/include/drm/display/drm_dp_aux_bus.h 
>> b/include/drm/display/drm_dp_aux_bus.h
>> index 8a0a486383c5..a4063aa7fc40 100644
>> --- a/include/drm/display/drm_dp_aux_bus.h
>> +++ b/include/drm/display/drm_dp_aux_bus.h
>> @@ -47,7 +47,7 @@ static inline struct dp_aux_ep_driver 
>> *to_dp_aux_ep_drv(struct device_driver *dr
>>   int of_dp_aux_populate_bus(struct drm_dp_aux *aux,
>>                  int (*done_probing)(struct drm_dp_aux *aux));
>>   void of_dp_aux_depopulate_bus(struct drm_dp_aux *aux);
>> -int devm_of_dp_aux_populate_bus(struct drm_dp_aux *aux,
>> +int devm_of_dp_aux_populate_bus(struct device *dev, struct 
>> drm_dp_aux *aux,
>>                   int (*done_probing)(struct drm_dp_aux *aux));
>>     /* Deprecated versions of the above functions. To be removed when 
>> no callers. */
>> @@ -61,11 +61,11 @@ static inline int 
>> of_dp_aux_populate_ep_devices(struct drm_dp_aux *aux)
>>       return (ret != -ENODEV) ? ret : 0;
>>   }
>>   -static inline int devm_of_dp_aux_populate_ep_devices(struct 
>> drm_dp_aux *aux)
>> +static inline int devm_of_dp_aux_populate_ep_devices(struct device 
>> *dev, struct drm_dp_aux *aux)
>>   {
>>       int ret;
>>   -    ret = devm_of_dp_aux_populate_bus(aux, NULL);
>> +    ret = devm_of_dp_aux_populate_bus(dev, aux, NULL);
>>         /* New API returns -ENODEV for no child case; adapt to old 
>> assumption */
>>       return (ret != -ENODEV) ? ret : 0;
>
This breaks builds which have ti-sn65dsi86 included:

drivers/gpu/drm/bridge/ti-sn65dsi86.c:628:50: error: passing argument 1 
of 'devm_of_dp_aux_populate_ep_devices' from incompatible argument type.

As well,

drivers/gpu/drm/bridge/ti-sn65dsi86.c:628:15: error: too few arguments 
to function 'devm_of_dp_aux_populate_ep_devices'


--steev


