Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590BA5E6E86
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 23:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiIVVjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 17:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiIVVjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 17:39:03 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBC311265E
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 14:39:00 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r7so17595900wrm.2
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 14:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=3YdjZ7VPUxdfC5sRfXwx/0L+V0iZ1cHHxou9pXPTrn0=;
        b=LUdmXEY4WTCLFE96EnTufspOZgwzO9if4fnR/Ki/tDw4TDslehPs9KXAWqVQ90eX74
         wr7N61D+a97NJnOs7WG5uEVR7FTjtHhiHo4C2F6126LiApGKN514zaeKrrwJnsP/zvq1
         42Ii9hLAq4vPR27IJRA/ByOyomv5u5UI22rWwwivAzOPq5Z9/wo/h5H+5E5zxQewEhQM
         0PYhr27vPRBTi1cbAJbZg6Uw2P37N7fKziMhHn1/AAbgWNQl2bMjevEOE+2qsA2fp87g
         uHA6cmo+ElyOcEEobYbt8FerYREw8vDcewHJG7mCrLGH5AinoqvTG9iP7zAuB3GRXqTg
         OlCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3YdjZ7VPUxdfC5sRfXwx/0L+V0iZ1cHHxou9pXPTrn0=;
        b=c+Utjgb+WstKT6GnV8cASZUMACEEz2ux8drBRvpCjrx4qXHVdOINdf8saik0o0bLIm
         Ro2CKXqLb2oMNaGtGzEBb7Cn5E78ld1soPd+CymQxNNzZ+7yKjH+/TjXXgyPZDvxdz2P
         CFhPSjXwwNsPqhfQgEGuOEPrSmJIML6uW7jFq/2gFrttzUCcVTMJdV4iD+5/g2HNI/oJ
         SF1n74i0tJFeWN2ntVNS6nECxgSwU8FfjmqFhsq54tCOMuS43GT0lafIN2znAvVTyr8o
         NjKQI22bdIOG5eQZ/kmpPLRXEoMDKIpVVHWcbAqFaa9dxIRZKO80/lod2mqjEDfaYQQm
         9hyA==
X-Gm-Message-State: ACrzQf3RGezM1mA1oCmywMZfPeVYYuWHeRJ51myEv9VhXfHsjhdSSql+
        xP3Ck9GkkJYcBRMBEVpRIjdlnA==
X-Google-Smtp-Source: AMsMyM7fIC1LBj6rLVhG2ZRjxhF1HjOWZH+eirIbrbnBVm0ST+5hrcXDL3kJ2ojgS88jH1nJ1qF0qA==
X-Received: by 2002:adf:fa81:0:b0:224:f260:2523 with SMTP id h1-20020adffa81000000b00224f2602523mr3238333wrr.26.1663882739290;
        Thu, 22 Sep 2022 14:38:59 -0700 (PDT)
Received: from [192.168.86.238] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id g14-20020a05600c4ece00b003b477532e66sm11907506wmq.2.2022.09.22.14.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 14:38:57 -0700 (PDT)
Message-ID: <f6d0df7f-de0d-75b8-57a7-8a3f5c93194a@linaro.org>
Date:   Thu, 22 Sep 2022 22:38:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/2] ASoC: wcd934x: fix order of Slimbus unprepare/disable
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
 <20220921145354.1683791-2-krzysztof.kozlowski@linaro.org>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220921145354.1683791-2-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 21/09/2022 15:53, Krzysztof Kozlowski wrote:
> Slimbus streams are first prepared and then enabled, so the cleanup path
> should reverse it.  The unprepare sets stream->num_ports to 0 and frees
> the stream->ports.  Calling disable after unprepare was not really
> effective (channels was not deactivated) and could lead to further
> issues due to making transfers on unprepared stream.
> 
> Fixes: a61f3b4f476e ("ASoC: wcd934x: add support to wcd9340/wcd9341 codec")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---

Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>


>   sound/soc/codecs/wcd934x.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
> index f56907d0942d..28175c746b9a 100644
> --- a/sound/soc/codecs/wcd934x.c
> +++ b/sound/soc/codecs/wcd934x.c
> @@ -1913,8 +1913,8 @@ static int wcd934x_trigger(struct snd_pcm_substream *substream, int cmd,
>   	case SNDRV_PCM_TRIGGER_STOP:
>   	case SNDRV_PCM_TRIGGER_SUSPEND:
>   	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> -		slim_stream_unprepare(dai_data->sruntime);
>   		slim_stream_disable(dai_data->sruntime);
> +		slim_stream_unprepare(dai_data->sruntime);
>   		break;
>   	default:
>   		break;
