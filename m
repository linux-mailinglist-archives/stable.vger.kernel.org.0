Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC616526422
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380793AbiEMO1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381087AbiEMO0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BCA517FF;
        Fri, 13 May 2022 07:26:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9570AB83065;
        Fri, 13 May 2022 14:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DB5C3411E;
        Fri, 13 May 2022 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451979;
        bh=Wk3ZM/Fctm4QK/WcXo/yj4/akZ4ZzAaOfv1i6rI2YGw=;
        h=From:To:Cc:Subject:Date:From;
        b=2KSEmoLkXPHL4RXQGVgLTmeEXwqUabIyEKGVp4U3NDOCmePDiF7/s4HMzKlzk7HlN
         C+MEF+5fw2lC6kr0lcv21OEAApX7sr3kQ06NmlMqNBfhFxiQPgxSfvnxaUx3xr2f5j
         6x8QGjrgX5rx1RtFxWJf6uW1icHcVFXf8fFJYsgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/15] 4.19.243-rc1 review
Date:   Fri, 13 May 2022 16:23:22 +0200
Message-Id: <20220513142227.897535454@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.243-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.243-rc1
X-KernelTest-Deadline: 2022-05-15T14:22+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.243 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.243-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.243-rc1

ChenXiaoSong <chenxiaosong2@huawei.com>
    VFS: Fix memory leak caused by concurrently mounting fs with subtype

Muchun Song <songmuchun@bytedance.com>
    mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent prealloc proc writes

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free calls

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent read/write and buffer changes

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent hw_params and hw_free calls

Itay Iellin <ieitayie@gmail.com>
    Bluetooth: Fix the creation of hdev->name

Andreas Larsson <andreas@gaisler.com>
    can: grcan: only use the NAPI poll budget for RX

Andreas Larsson <andreas@gaisler.com>
    can: grcan: grcan_probe(): fix broken system id check for errata workaround needs

Nathan Chancellor <nathan@kernel.org>
    nfp: bpf: silence bitwise vs. logical OR warning

Lee Jones <lee.jones@linaro.org>
    drm/amd/display/dc/gpio/gpio_service: Pass around correct dce_{version, environment} types

Lee Jones <lee.jones@linaro.org>
    block: drbd: drbd_nl: Make conversion to 'enum drbd_ret_code' explicit

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: Use address-of operator on section symbols


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/bmips/setup.c                            |   2 +-
 arch/mips/lantiq/prom.c                            |   2 +-
 arch/mips/pic32/pic32mzda/init.c                   |   2 +-
 arch/mips/ralink/of.c                              |   2 +-
 drivers/block/drbd/drbd_nl.c                       |  13 ++-
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c |  12 +--
 .../amd/display/include/gpio_service_interface.h   |   4 +-
 drivers/net/can/grcan.c                            |  38 ++++---
 drivers/net/ethernet/netronome/nfp/nfp_asm.c       |   4 +-
 fs/namespace.c                                     |   9 +-
 include/net/bluetooth/hci_core.h                   |   3 +
 include/sound/pcm.h                                |   2 +
 mm/memory.c                                        |   2 +
 mm/userfaultfd.c                                   |   3 +
 net/bluetooth/hci_core.c                           |   6 +-
 sound/core/pcm.c                                   |   3 +
 sound/core/pcm_lib.c                               |   5 +
 sound/core/pcm_memory.c                            |  11 ++-
 sound/core/pcm_native.c                            | 110 +++++++++++++++------
 20 files changed, 154 insertions(+), 83 deletions(-)


