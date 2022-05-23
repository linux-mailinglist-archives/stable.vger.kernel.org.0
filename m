Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11330531C37
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbiEWRDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239168AbiEWRDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:03:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEEA263E;
        Mon, 23 May 2022 10:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F980614B8;
        Mon, 23 May 2022 17:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722FBC34115;
        Mon, 23 May 2022 17:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325430;
        bh=W9fV845Xuh0fV3wyeqNdVqfyEyLMzse9SP3BHb8CBt0=;
        h=From:To:Cc:Subject:Date:From;
        b=xuJf77JiSLfcVLvv1qXVwO1xxkZeRiZusPjO2TT6/pRV1C7yHxRa/JwdrWUEcirqz
         qAqez6WPp2n+3BXsKfCHnNViFhTdzqoUe29v0QvGPE3lf2HKI/cPasbzjIgRz0B+q9
         mN0cr2nkhKvC8rnJQR3Sd56QPuItZ60wJeHZBcdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/25] 4.9.316-rc1 review
Date:   Mon, 23 May 2022 19:03:18 +0200
Message-Id: <20220523165743.398280407@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.316-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.316-rc1
X-KernelTest-Deadline: 2022-05-25T16:57+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.316 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.316-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.316-rc1

Yang Yingliang <yangyingliang@huawei.com>
    net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()

Yang Yingliang <yangyingliang@huawei.com>
    ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()

Felix Fietkau <nbd@nbd.name>
    mac80211: fix rx reordering with non explicit / psmp ack policy

Gleb Chesnokov <Chesnokov.G@raidix.com>
    scsi: qla2xxx: Fix missed DMA unmap for aborted commands

Thomas Richter <tmricht@linux.ibm.com>
    perf bench numa: Address compiler error on s390

Kevin Mitchell <kevmitch@arista.com>
    igb: skip phy status check where unavailable

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9197/1: spectre-bhb: fix loop8 sequence for Thumb2

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9196/1: spectre-bhb: enable for Cortex-A15

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: af_key: add check for pfkey_broadcast in function pfkey_process

Duoming Zhou <duoming@zju.edu.cn>
    NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net/qla3xxx: Fix a test in ql_reset_work()

Zixuan Fu <r33s3n6@gmail.com>
    net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

Zixuan Fu <r33s3n6@gmail.com>
    net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()

Hangyu Hua <hbh25y@gmail.com>
    drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix sys_perf_event_open() race against self

Takashi Iwai <tiwai@suse.de>
    ALSA: wavefront: Proper check of get_user() error

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC

linyujun <linyujun809@huawei.com>
    ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()

Jakob Koschel <jakobkoschel@gmail.com>
    drbd: remove usage of list iterator variable after loop

Xiaoke Wang <xkernel.wang@foxmail.com>
    MIPS: lantiq: check the return value of kzalloc()

Jeff LaBundy <jeff@labundy.com>
    Input: add bounds checking to input_set_capability()

David Gow <davidgow@google.com>
    um: Cleanup syscall_handler_t definition/cast, fix warning

Willy Tarreau <w@1wt.eu>
    floppy: use a statically allocated error counter


-------------

Diffstat:

 Makefile                                         |  4 +--
 arch/arm/kernel/entry-armv.S                     |  2 +-
 arch/arm/kernel/stacktrace.c                     | 10 +++---
 arch/arm/mm/proc-v7-bugs.c                       |  1 +
 arch/mips/lantiq/falcon/sysctrl.c                |  2 ++
 arch/mips/lantiq/xway/gptu.c                     |  2 ++
 arch/mips/lantiq/xway/sysctrl.c                  | 46 +++++++++++++++---------
 arch/x86/um/shared/sysdep/syscalls_64.h          |  5 ++-
 drivers/block/drbd/drbd_main.c                   |  7 ++--
 drivers/block/floppy.c                           | 19 +++++-----
 drivers/gpu/drm/drm_dp_mst_topology.c            |  1 +
 drivers/input/input.c                            | 19 ++++++++++
 drivers/mmc/card/block.c                         |  6 ++--
 drivers/mmc/core/core.c                          |  5 ++-
 drivers/mmc/core/mmc_ops.c                       |  9 ++---
 drivers/net/ethernet/dec/tulip/tulip_core.c      |  5 ++-
 drivers/net/ethernet/intel/igb/igb_main.c        |  3 +-
 drivers/net/ethernet/qlogic/qla3xxx.c            |  3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |  4 +--
 drivers/net/vmxnet3/vmxnet3_drv.c                |  6 ++++
 drivers/scsi/qla2xxx/qla_target.c                |  3 ++
 kernel/events/core.c                             | 14 ++++++++
 net/key/af_key.c                                 |  6 ++--
 net/mac80211/rx.c                                |  3 +-
 net/nfc/nci/data.c                               |  2 +-
 net/nfc/nci/hci.c                                |  4 +--
 sound/isa/wavefront/wavefront_synth.c            |  3 +-
 tools/perf/bench/numa.c                          |  2 +-
 28 files changed, 134 insertions(+), 62 deletions(-)


