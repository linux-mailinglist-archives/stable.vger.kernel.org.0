Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EC95318A9
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbiEWRFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239326AbiEWRFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:05:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367E569CCB;
        Mon, 23 May 2022 10:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B1D614BB;
        Mon, 23 May 2022 17:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A13DC385AA;
        Mon, 23 May 2022 17:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325537;
        bh=1ndn2883QweAHkGFNSs/HoRl/jlgdu7LPZJ+VQsDQ/M=;
        h=From:To:Cc:Subject:Date:From;
        b=c92kYmAzPocWpRNdRAc5cjEAHOfd6PbEJzWLU/jQz84K0rRuGxsDjr7LFHt1fe3V/
         36PXEKneYYk0JEykoy/oV0iIX1zjpbLlR8TBywfs9Z9EcSkxfC3Ih13vaVwps1gHoD
         yRW8A9+CMYcQk7FIOiudIHEK35FONIJgTAypZMrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/44] 4.19.245-rc1 review
Date:   Mon, 23 May 2022 19:04:44 +0200
Message-Id: <20220523165752.797318097@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.245-rc1
X-KernelTest-Deadline: 2022-05-25T17:00+00:00
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

This is the start of the stable review cycle for the 4.19.245 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.245-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.245-rc1

David Howells <dhowells@redhat.com>
    afs: Fix afs_getattr() to refetch file status if callback break occurred

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

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Properly block LRO when XDP is enabled

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

Paolo Abeni <pabeni@redhat.com>
    net/sched: act_pedit: sanitize shift argument before usage

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Increment rx bd head after allocating skb and buffer

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Cleanup BKOPS support

Hangyu Hua <hbh25y@gmail.com>
    drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

Ondrej Mosnacek <omosnace@redhat.com>
    crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold

Al Viro <viro@zeniv.linux.org.uk>
    Fix double fget() in vhost_net_set_backend()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix sys_perf_event_open() race against self

Takashi Iwai <tiwai@suse.de>
    ALSA: wavefront: Proper check of get_user() error

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix lockdep warnings during disk space reclamation

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix lockdep warnings in page operations for btree nodes

linyujun <linyujun809@huawei.com>
    ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()

Jakob Koschel <jakobkoschel@gmail.com>
    drbd: remove usage of list iterator variable after loop

Xiaoke Wang <xkernel.wang@foxmail.com>
    MIPS: lantiq: check the return value of kzalloc()

Zheng Yongjun <zhengyongjun3@huawei.com>
    crypto: stm32 - fix reference leak in stm32_crc_remove

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

 Makefile                                           |   4 +-
 arch/arm/kernel/entry-armv.S                       |   2 +-
 arch/arm/kernel/stacktrace.c                       |  10 +-
 arch/arm/mm/proc-v7-bugs.c                         |   1 +
 arch/mips/lantiq/falcon/sysctrl.c                  |   2 +
 arch/mips/lantiq/xway/gptu.c                       |   2 +
 arch/mips/lantiq/xway/sysctrl.c                    |  46 +++---
 arch/x86/um/shared/sysdep/syscalls_64.h            |   5 +-
 drivers/block/drbd/drbd_main.c                     |   7 +-
 drivers/block/floppy.c                             |  17 +--
 drivers/clk/at91/clk-generated.c                   |   4 +
 drivers/crypto/qcom-rng.c                          |   1 +
 drivers/crypto/stm32/stm32_crc32.c                 |   4 +-
 drivers/gpio/gpio-mvebu.c                          |   3 +
 drivers/gpio/gpio-vf610.c                          |   8 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   1 +
 drivers/input/input.c                              |  19 +++
 drivers/input/touchscreen/stmfts.c                 |   8 +-
 drivers/mmc/core/block.c                           |   8 +-
 drivers/mmc/core/card.h                            |   6 +-
 drivers/mmc/core/mmc.c                             |   6 -
 drivers/mmc/core/mmc_ops.c                         | 110 ++++----------
 drivers/mmc/core/mmc_ops.h                         |   3 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   7 +
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |   5 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   4 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   6 +
 drivers/pci/pci.c                                  |  10 ++
 drivers/scsi/qla2xxx/qla_target.c                  |   3 +
 drivers/vhost/net.c                                |  15 +-
 fs/afs/inode.c                                     |  14 +-
 fs/nilfs2/btnode.c                                 |  23 ++-
 fs/nilfs2/btnode.h                                 |   1 +
 fs/nilfs2/btree.c                                  |  27 ++--
 fs/nilfs2/dat.c                                    |   4 +-
 fs/nilfs2/gcinode.c                                |   7 +-
 fs/nilfs2/inode.c                                  | 159 +++++++++++++++++++--
 fs/nilfs2/mdt.c                                    |  43 ++++--
 fs/nilfs2/mdt.h                                    |   6 +-
 fs/nilfs2/nilfs.h                                  |  16 +--
 fs/nilfs2/page.c                                   |   7 +-
 fs/nilfs2/segment.c                                |   9 +-
 fs/nilfs2/super.c                                  |   5 +-
 kernel/dma/swiotlb.c                               |  12 +-
 kernel/events/core.c                               |  14 ++
 net/bridge/br_input.c                              |   7 +
 net/key/af_key.c                                   |   6 +-
 net/mac80211/rx.c                                  |   3 +-
 net/nfc/nci/data.c                                 |   2 +-
 net/nfc/nci/hci.c                                  |   4 +-
 net/sched/act_pedit.c                              |   4 +
 sound/isa/wavefront/wavefront_synth.c              |   3 +-
 tools/perf/bench/numa.c                            |   2 +-
 57 files changed, 483 insertions(+), 237 deletions(-)


