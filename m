Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5825734DE
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 13:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiGMLEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 07:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236204AbiGMLEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 07:04:01 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265F4BC9C
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 04:03:38 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r76so10469360iod.10
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 04:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b/0JkedFBgyQP8F08b57NaepGg8wf8N5QNQ/WUVtBXg=;
        b=p9mibesliJPz/ipByw4l96b8Elh74hIKidEwRz8xX7+2Bko9Uc0szVWWsURikw2Rve
         0yWTtoRNrCgMGgVnuHG9iCTrgBrfTMiK10Yr7OICMsLiEBAlVqmgWI3fhcx4GbSGqqHt
         yoajdq3o0gKMJxEq2BYIJb46bvWjv3jvLn3yt8hIz49z5r/VN4VQ5HmyRFipHIWVj/zb
         jnQiq4bUQANz6f8n5F/o9zyCCRJikENRSuCjOSLDBVv5CFTjX3MUZbimWwqhFEHFi5OI
         BwvEXgDMCRFJ/iKMQSa7DFewtBhn8Ymff4eE5oFfPmZ+zmTfN3pRvUDYzwHpduoPfHCa
         zU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b/0JkedFBgyQP8F08b57NaepGg8wf8N5QNQ/WUVtBXg=;
        b=SIkzbD9usGr5CKCuV6OXzznyYqGSMaXWe6v/G+0RlMSaAx12uKq4dWeOaafqcF1QNl
         7ZIsSn7Hz/fWRiWQqm5JR7eReH0QMjxFWFPu2/JWiCTwgk6+NysW10hTxMbN69TDyU1t
         0x7Rji84FciGmYvjByubkbx0YUM7Y8t8s77XL5VRTNDCUfyFwcxgyl443f9y5Otgc2pt
         ZM0FPr636tAB+oGdVe4l87aD/gsD8f5FWQW1dSocKAqNr0t87DbYaRZ2HSfdMNMVRTnY
         INJ8JtlmBiP/0EFHD+VBAWkNBoU9a6p4Hs7Eoi3xVb0MRsMUOPf+09o8RkojgLT7c809
         jS5A==
X-Gm-Message-State: AJIora/76spYJ2DFpHEHc8TB85yYrBbu7Tua8r1kR+BZAA0YAaO34QMf
        gz7A/y8W8GfKc+v/LBvUFUGteN5rdGqHQAFz7FbtiA==
X-Google-Smtp-Source: AGRyM1sVm3MvZ2VGp7Y56KHkZ2KMapH7rxph3dCiJ0Kyc2BiOWjaiOFWr7um3gkOEfTtFzLSwQ5H8WZRQFSnXUShgBw=
X-Received: by 2002:a05:6602:1409:b0:5e7:487:133c with SMTP id
 t9-20020a056602140900b005e70487133cmr1596354iov.196.1657710217039; Wed, 13
 Jul 2022 04:03:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183236.931648980@linuxfoundation.org>
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 Jul 2022 16:33:24 +0530
Message-ID: <CA+G9fYvRQ9gzee8pjRmsyedz6oGyh5pzSYEPkuDoKEE+X2RZDg@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm list <kvm@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 Jul 2022 at 00:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.12 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions on x86_64 (and still validating results)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

1) kernel panic on x86_64 while running kvm-unit-tests.
   - APIC base relocation is unsupported by KVM
2) qemu_x86_64 boot warning
   - WARNING: CPU: 0 PID: 0 at arch/x86/kernel/alternative.c:558
apply_returns+0x19c/0x1d0

3) New warnings noticed while building perf
   - Warning: Kernel ABI header at
'tools/arch/x86/include/asm/disabled-features.h' differs from latest
version at 'arch/x86/include/asm/disabled-features.h'

1. kernel panic on x86_64
  - https://lkft.validation.linaro.org/scheduler/job/5278093#L1719
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v=
5.18.11-62-g18f94637a014/testrun/10800594/suite/log-parser-test/tests/

TESTNAME=3Demulator TIMEOUT=3D90s ACCEL=3D ./x86/run x86/emulator.flat -smp=
 1
[   65.187749] APIC base relocation is unsupported by KVM
[  110.900413] kvm: emulating exchange as write
[  110.911805] int3: 0000 [#1] PREEMPT SMP PTI
[  110.911807] CPU: 3 PID: 3790 Comm: qemu-system-x86 Not tainted 5.18.12-r=
c1 #1
[  110.911809] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  110.911810] RIP: 0010:xaddw_ax_dx+0x9/0x10
[  110.911814] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
cc cc
[  110.911815] RSP: 0018:ffffb0dcc2f1fce0 EFLAGS: 00000206
[  110.911817] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 00000000000=
00000
[  110.911818] RDX: 0000000076543210 RSI: ffffffff834583f0 RDI: 00000000000=
00204
[  110.911819] RBP: ffffb0dcc2f1fce8 R08: ffff96ae06f86900 R09: 00000000000=
00002
[  110.911820] R10: ffff96ae06f86900 R11: ffff96ae029680c8 R12: ffff96ae06f=
86900
[  110.911821] R13: ffffffff84a096c0 R14: 0000000000000000 R15: 00000000000=
00000
[  110.911822] FS:  00007ff85a8de700(0000) GS:ffff96af6fb80000(0000)
knlGS:0000000000000000
[  110.911823] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  110.911824] CR2: 0000000000000000 CR3: 000000014df32004 CR4: 00000000003=
726e0
[  110.911825] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  110.911826] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  110.911827] Call Trace:
[  110.911828]  <TASK>
[  110.911829]  ? fastop+0x5a/0xa0
[  110.911831]  x86_emulate_insn+0x7c9/0xf20
[  110.911834]  x86_emulate_instruction+0x46d/0x7e0
[  110.911837]  ? trace_hardirqs_on+0x37/0x100
[  110.911841]  complete_emulated_mmio+0x211/0x2c0
[  110.911843]  kvm_arch_vcpu_ioctl_run+0x12e4/0x23a0
[  110.911845]  ? vfs_writev+0xcb/0x1a0
[  110.911848]  kvm_vcpu_ioctl+0x27e/0x6d0
[  110.911850]  ? clockevents_program_event+0x95/0x100
[  110.911853]  ? selinux_file_ioctl+0xae/0x140
[  110.911856]  ? selinux_file_ioctl+0xae/0x140
[  110.911858]  __x64_sys_ioctl+0x92/0xd0
[  110.911861]  do_syscall_64+0x38/0x90
[  110.911863]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[  110.911865] RIP: 0033:0x7ff85c2688f7
[  110.911867] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
01 48
[  110.911868] RSP: 002b:00007ff85a8dda28 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  110.911870] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007ff85c2=
688f7
[  110.911871] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 00000000000=
0000f
[  110.911872] RBP: 000055c53d26daf0 R08: 000055c53c07c450 R09: 00000000fff=
fffff
[  110.911872] R10: 00007ffe8c3a3080 R11: 0000000000000246 R12: 00000000000=
00000
[  110.911873] R13: 00007ff85e598000 R14: 0000000000000006 R15: 000055c53d2=
6daf0
[  110.911876]  </TASK>
[  110.911876] Modules linked in: x86_pkg_temp_thermal
[  111.164962] ---[ end trace 0000000000000000 ]---
[  111.164962] RIP: 0010:xaddw_ax_dx+0x9/0x10
[  111.164964] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
cc cc
[  111.164965] RSP: 0018:ffffb0dcc2f1fce0 EFLAGS: 00000206
[  111.164966] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 00000000000=
00000
[  111.164967] RDX: 0000000076543210 RSI: ffffffff834583f0 RDI: 00000000000=
00204
[  111.164982] RBP: ffffb0dcc2f1fce8 R08: ffff96ae06f86900 R09: 00000000000=
00002
[  111.164983] R10: ffff96ae06f86900 R11: ffff96ae029680c8 R12: ffff96ae06f=
86900
[  111.164983] R13: ffffffff84a096c0 R14: 0000000000000000 R15: 00000000000=
00000
[  111.164984] FS:  00007ff85a8de700(0000) GS:ffff96af6fb80000(0000)
knlGS:0000000000000000
[  111.164985] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  111.164986] CR2: 0000000000000000 CR3: 000000014df32004 CR4: 00000000003=
726e0
[  111.164987] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  111.164988] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  111.164989] Kernel panic - not syncing: Fatal exception in interrupt
[  111.165028] Kernel Offset: 0x2400000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  111.285522] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---
[  111.293090] ------------[ cut here ]------------
[  111.293091] sched: Unexpected reschedule of offline CPU#1!
[  111.293093] WARNING: CPU: 3 PID: 3790 at
arch/x86/kernel/apic/ipi.c:68 native_smp_send_reschedule+0x3e/0x50
[  111.293098] Modules linked in: x86_pkg_temp_thermal
[  111.293099] CPU: 3 PID: 3790 Comm: qemu-system-x86 Tainted: G
D           5.18.12-rc1 #1
[  111.293100] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  111.293101] RIP: 0010:native_smp_send_reschedule+0x3e/0x50
[  111.293103] Code: 1b 48 8b 05 d4 47 a9 01 be fd 00 00 00 48 8b 40
30 ff d0 0f 1f 00 5d c3 cc cc cc cc 89 fe 48 c7 c7 50 8d e4 84 e8 33
05 f5 00 <0f> 0b 5d c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00
[  111.293105] RSP: 0018:ffffb0dcc0168c40 EFLAGS: 00010086
[  111.293106] RAX: 0000000000000000 RBX: ffff96ae00292180 RCX: 00000000000=
00001
[  111.293106] RDX: 0000000000000027 RSI: ffffffff84e5d511 RDI: 00000000000=
00001
[  111.293107] RBP: ffffb0dcc0168c40 R08: ffffffff85790eed R09: 00000000000=
00000
[  111.293108] R10: 0000000000000030 R11: ffffffff85790eed R12: 00000000000=
00001
[  111.293109] R13: ffffb0dcc0168cf8 R14: ffffb0dcc0168cf8 R15: 00000000000=
00009
[  111.293109] FS:  00007ff85a8de700(0000) GS:ffff96af6fb80000(0000)
knlGS:0000000000000000
[  111.293111] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  111.293111] CR2: 0000000000000000 CR3: 000000014df32004 CR4: 00000000003=
726e0
[  111.293112] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  111.293113] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  111.293114] Call Trace:
[  111.293114]  <IRQ>
[  111.293115]  resched_curr+0x59/0xd0
[  111.293117]  check_preempt_curr+0x3b/0x70
[  111.293119]  ttwu_do_wakeup+0x1c/0x180
[  111.293121]  ttwu_do_activate+0x94/0x180
[  111.293122]  try_to_wake_up+0x276/0x5b0
[  111.293125]  default_wake_function+0x1a/0x40
[  111.293126]  autoremove_wake_function+0x12/0x40
[  111.293129]  __wake_up_common+0x7a/0x140
[  111.293132]  __wake_up_common_lock+0x7c/0xc0
[  111.293135]  __wake_up+0x13/0x20
[  111.293137]  wake_up_klogd_work_func+0x7b/0x90
[  111.293139]  irq_work_single+0x43/0xa0
[  111.293142]  irq_work_run_list+0x2a/0x40
[  111.293144]  irq_work_tick+0x4d/0x70
[  111.293147]  update_process_times+0xc1/0xe0
[  111.293148]  tick_sched_handle+0x38/0x50
[  111.293150]  tick_sched_timer+0x7b/0xa0
[  111.293152]  ? tick_sched_do_timer+0xa0/0xa0
[  111.293154]  __hrtimer_run_queues+0xa4/0x300
[  111.293157]  hrtimer_interrupt+0x110/0x230
[  111.293159]  __sysvec_apic_timer_interrupt+0x81/0x170
[  111.293161]  sysvec_apic_timer_interrupt+0xab/0xd0
[  111.293163]  </IRQ>
[  111.293164]  <TASK>
[  111.293164]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[  111.293166] RIP: 0010:panic+0x253/0x292
[  111.293169] Code: e8 8b 8a 1b ff 48 c7 c6 a0 ba 77 85 48 c7 c7 70
e6 e4 84 e8 2d 5b 00 00 c7 05 2e 2c 0c 01 01 00 00 00 e8 99 13 2a ff
fb 31 db <4c> 39 eb 7c 1d 41 83 f4 01 48 8b 05 26 8d 33 01 44 89 e7 ff
d0 0f
[  111.293170] RSP: 0018:ffffb0dcc2f1fb10 EFLAGS: 00000246
[  111.293171] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000000=
00001
[  111.293171] RDX: 0000000000110001 RSI: ffffffff8443dd67 RDI: ffffffff844=
42ce7
[  111.293172] RBP: ffffb0dcc2f1fb80 R08: ffffffff85790e82 R09: 00000000857=
90e5e
[  111.293173] R10: ffffffffffffffff R11: ffffffffffffffff R12: 00000000000=
00000
[  111.293174] R13: 0000000000000000 R14: ffffffff84e3d300 R15: 00000000000=
00000
[  111.293176]  ? oops_end.cold+0xc/0x18
[  111.293178]  ? panic+0x250/0x292
[  111.293181]  oops_end.cold+0xc/0x18
[  111.293183]  die+0x43/0x60
[  111.293186]  exc_int3+0x137/0x160
[  111.293187]  asm_exc_int3+0x39/0x40
[  111.293189] RIP: 0010:xaddw_ax_dx+0x9/0x10
[  111.293190] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
cc cc
[  111.293191] RSP: 0018:ffffb0dcc2f1fce0 EFLAGS: 00000206
[  111.293192] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 00000000000=
00000
[  111.293193] RDX: 0000000076543210 RSI: ffffffff834583f0 RDI: 00000000000=
00204
[  111.293194] RBP: ffffb0dcc2f1fce8 R08: ffff96ae06f86900 R09: 00000000000=
00002
[  111.293194] R10: ffff96ae06f86900 R11: ffff96ae029680c8 R12: ffff96ae06f=
86900
[  111.293195] R13: ffffffff84a096c0 R14: 0000000000000000 R15: 00000000000=
00000
[  111.293197]  ? xaddw_ax_dx+0x8/0x10
[  111.293199]  ? xaddw_ax_dx+0x9/0x10
[  111.293200]  ? fastop+0x5a/0xa0
[  111.293201]  x86_emulate_insn+0x7c9/0xf20
[  111.293204]  x86_emulate_instruction+0x46d/0x7e0
[  111.293206]  ? trace_hardirqs_on+0x37/0x100
[  111.293209]  complete_emulated_mmio+0x211/0x2c0
[  111.293211]  kvm_arch_vcpu_ioctl_run+0x12e4/0x23a0
[  111.293213]  ? vfs_writev+0xcb/0x1a0
[  111.293215]  kvm_vcpu_ioctl+0x27e/0x6d0
[  111.293217]  ? clockevents_program_event+0x95/0x100
[  111.293220]  ? selinux_file_ioctl+0xae/0x140
[  111.293221]  ? selinux_file_ioctl+0xae/0x140
[  111.293223]  __x64_sys_ioctl+0x92/0xd0
[  111.293225]  do_syscall_64+0x38/0x90
[  111.293227]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[  111.293229] RIP: 0033:0x7ff85c2688f7
[  111.293230] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
01 48
[  111.293230] RSP: 002b:00007ff85a8dda28 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  111.293232] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007ff85c2=
688f7
[  111.293233] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 00000000000=
0000f
[  111.293233] RBP: 000055c53d26daf0 R08: 000055c53c07c450 R09: 00000000fff=
fffff
[  111.293234] R10: 00007ffe8c3a3080 R11: 0000000000000246 R12: 00000000000=
00000
[  111.293235] R13: 00007ff85e598000 R14: 0000000000000006 R15: 000055c53d2=
6daf0
[  111.293238]  </TASK>
[  111.293238] ---[ end trace 0000000000000000 ]---
[  111.293240] ------------[ cut here ]------------
[  111.293240] sched: Unexpected reschedule of offline CPU#2!
[  111.293242] WARNING: CPU: 3 PID: 3790 at
arch/x86/kernel/apic/ipi.c:68 native_smp_send_reschedule+0x3e/0x50
[  111.293245] Modules linked in: x86_pkg_temp_thermal
[  111.293246] CPU: 3 PID: 3790 Comm: qemu-system-x86 Tainted: G
D W         5.18.12-rc1 #1
[  111.293247] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  111.293248] RIP: 0010:native_smp_send_reschedule+0x3e/0x50
[  111.293250] Code: 1b 48 8b 05 d4 47 a9 01 be fd 00 00 00 48 8b 40
30 ff d0 0f 1f 00 5d c3 cc cc cc cc 89 fe 48 c7 c7 50 8d e4 84 e8 33
05 f5 00 <0f> 0b 5d c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00
[  111.293251] RSP: 0018:ffffb0dcc0168b20 EFLAGS: 00010082
[  111.293252] RAX: 0000000000000000 RBX: ffff96ae00293240 RCX: 00000000000=
00001
[  111.293253] RDX: 0000000000000027 RSI: ffffffff84e5d511 RDI: 00000000000=
00001
[  111.293254] RBP: ffffb0dcc0168b20 R08: ffffffff857925ad R09: 00000000000=
00000
[  111.293254] R10: 0000000000000030 R11: ffffffff857925ad R12: 00000000000=
00002
[  111.293255] R13: ffffb0dcc0168bd8 R14: ffffb0dcc0168bd8 R15: 00000000000=
00009
[  111.293256] FS:  00007ff85a8de700(0000) GS:ffff96af6fb80000(0000)
knlGS:0000000000000000
[  111.293257] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  111.293258] CR2: 0000000000000000 CR3: 000000014df32004 CR4: 00000000003=
726e0
[  111.293259] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  111.293259] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  111.293260] Call Trace:
[  111.293260]  <IRQ>
[  111.293261]  resched_curr+0x59/0xd0
[  111.293263]  check_preempt_curr+0x3b/0x70
[  111.293264]  ttwu_do_wakeup+0x1c/0x180
[  111.293266]  ttwu_do_activate+0x94/0x180
[  111.293268]  try_to_wake_up+0x276/0x5b0
[  111.293270]  default_wake_function+0x1a/0x40
[  111.293272]  autoremove_wake_function+0x12/0x40
[  111.293274]  __wake_up_common+0x7a/0x140
[  111.293277]  __wake_up_common_lock+0x7c/0xc0
[  111.293280]  __wake_up+0x13/0x20
[  111.293282]  ep_poll_callback+0x117/0x290
[  111.293285]  __wake_up_common+0x7a/0x140
[  111.293288]  __wake_up_common_lock+0x7c/0xc0
[  111.293291]  __wake_up+0x13/0x20
[  111.293293]  wake_up_klogd_work_func+0x7b/0x90
[  111.293294]  irq_work_single+0x43/0xa0
[  111.293297]  irq_work_run_list+0x2a/0x40
[  111.293299]  irq_work_tick+0x4d/0x70
[  111.293301]  update_process_times+0xc1/0xe0
[  111.293303]  tick_sched_handle+0x38/0x50
[  111.293305]  tick_sched_timer+0x7b/0xa0
[  111.293306]  ? tick_sched_do_timer+0xa0/0xa0
[  111.293309]  __hrtimer_run_queues+0xa4/0x300
[  111.293311]  hrtimer_interrupt+0x110/0x230
[  111.293313]  __sysvec_apic_timer_interrupt+0x81/0x170
[  111.293316]  sysvec_apic_timer_interrupt+0xab/0xd0
[  111.293317]  </IRQ>
[  111.293318]  <TASK>
[  111.293319]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[  111.293320] RIP: 0010:panic+0x253/0x292
[  111.293322] Code: e8 8b 8a 1b ff 48 c7 c6 a0 ba 77 85 48 c7 c7 70
e6 e4 84 e8 2d 5b 00 00 c7 05 2e 2c 0c 01 01 00 00 00 e8 99 13 2a ff
fb 31 db <4c> 39 eb 7c 1d 41 83 f4 01 48 8b 05 26 8d 33 01 44 89 e7 ff
d0 0f
[  111.293323] RSP: 0018:ffffb0dcc2f1fb10 EFLAGS: 00000246
[  111.293324] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000000=
00001
[  111.293325] RDX: 0000000000110001 RSI: ffffffff8443dd67 RDI: ffffffff844=
42ce7
[  111.293325] RBP: ffffb0dcc2f1fb80 R08: ffffffff85790e82 R09: 00000000857=
90e5e
[  111.293326] R10: ffffffffffffffff R11: ffffffffffffffff R12: 00000000000=
00000
[  111.293327] R13: 0000000000000000 R14: ffffffff84e3d300 R15: 00000000000=
00000
[  111.293329]  ? oops_end.cold+0xc/0x18
[  111.293330]  ? panic+0x250/0x292
[  111.293334]  oops_end.cold+0xc/0x18
[  111.293336]  die+0x43/0x60
[  111.293338]  exc_int3+0x137/0x160
[  111.293339]  asm_exc_int3+0x39/0x40
[  111.293341] RIP: 0010:xaddw_ax_dx+0x9/0x10
[  111.293342] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
cc cc
[  111.293343] RSP: 0018:ffffb0dcc2f1fce0 EFLAGS: 00000206
[  111.293344] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 00000000000=
00000
[  111.293345] RDX: 0000000076543210 RSI: ffffffff834583f0 RDI: 00000000000=
00204
[  111.293345] RBP: ffffb0dcc2f1fce8 R08: ffff96ae06f86900 R09: 00000000000=
00002
[  111.293346] R10: ffff96ae06f86900 R11: ffff96ae029680c8 R12: ffff96ae06f=
86900
[  111.293347] R13: ffffffff84a096c0 R14: 0000000000000000 R15: 00000000000=
00000
[  111.293349]  ? xaddw_ax_dx+0x8/0x10
[  111.293350]  ? xaddw_ax_dx+0x9/0x10
[  111.293351]  ? fastop+0x5a/0xa0
[  111.293353]  x86_emulate_insn+0x7c9/0xf20
[  111.293355]  x86_emulate_instruction+0x46d/0x7e0
[  111.293358]  ? trace_hardirqs_on+0x37/0x100
[  111.293360]  complete_emulated_mmio+0x211/0x2c0
[  111.293362]  kvm_arch_vcpu_ioctl_run+0x12e4/0x23a0
[  111.293364]  ? vfs_writev+0xcb/0x1a0
[  111.293366]  kvm_vcpu_ioctl+0x27e/0x6d0
[  111.293368]  ? clockevents_program_event+0x95/0x100
[  111.293371]  ? selinux_file_ioctl+0xae/0x140
[  111.293372]  ? selinux_file_ioctl+0xae/0x140
[  111.293374]  __x64_sys_ioctl+0x92/0xd0
[  111.293376]  do_syscall_64+0x38/0x90
[  111.293377]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[  111.293379] RIP: 0033:0x7ff85c2688f7
[  111.293380] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
01 48
[  111.293381] RSP: 002b:00007ff85a8dda28 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  111.293382] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007ff85c2=
688f7
[  111.293383] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 00000000000=
0000f
[  111.293384] RBP: 000055c53d26daf0 R08: 000055c53c07c450 R09: 00000000fff=
fffff
[  111.293384] R10: 00007ffe8c3a3080 R11: 0000000000000246 R12: 00000000000=
00000
[  111.293385] R13: 00007ff85e598000 R14: 0000000000000006 R15: 000055c53d2=
6daf0
[  111.293388]  </TASK>
[  111.293388] ---[ end trace 0000000000000000 ]---


2. qemu_x86_64 boot warning:
-------------------------
<6>[    0.107789] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
<6>[    0.109374] Spectre V1 : Mitigation: usercopy/swapgs barriers
and __user pointer sanitization
<6>[    0.111110] Spectre V2 : Mitigation: Retpolines
<6>[    0.111782] Spectre V2 : Spectre v2 / SpectreRSB mitigation:
Filling RSB on context switch
<6>[    0.112906] Speculative Store Bypass: Vulnerable
<6>[    0.114978] MDS: Vulnerable: Clear CPU buffers attempted, no microcod=
e
<4>[    0.645298] ------------[ cut here ]------------
<4>[    0.646995] WARNING: CPU: 0 PID: 0 at
arch/x86/kernel/alternative.c:558 apply_returns+0x19c/0x1d0
<4>[    0.648802] Modules linked in:
<4>[    0.650105] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.18.12-rc1 #1
<4>[    0.650786] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.14.0-2 04/01/2014
<4>[    0.652104] RIP: 0010:apply_returns+0x19c/0x1d0
<4>[    0.652923] Code: 8d 7d c8 4c 89 75 c1 4c 89 74 08 f8 48 29 f8
8d 0c 02 4c 89 f0 c1 e9 03 f3 48 ab 8b 05 ed b6 56 02 85 c0 74 a0 e9
bf 30 26 01 <0f> 0b 48 83 c3 04 49 39 dd 0f 87 96 fe ff ff e9 0f ff ff
ff c7 45
<4>[    0.653825] RSP: 0000:ffffffff94a03d80 EFLAGS: 00000202
<4>[    0.654773] RAX: 0000000000000000 RBX: ffffffff95002f3c RCX:
0000000000000000
<4>[    0.655771] RDX: ffffffff94311ab5 RSI: 00000000000000e9 RDI:
ffffffff94311ab0
<4>[    0.656770] RBP: ffffffff94a03e48 R08: 0000000000000000 R09:
0000000000000001
<4>[    0.657445] R10: ffffffff94a03d48 R11: 0000000000000000 R12:
ffffffff94311ab0
<4>[    0.657770] R13: ffffffff950241c4 R14: cccccccccccccccc R15:
ffffffff94311ab5
<4>[    0.658884] FS:  0000000000000000(0000)
GS:ffff8a307ec00000(0000) knlGS:0000000000000000
<4>[    0.659777] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[    0.660767] CR2: ffff8a3049001000 CR3: 0000000007e26000 CR4:
00000000000006f0
<4>[    0.661836] Call Trace:
<4>[    0.662340]  <TASK>
<4>[    0.662908]  ? apply_retpolines+0x57/0x280
<4>[    0.663458]  ? synchronize_rcu+0xf4/0x110
<4>[    0.665050]  ? unregister_die_notifier+0x59/0x80
<4>[    0.665802]  alternative_instructions+0x4c/0x101
<4>[    0.666357]  check_bugs+0xdfc/0xe3d
<4>[    0.666899]  start_kernel+0x6b6/0x6ef
<4>[    0.667430]  x86_64_start_reservations+0x24/0x2a
<4>[    0.668192]  x86_64_start_kernel+0xab/0xb5
<4>[    0.668784]  secondary_startup_64_no_verify+0xd5/0xdb
<4>[    0.669590]  </TASK>
<4>[    0.670133] irq event stamp: 126395
<4>[    0.670514] hardirqs last  enabled at (126403):
[<ffffffff92c81b0c>] __up_console_sem+0x5c/0x70
<4>[    0.671499] hardirqs last disabled at (126412):
[<ffffffff92c81af1>] __up_console_sem+0x41/0x70
<4>[    0.672496] softirqs last  enabled at (82152):
[<ffffffff94000341>] __do_softirq+0x341/0x4d0
<4>[    0.672770] softirqs last disabled at (82135):
[<ffffffff92bfb413>] irq_exit_rcu+0xe3/0x140
<4>[    0.673782] ---[ end trace 0000000000000000 ]---
<6>[    0.870238] Freeing SMP alternatives memory: 52K
<6>[    1.015703] smpboot: CPU0: Intel Core i7 9xx (Nehalem Class Core
i7) (family: 0x6, model: 0x1a, stepping: 0x3)

3.perf build warning:
diff -u tools/arch/x86/include/asm/disabled-features.h
arch/x86/include/asm/disabled-features.h
Warning: Kernel ABI header at
'tools/arch/x86/include/asm/disabled-features.h' differs from latest
version at 'arch/x86/include/asm/disabled-features.h'
diff -u tools/arch/x86/include/asm/cpufeatures.h
arch/x86/include/asm/cpufeatures.h
Warning: Kernel ABI header at
'tools/arch/x86/include/asm/cpufeatures.h' differs from latest version
at 'arch/x86/include/asm/cpufeatures.h'
diff -u tools/arch/x86/include/asm/msr-index.h arch/x86/include/asm/msr-ind=
ex.h
Warning: Kernel ABI header at 'tools/arch/x86/include/asm/msr-index.h'
differs from latest version at 'arch/x86/include/asm/msr-index.h'

## Build
* kernel: 5.18.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 18f94637a0141cfc0d428f6acef57d59eb35dd27
* git describe: v5.18.11-62-g18f94637a014
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.11-62-g18f94637a014

## Test Regressions (compared to v5.18.10-113-g3c032a4d5696)
No test regressions found.

## Metric Regressions (compared to v5.18.10-113-g3c032a4d5696)
No metric regressions found.

## Test Fixes (compared to v5.18.10-113-g3c032a4d5696)
No test fixes found.

## Metric Fixes (compared to v5.18.10-113-g3c032a4d5696)
No metric fixes found.

## Test result summary
total: 136721, pass: 124649, fail: 913, skip: 10480, xfail: 679

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 62 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 52 passed, 8 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
