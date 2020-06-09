Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618221F2EF4
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgFIAqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbgFIApy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 20:45:54 -0400
Received: from mail-oi1-x262.google.com (mail-oi1-x262.google.com [IPv6:2607:f8b0:4864:20::262])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08560C03E969
        for <stable@vger.kernel.org>; Mon,  8 Jun 2020 17:45:54 -0700 (PDT)
Received: by mail-oi1-x262.google.com with SMTP id a3so5177908oid.4
        for <stable@vger.kernel.org>; Mon, 08 Jun 2020 17:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:content-transfer-encoding;
        bh=aM3H4KtnGL+PgPcPchRM5VYGjqUZm9ldRW8ECXkcMy4=;
        b=jtaBXKopSRLdWsqI84MnbTECdn1kDOf5dB3T9w815loqgC4yvogzFJrd/5xtvagUul
         43JehNCsrt5IRN0avv3ke/Hhj6uoX8vDCj6U2u1fGrvpOH1GgqAP0wsHAneLTxNRc26W
         d9Az90KOBQGt9bXWkEg0b2Ry9eajPMgKreVlZBa4Tzf7VGlybiZpbRHH2jp7xI8QvF57
         dfe/hIuvciOvvLrtWPFa1n64Ic66Rd7oP6/oMrpP8CkTnDft9hhkdL7WPiSlUrEgA5sz
         QNXMiGBD3Z50vknuOcgr2PynpRL6tGWe47kftsrTLqg6onK4AnPxLjwVftrxGw6CHhBc
         gOTQ==
X-Gm-Message-State: AOAM530lCNvKqXrdxfUGdBWTokK09hYAp0rEWQoSXDwol/jvr/vkVIy9
        DlmS0vhoABxNGsJ6Xwy6/KXEDpNEhQOcMJp0HsYeiIMCdkXS
X-Google-Smtp-Source: ABdhPJzqrXX0J/KC36eFF5LlLYj5tFarvag8WD82cgyyF6fbPjKMvCE2P7XxrK0+bslOvjXt47w9Eku+c9oc
X-Received: by 2002:aca:f141:: with SMTP id p62mr1630242oih.136.1591663552456;
        Mon, 08 Jun 2020 17:45:52 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [54.193.82.35])
        by smtp-relay.gmail.com with ESMTPS id l16sm1556693otn.1.2020.06.08.17.45.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2020 17:45:52 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.85.208])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 5514D30288A4;
        Mon,  8 Jun 2020 17:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1591663551;
        bh=aM3H4KtnGL+PgPcPchRM5VYGjqUZm9ldRW8ECXkcMy4=;
        h=From:To:Cc:Subject:Date:From;
        b=1HLg+512x5tnx6kZVgBwToFnHl5ogfS9sAtBAJ0Uq9yhWsLiIiVmJm/hcP18gQfc3
         9vskGJaER+ZCtkzKXUsnSS99lrstvb8E75ZgFwwZhKr+8PRXXmwCcZBs+s5pVIcivp
         OlGmvuL4sHpn9InOBjSrWI7sGiHj45Fwpuwk5LiaKGs9hwX19NOpXpmzLgfiE3QMhy
         61KZ28tRTbng4rAHOT/bAJzlB+DJv37Ob3KMmAJFPcIb4eAGPCJsJcXkTLpoHxdLPi
         h/4n/U5VC8Mku3KMl/Q4f/xCdCZi9wlaX/7SY9URNWlFlXjT2LyB4KGhVWR+bR/CyH
         oW91EP/e1eYvA==
Received: from kevmitch by chmeee with local (Exim 4.93)
        (envelope-from <kevmitch@chmeee>)
        id 1jiSOj-005RR6-F6; Mon, 08 Jun 2020 17:45:49 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Kevin Mitchell <kevmitch@arista.com>, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        David Rientjes <rientjes@google.com>,
        Dou Liyang <douly.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86/mpparse: avoid overwriting boot_cpu_physical_apicid
Date:   Mon,  8 Jun 2020 17:44:48 -0700
Message-Id: <20200609004451.1296880-1-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When booting with ACPI unavailable or disabled, get_smp_config() ends up
calling MP_processor_info() for each CPU found in the MPS
table. Previously, this resulted in boot_cpu_physical_apicid getting
unconditionally overwritten by the apicid of whatever processor had the
CPU_BOOTPROCESSOR flag. This occurred even if boot_cpu_physical_apicid
had already been more reliably determined in register_lapic_address() by
calling read_apic_id() from the actual boot processor.

Ordinariliy, this is not a problem because the boot processor really is
the one with the CPU_BOOTPROCESSOR flag. However, kexec is an exception
in which the kernel may be booted from any processor regardless of the
MPS table contents. In this case, boot_cpu_physical_apicid may not
indicate the actual boot processor.

This was particularly problematic when the second kernel was booted with
NR_CPUS fewer than the number of physical processors. It's the job of
generic_processor_info() to decide which CPUs to bring up in this case.
That obviously must include the real boot processor which it takes care
to save a slot for. It relies upon the contents of
boot_cpu_physical_apicid to do this, which if incorrect, may result in
the boot processor getting left out.

This condition can be discovered by smp_sanity_check() and rectified by
adding the boot processor to the phys_cpu_present_map with the warning
"weird, boot CPU (#%d) not listed by the BIOS". However, commit
3e730dad3b6da ("x86/apic: Unify interrupt mode setup for SMP-capable
system") caused setup_local_APIC() to be called before this could happen
resulting in a BUG_ON(!apic->apic_id_registered()):

[    0.655452] ------------[ cut here ]------------
[    0.660610] Kernel BUG at setup_local_APIC+0x74/0x280 [verbose debug info unavailable]
[    0.669466] invalid opcode: 0000 [#1] SMP
[    0.673948] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.19.109.Ar-16509018.eostrunkkernel419 #1
[    0.683670] Hardware name: Quanta Quanta LY6 (1LY6UZZ0FBC), BIOS 1.0.6.0-e7d6a55 11/26/2015
[    0.693007] RIP: 0010:setup_local_APIC+0x74/0x280
[    0.698264] Code: 80 e4 fe bf f0 00 00 00 89 c6 48 8b 05 0f 1a 8e 00 ff 50 10 e8 12 53 fd ff 48 8b 05 00 1a 8e 00 ff 90 a0 00 00 00 85 c0 75 02 <0f> 0b 48 8b 05 ed 19 8e 00 41 be 00 02 00 00 ff 90 b0 00 00 00 48
[    0.719251] RSP: 0000:ffffffff81a03e20 EFLAGS: 00010246
[    0.725091] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
[    0.733066] RDX: 0000000000000000 RSI: 000000000000000f RDI: 0000000000000020
[    0.741041] RBP: ffffffff81a03e98 R08: 0000000000000002 R09: 0000000000000000
[    0.749014] R10: ffffffff81a204e0 R11: ffffffff81b50ea7 R12: 0000000000000000
[    0.756989] R13: ffffffff81aef920 R14: ffffffff81af60a0 R15: 0000000000000000
[    0.764965] FS:  0000000000000000(0000) GS:ffff888036800000(0000) knlGS:0000000000000000
[    0.774007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.780427] CR2: ffff888035c01000 CR3: 0000000035a08000 CR4: 00000000000006b0
[    0.788401] Call Trace:
[    0.791137]  ? amd_iommu_prepare+0x15/0x2a
[    0.795717]  apic_bsp_setup+0x55/0x75
[    0.799808]  apic_intr_mode_init+0x169/0x16e
[    0.804579]  x86_late_time_init+0x10/0x17
[    0.809062]  start_kernel+0x37e/0x3fe
[    0.813154]  x86_64_start_reservations+0x2a/0x2c
[    0.818316]  x86_64_start_kernel+0x72/0x75
[    0.822886]  secondary_startup_64+0xa4/0xb0
[    0.827564] ---[ end trace 237b64da0fd9b22e ]---

This change avoids these issues by only setting boot_cpu_physical_apicid
from the MPS table if it is not already set, which can occur in the
construct_default_ISA_mptable() path. Otherwise,
boot_cpu_physical_apicid will already have been set in
register_lapic_address() and should therefore remain untouched.

Looking through all the places where boot_cpu_physical_apicid is
accessed, nearly all of them assume that boot_cpu_physical_apicid should
match read_apic_id() on the booting processor. The only place that might
intend to use the BSP apicid listed in the MPS table is amd_numa_init(),
which explicitly requires boot_cpu_physical_apicid to be the lowest
apicid of all processors. Ironically, due to the early exit short
circuit in early_get_smp_config(), it instead gets
boot_cpu_physical_apicid = read_apic_id() rather than the MPS table
BSP. The behaviour of amd_numa_init() is therefore unaffected by this
change.

Fixes: 3e730dad3b6da ("x86/apic: Unify interrupt mode setup for SMP-capable system")
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/mpparse.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index afac7ccce72f..6f22f09bfe11 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -64,7 +64,8 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 
 	if (m->cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
-		boot_cpu_physical_apicid = m->apicid;
+		if (boot_cpu_physical_apicid == -1U)
+			boot_cpu_physical_apicid = m->apicid;
 	}
 
 	pr_info("Processor #%d%s\n", m->apicid, bootup_cpu);
-- 
2.26.2

