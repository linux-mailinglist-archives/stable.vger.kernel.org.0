Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773955C00B5
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiIUPGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIUPGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:06:54 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0861F5D0D7
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:06:52 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id a10so7451187ljq.0
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=tJKrtCSfY5+gXFH9PIdDK9WMlvI30WQos0mPVhqlA9o=;
        b=Ff422eHalDyP9HUwFztILx1z91A9EzHUWkCChcEhFzC5Kd/eINPusYDhHHVwbl7Ave
         qKEQ09muCSC9VySNZDRt1jLzzSdQrxTvMNapx247RDG4sjks1I9rrTvZ4YyAX3L8rW9W
         h2RiTiHUviGcbPX3j1ImQOVIP3mG9aeXzcH2ZsZruI+JwnTJrGYVo3Q5zSPXzxuyCTtC
         NtyN6P3my+hVhZQ7d3Y9auX+15WDgq1sgYezKSSDqC5bDrH6bvVQC1s3t/H+KlQmnY8B
         5fXbG7C2ZLQeb9JSjYeqVgi4iLveddlIMB/E2WSlPHTI8/e/kt0V2XsHI7A/QzBIvQRS
         xWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tJKrtCSfY5+gXFH9PIdDK9WMlvI30WQos0mPVhqlA9o=;
        b=qQ0mzhelSkxScLx0vaKxREnyxftXdtcGO77EzZjNgexI/w9+3zZMmkSSpPu5AImX9c
         ZJoJPZ1Ingwo6+CT0FH5c6oDJXouXQ35Kt7C2CYxAIhsbPcBTjr4Riz2GCBKTXBV+6uh
         voEdWZ74UfkL4N3AcP9dLc8uO5rPaJhhXo1jvQfUi6V+lSGaVtlSEHFShk4JX7yUk1OQ
         foxJw9eLmG98qCW35Le4BSmpppOXppexb5nfEBICo8fQ0axne4OofzkukvATFMzooH4G
         rm4XT+gC0OJqd1M1hrzFOI3vW1NbafdnbxUXDmxnzpbVLyz0c4txGyCaY4Dpvq704wRm
         It6g==
X-Gm-Message-State: ACrzQf1rzWeReMI5AX/UaRzJyp3TT9hDmVNF4wGlXPHVfcstZXUrENkl
        UlZPvXYWf7X2Qy92ejRK3utcSQ==
X-Google-Smtp-Source: AMsMyM42X8A4oTmPBQ8Y36y0GUkP2BOkeRURa4f8MnioUONe4PO9EGGNr6bkOkpgO2WreFDeLMyUXw==
X-Received: by 2002:a05:651c:11cc:b0:26c:14c5:5b8f with SMTP id z12-20020a05651c11cc00b0026c14c55b8fmr9141160ljo.450.1663772811163;
        Wed, 21 Sep 2022 08:06:51 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id v4-20020a2e9f44000000b0026ac7cd51afsm477050ljk.57.2022.09.21.08.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 08:06:50 -0700 (PDT)
Message-ID: <af3bd3f4-dcd9-8f6c-6323-de1b53301225@linaro.org>
Date:   Wed, 21 Sep 2022 17:06:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
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
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20916c9d-3598-7c40-ee77-1148c3d2e4b1@linux.intel.com>
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

On 21/09/2022 17:05, Pierre-Louis Bossart wrote:
>> diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
>> index 06c6adbe5920..d2548fdf9ae5 100644
>> --- a/sound/soc/codecs/wcd9335.c
>> +++ b/sound/soc/codecs/wcd9335.c
>> @@ -1972,8 +1972,8 @@ static int wcd9335_trigger(struct snd_pcm_substream *substream, int cmd,
>>  	case SNDRV_PCM_TRIGGER_STOP:
>>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
>> -		slim_stream_unprepare(dai_data->sruntime);
>>  		slim_stream_disable(dai_data->sruntime);
>> +		slim_stream_unprepare(dai_data->sruntime);
> 
> This looks logical but different from what the kernel doc says:
> 
> /**
>  * slim_stream_disable() - Disable a SLIMbus Stream
>  *
>  * @stream: instance of slim stream runtime to disable
>  *
>  * This API will disable all the ports and channels associated with
>  * SLIMbus stream
>  *
>  * Return: zero on success and error code on failure. From ASoC DPCM
> framework,
>  * this state is linked to trigger() pause operation.
>  */
> 
> /**
>  * slim_stream_unprepare() - Un-prepare a SLIMbus Stream
>  *
>  * @stream: instance of slim stream runtime to unprepare
>  *
>  * This API will un allocate all the ports and channels associated with
>  * SLIMbus stream

You mean this piece of doc? Indeed looks inaccurate. I'll update it.

Best regards,
Krzysztof

