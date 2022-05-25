Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B263F53375A
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242414AbiEYHaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiEYHaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:30:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B37377EE;
        Wed, 25 May 2022 00:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 814FFB81CEF;
        Wed, 25 May 2022 07:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A53C385B8;
        Wed, 25 May 2022 07:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653463804;
        bh=WIp3CPnFwsQpB6X2ygBgfz6/YvkI43W+I/RoPBPvC4M=;
        h=From:To:Cc:Subject:Date:From;
        b=hJ3BcNwr3EuneZik3ccvMvtbzLh2eQ4K1DFwOFgnzHC2SDjmaUjbGtXgdZCAVjjd6
         alv8YvGParh2AvjLQUri0nFUZtDL38yj2ZPWlpujX0nzxPdn/NDBhzHPNPi4fSXVgl
         Om3RRs4vpu8c0rmAjA2YP5EorPkbP05zWrITyqFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.245
Date:   Wed, 25 May 2022 09:29:57 +0200
Message-Id: <1653463798136106@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

I'm announcing the release of the 4.19.245 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 arch/arm/kernel/entry-armv.S                              |    2 
 arch/arm/kernel/stacktrace.c                              |   10 
 arch/arm/mm/proc-v7-bugs.c                                |    1 
 arch/mips/lantiq/falcon/sysctrl.c                         |    2 
 arch/mips/lantiq/xway/gptu.c                              |    2 
 arch/mips/lantiq/xway/sysctrl.c                           |   46 ++--
 arch/x86/um/shared/sysdep/syscalls_64.h                   |    5 
 drivers/block/drbd/drbd_main.c                            |    7 
 drivers/block/floppy.c                                    |   17 -
 drivers/clk/at91/clk-generated.c                          |    4 
 drivers/crypto/qcom-rng.c                                 |    1 
 drivers/crypto/stm32/stm32_crc32.c                        |    4 
 drivers/gpio/gpio-mvebu.c                                 |    3 
 drivers/gpio/gpio-vf610.c                                 |    8 
 drivers/gpu/drm/drm_dp_mst_topology.c                     |    1 
 drivers/input/input.c                                     |   19 +
 drivers/input/touchscreen/stmfts.c                        |    8 
 drivers/mmc/core/block.c                                  |    8 
 drivers/mmc/core/card.h                                   |    6 
 drivers/mmc/core/mmc.c                                    |    6 
 drivers/mmc/core/mmc_ops.c                                |  110 ++-------
 drivers/mmc/core/mmc_ops.h                                |    3 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |    7 
 drivers/net/ethernet/cadence/macb_main.c                  |    2 
 drivers/net/ethernet/dec/tulip/tulip_core.c               |    5 
 drivers/net/ethernet/intel/igb/igb_main.c                 |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         |    7 
 drivers/net/ethernet/qlogic/qla3xxx.c                     |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c          |    4 
 drivers/net/vmxnet3/vmxnet3_drv.c                         |    6 
 drivers/pci/pci.c                                         |   10 
 drivers/scsi/qla2xxx/qla_target.c                         |    3 
 drivers/vhost/net.c                                       |   15 -
 fs/afs/inode.c                                            |   14 +
 fs/nilfs2/btnode.c                                        |   23 +-
 fs/nilfs2/btnode.h                                        |    1 
 fs/nilfs2/btree.c                                         |   27 +-
 fs/nilfs2/dat.c                                           |    4 
 fs/nilfs2/gcinode.c                                       |    7 
 fs/nilfs2/inode.c                                         |  159 ++++++++++++--
 fs/nilfs2/mdt.c                                           |   43 ++-
 fs/nilfs2/mdt.h                                           |    6 
 fs/nilfs2/nilfs.h                                         |   16 -
 fs/nilfs2/page.c                                          |    7 
 fs/nilfs2/segment.c                                       |    9 
 fs/nilfs2/super.c                                         |    5 
 kernel/dma/swiotlb.c                                      |   12 -
 kernel/events/core.c                                      |   14 +
 net/bridge/br_input.c                                     |    7 
 net/key/af_key.c                                          |    6 
 net/mac80211/rx.c                                         |    3 
 net/nfc/nci/data.c                                        |    2 
 net/nfc/nci/hci.c                                         |    4 
 net/sched/act_pedit.c                                     |    4 
 sound/isa/wavefront/wavefront_synth.c                     |    3 
 tools/perf/bench/numa.c                                   |    2 
 57 files changed, 482 insertions(+), 236 deletions(-)

Al Viro (1):
      Fix double fget() in vhost_net_set_backend()

Andrew Lunn (1):
      net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.

Ard Biesheuvel (2):
      ARM: 9196/1: spectre-bhb: enable for Cortex-A15
      ARM: 9197/1: spectre-bhb: fix loop8 sequence for Thumb2

Christophe JAILLET (1):
      net/qla3xxx: Fix a test in ql_reset_work()

Codrin Ciubotariu (1):
      clk: at91: generated: consider range when calculating best rate

David Gow (1):
      um: Cleanup syscall_handler_t definition/cast, fix warning

David Howells (1):
      afs: Fix afs_getattr() to refetch file status if callback break occurred

Duoming Zhou (1):
      NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc

Felix Fietkau (1):
      mac80211: fix rx reordering with non explicit / psmp ack policy

Gleb Chesnokov (1):
      scsi: qla2xxx: Fix missed DMA unmap for aborted commands

Grant Grundler (1):
      net: atlantic: verify hw_head_ lies within TX buffer ring

Greg Kroah-Hartman (1):
      Linux 4.19.245

Haibo Chen (1):
      gpio: gpio-vf610: do not touch other bits when set the target bit

Halil Pasic (1):
      swiotlb: fix info leak with DMA_FROM_DEVICE

Hangyu Hua (1):
      drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

Harini Katakam (1):
      net: macb: Increment rx bd head after allocating skb and buffer

Jakob Koschel (1):
      drbd: remove usage of list iterator variable after loop

Jeff LaBundy (1):
      Input: add bounds checking to input_set_capability()

Jiasheng Jiang (1):
      net: af_key: add check for pfkey_broadcast in function pfkey_process

Kevin Mitchell (1):
      igb: skip phy status check where unavailable

Linus Torvalds (1):
      Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""

Maxim Mikityanskiy (1):
      net/mlx5e: Properly block LRO when XDP is enabled

Ondrej Mosnacek (1):
      crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ

Paolo Abeni (1):
      net/sched: act_pedit: sanitize shift argument before usage

Peter Zijlstra (1):
      perf: Fix sys_perf_event_open() race against self

Rafael J. Wysocki (1):
      PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold

Ryusuke Konishi (2):
      nilfs2: fix lockdep warnings in page operations for btree nodes
      nilfs2: fix lockdep warnings during disk space reclamation

Takashi Iwai (1):
      ALSA: wavefront: Proper check of get_user() error

Thomas Richter (1):
      perf bench numa: Address compiler error on s390

Ulf Hansson (4):
      mmc: core: Cleanup BKOPS support
      mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
      mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
      mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

Uwe Kleine-König (1):
      gpio: mvebu/pwm: Refuse requests with inverted polarity

Willy Tarreau (1):
      floppy: use a statically allocated error counter

Xiaoke Wang (1):
      MIPS: lantiq: check the return value of kzalloc()

Yang Yingliang (2):
      ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()
      net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()

Zheng Yongjun (2):
      Input: stmfts - fix reference leak in stmfts_input_open
      crypto: stm32 - fix reference leak in stm32_crc_remove

Zixuan Fu (2):
      net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
      net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

linyujun (1):
      ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()

