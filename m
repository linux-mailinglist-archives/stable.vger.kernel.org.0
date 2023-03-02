Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0C26A8347
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 14:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCBNKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 08:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCBNKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 08:10:36 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9C2149B1
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 05:10:35 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id bw19so16435328wrb.13
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 05:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677762634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LTMb2uiAKQy8zkbJrBkzpMbRkO+dwt0YiEEiYQBT8oM=;
        b=RQh0pRw3GZQXbuvLXDlP/waEUyZWHkYkc0rlKmxYZpkshO94bQ7StbBQ1MtI3m2kDU
         KzH1v7ZpIiP6QCzqx4vsx2CV8F9WfIPKzeFrYTe7sCiXIVlHgAuLatKo0cjH+Oy3g927
         PmrQkT9MQv12j2neob8toCo4kW/kb+xG/bQAbNNIDLAlN2jCDZ3Ag3ILQYl8ynlogXXO
         kjLhWz4Z00knAmyth4KuQYshKND2D1o4hOaJw4KnALM7ucc1PjbfA0GKF9JRljTSuZZe
         UrV4v7degPV2NP3gxGd/BRB3oGSoGZqYEn4i7kFx/cPiVwbvyuDCaOtZLtXJcM3BY3Eq
         po9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677762634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTMb2uiAKQy8zkbJrBkzpMbRkO+dwt0YiEEiYQBT8oM=;
        b=rOkDP577jUkMFKq4DMVfCg5eIA82I8WEDHTFJ7EIuyau/uJ/Oiu5NI6dEf26Erj2uG
         MF3TAILvfEr4m/oALGsxCXJL9oyoHlLx94DlTxyq5P4XKXK6HG1QKfKa7igGvxr4TH3G
         NGySUAYo1sm50ztA+ECdxOJcOTA8sT3wACNdWTYewp+9gLgtOV8X7Ybhor0wnui4kvUB
         PCIRIf41PZSqNty7/O14zn5nCQIU5Unz/LmzGdlvsISgM7CvhHZYq3NQ5T9gidsLih8L
         48bY1N3+eFBFQ1RnJNz4EKxamnkjmBWdYcjUujNefGlPWby/WyMcFwqhBR+PKHV/PPZW
         xbcA==
X-Gm-Message-State: AO0yUKWiQF6G1Wvvos0txsXm7fcn7nLixlwzY59m3bqidO3N8rwJohro
        VoTdb9DKOR9dvFVdUqmkb2Az7g==
X-Google-Smtp-Source: AK7set/UY2mu+bVvyesOlReohTFVfVRqwfeXA8qbg0d09zP+0hh61PBsHLM+AjPQwB0/GuENcMxemw==
X-Received: by 2002:a5d:4dd2:0:b0:2cb:c66d:6ac1 with SMTP id f18-20020a5d4dd2000000b002cbc66d6ac1mr7025325wru.3.1677762633759;
        Thu, 02 Mar 2023 05:10:33 -0800 (PST)
Received: from [192.168.1.195] ([5.133.47.210])
        by smtp.googlemail.com with ESMTPSA id t14-20020adfe44e000000b002c5503a8d21sm15622256wrm.70.2023.03.02.05.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 05:10:33 -0800 (PST)
Message-ID: <ee0a09bd-831b-9ac4-7b9c-d584497cd7a0@linaro.org>
Date:   Thu, 2 Mar 2023 13:10:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] ASoC: qcom: q6prm: fix incorrect clk_root passed to ADSP
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20230302122908.221398-1-krzysztof.kozlowski@linaro.org>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20230302122908.221398-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 02/03/2023 12:29, Krzysztof Kozlowski wrote:
> The second to last argument is clk_root (root of the clock), however the
> code called q6prm_request_lpass_clock() with clk_attr instead
> (copy-paste error).  This effectively was passing value of 1 as root
> clock which worked on some of the SoCs (e.g. SM8450) but fails on
> others, depending on the ADSP.  For example on SM8550 this "1" as root
> clock is not accepted and results in errors coming from ADSP.
> 
> Fixes: 2f20640491ed ("ASoC: qdsp6: qdsp6: q6prm: handle clk disable correctly")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Nice Find, Tested on sc8280xp

Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>


--srini
> ---
>   sound/soc/qcom/qdsp6/q6prm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/qcom/qdsp6/q6prm.c b/sound/soc/qcom/qdsp6/q6prm.c
> index 8aa1a213bfb7..c1dc5bae715a 100644
> --- a/sound/soc/qcom/qdsp6/q6prm.c
> +++ b/sound/soc/qcom/qdsp6/q6prm.c
> @@ -183,9 +183,9 @@ int q6prm_set_lpass_clock(struct device *dev, int clk_id, int clk_attr, int clk_
>   			  unsigned int freq)
>   {
>   	if (freq)
> -		return q6prm_request_lpass_clock(dev, clk_id, clk_attr, clk_attr, freq);
> +		return q6prm_request_lpass_clock(dev, clk_id, clk_attr, clk_root, freq);
>   
> -	return q6prm_release_lpass_clock(dev, clk_id, clk_attr, clk_attr, freq);
> +	return q6prm_release_lpass_clock(dev, clk_id, clk_attr, clk_root, freq);
>   }
>   EXPORT_SYMBOL_GPL(q6prm_set_lpass_clock);
>   
