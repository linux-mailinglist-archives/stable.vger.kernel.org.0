Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27106163D5
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 14:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiKBN32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 09:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiKBN31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 09:29:27 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE42C27B2D
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 06:29:25 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id f5so23754291ejc.5
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 06:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=10sZx/9sD6FT7hPA9dac/VkIhxcnmIJ1BXIBAJsrqzg=;
        b=qPXklqJ5RDPLAZX/MLEaB8rLGx22D++CjepgaXPOKDax319v5XH6/kuoQHAhjnUevy
         kha+5sH+J++EUuITHuRvIhtedRiPZ51sSnzU9pqlC4h2G9LydQ1QvX6DRMqfuBdtsidy
         NqbAkkdptBo7oAM8T3QP43Iqm+/EdBzV4PeSzjd+X5UqYThfMigJFvfLc500h4pKJiv2
         06Ni1s4VicQYFTQGBwOhynPpv6uXcfRxbCmJ4gZ5Lrbzu5uHEi+A0+0mxO4sacbw5vT9
         1zAKFwbxlCHz+kGoAqL23bfbtzW1xuOfqowaPPQwt3+ipnrwfYDCVVtjzRiIM7u+oVNz
         Ne2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=10sZx/9sD6FT7hPA9dac/VkIhxcnmIJ1BXIBAJsrqzg=;
        b=0P9KUpe2IVCU3t9DfKQVPA80wNyC2Z8hipoySvT9Mya6qrZL+FSWpUtS1RHT7lOGC3
         Mn/BeEorNrOACAeLhGHiDnf76JhFFhE/vMcy8P40UcJUl+RqLg6TVt5GELZ6CczkDHMW
         75pos+BJZ9AC9bckagDmTooup8l84UVZYjlzUJNCGzWQ71rMTczigVITLgN58ra0h9Lx
         uyQnZI0x3Ewxkr22ctAByGiJfl27gqIMzrFFWeFBPJjEXWZhZhqFMv6LnMlw/POcDSbY
         PVlndvnf1S7uJOfZhcQr6XYDZkfadafszW5zKJMyCsjWwTb+V+YfCydL+dF3wYxZHah6
         Ak3Q==
X-Gm-Message-State: ACrzQf28EKbaQtvRHtLZLkkSDX/ME01HXWs1ES+U+h0VJOjktJ0TyADW
        1TavqON4CvJhnlWOrY09q2mLnK6isSEni2BQOgrBwzwR5fUOwA==
X-Google-Smtp-Source: AMsMyM5Fa9GIXaQ/xo/3L5itYv0iIl0Kn45kxztdQZUw9sQNOdSEc6le41/zqcC7+M8pEiSuAPY0JdbohGFmvWW12kI=
X-Received: by 2002:a17:907:7b93:b0:770:1d4f:4de9 with SMTP id
 ne19-20020a1709077b9300b007701d4f4de9mr24285358ejc.201.1667395762037; Wed, 02
 Nov 2022 06:29:22 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Nov 2022 18:59:10 +0530
Message-ID: <CA+G9fYtYTOyY4tvWU54Zvtew5g7fpWR8rP1XY1aSxTD855cDww@mail.gmail.com>
Subject: arm32: kselftest: zram: Unable to handle kernel NULL pointer
 dereference at virtual address 00000144
To:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah@kernel.org>, lkft-triage@lists.linaro.org,
        Zhang Zhen <zhenzhang.zhang@huawei.com>,
        Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>,
        Fabian Frederick <fabf@skynet.be>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
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

While running kselftest zram test case on x15 device and qemu-arm on
stable-rc 6.0.7-rc1 the following kernel crash noticed the image was
built with gcc-10.

This is not regression because it has been happening on mainline and next.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

# selftests: zram: zram.sh
# --------------------
# running zram tests
# --------------------
# create '1' zram device(s)
[  677.430297] zram: Added device: zram0
# all zram devices (/dev/zram0~0) successfully created
# set max_comp_streams to zram device(s)
# The device attribute max_comp_streams was[  677.485321] zram0:
detected capacity change from 0 to 4096
 deprecated in 4.7
# test that we can set compression algorithm
# supported algs: lzo [lzo-rle] lz4 lz4hc 842 zstd
# /sys/block/zram0/comp_algorithm = 'lzo'
# zram set compression algorithm: OK
# set disk size to zram device(s)
# /sys/block/zram0/disksize = '2097152'
# zram set disksizes: OK
# set memory limit to zram device(s)
# /sys/block/zram0/mem_limit = '2M'
# zram set memory limit: OK
# make ext4 filesystem on /dev/zram0
[  677.550018] 8<--- cut here ---
[  677.553100] Unable to handle kernel NULL pointer dereference at
virtual address 00000144
[  677.561218] [00000144] *pgd=fb0e8835
[  677.564819] Internal error: Oops: 17 [#1] SMP ARM
[  677.569549] Modules linked in: zram zsmalloc cfg80211 bluetooth
snd_soc_simple_card snd_soc_simple_card_utils etnaviv gpu_sched
onboard_usb_hub snd_soc_davinci_mcasp snd_soc_ti_udma snd_soc_ti_edma
snd_soc_ti_sdma snd_soc_core ac97_bus snd_pcm_dmaengine snd_pcm
snd_timer snd soundcore display_connector fuse [last unloaded:
test_user_copy]
[  677.599761] CPU: 1 PID: 2249 Comm: mkfs.ext4 Not tainted 6.0.7-rc1 #1
[  677.606231] Hardware name: Generic DRA74X (Flattened Device Tree)
[  677.612365] PC is at strcmp+0x4/0x34
[  677.615966] LR is at register_lock_class+0x420/0x990
[  677.620971] pc : [<c09ae910>]    lr : [<c03d288c>]    psr: a0070093
[  677.627258] sp : f120da60  ip : 00000001  fp : c2240768
[  677.632507] r10: 00000000  r9 : eeb10334  r8 : c33cedc0
[  677.637756] r7 : eeb22334  r6 : c2b242e8  r5 : 00000144  r4 : c2976cd8
[  677.644317] r3 : 00000028  r2 : c2240c1c  r1 : 00000144  r0 : c1cfa56d
[  677.650878] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment none
[  677.658142] Control: 10c5387d  Table: 89b9c06a  DAC: 00000051
[  677.663909] Register r0 information: non-slab/vmalloc memory
[  677.669586] Register r1 information: non-paged memory
[  677.674682] Register r2 information: non-slab/vmalloc memory
[  677.680358] Register r3 information: non-paged memory
[  677.685455] Register r4 information: non-slab/vmalloc memory
[  677.691131] Register r5 information: non-paged memory
[  677.696197] Register r6 information: non-slab/vmalloc memory
[  677.701904] Register r7 information: non-slab/vmalloc memory
[  677.707580] Register r8 information: slab task_struct start
c33ced80 data offset 64 pointer offset 0 allocated at
copy_process+0x1a4/0x1950
[  677.720184]     kmem_cache_alloc+0x328/0x43c
[  677.724487]     copy_process+0x1a4/0x1950
[  677.728515]     kernel_clone+0x5c/0x418
[  677.732360]     sys_clone+0x74/0x90
[  677.735870]     ret_fast_syscall+0x0/0x1c
[  677.739898]  Free path:
[  677.742370]     rcu_core+0x3c8/0x1140
[  677.746063]     __do_softirq+0x130/0x538
[  677.749999] Register r9 information: non-slab/vmalloc memory
[  677.755676] Register r10 information: NULL pointer
[  677.760498] Register r11 information: non-slab/vmalloc memory
[  677.766265] Register r12 information: non-paged memory
[  677.771453] Process mkfs.ext4 (pid: 2249, stack limit = 0xf120c000)
[  677.777740] Stack: (0xf120da60 to 0xf120e000)
...
[  678.151947]  strcmp from register_lock_class+0x420/0x990
[  678.157287]  register_lock_class from __lock_acquire+0x68/0x2a98
[  678.163330]  __lock_acquire from lock_acquire+0x110/0x364
[  678.168762]  lock_acquire from zs_map_object+0x114/0x338 [zsmalloc]
[  678.175079]  zs_map_object [zsmalloc] from zram_bvec_rw+0x284/0xb1c [zram]
[  678.182006]  zram_bvec_rw [zram] from zram_submit_bio+0x1a0/0x3fc [zram]
[  678.188751]  zram_submit_bio [zram] from __submit_bio+0x50/0x80
[  678.194702]  __submit_bio from submit_bio_noacct_nocheck+0xb8/0x218
[  678.201019]  submit_bio_noacct_nocheck from submit_bh_wbc+0x150/0x180
[  678.207489]  submit_bh_wbc from __block_write_full_page+0x504/0x6ac
[  678.213806]  __block_write_full_page from block_write_full_page+0x148/0x18c
[  678.220794]  block_write_full_page from __writepage+0x1c/0x74
[  678.226562]  __writepage from write_cache_pages+0x1b4/0x4f4
[  678.232177]  write_cache_pages from generic_writepages+0x58/0x84
[  678.238220]  generic_writepages from do_writepages+0x7c/0x1b8
[  678.243988]  do_writepages from filemap_fdatawrite_wbc+0x6c/0x8c
[  678.250030]  filemap_fdatawrite_wbc from file_write_and_wait_range+0x90/0xec
[  678.257141]  file_write_and_wait_range from blkdev_fsync+0x20/0x44
[  678.263336]  blkdev_fsync from do_fsync+0x44/0x78
[  678.268066]  do_fsync from ret_fast_syscall+0x0/0x1c
[  678.273071] Exception stack(0xf120dfa8 to 0xf120dff0)
[  678.278137] dfa0:                   00038960 b6f615a0 00000005
00042a00 00001000 00000000
[  678.286376] dfc0: 00038960 b6f615a0 00000000 00000076 bebd8818
00000000 bebd8800 bebd8808
[  678.294586] dfe0: 00000076 bebd87b8 b6db8def b6d31ae6
[  678.299652] Code: e3520000 1afffffb e12fff1e e4d03001 (e4d12001)
[  678.305786] ---[ end trace 0000000000000000 ]---
[  678.310424] note: mkfs.ext4[2249] exited with preempt_count 3
[  678.316192] ------------[ cut here ]------------
[  678.320831] WARNING: CPU: 1 PID: 2249 at kernel/exit.c:741
do_exit+0x8a8/0xae0
[  678.328094] Modules linked in: zram zsmalloc cfg80211 bluetooth
snd_soc_simple_card snd_soc_simple_card_utils etnaviv gpu_sched
onboard_usb_hub snd_soc_davinci_mcasp snd_soc_ti_udma snd_soc_ti_edma
snd_soc_ti_sdma snd_soc_core ac97_bus snd_pcm_dmaengine snd_pcm
snd_timer snd soundcore display_connector fuse [last unloaded:
test_user_copy]
[  678.358306] CPU: 1 PID: 2249 Comm: mkfs.ext4 Tainted: G      D
      6.0.7-rc1 #1
[  678.366271] Hardware name: Generic DRA74X (Flattened Device Tree)
[  678.372406]  unwind_backtrace from show_stack+0x18/0x1c
[  678.377655]  show_stack from dump_stack_lvl+0x58/0x70
[  678.382720]  dump_stack_lvl from __warn+0xd0/0x1f0
[  678.387542]  __warn from warn_slowpath_fmt+0x64/0xbc
[  678.392547]  warn_slowpath_fmt from do_exit+0x8a8/0xae0
[  678.397796]  do_exit from make_task_dead+0x64/0x104
[  678.402709]  make_task_dead from die+0x4c4/0x4e4
[  678.407348]  die from die_kernel_fault+0x6c/0x7c
[  678.412017]  die_kernel_fault from do_translation_fault+0x0/0xbc
[  678.418060] irq event stamp: 10325
[  678.421478] hardirqs last  enabled at (10325): [<c0572914>]
inc_zone_page_state+0x5c/0x64
[  678.429687] hardirqs last disabled at (10324): [<c0572904>]
inc_zone_page_state+0x4c/0x64
[  678.437927] softirqs last  enabled at (8038): [<c0301fe0>]
__do_softirq+0x300/0x538
[  678.445617] softirqs last disabled at (8029): [<c0359ca4>]
__irq_exit_rcu+0x14c/0x170
[  678.453491] ---[ end trace 0000000000000000 ]---

Broadcast message from systemd-journald@am57xx-evm (Thu 2022-04-28
17:53:32 UTC):
kernel[302]: [  677.564819] Internal error: Oops: 17 [#1] SMP ARM

metadata:
  git_ref: linux-6.0.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: 436175d0f780af8302164b3102ecf0ff99f7a376
  git_describe: v6.0.6-241-g436175d0f780
  kernel_version: 6.0.7-rc1
  kernel-config: https://builds.tuxbuild.com/2GyMeKKxOr8QQQbN95Ngll7cpZ8/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/683032123
  artifact-location: https://builds.tuxbuild.com/2GyMeKKxOr8QQQbN95Ngll7cpZ8
  toolchain: gcc-10


[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.6-241-g436175d0f780/testrun/12809079/suite/log-parser-test/test/check-kernel-exception/details/
[2] https://lkft.validation.linaro.org/scheduler/job/5799922#L4146
[3] https://lkft.validation.linaro.org/scheduler/job/5780009#L1853

--
Linaro LKFT
https://lkft.linaro.org
