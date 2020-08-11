Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD7E241654
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 08:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgHKG3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 02:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgHKG3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 02:29:50 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AE8C061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 23:29:50 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id j8so11509074ioe.9
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 23:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aNnAeZQA4dDcU/wP3GlS98gDCwWR0FArn/KPOtHttxw=;
        b=rMRR3B/IUXnChu4yxa02VcTqFo7vPHWHHyMIoUf3q2VRLbmSXlTiy9CzU74grMCJmn
         MIOapE/wMdEUU7teHJXzPHEpVy0GrPVrND+qqz1LV82K/pUbrCVylNNC8Mw26Uw+P3ny
         8zIlgemEqUNBt7PCZ6xAIsKeSk5wemIeH4ggqlNZMcLLhD/5ue6esPVNS0hSKTNrLaTC
         4zkJW/bDn/C/6+kbe51qR8CN1XdGbzgIn44WfgZbsLL/7rCkMZRWKCWripO9pj4t+L1K
         798hQmfHbJpxuZg3It1DLezH7JKhMufEs5Ji+Xo9NMWExlgoAhS8C8r0WpvcPvxduaQj
         VA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aNnAeZQA4dDcU/wP3GlS98gDCwWR0FArn/KPOtHttxw=;
        b=Aa0ZS37/fpfENDsaRo//H4Q/N3+Vbi+aqK2x9M8BjC6OS8S7GN9oqPE81SwNav7/8L
         KHzNV/oVYTf3Q0r1GhRqnxBD96KTPmGMlD+L0v9gA3uN1+c+X6tBFVaj0LQVcP1071Jw
         BgD8mGaP1ig71OgGhML3c5pa0r0p2CmgxQ/3LRIBdrhDNmeHhwNK1U3TI2PIGXFxJh/5
         fwgtVYA1Bfnj20k8wIaCaxWoIefsoSaKKVQdHa/ScxDyr84MS/2cKP7jtKYrZZEXBVtD
         eV6jdJMYXmtVKnitQpdHuTOLr1yQBROhK7/+hMFQ6Q0/wlt+oPbhZlf4nbYv5oQsOJCq
         iEGA==
X-Gm-Message-State: AOAM53245qs0hFyyT7nnYxOZ0CHURm3e7A7qAmEZEHrUePPTjdEtXe5e
        uV2PIikTB+nwSROE1wTJMxALi5hcPxtaqeV0dWCRyZZ+zv7tSQ==
X-Google-Smtp-Source: ABdhPJx229ezwmO8zclGn4W04WWCsMNuhTrFQKqTtcJJMOqZSK5pKLWofS7fxWyBKBNUEMN8ltHSGUCC8CXnPWanEh4=
X-Received: by 2002:a05:6602:2c08:: with SMTP id w8mr21797292iov.129.1597127388974;
 Mon, 10 Aug 2020 23:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200810151803.920113428@linuxfoundation.org>
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Aug 2020 11:59:37 +0530
Message-ID: <CA+G9fYtzP22nR4vd+GAn+tqy0S38XAa3E9=QfDiSPWHrHeqgsw@mail.gmail.com>
Subject: Re: [PATCH 5.8 00/38] 5.8.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Aug 2020 at 20:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Few warnings noticed while running kselftests on arm64 juno-r2 device
1 and 3 noticed on linux mainline tree
2 and 4 seems to be specific to arm64 juno platform.

1)
[   85.834361] WARNING: CPU: 4 PID: 740 at
/usr/src/kernel/kernel/bpf/verifier.c:8999 bpf_check+0x1d1c/0x2ac0
2)
[   97.854733] Unexpected kernel BRK exception at EL1
[   97.861235] Internal error: ptrace BRK handler: f2000100 [#1] PREEMPT SM=
P
3)
[  102.715399] BUG: sleeping function called from invalid context at
/usr/src/kernel/include/linux/percpu-rwsem.h:49
4)
[  102.891463] WARNING: CPU: 2 PID: 0 at
/usr/src/kernel/kernel/rcu/tree.c:618 rcu_eqs_enter.isra.67+0xd8/0xe0

Summary
------------------------------------------------------------------------

kernel: 5.8.1-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: b30c8c9d42601af8ebeb3ad42085ff4134a111a0
git describe: v5.8-39-gb30c8c9d4260
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/bui=
ld/v5.8-39-gb30c8c9d4260

No regressions (compared to build v5.8)

No fixes (compared to build v5.8)


------------[ cut here ]------------
[   85.826439] trace type BPF program uses run-time allocation
[   85.834361] WARNING: CPU: 4 PID: 740 at
/usr/src/kernel/kernel/bpf/verifier.c:8999 bpf_check+0x1d1c/0x2ac0
[   85.846245] Modules linked in: rfkill tda998x cec drm_kms_helper
drm crct10dif_ce fuse
[   85.856955] CPU: 4 PID: 740 Comm: test_verifier Not tainted 5.8.1-rc1 #1
[   85.866436] Hardware name: ARM Juno development board (r2) (DT)
[   85.875143] pstate: 40000005 (nZcv daif -PAN -UAO BTYPE=3D--)
[   85.883503] pc : bpf_check+0x1d1c/0x2ac0
[   85.890202] lr : bpf_check+0x1d1c/0x2ac0
[   85.896902] sp : ffff80001472bb00
[   85.902997] x29: ffff80001472bb00 x28: 0000000000000025
[   85.911091] x27: ffff800011382000 x26: 0000000000000000
[   85.919186] x25: 0000000000000000 x24: ffff00096e9d8000
[   85.927282] x23: ffff0009731d1400 x22: ffff8000135c3058
[   85.935376] x21: 0000000000000004 x20: ffff00096e94b800
[   85.943471] x19: ffff800012650000 x18: ffffffffffffffff
[   85.951566] x17: 00000000bd597f08 x16: 000000004476e5aa
[   85.959662] x15: ffff800012650a88 x14: ffff80009472b7e7
[   85.967757] x13: ffff80001472b7f5 x12: ffff800012680000
[   85.975851] x11: 0000000005f5e0ff x10: ffff00097efa5118
[   85.983947] x9 : ffff800013134000 x8 : 00000000d7e0a7a6
[   85.992042] x7 : ffff800012654000 x6 : ffff00097ef904a8
[   86.000137] x5 : ffff00097ef904a8 x4 : ffff0009751597c0
[   86.008233] x3 : ffff800012651000 x2 : 0000000000000000
[   86.016327] x1 : ac9d7b2c4e06c300 x0 : 0000000000000000
[   86.024423] Call trace:
[   86.029653]  bpf_check+0x1d1c/0x2ac0
[   86.036006]  bpf_prog_load+0x698/0x8b8
[   86.042533]  __do_sys_bpf+0xf3c/0x1d18
[   86.049062]  __arm64_sys_bpf+0x28/0x38
[   86.055592]  el0_svc_common.constprop.3+0x7c/0x198
[   86.063162]  do_el0_svc+0x34/0xa0
[   86.069258]  el0_sync_handler+0x16c/0x210
[   86.076045]  el0_sync+0x140/0x180
[   86.082137] irq event stamp: 60966
[   86.088326] hardirqs last  enabled at (60965): [<ffff800011332760>]
_raw_spin_unlock_irq+0x48/0x90
[   86.100075] hardirqs last disabled at (60966): [<ffff800010029a04>]
debug_exception_enter+0xac/0xe8
[   86.111909] softirqs last  enabled at (60960): [<ffff8000100019bc>]
__do_softirq+0x59c/0x5dc
[   86.123138] softirqs last disabled at (60925): [<ffff80001008fbf4>]
irq_exit+0x144/0x150
[   86.134011] ---[ end trace 14c3fdd625b93f50 ]---
[   88.541693]
[   90.633700] kauditd_printk_skb: 1766 callbacks suppressed
[   90.633713] audit: type=3D1334 audit(1597081685.048:1803): prog-id=3D906=
 op=3DLOAD
[   90.651538] audit: type=3D1334 audit(1597081686.220:1804):
prog-id=3D906 op=3DUNLOAD
[   90.661574] audit: type=3D1334 audit(1597081686.220:1805): prog-id=3D907=
 op=3DLOAD
[   90.671455] audit: type=3D1334 audit(1597081686.228:1806):
prog-id=3D907 op=3DUNLOAD
[   95.725310] audit: type=3D1334 audit(1597081686.228:1807): prog-id=3D908=
 op=3DLOAD
[   95.734199] audit: type=3D1334 audit(1597081691.312:1808):
prog-id=3D908 op=3DUNLOAD
[   95.760019] audit: type=3D1334 audit(1597081691.344:1809): prog-id=3D909=
 op=3DLOAD
[   95.769379] audit: type=3D1334 audit(1597081691.348:1810):
prog-id=3D909 op=3DUNLOAD
[   95.779416] audit: type=3D1334 audit(1597081691.348:1811): prog-id=3D910=
 op=3DLOAD
[   95.789197] audit: type=3D1334 audit(1597081691.356:1812):
prog-id=3D910 op=3DUNLOAD
[   95.799333] audit: type=3D1334 audit(1597081691.356:1813): prog-id=3D911=
 op=3DLOAD
[   95.809110] audit: type=3D1334 audit(1597081691.368:1814):
prog-id=3D911 op=3DUNLOAD
[   95.818982] audit: type=3D1334 audit(1597081691.368:1815): prog-id=3D912=
 op=3DLOAD
[   95.828982] audit: type=3D1334 audit(1597081691.376:1816):
prog-id=3D912 op=3DUNLOAD
[   97.854733] Unexpected kernel BRK exception at EL1
[   97.861235] Internal error: ptrace BRK handler: f2000100 [#1] PREEMPT SM=
P
[   97.870587] Modules linked in: rfkill tda998x cec drm_kms_helper
drm crct10dif_ce fuse
[   97.881295] CPU: 2 PID: 740 Comm: test_verifier Tainted: G        W
        5.8.1-rc1 #1
[   97.892171] Hardware name: ARM Juno development board (r2) (DT)
[   97.900877] pstate: 20000005 (nzCv daif -PAN -UAO BTYPE=3D--)
[   97.909235] pc : 0xffff8000000129b8
[   97.915501] lr : bpf_prog_d53bb52e3f4483f9_F+0x38/0x8d0
[   97.923507] sp : ffff80001472bb00
[   97.929601] x29: ffff80001472bb30 x28: ffff80001472bcd8
[   97.937696] x27: 0000000000000001 x26: 0000000000000000
[   97.945790] x25: ffff80001472bb00 x24: ffff8000135c3038
[   97.953885] x23: ffff80001472bce0 x22: ffff80001472bc58
[   97.961981] x21: ffff8000135c3038 x20: ffff80001472bce0
[   97.970076] x19: ffff800000030730 x18: 0000000000000000
[   97.978171] x17: 0000000000000000 x16: 0000000000000000
[   97.986266] x15: 0000000000000000 x14: 0000000000000000
[   97.994361] x13: 0000000000000000 x12: 0000000000000000
[   98.002455] x11: 0000000000000001 x10: ffff800000032998
[   98.010551] x9 : ffff800013134000 x8 : 00000000430ad605
[   98.018646] x7 : ffff800012654000 x6 : 000000024ead2ef5
[   98.026741] x5 : 00ffffffffffffff x4 : 001a3a31531529a9
[   98.034836] x3 : 0000000000000000 x2 : ffff800000030730
[   98.042931] x1 : 000000000000000a x0 : 0000000000000009
[   98.051027] Call trace:
[   98.056252]  0xffff8000000129b8
[   98.062172]  bpf_prog_d53bb52e3f4483f9_F+0x38/0x8d0
[   98.069837]  bpf_dispatcher_xdp_func+0x30/0x40
[   98.077057]  bpf_test_run+0x180/0x570
[  102.671323]  bpf_prog_test_run_xdp+0xf4/0x1b0
[  102.675688]  __do_sys_bpf+0x708/0x1d18
[  102.679442]  __arm64_sys_bpf+0x28/0x38
[  102.683197]  el0_svc_common.constprop.3+0x7c/0x198
[  102.687995]  do_el0_svc+0x34/0xa0
[  102.691315]  el0_sync_handler+0x16c/0x210
[  102.695329]  el0_sync+0x140/0x180
[  102.698651] Code: d4202000 d4202000 d4202000 d4202000 (d4202000)
[  102.704758] ---[ end trace 14c3fdd625b93f51 ]---
[  102.709383] note: test_verifier[740] exited with preempt_count 2
[  102.715399] BUG: sleeping function called from invalid context at
/usr/src/kernel/include/linux/percpu-rwsem.h:49
[  102.725680] in_atomic(): 0, irqs_disabled(): 128, non_block: 0,
pid: 740, name: test_verifier
[  102.734219] INFO: lockdep is turned off.
[  102.738146] irq event stamp: 4369860
[  102.741729] hardirqs last  enabled at (4369859):
[<ffff80001015ab18>] ktime_get+0xc0/0x178
[  102.750010] hardirqs last disabled at (4369860):
[<ffff800010029a04>] debug_exception_enter+0xac/0xe8
[  102.759249] softirqs last  enabled at (4369842):
[<ffff8000102161d4>] bpf_ksym_add+0x12c/0x148
[  102.767878] softirqs last disabled at (4369840):
[<ffff8000102160d4>] bpf_ksym_add+0x2c/0x148
[  102.776419] CPU: 2 PID: 740 Comm: test_verifier Tainted: G      D W
        5.8.1-rc1 #1
[  102.784523] Hardware name: ARM Juno development board (r2) (DT)
[  102.790451] Call trace:
[  102.792900]  dump_backtrace+0x0/0x1f8
[  102.796567]  show_stack+0x2c/0x38
[  102.799889]  dump_stack+0xf0/0x16c
[  102.803296]  ___might_sleep+0x144/0x208
[  102.807137]  __might_sleep+0x54/0x90
[  102.810719]  exit_signals+0x54/0x3e8
[  102.814301]  do_exit+0xc8/0xae0
[  102.817446]  die+0x200/0x268
[  102.820329]  arm64_notify_die+0xa0/0xc0
[  102.824172]  do_debug_exception+0xf0/0x128
[  102.828275]  el1_sync_handler+0x90/0xf0
[  102.832116]  el1_sync+0x7c/0x100
[  102.835347]  0xffff8000000129b8
[  102.838493]  bpf_prog_d53bb52e3f4483f9_F+0x38/0x8d0
[  102.843379]  bpf_dispatcher_xdp_func+0x30/0x40
[  102.847830]  bpf_test_run+0x180/0x570
[  102.851497]  bpf_prog_test_run_xdp+0xf4/0x1b0
[  102.855861]  __do_sys_bpf+0x708/0x1d18
[  102.859615]  __arm64_sys_bpf+0x28/0x38
[  102.863369]  el0_svc_common.constprop.3+0x7c/0x198
[  102.868167]  do_el0_svc+0x34/0xa0
[  102.871486]  el0_sync_handler+0x16c/0x210
[  102.875501]  el0_sync+0x140/0x180
[  102.886823] ------------[ cut here ]------------
[[  102.887376] kauditd_printk_skb: 125 callbacks suppressed
[  102.887387] audit: type=3D1701 audit(1597081698.472:1942):
auid=3D4294967295 uid=3D0 gid=3D0 ses=3D4294967295 pid=3D738 comm=3D\"timeo=
ut\"
exe=3D\"/usr/bin/timeout.coreutils\" sig=3D11 res=3D1
[  102.891463] WARNING: CPU: 2 PID: 0 at
/usr/src/kernel/kernel/rcu/tree.c:618 rcu_eqs_enter.isra.67+0xd8/0xe0
[  102.891467] Modules linked in: rfkill tda998x cec drm_kms_helper
drm crct10dif_ce fuse
[  102.891486] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D W
  5.8.1-rc1 #1
[  102.891490] Hardware name: ARM Juno development board (r2) (DT)
[  102.891495] pstate: 200003c5 (nzCv DAIF -PAN -UAO BTYPE=3D--)
[  102.891501] pc : rcu_eqs_enter.isra.67+0xd8/0xe0
[  102.891511] lr : rcu_eqs_enter.isra.67+0x10/0xe0
[  102.957881] sp : ffff800013683f20
[  102.961198] x29: ffff800013683f20 x28: 0000000000000000
[  102.966519] x27: 0000000000000000 x26: ffff000973033800
[  102.971840] x25: ffff00097ef5fc80 x24: ffff800012651410
[  102.977162] x23: ffff800011f00c78 x22: ffff800012650000
[  102.982483] x21: ffff800012651000 x20: ffff800011f02000
[  102.987803] x19: ffff00097ef61ec0 x18: ffffffffffffffff
[  102.993124] x17: 0000000000000000 x16: 0000000000000000
[  102.998444] x15: 000000000000006c x14: 000000000000002a
[  103.003765] x13: 0000000000000002 x12: 0000000000000000
[  103.009086] x11: 0000000000000000 x10: ffff80001264b1c8
[  103.014406] x9 : 0000000000000000 x8 : ffff800012650a88
[  103.019727] x7 : ffff80001016d09c x6 : 0000000000000000
[  103.025048] x5 : 0000000000000000 x4 : 0000000000000000
[  103.030368] x3 : ffff800012650a88 x2 : 00000017f0129f00
[  103.035689] x1 : 4000000000000002 x0 : 4000000000000000
[  103.041011] Call trace:
[  103.043461]  rcu_eqs_enter.isra.67+0xd8/0xe0
[  103.047739]  rcu_idle_enter+0x44/0x70
[  103.051406]  do_idle+0x214/0x2c0
[  103.054637]  cpu_startup_entry+0x2c/0x70
[  103.058567]  secondary_start_kernel+0x1a8/0x200
[  103.063103] irq event stamp: 449856
[  103.066599] hardirqs last  enabled at (449855):
[<ffff80001016d1ec>] tick_nohz_idle_exit+0x64/0xd0
[  103.075574] hardirqs last disabled at (449856):
[<ffff800011329c08>] __schedule+0xf0/0x8f0
[  103.083853] softirqs last  enabled at (449814):
[<ffff8000100019bc>] __do_softirq+0x59c/0x5dc
[  103.092396] softirqs last disabled at (449803):
[<ffff80001008fbf4>] irq_exit+0x144/0x150


Full output log:
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/build/v5.8-39-gb3=
0c8c9d4260/testrun/3049360/suite/linux-log-parser/test/check-kernel-excepti=
on-1657446/log

Ran 35329 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* network-basic-tests
* v4l2-compliance
* ltp-containers-tests
* ltp-dio-tests
* ltp-open-posix-tests
* igt-gpu-tools
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite


--=20
Linaro LKFT
https://lkft.linaro.org
