Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF49E577E4B
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 11:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiGRJEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 05:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbiGRJE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 05:04:29 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B8B1A061
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 02:04:24 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id va17so20093588ejb.0
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 02:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monstr-eu.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3y6mB0hrnaV46VnRdVCEKqtLVV2m+vYW81yoBr+fw0w=;
        b=lazb5AJju1MIZiojh4ugOqp3SpUeeN4m9pS4gWOOnJbgrHukSBCMpnqykr4R6rEOKM
         po8QLW0Y+VzxM3g1dOM7i/6BAjT9Q9BlTiTVmrac89YvdKky0kmYJSAp/0HX4drLUcFc
         L41YTwau745fy7DAYoCjPMWpCEEOgB5YsZnp05gpatqBMCwI1wZeO9eylWprvWs6OY00
         cqoSUOmPUNMqhMS1tjqK0Ax6pFAhDGVEAVwrgkC1jZ9cXJo9Yxzy3mi/WgjQ8ny0z9Ii
         BHOPafrZBMcQWqNHyW1SIPdatfxNXyzNbBUOiCILDiq+iys5YIJoEne7lul8CoZkG7Qp
         1dLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3y6mB0hrnaV46VnRdVCEKqtLVV2m+vYW81yoBr+fw0w=;
        b=FoOLIj8+LNJgmS4zQbsXW/b2fGjMyRV/yyOFXOoA4tGOC1kjiikrMr6de0WXaubIA9
         qkO5WUPAeYS8FjGNtLYJwsVp9AXax1WVqeCbJEML0UuwUDIL5XR3IQ+vmxA+D+Sm8zbL
         phfHu/4LnPqEnR0s1kE3nPh1RackcOQgY8zSHXpZ3rG4dzO0oI+pnse0IyDmxUnAO/+n
         PKg90/cDWUolS4pzRVXV6BRm2d1JT9MaR7KpJ5mpvSk5KN+OvRo0oRD4Kgvae5Rd8OOz
         K3CwOWrgEnOFNYU9U2pZa8MdhvUsmbMHbIbo9M9MmN8B9VBGXt4DT7jw2U+dxDqzlj0A
         MK1A==
X-Gm-Message-State: AJIora+dg5C/4P+6NeKo3tefPYgkNHTZ5ysKrxaauGOTR1idofXudMgT
        flnYxh5QfuvA/MArRH5Fb0j9SQ==
X-Google-Smtp-Source: AGRyM1shiX+UWsxgu56aWSxDBQiM5H9sYKjZglHKR9uDIypb1Ru+e71R8EEH25Apr7Yq430Wp4Nzhg==
X-Received: by 2002:a17:907:2d2b:b0:72b:546a:bd03 with SMTP id gs43-20020a1709072d2b00b0072b546abd03mr25807330ejc.149.1658135062709;
        Mon, 18 Jul 2022 02:04:22 -0700 (PDT)
Received: from ?IPV6:2a02:768:2307:40d6::f9e? ([2a02:768:2307:40d6::f9e])
        by smtp.gmail.com with ESMTPSA id u15-20020a056402064f00b0043a6c538047sm8259072edx.70.2022.07.18.02.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 02:04:21 -0700 (PDT)
Message-ID: <9cc11fd0-28c7-fd0d-fe55-cce0bb5e92a7@monstr.eu>
Date:   Mon, 18 Jul 2022 11:04:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4/6] MicroBlaze: cpuinfo: Fix a warning for
 CONFIG_CPUMASK_OFFSTACK
Content-Language: en-US
To:     Huacai Chen <chenhuacai@loongson.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     loongarch@lists.linux.dev, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huacai Chen <chenhuacai@gmail.com>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-sh@vger.kernel.org, linux-um@lists.infradead.org,
        stable@vger.kernel.org
References: <20220712075255.1345991-1-chenhuacai@loongson.cn>
 <20220712075255.1345991-4-chenhuacai@loongson.cn>
From:   Michal Simek <monstr@monstr.eu>
In-Reply-To: <20220712075255.1345991-4-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/12/22 09:52, Huacai Chen wrote:
> When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> cpu_max_bits_warn() generates a runtime warning similar as below while
> we show /proc/cpuinfo. Fix this by using nr_cpu_ids (the runtime limit)
> instead of NR_CPUS to iterate CPUs.
> 
> [    3.052463] ------------[ cut here ]------------
> [    3.059679] WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:108 show_cpuinfo+0x5e8/0x5f0
> [    3.070072] Modules linked in: efivarfs autofs4
> [    3.076257] CPU: 0 PID: 1 Comm: systemd Not tainted 5.19-rc5+ #1052
> [    3.099465] Stack : 9000000100157b08 9000000000f18530 9000000000cf846c 9000000100154000
> [    3.109127]         9000000100157a50 0000000000000000 9000000100157a58 9000000000ef7430
> [    3.118774]         90000001001578e8 0000000000000040 0000000000000020 ffffffffffffffff
> [    3.128412]         0000000000aaaaaa 1ab25f00eec96a37 900000010021de80 900000000101c890
> [    3.138056]         0000000000000000 0000000000000000 0000000000000000 0000000000aaaaaa
> [    3.147711]         ffff8000339dc220 0000000000000001 0000000006ab4000 0000000000000000
> [    3.157364]         900000000101c998 0000000000000004 9000000000ef7430 0000000000000000
> [    3.167012]         0000000000000009 000000000000006c 0000000000000000 0000000000000000
> [    3.176641]         9000000000d3de08 9000000001639390 90000000002086d8 00007ffff0080286
> [    3.186260]         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1c
> [    3.195868]         ...
> [    3.199917] Call Trace:
> [    3.203941] [<90000000002086d8>] show_stack+0x38/0x14c
> [    3.210666] [<9000000000cf846c>] dump_stack_lvl+0x60/0x88
> [    3.217625] [<900000000023d268>] __warn+0xd0/0x100
> [    3.223958] [<9000000000cf3c90>] warn_slowpath_fmt+0x7c/0xcc
> [    3.231150] [<9000000000210220>] show_cpuinfo+0x5e8/0x5f0
> [    3.238080] [<90000000004f578c>] seq_read_iter+0x354/0x4b4
> [    3.245098] [<90000000004c2e90>] new_sync_read+0x17c/0x1c4
> [    3.252114] [<90000000004c5174>] vfs_read+0x138/0x1d0
> [    3.258694] [<90000000004c55f8>] ksys_read+0x70/0x100
> [    3.265265] [<9000000000cfde9c>] do_syscall+0x7c/0x94
> [    3.271820] [<9000000000202fe4>] handle_syscall+0xc4/0x160
> [    3.281824] ---[ end trace 8b484262b4b8c24c ]---
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>   arch/microblaze/kernel/cpu/mb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/microblaze/kernel/cpu/mb.c b/arch/microblaze/kernel/cpu/mb.c
> index 9581d194d9e4..689de7f75614 100644
> --- a/arch/microblaze/kernel/cpu/mb.c
> +++ b/arch/microblaze/kernel/cpu/mb.c
> @@ -137,7 +137,7 @@ static void *c_start(struct seq_file *m, loff_t *pos)
>   {
>   	int i = *pos;
>   
> -	return i < NR_CPUS ? (void *) (i + 1) : NULL;
> +	return i < nr_cpu_ids ? (void *) (i + 1) : NULL;
>   }
>   
>   static void *c_next(struct seq_file *m, void *v, loff_t *pos)

As was said in m68k thread commit message should be fixed. MB upstream in not 
SMP. We have SMP configuration in soc vendor tree but upstream we can't enable 
DEBUG_PER_CPU_MAPS which depends on SMP. But definitely worth to fix it.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Xilinx Microblaze
Maintainer of Linux kernel - Xilinx Zynq ARM and ZynqMP ARM64 SoCs
U-Boot custodian - Xilinx Microblaze/Zynq/ZynqMP/Versal SoCs

