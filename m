Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B77C62926F
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 08:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiKOH2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 02:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiKOH2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 02:28:10 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A18205FB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 23:28:06 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id j2so16217016ybb.6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 23:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t2MSqieIloRSX5j4XySxPNiECkBoHXA8aafgFPvChpc=;
        b=QgfBWx5jr+T9D0OPatz9aPNvycrIr4iLDGczMIzC44uZC9r3WFasL9kXz9bxT2FW/x
         glqG1PaWw4xvuOrV67TlUP7yxQQloJzA5Nr3tRkrKnPpJCIc+coc18Cb5PhjpivrwkGg
         8b+QBJu5yLEI9vWBdYYizjJqj8S+VftW/cgxTvZ1ef9mo5HH75/d6Jg3qOQvpy18ka0Q
         y8GrQUcOykvgOiJhC94mg2ZxY6M5NaTQ6QQsxQcYUmgb6JwNjI+mo5lQ/mVik6dgg4wG
         mCkOn+WDOFXogwYbNEDgriUju/CHlBrUvJ5r+WKPp+1BbyvCXBoi2OE1E5DCvpqBtLnh
         N5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t2MSqieIloRSX5j4XySxPNiECkBoHXA8aafgFPvChpc=;
        b=NlnGRG9Ww9toSuJYirxIp/Q+X1qoW83mqD5xdsWO7VpJXc7gXCknOxDJw3IhzRb5OO
         jAr2JpugooH1bu60EKS96Xww+Yich7xgPUu1mIhNZ5NLn5kT4nQNUyhJsvyQ1bomFq/N
         kOP2eq722AR32zOIddCka1W6RuTiPjtB+4ekGQixaMb2BBgm7oa20UeCvuIEXKdzt8u1
         tEhMU0Jx35+vw1I9J7wJlmOH0N4/OrCIUqHngqg8oM8cWZW7HLz7J/6c0pawzOaOAqHk
         HtbCiWKyFs7JNqY+WJKQuninsYaDVKTpGjXqyfCCZ/Z0ALHcgD16HRC8Zxn/rIfXOH1U
         FBhA==
X-Gm-Message-State: ANoB5pkWApQpTEZnLxMAh9tSkT/j277A5sM/bS5On9x0fA5ePMahOhIK
        zM4sYdgxJlwPWLSaM8NZeAVJ3H/JRCHAtJpopiCO0A==
X-Google-Smtp-Source: AA0mqf6WThw8/wCMg/frn8fJbsp9aqZO/VwChiLVnMcfDNy/uDXXgreCDrwyobhbVXklWp54j9nYJImA/KC+mML6N7Y=
X-Received: by 2002:a25:2358:0:b0:6d2:5835:301f with SMTP id
 j85-20020a252358000000b006d25835301fmr15945622ybj.336.1668497285091; Mon, 14
 Nov 2022 23:28:05 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Nov 2022 12:57:53 +0530
Message-ID: <CA+G9fYuXG7Rh_A8W1NRVWbgWjozwzxzQY7tYw7bA4NsCuSovMg@mail.gmail.com>
Subject: WARNING: CPU: 0 PID: 1111 at arch/arm64/kernel/fpsimd.c:464 fpsimd_save+0x170/0x1b0
To:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following kernel warning noticed while running kselftest arm64 sve-ptrace
on qemu-arm64 on ampere-altra server.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

 /usr/bin/qemu-system-aarch64 -cpu max,pauth-impdef=on \
 -machine virt-2.10 \
 -nographic \
 -net nic,model=virtio,macaddr=BA:DD:AD:FC:09:12 \
 -net tap -m 4096 -monitor none \
 -kernel Image.gz --append "console=ttyAMA0 root=/dev/vda rw"
 -hda lkft-kselftest-image-juno-20221114150409.rootfs.ext4
 -smp 4 -nographic

Boot log:
---------
[    0.000000] Linux version 6.0.9-rc1 (tuxmake@tuxmake)
(aarch64-linux-gnu-gcc (Debian 11.3.0-6) 11.3.0, GNU ld (GNU Binutils
for Debian) 2.39) #1 SMP PREEMPT @1668438377
[    0.000000] random: crng init done
[    0.000000] Machine model: linux,dummy-virt


# selftests: arm64: sve-ptrace
# ok 680 # SKIP SVE set FPSIMD get SVE for VL 2704
# ok 681 Set SVE VL 2720

[  422.607034] ------------[ cut here ]------------
[  422.615382] WARNING: CPU: 0 PID: 1111 at
arch/arm64/kernel/fpsimd.c:464 fpsimd_save+0x170/0x1b0
[  422.617588] Modules linked in: cfg80211 bluetooth rfkill
crct10dif_ce sm3_ce sm3 sha3_ce sha512_ce sha512_arm64 fuse drm
[  422.619758] CPU: 0 PID: 1111 Comm: sve-ptrace Not tainted 6.0.9-rc1 #1
[  422.620402] Hardware name: linux,dummy-virt (DT)
[  422.620958] pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  422.621614] pc : fpsimd_save+0x170/0x1b0
[  422.621988] lr : fpsimd_save+0xd8/0x1b0
[  422.622307] sp : ffff800008f3bb00
[  422.622612] x29: ffff800008f3bb00 x28: ffffae14dd664bc0 x27: 0000000000000001
[  422.623519] x26: ffff0000ff773858 x25: 0000000000000000 x24: ffff0000c0994fa8
[  422.624102] x23: 0000000000000001 x22: 0000000000000100 x21: ffff0000ff75f0b0
[  422.624706] x20: ffff51ec22a8b000 x19: ffffae14dccd40b0 x18: 0000000000000000
[  422.625292] x17: ffff51ec22a8b000 x16: 0000000000000000 x15: 0000000000000000
[  422.626041] x14: 0000000000000003 x13: 0000000000000000 x12: 0000000000000002
[  422.626647] x11: ffffae14ddbee840 x10: 0000000000000312 x9 : ffffae14da818210
[  422.627326] x8 : ffff0000c09935c0 x7 : ffffae14de2b8d08 x6 : 0000000000000000
[  422.627889] x5 : 000000c91075a4a8 x4 : 0000000000000000 x3 : 0000000000000001
[  422.628487] x2 : ffff51ec22a8b000 x1 : 0000000000000204 x0 : 0000000000000010
[  422.629203] Call trace:
[  422.629579]  fpsimd_save+0x170/0x1b0
[  422.630014]  fpsimd_thread_switch+0x2c/0xc4
[  422.630431]  __switch_to+0x20/0x160
[  422.630745]  __schedule+0x380/0xb90
[  422.631038]  preempt_schedule_irq+0x4c/0x130
[  422.631386]  el1_interrupt+0x4c/0x64
[  422.631689]  el1h_64_irq_handler+0x18/0x24
[  422.632037]  el1h_64_irq+0x64/0x68
[  422.632335]  do_page_fault+0x31c/0x4d0
[  422.632660]  do_translation_fault+0xd8/0x100
[  422.632993]  do_mem_abort+0x58/0xb0
[  422.633311]  el0_ia+0x8c/0x134
[  422.633685]  el0t_64_sync_handler+0x134/0x140
[  422.634061]  el0t_64_sync+0x18c/0x190
[  422.634580] irq event stamp: 654
[  422.634923] hardirqs last  enabled at (653): [<ffffae14dbeafc94>]
exit_to_kernel_mode+0x34/0x130
[  422.635713] hardirqs last disabled at (654): [<ffffae14dbeb7700>]
__schedule+0x3f0/0xb90
[  422.636309] softirqs last  enabled at (650): [<ffffae14da810be4>]
__do_softirq+0x514/0x62c
[  422.636877] softirqs last disabled at (637): [<ffffae14da8b4f58>]
__irq_exit_rcu+0x164/0x19c
[  422.637446] ---[ end trace 0000000000000000 ]---

Full test log:
https://lkft.validation.linaro.org/scheduler/job/5847349#L2206
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.8-191-gf8896c3ebbcf/testrun/13007451/suite/log-parser-test/test/check-kernel-exception/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.8-191-gf8896c3ebbcf/testrun/13007451/suite/log-parser-test/test/check-kernel-exception/details/

metadata:
  git_ref: linux-6.0.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: f8896c3ebbcfcc053d9c27413bea3af94c01fd71
  git_describe: v6.0.8-191-gf8896c3ebbcf
  kernel_version: 6.0.9-rc1
  kernel-config: https://builds.tuxbuild.com/2HXisCgbMlQAU85bS1QC4TvzydK/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/694074125
  artifact-location: https://builds.tuxbuild.com/2HXisCgbMlQAU85bS1QC4TvzydK
  toolchain: gcc-11


--
Linaro LKFT
https://lkft.linaro.org
