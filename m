Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B8C242CF3
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 18:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHLQNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 12:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgHLQNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 12:13:47 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DB7C061384
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 09:13:47 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id z3so2292780ilh.3
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 09:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=0fcXqD2e34mStbQ4CipvkyFSKSgujQkePayCmGVTsYA=;
        b=jX4xwt2NazB3xdglZvsd7yJE4rvlRubB9PqFRGEFcHCkRdOlafxc8n+7RN7FJA267O
         4P16d6Rng63lnN9DUiOzyGiMtxag2hsdBHMhC8Qfft0xZxqwIDALcqijUPOf3ZZgcagB
         CLOSc7e71StV/VTTHFQ6OP6OKyl6gImAunoP+95djfwVwZRxMkSPzCWca4SwKkcjHJI1
         J42hfVUHh4wrqJsCwuArt7FVtc5ekjkTaaW4cMJ7bLNlD0Zt5n8ysznAVhuPONhn25H3
         xCCoUdxzuYpW0kndezmMg0ny9OhrR/4XZZENgWWZDC0f9OH6RMefjPmLihOa4DdAWVn2
         GGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=0fcXqD2e34mStbQ4CipvkyFSKSgujQkePayCmGVTsYA=;
        b=L3DCLOBGk4+Lq3NlOdnHcAqmMW4BzhotRrJ1nqh4jzK6fNk4DV//ppvzeeWVbH0Yud
         uJt+iK2QThTqZwlrI52Ll7VXiwZ63MKd7SfEY3WxXMV0hXbBVW0R/QqOEwTPpHHs2MqD
         C6FaZiAAyRiYptCNEWhIUTaC5JgtMWDB3FdtaBdSLjoRAEYV9IRTVX4o9gpWiqvkPAUn
         7tjwQtKXFT419ePNeaL6EKBj4FE0Qtn00XcYQKTEbE1KNt3qfSDp1iAm6fQId92ypHZ0
         7gHGvviW4QFywG3KUw8vI5PJBinUEWZqC/EMQWvcH7btyiSNJsWRNbdY9heuW2Q10iFh
         MhHg==
X-Gm-Message-State: AOAM531H1VcB6YQH5f8qeLsZrr5L0fLek+0yxO9XJUd32tbNXnX25xO1
        oXhi6LVdNd6a79/v0GU4GgXlYb+LX6+0mBAYn83wbqhjvEcBNg==
X-Google-Smtp-Source: ABdhPJxFsLQY3ilpN0t3+zQDC5Lib0LVhD9tzLGh9M1Zfcv0WeuqBIixLNix1ke7CkgyTf3dL3NwVlUXmRru0mYayns=
X-Received: by 2002:a92:1805:: with SMTP id 5mr359906ily.127.1597248826154;
 Wed, 12 Aug 2020 09:13:46 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 12 Aug 2020 21:43:35 +0530
Message-ID: <CA+G9fYt9J3tzYjVMq2Z-i8+j3qHTNVX8zwVOJrzRbiJmei7OHw@mail.gmail.com>
Subject: WARNING: kernel/rcu/tree.c:618 rcu_eqs_enter.isra.67+0xd8
To:     open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, rcu@vger.kernel.org,
        linux- stable <stable@vger.kernel.org>
Cc:     srostedt@redhat.com, "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        lkft-triage@lists.linaro.org, Basil Eljuse <Basil.Eljuse@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john.fastabend@gmail.com, jakub@cloudflare.com,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running kselftests bpf test_verifier on arm64 juno-r2 device
the kernel BUG and WARNING noticed.

metadata:
  git branch: linux-5.8.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: b30c8c9d42601af8ebeb3ad42085ff4134a111a0
  git describe: v5.8-39-gb30c8c9d4260
  make_kernelversion: 5.8.1-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.8/3/config

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
[  102.887376] kauditd_printk_skb: 125 callbacks suppressed
[  102.887387] audit: type=1701 audit(1597081698.472:1942):
auid=4294967295 uid=0 gid=0 ses=4294967295 pid=738 comm=\"timeout\"
exe=\"/usr/bin/timeout.coreutils\" sig=11 res=1

[  102.891463] WARNING: CPU: 2 PID: 0 at
/usr/src/kernel/kernel/rcu/tree.c:618 rcu_eqs_enter.isra.67+0xd8/0xe0
[  102.891467] Modules linked in: rfkill tda998x cec drm_kms_helper
drm crct10dif_ce fuse
[  102.891486] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D W
  5.8.1-rc1 #1
[  102.891490] Hardware name: ARM Juno development board (r2) (DT)
[  102.891495] pstate: 200003c5 (nzCv DAIF -PAN -UAO BTYPE=--)
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
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/build/v5.8-39-gb30c8c9d4260/testrun/3049360/suite/linux-log-parser/test/check-kernel-exception-1657446/log

--
Linaro LKFT
https://lkft.linaro.org
