Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0EA2A927F
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 10:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgKFJZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 04:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgKFJZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 04:25:49 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5300DC0613D3
        for <stable@vger.kernel.org>; Fri,  6 Nov 2020 01:25:48 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id a18so589519pfl.3
        for <stable@vger.kernel.org>; Fri, 06 Nov 2020 01:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RJ6te3ObHVnElBaSFwGNPPBac7krO/8OzGYULw7Qx98=;
        b=XJ0VBIj7n/TNvivjTiFO2gl3zVbYjfnbWLt0sDNjhMX0SuSVXi+l6Zk5qlm1WTTBqq
         ZeNzqpTeyloDaD4lnN42MFAbn160deOuXSa3H9O48AxVsyc6vhZNQy0cl7FuIcmIugqr
         f9HK39X+AySWn2pEp9ZWDzzdXunuYpxKbiNNjsSg5QP8MPlwwOz/gGKT1DuSapSlgGl4
         GMbcBx6/UYTk8qMLm4J9GvpBi8IpNTpci3sc9JgoIAaSu5XTBuFUEvvq/+ILQAzpykcS
         QrI9APHgiOAv6v2tJC1FSmzWJoXqaAT32uHFqLVPMQlbT7EGwthj0sMjx8S51r/Gv/ep
         wtKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RJ6te3ObHVnElBaSFwGNPPBac7krO/8OzGYULw7Qx98=;
        b=G7MY33k6d+xsxPmAOXPykqvPffkT4QXaD0Qa/KVCsbiKvssBTgPCN1tMdtMaBktgYG
         UeHl4xLey59GfqtIR1BHTHHFhnav5GXcY64zwQU5wi3s4wwx5tU/zj+LmGuvmAqjGOVR
         2ZTpkgOYQKkfHVMsRUV8BhxIfZhOc8fgdlv0EHLUU/pmzcGUv7N3Dp9KE1XlLw2bngm6
         VWpANofNJNrlBanJdwN8eoak+n78zFViAjcUWS67GEohnPcOAAYkmC1v9JentuNTjc9+
         odZk2mPeXYFReVJobCs760Fn9F1zubxOoDRvmRmwRiU1kM0beEHsM8FjgrRCK4Y5vJ4A
         i3fA==
X-Gm-Message-State: AOAM532ohaL5OdmCQ39GpjctgNpEdwUrF6rvoYu70PPgwbSy8GlmgxnA
        gy50l+tTFh2Cr8RBMHnc3spEPQ==
X-Google-Smtp-Source: ABdhPJz3XKub0XpZWCPKgN83lov2zPfROr1OuCkJt6Yz/rVIq3RO5XmJdbLmI8Pwc9ew4RaKAI8adA==
X-Received: by 2002:a17:90b:1106:: with SMTP id gi6mr1627653pjb.70.1604654747918;
        Fri, 06 Nov 2020 01:25:47 -0800 (PST)
Received: from localhost ([122.172.12.172])
        by smtp.gmail.com with ESMTPSA id 17sm1360293pfu.160.2020.11.06.01.25.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 01:25:47 -0800 (PST)
Date:   Fri, 6 Nov 2020 14:55:45 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     zhuguangqing83@gmail.com
Cc:     amit.kachhap@gmail.com, daniel.lezcano@linaro.org,
        javi.merino@kernel.org, rui.zhang@intel.com, amitk@kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhuguangqing <zhuguangqing@xiaomi.com>,
        "v5 . 4+" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] thermal/drivers/cpufreq_cooling: Update cpufreq_state
 only if state has changed
Message-ID: <20201106092545.2elo5o73ku3wj73b@vireshk-i7>
References: <20201106092243.15574-1-zhuguangqing83@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106092243.15574-1-zhuguangqing83@gmail.com>
User-Agent: NeoMutt/20180716-391-311a52
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06-11-20, 17:22, zhuguangqing83@gmail.com wrote:
> From: Zhuguangqing <zhuguangqing@xiaomi.com>
> 
> If state has not changed successfully and we updated cpufreq_state,
> next time when the new state is equal to cpufreq_state (not changed
> successfully last time), we will return directly and miss a
> freq_qos_update_request() that should have been.
> 
> Fixes: 5130802ddbb1 ("thermal: cpu_cooling: Switch to QoS requests for freq limits")
> Cc: v5.4+ <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Zhuguangqing <zhuguangqing@xiaomi.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> v2:
>   - Add Fixes: 5130802ddbb1 in log.
>   - Add Cc: v5.4+ <stable@vger.kernel.org> # v5.4+ in log.
>   - Add Acked-by: Viresh Kumar <viresh.kumar@linaro.org> in log.
>   - Delete an extra blank line.
> ---
>  drivers/thermal/cpufreq_cooling.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
> index cc2959f22f01..612f063c1cfc 100644
> --- a/drivers/thermal/cpufreq_cooling.c
> +++ b/drivers/thermal/cpufreq_cooling.c
> @@ -438,13 +438,11 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
>  	if (cpufreq_cdev->cpufreq_state == state)
>  		return 0;
>  
> -	cpufreq_cdev->cpufreq_state = state;
> -
>  	frequency = get_state_freq(cpufreq_cdev, state);
>  
>  	ret = freq_qos_update_request(&cpufreq_cdev->qos_req, frequency);
> -
>  	if (ret > 0) {
> +		cpufreq_cdev->cpufreq_state = state;
>  		cpus = cpufreq_cdev->policy->cpus;
>  		max_capacity = arch_scale_cpu_capacity(cpumask_first(cpus));
>  		capacity = frequency * max_capacity;

Thanks Zhuguangqing.

-- 
viresh
