Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E4F531605
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239343AbiEWRFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239367AbiEWRFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:05:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB316A000;
        Mon, 23 May 2022 10:05:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4ACC614BF;
        Mon, 23 May 2022 17:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92325C385A9;
        Mon, 23 May 2022 17:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325534;
        bh=yxudxAP5vXJv5jR8c6g73YNgGDBzANxhBZMt3vtI50Q=;
        h=From:To:Cc:Subject:Date:From;
        b=yBCcZ4olayIzrREjQ0ladhRyAX7JcSLXWx303d1i4yHrySZjp8/ShptXvx4OfedpC
         48GduI4AtDspkE+2mDexzuwUopPxh1E7dNE9LIXNgGCeiPEMT8V8yiVBkhozKUYP+1
         0s6+SPcPKvJMlxEAz59gufMmpOqbERMTQ2j6ppPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/33] 4.14.281-rc1 review
Date:   Mon, 23 May 2022 19:04:49 +0200
Message-Id: <20220523165746.957506211@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.281-rc1
X-KernelTest-Deadline: 2022-05-25T16:59+00:00
Content-Type: text/plain; charset=UTF-8
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

This is the start of the stable review cycle for the 4.14.281 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.281-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.281-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""

Halil Pasic <pasic@linux.ibm.com>
    swiotlb: fix info leak with DMA_FROM_DEVICE

Grant Grundler <grundler@chromium.org>
    net: atlantic: verify hw_head_ lies within TX buffer ring

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

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    gpio: mvebu/pwm: Refuse requests with inverted polarity

Haibo Chen <haibo.chen@nxp.com>
    gpio: gpio-vf610: do not touch other bits when set the target bit

Andrew Lunn <andrew@lunn.ch>
    net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.

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

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    clk: at91: generated: consider range when calculating best rate

Zixuan Fu <r33s3n6@gmail.com>
    net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

Zixuan Fu <r33s3n6@gmail.com>
    net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC

Hangyu Hua <hbh25y@gmail.com>
    drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix sys_perf_event_open() race against self

Takashi Iwai <tiwai@suse.de>
    ALSA: wavefront: Proper check of get_user() error

linyujun <linyujun809@huawei.com>
    ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()

Jakob Koschel <jakobkoschel@gmail.com>
    drbd: remove usage of list iterator variable after loop

Xiaoke Wang <xkernel.wang@foxmail.com>
    MIPS: lantiq: check the return value of kzalloc()

Zheng Yongjun <zhengyongjun3@huawei.com>
    Input: stmfts - fix reference leak in stmfts_input_open

Jeff LaBundy <jeff@labundy.com>
    Input: add bounds checking to input_set_capability()

David Gow <davidgow@google.com>
    um: Cleanup syscall_handler_t definition/cast, fix warning

Willy Tarreau <w@1wt.eu>
    floppy: use a statically allocated error counter


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/kernel/entry-armv.S                       |  2 +-
 arch/arm/kernel/stacktrace.c                       | 10 ++---
 arch/arm/mm/proc-v7-bugs.c                         |  1 +
 arch/mips/lantiq/falcon/sysctrl.c                  |  2 +
 arch/mips/lantiq/xway/gptu.c                       |  2 +
 arch/mips/lantiq/xway/sysctrl.c                    | 46 ++++++++++++++--------
 arch/x86/um/shared/sysdep/syscalls_64.h            |  5 +--
 drivers/block/drbd/drbd_main.c                     |  7 +++-
 drivers/block/floppy.c                             | 17 ++++----
 drivers/clk/at91/clk-generated.c                   |  4 ++
 drivers/gpio/gpio-mvebu.c                          |  3 ++
 drivers/gpio/gpio-vf610.c                          |  8 +++-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  1 +
 drivers/input/input.c                              | 19 +++++++++
 drivers/input/touchscreen/stmfts.c                 |  8 ++--
 drivers/mmc/core/block.c                           |  6 +--
 drivers/mmc/core/mmc_ops.c                         | 27 +++++++------
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |  7 ++++
 drivers/net/ethernet/dec/tulip/tulip_core.c        |  5 ++-
 drivers/net/ethernet/intel/igb/igb_main.c          |  3 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |  3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |  4 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  6 +++
 drivers/scsi/qla2xxx/qla_target.c                  |  3 ++
 kernel/events/core.c                               | 14 +++++++
 lib/swiotlb.c                                      | 12 ++++--
 net/bridge/br_input.c                              |  7 ++++
 net/key/af_key.c                                   |  6 ++-
 net/mac80211/rx.c                                  |  3 +-
 net/nfc/nci/data.c                                 |  2 +-
 net/nfc/nci/hci.c                                  |  4 +-
 sound/isa/wavefront/wavefront_synth.c              |  3 +-
 tools/perf/bench/numa.c                            |  2 +-
 34 files changed, 177 insertions(+), 79 deletions(-)


