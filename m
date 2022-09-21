Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F015C01D1
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiIUPk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiIUPkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:40:02 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CA29A69A
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:38:08 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id k10so9879605lfm.4
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=4fyDdd6hcvCfFZT9i19QE30bk4gB/G2w/iEESMxgbKA=;
        b=svch8Vd6r5prc+EGUm5IRQ9iK6HudwOgs+E0/t3t6ZepH24yrJ3rb2q47vhpC/hSa5
         eePSlz7Zb9Lw/5kBu1F+jrYiKW7u52M1oCGfMoxtxNcI7w52YP4ggol4vHs61087fQPn
         zkxiUfstNdQLdKfuWntvkdn1pHs/VU98DT/nkc+fv9e+Ftq30wa8TJirz10+nLEQ2ViN
         klJweBcRNlRpLGskSeJfL+qoawD1pAP/J3TUiQ+9G8AWEAWBch5rrkVYmw3a4n8m7z8D
         Lw/hWf8MxPimo84973uQKVzW4JGaWScCmK/FaP7kjWGNqXvuYj0rKOpgn5Uy4E/17WQD
         3YnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4fyDdd6hcvCfFZT9i19QE30bk4gB/G2w/iEESMxgbKA=;
        b=sjHqWyQQ64Xo1XF/K4ec3SzSsKLzU3tQW9xFBoS8n5p2XF8e7ZW4UdvZNuk3C10eOP
         e4dLgQPBG0J/aqwXrQehz36vptDD+t1YFB/WQ1b+d3x0rAdT+dq46FSQIre6P5cC1BHn
         BIA1RHrw5n/JnSHXUHlJeYBrq+QM/kTH/Ludd9yGQz5lQB1r/XlWMeokVZiluP6ER7s3
         2V9iXfVOtbx2I5CZCShT6qUnZX4lpcI6wEbM0yjDcNVIfoGaF7su07daR384FoBaBtaF
         4Y5TIjKxcKbgK1gDn5bpMr8korfCmS13HHGsVggbeiTZv4Fa6EqxLzRLBHFssBHeKysS
         1ETA==
X-Gm-Message-State: ACrzQf1EC1vMrnmAILqt0KacjytMcU6iRgX6bjh4Twf5GO7FhJ8eerEC
        aYQ/AhQsQd9j44ekduDoyFvDu3oh1w7Vpg==
X-Google-Smtp-Source: AMsMyM4kgLEzuRCbwB9NE7eQli7CQSYE21f8z+xxXzyue6Db7mHLo03HzBf6cA9GZU7GrFsDfz3CmA==
X-Received: by 2002:a2e:9d94:0:b0:26b:de12:7c9 with SMTP id c20-20020a2e9d94000000b0026bde1207c9mr9055575ljj.244.1663774098321;
        Wed, 21 Sep 2022 08:28:18 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id n21-20020a05651203f500b00494a8fecacesm474505lfq.192.2022.09.21.08.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 08:28:17 -0700 (PDT)
Message-ID: <df350235-3c50-c7ac-eb62-5fbc501fed0a@linaro.org>
Date:   Wed, 21 Sep 2022 17:28:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
Content-Language: en-US
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Vinod Koul <vkoul@kernel.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
 <20916c9d-3598-7c40-ee77-1148c3d2e4b1@linux.intel.com>
 <af3bd3f4-dcd9-8f6c-6323-de1b53301225@linaro.org>
 <9a210b04-2ff2-df98-ad1a-89e9d8b0f686@linaro.org>
 <fd74e77c-f3d3-1f09-2e5a-0a94e2a3eeea@linux.intel.com>
 <5e34eadc-ef6a-abeb-6bce-347593c275b7@linaro.org>
 <dd61f44e-8d4a-ac2e-0af4-56ced642c4bd@linux.intel.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <dd61f44e-8d4a-ac2e-0af4-56ced642c4bd@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/09/2022 17:25, Pierre-Louis Bossart wrote:
>>>>
>>>> Wait, no, this is correct. Please point to what is wrong in kernel doc.
>>>> I don't see it. :(
>>>
>>> the TRIGGER_STOP and TRIGGER_PAUSE_PUSH do the same thing. There is no
>>> specific mapping of disable() to TRIGGER_STOP and unprepare() to
>>> TRIGGER_PAUSE_PUSH as the documentation hints at.
>>
>> Which TRIGGER_STOP and TRIGGER_PAUSE_PUSH? In one specific codec driver?
>> If yes, I don't think Slimbus documentation should care how actual users
>> implement it (e.g. coalesce states).
> 
> In both of the patches you just modified :-)

Yeah, but this is just some implementation. How this implementation
calls, e.g. whether they split STOP from PAUSE is not the concern of
Slimbus.

> 
> diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
> index 06c6adbe5920..d2548fdf9ae5 100644
> --- a/sound/soc/codecs/wcd9335.c
> +++ b/sound/soc/codecs/wcd9335.c
> @@ -1972,8 +1972,8 @@ static int wcd9335_trigger(struct
> snd_pcm_substream *substream, int cmd,
>  	case SNDRV_PCM_TRIGGER_STOP:
>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> -		slim_stream_unprepare(dai_data->sruntime);
>  		slim_stream_disable(dai_data->sruntime);
> +		slim_stream_unprepare(dai_data->sruntime);
>  		break;
>  	default:
> 
> diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
> index f56907d0942d..28175c746b9a 100644
> --- a/sound/soc/codecs/wcd934x.c
> +++ b/sound/soc/codecs/wcd934x.c
> @@ -1913,8 +1913,8 @@ static int wcd934x_trigger(struct
> snd_pcm_substream *substream, int cmd,
>  	case SNDRV_PCM_TRIGGER_STOP:
>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> -		slim_stream_unprepare(dai_data->sruntime);
>  		slim_stream_disable(dai_data->sruntime);
> +		slim_stream_unprepare(dai_data->sruntime);
>  		break;
>  	default:
>  		break;
> 
> the bus provides helpers to be used in well-defined transitions. A codec
> driver doing whatever it wants whenever it wants would create chaos for
> the bus.

True, but it's the problem of the codec, not the Slimbus.

Best regards,
Krzysztof

