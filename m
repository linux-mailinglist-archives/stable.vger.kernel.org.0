Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EBE6229C0
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 12:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiKILK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 06:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiKILK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 06:10:27 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E9C22B0C
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 03:10:25 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-333a4a5d495so158778287b3.10
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 03:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lIiD/YktLh6x3KvVRLpjLG0H3sFyEQMXVJ3Yb0g4amA=;
        b=BqghN20BQIeKh0ZkP9QSwssua2FHHrd8CNlK9yzw89YxrGaD2bykZVPPckSumbzR9/
         mBUbfXjF5FwolnMxU4G3TchH0rMxAfC3AdE1LW51upijZ2t+vDkN10iHA2GMzA2XLEDw
         mAtE7cj+hNcr98z6WrPvGlC8QwbPuuPvmSrwhlAr1DskKhkCIYBzD0jpDVmh49Otu30j
         1zob/zpY+kLFgzgyNyxJye0y9VWBTwLScfXm14LCaoXSlrvxi40FKFTeLygNH8ojwJ/E
         A+9A3WFJ1YiYsmEkECllItk0a0s38r7qspolkiuJ32a4bn9dADSIa3w6Nf+c9IZ03qqv
         w+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lIiD/YktLh6x3KvVRLpjLG0H3sFyEQMXVJ3Yb0g4amA=;
        b=IW49ySQ4Qt4EbNk+IN4jwE45XHLsIfG3rLGPX5eJDCdcPDyg+obe6qDqbag5fwr6lc
         KGEdKfhSNQXtYHcdUxV3yNaYlUpuvLalyqeeX5ujg5RqxjfZZB8szhwUsN+/ktPfK78a
         3mYHGSdnJA2nAceETw+68js8W1MOVwQEvtD4z3LLLaBPat5mjwVhPtppbWcDLqzAKIGx
         2+ojWA++PfCRxAnM/3uG6rA4k1Zt6NbRZyJ6j2QylURLExlWYQdRajWoEe+pr4TPauf6
         umjvSwlU6DmBr5HY+Z6t1r6MGF3AwY3I1n/W3uU5foLGSyeon9Gjr7TEeTpucfmT1niR
         3hSw==
X-Gm-Message-State: ACrzQf0i2phD0xs19Yr1BdpTktJicdjZslNcE3bXqUXmKCra6b6ubLt7
        S5NkQcfAMU9Ps61ew5itayrwwE8sXxsQdG6UFako3z3jzebkEQ==
X-Google-Smtp-Source: AMsMyM55b9N0moVYLVs6ggUCroCVB08a9W8wFWHcepHVh40UpaQOmHQQsns2vW0wT7T82l6TV3GPI1NQ8u8doPFXHfc=
X-Received: by 2002:a05:690c:802:b0:36b:adba:8ff with SMTP id
 bx2-20020a05690c080200b0036badba08ffmr54131360ywb.237.1667992224068; Wed, 09
 Nov 2022 03:10:24 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Nov 2022 16:40:13 +0530
Message-ID: <CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com>
Subject: arm: TI BeagleBoard X15 : Unable to handle kernel NULL pointer
 dereference at virtual address 00000369 - Internal error: Oops: 5 [#1] SMP ARM
To:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following kernel oops found while booting arm 32 bit x15 device with
kselftest configs enabled on stable-rc linux-5.15. This is specific
to kselftest merge config build booting on arm TI BeagleBoard X15
device.

This is an intermittent issue and not specific to current stable rc
release.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

[    0.000000] Linux version 5.15.78-rc1 (tuxmake@tuxmake)
(arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld
(GNU Binutils for Debian) 2.35.2) #1 SMP @1667916073
[    0.000000] CPU: ARMv7 Processor [412fc0f2] revision 2 (ARMv7), cr=10c5387d
...
[    5.375946] 8<--- cut here ---
[    5.379089] Unable to handle kernel NULL pointer dereference at
virtual address 00000369
[    5.387237] pgd = (ptrval)
[    5.389953] [00000369] *pgd=00000000
[    5.393585] Internal error: Oops: 5 [#1] SMP ARM
[    5.398223] Modules linked in:
[    5.401306] CPU: 0 PID: 8 Comm: kworker/0:0H Not tainted 5.15.78-rc1 #1
[    5.407958] Hardware name: Generic DRA74X (Flattened Device Tree)
[    5.414093] PC is at do_page_fault+0x94/0x464
[    5.418487] LR is at do_translation_fault+0xc0/0xc4
[    5.423400] pc : [<c15cdbb0>]    lr : [<c15ce040>]    psr: 20000193
[    5.429687] sp : c31ce020  ip : ffffe000  fp : c31ce06c
[    5.434936] r10: 00003b9a  r9 : c31ce000  r8 : 00000000
[    5.440216] r7 : c2110e10  r6 : 00000665  r5 : 00000005  r4 : c31ce0c8
[    5.446777] r3 : c31ce000  r2 : 00000001  r1 : 2ca6c000  r0 : 00000665
[    5.453338] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment none
[    5.460601] Control: 10c5387d  Table: 8020406a  DAC: 00000051
[    5.466369] Register r0 information: non-paged memory
[    5.471466] Register r1 information: non-paged memory
[    5.476531] Register r2 information: non-paged memory
[    5.481628] Register r3 information: non-slab/vmalloc memory
[    5.487335] Register r4 information: non-slab/vmalloc memory
[    5.493011] Register r5 information: non-paged memory
[    5.498107] Register r6 information: non-paged memory
[    5.503204] Register r7 information: non-slab/vmalloc memory
[    5.508880] Register r8 information: NULL pointer
[    5.513610] Register r9 information: non-slab/vmalloc memory
[    5.519317] Register r10 information: non-paged memory
[    5.524475] Register r11 information: non-slab/vmalloc memory
[    5.530273] Register r12 information: non-paged memory
[    5.535430] Process kworker/0:0H (pid: 8, stack limit = 0x(ptrval))
[    5.541748] Stack: (0xc31ce020 to 0xc31ce000)
[    5.546142] Backtrace:
...
[    7.896820] Code: e5942040 e3c3303f e3120080 e5932008 (e5927368)
[    7.902954] ---[ end trace 86f7fd8d70b6f6f9 ]---
[    7.907592] note: kworker/0:0H[8] exited with preempt_count 2
[    7.913360] ------------[ cut here ]------------
[    7.917999] WARNING: CPU: 0 PID: 8 at kernel/sched/core.c:9542
__might_sleep+0xa8/0xac
[    7.925994] do not call blocking ops when !TASK_RUNNING; state=402
set at [<(ptrval)>] worker_thread+0xb8/0x554
[    7.936126] Modules linked in:
[    7.939208] CPU: 0 PID: 8 Comm: kworker/0:0H Tainted: G      D
     5.15.78-rc1 #1
[    7.947265] Hardware name: Generic DRA74X (Flattened Device Tree)
[    7.953399] Backtrace:
...
[   28.471862] Code: bad PC value
[   28.474945] ---[ end trace 86f7fd8d70b6f700 ]---
[   28.479614] Fixing recursive fault but reboot is needed!

Test log link,
  https://lkft.validation.linaro.org/scheduler/job/5826464#L2710
  https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.77-145-gf98185b81e48/testrun/12907651/suite/log-parser-test/test/check-kernel-oops/log
  https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.77-145-gf98185b81e48/testrun/12907651/suite/log-parser-test/tests/

metadata:
  git_ref: linux-5.15.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: f98185b81e483128439a76d6e64217b606c09bed
  git_describe: v5.15.77-145-gf98185b81e48
  kernel_version: 5.15.78-rc1
  kernel-config: https://builds.tuxbuild.com/2HGeIzgM9yCQbFVPZR0ItTY7Nt4/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/688777444
  artifact-location: https://builds.tuxbuild.com/2HGeIzgM9yCQbFVPZR0ItTY7Nt4
  toolchain: gcc-10
  build_name: gcc-10-lkftconfig-kselftest-kernel

--
Linaro LKFT
https://lkft.linaro.org
