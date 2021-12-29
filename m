Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89B6481258
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbhL2L6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbhL2L6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:58:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730C3C061574;
        Wed, 29 Dec 2021 03:58:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E945A6147D;
        Wed, 29 Dec 2021 11:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CD0C36AE7;
        Wed, 29 Dec 2021 11:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640779097;
        bh=gG2GVkXg3FNb2QrcTWiyLB7PUN+Q8qQfshTx9HYi6XQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Y1qoNcilNJOUiJVxDKSnsGeZbcQA/fsXWb4ndir3a9hjS451z0NZuT+5CsYGmqcEM
         IepEbqcpe0AG9mqYEB+PHC0HS8U8XDDO/KM0dXR1003F97lQAf+kQB1u5VNksoVWPA
         yDfQ9RN/kGMrD9WNteIWSnfVPEtO1dAcSbSBbsRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.12
Date:   Wed, 29 Dec 2021 12:58:13 +0100
Message-Id: <16407790937344@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.12 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                |    8 
 Documentation/hwmon/lm90.rst                                   |   10 
 Documentation/networking/bonding.rst                           |   11 
 Documentation/sound/hd-audio/models.rst                        |    2 
 Makefile                                                       |    2 
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi                       |    1 
 arch/arm/kernel/entry-armv.S                                   |    8 
 arch/arm/kernel/head-nommu.S                                   |    1 
 arch/arm64/Kconfig                                             |    3 
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts |    2 
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi                 |    4 
 arch/arm64/kernel/vdso32/Makefile                              |   17 
 arch/parisc/include/asm/futex.h                                |    4 
 arch/parisc/kernel/syscall.S                                   |    2 
 arch/x86/include/asm/kvm-x86-ops.h                             |    1 
 arch/x86/include/asm/kvm_host.h                                |    1 
 arch/x86/include/asm/pkru.h                                    |    4 
 arch/x86/kernel/setup.c                                        |   72 +---
 arch/x86/kvm/mmu/tdp_iter.c                                    |    6 
 arch/x86/kvm/mmu/tdp_iter.h                                    |    6 
 arch/x86/kvm/mmu/tdp_mmu.c                                     |   29 -
 arch/x86/kvm/svm/svm.c                                         |   21 -
 arch/x86/kvm/vmx/vmx.c                                         |   45 +-
 arch/x86/kvm/x86.c                                             |    9 
 drivers/base/power/main.c                                      |    2 
 drivers/bus/sunxi-rsb.c                                        |    8 
 drivers/char/ipmi/ipmi_msghandler.c                            |   21 -
 drivers/char/ipmi/ipmi_ssif.c                                  |    7 
 drivers/gpio/gpio-dln2.c                                       |   19 -
 drivers/gpio/gpio-virtio.c                                     |    6 
 drivers/gpu/drm/mediatek/mtk_hdmi.c                            |   12 
 drivers/hid/hid-holtek-mouse.c                                 |   15 
 drivers/hid/hid-vivaldi.c                                      |    3 
 drivers/hwmon/Kconfig                                          |    2 
 drivers/hwmon/lm90.c                                           |  175 ++++++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                     |   64 +++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                     |    8 
 drivers/infiniband/hw/hns/hns_roce_srq.c                       |    2 
 drivers/infiniband/hw/qib/qib_user_sdma.c                      |    2 
 drivers/input/misc/iqs626a.c                                   |   21 -
 drivers/input/mouse/elantech.c                                 |    8 
 drivers/input/touchscreen/atmel_mxt_ts.c                       |    2 
 drivers/input/touchscreen/elants_i2c.c                         |   46 ++
 drivers/input/touchscreen/goodix.c                             |    1 
 drivers/mmc/core/core.c                                        |    7 
 drivers/mmc/core/core.h                                        |    1 
 drivers/mmc/core/host.c                                        |    9 
 drivers/mmc/host/meson-mx-sdhc-mmc.c                           |   16 
 drivers/mmc/host/mmci_stm32_sdmmc.c                            |    2 
 drivers/mmc/host/sdhci-tegra.c                                 |   43 +-
 drivers/net/bonding/bond_options.c                             |    2 
 drivers/net/ethernet/intel/ice/ice_txrx.h                      |   16 
 drivers/net/ethernet/intel/ice/ice_xsk.c                       |   64 +--
 drivers/net/ethernet/intel/igb/igb_main.c                      |   19 -
 drivers/net/ethernet/marvell/prestera/prestera_main.c          |   35 +-
 drivers/net/ethernet/micrel/ks8851_par.c                       |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h              |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c       |   12 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c           |    4 
 drivers/net/ethernet/sfc/falcon/rx.c                           |    5 
 drivers/net/ethernet/sfc/rx_common.c                           |    5 
 drivers/net/ethernet/smsc/smc911x.c                            |    5 
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c           |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c               |    2 
 drivers/net/fjes/fjes_main.c                                   |    5 
 drivers/net/hamradio/mkiss.c                                   |    5 
 drivers/net/tun.c                                              |  115 +++---
 drivers/net/usb/asix_common.c                                  |    8 
 drivers/net/usb/lan78xx.c                                      |    6 
 drivers/net/usb/r8152.c                                        |   43 ++
 drivers/net/veth.c                                             |    8 
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                          |   29 -
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c               |    8 
 drivers/pinctrl/stm32/pinctrl-stm32.c                          |    8 
 drivers/platform/x86/Makefile                                  |    2 
 drivers/platform/x86/amd-pmc.c                                 |    3 
 drivers/platform/x86/intel/Kconfig                             |   15 
 drivers/platform/x86/intel/pmc/pltdrv.c                        |    2 
 drivers/spi/spi-armada-3700.c                                  |    2 
 drivers/tee/optee/shm_pool.c                                   |    6 
 drivers/tee/tee_shm.c                                          |  171 +++------
 fs/ext4/extents.c                                              |   95 +++--
 fs/f2fs/xattr.c                                                |   11 
 fs/io_uring.c                                                  |   10 
 fs/ksmbd/ndr.c                                                 |    2 
 fs/ksmbd/smb2ops.c                                             |    3 
 fs/ksmbd/smb2pdu.c                                             |   29 +
 fs/netfs/read_helper.c                                         |    6 
 fs/nfsd/nfs3proc.c                                             |   11 
 fs/nfsd/nfsproc.c                                              |    8 
 include/linux/compiler.h                                       |    4 
 include/linux/instrumentation.h                                |    4 
 include/linux/ipv6.h                                           |    1 
 include/linux/tee_drv.h                                        |    4 
 include/linux/virtio_net.h                                     |   25 +
 include/net/inet_sock.h                                        |    3 
 include/net/sock.h                                             |    7 
 include/uapi/linux/byteorder/big_endian.h                      |    1 
 include/uapi/linux/byteorder/little_endian.h                   |    1 
 kernel/crash_core.c                                            |   11 
 kernel/ucount.c                                                |   15 
 mm/damon/dbgfs.c                                               |    2 
 mm/kfence/core.c                                               |    1 
 mm/memory-failure.c                                            |   14 
 mm/mempolicy.c                                                 |    3 
 net/ax25/af_ax25.c                                             |    4 
 net/bridge/br_ioctl.c                                          |    8 
 net/ipv4/af_inet.c                                             |    2 
 net/ipv4/tcp.c                                                 |    3 
 net/ipv4/tcp_input.c                                           |    2 
 net/ipv4/tcp_ipv4.c                                            |   17 
 net/ipv4/udp.c                                                 |    6 
 net/ipv6/tcp_ipv6.c                                            |   23 -
 net/ipv6/udp.c                                                 |    8 
 net/mac80211/cfg.c                                             |    3 
 net/netfilter/nf_tables_api.c                                  |    4 
 net/netfilter/nfnetlink_log.c                                  |    3 
 net/netfilter/nfnetlink_queue.c                                |    3 
 net/phonet/pep.c                                               |    2 
 sound/core/jack.c                                              |    4 
 sound/core/rawmidi.c                                           |    1 
 sound/drivers/opl3/opl3_midi.c                                 |    2 
 sound/pci/hda/patch_hdmi.c                                     |   21 -
 sound/pci/hda/patch_realtek.c                                  |   29 +
 sound/soc/codecs/rt5682.c                                      |    4 
 sound/soc/codecs/tas2770.c                                     |    4 
 sound/soc/meson/aiu-encoder-i2s.c                              |   33 -
 sound/soc/meson/aiu-fifo-i2s.c                                 |   19 +
 sound/soc/meson/aiu-fifo.c                                     |    6 
 sound/soc/sof/intel/pci-tgl.c                                  |    4 
 sound/soc/tegra/tegra_asoc_machine.c                           |   11 
 sound/soc/tegra/tegra_asoc_machine.h                           |    1 
 tools/testing/selftests/kvm/include/kvm_util.h                 |   10 
 tools/testing/selftests/kvm/lib/kvm_util.c                     |    5 
 134 files changed, 1173 insertions(+), 722 deletions(-)

Alexey Gladkov (1):
      ucounts: Fix rlimit max values check

Andrea Righi (1):
      Input: elantech - fix stack out of bound access in elantech_change_report_id()

Andrew Cooper (1):
      x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

Andrew Jones (1):
      selftests: KVM: Fix non-x86 compiling

Andrey Ryabinin (1):
      mm: mempolicy: fix THP allocations escaping mempolicy restrictions

Andy Shevchenko (1):
      platform/x86/intel: Remove X86_PLATFORM_DRIVERS_INTEL

AngeloGioacchino Del Regno (1):
      drm/mediatek: hdmi: Perform NULL pointer check for mtk_hdmi_conf

Ard Biesheuvel (1):
      ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling

Baokun Li (1):
      kfence: fix memory leak when cat kfence objects

Benjamin Tissoires (1):
      HID: holtek: fix mouse probing

Borislav Petkov (1):
      Revert "x86/boot: Pull up cmdline preparation and early param parsing"

Bradley Scott (2):
      ALSA: hda/realtek: Amp init fixup for HP ZBook 15 G6
      ALSA: hda/realtek: Add new alc285-hp-amp-init model

Chao Yu (1):
      f2fs: fix to do sanity check on last xattr entry in __f2fs_setxattr()

Chuck Lever (1):
      NFSD: Fix READDIR buffer overflow

Colin Ian King (1):
      ALSA: drivers: opl3: Fix incorrect use of vp->state

Dan Carpenter (1):
      ksmbd: fix error code in ndr_read_int32()

Derek Fang (1):
      ASoC: rt5682: fix the wrong jack type detected

Dmitry Osipenko (2):
      ASoC: tegra: Add DAPM switches for headphones and mic jack
      ASoC: tegra: Restore headphones jack name on Nyan Big

Dongliang Mu (1):
      spi: change clk_disable_unprepare to clk_unprepare

Eric Dumazet (4):
      netfilter: nf_tables: fix use-after-free in nft_set_catchall_destroy()
      tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex
      ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie
      inet: fully convert sk->sk_rx_dst to RCU rules

Fabien Dessenne (1):
      pinctrl: stm32: consider the GPIO offset to expose all the GPIO lines

Fernando Fernandez Mancera (1):
      bonding: fix ad_actor_system option setting to default

George Kennedy (1):
      tun: avoid double free in tun_free_netdev

Greg Jesionowski (1):
      net: usb: lan78xx: add Allied Telesis AT29M2-AF

Greg Kroah-Hartman (1):
      Linux 5.15.12

Guenter Roeck (7):
      hwmon: (lm90) Fix usage of CONFIG2 register in detect function
      hwmon: (lm90) Prevent integer overflow/underflow in hysteresis calculations
      hwmon: (lm90) Introduce flag indicating extended temperature support
      hwmon: (lm90) Add basic support for TI TMP461
      hwmon: (lm90) Drop critical attribute support for MAX6654
      hwmom: (lm90) Fix citical alarm status for MAX6680/MAX6681
      hwmon: (lm90) Do not report 'busy' status bit as alarm

Guodong Liu (1):
      pinctrl: mediatek: fix global-out-of-bounds issue

Gustavo A. R. Silva (1):
      net: bridge: Use array_size() helper in copy_to_user()

Hans de Goede (1):
      Input: goodix - add id->model mapping for the "9111" model

Hayes Wang (2):
      r8152: fix the force speed doesn't work for RTL8156
      r8152: sync ocp base

Heiner Kallweit (1):
      igb: fix deadlock caused by taking RTNL in RPM resume path

Ignacy Gawędzki (1):
      netfilter: fix regression in looped (broad|multi)cast's MAC handling

Ismael Luceno (1):
      uapi: Fix undefined __always_inline on non-glibc systems

Jaroslav Kysela (1):
      ALSA: rawmidi - fix the uninitalized user_pversion

Jeff LaBundy (1):
      Input: iqs626a - prohibit inlining of channel parsing functions

Jeffle Xu (1):
      netfs: fix parameter of cleanup()

Jens Axboe (1):
      io_uring: zero iocb->ki_pos for stream file types

Jens Wiklander (1):
      tee: handle lookup of shm with reference count 0

Jeremy Szu (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Jernej Skrabec (1):
      bus: sunxi-rsb: Fix shutdown

Jiacheng Shi (1):
      RDMA/hns: Replace kfree() with kvfree()

Jiasheng Jiang (7):
      HID: potential dereference of null pointer
      qlcnic: potential dereference null pointer of rx_queue->page_ring
      fjes: Check for error irq
      drivers: net: smc911x: Check for error irq
      net: ks8851: Check for error irq
      sfc: Check null pointer of rx_queue->page_ring
      sfc: falcon: Check null pointer of rx_queue->page_ring

Johan Hovold (1):
      platform/x86: intel_pmc_core: fix memleak on registration failure

Johannes Berg (1):
      mac80211: fix locking in ieee80211_start_ap error path

John David Anglin (2):
      parisc: Correct completer in lws start
      parisc: Fix mask used to select futex spinlock

Johnny Chuang (1):
      Input: elants_i2c - do not check Remark ID on eKTH3900/eKTH5312

Josh Poimboeuf (1):
      compiler.h: Fix annotation macro misplacement with Clang

José Expósito (2):
      IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()
      Input: atmel_mxt_ts - fix double free in mxt_read_info_block

Kai Vehmanen (2):
      ASoC: SOF: Intel: pci-tgl: add new ADL-P variant
      ASoC: SOF: Intel: pci-tgl: add ADL-N support

Lin Ma (3):
      ax25: NPD bug when detaching AX25 device
      hamradio: defer ax25 kfree after unregister_netdev
      hamradio: improve the incomplete fix to avoid NPD

Liu Shixin (1):
      mm/hwpoison: clear MF_COUNT_INCREASED before retrying get_any_page()

Maciej Fijalkowski (1):
      ice: xsk: return xsk buffers back to pool when cleaning the ring

Magnus Karlsson (1):
      ice: Use xdp_buf instead of rx_buf for xsk zero-copy

Marc Orr (1):
      KVM: x86: Always set kvm_run->if_flag

Marcos Del Sol Vives (1):
      ksmbd: disable SMB2_GLOBAL_CAP_ENCRYPTION for SMB 3.1.1

Mario Limonciello (1):
      platform/x86: amd-pmc: only use callbacks for suspend

Martin Blumenstingl (3):
      ASoC: meson: aiu: fifo: Add missing dma_coerce_mask_and_coherent()
      ASoC: meson: aiu: Move AIU_I2S_MISC hold setting to aiu-fifo-i2s
      mmc: meson-mx-sdhc: Set MANUAL_STOP for multi-block SDIO commands

Martin Haaß (1):
      ARM: dts: imx6qdl-wandboard: Fix Ethernet support

Martin Povišer (1):
      ASoC: tas2770: Fix setting of high sample rates

Mian Yousaf Kaukab (1):
      ipmi: ssif: initialize ssif_info->client early

Mike Rapoport (1):
      x86/boot: Move EFI range reservation after cmdline parsing

Namjae Jeon (1):
      ksmbd: fix uninitialized symbol 'pntsd_size'

Naoya Horiguchi (1):
      mm, hwpoison: fix condition in free hugetlb page path

Nick Desaulniers (1):
      arm64: vdso32: require CROSS_COMPILE_COMPAT for gcc+bfd

Nobuhiro Iwamatsu (1):
      net: stmmac: dwmac-visconti: Fix value of ETHER_CLK_SEL_FREQ_SEL_2P5M

Noralf Trønnes (1):
      gpio: dln2: Fix interrupts when replugging the device

Paolo Abeni (1):
      veth: ensure skb entering GRO are not cloned.

Pavel Skripkin (2):
      asix: fix uninit-value in asix_mdio_read()
      asix: fix wrong return value in asix_check_host_enable()

Phil Elwell (1):
      pinctrl: bcm2835: Change init order for gpio hogs

Philipp Rudo (1):
      kernel/crash_core: suppress unknown crashkernel parameter warning

Prathamesh Shete (1):
      mmc: sdhci-tegra: Fix switch to HS400ES mode

Rafael J. Wysocki (1):
      PM: sleep: Fix error handling in dpm_prepare()

Remi Pommarel (1):
      net: bridge: fix ioctl old_deviceless bridge argument

Robert Marko (1):
      arm64: dts: allwinner: orangepi-zero-plus: fix PHY mode

Rémi Denis-Courmont (1):
      phonet/pep: refuse to enable an unbound pipe

Sean Christopherson (5):
      KVM: x86/mmu: Don't advance iterator after restart due to yielding
      KVM: nVMX: Synthesize TRIPLE_FAULT for L2 if emulation is required
      KVM: VMX: Always clear vmx->fail on emulation_required
      KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU
      KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state

SeongJae Park (1):
      mm/damon/dbgfs: protect targets destructions with kdamond_lock

Sumit Garg (1):
      tee: optee: Fix incorrect page free bug

Thadeu Lima de Souza Cascardo (2):
      ipmi: bail out if init_srcu_struct fails
      ipmi: fix initialization when workqueue allocation fails

Ulf Hansson (1):
      mmc: core: Disable card detect during shutdown

Ville Syrjälä (1):
      ALSA: hda/hdmi: Disable silent stream on GLK

Vincent Whitchurch (1):
      gpio: virtio: remove timeout

Vladimir Murzin (1):
      ARM: 9160/1: NOMMU: Reload __secondary_data after PROCINFO_INITFUNC

Werner Sembach (1):
      ALSA: hda/realtek: Fix quirk for Clevo NJ51CU

Willem de Bruijn (2):
      net: accept UFOv6 packages in virtio_net_hdr_to_skb
      net: skip virtio_net_hdr_set_proto if protocol already set

Wu Bo (1):
      ipmi: Fix UAF when uninstall ipmi_si and ipmi_msghandler module

Xiaoke Wang (1):
      ALSA: jack: Check the return value of kstrdup()

Xiaoliang Yang (1):
      net: stmmac: ptp: fix potentially overflowing expression

Yangyang Li (1):
      RDMA/hns: Fix RNR retransmission issue for HIP08

Yann Gautier (1):
      mmc: mmci: stm32: clear DLYB_CR after sending tuning command

Yevhen Orlov (2):
      net: marvell: prestera: fix incorrect return of port_find
      net: marvell: prestera: fix incorrect structure access

Zhang Yi (3):
      ext4: prevent partial update of the extent blocks
      ext4: check for out-of-order index extents in ext4_valid_extent_entries()
      ext4: check for inconsistent extents between index and leaf block

Zhang Ying-22455 (1):
      arm64: dts: lx2160a: fix scl-gpios property name

