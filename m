Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4374252F6D6
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 02:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347510AbiEUAc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 20:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiEUAc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 20:32:58 -0400
Received: from mail-oi1-x261.google.com (mail-oi1-x261.google.com [IPv6:2607:f8b0:4864:20::261])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F118B1966A1
        for <stable@vger.kernel.org>; Fri, 20 May 2022 17:32:56 -0700 (PDT)
Received: by mail-oi1-x261.google.com with SMTP id v66so11742959oib.3
        for <stable@vger.kernel.org>; Fri, 20 May 2022 17:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:date:from:to:cc:subject
         :message-id:references:content-disposition:in-reply-to;
        bh=uKGN50vu+4GfXG0sgHNA4qzCjapPU1Kse30oS1F+Mz0=;
        b=Ar/gEWntGtfJdwAE7jr66Wu8aM22Ym+6WWDpl37hSpIt64KDitm6Su5mkRugRQ26xR
         PdL5ELasEx/JU7mFNWspH9dwSsZZH7Mj7shkcwk9OHwUZHBy9TENFSBnur99JkxBGNjE
         n43TN5oTI4QejcVlyvh0VlHsR3XI/LSzFiysObf8MEl+mgp2NnRqp/+OuqC1ULZ5EywP
         O7AqjQ6YMlD6jVnO4eeNzn7704Wy3s52HnDnl50fNHT6ZQaepQphftJHut3Pik393OPR
         MJYLwE04vmXdB+UBEpGgQhd8xY/dn6gra81Oaalt7LVzEL/PERK2LC5Cm8bxFJel8+Nk
         LeTQ==
X-Gm-Message-State: AOAM5325Mh6WRgvoMg3w7lW6UgVeLvpFeRwr/fgTSBOqmqXn/YTsjTK7
        o/4rXy4cpIeGF3u1PL0Rlvu9Yj0KfWM58pbQXYI4hWygU9ES
X-Google-Smtp-Source: ABdhPJx5Tde5W9mWXWJv9R/IlJRR5cVmbZkn08TLXsh8C2TlLikx0u1fk85XfVyZOK7sa3+S/ewkQqnUitbo
X-Received: by 2002:a05:6808:3021:b0:2f7:4c5b:2783 with SMTP id ay33-20020a056808302100b002f74c5b2783mr6926937oib.53.1653093176066;
        Fri, 20 May 2022 17:32:56 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [54.193.82.35])
        by smtp-relay.gmail.com with ESMTPS id x19-20020a4a4113000000b0035ecc74f8b3sm296899ooa.3.2022.05.20.17.32.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 May 2022 17:32:56 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.70.242])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 1EC2E3047DE0;
        Fri, 20 May 2022 17:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1653093175;
        bh=uKGN50vu+4GfXG0sgHNA4qzCjapPU1Kse30oS1F+Mz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0DyVyJXJt4FYoH8Kv0cX4olYdnqzSuA4lBBROmFHad3DGAhawAeQkq3DanjUAyYyv
         ImkqFFtFUHvijhmZuNkN3DNSfJBhmRNbi6GWHwNRoYBUs6VpTIqIs5c4g9spoAAMqL
         /ex/H6i0JBWv2wnR1xrrfbcf8t2ILB6T7P4H5QN1t4m6QbxhTJtqvXZYZZA9QKgPgd
         t+f6Z8xIQNFb44GPzld79gtzN67mS+Q5cqwBcH4lg4co5S8Q4KKc/i7jOjzU8KM7bI
         DUoOc4kk1/+H0lg1e5FgyCZbnREHrklWrgqVlUF8mP1ug0j/mjLgC5KPaFUDir95EQ
         almPQRMxyu44w==
Received: from kevmitch by chmeee with local (Exim 4.95)
        (envelope-from <kevmitch@arista.com>)
        id 1nsD37-001pZX-EI;
        Fri, 20 May 2022 17:32:53 -0700
Date:   Fri, 20 May 2022 17:32:52 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        David Rientjes <rientjes@google.com>,
        Dou Liyang <douly.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mpparse: avoid overwriting
 boot_cpu_physical_apicid
Message-ID: <YogzNIs7uBSaX1gE@chmeee>
References: <20200609004451.1296880-1-kevmitch@arista.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609004451.1296880-1-kevmitch@arista.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 05:44:48PM -0700, Kevin Mitchell wrote:
> When booting with ACPI unavailable or disabled, get_smp_config() ends up
> calling MP_processor_info() for each CPU found in the MPS
> table. Previously, this resulted in boot_cpu_physical_apicid getting
> unconditionally overwritten by the apicid of whatever processor had the
> CPU_BOOTPROCESSOR flag. This occurred even if boot_cpu_physical_apicid
> had already been more reliably determined in register_lapic_address() by
> calling read_apic_id() from the actual boot processor.
> 
> Ordinariliy, this is not a problem because the boot processor really is
> the one with the CPU_BOOTPROCESSOR flag. However, kexec is an exception
> in which the kernel may be booted from any processor regardless of the
> MPS table contents. In this case, boot_cpu_physical_apicid may not
> indicate the actual boot processor.
> 
> This was particularly problematic when the second kernel was booted with
> NR_CPUS fewer than the number of physical processors. It's the job of
> generic_processor_info() to decide which CPUs to bring up in this case.
> That obviously must include the real boot processor which it takes care
> to save a slot for. It relies upon the contents of
> boot_cpu_physical_apicid to do this, which if incorrect, may result in
> the boot processor getting left out.
> 
> This condition can be discovered by smp_sanity_check() and rectified by
> adding the boot processor to the phys_cpu_present_map with the warning
> "weird, boot CPU (#%d) not listed by the BIOS". However, commit
> 3e730dad3b6da ("x86/apic: Unify interrupt mode setup for SMP-capable
> system") caused setup_local_APIC() to be called before this could happen
> resulting in a BUG_ON(!apic->apic_id_registered()):
> 
> [    0.655452] ------------[ cut here ]------------
> [    0.660610] Kernel BUG at setup_local_APIC+0x74/0x280 [verbose debug info unavailable]
> [    0.669466] invalid opcode: 0000 [#1] SMP
> [    0.673948] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.19.109.Ar-16509018.eostrunkkernel419 #1
> [    0.683670] Hardware name: Quanta Quanta LY6 (1LY6UZZ0FBC), BIOS 1.0.6.0-e7d6a55 11/26/2015
> [    0.693007] RIP: 0010:setup_local_APIC+0x74/0x280
> [    0.698264] Code: 80 e4 fe bf f0 00 00 00 89 c6 48 8b 05 0f 1a 8e 00 ff 50 10 e8 12 53 fd ff 48 8b 05 00 1a 8e 00 ff 90 a0 00 00 00 85 c0 75 02 <0f> 0b 48 8b 05 ed 19 8e 00 41 be 00 02 00 00 ff 90 b0 00 00 00 48
> [    0.719251] RSP: 0000:ffffffff81a03e20 EFLAGS: 00010246
> [    0.725091] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> [    0.733066] RDX: 0000000000000000 RSI: 000000000000000f RDI: 0000000000000020
> [    0.741041] RBP: ffffffff81a03e98 R08: 0000000000000002 R09: 0000000000000000
> [    0.749014] R10: ffffffff81a204e0 R11: ffffffff81b50ea7 R12: 0000000000000000
> [    0.756989] R13: ffffffff81aef920 R14: ffffffff81af60a0 R15: 0000000000000000
> [    0.764965] FS:  0000000000000000(0000) GS:ffff888036800000(0000) knlGS:0000000000000000
> [    0.774007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.780427] CR2: ffff888035c01000 CR3: 0000000035a08000 CR4: 00000000000006b0
> [    0.788401] Call Trace:
> [    0.791137]  ? amd_iommu_prepare+0x15/0x2a
> [    0.795717]  apic_bsp_setup+0x55/0x75
> [    0.799808]  apic_intr_mode_init+0x169/0x16e
> [    0.804579]  x86_late_time_init+0x10/0x17
> [    0.809062]  start_kernel+0x37e/0x3fe
> [    0.813154]  x86_64_start_reservations+0x2a/0x2c
> [    0.818316]  x86_64_start_kernel+0x72/0x75
> [    0.822886]  secondary_startup_64+0xa4/0xb0
> [    0.827564] ---[ end trace 237b64da0fd9b22e ]---
> 
> This change avoids these issues by only setting boot_cpu_physical_apicid
> from the MPS table if it is not already set, which can occur in the
> construct_default_ISA_mptable() path. Otherwise,
> boot_cpu_physical_apicid will already have been set in
> register_lapic_address() and should therefore remain untouched.
> 
> Looking through all the places where boot_cpu_physical_apicid is
> accessed, nearly all of them assume that boot_cpu_physical_apicid should
> match read_apic_id() on the booting processor. The only place that might
> intend to use the BSP apicid listed in the MPS table is amd_numa_init(),
> which explicitly requires boot_cpu_physical_apicid to be the lowest
> apicid of all processors. Ironically, due to the early exit short
> circuit in early_get_smp_config(), it instead gets
> boot_cpu_physical_apicid = read_apic_id() rather than the MPS table
> BSP. The behaviour of amd_numa_init() is therefore unaffected by this
> change.
> 
> Fixes: 3e730dad3b6da ("x86/apic: Unify interrupt mode setup for SMP-capable system")
> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/kernel/mpparse.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> index afac7ccce72f..6f22f09bfe11 100644
> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c
> @@ -64,7 +64,8 @@ static void __init MP_processor_info(struct mpc_cpu *m)
>  
>  	if (m->cpuflag & CPU_BOOTPROCESSOR) {
>  		bootup_cpu = " (Bootup-CPU)";
> -		boot_cpu_physical_apicid = m->apicid;
> +		if (boot_cpu_physical_apicid == -1U)
> +			boot_cpu_physical_apicid = m->apicid;
>  	}
>  
>  	pr_info("Processor #%d%s\n", m->apicid, bootup_cpu);
> -- 
> 2.26.2
> 

We've moved on to our next kernel upgrade to linux-5.10 and are still seeing
this same issue with the upstream kernel. We will therefore be porting this
patch forward, but still wondering if there is any interest in getting this into
the mainline kernel so more people get (more) correct code? Both patches still
apply to the mainline (linux-5.18-rc7 right now). Are there any
alternative suggestions for avoiding this BUG_ON on kexec?
