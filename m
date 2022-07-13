Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D045A573B9B
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 18:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiGMQyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 12:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiGMQyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 12:54:52 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A3329824;
        Wed, 13 Jul 2022 09:54:49 -0700 (PDT)
Received: from quatroqueijos (unknown [179.93.156.216])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id EA0493F3C1;
        Wed, 13 Jul 2022 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1657731287;
        bh=k/051IrXQ3mmpWzTi8XT7epL2x4DGtpxxDFcro41vWg=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=lMaqXf9giU92GcGHd+ZVPpAX5kivK5wyYyARwoHI7bGH8y2i47oZxnsAObklp5oZj
         257I66VO52jz9BQs6Xnech7PgbGkQlI6tKY5UKgO37t/owXqPRBmIt40Dg+Mz65OiJ
         qhjshI33C7vIhn9FIQKE15GQbyY53WIP/LoXH7iwCZ3+3kVzm64tS/UcdsXuiJnJX/
         Lc4HXtQ28w1F09dKsC3jyedWww3A9B1FralCaVh8jGUoBvcF3zSkL7PkS3fS0kEjum
         LRWR3Xh1/CZvdAsOLOZW4briQeum9tHkp926id3u6CppMVmjaK6Bg8RfLznviCa1++
         vxmypy9QfSB0A==
Date:   Wed, 13 Jul 2022 13:54:34 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
Message-ID: <Ys74yvOUuZqrl9D7@quatroqueijos>
References: <20220712183236.931648980@linuxfoundation.org>
 <CA+G9fYvRQ9gzee8pjRmsyedz6oGyh5pzSYEPkuDoKEE+X2RZDg@mail.gmail.com>
 <Ys7Cm17ShWUOXkRw@kroah.com>
 <CA+G9fYuf7KqVYNqLdZci1BVYK--QEqaLOVYmmLjObTMROyvfew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuf7KqVYNqLdZci1BVYK--QEqaLOVYmmLjObTMROyvfew@mail.gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 07:28:40PM +0530, Naresh Kamboju wrote:
> On Wed, 13 Jul 2022 at 18:33, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Jul 13, 2022 at 04:33:24PM +0530, Naresh Kamboju wrote:
> > > On Wed, 13 Jul 2022 at 00:21, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.18.12 release.
> > > > There are 61 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.12-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > >
> > > Results from Linaro’s test farm.
> > > Regressions on x86_64 (and still validating results)
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > 1) kernel panic on x86_64 while running kvm-unit-tests.
> > >    - APIC base relocation is unsupported by KVM
> >
> > Seems others are hitting this too:
> >         https://lore.kernel.org/r/CAMGffEm9y0wnn8LNS9Qo3obPhs0GD5iJZ0WejFzC4baGPDsYTw@mail.gmail.com
> >
> > Does this also happen right now on Linus's tree?
> 
> I see this on the mainline 5.19.0-rc6 kernel.
> more data is at the bottom of the email.
> 

I think I know what this is and I am just testing a fix. This is due to
FASTOP_SIZE not taking into consideration the size of the return thunk jump.

Cascardo.

> TESTNAME=emulator TIMEOUT=90s ACCEL= ./x86/run x86/emulator.flat -smp 1
> [  110.831265] kvm: emulating exchange as write
> [  110.837146] int3: 0000 [#1] PREEMPT SMP PTI
> [  110.837149] CPU: 3 PID: 3804 Comm: qemu-system-x86 Not tainted 5.19.0-rc6 #1
> [  110.837151] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  110.837151] RIP: 0010:xaddw_ax_dx+0x9/0x10
> 
> https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.19-rc6-111-gb047602d579b/testrun/10811596/suite/log-parser-test/tests/
> >
> > > 2) qemu_x86_64 boot warning
> > >    - WARNING: CPU: 0 PID: 0 at arch/x86/kernel/alternative.c:558
> > > apply_returns+0x19c/0x1d0
> >
> > Warning, but does everything still work?
> > And again, still on Linus's tree?
> 
> yes.
> The same kernel warning on qemu_x86_64.
> 
> <6>[    1.163406] MDS: Vulnerable: Clear CPU buffers attempted, no microcode
> <4>[    1.502974] ------------[ cut here ]------------
> <4>[    1.504324] WARNING: CPU: 0 PID: 0 at
> arch/x86/kernel/alternative.c:558 apply_returns+0x19c/0x1d0
> <4>[    1.505319] Modules linked in:
> <4>[    1.506482] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc6 #1
> <4>[    1.507244] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS 1.14.0-2 04/01/2014
> <4>[    1.508031] RIP: 0010:apply_returns+0x19c/0x1d0
> 
> https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.19-rc6-111-gb047602d579b/testrun/10804486/suite/log-parser-test/tests/
> 
> >
> 
> >
> > > 3) New warnings noticed while building perf
> > >    - Warning: Kernel ABI header at
> > > 'tools/arch/x86/include/asm/disabled-features.h' differs from latest
> > > version at 'arch/x86/include/asm/disabled-features.h'
> >
> > Ick, I'll wait for that to get synced in Linus's tree.
> >
> 
> ---
> TESTNAME=emulator TIMEOUT=90s ACCEL= ./x86/run x86/emulator.flat -smp 1
> [  110.831265] kvm: emulating exchange as write
> [  110.837146] int3: 0000 [#1] PREEMPT SMP PTI
> [  110.837149] CPU: 3 PID: 3804 Comm: qemu-system-x86 Not tainted 5.19.0-rc6 #1
> [  110.837151] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  110.837151] RIP: 0010:xaddw_ax_dx+0x9/0x10
> [  110.837155] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [  110.837156] RSP: 0018:ffffa3ca02fafce0 EFLAGS: 00000206
> [  110.837158] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [  110.837159] RDX: 0000000076543210 RSI: ffffffffaa858f90 RDI: 0000000000000204
> [  110.837160] RBP: ffffa3ca02fafce8 R08: ffff9785cd9e7380 R09: 0000000000000002
> [  110.837161] R10: ffff9785cd9e7380 R11: ffff978583b6c0c8 R12: ffff9785cd9e7380
> [  110.837161] R13: ffffffffabe09d20 R14: 0000000000000000 R15: 0000000000000000
> [  110.837162] FS:  00007f9c6ee4f700(0000) GS:ffff9788dfd80000(0000)
> knlGS:0000000000000000
> [  110.837163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  110.837164] CR2: 0000000000000000 CR3: 0000000103b86001 CR4: 00000000003726e0
> [  110.837165] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  110.837166] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  110.837166] Call Trace:
> [  110.837167]  <TASK>
> [  110.837168]  ? fastop+0x5d/0xa0
> [  110.837170]  x86_emulate_insn+0x7c9/0xf20
> [  110.837172]  x86_emulate_instruction+0x46d/0x7e0
> [  110.837174]  ? trace_hardirqs_on+0x37/0x100
> [  110.837177]  complete_emulated_mmio+0x211/0x2c0
> [  110.837178]  kvm_arch_vcpu_ioctl_run+0x12a3/0x2310
> [  110.837180]  ? vfs_writev+0xcb/0x1a0
> [  110.837183]  kvm_vcpu_ioctl+0x27e/0x6d0
> [  110.837185]  ? clockevents_program_event+0x98/0x100
> [  110.837188]  ? selinux_file_ioctl+0xae/0x140
> [  110.837191]  ? selinux_file_ioctl+0xae/0x140
> [  110.837193]  __x64_sys_ioctl+0x95/0xd0
> [  110.837195]  do_syscall_64+0x3b/0x90
> [  110.837199]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  110.837200] RIP: 0033:0x7f9c707d98f7
> [  110.837202] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
> 01 48
> [  110.837203] RSP: 002b:00007f9c6ee4ea28 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  110.837204] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f9c707d98f7
> [  110.837205] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000f
> [  110.837206] RBP: 00005612cd03faf0 R08: 00005612cba7c450 R09: 00000000ffffffff
> [  110.837206] R10: 00007ffdfdda3080 R11: 0000000000000246 R12: 0000000000000000
> [  110.837207] R13: 00007f9c72b09000 R14: 0000000000000006 R15: 00005612cd03faf0
> [  110.837208]  </TASK>
> [  110.837209] Modules linked in: x86_pkg_temp_thermal
> [  111.090304] ---[ end trace 0000000000000000 ]---
> [  111.090304] RIP: 0010:xaddw_ax_dx+0x9/0x10
> [  111.090306] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [  111.090306] RSP: 0018:ffffa3ca02fafce0 EFLAGS: 00000206
> [  111.090307] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [  111.090308] RDX: 0000000076543210 RSI: ffffffffaa858f90 RDI: 0000000000000204
> [  111.090309] RBP: ffffa3ca02fafce8 R08: ffff9785cd9e7380 R09: 0000000000000002
> [  111.090309] R10: ffff9785cd9e7380 R11: ffff978583b6c0c8 R12: ffff9785cd9e7380
> [  111.090310] R13: ffffffffabe09d20 R14: 0000000000000000 R15: 0000000000000000
> [  111.090310] FS:  00007f9c6ee4f700(0000) GS:ffff9788dfd80000(0000)
> knlGS:0000000000000000
> [  111.090311] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  111.090312] CR2: 0000000000000000 CR3: 0000000103b86001 CR4: 00000000003726e0
> [  111.090313] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  111.090328] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  111.090329] Kernel panic - not syncing: Fatal exception in interrupt
> [  111.090367] Kernel Offset: 0x29800000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [  111.210947] ---[ end Kernel panic - not syncing: Fatal exception in
> interrupt ]---
> [  111.218507] ------------[ cut here ]------------
> [  111.218508] sched: Unexpected reschedule of offline CPU#0!
> [  111.218510] WARNING: CPU: 3 PID: 3804 at
> arch/x86/kernel/apic/ipi.c:68 native_smp_send_reschedule+0x3e/0x50
> [  111.218512] Modules linked in: x86_pkg_temp_thermal
> [  111.218513] CPU: 3 PID: 3804 Comm: qemu-system-x86 Tainted: G
> D           5.19.0-rc6 #1
> [  111.218515] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  111.218515] RIP: 0010:native_smp_send_reschedule+0x3e/0x50
> [  111.218516] Code: 1b 48 8b 05 24 b9 aa 01 be fd 00 00 00 48 8b 40
> 30 e8 96 06 31 01 5d c3 cc cc cc cc 89 fe 48 c7 c7 c8 d9 25 ac e8 76
> 56 f6 00 <0f> 0b 5d c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
> 44 00
> [  111.218517] RSP: 0018:ffffa3ca00168c40 EFLAGS: 00010086
> [  111.218518] RAX: 0000000000000000 RBX: ffffffffac6189c0 RCX: 0000000000000001
> [  111.218519] RDX: 0000000000000027 RSI: ffffffffac272909 RDI: 0000000000000001
> [  111.218520] RBP: ffffa3ca00168c40 R08: ffffffffacb91045 R09: 0000000000000000
> [  111.218520] R10: 0000000000000030 R11: ffffffffacb91045 R12: 0000000000000000
> [  111.218521] R13: ffffa3ca00168cf8 R14: ffffa3ca00168cf8 R15: 0000000000000009
> [  111.218521] FS:  00007f9c6ee4f700(0000) GS:ffff9788dfd80000(0000)
> knlGS:0000000000000000
> [  111.218522] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  111.218523] CR2: 0000000000000000 CR3: 0000000103b86001 CR4: 00000000003726e0
> [  111.218523] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  111.218524] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  111.218525] Call Trace:
> [  111.218525]  <IRQ>
> [  111.218526]  resched_curr+0x5c/0xd0
> [  111.218528]  check_preempt_curr+0x3b/0x70
> [  111.218530]  ttwu_do_wakeup+0x1c/0x180
> [  111.218531]  ttwu_do_activate+0x94/0x180
> [  111.218533]  try_to_wake_up+0x276/0x5b0
> [  111.218535]  default_wake_function+0x1a/0x40
> [  111.218536]  autoremove_wake_function+0x12/0x40
> [  111.218538]  __wake_up_common+0x7d/0x140
> [  111.218540]  __wake_up_common_lock+0x7c/0xc0
> [  111.218543]  __wake_up+0x13/0x20
> [  111.218545]  wake_up_klogd_work_func+0x7b/0x90
> [  111.218547]  irq_work_single+0x46/0xa0
> [  111.218548]  irq_work_run_list+0x2a/0x40
> [  111.218550]  irq_work_tick+0x4d/0x70
> [  111.218551]  update_process_times+0x90/0xb0
> [  111.218553]  tick_sched_handle+0x38/0x50
> [  111.218555]  tick_sched_timer+0x7b/0xa0
> [  111.218556]  ? tick_sched_do_timer+0xa0/0xa0
> [  111.218557]  __hrtimer_run_queues+0xa7/0x300
> [  111.218560]  hrtimer_interrupt+0x110/0x230
> [  111.218562]  __sysvec_apic_timer_interrupt+0x84/0x170
> [  111.218564]  sysvec_apic_timer_interrupt+0xab/0xd0
> [  111.218566]  </IRQ>
> [  111.218566]  <TASK>
> [  111.218567]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
> [  111.218568] RIP: 0010:panic+0x253/0x292
> [  111.218570] Code: e8 88 3b 1a ff 48 c7 c6 a0 ba b7 ac 48 c7 c7 80
> 32 26 ac e8 23 5c 00 00 c7 05 e3 97 0a 01 01 00 00 00 e8 46 e6 28 ff
> fb 31 db <4c> 39 eb 7c 1d 41 83 f4 01 48 8b 05 13 2d 32 01 44 89 e7 e8
> ab ac
> [  111.218571] RSP: 0018:ffffa3ca02fafb10 EFLAGS: 00000246
> [  111.218572] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
> [  111.218572] RDX: 0000000000110001 RSI: ffffffffab853daf RDI: ffffffffab858cfa
> [  111.218573] RBP: ffffa3ca02fafb80 R08: ffffffffacb90fda R09: 00000000acb90fb6
> [  111.218574] R10: ffffffffffffffff R11: ffffffffffffffff R12: 0000000000000000
> [  111.218574] R13: 0000000000000000 R14: ffffffffac2520a6 R15: 0000000000000000
> [  111.218575]  ? oops_end.cold+0xc/0x18
> [  111.218577]  ? panic+0x250/0x292
> [  111.218579]  oops_end.cold+0xc/0x18
> [  111.218580]  die+0x43/0x60
> [  111.218582]  exc_int3+0x137/0x160
> [  111.218583]  asm_exc_int3+0x3a/0x40
> [  111.218584] RIP: 0010:xaddw_ax_dx+0x9/0x10
> [  111.218585] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [  111.218586] RSP: 0018:ffffa3ca02fafce0 EFLAGS: 00000206
> [  111.218587] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [  111.218587] RDX: 0000000076543210 RSI: ffffffffaa858f90 RDI: 0000000000000204
> [  111.218588] RBP: ffffa3ca02fafce8 R08: ffff9785cd9e7380 R09: 0000000000000002
> [  111.218588] R10: ffff9785cd9e7380 R11: ffff978583b6c0c8 R12: ffff9785cd9e7380
> [  111.218589] R13: ffffffffabe09d20 R14: 0000000000000000 R15: 0000000000000000
> [  111.218590]  ? xaddw_ax_dx+0x8/0x10
> [  111.218591]  ? xaddw_ax_dx+0x9/0x10
> [  111.218592]  ? fastop+0x5d/0xa0
> [  111.218594]  x86_emulate_insn+0x7c9/0xf20
> [  111.218596]  x86_emulate_instruction+0x46d/0x7e0
> [  111.218597]  ? trace_hardirqs_on+0x37/0x100
> [  111.218599]  complete_emulated_mmio+0x211/0x2c0
> [  111.218601]  kvm_arch_vcpu_ioctl_run+0x12a3/0x2310
> [  111.218602]  ? vfs_writev+0xcb/0x1a0
> [  111.218605]  kvm_vcpu_ioctl+0x27e/0x6d0
> [  111.218607]  ? clockevents_program_event+0x98/0x100
> [  111.218609]  ? selinux_file_ioctl+0xae/0x140
> [  111.218612]  ? selinux_file_ioctl+0xae/0x140
> [  111.218614]  __x64_sys_ioctl+0x95/0xd0
> [  111.218616]  do_syscall_64+0x3b/0x90
> [  111.218618]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  111.218619] RIP: 0033:0x7f9c707d98f7
> [  111.218620] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
> 01 48
> [  111.218621] RSP: 002b:00007f9c6ee4ea28 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  111.218622] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f9c707d98f7
> [  111.218623] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000f
> [  111.218623] RBP: 00005612cd03faf0 R08: 00005612cba7c450 R09: 00000000ffffffff
> [  111.218624] R10: 00007ffdfdda3080 R11: 0000000000000246 R12: 0000000000000000
> [  111.218624] R13: 00007f9c72b09000 R14: 0000000000000006 R15: 00005612cd03faf0
> [  111.218626]  </TASK>
> [  111.218626] ---[ end trace 0000000000000000 ]---
> [  111.218629] ------------[ cut here ]------------
> [  111.218629] WARNING: CPU: 3 PID: 3804 at kernel/sched/core.c:3125
> set_task_cpu+0x195/0x1b0
> [  111.218631] Modules linked in: x86_pkg_temp_thermal
> [  111.218632] CPU: 3 PID: 3804 Comm: qemu-system-x86 Tainted: G
> D W         5.19.0-rc6 #1
> [  111.218634] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  111.218634] RIP: 0010:set_task_cpu+0x195/0x1b0
> [  111.218636] Code: 65 ff 0d 2e 0a 61 55 0f 85 db fe ff ff 0f 1f 44
> 00 00 e9 d1 fe ff ff 80 8b 1c 05 00 00 04 e9 0f ff ff ff 0f 0b e9 9a
> fe ff ff <0f> 0b 66 83 bb f8 03 00 00 00 0f 84 a9 fe ff ff 0f 0b e9 a2
> fe ff
> [  111.218636] RSP: 0018:ffffa3ca00168b98 EFLAGS: 00010006
> [  111.218637] RAX: 0000000000000200 RBX: ffff9785826ad3c0 RCX: ffff978580836e00
> [  111.218638] RDX: fffffffffffffff2 RSI: 0000000000000001 RDI: ffff9785826ad3c0
> [  111.218638] RBP: ffffa3ca00168bb8 R08: 0000000000000001 R09: 0000000000000004
> [  111.218639] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
> [  111.218639] R13: 0000000000000001 R14: 0000000000000087 R15: ffff9785826adc04
> [  111.218640] FS:  00007f9c6ee4f700(0000) GS:ffff9788dfd80000(0000)
> knlGS:0000000000000000
> [  111.218641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  111.218642] CR2: 0000000000000000 CR3: 0000000103b86001 CR4: 00000000003726e0
> [  111.218642] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  111.218643] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  111.218643] Call Trace:
> [  111.218644]  <IRQ>
> [  111.218644]  try_to_wake_up+0x1d0/0x5b0
> [  111.218646]  default_wake_function+0x1a/0x40
> [  111.218648]  autoremove_wake_function+0x12/0x40
> [  111.218649]  __wake_up_common+0x7d/0x140
> [  111.218651]  __wake_up_common_lock+0x7c/0xc0
> [  111.218653]  __wake_up+0x13/0x20
> [  111.218655]  ep_poll_callback+0x117/0x290
> [  111.218657]  __wake_up_common+0x7d/0x140
> [  111.218659]  __wake_up_common_lock+0x7c/0xc0
> [  111.218662]  __wake_up+0x13/0x20
> [  111.218663]  wake_up_klogd_work_func+0x7b/0x90
> [  111.218665]  irq_work_single+0x46/0xa0
> [  111.218666]  irq_work_run_list+0x2a/0x40
> [  111.218667]  irq_work_tick+0x4d/0x70
> [  111.218669]  update_process_times+0x90/0xb0
> [  111.218670]  tick_sched_handle+0x38/0x50
> [  111.218672]  tick_sched_timer+0x7b/0xa0
> [  111.218673]  ? tick_sched_do_timer+0xa0/0xa0
> [  111.218674]  __hrtimer_run_queues+0xa7/0x300
> [  111.218677]  hrtimer_interrupt+0x110/0x230
> [  111.218679]  __sysvec_apic_timer_interrupt+0x84/0x170
> [  111.218681]  sysvec_apic_timer_interrupt+0xab/0xd0
> [  111.218683]  </IRQ>
> [  111.218683]  <TASK>
> [  111.218683]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
> [  111.218685] RIP: 0010:panic+0x253/0x292
> [  111.218686] Code: e8 88 3b 1a ff 48 c7 c6 a0 ba b7 ac 48 c7 c7 80
> 32 26 ac e8 23 5c 00 00 c7 05 e3 97 0a 01 01 00 00 00 e8 46 e6 28 ff
> fb 31 db <4c> 39 eb 7c 1d 41 83 f4 01 48 8b 05 13 2d 32 01 44 89 e7 e8
> ab ac
> [  111.218686] RSP: 0018:ffffa3ca02fafb10 EFLAGS: 00000246
> [  111.218687] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
> [  111.218688] RDX: 0000000000110001 RSI: ffffffffab853daf RDI: ffffffffab858cfa
> [  111.218688] RBP: ffffa3ca02fafb80 R08: ffffffffacb90fda R09: 00000000acb90fb6
> [  111.218689] R10: ffffffffffffffff R11: ffffffffffffffff R12: 0000000000000000
> [  111.218689] R13: 0000000000000000 R14: ffffffffac2520a6 R15: 0000000000000000
> [  111.218690]  ? oops_end.cold+0xc/0x18
> [  111.218692]  ? panic+0x250/0x292
> [  111.218693]  oops_end.cold+0xc/0x18
> [  111.218694]  die+0x43/0x60
> [  111.218696]  exc_int3+0x137/0x160
> [  111.218697]  asm_exc_int3+0x3a/0x40
> [  111.218698] RIP: 0010:xaddw_ax_dx+0x9/0x10
> [  111.218699] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [  111.218700] RSP: 0018:ffffa3ca02fafce0 EFLAGS: 00000206
> [  111.218700] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [  111.218701] RDX: 0000000076543210 RSI: ffffffffaa858f90 RDI: 0000000000000204
> [  111.218702] RBP: ffffa3ca02fafce8 R08: ffff9785cd9e7380 R09: 0000000000000002
> [  111.218702] R10: ffff9785cd9e7380 R11: ffff978583b6c0c8 R12: ffff9785cd9e7380
> [  111.218703] R13: ffffffffabe09d20 R14: 0000000000000000 R15: 0000000000000000
> [  111.218704]  ? xaddw_ax_dx+0x8/0x10
> [  111.218705]  ? xaddw_ax_dx+0x9/0x10
> [  111.218706]  ? fastop+0x5d/0xa0
> [  111.218707]  x86_emulate_insn+0x7c9/0xf20
> [  111.218709]  x86_emulate_instruction+0x46d/0x7e0
> [  111.218710]  ? trace_hardirqs_on+0x37/0x100
> [  111.218713]  complete_emulated_mmio+0x211/0x2c0
> [  111.218714]  kvm_arch_vcpu_ioctl_run+0x12a3/0x2310
> [  111.218716]  ? vfs_writev+0xcb/0x1a0
> [  111.218718]  kvm_vcpu_ioctl+0x27e/0x6d0
> [  111.218720]  ? clockevents_program_event+0x98/0x100
> [  111.218723]  ? selinux_file_ioctl+0xae/0x140
> [  111.218725]  ? selinux_file_ioctl+0xae/0x140
> [  111.218727]  __x64_sys_ioctl+0x95/0xd0
> [  111.218729]  do_syscall_64+0x3b/0x90
> [  111.218731]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  111.218732] RIP: 0033:0x7f9c707d98f7
> [  111.218733] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
> 01 48
> [  111.218734] RSP: 002b:00007f9c6ee4ea28 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  111.218735] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f9c707d98f7
> [  111.218735] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000f
> [  111.218736] RBP: 00005612cd03faf0 R08: 00005612cba7c450 R09: 00000000ffffffff
> [  111.218736] R10: 00007ffdfdda3080 R11: 0000000000000246 R12: 0000000000000000
> [  111.218737] R13: 00007f9c72b09000 R14: 0000000000000006 R15: 00005612cd03faf0
> [  111.218738]  </TASK>
> [  111.218739] ---[ end trace 0000000000000000 ]---
> [  111.218740] ------------[ cut here ]------------
> [  111.218741] sched: Unexpected reschedule of offline CPU#1!
> [  111.218742] WARNING: CPU: 3 PID: 3804 at
> arch/x86/kernel/apic/ipi.c:68 native_smp_send_reschedule+0x3e/0x50
> [  111.218743] Modules linked in: x86_pkg_temp_thermal
> [  111.218744] CPU: 3 PID: 3804 Comm: qemu-system-x86 Tainted: G
> D W         5.19.0-rc6 #1
> [  111.218745] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  111.218745] RIP: 0010:native_smp_send_reschedule+0x3e/0x50
> [  111.218747] Code: 1b 48 8b 05 24 b9 aa 01 be fd 00 00 00 48 8b 40
> 30 e8 96 06 31 01 5d c3 cc cc cc cc 89 fe 48 c7 c7 c8 d9 25 ac e8 76
> 56 f6 00 <0f> 0b 5d c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
> 44 00
> [  111.218747] RSP: 0018:ffffa3ca00168b20 EFLAGS: 00010082
> [  111.218748] RAX: 0000000000000000 RBX: ffff978580362180 RCX: 0000000000000001
> [  111.218749] RDX: 0000000000000027 RSI: ffffffffac272909 RDI: 0000000000000001
> [  111.218749] RBP: ffffa3ca00168b20 R08: ffffffffacb93d75 R09: 0000000000000000
> [  111.218750] R10: 0000000000000030 R11: ffffffffacb93d75 R12: 0000000000000001
> [  111.218750] R13: ffffa3ca00168bd8 R14: ffffa3ca00168bd8 R15: 0000000000000049
> [  111.218751] FS:  00007f9c6ee4f700(0000) GS:ffff9788dfd80000(0000)
> knlGS:0000000000000000
> [  111.218752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  111.218753] CR2: 0000000000000000 CR3: 0000000103b86001 CR4: 00000000003726e0
> [  111.218753] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  111.218754] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  111.218754] Call Trace:
> [  111.218755]  <IRQ>
> [  111.218755]  resched_curr+0x5c/0xd0
> [  111.218756]  check_preempt_curr+0x3b/0x70
> [  111.218758]  ttwu_do_wakeup+0x1c/0x180
> [  111.218760]  ttwu_do_activate+0x94/0x180
> [  111.218761]  try_to_wake_up+0x276/0x5b0
> [  111.218763]  default_wake_function+0x1a/0x40
> [  111.218765]  autoremove_wake_function+0x12/0x40
> [  111.218766]  __wake_up_common+0x7d/0x140
> [  111.218768]  __wake_up_common_lock+0x7c/0xc0
> [  111.218770]  __wake_up+0x13/0x20
> [  111.218772]  ep_poll_callback+0x117/0x290
> [  111.218773]  __wake_up_common+0x7d/0x140
> [  111.218775]  __wake_up_common_lock+0x7c/0xc0
> [  111.218778]  __wake_up+0x13/0x20
> [  111.218779]  wake_up_klogd_work_func+0x7b/0x90
> [  111.218781]  irq_work_single+0x46/0xa0
> [  111.218782]  irq_work_run_list+0x2a/0x40
> [  111.218783]  irq_work_tick+0x4d/0x70
> [  111.218784]  update_process_times+0x90/0xb0
> [  111.218786]  tick_sched_handle+0x38/0x50
> [  111.218788]  tick_sched_timer+0x7b/0xa0
> [  111.218789]  ? tick_sched_do_timer+0xa0/0xa0
> [  111.218790]  __hrtimer_run_queues+0xa7/0x300
> [  111.218793]  hrtimer_interrupt+0x110/0x230
> [  111.218795]  __sysvec_apic_timer_interrupt+0x84/0x170
> [  111.218797]  sysvec_apic_timer_interrupt+0xab/0xd0
> [  111.218798]  </IRQ>
> [  111.218799]  <TASK>
> [  111.218799]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
> [  111.218801] RIP: 0010:panic+0x253/0x292
> [  111.218801] Code: e8 88 3b 1a ff 48 c7 c6 a0 ba b7 ac 48 c7 c7 80
> 32 26 ac e8 23 5c 00 00 c7 05 e3 97 0a 01 01 00 00 00 e8 46 e6 28 ff
> fb 31 db <4c> 39 eb 7c 1d 41 83 f4 01 48 8b 05 13 2d 32 01 44 89 e7 e8
> ab ac
> [  111.218802] RSP: 0018:ffffa3ca02fafb10 EFLAGS: 00000246
> [  111.218803] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
> [  111.218803] RDX: 0000000000110001 RSI: ffffffffab853daf RDI: ffffffffab858cfa
> [  111.218804] RBP: ffffa3ca02fafb80 R08: ffffffffacb90fda R09: 00000000acb90fb6
> [  111.218805] R10: ffffffffffffffff R11: ffffffffffffffff R12: 0000000000000000
> [  111.218805] R13: 0000000000000000 R14: ffffffffac2520a6 R15: 0000000000000000
> [  111.218806]  ? oops_end.cold+0xc/0x18
> [  111.218807]  ? panic+0x250/0x292
> [  111.218809]  oops_end.cold+0xc/0x18
> [  111.218810]  die+0x43/0x60
> [  111.218812]  exc_int3+0x137/0x160
> [  111.218813]  asm_exc_int3+0x3a/0x40
> [  111.218814] RIP: 0010:xaddw_ax_dx+0x9/0x10
> [  111.218815] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [  111.218815] RSP: 0018:ffffa3ca02fafce0 EFLAGS: 00000206
> [  111.218816] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [  111.218817] RDX: 0000000076543210 RSI: ffffffffaa858f90 RDI: 0000000000000204
> [  111.218817] RBP: ffffa3ca02fafce8 R08: ffff9785cd9e7380 R09: 0000000000000002
> [  111.218818] R10: ffff9785cd9e7380 R11: ffff978583b6c0c8 R12: ffff9785cd9e7380
> [  111.218818] R13: ffffffffabe09d20 R14: 0000000000000000 R15: 0000000000000000
> [  111.218819]  ? xaddw_ax_dx+0x8/0x10
> [  111.218821]  ? xaddw_ax_dx+0x9/0x10
> [  111.218822]  ? fastop+0x5d/0xa0
> [  111.218823]  x86_emulate_insn+0x7c9/0xf20
> [  111.218825]  x86_emulate_instruction+0x46d/0x7e0
> [  111.218826]  ? trace_hardirqs_on+0x37/0x100
> [  111.218828]  complete_emulated_mmio+0x211/0x2c0
> [  111.218829]  kvm_arch_vcpu_ioctl_run+0x12a3/0x2310
> [  111.218831]  ? vfs_writev+0xcb/0x1a0
> [  111.218833]  kvm_vcpu_ioctl+0x27e/0x6d0
> [  111.218835]  ? clockevents_program_event+0x98/0x100
> [  111.218838]  ? selinux_file_ioctl+0xae/0x140
> [  111.218840]  ? selinux_file_ioctl+0xae/0x140
> [  111.218842]  __x64_sys_ioctl+0x95/0xd0
> [  111.218844]  do_syscall_64+0x3b/0x90
> [  111.218846]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  111.218847] RIP: 0033:0x7f9c707d98f7
> [  111.218848] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
> 01 48
> [  111.218849] RSP: 002b:00007f9c6ee4ea28 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  111.218849] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f9c707d98f7
> [  111.218850] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000f
> [  111.218851] RBP: 00005612cd03faf0 R08: 00005612cba7c450 R09: 00000000ffffffff
> [  111.218851] R10: 00007ffdfdda3080 R11: 0000000000000246 R12: 0000000000000000
> [  111.218852] R13: 00007f9c72b09000 R14: 0000000000000006 R15: 00005612cd03faf0
> [  111.218853]  </TASK>
> [  111.218854] ---[ end trace 0000000000000000 ]---
> 
> https://lkft.validation.linaro.org/scheduler/job/5279904#L1721
> 
> - Naresh
