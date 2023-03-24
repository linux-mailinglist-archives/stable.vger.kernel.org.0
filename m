Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6846C7497
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 01:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjCXA2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 20:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjCXA2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 20:28:18 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F12E3BF
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 17:28:15 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i13so142937lfe.9
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 17:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679617693;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+J8p8pl2Pt3GUIvBHOdUa3bfVDVXJiWCxeGSW1F0PEY=;
        b=lKika/aCnauE2ihkPyFGtIb/y9pWowhjIWcrfDDPysDBKukzCQ6zu5BDpQC1wxIO4e
         l9GfD8VVlgXMeXqJgX+JMD0H/d+CP0ppW9nqZYASLFplzfnTNV7SvNzv4T/dcgRXUlNT
         E1beeT2cZtcuf40h3pttpH3DHYYampYbrznPZvxTcB6UVwPPfXpbdcBFq7Yyc1r0EhQJ
         5uVSINLkmxvQWNdDZ/Dj3g5I2yvZHRUIoow3CsIHV7yPTRRmX2Ieb8fl3F4QeWbLO5MM
         MT5C+k8BRT3iqKpGcc71rLsdzlrCr5pjhWu/6lyche1Nppbfd9Pf37s/DRl5feLSQBR0
         YdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679617693;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+J8p8pl2Pt3GUIvBHOdUa3bfVDVXJiWCxeGSW1F0PEY=;
        b=IXz/bj7927PR30B7CWjHdXe/8BLcJInKp+eYi+mlfH0puU8E+To8z2bAyuOgiU5WxQ
         Fd6OMUpYCdYbba4zMAyyF4o4uY8zVN0nkHuimUSv8+wRScgr4NF2aseMloVXFa/hBJg4
         58xnKFN886xJVxBgHSrqg6QmApNhIZa4ScYJlVOoaE3g8QY/1fO1OUnF9Vud+Ig1zWwF
         TNKafEkJLY7JhTGBHsBjqcvQ7z/mbhh1LMnjSeEl7RF2GHyuhxryQigbSxhn7TAfTwzM
         TYfexC2NLy7KZHbPLrk8Nsvdm376VnRCq63dJwTfptpZ2Zq9TfB+Hq012hHDh6ZG1XKF
         wlWw==
X-Gm-Message-State: AAQBX9cmvCvO7lp6Y4GSnML88klyVutOrtCEmZ/RghzuOJYToYsZ9etf
        OuPWHV2KvOhOWcg4y8yCMmKCbqpTA0C8LDL9i9c=
X-Google-Smtp-Source: AKy350YqrKe7OxTHs4gi2Wx39qKPpxkvAYrkEs/iJWYImYxIZEgJe9m465IkFy36hfOtg1arBTnzcw==
X-Received: by 2002:ac2:410d:0:b0:4e9:b165:cdc with SMTP id b13-20020ac2410d000000b004e9b1650cdcmr165985lfi.17.1679617693436;
        Thu, 23 Mar 2023 17:28:13 -0700 (PDT)
Received: from [192.168.1.101] (abxj225.neoplus.adsl.tpnet.pl. [83.9.3.225])
        by smtp.gmail.com with ESMTPSA id r8-20020a19ac48000000b004e8b90e14a8sm3138916lfc.25.2023.03.23.17.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 17:28:13 -0700 (PDT)
Message-ID: <cbedb905-1888-5a41-047d-c8ce02c435a1@linaro.org>
Date:   Fri, 24 Mar 2023 01:28:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] cpufreq: qcom-cpufreq-hw: Revert adding cpufreq qos
To:     Bjorn Andersson <quic_bjorande@quicinc.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Xuewen Yan <xuewen.yan@unisoc.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230323223343.587210-1-quic_bjorande@quicinc.com>
Content-Language: en-US
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230323223343.587210-1-quic_bjorande@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 23.03.2023 23:33, Bjorn Andersson wrote:
> The OSM/EPSS hardware controls the frequency of each CPU cluster based
> on requests from the OS and various throttling events in the system.
> While throttling is in effect the related dcvs interrupt will be kept
> high. The purpose of the code handling this interrupt is to
> continuously report the thermal pressure based on the throttled
> frequency.
> 
> The reasoning for adding QoS control to this mechanism is not entirely
> clear, but the introduction of commit 'c4c0efb06f17 ("cpufreq:
> qcom-cpufreq-hw: Add cpufreq qos for LMh")' causes the
> scaling_max_frequncy to be set to the throttled frequency. On the next
> iteration of polling, the throttled frequency is above or equal to the
> newly requested frequency, so the polling is stopped.
Oh wow.. That must have been fun to debug..

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
> 
> With cpufreq limiting the max frequency, the hardware no longer report a
> throttling state and no further updates to thermal pressure or qos
> state are made.
> 
> The result of this is that scaling_max_frequency can only go down, and
> the system becomes slower and slower every time a thermal throttling
> event is reported by the hardware.
> 
> Even if the logic could be improved, there is no reason for software to
> limit the max freqency in response to the hardware limiting the max
> frequency. At best software will follow the reported hardware state, but
> typically it will cause slower backoff of the throttling.
> 
> This reverts commit c4c0efb06f17fa4a37ad99e7752b18a5405c76dc.
> 
> Fixes: c4c0efb06f17 ("cpufreq: qcom-cpufreq-hw: Add cpufreq qos for LMh")
> Cc: stable@vger.kernel.org
> Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
> ---
>  drivers/cpufreq/qcom-cpufreq-hw.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
> index 575a4461c25a..1503d315fa7e 100644
> --- a/drivers/cpufreq/qcom-cpufreq-hw.c
> +++ b/drivers/cpufreq/qcom-cpufreq-hw.c
> @@ -14,7 +14,6 @@
>  #include <linux/of_address.h>
>  #include <linux/of_platform.h>
>  #include <linux/pm_opp.h>
> -#include <linux/pm_qos.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/units.h>
> @@ -60,8 +59,6 @@ struct qcom_cpufreq_data {
>  	struct clk_hw cpu_clk;
>  
>  	bool per_core_dcvs;
> -
> -	struct freq_qos_request throttle_freq_req;
>  };
>  
>  static struct {
> @@ -351,8 +348,6 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
>  
>  	throttled_freq = freq_hz / HZ_PER_KHZ;
>  
> -	freq_qos_update_request(&data->throttle_freq_req, throttled_freq);
> -
>  	/* Update thermal pressure (the boost frequencies are accepted) */
>  	arch_update_thermal_pressure(policy->related_cpus, throttled_freq);
>  
> @@ -445,14 +440,6 @@ static int qcom_cpufreq_hw_lmh_init(struct cpufreq_policy *policy, int index)
>  	if (data->throttle_irq < 0)
>  		return data->throttle_irq;
>  
> -	ret = freq_qos_add_request(&policy->constraints,
> -				   &data->throttle_freq_req, FREQ_QOS_MAX,
> -				   FREQ_QOS_MAX_DEFAULT_VALUE);
> -	if (ret < 0) {
> -		dev_err(&pdev->dev, "Failed to add freq constraint (%d)\n", ret);
> -		return ret;
> -	}
> -
>  	data->cancel_throttle = false;
>  	data->policy = policy;
>  
> @@ -519,7 +506,6 @@ static void qcom_cpufreq_hw_lmh_exit(struct qcom_cpufreq_data *data)
>  	if (data->throttle_irq <= 0)
>  		return;
>  
> -	freq_qos_remove_request(&data->throttle_freq_req);
>  	free_irq(data->throttle_irq, data);
>  }
>  
