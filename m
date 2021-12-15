Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C104547568D
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 11:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241713AbhLOKha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 05:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbhLOKh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 05:37:29 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFE4C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 02:37:29 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id b40so42239068lfv.10
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 02:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=75hG4ptV8ugZS6z2EZMXoRviBeddRnCuWyksj5im6Yw=;
        b=T/eaOryjK+PHO9SIpO1TfbLbnlbK7HAwBlpLaxnV8qptCdnz3m9FqDzfMmXhgOVmpV
         uNp/DuOz/7YcfgoBo5wQIElF9XQWefB+HO7c6DJyNFdxH3ONIicnuQnhWmOegsfDzXK0
         i+vsY+4Y31OcPFWYUr3tZnEwgNRjt2t5bqcm9KQ/e97X+p4I4ZXfvdvur7q1PKzxj04U
         2eBiTxogfIsFO7rThOhW4ZWG1paBzdGv7WkWm2auZ8aZdAA1/rN7HJgnldpOM0LYkl3g
         LPKO8k5nEzqsmWV165LfRMnr0cTdll/oXxM/4Uh10YjCHjH5bjG17apNqnboJHSf0VOi
         G4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=75hG4ptV8ugZS6z2EZMXoRviBeddRnCuWyksj5im6Yw=;
        b=Kjc1t28He8ihPj8RnZugOedlebs9hz+GW2OaKXa5j+lH83LAezANptC8rKneTHebh9
         e8RMf5ls34e0csjCeQ9HTAu7LLez9J90UMsgIk3WJYjaLWJtFWNPeKE30odeuA4NpGno
         orjFXvT/xmICkspZXEA7hWlxFX3UnekyQRgoFgINj4nQ7GYUkNSlVFRVM593zYRAjp/Z
         INdPwWhWZHQXAIYCQcRGVY9P92DtHOhNSO2/XbWDd1nWGtN9uWvcwteCOLyC3KiX3nQI
         zxTcBeDUXcjYXUbVahPJZuf3l0rfJAcuUnIlpdA5hH2lGnui93GUkR5S+yZNFaKt7IGS
         BeZQ==
X-Gm-Message-State: AOAM53016BMBmpdQRTeimJnK0emTElPezKuG3iytzljauJJM8w5FPG3U
        jxEBoUeu0scTQiOYp1da/HqgwORRVQ/uR8Ws
X-Google-Smtp-Source: ABdhPJz9rUzSBDRwz043Gb+0Avx6UpDQvRlK8w8o1Q/3mC6GcycjedzkehphirfMSxiuoEpEeBdprA==
X-Received: by 2002:a05:6512:b1d:: with SMTP id w29mr9291775lfu.219.1639564647513;
        Wed, 15 Dec 2021 02:37:27 -0800 (PST)
Received: from ?IPV6:2001:470:dd84:abc0::8a5? ([2001:470:dd84:abc0::8a5])
        by smtp.gmail.com with ESMTPSA id v2sm365110ljg.46.2021.12.15.02.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 02:37:27 -0800 (PST)
Message-ID: <67a77fc5-6db4-ba26-cacb-9758336ad074@linaro.org>
Date:   Wed, 15 Dec 2021 13:37:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 4.19 29/74] clk: qcom: regmap-mux: fix parent clock lookup
Content-Language: en-GB
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephen Boyd <sboyd@kernel.org>
References: <20211213092930.763200615@linuxfoundation.org>
 <20211213092931.784850569@linuxfoundation.org> <20211215091623.GA15796@amd>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20211215091623.GA15796@amd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/12/2021 12:16, Pavel Machek wrote:
> Hi!
> 
>> The function mux_get_parent() uses qcom_find_src_index() to find the
>> parent clock index, which is incorrect: qcom_find_src_index() uses src
>> enum for the lookup, while mux_get_parent() should use cfg field (which
>> corresponds to the register value). Add qcom_find_cfg_index() function
>> doing this kind of lookup and use it for mux parent lookup.
> 
> This appears to have problems with error handling.
> 
>> +++ b/drivers/clk/qcom/clk-regmap-mux.c
>> @@ -36,7 +36,7 @@ static u8 mux_get_parent(struct clk_hw *
>>   	val &= mask;
>>   
>>   	if (mux->parent_map)
>> -		return qcom_find_src_index(hw, mux->parent_map, val);
>> +		return qcom_find_cfg_index(hw, mux->parent_map, val);
>>   
>>   	return val;
>>   }
> 
> So this returns u8.
> 
>> +int qcom_find_cfg_index(struct clk_hw *hw, const struct parent_map *map, u8 cfg)
>> +{
>> +	int i, num_parents = clk_hw_get_num_parents(hw);
>> +
>> +	for (i = 0; i < num_parents; i++)
>> +		if (cfg == map[i].cfg)
>> +			return i;
>> +
>> +	return -ENOENT;
>> +}
> 
> In case of error, -ENOENT will be cast to u8 in caller. I don't
> believe that is correct.

Unfortunately there is no way to return proper error code from 
clk_ops->get_parent() callback. However returning -ENOENT would 
translate to 254. Then clk_core_get_parent_by_index() would determine 
that there is no such parent and return NULL. A call to clk_set_parent 
would reparent the clock.

Returning some sensible default (e.g. 0) would be much worse, since then 
the clock subsystem would assume that the clock has correct parent. A 
call to clk_set_parent would always result in ops->set_parent() call, 
reparenting the clock correctly.

Most probably it would be correct to make ops->get_parent() return int 
instead of u8 (either an index or an -ERROR). However this was out of 
scope for this patch.

-- 
With best wishes
Dmitry
