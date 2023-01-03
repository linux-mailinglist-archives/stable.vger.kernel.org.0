Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0215D65C006
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 13:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjACMlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 07:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjACMlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 07:41:08 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE349DF6A
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 04:41:03 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id bi26-20020a05600c3d9a00b003d3404a89faso16324913wmb.1
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 04:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1gkN1S5ZlvpEeBogO6vpEZy9U0i82QGUm+UbrTpiEso=;
        b=E3K3wLQAZdncIqzqu2Q6Bd7JKdI4Rq6ZX1HiGGEj2M+BQDEGbUHwucomhqO4uZgAOD
         Enqs8wqSbmv0BnVfWnfZUa0Z0TpWoKe4gZTSOv666zhzqtwzFzWVj88cUO/aANoaGHiL
         JS+PW9W4Ql6HYCij65Wvofyolx0dHO5n+XYCd8yP8i8XEaJsO2N0lsaq1+hSB4GXLkqm
         7f7uzOLgC/0y55PxKdaIh6ikINaZYWDO7WnPEgqKH903WesXJtV2E9n+2pWfEcBqNQ7K
         SmREjXv2EbolfNtTebVuh1CArMiBIbCLedw3I4Vu0oqrnEaB3MEQOwDpoVnYTiEaMvlA
         iHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1gkN1S5ZlvpEeBogO6vpEZy9U0i82QGUm+UbrTpiEso=;
        b=GhfVR/KsJU5j6kCKovWrKEgod6HzoWwri328QMdYyLMYemcFT9kfKBYEPEReiK2smw
         NqVT+mZULxcNGGVwf6wpM8GgAiioiHta3T6O6f9eGaHlEguO5H3rQzToTp2TdaZ7LKvh
         nj0zmxH4pDShmcy3pDfZ5sD99KsmGXpko9+KACLPAdjSJDer+ablzgz4KaO3ADkH7C4K
         Ga54Zq0HZghqUAMh7dkwrQCVh6rfMkT6ncJEJiA/owe64b+vygA0PC2YxzoH43LRKzjv
         ByZRv0+JzH1ToCNuWbgBme0aJGYdpUcQArHagNSEE0JCWFOa8ZyWbHSQbFRJnlY2VZZq
         NUZw==
X-Gm-Message-State: AFqh2koBFVAGOAn1OvgAhM4OSuzg6sGqGm2aXGXfgpQTR9Vtgg0yE37r
        jDBgdd2fQz00b4J4mEUYm4QeiRxDo7y3aNpKoMk=
X-Google-Smtp-Source: AMrXdXtd/n4T7oT7EJwzPIPADbEUarUVmVBN9kaC29mimSQ3fmwKsrjWYJugvfguwY0xNRU+WSG49w==
X-Received: by 2002:a05:600c:798:b0:3d3:5737:3b0f with SMTP id z24-20020a05600c079800b003d357373b0fmr38639588wmo.36.1672749662438;
        Tue, 03 Jan 2023 04:41:02 -0800 (PST)
Received: from [192.168.1.195] ([5.133.47.210])
        by smtp.googlemail.com with ESMTPSA id bi14-20020a05600c3d8e00b003d9ad6783b1sm11844502wmb.6.2023.01.03.04.41.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 04:41:01 -0800 (PST)
Message-ID: <ff77ba1c-8b67-4697-d713-0392d3b1d77a@linaro.org>
Date:   Tue, 3 Jan 2023 12:41:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] nvmem: core: Fix race in nvmem_register()
Content-Language: en-US
To:     Hector Martin <marcan@marcan.st>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Curtin <ecurtin@redhat.com>
References: <20230103114427.1825-1-marcan@marcan.st>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20230103114427.1825-1-marcan@marcan.st>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 03/01/2023 11:44, Hector Martin wrote:
> nvmem_register() currently registers the device before adding the nvmem
> cells, which creates a race window where consumers may find the nvmem
> device (and not get PROBE_DEFERred), but then fail to find the cells and
> error out.
> 
> Move device registration to the end of nvmem_register(), to close the
> race.
> 
> Observed when the stars line up on Apple Silicon machines with the (not
> yet upstream, but trivial) spmi nvmem driver and the macsmc-rtc client:
> 
> [    0.487375] macsmc-rtc macsmc-rtc: error -ENOENT: Failed to get rtc_offset NVMEM cell
> 
> Fixes: eace75cfdcf7 ("nvmem: Add a simple NVMEM framework for nvmem providers")
> Cc: stable@vger.kernel.org
> Reviewed-by: Eric Curtin <ecurtin@redhat.com>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---

What has changed since v1?


>   drivers/nvmem/core.c | 32 +++++++++++++++++---------------
>   1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> index 321d7d63e068..606f428d6292 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> @@ -822,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>   		break;
>   	}
> 
> -	if (rval) {
> -		ida_free(&nvmem_ida, nvmem->id);
> -		kfree(nvmem);
> -		return ERR_PTR(rval);
> -	}
> +	if (rval)
> +		goto err_gpiod_put;

Why was gpiod changes added to this patch, that should be a separate 
patch/discussion, as this is not relevant to the issue that you are 
reporting.

> 
>   	nvmem->read_only = device_property_present(config->dev, "read-only") ||
>   			   config->read_only || !nvmem->reg_write;
> @@ -837,20 +834,16 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
> 
>   	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
> 
> -	rval = device_register(&nvmem->dev);
> -	if (rval)
> -		goto err_put_device;
> -
>   	if (nvmem->nkeepout) {
>   		rval = nvmem_validate_keepouts(nvmem);
>   		if (rval)
> -			goto err_device_del;
> +			goto err_gpiod_put;
>   	}
> 
>   	if (config->compat) {
>   		rval = nvmem_sysfs_setup_compat(nvmem, config);
>   		if (rval)
> -			goto err_device_del;
> +			goto err_gpiod_put;
>   	}
> 
>   	if (config->cells) {
> @@ -867,6 +860,15 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>   	if (rval)
>   		goto err_remove_cells;
> 
> +	rval = device_register(&nvmem->dev);
> +	if (rval) {
> +		nvmem_device_remove_all_cells(nvmem);
> +		if (config->compat)
> +			nvmem_sysfs_remove_compat(nvmem, config);
> +		put_device(&nvmem->dev);
> +		return ERR_PTR(rval);
> +	}
> +
>   	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_ADD, nvmem);
> 
>   	return nvmem;
> @@ -876,10 +878,10 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>   err_teardown_compat:
>   	if (config->compat)
>   		nvmem_sysfs_remove_compat(nvmem, config);
> -err_device_del:
> -	device_del(&nvmem->dev);
> -err_put_device:
> -	put_device(&nvmem->dev);
> +err_gpiod_put:
> +	gpiod_put(nvmem->wp_gpio);
> +	ida_free(&nvmem_ida, nvmem->id);
> +	kfree(nvmem);
> 
>   	return ERR_PTR(rval);
>   }
> --
> 2.35.1
> 
