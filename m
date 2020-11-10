Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F122AD093
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 08:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgKJHla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 02:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgKJHl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 02:41:29 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0F0C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 23:41:27 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id oq3so16059783ejb.7
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 23:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+A/E+HuPe8v8u2I+5nMtlhsi5h/+K+qNfUiEOaq1bTk=;
        b=lDUDdRM2q5FQtDdjFccn5estlbFnIjXGztAxp+jUmqZa2wyTCM+MxKYmy83RbFkNSI
         l4jLQOBUtEmB9/vxYHCCw6AtfbBtdxCsCLLqTOAJQwK3Flh98dbXcEKr31AY7MnB3ucB
         PQhB1cx9fOCKIwh+dAczhL0neA/e+5Jvy9AoZs4fu/W6smABo6ikUT1ARllmOAIAT7BL
         rhZ2UnAW+072TKVdoUaQGDRSVzFf3DzA1mRkcZifvaIPcvaCEG0W45flQ5SlizD3RcdE
         k3lTIjLNSCYlA90teJA0xkLL+LIcs2Y1N2vWFN5STW5/rgAN6eQkogiupdBxeKmLZoh5
         2MHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+A/E+HuPe8v8u2I+5nMtlhsi5h/+K+qNfUiEOaq1bTk=;
        b=Tb5kE5g80Jk6D4x8ICsjHu3czQeTObjBjAEC0DRzbyXWwsvhHvjspLo3msKmMgOTws
         hpOJgaHqSVEpLdfr8KQ12sSTwe34IKhy1YeElfLWoV0tHHSpH95eflH+dLLtlQIq48Om
         QpJcN9LDJ3750JT9saY8Fo87NKu5sAMEVgkexPlvQ59xYBOI5eHjvafDhdLsD6sOc/+h
         MJHmACEOnnA0twnt08yDWrz9z4oslgkG4teN4Q6OiL462zMKYkba8VmfDp58srIr8fCw
         WmdPFiYthlJlXMiG/kSnbHZsuo+l3gZcNOdI9GjapooQITIJy8d3pBMB95qa+NI5T0ex
         cLXw==
X-Gm-Message-State: AOAM5310bmBuZt4xHdikdJG+4GDzdfeVJTCu+OH1Y2hIl9mdk2ZA3sq7
        JgOeA81oj8gEwOanjlHsUNtsm4aYhbQz0HZ7b3AXtg==
X-Google-Smtp-Source: ABdhPJxDLllAmYwP42N/vmNhFsCbl5VuuE4DFUVNZoDQxhQLzlWKKq7QZr79p5EoITlaqKYN144sMUbYsl13mDoI+rk=
X-Received: by 2002:a17:906:4742:: with SMTP id j2mr18476362ejs.247.1604994086125;
 Mon, 09 Nov 2020 23:41:26 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Nov 2020 13:11:14 +0530
Message-ID: <CA+G9fYu+KK=hm1AmQ78GCCgQTwsRCzyA6WHYR68ozZBzp7USiA@mail.gmail.com>
Subject: WARNING: CPU: 2 at kernel/workqueue.c:4762 workqueue_online_cpu
To:     open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Tejun Heo <tj@kernel.org>,
        jiangshanlai@gmail.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running CPU hotplug testing on arm64 db410c device the following
kernel warning
noticed on linux stable-rc 4.19 branch. I did not bisect this problem yet.

Kernel Warning log:
------------------------------
[  290.463053] CPU1: shutdown
[  290.463107] psci: CPU1 killed (polled 0 ms)
[  290.527026] CPU2: shutdown
[  290.527072] psci: CPU2 killed (polled 0 ms)
[  290.579064] CPU3: shutdown
[  290.579098] psci: CPU3 killed (polled 0 ms)
[  290.612295] Detected VIPT I-cache on CPU1
[  290.612361] CPU1: Booted secondary processor 0x0000000001 [0x410fd030]
[  290.684091] Detected VIPT I-cache on CPU2
[  290.684158] CPU2: Booted secondary processor 0x0000000002 [0x410fd030]
[  290.684464] WARNING: CPU: 2 PID: 20 at
/usr/src/kernel/kernel/workqueue.c:4762
workqueue_online_cpu+0x18c/0x428
[  290.697731] Modules linked in: sch_ingress algif_hash test_bpf
snd_soc_hdmi_codec crc32_ce adv7511 cec rfkill msm
snd_soc_msm8916_analog snd_soc_lpass_apq8016 mdt_loader
snd_soc_lpass_cpu snd_soc_msm8916_digital snd_soc_apq8016_sbc
drm_kms_helper snd_soc_lpass_platform drm drm_panel_orientation_quirks
fuse [last unloaded: test_bpf]
[  290.714992] CPU: 2 PID: 20 Comm: cpuhp/2 Tainted: G      D
 4.19.156-rc1 #1
[  290.737221] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[  290.745033] pstate: 40000005 (nZcv daif -PAN -UAO)
[  290.751718] pc : workqueue_online_cpu+0x18c/0x428
[  290.756316] lr : workqueue_online_cpu+0x140/0x428
[  290.761086] sp : ffff00000a90bc90
[  290.765774] x29: ffff00000a90bc90 x28: ffff00000989bfc8
[  290.769074] x27: ffff80003ac81a00 x26: ffff000009914a00
[  290.774456] x25: ffff00000989c068 x24: ffff00000a90bd24
[  290.779752] x23: 0000000000000002 x22: ffff80003fe7a4d0
[  290.785047] x21: ffff000009914000 x20: ffff00000989bf68
[  290.790341] x19: ffff80003fe7a1c0 x18: ffffffffffffffff
[  290.795636] x17: 0000000000000000 x16: 0000000000000000
[  290.800932] x15: ffff00000987fa48 x14: ffff00000a69c530
[  290.806227] x13: 0000000000000040 x12: 0000000000000228
[  290.811522] x11: 0000000000000000 x10: ffff00000987fa48
[  290.816816] x9 : ffff000009914000 x8 : ffff00000987fa48
[  290.822112] x7 : ffff00000812d338 x6 : 0000000000000000
[  290.827407] x5 : 0000000000000000 x4 : ffff80003c59ad00
[  290.832702] x3 : ffff000009880000 x2 : 8b427f82388e4a00
[  290.837997] x1 : 0000000000000000 x0 : 00000000ffffffea
[  290.843293] Call trace:
[  290.848588]  workqueue_online_cpu+0x18c/0x428
[  290.850762]  cpuhp_invoke_callback+0xe8/0xd18
[  290.855274]  cpuhp_thread_fun+0x1a8/0x250
[  290.859613]  smpboot_thread_fn+0x1c4/0x2d0
[  290.863606]  kthread+0x150/0x168
[  290.867600]  ret_from_fork+0x10/0x1c
[  290.870983] irq event stamp: 158
[  290.874546] hardirqs last  enabled at (157): [<ffff000009001784>]
_raw_spin_unlock_irqrestore+0x74/0xb0
[  290.877765] hardirqs last disabled at (158): [<ffff000008ffa1e0>]
__schedule+0xc0/0xbc0
[  290.886878] softirqs last  enabled at (0): [<ffff0000080efac8>]
copy_process.isra.5.part.6+0x490/0x1b20
[  290.894861] softirqs last disabled at (0): [<0000000000000000>]
      (null)
[  290.904233] ---[ end trace 7a9cb6558129244f ]---

steps to reproduce:
----------------------------------
Total number of CPU[0-3]
offline each CPU 1, 2 and 3
online each CPU 1, 2 and 3

          echo 0 > /sys/devices/system/cpu/cpu1/online
          echo 0 > /sys/devices/system/cpu/cpu2/online
          echo 0 > /sys/devices/system/cpu/cpu3/online
          echo 1 > /sys/devices/system/cpu/cpu1/online
          echo 1 > /sys/devices/system/cpu/cpu2/online
          echo 1 > /sys/devices/system/cpu/cpu3/online

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

metadata:
  git branch: linux-4.19.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git describe: v4.19.155-72-g4d10cdd4ac50
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/dragonboard-410c/lkft/linux-stable-rc-4.19/666/config

ref:
https://lkft.validation.linaro.org/scheduler/job/1927553#L3876
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.155-72-g4d10cdd4ac50/testrun/3416766/suite/linux-log-parser/test/check-kernel-warning-1925672/log

-- 
Linaro LKFT
https://lkft.linaro.org
