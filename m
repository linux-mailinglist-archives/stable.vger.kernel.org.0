Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E560A6C3BE2
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 21:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCUUd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 16:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCUUd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 16:33:56 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4285A22110
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 13:33:53 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ew6so1666908edb.7
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 13:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679430832;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KTpu7F9BL2yL3dz5JaGLJyVf1Ik8YB0yHGfUTS5ixLY=;
        b=p+bIXPROrY9Nrek+Wmbtia3iwVn1uy5t5w/nMtRwmRA8GTLXIuMWRTOTMjAwvAADPV
         DACTTt5AzcV0w90we/PtHmkPjievW5kvs59J9hzQLWyky5rRuUgY1b5xiseQW36ZPKK9
         Qwqwk8npprKqw1mJPUEG7w210YMUp93BRMFT1lnoh9lD+y6tFqpkIoIQMg4RAUfh0KK6
         Wwfbp+utgdZ+r1i1hW04RWiH5VYdU0mdiPpGB8DIcCsI+IupfeQ+6anQzwFCdo+wJWpT
         nV9TgkqYd3VykDsAhd5lMfSMmXrgd36f605L+P5vjqTFjEEn8Fifu0TRTFskB/NSP27F
         WaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679430832;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTpu7F9BL2yL3dz5JaGLJyVf1Ik8YB0yHGfUTS5ixLY=;
        b=vP8So+VNPxHO9CnEuTRerkjilFXzN3IXBbIF7z2zixB9GvNjEEQmOMtdv4C8UbBYo6
         2G+G+W6eJxS7muLhqaDfx/rvaGVjNuf2U6qIxWR9fBu16cADAy/AXAm47gfIGf5bZbeb
         LH+u9d/dqFP+3ZYxSdSh84YaVAxXdibXdNo4uMPg4E1N5AgimDip8Jz29lh0rEQnfwQ3
         woTLZeVQADBQ7bCkadYNoIeZS1r8MKIxtp7XUQljrnLawDc4WbX0g56Iifd+bbqPPkHA
         5rYqU90tUIVx2EMiNu0KRKBXRnZ2h9v8f7fggHMjrpCh6YQrbfK8pe14K6GFJ8ttztpb
         TE2w==
X-Gm-Message-State: AO0yUKU76PNe9rxDuNakX+jBZsbq9Jhs5mmSoVk4j9hutVTpNwwwBBtY
        1AdP/m84pggpGkMpoJZ/ozYXDg==
X-Google-Smtp-Source: AK7set8DiQQyI/6A7EQc/HPSa7kGeb9afOqUgPq7x5HSX2RAXq6ySWlu8V7lc1HMMxcVwyd57KB7FA==
X-Received: by 2002:a17:907:2122:b0:92f:b290:78c with SMTP id qo2-20020a170907212200b0092fb290078cmr4179455ejb.21.1679430831701;
        Tue, 21 Mar 2023 13:33:51 -0700 (PDT)
Received: from [192.168.1.195] ([5.133.47.210])
        by smtp.googlemail.com with ESMTPSA id b1-20020a1709065e4100b008ca52f7fbcbsm6212839eju.1.2023.03.21.13.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 13:33:51 -0700 (PDT)
Message-ID: <4df4d530-f12a-cc34-692a-1f5ff784bbe5@linaro.org>
Date:   Tue, 21 Mar 2023 20:33:49 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] clk: qcom: gfm-mux: use runtime pm while accessing
 registers
Content-Language: en-US
To:     Stephen Boyd <sboyd@kernel.org>, agross@kernel.org,
        andersson@kernel.org
Cc:     konrad.dybcio@linaro.org, mturquette@baylibre.com,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amit Pundir <amit.pundir@linaro.org>
References: <20230321175758.26738-1-srinivas.kandagatla@linaro.org>
 <c5273d67493cbb008f13d7538837828a.sboyd@kernel.org>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <c5273d67493cbb008f13d7538837828a.sboyd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 21/03/2023 18:46, Stephen Boyd wrote:
> Quoting Srinivas Kandagatla (2023-03-21 10:57:58)
>> gfm mux driver does support runtime pm but we never use it while
>> accessing registers. Looks like this driver was getting lucky and
>> totally depending on other drivers to leave the clk on.
>>
>> Fix this by doing runtime pm while accessing registers.
>>
>> Fixes: a2d8f507803e ("clk: qcom: Add support to LPASS AUDIO_CC Glitch Free Mux clocks")
>> Cc: stable@vger.kernel.org
>> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> 
> Is there a link to the report?

https://www.spinics.net/lists/stable/msg638380.html

> 
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> ---
>>   drivers/clk/qcom/lpass-gfm-sm8250.c | 29 ++++++++++++++++++++++++++++-
>>   1 file changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/qcom/lpass-gfm-sm8250.c b/drivers/clk/qcom/lpass-gfm-sm8250.c
>> index 96f476f24eb2..bcf0ea534f7f 100644
>> --- a/drivers/clk/qcom/lpass-gfm-sm8250.c
>> +++ b/drivers/clk/qcom/lpass-gfm-sm8250.c
>> @@ -38,14 +38,37 @@ struct clk_gfm {
>>   static u8 clk_gfm_get_parent(struct clk_hw *hw)
>>   {
>>          struct clk_gfm *clk = to_clk_gfm(hw);
>> +       int ret;
>> +       u8 parent;
>> +
>> +       ret = pm_runtime_resume_and_get(clk->priv->dev);
>> +       if (ret < 0 && ret != -EACCES) {
>> +               dev_err_ratelimited(clk->priv->dev,
>> +                                   "pm_runtime_resume_and_get failed in %s, ret %d\n",
>> +                                   __func__, ret);
>> +               return ret;
>> +       }
>> +
>> +       parent = readl(clk->gfm_mux) & clk->mux_mask;
>> +
>> +       pm_runtime_mark_last_busy(clk->priv->dev);
>>   
>> -       return readl(clk->gfm_mux) & clk->mux_mask;
>> +       return parent;
>>   }
>>   
>>   static int clk_gfm_set_parent(struct clk_hw *hw, u8 index)
>>   {
>>          struct clk_gfm *clk = to_clk_gfm(hw);
>>          unsigned int val;
>> +       int ret;
>> +
>> +       ret = pm_runtime_resume_and_get(clk->priv->dev);
> 
> Doesn't the clk framework already do this? Why do we need to do it
> again?

You are right, clk core already does do pm_runtime_resume_and_get for 
set_parent.

this looks redundant here.


so we need only need to add this for get_parent

--srini
> 
>> +       if (ret < 0 && ret != -EACCES) {
>> +               dev_err_ratelimited(clk->priv->dev,
>> +                                   "pm_runtime_resume_and_get failed in %s, ret %d\n",
>> +                                   __func__, ret);
>> +               return ret;
>> +       }
>>   
>>          val = readl(clk->gfm_mux);
>>
