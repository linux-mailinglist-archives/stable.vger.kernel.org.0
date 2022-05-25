Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC35B533797
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiEYHp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiEYHp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:45:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB4C40A28;
        Wed, 25 May 2022 00:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC971CE1E2F;
        Wed, 25 May 2022 07:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1498C385B8;
        Wed, 25 May 2022 07:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653464722;
        bh=JfZab1z+xt1oDyB1p6UDEYlvFX7gwRpVrT01RQlCjLk=;
        h=From:To:Cc:Subject:Date:From;
        b=NjK64GrLtVFX5Paeur+9J1OadG3BidkpkGxPzVJhGM0n848JLWqqc3dloehLzBE6x
         P4MeWFGQbMq0rt7RFHIeAWz9tK0QBRovQBdobuN9NmEel310Rw4R9dB6z9kwiZx5bO
         eZ3rl+XboRNFsRPPcgjFdWiRkP2AAZoBkbdSHGzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.196
Date:   Wed, 25 May 2022 09:45:17 +0200
Message-Id: <165346471818414@kroah.com>
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

I'm announcing the release of the 5.4.196 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/DMA-attributes.txt                          |   10 
 Makefile                                                  |    2 
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi                  |    9 
 arch/arm/boot/dts/imx7-colibri.dtsi                       |    4 
 arch/arm/boot/dts/imx7-mba7.dtsi                          |    2 
 arch/arm/boot/dts/imx7d-nitrogen7.dts                     |    2 
 arch/arm/boot/dts/imx7d-pico-hobbit.dts                   |    4 
 arch/arm/boot/dts/imx7d-pico-pi.dts                       |    4 
 arch/arm/boot/dts/imx7d-sdb.dts                           |    2 
 arch/arm/boot/dts/imx7s-warp.dts                          |    4 
 arch/arm/kernel/entry-armv.S                              |    2 
 arch/arm/kernel/stacktrace.c                              |   10 
 arch/arm/mm/proc-v7-bugs.c                                |    1 
 arch/mips/lantiq/falcon/sysctrl.c                         |    2 
 arch/mips/lantiq/xway/gptu.c                              |    2 
 arch/mips/lantiq/xway/sysctrl.c                           |   46 ++--
 arch/x86/crypto/chacha-avx512vl-x86_64.S                  |    4 
 arch/x86/kvm/mmu.c                                        |   10 
 arch/x86/um/shared/sysdep/syscalls_64.h                   |    5 
 arch/x86/xen/smp_pv.c                                     |    3 
 arch/x86/xen/xen-head.S                                   |   18 +
 block/bfq-iosched.c                                       |    3 
 block/blk-merge.c                                         |   15 -
 block/elevator.c                                          |    3 
 block/mq-deadline.c                                       |    2 
 drivers/base/firmware_loader/main.c                       |   17 +
 drivers/block/drbd/drbd_main.c                            |    7 
 drivers/block/floppy.c                                    |   20 -
 drivers/clk/at91/clk-generated.c                          |    4 
 drivers/crypto/qcom-rng.c                                 |    1 
 drivers/crypto/stm32/stm32-crc32.c                        |    4 
 drivers/gpio/gpio-mvebu.c                                 |    3 
 drivers/gpio/gpio-vf610.c                                 |    8 
 drivers/gpu/drm/drm_dp_mst_topology.c                     |    1 
 drivers/i2c/busses/i2c-mt7621.c                           |   10 
 drivers/input/input.c                                     |   19 +
 drivers/input/touchscreen/ili210x.c                       |    4 
 drivers/input/touchscreen/stmfts.c                        |    8 
 drivers/mmc/core/block.c                                  |    6 
 drivers/mmc/core/mmc_ops.c                                |   25 +-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |    7 
 drivers/net/ethernet/cadence/macb_main.c                  |    2 
 drivers/net/ethernet/dec/tulip/tulip_core.c               |    5 
 drivers/net/ethernet/intel/ice/ice_main.c                 |    7 
 drivers/net/ethernet/intel/igb/igb_main.c                 |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         |    7 
 drivers/net/ethernet/qlogic/qla3xxx.c                     |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c          |    5 
 drivers/net/vmxnet3/vmxnet3_drv.c                         |    6 
 drivers/nvme/host/core.c                                  |    1 
 drivers/nvme/host/multipath.c                             |   25 ++
 drivers/nvme/host/nvme.h                                  |    4 
 drivers/pci/pci.c                                         |   10 
 drivers/platform/chrome/cros_ec_debugfs.c                 |   12 -
 drivers/rtc/class.c                                       |    9 
 drivers/rtc/rtc-mc146818-lib.c                            |   16 +
 drivers/scsi/qla2xxx/qla_target.c                         |    3 
 drivers/vhost/net.c                                       |   15 -
 fs/afs/inode.c                                            |   14 +
 fs/file_table.c                                           |    1 
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
 include/linux/blkdev.h                                    |   16 +
 include/linux/dma-mapping.h                               |    8 
 include/linux/mc146818rtc.h                               |    2 
 include/linux/stmmac.h                                    |    1 
 include/linux/sunrpc/xprtsock.h                           |    1 
 include/uapi/linux/dma-buf.h                              |    4 
 kernel/dma/swiotlb.c                                      |   13 -
 kernel/events/core.c                                      |   14 +
 net/bridge/br_input.c                                     |    7 
 net/key/af_key.c                                          |    6 
 net/mac80211/rx.c                                         |    3 
 net/nfc/nci/data.c                                        |    2 
 net/nfc/nci/hci.c                                         |    4 
 net/sched/act_pedit.c                                     |    4 
 net/sunrpc/xprt.c                                         |   34 +-
 net/sunrpc/xprtsock.c                                     |   36 ++-
 sound/isa/wavefront/wavefront_synth.c                     |    3 
 sound/pci/hda/patch_realtek.c                             |    1 
 tools/objtool/check.c                                     |    1 
 tools/perf/bench/numa.c                                   |    2 
 tools/testing/selftests/net/fcnal-test.sh                 |   12 +
 94 files changed, 681 insertions(+), 263 deletions(-)

Abel Vesa (1):
      ARM: dts: imx7: Use audio_mclk_post_div instead audio_mclk_root_clk

Al Viro (1):
      Fix double fget() in vhost_net_set_backend()

Andrew Lunn (1):
      net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.

Anton Eidelman (1):
      nvme-multipath: fix hang when disk goes live over reconnect

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
      Linux 5.4.196

Haibo Chen (1):
      gpio: gpio-vf610: do not touch other bits when set the target bit

Hangyu Hua (1):
      drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

Harini Katakam (1):
      net: macb: Increment rx bd head after allocating skb and buffer

Jae Hyun Yoo (2):
      ARM: dts: aspeed-g6: remove FWQSPID group in pinctrl dtsi
      ARM: dts: aspeed-g6: fix SPI1/SPI2 quad pin group

Jakob Koschel (1):
      drbd: remove usage of list iterator variable after loop

Jeff LaBundy (1):
      Input: add bounds checking to input_set_capability()

Jiasheng Jiang (1):
      net: af_key: add check for pfkey_broadcast in function pfkey_process

Juergen Gross (1):
      x86/xen: fix booting 32-bit pv guest

Jérôme Pouiller (1):
      dma-buf: fix use of DMA_BUF_SET_NAME_{A,B} in userspace

Kai-Heng Feng (1):
      ALSA: hda/realtek: Enable headset mic on Lenovo P360

Kevin Mitchell (1):
      igb: skip phy status check where unavailable

Linus Torvalds (1):
      Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""

Marek Vasut (1):
      Input: ili210x - fix reset timing

Mario Limonciello (1):
      rtc: mc146818-lib: Fix the AltCentury for AMD platforms

Maxim Mikityanskiy (1):
      net/mlx5e: Properly block LRO when XDP is enabled

Meena Shanmugam (4):
      SUNRPC: Clean up scheduling of autoclose
      SUNRPC: Prevent immediate close+reconnect
      SUNRPC: Don't call connect() more than once on a TCP socket
      SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

Ming Lei (1):
      block: return ELEVATOR_DISCARD_MERGE if possible

Miroslav Benes (2):
      x86/xen: Make the boot CPU idle task reliable
      x86/xen: Make the secondary CPU idle tasks reliable

Nicolas Dichtel (1):
      selftests: add ping test with ping_group_range tuned

Ondrej Mosnacek (1):
      crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ

Paolo Abeni (1):
      net/sched: act_pedit: sanitize shift argument before usage

Paul Greenwalt (1):
      ice: fix possible under reporting of ethtool Tx and Rx statistics

Peter Zijlstra (3):
      crypto: x86/chacha20 - Avoid spurious jumps to other functions
      perf: Fix sys_perf_event_open() race against self
      x86/xen: Mark cpu_bringup_and_idle() as dead_end_function

Rafael J. Wysocki (1):
      PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold

Ryusuke Konishi (2):
      nilfs2: fix lockdep warnings in page operations for btree nodes
      nilfs2: fix lockdep warnings during disk space reclamation

Sean Christopherson (1):
      KVM: x86/mmu: Update number of zapped pages even if page list is stable

Takashi Iwai (1):
      ALSA: wavefront: Proper check of get_user() error

Tan Tee Min (1):
      net: stmmac: disable Split Header (SPH) for Intel platforms

Thiébaud Weksteen (1):
      firmware_loader: use kernel credentials when reading firmware

Thomas Richter (1):
      perf bench numa: Address compiler error on s390

Tzung-Bi Shih (1):
      platform/chrome: cros_ec_debugfs: detach log reader wq from devm

Ulf Hansson (3):
      mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
      mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
      mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

Uwe Kleine-König (1):
      gpio: mvebu/pwm: Refuse requests with inverted polarity

Vincent Whitchurch (1):
      rtc: fix use-after-free on device removal

Willy Tarreau (1):
      floppy: use a statically allocated error counter

Xiaoke Wang (1):
      MIPS: lantiq: check the return value of kzalloc()

Yang Yingliang (3):
      ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()
      net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()
      i2c: mt7621: fix missing clk_disable_unprepare() on error in mtk_i2c_probe()

Zheng Yongjun (2):
      Input: stmfts - fix reference leak in stmfts_input_open
      crypto: stm32 - fix reference leak in stm32_crc_remove

Zixuan Fu (2):
      net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
      net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

linyujun (1):
      ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()

