Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1D55E6E83
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 23:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiIVViq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 17:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiIVVip (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 17:38:45 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DAA106515
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 14:38:43 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id n10so17500817wrw.12
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 14:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=rE4qkoQWFMK80vrDxYXRfq6e/ZoyI2F/bN7ZyOFnWvk=;
        b=AjEKNitGnBVVvUIhiBOOIz384XMAwt2GfXvy5+08/YqD4eDCPYNZVPX2NeU6XqysoS
         IkNDeCWYZTXuA0ePbraD+WK6JEvEptSZw0mDM/KZhl4i7ZEEebKGysFOUKn3iQYybmIF
         0mGzx7X1bTpfnm+s4oSJ51J8jLHhxCtoZCM3bcyLWR5g2kAa84ndQQBtj7F44biRhEO0
         vkpvfaKbpmG9W8CJ722xEeVjpiHSEHoJwKmkPficS5NTXNjrFXu3ugYFcmDHX6Yh9mHV
         PVq64ZARu8HlsBseE6KOtz2ASQGN9Yy7OpOWdLsLOhB/HgnYmZWCOhJZsqp0JXaoYpq+
         Jtww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rE4qkoQWFMK80vrDxYXRfq6e/ZoyI2F/bN7ZyOFnWvk=;
        b=yhSXC49kJrl3ObUrulIj1Jm9GSfm+4gHixpE4DmdrV2yLLWzEWLorA000vexSWQWe1
         hb01hLESIBIa8D68GKCCV30wgKMZ1S22I2Y6cfqYyKm1zqeyp3jZZsNa08+PIbZsS2vA
         KGZpZompK15jhC0AfyQoTYm0BGKBFy3WQd82qfiNsV0EZiwKRe9fRJMJkpjg4D0F8vQ6
         ZeA7uL7xIb+1pEXmNF30nc+XAnfivMtyOZC5qIsC8wbwP9/yT8S8LG9hvdfkVpzHiIml
         NK3xnOIyaVed+Lea5wi5ihheNBibuDVAQnx/4tOLlDJSu2LDqOF1oiwLoNZZqyJuXNPd
         uKmQ==
X-Gm-Message-State: ACrzQf0wv97jCH6mDgcpKqDyxGo6iXSe6H6C50FQ4YW6DAMHdF8L93wU
        M/fpiIJbvPcHF0WzhgAal88osg==
X-Google-Smtp-Source: AMsMyM5kgUiRLL5Xx+qtmKQlyMn1l0m6sz2JT4ou1vq2rC1rwLKpsQC6l0ZaDdfHYwKvvtU4qDXTTA==
X-Received: by 2002:adf:f2c9:0:b0:228:63f6:73c2 with SMTP id d9-20020adff2c9000000b0022863f673c2mr3282652wrp.554.1663882722308;
        Thu, 22 Sep 2022 14:38:42 -0700 (PDT)
Received: from [192.168.86.238] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id n42-20020a05600c3baa00b003a319b67f64sm10953764wms.0.2022.09.22.14.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 14:38:41 -0700 (PDT)
Message-ID: <15b6bf59-9a76-8a97-cb92-701277a2f80d@linaro.org>
Date:   Thu, 22 Sep 2022 22:38:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Vinod Koul <vkoul@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Krzysztof

On 21/09/2022 15:53, Krzysztof Kozlowski wrote:
> Slimbus streams are first prepared and then enabled, so the cleanup path
> should reverse it.  The unprepare sets stream->num_ports to 0 and frees
> the stream->ports.  Calling disable after unprepare was not really
> effective (channels was not deactivated) and could lead to further
> issues due to making transfers on unprepared stream.
> 
> Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
Nice catch,

Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

>   sound/soc/codecs/wcd9335.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
> index 06c6adbe5920..d2548fdf9ae5 100644
> --- a/sound/soc/codecs/wcd9335.c
> +++ b/sound/soc/codecs/wcd9335.c
> @@ -1972,8 +1972,8 @@ static int wcd9335_trigger(struct snd_pcm_substream *substream, int cmd,
>   	case SNDRV_PCM_TRIGGER_STOP:
>   	case SNDRV_PCM_TRIGGER_SUSPEND:
>   	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> -		slim_stream_unprepare(dai_data->sruntime);
>   		slim_stream_disable(dai_data->sruntime);
> +		slim_stream_unprepare(dai_data->sruntime);
>   		break;
>   	default:
>   		break;
