Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911E953379A
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244385AbiEYHpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243944AbiEYHpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:45:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320E47892E;
        Wed, 25 May 2022 00:45:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C0BF617AF;
        Wed, 25 May 2022 07:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A85C385B8;
        Wed, 25 May 2022 07:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653464730;
        bh=aDCh7o6y/uyOUV6QIbVW0dcP/qd9r5wiSZyYzYLruS8=;
        h=From:To:Cc:Subject:Date:From;
        b=jPH8ZJVyNBX7cPnT+q0YyU7CzsHqUP9oOQIFCQK+t9jGN8PjBqm+SqDVPI+h20cBw
         6n8eJD+6tfgYp2IyHGSSBNAkDjJ3BSRdnJdnc7AGul3Z3Pq+9yFjGUuXZ/xplzSfKe
         vYiGYGTiwdtl8oHyDvpSerSaPpdfjIA+ZScCdKL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.118
Date:   Wed, 25 May 2022 09:45:23 +0200
Message-Id: <1653464723702@kroah.com>
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

I'm announcing the release of the 5.10.118 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst                                |    3 
 Documentation/core-api/dma-attributes.rst                             |    8 
 Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml |    2 
 Makefile                                                              |    2 
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi                              |    9 
 arch/arm/kernel/entry-armv.S                                          |    2 
 arch/arm/kernel/stacktrace.c                                          |   10 
 arch/arm/mm/proc-v7-bugs.c                                            |    1 
 arch/arm64/kernel/cpu_errata.c                                        |    2 
 arch/arm64/kernel/mte.c                                               |    3 
 arch/arm64/kernel/paravirt.c                                          |   29 
 arch/mips/lantiq/falcon/sysctrl.c                                     |    2 
 arch/mips/lantiq/xway/gptu.c                                          |    2 
 arch/mips/lantiq/xway/sysctrl.c                                       |   46 -
 arch/riscv/boot/dts/sifive/fu540-c000.dtsi                            |    2 
 arch/s390/pci/pci.c                                                   |    1 
 arch/s390/pci/pci_bus.h                                               |    3 
 arch/s390/pci/pci_clp.c                                               |    9 
 arch/s390/pci/pci_event.c                                             |    7 
 arch/x86/crypto/chacha-avx512vl-x86_64.S                              |    4 
 arch/x86/kvm/mmu/mmu.c                                                |   10 
 arch/x86/um/shared/sysdep/syscalls_64.h                               |    5 
 drivers/block/drbd/drbd_main.c                                        |    7 
 drivers/block/floppy.c                                                |   20 
 drivers/clk/at91/clk-generated.c                                      |    4 
 drivers/crypto/qcom-rng.c                                             |    1 
 drivers/crypto/stm32/stm32-crc32.c                                    |    4 
 drivers/gpio/gpio-mvebu.c                                             |    3 
 drivers/gpio/gpio-vf610.c                                             |    8 
 drivers/gpu/drm/drm_dp_mst_topology.c                                 |    1 
 drivers/gpu/drm/i915/display/intel_opregion.c                         |   15 
 drivers/i2c/busses/i2c-mt7621.c                                       |   10 
 drivers/input/input.c                                                 |   19 
 drivers/input/touchscreen/ili210x.c                                   |    4 
 drivers/input/touchscreen/stmfts.c                                    |    8 
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c                      |   20 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c             |    7 
 drivers/net/ethernet/broadcom/bcmsysport.c                            |    6 
 drivers/net/ethernet/cadence/macb_main.c                              |    2 
 drivers/net/ethernet/dec/tulip/tulip_core.c                           |    5 
 drivers/net/ethernet/intel/ice/ice_main.c                             |    7 
 drivers/net/ethernet/intel/igb/igb_main.c                             |    3 
 drivers/net/ethernet/intel/igc/igc_base.c                             |   10 
 drivers/net/ethernet/intel/igc/igc_hw.h                               |    1 
 drivers/net/ethernet/intel/igc/igc_main.c                             |   18 
 drivers/net/ethernet/intel/igc/igc_phy.c                              |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                     |    7 
 drivers/net/ethernet/qlogic/qla3xxx.c                                 |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c                      |    4 
 drivers/net/ipa/gsi.c                                                 |    6 
 drivers/net/vmxnet3/vmxnet3_drv.c                                     |    6 
 drivers/nvme/host/core.c                                              |    1 
 drivers/nvme/host/multipath.c                                         |   25 
 drivers/nvme/host/nvme.h                                              |    4 
 drivers/nvme/host/pci.c                                               |    5 
 drivers/pci/pci.c                                                     |   10 
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c                            |   14 
 drivers/platform/chrome/cros_ec_debugfs.c                             |   12 
 drivers/rtc/class.c                                                   |    9 
 drivers/rtc/rtc-mc146818-lib.c                                        |   16 
 drivers/rtc/rtc-pcf2127.c                                             |    3 
 drivers/rtc/rtc-sun6i.c                                               |   14 
 drivers/scsi/qla2xxx/qla_target.c                                     |    3 
 drivers/usb/gadget/legacy/raw_gadget.c                                |    2 
 drivers/vhost/net.c                                                   |   15 
 drivers/vhost/vdpa.c                                                  |    5 
 fs/afs/inode.c                                                        |   14 
 fs/gfs2/file.c                                                        |    4 
 fs/io_uring.c                                                         |    6 
 fs/ioctl.c                                                            |    2 
 fs/nilfs2/btnode.c                                                    |   23 
 fs/nilfs2/btnode.h                                                    |    1 
 fs/nilfs2/btree.c                                                     |   27 
 fs/nilfs2/dat.c                                                       |    4 
 fs/nilfs2/gcinode.c                                                   |    7 
 fs/nilfs2/inode.c                                                     |  159 ++++-
 fs/nilfs2/mdt.c                                                       |   43 -
 fs/nilfs2/mdt.h                                                       |    6 
 fs/nilfs2/nilfs.h                                                     |   16 
 fs/nilfs2/page.c                                                      |    7 
 fs/nilfs2/segment.c                                                   |    9 
 fs/nilfs2/super.c                                                     |    5 
 include/linux/ceph/osd_client.h                                       |    3 
 include/linux/dma-mapping.h                                           |    8 
 include/linux/mc146818rtc.h                                           |    2 
 include/net/ip.h                                                      |    1 
 include/net/netns/xfrm.h                                              |    3 
 include/net/xfrm.h                                                    |   36 -
 include/uapi/linux/dma-buf.h                                          |    4 
 include/uapi/linux/xfrm.h                                             |   14 
 kernel/dma/swiotlb.c                                                  |   12 
 kernel/events/core.c                                                  |   14 
 kernel/module.c                                                       |   18 
 net/bridge/br_input.c                                                 |    7 
 net/ceph/osd_client.c                                                 |  302 +++-------
 net/ipv4/route.c                                                      |   29 
 net/key/af_key.c                                                      |    6 
 net/mac80211/rx.c                                                     |    3 
 net/nfc/nci/data.c                                                    |    2 
 net/nfc/nci/hci.c                                                     |    4 
 net/sched/act_pedit.c                                                 |    4 
 net/wireless/nl80211.c                                                |   18 
 net/xfrm/xfrm_policy.c                                                |   20 
 net/xfrm/xfrm_user.c                                                  |   88 ++
 security/selinux/nlmsgtab.c                                           |    4 
 security/selinux/ss/hashtab.c                                         |    3 
 sound/isa/wavefront/wavefront_synth.c                                 |    3 
 sound/pci/hda/patch_realtek.c                                         |    9 
 sound/usb/quirks-table.h                                              |    9 
 tools/perf/bench/numa.c                                               |    2 
 tools/testing/selftests/net/fcnal-test.sh                             |   12 
 tools/virtio/Makefile                                                 |    3 
 112 files changed, 997 insertions(+), 494 deletions(-)

Al Viro (1):
      Fix double fget() in vhost_net_set_backend()

Alex Elder (1):
      net: ipa: record proper RX transaction count

Andre Przywara (1):
      rtc: sun6i: Fix time overflow handling

Andreas Gruenbacher (1):
      gfs2: Disable page faults during lockless buffered reads

Andrew Lunn (1):
      net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.

Anton Eidelman (1):
      nvme-multipath: fix hang when disk goes live over reconnect

Ard Biesheuvel (2):
      ARM: 9196/1: spectre-bhb: enable for Cortex-A15
      ARM: 9197/1: spectre-bhb: fix loop8 sequence for Thumb2

Catalin Marinas (1):
      arm64: mte: Ensure the cleared tags are visible before setting the PTE

Christophe JAILLET (2):
      net: systemport: Fix an error handling path in bcm_sysport_probe()
      net/qla3xxx: Fix a test in ql_reset_work()

Codrin Ciubotariu (1):
      clk: at91: generated: consider range when calculating best rate

David Gow (1):
      um: Cleanup syscall_handler_t definition/cast, fix warning

David Howells (1):
      afs: Fix afs_getattr() to refetch file status if callback break occurred

Duoming Zhou (1):
      NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc

Eugene Syromiatnikov (1):
      include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage

Eyal Birger (1):
      xfrm: fix "disable_policy" flag use when arriving from different devices

Felix Fietkau (1):
      mac80211: fix rx reordering with non explicit / psmp ack policy

Gleb Chesnokov (1):
      scsi: qla2xxx: Fix missed DMA unmap for aborted commands

Grant Grundler (4):
      net: atlantic: fix "frag[0] not initialized"
      net: atlantic: reduce scope of is_rsc_complete
      net: atlantic: add check for MAX_SKB_FRAGS
      net: atlantic: verify hw_head_ lies within TX buffer ring

Greg Kroah-Hartman (1):
      Linux 5.10.118

Greg Thelen (1):
      Revert "drm/i915/opregion: check port number bounds for SWSCI display power state"

Guo Xuenan (1):
      fs: fix an infinite loop in iomap_fiemap

Haibo Chen (1):
      gpio: gpio-vf610: do not touch other bits when set the target bit

Hangyu Hua (1):
      drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

Harini Katakam (1):
      net: macb: Increment rx bd head after allocating skb and buffer

Hugo Villeneuve (1):
      rtc: pcf2127: fix bug when reading alarm registers

Ilya Dryomov (1):
      libceph: fix potential use-after-free on linger ping and resends

Jae Hyun Yoo (4):
      ARM: dts: aspeed-g6: remove FWQSPID group in pinctrl dtsi
      pinctrl: pinctrl-aspeed-g6: remove FWQSPID group in pinctrl
      ARM: dts: aspeed-g6: fix SPI1/SPI2 quad pin group
      dt-bindings: pinctrl: aspeed-g6: remove FWQSPID group

Jakob Koschel (1):
      drbd: remove usage of list iterator variable after loop

Jeff LaBundy (1):
      Input: add bounds checking to input_set_capability()

Jens Axboe (1):
      io_uring: always grab file table for deferred statx

Jessica Yu (2):
      module: treat exit sections the same as init sections when !CONFIG_MODULE_UNLOAD
      module: check for exit sections in layout_sections() instead of module_init_section()

Jiasheng Jiang (1):
      net: af_key: add check for pfkey_broadcast in function pfkey_process

Johannes Berg (1):
      nl80211: fix locking in nl80211_set_tx_bitrate_mask()

Jérôme Pouiller (1):
      dma-buf: fix use of DMA_BUF_SET_NAME_{A,B} in userspace

Kai-Heng Feng (1):
      ALSA: hda/realtek: Enable headset mic on Lenovo P360

Kevin Mitchell (1):
      igb: skip phy status check where unavailable

Kieran Frewen (1):
      nl80211: validate S1G channel width

Krzysztof Kozlowski (1):
      riscv: dts: sifive: fu540-c000: align dma node name with dtschema

Linus Torvalds (1):
      Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""

Marek Vasut (1):
      Input: ili210x - fix reset timing

Mario Limonciello (1):
      rtc: mc146818-lib: Fix the AltCentury for AMD platforms

Maxim Mikityanskiy (1):
      net/mlx5e: Properly block LRO when XDP is enabled

Michael S. Tsirkin (1):
      tools/virtio: compile with -pthread

Monish Kumar R (1):
      nvme-pci: add quirks for Samsung X5 SSDs

Nicolas Dichtel (5):
      xfrm: make user policy API complete
      xfrm: notify default policy on update
      xfrm: fix dflt policy check when there is no policy configured
      xfrm: rework default policy structure
      selftests: add ping test with ping_group_range tuned

Niklas Schnelle (1):
      s390/pci: improve zpci_dev reference counting

Ondrej Mosnacek (2):
      selinux: fix bad cleanup on error in hashtab_duplicate()
      crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ

Paolo Abeni (1):
      net/sched: act_pedit: sanitize shift argument before usage

Paul Greenwalt (1):
      ice: fix possible under reporting of ethtool Tx and Rx statistics

Pavel Skripkin (1):
      net: xfrm: fix shift-out-of-bounce

Peter Zijlstra (2):
      crypto: x86/chacha20 - Avoid spurious jumps to other functions
      perf: Fix sys_perf_event_open() race against self

Prakruthi Deepak Heragu (1):
      arm64: paravirt: Use RCU read locks to guard stolen_time

Rafael J. Wysocki (1):
      PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold

Ryusuke Konishi (2):
      nilfs2: fix lockdep warnings in page operations for btree nodes
      nilfs2: fix lockdep warnings during disk space reclamation

Sasha Levin (1):
      Revert "swiotlb: fix info leak with DMA_FROM_DEVICE"

Sasha Neftin (3):
      igc: Remove _I_PHY_ID checking
      igc: Remove phy->type checking
      igc: Update I226_K device ID

Schspa Shi (1):
      usb: gadget: fix race when gadget driver register via ioctl

Sean Christopherson (1):
      KVM: x86/mmu: Update number of zapped pages even if page list is stable

Shreyas K K (1):
      arm64: Enable repeat tlbi workaround on KRYO4XX gold CPUs

Steffen Klassert (1):
      xfrm: Add possibility to set the default to block if we have no policy

Takashi Iwai (2):
      ALSA: usb-audio: Restore Rane SL-1 quirk
      ALSA: wavefront: Proper check of get_user() error

Thomas Richter (1):
      perf bench numa: Address compiler error on s390

Tzung-Bi Shih (1):
      platform/chrome: cros_ec_debugfs: detach log reader wq from devm

Uwe Kleine-König (1):
      gpio: mvebu/pwm: Refuse requests with inverted polarity

Vincent Bernat (1):
      net: evaluate net.ipvX.conf.all.disable_policy and disable_xfrm

Vincent Whitchurch (1):
      rtc: fix use-after-free on device removal

Werner Sembach (1):
      ALSA: hda/realtek: Add quirk for TongFang devices with pop noise

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

Zhu Lingshan (1):
      vhost_vdpa: don't setup irq offloading when irq_num < 0

Zixuan Fu (2):
      net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
      net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

linyujun (1):
      ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()

