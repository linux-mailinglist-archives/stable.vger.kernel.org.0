Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E30574998
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 11:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiGNJuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 05:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiGNJuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 05:50:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0D581112
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 02:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657792217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=88qmQUgJ5U1AJ47SLAqo2YhFA7k8xSFsRJSJT0L316Q=;
        b=CzLoK46EsNZ2YKDjYUpnxyWcarWBCFmN9fq2w/8iUn2UGYfLAdIBOooz7s//bsW1AitIKe
        1S9lFRGmFVlGAhWwwm1T8uHCa8FYTl2ArGd9goKUTn3GGXfsPwHIk9cXB5NTbAbntHSH2o
        eKaZeUvX0BdUYx7vNhFFoycfxqVx3Y4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-cga3-V7CPsW49ll9xelApQ-1; Thu, 14 Jul 2022 05:50:16 -0400
X-MC-Unique: cga3-V7CPsW49ll9xelApQ-1
Received: by mail-wr1-f70.google.com with SMTP id a7-20020adfbc47000000b0021d77d52041so416818wrh.4
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 02:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=88qmQUgJ5U1AJ47SLAqo2YhFA7k8xSFsRJSJT0L316Q=;
        b=01Fgbf1RjbZKaaNTLC9EMMxlJTmc+TEjuF9zGn1B8nzdkayPGJTUGBOK6IFCsW3SOF
         SO4bnc1xfXwWAZy/cvydOfMAWXXnt9BXNZABdrvAyOiJHHTWRrtOMPQQLrDMS+/h/lz8
         IzkGcEZdz7u9XmBD0qv29ZqSHodVhc/JELmKevnOIwvcVVJjEEtzVMqdF+RheHNK/gfb
         bnfgIWBUxa6jhq7h11Dwkjc3dfirQ+sMy14GrEFQFxfLzgWDYXn9qzpiWYo6hyTr1EWj
         MU6v8WBiOst6NqXpzUzfGDw2+1e07rQf6YJgeHxe76Th83IhyDDcC1DKOc1Q2viw3392
         WVoQ==
X-Gm-Message-State: AJIora98yAiNVtP7gDLG/KUCp/hu4LPZ+RXv2iZS2CFGlI4G3E0bhC17
        r29QAm7I87B454HhE/XJXBhPIBH21zANNuHiEmfECLslxVC+pe7JTVHuWERHj/dJZLfMaAUKCTS
        lZlYEjTK7GjkTr7ET
X-Received: by 2002:a05:600c:1d1b:b0:3a3:e2:42d1 with SMTP id l27-20020a05600c1d1b00b003a300e242d1mr2845122wms.137.1657792214845;
        Thu, 14 Jul 2022 02:50:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ujm25SJJAlG3nTPWBxeVgc3y6GXdmEQdiaU/HtUzrivd8e3EP0jzuisueUKV5sTBiSrFUDeg==
X-Received: by 2002:a05:600c:1d1b:b0:3a3:e2:42d1 with SMTP id l27-20020a05600c1d1b00b003a300e242d1mr2845078wms.137.1657792214423;
        Thu, 14 Jul 2022 02:50:14 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id t7-20020a5d5347000000b0020fe35aec4bsm1021393wrv.70.2022.07.14.02.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 02:50:13 -0700 (PDT)
Message-ID: <1a143d949dc333666374cf14fae4496045f77db4.camel@redhat.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Date:   Thu, 14 Jul 2022 12:50:10 +0300
In-Reply-To: <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
References: <20220712183238.844813653@linuxfoundation.org>
         <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-07-13 at 18:22 +0530, Naresh Kamboju wrote:
> On Wed, 13 Jul 2022 at 00:17, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 
> > This is the start of the stable review cycle for the 5.15.55 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.55-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Results from Linaro’s test farm.
> Regressions on x86_64.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> 1) Kernel panic noticed on device x86_6 while running kvm-unit-tests.
>    - APIC base relocation is unsupported by KVM

My 0.2 cent:

APIC base relocation warning is harmless, and I removed it 5.19 kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.19-rc6&id=3743c2f0251743b8ae968329708bbbeefff244cf

The 'emulating exchange as write' is also something that KVM unit tests trigger
normally although this warning recently did signal a real and very nasty bug, which I fixed in this commit:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.19-rc6&id=33fbe6befa622c082f7d417896832856814bdde0


FYI, Another 'pr_info_ratelimited' message from KVM that you will see when running the unit tests is this
"kvm: vcpu 0: requested 2000 ns lapic timer period limited to 200000 ns"

It is also harmless, but I do wonder how much value it adds.

And the panic I guess was already figured out.

BTW, there is a script in the kernel source, called decode_stacktrace
(./scripts/decode_stacktrace.sh)

It is very useful to figure out, on which source line the panic/oops
was triggered, you might want to consider using it in the report.

(I do wish the kernel had a debug option, of 'I don't care about kernel addresses/info leaks',
please print all the info you can in the stacktrace).


Best regards,
	Maxim Levitsky

> 
> 2) while booting qemu-x86_64 the following warning noticed.
>   - WARNING: CPU: 0 PID: 0 at arch/x86/kernel/alternative.c:557
> apply_returns+0x19c/0x1d0
> 
> kernel panic log:
>    -  https://lkft.validation.linaro.org/scheduler/job/5278112#L1703
> TESTNAME=emulator TIMEOUT=90s ACCEL= ./x86/run x86/emulator.flat -smp 1
> [   67.774572] APIC base relocation is unsupported by KVM
> [  105.643057] kvm: emulating exchange as write
> [  105.653717] int3: 0000 [#1] SMP PTI
> [  105.653720] CPU: 3 PID: 3747 Comm: qemu-system-x86 Not tainted 5.15.55-rc1 #1
> [  105.653721] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  105.653722] RIP: 0010:xaddw_ax_dx+0x9/0x10
> [  105.653727] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [  105.653728] RSP: 0018:ffffb98bc5157ce8 EFLAGS: 00000206
> [  105.653729] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [  105.653730] RDX: 0000000076543210 RSI: ffffffff8ea56000 RDI: 0000000000000204
> [  105.653731] RBP: ffffb98bc5157cf0 R08: ffffa306c6cf5df0 R09: 0000000000000002
> [  105.653732] R10: ffffa306c6cf5df0 R11: 0000000000000000 R12: ffffa306c6cf5df0
> [  105.653733] R13: ffffffff900090c0 R14: 0000000000000000 R15: 0000000000000000
> [  105.653734] FS:  00007f30ab0df700(0000) GS:ffffa30a1fd80000(0000)
> knlGS:0000000000000000
> [  105.653735] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  105.653736] CR2: 0000000000000000 CR3: 000000014e0d0003 CR4: 00000000003726e0
> [  105.653736] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  105.653737] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  105.653738] Call Trace:
> [  105.653738]  <TASK>
> [  105.653739]  ? fastop+0x5d/0xa0
> [  105.653741]  x86_emulate_insn+0x7c9/0xf20
> [  105.653743]  x86_emulate_instruction+0x2e3/0x790
> [  105.653746]  complete_emulated_mmio+0x238/0x310
> [  105.653748]  kvm_arch_vcpu_ioctl_run+0x11ba/0x1a70
> [  105.653750]  ? vfs_writev+0xcb/0x140
> [  105.653753]  kvm_vcpu_ioctl+0x281/0x6b0
> [  105.653755]  ? clockevents_program_event+0x98/0x100
> [  105.653757]  ? selinux_file_ioctl+0xae/0x140
> [  105.653760]  ? selinux_file_ioctl+0xae/0x140
> [  105.653762]  __x64_sys_ioctl+0x95/0xd0
> [  105.653764]  do_syscall_64+0x3b/0x90
> [  105.653767]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
> [  105.653769] RIP: 0033:0x7f30aca698f7
> [  105.653770] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
> 01 48
> [  105.653771] RSP: 002b:00007f30ab0dea28 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  105.653772] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f30aca698f7
> [  105.653773] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000f
> [  105.653774] RBP: 000055fb7fb6faf0 R08: 000055fb7d67c450 R09: 00000000ffffffff
> [  105.653775] R10: 00000000000216a8 R11: 0000000000000246 R12: 0000000000000000
> [  105.653775] R13: 00007f30aed99000 R14: 0000000000000006 R15: 000055fb7fb6faf0
> [  105.653776]  </TASK>
> [  105.653777] Modules linked in: x86_pkg_temp_thermal
> [  105.902123] ---[ end trace cec99cae36bcbfd7 ]---
> [  105.902124] RIP: 0010:xaddw_ax_dx+0x9/0x10
> [  105.902126] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [  105.902127] RSP: 0018:ffffb98bc5157ce8 EFLAGS: 00000206
> [  105.902127] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [  105.902128] RDX: 0000000076543210 RSI: ffffffff8ea56000 RDI: 0000000000000204
> [  105.902129] RBP: ffffb98bc5157cf0 R08: ffffa306c6cf5df0 R09: 0000000000000002
> [  105.902129] R10: ffffa306c6cf5df0 R11: 0000000000000000 R12: ffffa306c6cf5df0
> [  105.902130] R13: ffffffff900090c0 R14: 0000000000000000 R15: 0000000000000000
> [  105.902130] FS:  00007f30ab0df700(0000) GS:ffffa30a1fd80000(0000)
> knlGS:0000000000000000
> [  105.902131] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  105.902132] CR2: 0000000000000000 CR3: 000000014e0d0003 CR4: 00000000003726e0
> [  105.902133] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  105.902133] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  105.902134] Kernel panic - not syncing: Fatal exception in interrupt
> [  105.902170] Kernel Offset: 0xda00000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [  106.022663] ---[ end Kernel panic - not syncing: Fatal exception in
> interrupt ]---
> [  106.030224] ------------[ cut here ]------------
> [  106.030224] sched: Unexpected reschedule of offline CPU#0!
> [  106.030226] WARNING: CPU: 3 PID: 3747 at
> arch/x86/kernel/apic/ipi.c:68 native_smp_send_reschedule+0x3e/0x50
> [  106.030229] Modules linked in: x86_pkg_temp_thermal
> [  106.030230] CPU: 3 PID: 3747 Comm: qemu-system-x86 Tainted: G
> D           5.15.55-rc1 #1
> [  106.030231] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  106.030232] RIP: 0010:native_smp_send_reschedule+0x3e/0x50
> [  106.030234] Code: 1b 48 8b 05 d4 70 a6 01 be fd 00 00 00 48 8b 40
> 30 e8 66 dc 31 01 5d c3 cc cc cc cc 89 fe 48 c7 c7 a0 e9 41 90 e8 1e
> c3 ea 00 <0f> 0b 5d c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
> 44 00
> [  106.030234] RSP: 0018:ffffb98bc0160c60 EFLAGS: 00010086
> [  106.030235] RAX: 0000000000000000 RBX: ffffa30a1fc29b00 RCX: 0000000000000027
> [  106.030236] RDX: ffffa30a1fd9b4b8 RSI: 0000000000000001 RDI: ffffa30a1fd9b4b0
> [  106.030237] RBP: ffffb98bc0160c60 R08: ffffffff90b65665 R09: 0000000000000000
> [  106.030237] R10: 0000000000000030 R11: ffffffff90b65665 R12: ffffa306c097c100
> [  106.030238] R13: ffffb98bc0160d00 R14: ffffb98bc0160d00 R15: 0000000000000009
> [  106.030239] FS:  00007f30ab0df700(0000) GS:ffffa30a1fd80000(0000)
> knlGS:0000000000000000
> [  106.030239] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  106.030240] CR2: 0000000000000000 CR3: 000000014e0d0003 CR4: 00000000003726e0
> [  106.030241] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  106.030241] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  106.030242] Call Trace:
> [  106.030242]  <IRQ>
> [  106.030243]  resched_curr+0x52/0xb0
> [  106.030245]  check_preempt_curr+0x3b/0x70
> [  106.030247]  ttwu_do_wakeup+0x1c/0x160
> [  106.030249]  ttwu_do_activate+0x94/0x190
> [  106.030251]  try_to_wake_up+0x1c4/0x480
> [  106.030253]  default_wake_function+0x1a/0x40
> [  106.030254]  autoremove_wake_function+0x12/0x40
> [  106.030256]  __wake_up_common+0x7d/0x140
> [  106.030258]  __wake_up_common_lock+0x7c/0xc0
> [  106.030261]  __wake_up+0x13/0x20
> [  106.030263]  wake_up_klogd_work_func+0x7b/0x90
> [  106.030265]  irq_work_single+0x46/0x80
> [  106.030267]  irq_work_run_list+0x2a/0x40
> [  106.030269]  irq_work_tick+0x3b/0x50
> [  106.030270]  update_process_times+0xba/0xd0
> [  106.030272]  tick_sched_handle+0x38/0x50
> [  106.030274]  tick_sched_timer+0x8c/0xc0
> [  106.030276]  ? can_stop_idle_tick+0xa0/0xa0
> [  106.030278]  __hrtimer_run_queues+0xa6/0x2b0
> [  106.030280]  hrtimer_interrupt+0x101/0x220
> [  106.030281]  __sysvec_apic_timer_interrupt+0x61/0xe0
> [  106.030283]  sysvec_apic_timer_interrupt+0x7b/0x90
> [  106.030285]  </IRQ>
> [  106.030285]  <TASK>
> [  106.030286]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [  106.030288] RIP: 0010:panic+0x277/0x2b6
> [  106.030290] Code: e8 65 ac 25 ff 48 c7 c6 80 04 b5 90 48 c7 c7 80
> 3f 42 90 e8 6a 58 00 00 c7 05 cc 8e f5 00 01 00 00 00 e8 d3 80 33 ff
> fb 31 db <4c> 39 eb 7c 1d 41 83 f4 01 48 8b 05 a0 d2 1b 01 44 89 e7 e8
> 18 16
> [  106.030291] RSP: 0018:ffffb98bc5157b10 EFLAGS: 00000246
> [  106.030292] RAX: ffffb98bc5157b80 RBX: 0000000000000000 RCX: 0000000000000027
> [  106.030292] RDX: 0000000000000000 RSI: ffffffff8f98de8f RDI: ffffffff8f99314d
> [  106.030293] RBP: ffffb98bc5157b80 R08: ffffffff90b655fa R09: 0000000090b655d6
> [  106.030293] R10: ffffffffffffffff R11: ffffffffffffffff R12: 0000000000000000
> [  106.030294] R13: 0000000000000000 R14: ffffffff904131e0 R15: 0000000000000000
> [  106.030295]  ? oops_end.cold+0xc/0x18
> [  106.030297]  ? panic+0x274/0x2b6
> [  106.030299]  oops_end.cold+0xc/0x18
> [  106.030300]  die+0x43/0x60
> [  106.030302]  exc_int3+0x137/0x160
> [  106.030303]  asm_exc_int3+0x39/0x40
> [  106.030305] RIP: 0010:xaddw_ax_dx+0x9/0x10
> [  106.030307] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [  106.030308] RSP: 0018:ffffb98bc5157ce8 EFLAGS: 00000206
> [  106.030308] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [  106.030309] RDX: 0000000076543210 RSI: ffffffff8ea56000 RDI: 0000000000000204
> [  106.030310] RBP: ffffb98bc5157cf0 R08: ffffa306c6cf5df0 R09: 0000000000000002
> [  106.030310] R10: ffffa306c6cf5df0 R11: 0000000000000000 R12: ffffa306c6cf5df0
> [  106.030311] R13: ffffffff900090c0 R14: 0000000000000000 R15: 0000000000000000
> [  106.030312]  ? xaddw_ax_dx+0x8/0x10
> [  106.030314]  ? xaddw_ax_dx+0x9/0x10
> [  106.030315]  ? xaddw_ax_dx+0x8/0x10
> [  106.030317]  ? fastop+0x5d/0xa0
> [  106.030319]  x86_emulate_insn+0x7c9/0xf20
> [  106.030321]  x86_emulate_instruction+0x2e3/0x790
> [  106.030323]  complete_emulated_mmio+0x238/0x310
> [  106.030325]  kvm_arch_vcpu_ioctl_run+0x11ba/0x1a70
> [  106.030327]  ? vfs_writev+0xcb/0x140
> [  106.030330]  kvm_vcpu_ioctl+0x281/0x6b0
> [  106.030331]  ? clockevents_program_event+0x98/0x100
> [  106.030333]  ? selinux_file_ioctl+0xae/0x140
> [  106.030335]  ? selinux_file_ioctl+0xae/0x140
> [  106.030337]  __x64_sys_ioctl+0x95/0xd0
> [  106.030339]  do_syscall_64+0x3b/0x90
> [  106.030340]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
> [  106.030342] RIP: 0033:0x7f30aca698f7
> [  106.030343] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
> 01 48
> [  106.030343] RSP: 002b:00007f30ab0dea28 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  106.030344] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f30aca698f7
> [  106.030345] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000f
> [  106.030346] RBP: 000055fb7fb6faf0 R08: 000055fb7d67c450 R09: 00000000ffffffff
> [  106.030346] R10: 00000000000216a8 R11: 0000000000000246 R12: 0000000000000000
> [  106.030347] R13: 00007f30aed99000 R14: 0000000000000006 R15: 000055fb7fb6faf0
> [  106.030348]  </TASK>
> [  106.030348] ---[ end trace cec99cae36bcbfd8 ]---
> [  106.030350] ------------[ cut here ]------------
> [  106.030350] sched: Unexpected reschedule of offline CPU#2!
> [  106.030351] WARNING: CPU: 3 PID: 3747 at
> arch/x86/kernel/apic/ipi.c:68 native_smp_send_reschedule+0x3e/0x50
> [  106.030354] Modules linked in: x86_pkg_temp_thermal
> [  106.030354] CPU: 3 PID: 3747 Comm: qemu-system-x86 Tainted: G
> D W         5.15.55-rc1 #1
> [  106.030355] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  106.030356] RIP: 0010:native_smp_send_reschedule+0x3e/0x50
> [  106.030357] Code: 1b 48 8b 05 d4 70 a6 01 be fd 00 00 00 48 8b 40
> 30 e8 66 dc 31 01 5d c3 cc cc cc cc 89 fe 48 c7 c7 a0 e9 41 90 e8 1e
> c3 ea 00 <0f> 0b 5d c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
> 44 00
> [  106.030358] RSP: 0018:ffffb98bc0160b40 EFLAGS: 00010086
> [  106.030359] RAX: 0000000000000000 RBX: ffffa30a1fd29b00 RCX: 0000000000000027
> [  106.030360] RDX: ffffa30a1fd9b4b8 RSI: 0000000000000001 RDI: ffffa30a1fd9b4b0
> [  106.030360] RBP: ffffb98bc0160b40 R08: ffffffff90b66d1d R09: 0000000000000000
> [  106.030361] R10: 0000000000000030 R11: ffffffff90b66d1d R12: ffffa306c2216180
> [  106.030361] R13: ffffb98bc0160be0 R14: ffffb98bc0160be0 R15: 0000000000000009
> [  106.030362] FS:  00007f30ab0df700(0000) GS:ffffa30a1fd80000(0000)
> knlGS:0000000000000000
> [  106.030363] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  106.030364] CR2: 0000000000000000 CR3: 000000014e0d0003 CR4: 00000000003726e0
> [  106.030364] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  106.030365] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  106.030365] Call Trace:
> [  106.030366]  <IRQ>
> [  106.030366]  resched_curr+0x52/0xb0
> [  106.030368]  check_preempt_curr+0x3b/0x70
> [  106.030369]  ttwu_do_wakeup+0x1c/0x160
> [  106.030371]  ttwu_do_activate+0x94/0x190
> [  106.030373]  try_to_wake_up+0x1c4/0x480
> [  106.030375]  default_wake_function+0x1a/0x40
> [  106.030377]  autoremove_wake_function+0x12/0x40
> [  106.030378]  __wake_up_common+0x7d/0x140
> [  106.030380]  __wake_up_common_lock+0x7c/0xc0
> [  106.030382]  __wake_up+0x13/0x20
> [  106.030384]  ep_poll_callback+0x10e/0x290
> [  106.030386]  __wake_up_common+0x7d/0x140
> [  106.030389]  __wake_up_common_lock+0x7c/0xc0
> [  106.030391]  __wake_up+0x13/0x20
> [  106.030393]  wake_up_klogd_work_func+0x7b/0x90
> [  106.030395]  irq_work_single+0x46/0x80
> [  106.030397]  irq_work_run_list+0x2a/0x40
> [  106.030398]  irq_work_tick+0x3b/0x50
> [  106.030400]  update_process_times+0xba/0xd0
> [  106.030401]  tick_sched_handle+0x38/0x50
> [  106.030403]  tick_sched_timer+0x8c/0xc0
> [  106.030405]  ? can_stop_idle_tick+0xa0/0xa0
> [  106.030407]  __hrtimer_run_queues+0xa6/0x2b0
> [  106.030408]  hrtimer_interrupt+0x101/0x220
> [  106.030410]  __sysvec_apic_timer_interrupt+0x61/0xe0
> [  106.030411]  sysvec_apic_timer_interrupt+0x7b/0x90
> [  106.030413]  </IRQ>
> [  106.030413]  <TASK>
> [  106.030414]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [  106.030416] RIP: 0010:panic+0x277/0x2b6
> [  106.030417] Code: e8 65 ac 25 ff 48 c7 c6 80 04 b5 90 48 c7 c7 80
> 3f 42 90 e8 6a 58 00 00 c7 05 cc 8e f5 00 01 00 00 00 e8 d3 80 33 ff
> fb 31 db <4c> 39 eb 7c 1d 41 83 f4 01 48 8b 05 a0 d2 1b 01 44 89 e7 e8
> 18 16
> [  106.030418] RSP: 0018:ffffb98bc5157b10 EFLAGS: 00000246
> [  106.030419] RAX: ffffb98bc5157b80 RBX: 0000000000000000 RCX: 0000000000000027
> [  106.030419] RDX: 0000000000000000 RSI: ffffffff8f98de8f RDI: ffffffff8f99314d
> [  106.030420] RBP: ffffb98bc5157b80 R08: ffffffff90b655fa R09: 0000000090b655d6
> [  106.030420] R10: ffffffffffffffff R11: ffffffffffffffff R12: 0000000000000000
> [  106.030421] R13: 0000000000000000 R14: ffffffff904131e0 R15: 0000000000000000
> [  106.030422]  ? oops_end.cold+0xc/0x18
> [  106.030423]  ? panic+0x274/0x2b6
> [  106.030425]  oops_end.cold+0xc/0x18
> [  106.030427]  die+0x43/0x60
> [  106.030428]  exc_int3+0x137/0x160
> [  106.030430]  asm_exc_int3+0x39/0x40
> [  106.030431] RIP: 0010:xaddw_ax_dx+0x9/0x10
> [  106.030433] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [  106.030434] RSP: 0018:ffffb98bc5157ce8 EFLAGS: 00000206
> [  106.030434] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [  106.030435] RDX: 0000000076543210 RSI: ffffffff8ea56000 RDI: 0000000000000204
> [  106.030436] RBP: ffffb98bc5157cf0 R08: ffffa306c6cf5df0 R09: 0000000000000002
> [  106.030436] R10: ffffa306c6cf5df0 R11: 0000000000000000 R12: ffffa306c6cf5df0
> [  106.030437] R13: ffffffff900090c0 R14: 0000000000000000 R15: 0000000000000000
> [  106.030437]  ? xaddw_ax_dx+0x8/0x10
> [  106.030439]  ? xaddw_ax_dx+0x9/0x10
> [  106.030441]  ? xaddw_ax_dx+0x8/0x10
> [  106.030443]  ? fastop+0x5d/0xa0
> [  106.030445]  x86_emulate_insn+0x7c9/0xf20
> [  106.030446]  x86_emulate_instruction+0x2e3/0x790
> [  106.030449]  complete_emulated_mmio+0x238/0x310
> [  106.030450]  kvm_arch_vcpu_ioctl_run+0x11ba/0x1a70
> [  106.030453]  ? vfs_writev+0xcb/0x140
> [  106.030455]  kvm_vcpu_ioctl+0x281/0x6b0
> [  106.030456]  ? clockevents_program_event+0x98/0x100
> [  106.030458]  ? selinux_file_ioctl+0xae/0x140
> [  106.030460]  ? selinux_file_ioctl+0xae/0x140
> [  106.030462]  __x64_sys_ioctl+0x95/0xd0
> [  106.030464]  do_syscall_64+0x3b/0x90
> [  106.030465]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
> [  106.030467] RIP: 0033:0x7f30aca698f7
> [  106.030468] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
> 01 48
> [  106.030468] RSP: 002b:00007f30ab0dea28 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  106.030469] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f30aca698f7
> [  106.030470] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000f
> [  106.030470] RBP: 000055fb7fb6faf0 R08: 000055fb7d67c450 R09: 00000000ffffffff
> [  106.030471] R10: 00000000000216a8 R11: 0000000000000246 R12: 0000000000000000
> [  106.030472] R13: 00007f30aed99000 R14: 0000000000000006 R15: 000055fb7fb6faf0
> [  106.030473]  </TASK>
> [  106.030473] ---[ end trace cec99cae36bcbfd9 ]---
> 
> 2. Kernel warning
>     - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.54-79-g0fe4fdf9b1da/testrun/10799646/suite/log-parser-test/tests/
> <6>[    0.571674] Speculative Store Bypass: Vulnerable
> <6>[    0.573329] MDS: Vulnerable: Clear CPU buffers attempted, no microcode
> <4>[    0.942716] ------------[ cut here ]------------
> <4>[    0.944263] WARNING: CPU: 0 PID: 0 at
> arch/x86/kernel/alternative.c:557 apply_returns+0x19c/0x1d0
> <4>[    0.945106] Modules linked in:
> <4>[    0.946322] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.55-rc1 #1
> <4>[    0.947052] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS 1.14.0-2 04/01/2014
> <4>[    0.947844] RIP: 0010:apply_returns+0x19c/0x1d0
> <4>[    0.948453] Code: 8d 7d c8 4c 89 75 c1 4c 89 74 08 f8 48 29 f8
> 8d 0c 02 4c 89 f0 c1 e9 03 f3 48 ab 8b 05 9d ba 52 02 85 c0 74 a0 e9
> 45 32 1a 01 <0f> 0b 48 83 c3 04 49 39 dd 0f 87 96 fe ff ff e9 0f ff ff
> ff c7 45
> <4>[    0.950059] RSP: 0000:ffffffff89803d78 EFLAGS: 00000206
> <4>[    0.950484] RAX: 0000000000000000 RBX: ffffffff89dbb174 RCX:
> 0000000000000000
> <4>[    0.951033] RDX: ffffffff891011b5 RSI: 00000000000000e9 RDI:
> ffffffff891011b0
> <4>[    0.951488] RBP: ffffffff89803e40 R08: 0000000000000000 R09:
> 0000000000000001
> <4>[    0.952032] R10: 0000000000000029 R11: 0000000000000000 R12:
> ffffffff891011b0
> <4>[    0.952488] R13: ffffffff89ddb184 R14: cccccccccccccccc R15:
> ffffffff891011b5
> <4>[    0.953125] FS:  0000000000000000(0000)
> GS:ffff90f63fc00000(0000) knlGS:0000000000000000
> <4>[    0.953634] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[    0.954031] CR2: ffff90f63fa01000 CR3: 000000003e826000 CR4:
> 00000000000006f0
> <4>[    0.954669] Call Trace:
> <4>[    0.955846]  <TASK>
> <4>[    0.957183]  alternative_instructions+0x7d/0x146
> <4>[    0.957673]  check_bugs+0xf16/0xf57
> <4>[    0.958114]  start_kernel+0x6b6/0x6ef
> <4>[    0.958446]  x86_64_start_reservations+0x24/0x2a
> <4>[    0.958764]  x86_64_start_kernel+0x8d/0x95
> <4>[    0.959035]  secondary_startup_64_no_verify+0xc2/0xcb
> <4>[    0.959591]  </TASK>
> <4>[    0.960146] irq event stamp: 121171
> <4>[    0.960419] hardirqs last  enabled at (121179):
> [<ffffffff87a7247c>] __up_console_sem+0x5c/0x70
> <4>[    0.961036] hardirqs last disabled at (121188):
> [<ffffffff87a72461>] __up_console_sem+0x41/0x70
> <4>[    0.961577] softirqs last  enabled at (1484):
> [<ffffffff87ad3f20>] cgroup_idr_alloc.constprop.0+0x60/0xe0
> <4>[    0.962031] softirqs last disabled at (1482):
> [<ffffffff87ad3ef3>] cgroup_idr_alloc.constprop.0+0x33/0xe0
> <4>[    0.963358] ---[ end trace 7af0f35d34a8be8b ]---
> <6>[    1.100332] Freeing SMP alternatives memory: 52K
> <6>[    1.233988] smpboot: CPU0: Intel Core i7 9xx (Nehalem Class Core
> i7) (family: 0x6, model: 0x1a, stepping: 0x3)
> <6>[    1.266761] Running RCU-tasks wait API self tests
> <6>[    1.271070] Performance Events: unsupported p6 CPU model 26 no
> PMU driver, software events only.
> <6>[    1.276776] rcu: Hierarchical SRCU implementation.
> <6>[    1.281153] Callback from call_rcu_ta#
> sks_trace() invoked.
> <6>[    1.308215] smp: Bringing up secondary CPUs ...
> <6>[    1.322732] x86: Booting SMP configuration:
> <6>[    1.323121] .... node  #0, CPUs:      #1
> <6>[    1.361239] smp: Brought up 1 node, 2 CPUs
> 
> 
> ## Build
> * kernel: 5.15.55-rc1
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-5.15.y
> * git commit: 0fe4fdf9b1dac90e23465eefeff45e529adcf3c6
> * git describe: v5.15.54-79-g0fe4fdf9b1da
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.54-79-g0fe4fdf9b1da
> 
> ## Test Regressions (compared to v5.15.53-227-g71721f5974f2)
> kernel crash regression found.
> 
> ## Metric Regressions (compared to v5.15.53-227-g71721f5974f2)
> No metric regressions found.
> 
> ## Test Fixes (compared to v5.15.53-227-g71721f5974f2)
> No test fixes found.
> 
> ## Metric Fixes (compared to v5.15.53-227-g71721f5974f2)
> No metric fixes found.
> 
> ## Test result summary
> total: 137556, pass: 124337, fail: 404, skip: 12121, xfail: 694
> 
> ## Build Summary
> * arc: 10 total, 10 passed, 0 failed
> * arm: 308 total, 308 passed, 0 failed
> * arm64: 62 total, 62 passed, 0 failed
> * i386: 52 total, 49 passed, 3 failed
> * mips: 48 total, 48 passed, 0 failed
> * parisc: 12 total, 12 passed, 0 failed
> * powerpc: 54 total, 52 passed, 2 failed
> * riscv: 22 total, 22 passed, 0 failed
> * s390: 21 total, 21 passed, 0 failed
> * sh: 24 total, 24 passed, 0 failed
> * sparc: 12 total, 12 passed, 0 failed
> * x86_64: 56 total, 55 passed, 1 failed
> 
> ## Test suites summary
> * fwts
> * kunit
> * kvm-unit-tests
> * libgpiod
> * libhugetlbfs
> * log-parser-boot
> * log-parser-test
> * ltp-cap_bounds
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-cpuhotplug
> * ltp-crypto
> * ltp-cve
> * ltp-dio
> * ltp-fcntl-locktests
> * ltp-filecaps
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-fsx
> * ltp-hugetlb
> * ltp-io
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-open-posix-tests
> * ltp-pty
> * ltp-sched
> * ltp-securebits
> * ltp-smoke
> * ltp-syscalls
> * ltp-tracing
> * network-basic-tests
> * packetdrill
> * perf
> * perf/Zstd-perf.data-compression
> * rcutorture
> * ssuite
> * v4l2-compliance
> * vdso
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 


