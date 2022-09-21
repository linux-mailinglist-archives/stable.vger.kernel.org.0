Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E4A5BF752
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 09:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiIUHOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 03:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiIUHOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 03:14:06 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D6882870
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 00:14:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id c11so8256919wrp.11
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 00:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=b3R9DZoCrYArCpmU71BmWGHj2dQq4IcyzDjXj86ttQs=;
        b=wrleY46bAvW9orcPdmhsGXsqIOZo6+mJ/aKl/qobRPfSARZkDXHDIXKaDWEJgSh1BF
         gjsbQU3f6mA7OZXAGqWtJ2jkHfyYGj9+pFPa5154c+wSrXeDe3h4OiRUwwXK9L0XtTvh
         GioFbERE3aUbAlm1ElAXoYAPzF77rSiS+RzxHyREkrpFBOqjOLim+QHj7pTnK/oRAs6k
         gUKdfJb1sbqFydZrZ7uQA3HqhV25QkUBd0yQGVPnrQ1lie7yDKaQwn8RDcxBOkLKuvef
         CDdYGCTsYbLO/4boTiaWto7J6H06j6+Kasj2nSeNdAQUouPhPcOjjQCOVmAB0oTe8A1P
         XBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=b3R9DZoCrYArCpmU71BmWGHj2dQq4IcyzDjXj86ttQs=;
        b=xI1NhRKF8SllegarsShwhQQJNzbQ7vqpqsVGtFuG28NKcejbIz3Zlxd3fd4W3/xNaf
         33Lod2JJIixO3VBjtpcwuBoXR69kEJvX1VjrwrAEkm4RujzVA93dC3rsX+pIZ3VwtUKy
         kRvxHmFZwuonEnYO0dbOYYYMkDNnnqBQgeMe/pFooPJZ3h2uF+3WazxHXEBfdCJL/eae
         dlZYfMEduCcd1f8O+BzWc+XQkiAQPwPZJMoohfAWy4hVrxjSbZCuIxknUbweryxg+4g1
         15p5AU6uEpuRU93JjK4KIMuQolufPIbK9wDwGxP+Jom+Wj0HOBpU+oVjYrWE4wzmM+hn
         gYIg==
X-Gm-Message-State: ACrzQf2DqKL4xBwSsNOHmNeBJ1M+bbC14TH2YEmtLBfkGuEUbT2bywKP
        +zm+0FKYWVKbQQACNgbmQRqx6A==
X-Google-Smtp-Source: AMsMyM7zmNVSeMitft5m1bCKwdxJeXe8VrB5miovFwS9K97uh3EJKfGQh5sjBYY25eWcRqfGh4opKA==
X-Received: by 2002:a5d:47a4:0:b0:226:e547:b602 with SMTP id 4-20020a5d47a4000000b00226e547b602mr16834338wrb.406.1663744441866;
        Wed, 21 Sep 2022 00:14:01 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:8ce3:ff4e:ae9b:55f3? ([2a01:e0a:982:cbb0:8ce3:ff4e:ae9b:55f3])
        by smtp.gmail.com with ESMTPSA id q63-20020a1c4342000000b003b4bd18a23bsm1866139wma.12.2022.09.21.00.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 00:14:01 -0700 (PDT)
Message-ID: <18097f21-0c19-926a-2242-0aed1fb229b5@linaro.org>
Date:   Wed, 21 Sep 2022 09:14:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] cpufreq: qcom-cpufreq-hw: Fix uninitialized
 throttled_freq warning
Content-Language: en-US
To:     Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc:     linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "v5 . 18+" <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8342b10a2716ec267ab89ea827f851b78b68470a.1663744088.git.viresh.kumar@linaro.org>
From:   Neil Armstrong <neil.armstrong@linaro.org>
Organization: Linaro
In-Reply-To: <8342b10a2716ec267ab89ea827f851b78b68470a.1663744088.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/09/2022 09:10, Viresh Kumar wrote:
> Commit 6240aaad75e1 was supposed to drop the reference count to the OPP,
> instead it avoided more stuff if the OPP isn't found. This isn't
> entirely correct. We already have a frequency value available, we just
> couldn't align it with an OPP in case of IS_ERR(opp).
> 
> Lets continue with updating thermal pressure, etc, even if we aren't
> able to find an OPP here.
> 
> This fixes warning generated by the 'smatch' tool.
> 
> Fixes: 6240aaad75e1 ("cpufreq: qcom-hw: fix the opp entries refcounting")
> Cc: v5.18+ <stable@vger.kernel.org> # v5.18+
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   drivers/cpufreq/qcom-cpufreq-hw.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
> index d5ef3c66c762..bb32659820ce 100644
> --- a/drivers/cpufreq/qcom-cpufreq-hw.c
> +++ b/drivers/cpufreq/qcom-cpufreq-hw.c
> @@ -316,14 +316,14 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
>   	if (IS_ERR(opp)) {
>   		dev_warn(dev, "Can't find the OPP for throttling: %pe!\n", opp);
>   	} else {
> -		throttled_freq = freq_hz / HZ_PER_KHZ;
> -
> -		/* Update thermal pressure (the boost frequencies are accepted) */
> -		arch_update_thermal_pressure(policy->related_cpus, throttled_freq);
> -
>   		dev_pm_opp_put(opp);
>   	}
>   
> +	throttled_freq = freq_hz / HZ_PER_KHZ;
> +
> +	/* Update thermal pressure (the boost frequencies are accepted) */
> +	arch_update_thermal_pressure(policy->related_cpus, throttled_freq);
> +
>   	/*
>   	 * In the unlikely case policy is unregistered do not enable
>   	 * polling or h/w interrupt

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
