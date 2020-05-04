Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489631C48D2
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 23:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgEDVOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 17:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726334AbgEDVOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 17:14:00 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFDEC061A0E
        for <stable@vger.kernel.org>; Mon,  4 May 2020 14:13:59 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id z6so282750plk.10
        for <stable@vger.kernel.org>; Mon, 04 May 2020 14:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=O/LbpJnPhVHmNihaVc3Tkl9gnztDmWEWrxGREVa1cKw=;
        b=qpkvPm7a4ESLZBP5G3g1wc2r5HbiLS1AYPBRTvjhNxfuT2rV81ivr/0Z4oADq46OM+
         ov0GjQPrHWiYkMCsAM/fLmJWmK8T1LnMhbNwDweZ/fSivQYbOfYxaCfgknf2rszTNs4R
         4d9OB+ygqA1xrKZIkkvlUHdaHIjEzBweG2bKAU9ERaCZmIXF5rNw+Asq0YULTUxtxEHq
         KPwMaCygvtWXOpEG3B24IV4IJE31Acd+QqY5/0qBg875vnzS6jwHgrGqT9sF1I661yJN
         dbhJLaONbulAxbGpcgo68iyJp+gsKEhGrM5GGDWrWjSIOou+Osm9w5T799o/Hz/xU0dq
         n2Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=O/LbpJnPhVHmNihaVc3Tkl9gnztDmWEWrxGREVa1cKw=;
        b=kh93IHlxZjaYfzq77SUopVcC3kLE1nTYXqwm6mUmVOCtDRYv0CWc0mwl6Gcwdp2a+R
         vgVDmD0jc0o4qCFr+dqKdt/BXcykLfirh5Fk4n9g4ylEU7pzlpSJkLXmwcMU7L6L2YTE
         5dfGETU1rs47rnvIbsaplWtmkauI9AcaSDyOJXfjbKJ74TAjw5rnS9norKkynyddTkH9
         XtIU95J6igPsmpFUxdOyNUXgWwtQWahU8yaRbFWjoXcfb0uIlKWbZZcuoo96ng87TzLO
         OX2OZzqXg86Y+YD2233re/b7+IvFh6TJcShhMUIVRSzquqceDVIZuzbbln5Avyz3qxFW
         Q86g==
X-Gm-Message-State: AGi0PuYJsHCGFS7u9j4c4yBzdGNrbe4D8v9i+uxRCwc4Z0+8AdXm0oMa
        coJI2bnJvy3XGZqeGF7UlzZw0pIMvgGb8A==
X-Google-Smtp-Source: APiQypLZ6S4t4a9i3wmdcCw8yGySraGf81OTeSD16fInrEjO1bn6FXYsh4NgOtvbSlomLa8Y+1h7vw==
X-Received: by 2002:a17:90a:780d:: with SMTP id w13mr120832pjk.20.1588626838433;
        Mon, 04 May 2020 14:13:58 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id h12sm9694904pfq.176.2020.05.04.14.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 14:13:57 -0700 (PDT)
Date:   Mon, 04 May 2020 14:13:57 -0700 (PDT)
X-Google-Original-Date: Mon, 04 May 2020 14:13:20 PDT (-0700)
Subject:     Re: [PATCH v3] riscv: set max_pfn to the PFN of the last page
In-Reply-To: <1587970764-4393-1-git-send-email-vincent.chen@sifive.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        linux-riscv@lists.infradead.org, vincent.chen@sifive.com,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     vincent.chen@sifive.com
Message-ID: <mhng-75f253d6-21f7-47be-a163-62c232ade694@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 26 Apr 2020 23:59:24 PDT (-0700), vincent.chen@sifive.com wrote:
> The current max_pfn equals to zero. In this case, I found it caused users
> cannot get some page information through /proc such as kpagecount in v5.6
> kernel because of new sanity checks. The following message is displayed by
> stress-ng test suite with the command "stress-ng --verbose --physpage 1 -t
> 1" on HiFive unleashed board.
>
>  # stress-ng --verbose --physpage 1 -t 1
>  stress-ng: debug: [109] 4 processors online, 4 processors configured
>  stress-ng: info: [109] dispatching hogs: 1 physpage
>  stress-ng: debug: [109] cache allocate: reducing cache level from L3 (too high) to L0
>  stress-ng: debug: [109] get_cpu_cache: invalid cache_level: 0
>  stress-ng: info: [109] cache allocate: using built-in defaults as no suitable cache found
>  stress-ng: debug: [109] cache allocate: default cache size: 2048K
>  stress-ng: debug: [109] starting stressors
>  stress-ng: debug: [109] 1 stressor spawned
>  stress-ng: debug: [110] stress-ng-physpage: started [110] (instance 0)
>  stress-ng: error: [110] stress-ng-physpage: cannot read page count for address 0x3fd34de000 in /proc/kpagecount, errno=0 (Success)
>  stress-ng: error: [110] stress-ng-physpage: cannot read page count for address 0x3fd32db078 in /proc/kpagecount, errno=0 (Success)
>  ...
>  stress-ng: error: [110] stress-ng-physpage: cannot read page count for address 0x3fd32db078 in /proc/kpagecount, errno=0 (Success)
>  stress-ng: debug: [110] stress-ng-physpage: exited [110] (instance 0)
>  stress-ng: debug: [109] process [110] terminated
>  stress-ng: info: [109] successful run completed in 1.00s
>  #
>
> After applying this patch, the kernel can pass the test.
>
>  # stress-ng --verbose --physpage 1 -t 1
>  stress-ng: debug: [104] 4 processors online, 4 processors configured stress-ng: info: [104] dispatching hogs: 1 physpage
>  stress-ng: info: [104] cache allocate: using defaults, can't determine cache details from sysfs
>  stress-ng: debug: [104] cache allocate: default cache size: 2048K
>  stress-ng: debug: [104] starting stressors
>  stress-ng: debug: [104] 1 stressor spawned
>  stress-ng: debug: [105] stress-ng-physpage: started [105] (instance 0) stress-ng: debug: [105] stress-ng-physpage: exited [105] (instance 0) stress-ng: debug: [104] process [105] terminated
>  stress-ng: info: [104] successful run completed in 1.01s
>  #
>
> Fixes: 0651c263c8e3 (RISC-V: Move setup_bootmem() to mm/init.c)
> Cc: stable@vger.kernel.org
>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Reviewed-by: Yash Shah <yash.shah@sifive.com>
> Tested-by: Yash Shah <yash.shah@sifive.com>
>
> Changes since v1:
> 1. Add Fixes line and Cc stable kernel
> Changes since v2:
> 1. Fix typo in Anup email address
> ---
>  arch/riscv/mm/init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index fab855963c73..157924baa191 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -149,7 +149,8 @@ void __init setup_bootmem(void)
>  	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
>
>  	set_max_mapnr(PFN_DOWN(mem_size));
> -	max_low_pfn = PFN_DOWN(memblock_end_of_DRAM());
> +	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
> +	max_low_pfn = max_pfn;
>
>  #ifdef CONFIG_BLK_DEV_INITRD
>  	setup_initrd();

I'm dropping the Fixes tag, as the actual bug goes back farther than that
commit, that's just as far as it'll auto-apply.
