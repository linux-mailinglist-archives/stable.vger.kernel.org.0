Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54B8533722
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbiEYHMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244288AbiEYHMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:12:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38209D126;
        Wed, 25 May 2022 00:08:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5559B81C9D;
        Wed, 25 May 2022 07:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2225FC385B8;
        Wed, 25 May 2022 07:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653462481;
        bh=ljSQUedHPgiwfkVPTMDtN7y49NV8RiENyTWaPpDWcIA=;
        h=From:To:Cc:Subject:Date:From;
        b=iJpKi1a8a8YoEUmIQBXKO8i5fi2By3c+zws+9Mg1ewAwKMNBOxeFMVPlXkPcEmOAx
         w9L2hZd5K6pnYZZAArx1rNvNms1H5ugn9802m46RwX16EV3NFSKuPPH/uSX79gesT1
         xcBgk2ssfLOv2mBOtMgIwC1xu9y86IQ8Ylsxqfr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.281
Date:   Wed, 25 May 2022 09:07:54 +0200
Message-Id: <16534624745741@kroah.com>
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

I'm announcing the release of the 4.14.281 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 arch/arm/kernel/entry-armv.S                              |    2 
 arch/arm/kernel/stacktrace.c                              |   10 +--
 arch/arm/mm/proc-v7-bugs.c                                |    1 
 arch/mips/lantiq/falcon/sysctrl.c                         |    2 
 arch/mips/lantiq/xway/gptu.c                              |    2 
 arch/mips/lantiq/xway/sysctrl.c                           |   46 +++++++++-----
 arch/x86/um/shared/sysdep/syscalls_64.h                   |    5 -
 drivers/block/drbd/drbd_main.c                            |    7 +-
 drivers/block/floppy.c                                    |   17 ++---
 drivers/clk/at91/clk-generated.c                          |    4 +
 drivers/gpio/gpio-mvebu.c                                 |    3 
 drivers/gpio/gpio-vf610.c                                 |    8 +-
 drivers/gpu/drm/drm_dp_mst_topology.c                     |    1 
 drivers/input/input.c                                     |   19 +++++
 drivers/input/touchscreen/stmfts.c                        |    8 +-
 drivers/mmc/core/block.c                                  |    6 -
 drivers/mmc/core/mmc_ops.c                                |   27 ++++----
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |    7 ++
 drivers/net/ethernet/dec/tulip/tulip_core.c               |    5 +
 drivers/net/ethernet/intel/igb/igb_main.c                 |    3 
 drivers/net/ethernet/qlogic/qla3xxx.c                     |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c          |    4 -
 drivers/net/vmxnet3/vmxnet3_drv.c                         |    6 +
 drivers/scsi/qla2xxx/qla_target.c                         |    3 
 kernel/events/core.c                                      |   14 ++++
 lib/swiotlb.c                                             |   12 ++-
 net/bridge/br_input.c                                     |    7 ++
 net/key/af_key.c                                          |    6 +
 net/mac80211/rx.c                                         |    3 
 net/nfc/nci/data.c                                        |    2 
 net/nfc/nci/hci.c                                         |    4 -
 sound/isa/wavefront/wavefront_synth.c                     |    3 
 tools/perf/bench/numa.c                                   |    2 
 34 files changed, 176 insertions(+), 78 deletions(-)

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

Duoming Zhou (1):
      NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc

Felix Fietkau (1):
      mac80211: fix rx reordering with non explicit / psmp ack policy

Gleb Chesnokov (1):
      scsi: qla2xxx: Fix missed DMA unmap for aborted commands

Grant Grundler (1):
      net: atlantic: verify hw_head_ lies within TX buffer ring

Greg Kroah-Hartman (1):
      Linux 4.14.281

Haibo Chen (1):
      gpio: gpio-vf610: do not touch other bits when set the target bit

Halil Pasic (1):
      swiotlb: fix info leak with DMA_FROM_DEVICE

Hangyu Hua (1):
      drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

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

Peter Zijlstra (1):
      perf: Fix sys_perf_event_open() race against self

Takashi Iwai (1):
      ALSA: wavefront: Proper check of get_user() error

Thomas Richter (1):
      perf bench numa: Address compiler error on s390

Ulf Hansson (3):
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

Zheng Yongjun (1):
      Input: stmfts - fix reference leak in stmfts_input_open

Zixuan Fu (2):
      net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
      net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

linyujun (1):
      ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()

