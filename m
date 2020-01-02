Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6888112E724
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 15:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgABONa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 09:13:30 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34176 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgABONa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 09:13:30 -0500
Received: by mail-pg1-f193.google.com with SMTP id r11so21967555pgf.1;
        Thu, 02 Jan 2020 06:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4VMARRBA+D6nTerX0WXryzqjbpeVos9bLGEszxT2t2A=;
        b=I3KGMqc4IcQtb4xEiCZRH4yPuIgzBhKv/sE9Zqio6/5flw1GsT4m52Jl0tL5NBEBb+
         aXl4L8tyYsWoOw4+G6VKEa6fb0V328tBMUnkDt/F77wwcYk69/FKNg55ZD7DmFx79IOK
         xYCM685IvSrkbDosxu7wxUh2HdejOPU/pQ55LdWl+jRe82nlc4NSd4PlqdLm2Z51Egh5
         o0c8/HHvVDLVj5YCufgppqNmXfwEjBav+JbyO0wPCcG/V6IHCaiT3sji8NurmI2UQ5og
         8V6apua8imTrvO9RxZqU1mEwO7XwryklSL7wuMpfUzQ/e/t8C8aV9THopt/vdtSuWCvi
         bzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4VMARRBA+D6nTerX0WXryzqjbpeVos9bLGEszxT2t2A=;
        b=KSYg0HXLnSSgnx0ZD6gfVdP+gy/pE1CrJi9+MFo05SrGrsvQgHYHFJ9NOMoktn5cNM
         BeQ5uIPbWJbZarS/9mblPEYmE1qZVHJOXsL1ihyD50Nah2O09FEtjoOrkmdNxnuYQ4nR
         u+K5tnbvIOSt1xJlNlqJbSq0/6haK9pe54rt51pOKkrz2EqIy5Uu1krT6D9G/7ZuFrK2
         1UZjemyz0CymvOYWwD8SjhB+tD+dvB50NqIEaWfXd9lDBlI3oDBdVbHPk74cuXuwucOT
         k0djlNZjTK5UIkLlmOCOmqZFRMXqRzNOghEiHr47t0Rbbi41RZdw4Qrumr4DsFSFm7bK
         f1Mg==
X-Gm-Message-State: APjAAAU1cGMFAN/Kn5isnqMj98HR7PT0vS3dnfkMS03nbinu0ARCmPjJ
        wH9XsCrkSVsllVWXh+BZAOTTw3cM
X-Google-Smtp-Source: APXvYqwe/Wy3T3Ksei9jcfi0zSioeQlwMRVogAy9C++J1RzLemh2s+c9j2XJxPBuipv3B5SCIbFZQw==
X-Received: by 2002:a63:1f16:: with SMTP id f22mr85757024pgf.2.1577974408569;
        Thu, 02 Jan 2020 06:13:28 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8sm64868650pfd.76.2020.01.02.06.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 06:13:27 -0800 (PST)
Subject: Re: Clock related crashes in v5.4.y-queue
To:     Stephen Boyd <sboyd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc:     linux-clk@vger.kernel.org
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <5869f050-7b3f-b950-bfb6-5601d2b30fbd@roeck-us.net>
 <20200102073058.662A9215A4@mail.kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <63d158e4-14ce-279f-1e77-eb50cb07b465@roeck-us.net>
Date:   Thu, 2 Jan 2020 06:13:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102073058.662A9215A4@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/1/20 11:30 PM, Stephen Boyd wrote:
> (Happy New Year!)
> 
> Quoting Guenter Roeck (2020-01-01 19:41:40)
>> On 1/1/20 6:44 PM, Guenter Roeck wrote:
>>> Hi,
>>>
>>> I see a number of crashes in the latest v5.4.y-queue; please see below
>>> for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
>>> leak in clk_unregister()").
>>>
>>> The context suggests recovery from a failed driver probe, and it appears
>>> that the memory is released twice. Interestingly, I don't see the problem
>>> in mainline.
>>>
>>
>> The reason for not seeing the crash in mainline is that macb_probe()
>> doesn't fail there due to unrelated changes in the driver. If I force
>> macb_probe() to fail in mainline, I see exactly the same crash.
>>
>> Effectively this means that upstream commit 8247470772be is broken;
>> it may fix a memory leak in some situations, but it results in UAF
>> and crashes otherwise.
>>
>> Stephen, any comments ? I must admit that I don't understand the clock
>> code nor the commit in question; I would have assumed that the call
>> to __clk_put() would release the clk data structure, not an explicit
>> call to kfree().
> 
> The clk that the commit from Kishon is freeing is the first "consumer
> handle" that we make when a clk is registered. That is returned to
> anyone that calls clk_register(), or if the provider decides to access
> clk_hw::clk directly, which is not desired but still exists for
> historical reasons. It is also used when drivers call clk_get_parent()
> and that API currently fails to reference count or even create a
> per-call clk pointer.
> 
> The general idea is that each user of clk_get() should get a different
> struct clk pointer to use. The problem is we have this semi-internal
> struct clk pointer that leaks out of clk_get_parent(), __clk_lookup()
> and clk_register().
> 
> Maybe someone is calling clk_unregister() twice with the same pointer
> they got through different ways? The macb driver does some questionable

I think it is clk_unregister() followed by __clk_put(), but yes, it looks
like that is what is happening.

> things, like calling clk_register() and then putting the returned
> pointer into *tx_clk, but only for the sifive implementation. After that
> it does even odder things, like calling clk_unregister() on a clk that
> probably shouldn't be unregistered, except for on the sifive platforms
> that register it. Pretty horrifying that clk_unregister() gives any
> consumer the power to destroy a clk from the system!
> 
> Can you try this patch? I think by fixing the leak we've discovered more
> problems.
> 

Yes, it does.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

> ----8<----
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 9c767ee252ac..7dce403fd27c 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4069,7 +4069,7 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
>   	mgmt->rate = 0;
>   	mgmt->hw.init = &init;
>   
> -	*tx_clk = clk_register(NULL, &mgmt->hw);
> +	*tx_clk = devm_clk_register(&pdev->dev, &mgmt->hw);
>   	if (IS_ERR(*tx_clk))
>   		return PTR_ERR(*tx_clk);
>   
> @@ -4397,7 +4397,6 @@ static int macb_probe(struct platform_device *pdev)
>   
>   err_disable_clocks:
>   	clk_disable_unprepare(tx_clk);
> -	clk_unregister(tx_clk);
>   	clk_disable_unprepare(hclk);
>   	clk_disable_unprepare(pclk);
>   	clk_disable_unprepare(rx_clk);
> @@ -4427,7 +4426,6 @@ static int macb_remove(struct platform_device *pdev)
>   		pm_runtime_dont_use_autosuspend(&pdev->dev);
>   		if (!pm_runtime_suspended(&pdev->dev)) {
>   			clk_disable_unprepare(bp->tx_clk);
> -			clk_unregister(bp->tx_clk);
>   			clk_disable_unprepare(bp->hclk);
>   			clk_disable_unprepare(bp->pclk);
>   			clk_disable_unprepare(bp->rx_clk);
> 
>>
>> Guenter
>>
>>> I would suggest to drop that patch from the stable queue.
>>>
>>> Guenter
>>>
>>> ---
>>> First traceback is:
>>>
>>> [   19.203547] ------------[ cut here ]------------
>>> [   19.204107] WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:4034 __clk_put+0xfc/0x128
> 
> Presumably this is the
> 
> 	WARN_ON_ONCE(IS_ERR(clk))
> 
> in __clk_put()? Or is it the exclusive count check that is getting
> tricked out because of page poisoning?
> 
> I guess we should put that in some sort of text form of warning instead
> of a not so helpful line number.
> 
>>> [   19.204275] Modules linked in:
>>> [   19.204634] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.8-rc1-00191-gaf408bc6c96e #1
>>> [   19.204790] Hardware name: Xilinx Zynq Platform
>>> [   19.204994] [<c0313658>] (unwind_backtrace) from [<c030d698>] (show_stack+0x10/0x14)
>>> [   19.205150] [<c030d698>] (show_stack) from [<c1139bdc>] (dump_stack+0xe0/0x10c)
>>> [   19.205278] [<c1139bdc>] (dump_stack) from [<c0349098>] (__warn+0xf4/0x10c)
>>> [   19.205399] [<c0349098>] (__warn) from [<c0349164>] (warn_slowpath_fmt+0xb4/0xbc)
>>> [   19.205522] [<c0349164>] (warn_slowpath_fmt) from [<c0956d14>] (__clk_put+0xfc/0x128)
>>> [   19.205654] [<c0956d14>] (__clk_put) from [<c0b1ea10>] (release_nodes+0x1c4/0x278)
>>> [   19.205780] [<c0b1ea10>] (release_nodes) from [<c0b1a220>] (really_probe+0x108/0x34c)
>>> [   19.205908] [<c0b1a220>] (really_probe) from [<c0b1a5dc>] (driver_probe_device+0x60/0x174)
>>> [   19.206042] [<c0b1a5dc>] (driver_probe_device) from [<c0b1a898>] (device_driver_attach+0x58/0x60)
>>> [   19.206179] [<c0b1a898>] (device_driver_attach) from [<c0b1a924>] (__driver_attach+0x84/0xc0)
>>> [   19.206313] [<c0b1a924>] (__driver_attach) from [<c0b18400>] (bus_for_each_dev+0x78/0xb8)
>>> [   19.206463] [<c0b18400>] (bus_for_each_dev) from [<c0b195e8>] (bus_add_driver+0x164/0x1e8)
>>> [   19.206590] [<c0b195e8>] (bus_add_driver) from [<c0b1b6fc>] (driver_register+0x74/0x108)
>>> [   19.206723] [<c0b1b6fc>] (driver_register) from [<c030315c>] (do_one_initcall+0x8c/0x3bc)
>>> [   19.206857] [<c030315c>] (do_one_initcall) from [<c1a01080>] (kernel_init_freeable+0x14c/0x1e8)
>>> [   19.206992] [<c1a01080>] (kernel_init_freeable) from [<c11547a4>] (kernel_init+0x8/0x118)
>>> [   19.207116] [<c11547a4>] (kernel_init) from [<c03010b4>] (ret_from_fork+0x14/0x20)
>>>
>>> followed by:
>>>
>>> [   19.209792] 8<--- cut here ---
>>> [   19.209926] Unable to handle kernel paging request at virtual address 6b6b6bb3
>>> [   19.210117] pgd = (ptrval)
>>> [   19.210207] [6b6b6bb3] *pgd=00000000
>>> [   19.210626] Internal error: Oops: 5 [#1] SMP ARM
>>> [   19.210807] Modules linked in:
>>> [   19.210956] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.4.8-rc1-00191-gaf408bc6c96e #1
>>> [   19.211090] Hardware name: Xilinx Zynq Platform
>>> [   19.211200] PC is at __clk_put+0x104/0x128
>>> [   19.211274] LR is at __clk_put+0xfc/0x128
>>> [   19.211349] pc : [<c0956d1c>]    lr : [<c0956d14>]    psr: 60000053
>>> [   19.211446] sp : c7129dd8  ip : 00000000  fp : c59f1680
>>> [   19.211534] r10: c72fb6ac  r9 : c0b1dbd0  r8 : 00000008
>>> [   19.211626] r7 : c7129e04  r6 : c72fb410  r5 : c59f0880  r4 : c59f3180
>>> [   19.211727] r3 : 7a538c1d  r2 : 6b6b6b6b  r1 : 6b6b6b6b  r0 : 00000000
>>> [   19.211885] Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
>>> [   19.212022] Control: 10c5387d  Table: 00204059  DAC: 00000051
>>> [   19.212152] Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
>>> [   19.212270] Stack: (0xc7129dd8 to 0xc712a000)
>>> [   19.212391] 9dc0:                                                       c59f1680 c59f0880
>>> [   19.212608] 9de0: c72fb410 c0b1ea10 ffffffed 00000000 c0b1e404 c7128000 c72fb410 a0000053
>>> [   19.212822] 9e00: c72fb68c c59f1c80 c59f1480 7a538c1d 00000001 c241e19c c72fb410 c241e1a0
>>> [   19.213029] 9e20: 00000000 c1d8a1ac 00000000 ffffffed c1b8124c c0b1a220 c72fb410 c1d8a1ac
>>> [   19.213240] 9e40: c1d8a1ac c7128000 c1dc347c 00000007 000001f6 c0b1a5dc c1d8a1ac c1d8a1ac
>>> [   19.213462] 9e60: c7128000 c72fb410 00000000 c1d8a1ac c7128000 c1dc347c 00000007 000001f6
>>> [   19.213683] 9e80: c1b8124c c0b1a898 00000000 c1d8a1ac c72fb410 c0b1a924 00000000 c1d8a1ac
>>> [   19.213899] 9ea0: c0b1a8a0 c0b18400 c70b50d4 c70b50a4 c725d210 7a538c1d c70b50d4 c1d8a1ac
>>> [   19.214115] 9ec0: c59f0280 c1d6dd50 00000000 c0b195e8 c185eb44 c1aab944 00000000 c1d8a1ac
>>> [   19.214343] 9ee0: c1aab944 00000000 c1c08468 c0b1b6fc c1dc46c0 c1aab944 00000000 c030315c
>>> [   19.214555] 9f00: c1959bf0 000001f6 000001f6 c0372600 00000000 c19574b8 c1883c18 00000000
>>> [   19.214783] 9f20: c7128000 c03b3f70 c7128000 c1dd1f00 c1c08468 c1ae7870 c1a00590 00000007
>>> [   19.215001] 9f40: 000001f6 c03d39b8 00000000 7a538c1d c1dc347c c1dd1f00 c1dd1f00 c1ae7850
>>> [   19.215214] 9f60: c1ae7870 c1a00590 00000007 c1a01080 00000006 00000006 00000000 c1a00590
>>> [   19.215429] 9f80: 00000000 00000000 c115479c 00000000 00000000 00000000 00000000 00000000
>>> [   19.215636] 9fa0: 00000000 c11547a4 00000000 c03010b4 00000000 00000000 00000000 00000000
>>> [   19.215843] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>>> [   19.216068] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
>>> [   19.216255] [<c0956d1c>] (__clk_put) from [<c0b1ea10>] (release_nodes+0x1c4/0x278)
>>> [   19.216376] [<c0b1ea10>] (release_nodes) from [<c0b1a220>] (really_probe+0x108/0x34c)
>>> [   19.216494] [<c0b1a220>] (really_probe) from [<c0b1a5dc>] (driver_probe_device+0x60/0x174)
>>> [   19.216617] [<c0b1a5dc>] (driver_probe_device) from [<c0b1a898>] (device_driver_attach+0x58/0x60)
>>> [   19.216745] [<c0b1a898>] (device_driver_attach) from [<c0b1a924>] (__driver_attach+0x84/0xc0)
>>> [   19.216867] [<c0b1a924>] (__driver_attach) from [<c0b18400>] (bus_for_each_dev+0x78/0xb8)
>>> [   19.216993] [<c0b18400>] (bus_for_each_dev) from [<c0b195e8>] (bus_add_driver+0x164/0x1e8)
>>> [   19.217112] [<c0b195e8>] (bus_add_driver) from [<c0b1b6fc>] (driver_register+0x74/0x108)
>>> [   19.217233] [<c0b1b6fc>] (driver_register) from [<c030315c>] (do_one_initcall+0x8c/0x3bc)
>>> [   19.217358] [<c030315c>] (do_one_initcall) from [<c1a01080>] (kernel_init_freeable+0x14c/0x1e8)
>>> [   19.217500] [<c1a01080>] (kernel_init_freeable) from [<c11547a4>] (kernel_init+0x8/0x118)
>>> [   19.217624] [<c11547a4>] (kernel_init) from [<c03010b4>] (ret_from_fork+0x14/0x20)
>>

