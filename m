Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E682A5C00BE
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiIUPIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiIUPIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:08:04 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CDA7755F
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:08:03 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id a8so9657271lff.13
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=RF9pE1XqBaCkFujXuhCj/YrM4VUzgwG2BT/TUrX/TQs=;
        b=Bgb+iEOe9wB7sYiTFOX2L4NoZHqArQD+KjhaktUTxRoqMOR7ETeLMVom22TQH6w/iB
         at55Y30/CDPtMsNUDzLUpckengtH+aKcMBIUymjHumbY5Wyqaq4CDTJ6UyZugqvxcnj/
         NroVkcIrCvjn0eqE1R2xRIBlHp3dwf2WitEcDT1INMmzOnM6rAr77ER65QARn2u/0B/N
         PGDyD5ShJI9cTZMDm5w8mwaxoJgTZoCC7imKOxKrPgNNIvHPHUPEBQ4ow1gubY17I5P9
         7uwYXQjX/eVZaYXKQ9804Jk266dh3Pibzjpdv7j4CZvS+IQmIacT3wih3O3X3YGtqpmp
         Tujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=RF9pE1XqBaCkFujXuhCj/YrM4VUzgwG2BT/TUrX/TQs=;
        b=AimpDRxU/4Wn3iwzqBtwdOVtdaIuoeAuQIHNvW1BRMZXFZ64dcImpOushQ/MV52Ozx
         yW9O1UJQtf2UFtmAtKndngjVW31tp2oF60wJ0RdrlL+k8k5+fQv5UfqgaMf4b+Zw/vzw
         B+FfNzQ/K/GvtXWAqJdTm+SjnHx9F4wFNej7p0WJSi5T92SLXEmoPjrL4hSODJzIS/Fo
         QKowGHIZaypWF7ykeldpK094t336PYcRglEEFviW1Oo6nzzmwojxw0QR4CiQCyjpSwj0
         x7OyhDUWWLiKYwr4+N7y+P3Dg9SZnkERNAj3mDet/aM1vh9NZaic9DMIGmEmEXFP0GVC
         pM2w==
X-Gm-Message-State: ACrzQf0E/KcR2AtRK3sstylSrD5sQCKCLWJirfr0/7uJUF5zltng9bL3
        Lcz2COjdHWWAlMiaFj9X/XRbtA==
X-Google-Smtp-Source: AMsMyM6LiMMw9ZyS7tgrWaPytuR+QBRjPIZREoDo1FdiuatxHS0wsN9I/0scWOUEj/XR3+sFYsn3pA==
X-Received: by 2002:ac2:52b1:0:b0:499:f7ac:14da with SMTP id r17-20020ac252b1000000b00499f7ac14damr11247218lfm.597.1663772881791;
        Wed, 21 Sep 2022 08:08:01 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id l10-20020a056512110a00b0049f9c732858sm462533lfg.254.2022.09.21.08.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 08:08:01 -0700 (PDT)
Message-ID: <9a210b04-2ff2-df98-ad1a-89e9d8b0f686@linaro.org>
Date:   Wed, 21 Sep 2022 17:08:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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
In-Reply-To: <af3bd3f4-dcd9-8f6c-6323-de1b53301225@linaro.org>
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

On 21/09/2022 17:06, Krzysztof Kozlowski wrote:
> On 21/09/2022 17:05, Pierre-Louis Bossart wrote:
>>> diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
>>> index 06c6adbe5920..d2548fdf9ae5 100644
>>> --- a/sound/soc/codecs/wcd9335.c
>>> +++ b/sound/soc/codecs/wcd9335.c
>>> @@ -1972,8 +1972,8 @@ static int wcd9335_trigger(struct snd_pcm_substream *substream, int cmd,
>>>  	case SNDRV_PCM_TRIGGER_STOP:
>>>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>>>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
>>> -		slim_stream_unprepare(dai_data->sruntime);
>>>  		slim_stream_disable(dai_data->sruntime);
>>> +		slim_stream_unprepare(dai_data->sruntime);
>>
>> This looks logical but different from what the kernel doc says:
>>
>> /**
>>  * slim_stream_disable() - Disable a SLIMbus Stream
>>  *
>>  * @stream: instance of slim stream runtime to disable
>>  *
>>  * This API will disable all the ports and channels associated with
>>  * SLIMbus stream
>>  *
>>  * Return: zero on success and error code on failure. From ASoC DPCM
>> framework,
>>  * this state is linked to trigger() pause operation.
>>  */
>>
>> /**
>>  * slim_stream_unprepare() - Un-prepare a SLIMbus Stream
>>  *
>>  * @stream: instance of slim stream runtime to unprepare
>>  *
>>  * This API will un allocate all the ports and channels associated with
>>  * SLIMbus stream
> 
> You mean this piece of doc? Indeed looks inaccurate. I'll update it.

Wait, no, this is correct. Please point to what is wrong in kernel doc.
I don't see it. :(

Best regards,
Krzysztof

