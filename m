Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E356796BE
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 12:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjAXLfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 06:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjAXLe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 06:34:57 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEBD6A5A
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 03:34:52 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id t7-20020a05683014c700b006864760b1caso9054637otq.0
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 03:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giDXIoZtu8Gb5koQJ5ztI5wIDgPl1boFVfCH2LWp1SE=;
        b=L05Ibbxmm0jo2lWQMfivCsHahg71uW7r6hmHqAl/tDyNPxZeZp/w1t/LnaEJfktbfV
         SAYcpx4FjuUbEx5GiqzdQdIoim1T1mps1G4n6TMy1Nly2FWn/5cdqFsucbgWzurVDw3V
         Tzb007aYo4OBCIgddRd7RQ9/PWPE1J2AocvpWGgGC9lQ5idv3sFzrU3+bcckwxjGpJqM
         Cfn35xbli3wGQiCWRubp8VKyUgllzyfKMfvMf7NnHw9BkxXkiioo8NeIy/e4LFT+WQE5
         2R5QHsnH1tZENqStcNO5ohY8oANLuEGINPHV7iXtCnT4kqPavqd0+pvav8008KO/1CfA
         mk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=giDXIoZtu8Gb5koQJ5ztI5wIDgPl1boFVfCH2LWp1SE=;
        b=wBYXls73cUwGS8IT4asFlGxFY6M7nqQv1LOG6VEx6fDgTkHKbF9qafDWsqdw+VqHxt
         HCngQHhT5vfc3Pbf0GHBxFXf9q0rQzJrss6En8fIcXCIqyK+lt13sapI3JtWcOfh7brP
         uQpZZETBTM6tsN9GQWYY4sZ1VArib2BqiIC6Pq8M80wocrZTCeq6lBwjTWtcbwzCnS6g
         DiS4Ma3nBHqYNlKis8wjfSPjOd+ZtXq+jcgqUWiu/2RCppWfrkNpTmdlzJHCdag6CPKB
         58GmRT4p14l1M+iqgBc1V7I7j5DV9tlC2/Pdcc8o8ixlck6UstGkTyPq1yt0sOP4NWCe
         +5pA==
X-Gm-Message-State: AFqh2kqlruKb8G3ZQaL8DGBrZBrWpYEXToUV3K7EBmtSlapBAjtwiFds
        yvRTquSwA4WVXGDps6UeSzzYG9VzNRd+N1ZUydY=
X-Google-Smtp-Source: AMrXdXs6kTOO7Nab7EaimWVCJaRAsWl416/CYYgGDiTCGITuWBIPfzDDkl0admopmNktMtE42y8MgMELLfePeUGkE7o=
X-Received: by 2002:a05:6830:1d88:b0:686:b88a:e95d with SMTP id
 y8-20020a0568301d8800b00686b88ae95dmr825527oti.64.1674560091371; Tue, 24 Jan
 2023 03:34:51 -0800 (PST)
MIME-Version: 1.0
References: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
 <Y89n98fRfTpLmPUg@kroah.com> <CAFJ_xbqMx8LsD_Ry70jnqVmmhyGjTFpA-Gv7SpRR21v3Djr1DA@mail.gmail.com>
In-Reply-To: <CAFJ_xbqMx8LsD_Ry70jnqVmmhyGjTFpA-Gv7SpRR21v3Djr1DA@mail.gmail.com>
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Tue, 24 Jan 2023 12:34:39 +0100
Message-ID: <CALFERdxxAt5+Y0nxbEieYSZX8YLTA9aogtGWLLZBEpGdbWxT-g@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Lukasz Majczak <lma@semihalf.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 11:18 AM Lukasz Majczak <lma@semihalf.com> wrote:
>
> Hi Sasa,
> I've just built a vanilla kernel (v.6.1.7) with ChromeOS and audio
> seems to work - at least for a while - I was able to play some music
> on YouTube. Can you share a full dmesg ?
>
Hi Lukasz, yes of course I can, I hope its not wrong to paste it in
here, here it is the
one with kernel 6.0.18 where sound works:

# dmesg
[    0.000000] microcode: microcode updated early to revision 0xf0,
date =3D 2021-11-12
[    0.000000] Linux version 6.0.18-300.fc37.x86_64
(mockbuild@bkernel02.iad2.fedoraproject.org) (gcc (GCC) 12.2.1
20221121 (Red Hat 12.2.1-4), GNU ld version 2.38-25.fc37) #1 SMP
PREEMPT_DYNAMIC Sat Jan 7 17:10:00 UTC 2023
[    0.000000] Command line:
BOOT_IMAGE=3D(hd0,msdos1)/vmlinuz-6.0.18-300.fc37.x86_64
root=3DUUID=3D29ab9af9-a304-4fe8-a886-b2977fa0e8a1 ro
rootflags=3Dsubvol=3Droot rhgb quiet
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating
point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registe=
rs'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is
960 bytes, using 'compacted' format.
[    0.000000] signal: max sigframe size: 2032
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007a95bfff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000007a95c000-0x000000007fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000e3ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fd000000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000047effffff] usabl=
e
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Google Eve/Eve, BIOS Google_Eve.9584.230.0 09/06/2021
[    0.000000] tsc: Detected 1600.000 MHz processor
[    0.000000] tsc: Detected 1599.960 MHz TSC
[    0.000846] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000853] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000863] last_pfn =3D 0x47f000 max_arch_pfn =3D 0x400000000
[    0.001076] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.002095] last_pfn =3D 0x7a95c max_arch_pfn =3D 0x400000000
[    0.019964] Using GB pages for direct mapping
[    0.020444] RAMDISK: [mem 0x33886000-0x35c3afff]
[    0.020453] ACPI: Early table checksum verification disabled
[    0.020457] ACPI: RSDP 0x00000000000F4310 000024 (v02 CORE  )
[    0.020465] ACPI: XSDT 0x000000007AA9A0E0 000064 (v01 CORE
COREBOOT 00000000 CORE 00000000)
[    0.020476] ACPI: FACP 0x000000007AA9E830 0000F4 (v04 CORE
COREBOOT 00000000 CORE 00000000)
[    0.020486] ACPI: DSDT 0x000000007AA9A280 0045B0 (v05 COREv4
COREBOOT 20110725 INTL 20150717)
[    0.020492] ACPI: FACS 0x000000007AA9A240 000040
[    0.020497] ACPI: FACS 0x000000007AA9A240 000040
[    0.020502] ACPI: SSDT 0x000000007AA9E930 000DBB (v02 CORE
COREBOOT 0000002A CORE 0000002A)
[    0.020509] ACPI: MCFG 0x000000007AA9F6F0 00003C (v01 CORE
COREBOOT 00000000 CORE 00000000)
[    0.020515] ACPI: TCPA 0x000000007AA9F730 000032 (v02 CORE
COREBOOT 00000000 CORE 00000000)
[    0.020520] ACPI: APIC 0x000000007AA9F770 00006C (v01 CORE
COREBOOT 00000000 CORE 00000000)
[    0.020526] ACPI: NHLT 0x000000007AA9F7E0 000404 (v05 GOOGLE EVEMAX
  00000000 CORE 00000000)
[    0.020535] ACPI: DBG2 0x000000007AAA1BF0 000061 (v00 CORE
COREBOOT 00000000 CORE 00000000)
[    0.020542] ACPI: HPET 0x000000007AAA1C60 000038 (v01 CORE
COREBOOT 00000000 CORE 00000000)
[    0.020548] ACPI: Reserving FACP table memory at [mem 0x7aa9e830-0x7aa9e=
923]
[    0.020552] ACPI: Reserving DSDT table memory at [mem 0x7aa9a280-0x7aa9e=
82f]
[    0.020554] ACPI: Reserving FACS table memory at [mem 0x7aa9a240-0x7aa9a=
27f]
[    0.020556] ACPI: Reserving FACS table memory at [mem 0x7aa9a240-0x7aa9a=
27f]
[    0.020557] ACPI: Reserving SSDT table memory at [mem 0x7aa9e930-0x7aa9f=
6ea]
[    0.020559] ACPI: Reserving MCFG table memory at [mem 0x7aa9f6f0-0x7aa9f=
72b]
[    0.020561] ACPI: Reserving TCPA table memory at [mem 0x7aa9f730-0x7aa9f=
761]
[    0.020562] ACPI: Reserving APIC table memory at [mem 0x7aa9f770-0x7aa9f=
7db]
[    0.020564] ACPI: Reserving NHLT table memory at [mem 0x7aa9f7e0-0x7aa9f=
be3]
[    0.020566] ACPI: Reserving DBG2 table memory at [mem 0x7aaa1bf0-0x7aaa1=
c50]
[    0.020567] ACPI: Reserving HPET table memory at [mem 0x7aaa1c60-0x7aaa1=
c97]
[    0.020713] No NUMA configuration found
[    0.020714] Faking a node at [mem 0x0000000000000000-0x000000047effffff]
[    0.020730] NODE_DATA(0) allocated [mem 0x47efd5000-0x47effffff]
[    0.065763] Zone ranges:
[    0.065765]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.065769]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.065772]   Normal   [mem 0x0000000100000000-0x000000047effffff]
[    0.065775]   Device   empty
[    0.065777] Movable zone start for each node
[    0.065782] Early memory node ranges
[    0.065783]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.065786]   node   0: [mem 0x0000000000100000-0x000000007a95bfff]
[    0.065789]   node   0: [mem 0x0000000100000000-0x000000047effffff]
[    0.065794] Initmem setup node 0 [mem 0x0000000000001000-0x000000047efff=
fff]
[    0.065802] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.065841] On node 0, zone DMA: 97 pages in unavailable ranges
[    0.112128] On node 0, zone Normal: 22180 pages in unavailable ranges
[    0.112228] On node 0, zone Normal: 4096 pages in unavailable ranges
[    0.112249] Reserving Intel graphics memory at [mem 0x7c000000-0x7ffffff=
f]
[    0.112611] ACPI: PM-Timer IO Port: 0x1808
[    0.112656] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
119
[    0.112662] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.112665] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.112673] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.112675] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.112680] TSC deadline timer available
[    0.112682] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.112698] PM: hibernation: Registered nosave memory: [mem
0x00000000-0x00000fff]
[    0.112701] PM: hibernation: Registered nosave memory: [mem
0x0009f000-0x0009ffff]
[    0.112703] PM: hibernation: Registered nosave memory: [mem
0x000a0000-0x000effff]
[    0.112705] PM: hibernation: Registered nosave memory: [mem
0x000f0000-0x000fffff]
[    0.112707] PM: hibernation: Registered nosave memory: [mem
0x7a95c000-0x7fffffff]
[    0.112709] PM: hibernation: Registered nosave memory: [mem
0x80000000-0xdfffffff]
[    0.112711] PM: hibernation: Registered nosave memory: [mem
0xe0000000-0xe3ffffff]
[    0.112712] PM: hibernation: Registered nosave memory: [mem
0xe4000000-0xfcffffff]
[    0.112714] PM: hibernation: Registered nosave memory: [mem
0xfd000000-0xffffffff]
[    0.112718] [mem 0x80000000-0xdfffffff] available for PCI devices
[    0.112720] Booting paravirtualized kernel on bare hardware
[    0.112724] clocksource: refined-jiffies: mask: 0xffffffff
max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.125758] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4
nr_cpu_ids:4 nr_node_ids:1
[    0.126042] percpu: Embedded 61 pages/cpu s212992 r8192 d28672 u524288
[    0.126052] pcpu-alloc: s212992 r8192 d28672 u524288 alloc=3D1*2097152
[    0.126057] pcpu-alloc: [0] 0 1 2 3
[    0.126096] Fallback order for Node 0: 0
[    0.126102] Built 1 zonelists, mobility grouping on.  Total pages: 41026=
46
[    0.126104] Policy zone: Normal
[    0.126107] Kernel command line:
BOOT_IMAGE=3D(hd0,msdos1)/vmlinuz-6.0.18-300.fc37.x86_64
root=3DUUID=3D29ab9af9-a304-4fe8-a886-b2977fa0e8a1 ro
rootflags=3Dsubvol=3Droot rhgb quiet
[    0.126265] Unknown kernel command line parameters "rhgb
BOOT_IMAGE=3D(hd0,msdos1)/vmlinuz-6.0.18-300.fc37.x86_64", will be
passed to user space.
[    0.127918] Dentry cache hash table entries: 2097152 (order: 12,
16777216 bytes, linear)
[    0.128735] Inode-cache hash table entries: 1048576 (order: 11,
8388608 bytes, linear)
[    0.129039] mem auto-init: stack:all(zero), heap alloc:off, heap free:of=
f
[    0.129046] software IO TLB: area num 4.
[    0.208902] Memory: 16228748K/16671720K available (16393K kernel
code, 3229K rwdata, 12812K rodata, 3012K init, 4688K bss, 442712K
reserved, 0K cma-reserved)
[    0.211152] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.211233] Kernel/User page tables isolation: enabled
[    0.211263] ftrace: allocating 50915 entries in 199 pages
[    0.230189] ftrace: allocated 199 pages with 5 groups
[    0.231969] Dynamic Preempt: voluntary
[    0.232135] rcu: Preemptible hierarchical RCU implementation.
[    0.232137] rcu:     RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_=
ids=3D4.
[    0.232139]     Trampoline variant of Tasks RCU enabled.
[    0.232140]     Rude variant of Tasks RCU enabled.
[    0.232141]     Tracing variant of Tasks RCU enabled.
[    0.232143] rcu: RCU calculated value of scheduler-enlistment delay
is 100 jiffies.
[    0.232144] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.244056] NR_IRQS: 524544, nr_irqs: 1024, preallocated irqs: 16
[    0.244342] rcu: srcu_init: Setting srcu_struct sizes based on contentio=
n.
[    0.244602] kfence: initialized - using 2097152 bytes for 255
objects at 0x(____ptrval____)-0x(____ptrval____)
[    0.244682] random: crng init done
[    0.245038] Console: colour dummy device 80x25
[    0.245068] printk: console [tty0] enabled
[    0.245113] ACPI: Core revision 20220331
[    0.245221] hpet: HPET dysfunctional in PC10. Force disabled.
[    0.245223] APIC: Switch to symmetric I/O mode setup
[    0.246464] x2apic: IRQ remapping doesn't support X2APIC mode
[    0.250596] clocksource: tsc-early: mask: 0xffffffffffffffff
max_cycles: 0x170fff30cc4, max_idle_ns: 440795237869 ns
[    0.250606] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3199.92 BogoMIPS (lpj=3D1599960)
[    0.250612] pid_max: default: 32768 minimum: 301
[    0.250654] LSM: Security Framework initializing
[    0.250673] Yama: becoming mindful.
[    0.250683] SELinux:  Initializing.
[    0.250725] LSM support for eBPF active
[    0.250728] landlock: Up and running.
[    0.250811] Mount-cache hash table entries: 32768 (order: 6, 262144
bytes, linear)
[    0.250853] Mountpoint-cache hash table entries: 32768 (order: 6,
262144 bytes, linear)
[    0.251276] CPU0: Thermal monitoring enabled (TM1)
[    0.251357] process: using mwait in idle threads
[    0.251361] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.251364] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.251373] Spectre V1 : Mitigation: usercopy/swapgs barriers and
__user pointer sanitization
[    0.251377] Spectre V2 : Mitigation: IBRS
[    0.251379] Spectre V2 : Spectre v2 / SpectreRSB mitigation:
Filling RSB on context switch
[    0.251381] Spectre V2 : Spectre v2 / SpectreRSB : Filling RSB on VMEXIT
[    0.251383] RETBleed: Mitigation: IBRS
[    0.251386] Spectre V2 : mitigation: Enabling conditional Indirect
Branch Prediction Barrier
[    0.251389] Speculative Store Bypass: Mitigation: Speculative Store
Bypass disabled via prctl
[    0.251403] MDS: Mitigation: Clear CPU buffers
[    0.251405] TAA: Mitigation: TSX disabled
[    0.251406] MMIO Stale Data: Mitigation: Clear CPU buffers
[    0.251416] SRBDS: Mitigation: Microcode
[    0.251603] Freeing SMP alternatives memory: 44K
[    0.251603] smpboot: CPU0: Intel(R) Core(TM) i7-7Y75 CPU @ 1.30GHz
(family: 0x6, model: 0x8e, stepping: 0x9)
[    0.251603] cblist_init_generic: Setting adjustable number of
callback queues.
[    0.251603] cblist_init_generic: Setting shift to 2 and lim to 1.
[    0.251603] cblist_init_generic: Setting shift to 2 and lim to 1.
[    0.251603] cblist_init_generic: Setting shift to 2 and lim to 1.
[    0.251603] Performance Events: PEBS fmt3+, Skylake events, 32-deep
LBR, full-width counters, Intel PMU driver.
[    0.251603] ... version:                4
[    0.251603] ... bit width:              48
[    0.251603] ... generic registers:      4
[    0.251603] ... value mask:             0000ffffffffffff
[    0.251603] ... max period:             00007fffffffffff
[    0.251603] ... fixed-purpose events:   3
[    0.251603] ... event mask:             000000070000000f
[    0.251603] Estimated ratio of average max frequency by base
frequency (times 1024): 2176
[    0.251603] rcu: Hierarchical SRCU implementation.
[    0.251603] rcu:     Max phase no-delay instances is 400.
[    0.252866] NMI watchdog: Enabled. Permanently consumes one hw-PMU count=
er.
[    0.252984] smp: Bringing up secondary CPUs ...
[    0.253170] x86: Booting SMP configuration:
[    0.253172] .... node  #0, CPUs:      #1
[    0.254053] MDS CPU bug present and SMT on, data leak possible. See
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html
for more details.
[    0.254053] MMIO Stale Data CPU bug present and SMT on, data leak
possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/pr=
ocessor_mmio_stale_data.html
for more details.
[    0.254053]  #2 #3
[    0.260207] smp: Brought up 1 node, 4 CPUs
[    0.260207] smpboot: Max logical packages: 1
[    0.260207] smpboot: Total of 4 processors activated (12799.68 BogoMIPS)
[    0.261609] devtmpfs: initialized
[    0.261705] x86/mm: Memory block size: 128MB
[    0.264890] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.264890] futex hash table entries: 1024 (order: 4, 65536 bytes, linea=
r)
[    0.264906] pinctrl core: initialized pinctrl subsystem
[    0.265203] PM: RTC time: 10:28:56, date: 2023-01-24
[    0.266393] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.266682] DMA: preallocated 2048 KiB GFP_KERNEL pool for atomic alloca=
tions
[    0.266696] DMA: preallocated 2048 KiB GFP_KERNEL|GFP_DMA pool for
atomic allocations
[    0.266706] DMA: preallocated 2048 KiB GFP_KERNEL|GFP_DMA32 pool
for atomic allocations
[    0.266729] audit: initializing netlink subsys (disabled)
[    0.266744] audit: type=3D2000 audit(1674556136.016:1):
state=3Dinitialized audit_enabled=3D0 res=3D1
[    0.266819] thermal_sys: Registered thermal governor 'fair_share'
[    0.266822] thermal_sys: Registered thermal governor 'bang_bang'
[    0.266824] thermal_sys: Registered thermal governor 'step_wise'
[    0.266826] thermal_sys: Registered thermal governor 'user_space'
[    0.266847] cpuidle: using governor menu
[    0.266958] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.266958] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.266958] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E82=
0
[    0.266958] PCI: MMCONFIG for 0000 [bus00-3f] at [mem
0xe0000000-0xe3ffffff] (base 0xe0000000) (size reduced!)
[    0.266958] PCI: Using configuration type 1 for base access
[    0.272189] kprobes: kprobe jump-optimization is enabled. All
kprobes are optimized if possible.
[    0.272222] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 page=
s
[    0.272222] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    0.272222] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 page=
s
[    0.272222] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    0.272696] cryptd: max_cpu_qlen set to 1000
[    0.272759] raid6: skipped pq benchmark and selected avx2x4
[    0.272759] raid6: using avx2x2 recovery algorithm
[    0.272848] ACPI: Added _OSI(Module Device)
[    0.272852] ACPI: Added _OSI(Processor Device)
[    0.272856] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.272860] ACPI: Added _OSI(Processor Aggregator Device)
[    0.272863] ACPI: Added _OSI(Linux-Dell-Video)
[    0.272866] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.272870] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.280238] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.302841] ACPI: EC: EC started
[    0.302845] ACPI: EC: interrupt blocked
[    0.303071] ACPI: EC: EC_CMD/EC_SC=3D0x66, EC_DATA=3D0x62
[    0.303077] ACPI: \_SB_.PCI0.LPCB.EC0_: Boot DSDT EC used to handle
transactions
[    0.303082] ACPI: Interpreter enabled
[    0.303114] ACPI: PM: (supports S0 S3 S5)
[    0.303117] ACPI: Using IOAPIC for interrupt routing
[    0.303181] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=3Dnocrs" and report a bug
[    0.303185] PCI: Using E820 reservations for host bridge windows
[    0.318694] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.318710] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI EDR HPX-Type3]
[    0.318784] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug
SHPCHotplug PME AER PCIeCapability LTR DPC]
[    0.318802] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain
0000 [bus 00-3f] only partially covers this bridge
[    0.319002] acpi PNP0A08:00: ignoring host bridge window [mem
0x000c4000-0x000c7fff window] (conflicts with Video ROM [mem
0x000c0000-0x000c6dff])
[    0.320364] PCI host bridge to bus 0000:00
[    0.320369] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window=
]
[    0.320376] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window=
]
[    0.320381] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000c3fff window]
[    0.320386] pci_bus 0000:00: root bus resource [mem
0x000c8000-0x000fffff window]
[    0.320390] pci_bus 0000:00: root bus resource [mem
0x80000001-0xdfffffff window]
[    0.320395] pci_bus 0000:00: root bus resource [mem
0x800000000-0xbffffffff window]
[    0.320400] pci_bus 0000:00: root bus resource [mem
0xfd000000-0xfe7fffff window]
[    0.320404] pci_bus 0000:00: root bus resource [mem
0xfed40000-0xfed44fff window]
[    0.320409] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.320467] pci 0000:00:00.0: [8086:590c] type 00 class 0x060000
[    0.320732] pci 0000:00:02.0: [8086:591e] type 00 class 0x030000
[    0.320754] pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd0ffffff 64bit=
]
[    0.320770] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff
64bit pref]
[    0.320781] pci 0000:00:02.0: reg 0x20: [io  0x1c00-0x1c3f]
[    0.320820] pci 0000:00:02.0: Video device with shadowed ROM at
[mem 0x000c0000-0x000dffff]
[    0.320990] pci 0000:00:04.0: [8086:1903] type 00 class 0x118000
[    0.321015] pci 0000:00:04.0: reg 0x10: [mem 0xd1220000-0xd1227fff 64bit=
]
[    0.321266] pci 0000:00:08.0: [8086:1911] type 00 class 0x088000
[    0.321290] pci 0000:00:08.0: reg 0x10: [mem 0xd1230000-0xd1230fff 64bit=
]
[    0.321524] pci 0000:00:14.0: [8086:9d2f] type 00 class 0x0c0330
[    0.321560] pci 0000:00:14.0: reg 0x10: [mem 0xd1200000-0xd120ffff 64bit=
]
[    0.321684] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.321977] pci 0000:00:14.2: [8086:9d31] type 00 class 0x118000
[    0.322013] pci 0000:00:14.2: reg 0x10: [mem 0xd1231000-0xd1231fff 64bit=
]
[    0.322266] pci 0000:00:15.0: [8086:9d60] type 00 class 0x118000
[    0.322309] pci 0000:00:15.0: reg 0x10: [mem 0xd1232000-0xd1232fff 64bit=
]
[    0.322639] pci 0000:00:15.1: [8086:9d61] type 00 class 0x118000
[    0.322684] pci 0000:00:15.1: reg 0x10: [mem 0xd1233000-0xd1233fff 64bit=
]
[    0.323024] pci 0000:00:15.2: [8086:9d62] type 00 class 0x118000
[    0.323067] pci 0000:00:15.2: reg 0x10: [mem 0xd1234000-0xd1234fff 64bit=
]
[    0.323418] pci 0000:00:16.0: [8086:9d3a] type 00 class 0x078000
[    0.323455] pci 0000:00:16.0: reg 0x10: [mem 0xd1235000-0xd1235fff 64bit=
]
[    0.323575] pci 0000:00:16.0: PME# supported from D3hot
[    0.323764] pci 0000:00:19.0: [8086:9d66] type 00 class 0x118000
[    0.323808] pci 0000:00:19.0: reg 0x10: [mem 0xd1236000-0xd1236fff 64bit=
]
[    0.323839] pci 0000:00:19.0: reg 0x18: [mem 0xd1237000-0xd1237fff 64bit=
]
[    0.324157] pci 0000:00:19.2: [8086:9d64] type 00 class 0x118000
[    0.324200] pci 0000:00:19.2: reg 0x10: [mem 0xd1238000-0xd1238fff 64bit=
]
[    0.324555] pci 0000:00:1c.0: [8086:9d10] type 01 class 0x060400
[    0.324696] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.324966] pci 0000:00:1c.4: [8086:9d14] type 01 class 0x060400
[    0.325125] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.325371] pci 0000:00:1e.0: [8086:9d27] type 00 class 0x118000
[    0.325408] pci 0000:00:1e.0: reg 0x10: [mem 0xd1239000-0xd1239fff 64bit=
]
[    0.325434] pci 0000:00:1e.0: reg 0x18: [mem 0xd123a000-0xd123afff 64bit=
]
[    0.325720] pci 0000:00:1e.2: [8086:9d29] type 00 class 0x118000
[    0.325764] pci 0000:00:1e.2: reg 0x10: [mem 0xd123b000-0xd123bfff 64bit=
]
[    0.326085] pci 0000:00:1e.4: [8086:9d2b] type 00 class 0x080501
[    0.326121] pci 0000:00:1e.4: reg 0x10: [mem 0xd123c000-0xd123cfff 64bit=
]
[    0.326655] pci 0000:00:1f.0: [8086:9d4b] type 00 class 0x060100
[    0.327001] pci 0000:00:1f.2: [8086:9d21] type 00 class 0x058000
[    0.327026] pci 0000:00:1f.2: reg 0x10: [mem 0xd1228000-0xd122bfff]
[    0.327281] pci 0000:00:1f.3: [8086:9d71] type 00 class 0x040100
[    0.327317] pci 0000:00:1f.3: reg 0x10: [mem 0xd122c000-0xd122ffff 64bit=
]
[    0.327365] pci 0000:00:1f.3: reg 0x20: [mem 0xd1210000-0xd121ffff 64bit=
]
[    0.327445] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.327801] pci 0000:00:1f.4: [8086:9d23] type 00 class 0x0c0500
[    0.327865] pci 0000:00:1f.4: reg 0x10: [mem 0xd123e000-0xd123e0ff 64bit=
]
[    0.327941] pci 0000:00:1f.4: reg 0x20: [io  0xefa0-0xefbf]
[    0.328188] pci 0000:00:1f.5: [8086:9d24] type 00 class 0x000000
[    0.328214] pci 0000:00:1f.5: reg 0x10: [mem 0xd123d000-0xd123dfff]
[    0.329898] pci 0000:01:00.0: [8086:095a] type 00 class 0x028000
[    0.330098] pci 0000:01:00.0: reg 0x10: [mem 0xd1000000-0xd1001fff 64bit=
]
[    0.330662] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.331724] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.331741] pci 0000:00:1c.0:   bridge window [mem 0xd1000000-0xd10fffff=
]
[    0.332002] pci 0000:02:00.0: [144d:a806] type 00 class 0x010802
[    0.332034] pci 0000:02:00.0: reg 0x10: [mem 0xd1100000-0xd1103fff 64bit=
]
[    0.332560] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    0.332570] pci 0000:00:1c.4:   bridge window [mem 0xd1100000-0xd11fffff=
]
[    0.333208] ACPI: PCI: Interrupt link LNKA configured for IRQ 11
[    0.333355] ACPI: PCI: Interrupt link LNKB configured for IRQ 10
[    0.333484] ACPI: PCI: Interrupt link LNKC configured for IRQ 11
[    0.333634] ACPI: PCI: Interrupt link LNKD configured for IRQ 11
[    0.333775] ACPI: PCI: Interrupt link LNKE configured for IRQ 11
[    0.333918] ACPI: PCI: Interrupt link LNKF configured for IRQ 11
[    0.334047] ACPI: PCI: Interrupt link LNKG configured for IRQ 11
[    0.334176] ACPI: PCI: Interrupt link LNKH configured for IRQ 11
[    0.336944] ACPI: EC: interrupt unblocked
[    0.336948] ACPI: EC: event unblocked
[    0.336958] ACPI: EC: EC_CMD/EC_SC=3D0x66, EC_DATA=3D0x62
[    0.336962] ACPI: EC: GPE=3D0x6e
[    0.336966] ACPI: \_SB_.PCI0.LPCB.EC0_: Boot DSDT EC initialization comp=
lete
[    0.336971] ACPI: \_SB_.PCI0.LPCB.EC0_: EC: Used to handle
transactions and events
[    0.337145] iommu: Default domain type: Translated
[    0.337145] iommu: DMA domain TLB invalidation policy: lazy mode
[    0.337145] SCSI subsystem initialized
[    0.337145] libata version 3.00 loaded.
[    0.337145] ACPI: bus type USB registered
[    0.337145] usbcore: registered new interface driver usbfs
[    0.337145] usbcore: registered new interface driver hub
[    0.337640] usbcore: registered new device driver usb
[    0.337724] pps_core: LinuxPPS API ver. 1 registered
[    0.337727] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    0.337735] PTP clock support registered
[    0.337769] EDAC MC: Ver: 3.0.0
[    0.338808] NetLabel: Initializing
[    0.338811] NetLabel:  domain hash size =3D 128
[    0.338814] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
[    0.338855] NetLabel:  unlabeled traffic allowed by default
[    0.338866] mctp: management component transport protocol core
[    0.338868] NET: Registered PF_MCTP protocol family
[    0.338876] PCI: Using ACPI for IRQ routing
[    0.345879] PCI: pci_cache_line_size set to 64 bytes
[    0.346567] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.346575] e820: reserve RAM buffer [mem 0x7a95c000-0x7bffffff]
[    0.346578] e820: reserve RAM buffer [mem 0x47f000000-0x47fffffff]
[    0.346650] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.346650] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.346650] pci 0000:00:02.0: vgaarb: VGA device added:
decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
[    0.346650] vgaarb: loaded
[    0.346886] clocksource: Switched to clocksource tsc-early
[    0.380246] VFS: Disk quotas dquot_6.6.0
[    0.380277] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    0.380429] pnp: PnP ACPI init
[    0.380766] system 00:00: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.380774] system 00:00: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.380780] system 00:00: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.380784] system 00:00: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.380789] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.380793] system 00:00: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.380797] system 00:00: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.380802] system 00:00: [mem 0xff000000-0xffffffff] has been reserved
[    0.380806] system 00:00: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.380810] system 00:00: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.381199] system 00:01: [io  0x1800-0x18fe] has been reserved
[    0.381337] system 00:03: [io  0x0900-0x09fe] has been reserved
[    0.381424] system 00:04: [io  0x0200] has been reserved
[    0.381429] system 00:04: [io  0x0204] has been reserved
[    0.381433] system 00:04: [io  0x0800-0x087f] has been reserved
[    0.381436] system 00:04: [io  0x0880-0x08ff] has been reserved
[    0.381975] pnp: PnP ACPI: found 6 devices
[    0.390277] clocksource: acpi_pm: mask: 0xffffff max_cycles:
0xffffff, max_idle_ns: 2085701024 ns
[    0.390395] NET: Registered PF_INET protocol family
[    0.390899] IP idents hash table entries: 262144 (order: 9, 2097152
bytes, linear)
[    0.397070] tcp_listen_portaddr_hash hash table entries: 8192
(order: 5, 131072 bytes, linear)
[    0.397118] Table-perturb hash table entries: 65536 (order: 6,
262144 bytes, linear)
[    0.397130] TCP established hash table entries: 131072 (order: 8,
1048576 bytes, linear)
[    0.397373] TCP bind hash table entries: 65536 (order: 8, 1048576
bytes, linear)
[    0.397545] TCP: Hash tables configured (established 131072 bind 65536)
[    0.397692] MPTCP token hash table entries: 16384 (order: 6, 393216
bytes, linear)
[    0.397786] UDP hash table entries: 8192 (order: 6, 262144 bytes, linear=
)
[    0.397841] UDP-Lite hash table entries: 8192 (order: 6, 262144
bytes, linear)
[    0.397948] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.397960] NET: Registered PF_XDP protocol family
[    0.397980] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.397993] pci 0000:00:1c.0:   bridge window [mem 0xd1000000-0xd10fffff=
]
[    0.398005] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    0.398021] pci 0000:00:1c.4:   bridge window [mem 0xd1100000-0xd11fffff=
]
[    0.398034] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.398039] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.398042] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000c3fff windo=
w]
[    0.398046] pci_bus 0000:00: resource 7 [mem 0x000c8000-0x000fffff windo=
w]
[    0.398049] pci_bus 0000:00: resource 8 [mem 0x80000001-0xdfffffff windo=
w]
[    0.398052] pci_bus 0000:00: resource 9 [mem 0x800000000-0xbffffffff win=
dow]
[    0.398056] pci_bus 0000:00: resource 10 [mem 0xfd000000-0xfe7fffff wind=
ow]
[    0.398059] pci_bus 0000:00: resource 11 [mem 0xfed40000-0xfed44fff wind=
ow]
[    0.398063] pci_bus 0000:01: resource 1 [mem 0xd1000000-0xd10fffff]
[    0.398066] pci_bus 0000:02: resource 1 [mem 0xd1100000-0xd11fffff]
[    0.399031] PCI: CLS 64 bytes, default 64
[    0.399041] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.399044] software IO TLB: mapped [mem
0x000000007695c000-0x000000007a95c000] (64MB)
[    0.399158] Trying to unpack rootfs image as initramfs...
[    0.431545] sgx: There are zero EPC sections.
[    0.433310] Initialise system trusted keyrings
[    0.433331] Key type blacklist registered
[    0.433414] workingset: timestamp_bits=3D36 max_order=3D22 bucket_order=
=3D0
[    0.439794] zbud: loaded
[    0.442008] integrity: Platform Keyring initialized
[    0.442015] integrity: Machine keyring initialized
[    0.459254] NET: Registered PF_ALG protocol family
[    0.459261] xor: automatically using best checksumming function   avx
[    0.459266] Key type asymmetric registered
[    0.459270] Asymmetric key parser 'x509' registered
[    1.433656] tsc: Refined TSC clocksource calibration: 1608.000 MHz
[    1.433672] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
0x172daa3a18b, max_idle_ns: 440795212390 ns
[    1.434421] Freeing initrd memory: 36564K
[    1.434442] clocksource: Switched to clocksource tsc
[    1.444355] alg: self-tests for CTR-KDF (hmac(sha256)) passed
[    1.444391] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 245)
[    1.444461] io scheduler mq-deadline registered
[    1.444466] io scheduler kyber registered
[    1.444546] io scheduler bfq registered
[    1.448101] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    1.449201] pcieport 0000:00:1c.0: PME: Signaling with IRQ 120
[    1.449333] pcieport 0000:00:1c.0: AER: enabled with IRQ 120
[    1.449809] pcieport 0000:00:1c.4: PME: Signaling with IRQ 121
[    1.449967] pcieport 0000:00:1c.4: AER: enabled with IRQ 121
[    1.450166] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.451113] ACPI: AC: AC Adapter [AC] (on-line)
[    1.451214] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.451260] ACPI: button: Power Button [PWRB]
[    1.451336] input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/PNP0C09:00/PNP0C0D:00=
/input/input1
[    1.451409] ACPI: button: Lid Switch [LID0]
[    1.451487] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.451549] ACPI: button: Power Button [PWRF]
[    1.452427] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.472865] ACPI: battery: Slot [BAT0] (battery present)
[    1.475424] hpet_acpi_add: no address or irqs in _CRS
[    1.475505] Non-volatile memory driver v1.3
[    1.475519] Linux agpgart interface v0.103
[    1.475778] ACPI: bus type drm_connector registered
[    1.485875] dw-apb-uart.3: ttyS4 at MMIO 0xd1236000 (irq =3D 32,
base_baud =3D 7500000) is a 16550A
[    1.490104] dw-apb-uart.5: ttyS5 at MMIO 0xd1239000 (irq =3D 20,
base_baud =3D 7500000) is a 16550A
[    1.492043] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.492053] ehci-pci: EHCI PCI platform driver
[    1.492081] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.492087] ohci-pci: OHCI PCI platform driver
[    1.492104] uhci_hcd: USB Universal Host Controller Interface driver
[    1.492416] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.492493] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 1
[    1.493663] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci
version 0x100 quirks 0x0000000081109810
[    1.494162] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.494241] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 2
[    1.494248] xhci_hcd 0000:00:14.0: Host supports USB 3.0 SuperSpeed
[    1.494340] usb usb1: New USB device found, idVendor=3D1d6b,
idProduct=3D0002, bcdDevice=3D 6.00
[    1.494346] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,
SerialNumber=3D1
[    1.494350] usb usb1: Product: xHCI Host Controller
[    1.494353] usb usb1: Manufacturer: Linux 6.0.18-300.fc37.x86_64 xhci-hc=
d
[    1.494356] usb usb1: SerialNumber: 0000:00:14.0
[    1.494691] hub 1-0:1.0: USB hub found
[    1.494727] hub 1-0:1.0: 12 ports detected
[    1.498463] usb usb2: New USB device found, idVendor=3D1d6b,
idProduct=3D0003, bcdDevice=3D 6.00
[    1.498471] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,
SerialNumber=3D1
[    1.498475] usb usb2: Product: xHCI Host Controller
[    1.498479] usb usb2: Manufacturer: Linux 6.0.18-300.fc37.x86_64 xhci-hc=
d
[    1.498482] usb usb2: SerialNumber: 0000:00:14.0
[    1.498809] hub 2-0:1.0: USB hub found
[    1.498840] hub 2-0:1.0: 6 ports detected
[    1.499922] usb: port power management may be unreliable
[    1.500684] usbcore: registered new interface driver usbserial_generic
[    1.500694] usbserial: USB Serial support registered for generic
[    1.500762] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq =
1
[    1.500766] i8042: PNP: PS/2 appears to have AUX port disabled, if
this is incorrect please boot with i8042.nopnp
[    1.501275] i8042: Warning: Keylock active
[    1.501473] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.501675] mousedev: PS/2 mouse device common for all mice
[    1.502086] rtc_cmos 00:02: RTC can wake from S4
[    1.502961] rtc_cmos 00:02: registered as rtc0
[    1.503095] rtc_cmos 00:02: setting system clock to
2023-01-24T10:28:58 UTC (1674556138)
[    1.503151] rtc_cmos 00:02: alarms up to one month, 242 bytes nvram
[    1.503341] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is
disabled. Duplicate IMA measurements will not be recorded in the IMA
log.
[    1.503394] device-mapper: uevent: version 1.0.3
[    1.503554] device-mapper: ioctl: 4.47.0-ioctl (2022-07-28)
initialised: dm-devel@redhat.com
[    1.503720] intel_pstate: Intel P-state driver initializing
[    1.503907] intel_pstate: HWP enabled
[    1.503981] hid: raw HID events driver (C) Jiri Kosina
[    1.504009] usbcore: registered new interface driver usbhid
[    1.504010] usbhid: USB HID core driver
[    1.504098] intel_pmc_core intel_pmc_core.0:  initialized
[    1.504168] input: Tablet Mode Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/PNP0C09:00/GOOG0006:0=
0/input/input4
[    1.504321] drop_monitor: Initializing network drop monitor service
[    1.507668] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input3
[    1.517733] Initializing XFRM netlink socket
[    1.517850] NET: Registered PF_INET6 protocol family
[    1.521875] Segment Routing with IPv6
[    1.521878] RPL Segment Routing with IPv6
[    1.521886] In-situ OAM (IOAM) with IPv6
[    1.521908] mip6: Mobile IPv6
[    1.521909] NET: Registered PF_PACKET protocol family
[    1.522220] microcode: sig=3D0x806e9, pf=3D0x80, revision=3D0xf0
[    1.522234] microcode: Microcode Update Driver: v2.2.
[    1.522240] IPI shorthand broadcast: enabled
[    1.522246] AVX2 version of gcm_enc/dec engaged.
[    1.522305] AES CTR mode by8 optimization enabled
[    1.522546] sched_clock: Marking stable (1516361665,
6167251)->(1577702643, -55173727)
[    1.522760] registered taskstats version 1
[    1.522834] Loading compiled-in X.509 certificates
[    1.530679] Loaded X.509 cert 'Fedora kernel signing key:
e5a8a4ee4a3b5c044d8e590887c122ef6a4ac65f'
[    1.530911] zswap: loaded using pool lzo/zbud
[    1.531067] page_owner is disabled
[    1.531134] Key type .fscrypt registered
[    1.531135] Key type fscrypt-provisioning registered
[    1.531441] Btrfs loaded, crc32c=3Dcrc32c-generic, zoned=3Dyes, fsverity=
=3Dyes
[    1.531455] Key type big_key registered
[    1.535154] Key type encrypted registered
[    1.535163] ima: No TPM chip found, activating TPM-bypass!
[    1.535180] Loading compiled-in module X.509 certificates
[    1.535622] Loaded X.509 cert 'Fedora kernel signing key:
e5a8a4ee4a3b5c044d8e590887c122ef6a4ac65f'
[    1.535625] ima: Allocated hash algorithm: sha256
[    1.535634] ima: No architecture policies found
[    1.535645] evm: Initialising EVM extended attributes:
[    1.535645] evm: security.selinux
[    1.535647] evm: security.SMACK64 (disabled)
[    1.535647] evm: security.SMACK64EXEC (disabled)
[    1.535648] evm: security.SMACK64TRANSMUTE (disabled)
[    1.535649] evm: security.SMACK64MMAP (disabled)
[    1.535649] evm: security.apparmor (disabled)
[    1.535650] evm: security.ima
[    1.535651] evm: security.capability
[    1.535651] evm: HMAC attrs: 0x1
[    1.579782] alg: No test for 842 (842-scomp)
[    1.579805] alg: No test for 842 (842-generic)
[    1.672504] PM:   Magic number: 7:757:477
[    1.672616] RAS: Correctable Errors collector initialized.
[    1.673542] Freeing unused decrypted memory: 2036K
[    1.673950] Freeing unused kernel image (initmem) memory: 3012K
[    1.677772] Write protecting the kernel read-only data: 32768k
[    1.678407] Freeing unused kernel image (text/rodata gap) memory: 2036K
[    1.678713] Freeing unused kernel image (rodata/data gap) memory: 1524K
[    1.720416] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    1.720422] rodata_test: all tests were successful
[    1.720423] x86/mm: Checking user space page tables
[    1.739643] usb 1-2: new high-speed USB device number 2 using xhci_hcd
[    1.760474] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    1.760478] Run /init as init process
[    1.760479]   with arguments:
[    1.760480]     /init
[    1.760481]     rhgb
[    1.760482]   with environment:
[    1.760483]     HOME=3D/
[    1.760483]     TERM=3Dlinux
[    1.760484]     BOOT_IMAGE=3D(hd0,msdos1)/vmlinuz-6.0.18-300.fc37.x86_64
[    1.768343] systemd[1]: systemd 251.10-588.fc37 running in system
mode (+PAM +AUDIT +SELINUX -APPARMOR +IMA +SMACK +SECCOMP -GCRYPT
+GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN -IPTC
+KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 +PWQUALITY +P11KIT +QRENCODE
+TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD +BPF_FRAMEWORK +XKBCOMMON +UTMP
+SYSVINIT default-hierarchy=3Dunified)
[    1.768349] systemd[1]: Detected architecture x86-64.
[    1.768351] systemd[1]: Running in initial RAM disk.
[    1.768391] systemd[1]: Hostname set to <rclaptop>.
[    1.884589] usb 1-2: New USB device found, idVendor=3D0bda,
idProduct=3D564b, bcdDevice=3D 0.06
[    1.884594] usb 1-2: New USB device strings: Mfr=3D3, Product=3D1, Seria=
lNumber=3D2
[    1.884596] usb 1-2: Product: WebCamera
[    1.884598] usb 1-2: Manufacturer: Generic
[    1.884599] usb 1-2: SerialNumber: \x07LOE65001063010A8C60125DAI06BF1200=
0
[    1.980111] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
[    2.001408] usb 2-2: New USB device found, idVendor=3D05e3,
idProduct=3D0626, bcdDevice=3D 6.63
[    2.001419] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.001423] usb 2-2: Product: USB3.1 Hub
[    2.001427] usb 2-2: Manufacturer: GenesysLogic
[    2.004721] hub 2-2:1.0: USB hub found
[    2.005731] hub 2-2:1.0: 4 ports detected
[    2.110775] usb 1-3: new full-speed USB device number 3 using xhci_hcd
[    2.181879] systemd[1]: bpf-lsm: LSM BPF program attached
[    2.237982] usb 1-3: New USB device found, idVendor=3D8087,
idProduct=3D0a2a, bcdDevice=3D 0.03
[    2.237989] usb 1-3: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    2.244287] systemd[1]: Queued start job for default target initrd.targe=
t.
[    2.244415] systemd[1]: Reached target initrd-usr-fs.target -
Initrd /usr File System.
[    2.244470] systemd[1]: Reached target local-fs.target - Local File Syst=
ems.
[    2.244485] systemd[1]: Reached target slices.target - Slice Units.
[    2.244497] systemd[1]: Reached target swap.target - Swaps.
[    2.244510] systemd[1]: Reached target timers.target - Timer Units.
[    2.244601] systemd[1]: Listening on dbus.socket - D-Bus System
Message Bus Socket.
[    2.244789] systemd[1]: Listening on systemd-journald-audit.socket
- Journal Audit Socket.
[    2.244881] systemd[1]: Listening on
systemd-journald-dev-log.socket - Journal Socket (/dev/log).
[    2.244977] systemd[1]: Listening on systemd-journald.socket -
Journal Socket.
[    2.245092] systemd[1]: Listening on systemd-udevd-control.socket -
udev Control Socket.
[    2.245162] systemd[1]: Listening on systemd-udevd-kernel.socket -
udev Kernel Socket.
[    2.245174] systemd[1]: Reached target sockets.target - Socket Units.
[    2.261156] systemd[1]: Starting kmod-static-nodes.service - Create
List of Static Device Nodes...
[    2.261232] systemd[1]: memstrack.service - Memstrack Anylazing
Service was skipped because all trigger condition checks failed.
[    2.262729] systemd[1]: Starting systemd-journald.service - Journal
Service...
[    2.264080] systemd[1]: Starting systemd-modules-load.service -
Load Kernel Modules...
[    2.265077] systemd[1]: Starting systemd-sysusers.service - Create
System Users...
[    2.266156] systemd[1]: Starting systemd-vconsole-setup.service -
Setup Virtual Console...
[    2.273832] systemd[1]: Finished kmod-static-nodes.service - Create
List of Static Device Nodes.
[    2.287797] systemd[1]: Finished systemd-sysusers.service - Create
System Users.
[    2.287882] audit: type=3D1130 audit(1674556139.283:2): pid=3D1 uid=3D0
auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsystemd-sysu=
sers
comm=3D"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D?
terminal=3D? res=3Dsuccess'
[    2.296891] systemd[1]: Starting systemd-tmpfiles-setup-dev.service
- Create Static Device Nodes in /dev...
[    2.299000] fuse: init (API version 7.36)
[    2.302683] usb 2-2.1: new SuperSpeed USB device number 3 using xhci_hcd
[    2.309783] systemd[1]: Finished systemd-tmpfiles-setup-dev.service
- Create Static Device Nodes in /dev.
[    2.309886] audit: type=3D1130 audit(1674556139.305:3): pid=3D1 uid=3D0
auid=3D4294967295 ses=3D4294967295 subj=3Dkernel
msg=3D'unit=3Dsystemd-tmpfiles-setup-dev comm=3D"systemd"
exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?
res=3Dsuccess'
[    2.310441] systemd[1]: Started systemd-journald.service - Journal Servi=
ce.
[    2.310531] audit: type=3D1130 audit(1674556139.305:4): pid=3D1 uid=3D0
auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsystemd-jour=
nald
comm=3D"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D?
terminal=3D? res=3Dsuccess'
[    2.315231] usb 2-2.1: New USB device found, idVendor=3D0bda,
idProduct=3D8153, bcdDevice=3D31.00
[    2.315238] usb 2-2.1: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D6
[    2.315240] usb 2-2.1: Product: USB 10/100/1000 LAN
[    2.315242] usb 2-2.1: Manufacturer: Realtek
[    2.315244] usb 2-2.1: SerialNumber: 001000000
[    2.324993] audit: type=3D1130 audit(1674556139.320:5): pid=3D1 uid=3D0
auid=3D4294967295 ses=3D4294967295 subj=3Dkernel
msg=3D'unit=3Dsystemd-modules-load comm=3D"systemd"
exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?
res=3Dsuccess'
[    2.328903] audit: type=3D1130 audit(1674556139.324:6): pid=3D1 uid=3D0
auid=3D4294967295 ses=3D4294967295 subj=3Dkernel
msg=3D'unit=3Dsystemd-tmpfiles-setup comm=3D"systemd"
exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?
res=3Dsuccess'
[    2.351946] audit: type=3D1130 audit(1674556139.347:7): pid=3D1 uid=3D0
auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsystemd-sysc=
tl
comm=3D"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D?
terminal=3D? res=3Dsuccess'
[    2.359939] audit: type=3D1130 audit(1674556139.355:8): pid=3D1 uid=3D0
auid=3D4294967295 ses=3D4294967295 subj=3Dkernel
msg=3D'unit=3Dsystemd-vconsole-setup comm=3D"systemd"
exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?
res=3Dsuccess'
[    2.386963] audit: type=3D1130 audit(1674556139.382:9): pid=3D1 uid=3D0
auid=3D4294967295 ses=3D4294967295 subj=3Dkernel
msg=3D'unit=3Ddracut-cmdline-ask comm=3D"systemd"
exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?
res=3Dsuccess'
[    2.429616] usb 1-5: new high-speed USB device number 4 using xhci_hcd
[    2.455911] audit: type=3D1130 audit(1674556139.451:10): pid=3D1 uid=3D0
auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Ddracut-cmdli=
ne
comm=3D"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D?
terminal=3D? res=3Dsuccess'
[    2.546971] usbcore: registered new interface driver r8152
[    2.559552] usb 1-5: New USB device found, idVendor=3D05e3,
idProduct=3D0610, bcdDevice=3D 6.63
[    2.559556] usb 1-5: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.559558] usb 1-5: Product: USB2.1 Hub
[    2.559559] usb 1-5: Manufacturer: GenesysLogic
[    2.560777] hub 1-5:1.0: USB hub found
[    2.561025] hub 1-5:1.0: 4 ports detected
[    2.622961] usb 2-2.1: reset SuperSpeed USB device number 3 using xhci_h=
cd
[    2.659535] r8152 2-2.1:1.0: load rtl8153b-2 v1 10/23/19 successfully
[    2.694724] r8152 2-2.1:1.0 eth0: v1.12.13
[    2.793917] r8152 2-2.1:1.0 enp0s20f0u2u1: renamed from eth0
[    2.857703] usb 1-5.4: new full-speed USB device number 5 using xhci_hcd
[    2.893291] input: WCOM50C1:00 2D1F:5143 Touchscreen as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input5
[    2.893401] input: WCOM50C1:00 2D1F:5143 as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input6
[    2.893454] input: WCOM50C1:00 2D1F:5143 Stylus as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input7
[    2.893541] input: WCOM50C1:00 2D1F:5143 as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input8
[    2.893643] input: WCOM50C1:00 2D1F:5143 Mouse as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input9
[    2.893755] hid-generic 0018:2D1F:5143.0001: input,hidraw0: I2C HID
v1.00 Mouse [WCOM50C1:00 2D1F:5143] on i2c-WCOM50C1:00
[    2.897043] input: ACPI0C50:00 18D1:5028 as
/devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-2/i2c-ACPI0C50:00/001=
8:18D1:5028.0002/input/input10
[    2.919045] hid-multitouch 0018:18D1:5028.0002: input,hidraw1: I2C
HID v1.00 Device [ACPI0C50:00 18D1:5028] on i2c-ACPI0C50:00
[    2.935107] sdhci: Secure Digital Host Controller Interface driver
[    2.935112] sdhci: Copyright(c) Pierre Ossman
[    2.952783] sdhci-pci 0000:00:1e.4: SDHCI controller found
[8086:9d2b] (rev 21)
[    2.954175] mmc0: SDHCI controller on PCI [0000:00:1e.4] using ADMA 64-b=
it
[    2.960039] nvme nvme0: pci function 0000:02:00.0
[    2.960688] usb 1-5.4: New USB device found, idVendor=3D046d,
idProduct=3Dc52f, bcdDevice=3D22.00
[    2.960695] usb 1-5.4: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D0
[    2.960698] usb 1-5.4: Product: USB Receiver
[    2.960701] usb 1-5.4: Manufacturer: Logitech
[    2.967609] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5.4/1-5.4:1.0/0003:046D:C52F.00=
03/input/input11
[    2.967715] hid-generic 0003:046D:C52F.0003: input,hidraw0: USB HID
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:14.0-5.4/input0
[    2.967759] nvme nvme0: Shutdown timeout set to 10 seconds
[    2.969314] input: Logitech USB Receiver Consumer Control as
/devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5.4/1-5.4:1.1/0003:046D:C52F.00=
04/input/input12
[    2.972531] input: WCOM50C1:00 2D1F:5143 as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input15
[    2.972803] nvme nvme0: 4/0/0 default/read/poll queues
[    2.980183]  nvme0n1: p1 p2
[    3.020843] hid-generic 0003:046D:C52F.0004:
input,hiddev96,hidraw2: USB HID v1.11 Device [Logitech USB Receiver]
on usb-0000:00:14.0-5.4/input1
[    3.021374] input: WCOM50C1:00 2D1F:5143 UNKNOWN as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input16
[    3.021474] input: WCOM50C1:00 2D1F:5143 Stylus as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input17
[    3.021573] input: WCOM50C1:00 2D1F:5143 UNKNOWN as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input18
[    3.022082] input: WCOM50C1:00 2D1F:5143 Mouse as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0001/input/input19
[    3.022204] hid-multitouch 0018:2D1F:5143.0001: input,hidraw3: I2C
HID v1.00 Mouse [WCOM50C1:00 2D1F:5143] on i2c-WCOM50C1:00
[    3.046039] BTRFS: device label fedora_localhost-live devid 1
transid 77044 /dev/nvme0n1p2 scanned by systemd-udevd (378)
[    3.050988] logitech-djreceiver 0003:046D:C52F.0003: hidraw0: USB
HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:14.0-5.4/input0
[    3.117028] logitech-djreceiver 0003:046D:C52F.0004:
hiddev96,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on
usb-0000:00:14.0-5.4/input1
[    3.171016] logitech-djreceiver 0003:046D:C52F.0004: device of type
eQUAD step 4 DJ (0x04) connected on slot 1
[    3.352725] input: Logitech Wireless Mouse PID:1024 Mouse as
/devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5.4/1-5.4:1.1/0003:046D:C52F.00=
04/0003:046D:1024.0005/input/input20
[    3.353113] input: Logitech Wireless Mouse PID:1024 Consumer
Control as /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5.4/1-5.4:1.1/0003:0=
46D:C52F.0004/0003:046D:1024.0005/input/input21
[    3.353204] hid-generic 0003:046D:1024.0005: input,hidraw4: USB HID
v1.11 Mouse [Logitech Wireless Mouse PID:1024] on
usb-0000:00:14.0-5.4/input1:1
[    3.362875] i915 0000:00:02.0: vgaarb: deactivate vga console
[    3.409212] input: Logitech M310 as
/devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5.4/1-5.4:1.1/0003:046D:C52F.00=
04/0003:046D:1024.0005/input/input25
[    3.409346] logitech-hidpp-device 0003:046D:1024.0005:
input,hidraw4: USB HID v1.11 Mouse [Logitech M310] on
usb-0000:00:14.0-5.4/input1:1
[    3.413783] i915 0000:00:02.0: vgaarb: changed VGA decodes:
olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    3.416016] i915 0000:00:02.0: [drm] Finished loading DMC firmware
i915/kbl_dmc_ver1_04.bin (v1.4)
[    3.450348] i915 0000:00:02.0: [drm] [ENCODER:102:DDI B/PHY B] is
disabled/in DSI mode with an ungated DDI clock, gate it
[    3.450356] i915 0000:00:02.0: [drm] [ENCODER:113:DDI C/PHY C] is
disabled/in DSI mode with an ungated DDI clock, gate it
[    3.454897] [drm] Initialized i915 1.6.0 20201103 for 0000:00:02.0 on mi=
nor 0
[    3.457039] fbcon: i915drmfb (fb0) is primary device
[    3.457043] fbcon: Deferring console take-over
[    3.457046] i915 0000:00:02.0: [drm] fb0: i915drmfb frame buffer device
[    3.559225] BTRFS info (device nvme0n1p2): using crc32c
(crc32c-intel) checksum algorithm
[    3.559239] BTRFS info (device nvme0n1p2): using free space tree
[    3.636215] BTRFS info (device nvme0n1p2): enabling ssd optimizations
[    4.226382] systemd-journald[254]: Received SIGTERM from PID 1 (systemd)=
.
[    4.394914] SELinux:  policy capability network_peer_controls=3D1
[    4.394917] SELinux:  policy capability open_perms=3D1
[    4.394918] SELinux:  policy capability extended_socket_class=3D1
[    4.394919] SELinux:  policy capability always_check_network=3D0
[    4.394919] SELinux:  policy capability cgroup_seclabel=3D1
[    4.394920] SELinux:  policy capability nnp_nosuid_transition=3D1
[    4.394921] SELinux:  policy capability genfs_seclabel_symlinks=3D1
[    4.394921] SELinux:  policy capability ioctl_skip_cloexec=3D0
[    4.437062] systemd[1]: Successfully loaded SELinux policy in 86.860ms.
[    4.469846] systemd[1]: Relabelled /dev, /dev/shm, /run,
/sys/fs/cgroup in 25.720ms.
[    4.473092] systemd[1]: systemd 251.10-588.fc37 running in system
mode (+PAM +AUDIT +SELINUX -APPARMOR +IMA +SMACK +SECCOMP -GCRYPT
+GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN -IPTC
+KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 +PWQUALITY +P11KIT +QRENCODE
+TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD +BPF_FRAMEWORK +XKBCOMMON +UTMP
+SYSVINIT default-hierarchy=3Dunified)
[    4.473100] systemd[1]: Detected architecture x86-64.
[    4.797904] systemd[1]: bpf-lsm: LSM BPF program attached
[    5.030093] systemd-sysv-generator[548]: SysV service
'/etc/rc.d/init.d/livesys' lacks a native systemd unit file.
Automatically generating a unit file for compatibility. Please update
package to include a native systemd unit file, in order to make it
more safe and robust.
[    5.030180] systemd-sysv-generator[548]: SysV service
'/etc/rc.d/init.d/livesys-late' lacks a native systemd unit file.
Automatically generating a unit file for compatibility. Please update
package to include a native systemd unit file, in order to make it
more safe and robust.
[    5.057869] zram: Added device: zram0
[    5.231501] systemd[1]: initrd-switch-root.service: Deactivated successf=
ully.
[    5.239998] systemd[1]: Stopped initrd-switch-root.service - Switch Root=
.
[    5.240695] systemd[1]: systemd-journald.service: Scheduled restart
job, restart counter is at 1.
[    5.241074] systemd[1]: Created slice machine.slice - Virtual
Machine and Container Slice.
[    5.241644] systemd[1]: Created slice system-getty.slice - Slice
/system/getty.
[    5.242013] systemd[1]: Created slice system-modprobe.slice - Slice
/system/modprobe.
[    5.242373] systemd[1]: Created slice system-sshd\x2dkeygen.slice -
Slice /system/sshd-keygen.
[    5.242871] systemd[1]: Created slice system-systemd\x2dfsck.slice
- Slice /system/systemd-fsck.
[    5.243231] systemd[1]: Created slice
system-systemd\x2dzram\x2dsetup.slice - Slice
/system/systemd-zram-setup.
[    5.243577] systemd[1]: Created slice user.slice - User and Session Slic=
e.
[    5.243660] systemd[1]: systemd-ask-password-console.path -
Dispatch Password Requests to Console Directory Watch was skipped
because of a failed condition check
(ConditionPathExists=3D!/run/plymouth/pid).
[    5.243810] systemd[1]: Started systemd-ask-password-wall.path -
Forward Password Requests to Wall Directory Watch.
[    5.244243] systemd[1]: Set up automount
proc-sys-fs-binfmt_misc.automount - Arbitrary Executable File Formats
File System Automount Point.
[    5.244335] systemd[1]: Reached target cryptsetup.target - Local
Encrypted Volumes.
[    5.244389] systemd[1]: Reached target getty.target - Login Prompts.
[    5.244444] systemd[1]: Stopped target initrd-switch-root.target -
Switch Root.
[    5.244487] systemd[1]: Stopped target initrd-fs.target - Initrd
File Systems.
[    5.244520] systemd[1]: Stopped target initrd-root-fs.target -
Initrd Root File System.
[    5.244559] systemd[1]: Reached target integritysetup.target -
Local Integrity Protected Volumes.
[    5.244701] systemd[1]: Reached target slices.target - Slice Units.
[    5.244781] systemd[1]: Reached target veritysetup.target - Local
Verity Protected Volumes.
[    5.245485] systemd[1]: Listening on dm-event.socket -
Device-mapper event daemon FIFOs.
[    5.246430] systemd[1]: Listening on lvm2-lvmpolld.socket - LVM2
poll daemon socket.
[    5.247711] systemd[1]: Listening on systemd-coredump.socket -
Process Core Dump Socket.
[    5.247896] systemd[1]: Listening on systemd-initctl.socket -
initctl Compatibility Named Pipe.
[    5.248376] systemd[1]: Listening on systemd-oomd.socket -
Userspace Out-Of-Memory (OOM) Killer Socket.
[    5.249687] systemd[1]: Listening on systemd-udevd-control.socket -
udev Control Socket.
[    5.249999] systemd[1]: Listening on systemd-udevd-kernel.socket -
udev Kernel Socket.
[    5.250569] systemd[1]: Listening on systemd-userdbd.socket - User
Database Manager Socket.
[    5.260845] systemd[1]: Mounting dev-hugepages.mount - Huge Pages
File System...
[    5.262236] systemd[1]: Mounting dev-mqueue.mount - POSIX Message
Queue File System...
[    5.263571] systemd[1]: Mounting sys-kernel-debug.mount - Kernel
Debug File System...
[    5.265631] systemd[1]: Mounting sys-kernel-tracing.mount - Kernel
Trace File System...
[    5.266010] systemd[1]: auth-rpcgss-module.service - Kernel Module
supporting RPCSEC_GSS was skipped because of a failed condition check
(ConditionPathExists=3D/etc/krb5.keytab).
[    5.267522] systemd[1]: Starting kmod-static-nodes.service - Create
List of Static Device Nodes...
[    5.269085] systemd[1]: Starting lvm2-monitor.service - Monitoring
of LVM2 mirrors, snapshots etc. using dmeventd or progress polling...
[    5.271288] systemd[1]: Starting modprobe@configfs.service - Load
Kernel Module configfs...
[    5.273162] systemd[1]: Starting modprobe@drm.service - Load Kernel
Module drm...
[    5.275220] systemd[1]: Starting modprobe@fuse.service - Load
Kernel Module fuse...
[    5.275457] systemd[1]: plymouth-switch-root.service: Deactivated
successfully.
[    5.283732] systemd[1]: Stopped plymouth-switch-root.service -
Plymouth switch root service.
[    5.283891] kauditd_printk_skb: 89 callbacks suppressed
[    5.283893] audit: type=3D1131 audit(1674556142.279:100): pid=3D1 uid=3D=
0
auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:init_t:s0
msg=3D'unit=3Dplymouth-switch-root comm=3D"systemd"
exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?
res=3Dsuccess'
[    5.284122] systemd[1]: systemd-fsck-root.service: Deactivated successfu=
lly.
[    5.293679] systemd[1]: Stopped systemd-fsck-root.service - File
System Check on Root Device.
[    5.293725] audit: type=3D1131 audit(1674556142.289:101): pid=3D1 uid=3D=
0
auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:init_t:s0
msg=3D'unit=3Dsystemd-fsck-root comm=3D"systemd"
exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?
res=3Dsuccess'
[    5.293779] systemd[1]: Stopped systemd-journald.service - Journal Servi=
ce.
[    5.293813] audit: type=3D1130 audit(1674556142.289:102): pid=3D1 uid=3D=
0
auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:init_t:s0
msg=3D'unit=3Dsystemd-journald comm=3D"systemd"
exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?
res=3Dsuccess'
[    5.293827] audit: type=3D1131 audit(1674556142.289:103): pid=3D1 uid=3D=
0
auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:init_t:s0
msg=3D'unit=3Dsystemd-journald comm=3D"systemd"
exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D?
res=3Dsuccess'
[    5.294762] audit: type=3D1334 audit(1674556142.290:104): prog-id=3D52 o=
p=3DLOAD
[    5.294965] audit: type=3D1334 audit(1674556142.290:105): prog-id=3D53 o=
p=3DLOAD
[    5.295052] audit: type=3D1334 audit(1674556142.290:106): prog-id=3D54 o=
p=3DLOAD
[    5.295067] audit: type=3D1334 audit(1674556142.290:107): prog-id=3D0 op=
=3DUNLOAD
[    5.295078] audit: type=3D1334 audit(1674556142.290:108): prog-id=3D0 op=
=3DUNLOAD
[    5.305960] systemd[1]: Starting systemd-journald.service - Journal
Service...
[    5.307592] systemd[1]: Starting systemd-modules-load.service -
Load Kernel Modules...
[    5.309444] systemd[1]: Starting systemd-network-generator.service
- Generate network units from Kernel command line...
[    5.311611] systemd[1]: Starting systemd-remount-fs.service -
Remount Root and Kernel File Systems...
[    5.311843] systemd[1]: systemd-repart.service - Repartition Root
Disk was skipped because all trigger condition checks failed.
[    5.313937] systemd[1]: Starting systemd-udev-trigger.service -
Coldplug All udev Devices...
[    5.318466] systemd[1]: Mounted dev-hugepages.mount - Huge Pages File Sy=
stem.
[    5.319164] systemd[1]: Mounted dev-mqueue.mount - POSIX Message
Queue File System.
[    5.319787] systemd[1]: Mounted sys-kernel-debug.mount - Kernel
Debug File System.
[    5.320424] systemd[1]: Mounted sys-kernel-tracing.mount - Kernel
Trace File System.
[    5.323929] audit: type=3D1305 audit(1674556142.319:109): op=3Dset
audit_enabled=3D1 old=3D1 auid=3D4294967295 ses=3D4294967295
subj=3Dsystem_u:system_r:syslogd_t:s0 res=3D1
[    5.325022] BTRFS info (device nvme0n1p2: state M): use zstd
compression, level 1
[    5.331805] systemd[1]: Finished kmod-static-nodes.service - Create
List of Static Device Nodes.
[    5.333008] systemd[1]: Started systemd-journald.service - Journal Servi=
ce.
[    5.401190] systemd-journald[575]: Received client request to flush
runtime journal.
[    5.404671] systemd-journald[575]: File
/var/log/journal/d91ce01f8d294edb8b338a20c7a956c7/system.journal
corrupted or uncleanly shut down, renaming and replacing.
[    5.741016] zram0: detected capacity change from 0 to 16777216
[    5.912034] Adding 8388604k swap on /dev/zram0.  Priority:100
extents:1 across:8388604k SSDscFS
[    5.970272] chromeos ramoops using acpi device.
[    5.993677] cros-usbpd-notify-acpi GOOG0003:00: Couldn't get Chrome
EC device pointer.
[    6.008246] Consider using thermal netlink events interface
[    6.040063] intel_rapl_common: Found RAPL domain package
[    6.040068] intel_rapl_common: Found RAPL domain dram
[    6.047610] cros_ec_lpcs GOOG0004:00: Chrome EC device registered
[    6.057174] cr50_i2c i2c-GOOG0005:00: cr50 TPM 2.0 (i2c 0x50 irq 24 id 0=
x28)
[    6.083724] cros-ec-i2c i2c-GOOG0008:00: Chrome EC device registered
[    6.104231] mc: Linux media interface: v0.10
[    6.172698] videodev: Linux video capture interface: v2.00
[    6.172893] idma64 idma64.0: Found Intel integrated DMA 64-bit
[    6.173117] idma64 idma64.1: Found Intel integrated DMA 64-bit
[    6.173203] idma64 idma64.2: Found Intel integrated DMA 64-bit
[    6.185779] idma64 idma64.5: Found Intel integrated DMA 64-bit
[    6.197783] idma64 idma64.6: Found Intel integrated DMA 64-bit
[    6.229779] EXT4-fs (nvme0n1p1): mounted filesystem with ordered
data mode. Quota mode: none.
[    6.267889] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[    6.334665] Bluetooth: Core ver 2.22
[    6.334699] NET: Registered PF_BLUETOOTH protocol family
[    6.334701] Bluetooth: HCI device and connection manager initialized
[    6.334811] Bluetooth: HCI socket layer initialized
[    6.334815] Bluetooth: L2CAP socket layer initialized
[    6.334823] Bluetooth: SCO socket layer initialized
[    6.388520] usb 1-2: Found UVC 1.00 device WebCamera (0bda:564b)
[    6.402702] input: WebCamera: WebCamera as
/devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/input/input26
[    6.402806] usbcore: registered new interface driver uvcvideo
[    6.436970] max98927 i2c-MX98927:00: MAX98927 revisionID: 0x42
[    6.437251] max98927 i2c-MX98927:01: MAX98927 revisionID: 0x42
[    6.495393] cfg80211: Loading compiled-in X.509 certificates for
regulatory database
[    6.496133] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    6.499951] input: PC Speaker as /devices/platform/pcspkr/input/input27
[    6.539875] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[    6.539909] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[    6.539958] pci 0000:00:1f.1: [8086:9d20] type 00 class 0x058000
[    6.540018] pci 0000:00:1f.1: reg 0x10: [mem 0xfd000000-0xfdffffff 64bit=
]
[    6.574106] rt5663 i2c-10EC5663:00: supply avdd not found, using
dummy regulator
[    6.574276] rt5663 i2c-10EC5663:00: supply cpvdd not found, using
dummy regulator
[    6.633924] usbcore: registered new interface driver btusb
[    6.645465] RPC: Registered named UNIX socket transport module.
[    6.645469] RPC: Registered udp transport module.
[    6.645471] RPC: Registered tcp transport module.
[    6.645472] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    6.653942] Bluetooth: hci0: Legacy ROM 2.x revision 5.0 build 25
week 20 2015
[    6.660032] Bluetooth: hci0: Intel Bluetooth firmware file:
intel/ibt-hw-37.8.10-fw-22.50.19.14.f.bseq
[    6.741598] Intel(R) Wireless WiFi driver for Linux
[    6.748683] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters,
655360 ms ovfl timer
[    6.748687] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    6.748689] RAPL PMU: hw unit of domain package 2^-14 Joules
[    6.748690] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    6.748691] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    6.748692] RAPL PMU: hw unit of domain psys 2^-14 Joules
[    6.801482] iwlwifi 0000:01:00.0: Found debug destination: EXTERNAL_DRAM
[    6.801488] iwlwifi 0000:01:00.0: Found debug configuration: 0
[    6.801741] iwlwifi 0000:01:00.0: loaded firmware version
29.4063824552.0 7265D-29.ucode op_mode iwlmvm
[    6.825478] snd_hda_intel 0000:00:1f.3: DSP detected with PCI
class/subclass/prog-if info 0x040100
[    6.980912] Bluetooth: hci0: Intel BT fw patch 0x43 completed & activate=
d
[    7.094153] intel_rapl_common: Found RAPL domain package
[    7.094157] intel_rapl_common: Found RAPL domain core
[    7.094159] intel_rapl_common: Found RAPL domain uncore
[    7.094160] intel_rapl_common: Found RAPL domain dram
[    7.094162] intel_rapl_common: Found RAPL domain psys
[    7.192135] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band
Wireless AC 7265, REV=3D0x210
[    7.192244] thermal thermal_zone7: failed to read out thermal zone (-61)
[    7.207956] iwlwifi 0000:01:00.0: Applying debug destination EXTERNAL_DR=
AM
[    7.208163] iwlwifi 0000:01:00.0: Allocated 0x00400000 bytes for
firmware monitor.
[    7.219755] iwlwifi 0000:01:00.0: base HW address:
a0:a4:c5:22:3f:71, OTP minor version: 0x0
[    7.252484] snd_soc_skl 0000:00:1f.3: DSP detected with PCI
class/subclass/prog-if info 0x040100
[    7.271112] intel_tcc_cooling: Programmable TCC Offset detected
[    7.283823] cros-ec-dev cros-ec-dev.2.auto: CrOS Touchpad MCU detected
[    7.285767] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[    7.298561] snd_soc_skl 0000:00:1f.3: bound 0000:00:02.0 (ops
i915_audio_component_bind_ops [i915])
[    7.437094] iTCO_vendor_support: vendor-support=3D0
[    7.577263] input: ACPI0C50:00 18D1:5028 as
/devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-2/i2c-ACPI0C50:00/001=
8:18D1:5028.0006/input/input28
[    7.577527] hid-multitouch 0018:18D1:5028.0006: input,hidraw1: I2C
HID v1.00 Device [ACPI0C50:00 18D1:5028] on i2c-ACPI0C50:00
[    7.671754] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    7.671761] Bluetooth: BNEP filters: protocol multicast
[    7.671767] Bluetooth: BNEP socket layer initialized
[    7.701312] input: WCOM50C1:00 2D1F:5143 as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0007/input/input29
[    7.773232] input: WCOM50C1:00 2D1F:5143 UNKNOWN as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0007/input/input30
[    7.792396] input: WCOM50C1:00 2D1F:5143 Stylus as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0007/input/input31
[    7.792626] input: WCOM50C1:00 2D1F:5143 UNKNOWN as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0007/input/input32
[    7.792799] input: WCOM50C1:00 2D1F:5143 Mouse as
/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-WCOM50C1:00/001=
8:2D1F:5143.0007/input/input33
[    7.793444] hid-multitouch 0018:2D1F:5143.0007: input,hidraw3: I2C
HID v1.00 Mouse [WCOM50C1:00 2D1F:5143] on i2c-WCOM50C1:00
[    7.800044] Bluetooth: MGMT ver 1.22
[    7.809481] cros-usbpd-charger cros-usbpd-charger.4.auto: Could not
get charger port count
[    7.813145] iwlwifi 0000:01:00.0 wlp1s0: renamed from wlan0
[    7.834228] iTCO_wdt iTCO_wdt: Found a Intel PCH TCO device
(Version=3D4, TCOBASE=3D0x0400)
[    7.841318] iTCO_wdt iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=
=3D0)
[    7.843948] NET: Registered PF_QIPCRTR protocol family
[    8.132171] HDMI HDA Codec ehdaudio0D2: Max dais supported: 3
[    8.212512] snd_soc_skl 0000:00:1f.3: ASoC: no sink widget found
for AEC Capture
[    8.212520] snd_soc_skl 0000:00:1f.3: ASoC: Failed to add route
echo_ref_out cpr 7 -> direct -> AEC Capture
[    8.212536] kbl_r5514_5663_max kbl_r5514_5663_max: ASoC: Parent
card not yet available, widget card binding deferred
[    8.305367] rt5663 i2c-10EC5663:00: sysclk < 384 x fs, disable i2s asrc
[    8.306570] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense:
disconnect for pin:port 5:0
[    8.306698] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense:
disconnect for pin:port 6:0
[    8.306821] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense:
disconnect for pin:port 7:0
[    8.311643] input: kbl-r5514-5663-max Headset Jack as
/devices/platform/kbl_r5514_5663_max/sound/card0/input34
[    8.311833] input: kbl-r5514-5663-max HDMI/DP,pcm=3D6 Jack as
/devices/platform/kbl_r5514_5663_max/sound/card0/input35
[    8.311979] input: kbl-r5514-5663-max HDMI/DP,pcm=3D7 Jack as
/devices/platform/kbl_r5514_5663_max/sound/card0/input36
[    8.787957] iwlwifi 0000:01:00.0: Applying debug destination EXTERNAL_DR=
AM
[    8.795303] r8152 2-2.1:1.0 enp0s20f0u2u1: carrier on
[    8.873208] iwlwifi 0000:01:00.0: Applying debug destination EXTERNAL_DR=
AM
[    8.874523] iwlwifi 0000:01:00.0: FW already configured (0) - re-configu=
ring
[    8.885534] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s20f0u2u1: link becomes r=
eady
[    8.922287] iwlwifi 0000:01:00.0: Applying debug destination EXTERNAL_DR=
AM
[    9.000507] iwlwifi 0000:01:00.0: Applying debug destination EXTERNAL_DR=
AM
[    9.001920] iwlwifi 0000:01:00.0: FW already configured (0) - re-configu=
ring
[   14.336235] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   14.336672] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   14.337150] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   14.338004] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   14.338444] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   14.338879] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   14.366716] snd_soc_skl 0000:00:1f.3: Module list is empty
[   14.391814] snd_soc_skl 0000:00:1f.3: ipc FW reply: MCLK already
running FW Error Code: 0
[   14.391831] kbl_r5514_5663_max kbl_r5514_5663_max: Can't enable
mclk, err: 151
[   14.457281] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   14.458184] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   14.459454] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   14.493322] snd_soc_skl 0000:00:1f.3: ASoC: error at
soc_dai_trigger on HDMI2 Pin: -32
[   14.493330]  Kbl HDMI Port2: ASoC: trigger FE cmd: 1 failed: -32
[   14.495011] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   14.495509] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   14.496008] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   14.516669] snd_soc_skl 0000:00:1f.3: ASoC: error at
soc_dai_trigger on HDMI1 Pin: -32
[   14.516675]  Kbl HDMI Port1: ASoC: trigger FE cmd: 1 failed: -32
[   14.526345] rfkill: input handler disabled
[   24.656143] systemd-journald[575]: File
/var/log/journal/d91ce01f8d294edb8b338a20c7a956c7/user-1001.journal
corrupted or uncleanly shut down, renaming and replacing.
[   25.097876] rfkill: input handler enabled
[   25.722565] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   25.723005] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   25.723500] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   25.724424] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   25.724918] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   25.725418] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   26.296148] snd_soc_skl 0000:00:1f.3: ASoC: error at
snd_soc_dai_startup on Echoref Pin: -22
[   26.296158]  Kbl Audio Echo Reference cap: __soc_pcm_open() failed (-22)
[   26.421118] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   26.421616] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   26.422747] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   26.485529] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   26.485970] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   26.486422] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   26.527974] Bluetooth: RFCOMM TTY layer initialized
[   26.527984] Bluetooth: RFCOMM socket layer initialized
[   26.527996] Bluetooth: RFCOMM ver 1.11
[   26.568094] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   26.568593] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   26.569093] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   26.634535] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   26.635604] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   26.636249] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   26.636797] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   26.637300] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   26.637800] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   26.638839] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   26.639338] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   26.639838] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   26.655592] snd_soc_skl 0000:00:1f.3: MCPS Budget Violation: 9b050000
[   26.841430] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   26.841904] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   26.843221] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   26.901613] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   26.902489] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   26.902971] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   26.961904] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   26.963378] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   26.963879] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   27.053053] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   27.053559] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   27.058217] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   27.121290] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   27.121791] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   27.122290] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   27.124212] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   27.124706] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   27.125207] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   27.144613] snd_soc_skl 0000:00:1f.3: MCPS Budget Violation: 9b050000
[   27.162224] rfkill: input handler disabled
[   27.267599] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:0
[   27.268424] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:1
[   27.268859] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 5:2
[   27.855034] logitech-hidpp-device 0003:046D:1024.0005: HID++ 1.0
device connected.
[   27.933747] snd_soc_skl 0000:00:1f.3: ASoC: error at
soc_dai_trigger on HDMI2 Pin: -32
[   27.933753]  Kbl HDMI Port2: ASoC: trigger FE cmd: 1 failed: -32
[   27.935160] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:0
[   27.935678] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:1
[   27.936178] HDMI HDA Codec ehdaudio0D2: No connections found for pin:por=
t 6:2
[   28.036577] snd_soc_skl 0000:00:1f.3: ASoC: error at
soc_dai_trigger on HDMI1 Pin: -32
[   28.036584]  Kbl HDMI Port1: ASoC: trigger FE cmd: 1 failed: -32
[ 3677.233400] i2c_hid_acpi i2c-ACPI0C50:00: i2c_hid_get_input:
incomplete report (74/60652)

If you need anything else just let me know.

Thanks
Sasa

> Best regards,
> Lukasz
>
> wt., 24 sty 2023 o 06:09 Greg KH <gregkh@linuxfoundation.org> napisa=C5=
=82(a):
> >
> > On Mon, Jan 23, 2023 at 09:44:34PM +0100, Sasa Ostrouska wrote:
> > > Hi all, sorry if I put somebody in CC who is not the correct one. I
> > > have a google pixelbook and using it with Fedora 37.
> > > The last few kernels supplied by fedora 37, 6.1.6, 6.1.7 but also som=
e
> > > earlier have no working sound.
> > > I see the last kernel for me with working sound is 6.0.18.
> > > On my pixelbook this is showing in dmesg:
> >
> > Any chance you can use 'git bisect' to track down the offending commit?
> >
> > thanks,
> >
> > greg k-h
