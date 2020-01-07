Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57820133713
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 00:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgAGXI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 18:08:28 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36011 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgAGXI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 18:08:28 -0500
Received: by mail-oi1-f193.google.com with SMTP id c16so1045920oic.3;
        Tue, 07 Jan 2020 15:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Me8p44OHEqgPZhBG5+FV+ac90SFtMdoqaV35MndRxEM=;
        b=hijSl3niO27gP0mmOWLLGPyLQ/8rPj0i20vGWj9ly71XDolju6F7wLF7A7Ik+ZC83h
         swkbBGXVTGn9gohkiEboOfEH020Ec5WdI4pmvCQq6/KxbtL9k43I6iOKdp88GFDWd4FX
         QhuxWOKC/SPlfIm3xI2cHzUnH9XnPsz0QGbgRtUCSjKdIb08ounyAllVl1fohUuTMMSJ
         0lhEH4CxBSi55Gw2A4at7k9eWixIHo5IjWtFRMTIgb8bRxW8GMednbYcF4isUZzKSojO
         j/MB7dluxUvu8kwKmqwfLSdlmDw+D5noZVHBpWR+uUfp+Mp+uKOBPYQPLwn1B4GaT/bv
         rJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Me8p44OHEqgPZhBG5+FV+ac90SFtMdoqaV35MndRxEM=;
        b=DMV8GCbvYIkg2Feil2hzwmi9yqbRT6pu4KTYxsBOkygRb/ll27A7LTA9yM/5ocESoe
         lklVhlBftwMSqtJzDImM2HMIGdp+Af5iGeuKjhc2pJH3mx7HF3tyRM7ZrhKI+ul15sf+
         moUxERa50JBdZE62AoXqg7lfGJ+EvZLnE4ek0t8tmM/6gGBQ0uWNeTNxfryw4IVrNLVp
         TUp4bEz3ptpYwUMlYMZbLJHm3u0YP0d5w9raXx8cPUBn/BZGCs9trbwEDMUNktQd1mbl
         ATO6/Oh9lJ1p3E1hoJlWqsZK1rx5GzIg/owo/V5HbuTQBVlG5m19YtxzHX+b8uru4W11
         BLaQ==
X-Gm-Message-State: APjAAAWbMB/GBTy6dmy/a9D2p3GfLYj6H134kUw0hBAurkUs5Tu0GRNb
        4f+MCQlYAMHcTreyDmo3MXc=
X-Google-Smtp-Source: APXvYqzsCDZaKQuQmzyP3J+5LbIO/RG9HR1AzTfJ4Td96j2kx5cdk1Ti8pUR43TlXjf3SWeN1DPymA==
X-Received: by 2002:a54:4896:: with SMTP id r22mr760564oic.30.1578438507108;
        Tue, 07 Jan 2020 15:08:27 -0800 (PST)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id n25sm454794oic.6.2020.01.07.15.08.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 15:08:26 -0800 (PST)
Date:   Tue, 7 Jan 2020 16:08:25 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 65/74] coresight: tmc-etf: Do not call
 smp_processor_id from preemptible
Message-ID: <20200107230825.GA26430@ubuntu-m2-xlarge-x86>
References: <20200107205135.369001641@linuxfoundation.org>
 <20200107205228.054429793@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107205228.054429793@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 09:55:30PM +0100, Greg Kroah-Hartman wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> [ Upstream commit 024c1fd9dbcc1d8a847f1311f999d35783921b7f ]
> 
> During a perf session we try to allocate buffers on the "node" associated
> with the CPU the event is bound to. If it is not bound to a CPU, we
> use the current CPU node, using smp_processor_id(). However this is unsafe
> in a pre-emptible context and could generate the splats as below :
> 
>  BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
>  caller is tmc_alloc_etf_buffer+0x5c/0x60
>  CPU: 2 PID: 2544 Comm: perf Not tainted 5.1.0-rc6-147786-g116841e #344
>  Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Feb  1 2019
>  Call trace:
>   dump_backtrace+0x0/0x150
>   show_stack+0x14/0x20
>   dump_stack+0x9c/0xc4
>   debug_smp_processor_id+0x10c/0x110
>   tmc_alloc_etf_buffer+0x5c/0x60
>   etm_setup_aux+0x1c4/0x230
>   rb_alloc_aux+0x1b8/0x2b8
>   perf_mmap+0x35c/0x478
>   mmap_region+0x34c/0x4f0
>   do_mmap+0x2d8/0x418
>   vm_mmap_pgoff+0xd0/0xf8
>   ksys_mmap_pgoff+0x88/0xf8
>   __arm64_sys_mmap+0x28/0x38
>   el0_svc_handler+0xd8/0x138
>   el0_svc+0x8/0xc
> 
> Use NUMA_NO_NODE hint instead of using the current node for events
> not bound to CPUs.
> 
> Fixes: 2e499bbc1a929ac ("coresight: tmc: implementing TMC-ETF AUX space API")
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: stable <stable@vger.kernel.org> # 4.7+
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Link: https://lore.kernel.org/r/20190620221237.3536-4-mathieu.poirier@linaro.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hwtracing/coresight/coresight-tmc-etf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
> index 336194d059fe..329a201c0c19 100644
> --- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
> +++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
> @@ -308,9 +308,7 @@ static void *tmc_alloc_etf_buffer(struct coresight_device *csdev, int cpu,
>  	int node;
>  	struct cs_buffers *buf;
>  
> -	if (cpu == -1)
> -		cpu = smp_processor_id();
> -	node = cpu_to_node(cpu);
> +	node = (event->cpu == -1) ? NUMA_NO_NODE : cpu_to_node(event->cpu);

This breaks the build on 4.14 (and I believe 4.19 from the looks of it)
because the event variable is not available without
commit a0f08a6a9fee ("coresight: Communicate perf event to sink buffer
allocation functions") from upstream. I am not sure how this should be
fixed (either backporting the above commit or changing this one somehow)
but it should be dropped in the meantime.

Cheers,
Nathan
