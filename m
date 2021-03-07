Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517D7330099
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 12:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhCGLzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 06:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhCGLzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 06:55:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0349265020;
        Sun,  7 Mar 2021 11:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615118122;
        bh=V0wODKU/MwVdxyDl+doLs5YXAml+asxFpu0zWOpULb8=;
        h=From:To:Cc:Subject:Date:From;
        b=hG2NwSCGb18Hn+/LB+f2LvgKPm1EnB86UUr3gTy36vj/qTEhRGOEhJEGhDuUMvOxq
         EyB05zmNCpwY6wnITPZ5BkZ3k1am2XcYb6ZXNMIbTxV/Pcox0b359unqcqNlQsgRha
         tRu7lh77mjuhn++yyefNtySVmvpSbRy72z9K/DwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.4
Date:   Sun,  7 Mar 2021 12:55:15 +0100
Message-Id: <161511811591224@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.4 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/btusb.txt                |    2 
 Documentation/devicetree/bindings/net/ethernet-controller.yaml |    5 
 Documentation/networking/ip-sysctl.rst                         |    7 
 Makefile                                                       |    2 
 arch/arm/xen/p2m.c                                             |   35 ++
 arch/parisc/kernel/irq.c                                       |    4 
 arch/riscv/mm/init.c                                           |   21 -
 arch/x86/events/intel/core.c                                   |    3 
 arch/x86/include/asm/xen/page.h                                |   12 
 arch/x86/kernel/module.c                                       |    1 
 arch/x86/kernel/reboot.c                                       |    9 
 arch/x86/tools/relocs.c                                        |   12 
 arch/x86/xen/p2m.c                                             |   54 +++
 arch/x86/xen/setup.c                                           |   25 -
 crypto/tcrypt.c                                                |   20 -
 drivers/block/nbd.c                                            |   32 +-
 drivers/bluetooth/hci_h5.c                                     |    5 
 drivers/edac/amd64_edac.c                                      |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/cz_ih.c                             |   37 +-
 drivers/gpu/drm/amd/amdgpu/iceland_ih.c                        |   36 +-
 drivers/gpu/drm/amd/amdgpu/tonga_ih.c                          |   37 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                  |    5 
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c                |    1 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                         |   15 -
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                         |    3 
 drivers/infiniband/ulp/rtrs/rtrs.c                             |    4 
 drivers/media/rc/mceusb.c                                      |    9 
 drivers/media/usb/uvc/uvc_driver.c                             |    7 
 drivers/media/usb/zr364xx/zr364xx.c                            |   49 ++-
 drivers/media/v4l2-core/v4l2-ctrls.c                           |    3 
 drivers/net/can/flexcan.c                                      |  123 +++++++-
 drivers/net/ethernet/atheros/ag71xx.c                          |    4 
 drivers/net/ipa/ipa_reg.h                                      |   22 -
 drivers/net/phy/sfp-bus.c                                      |   15 +
 drivers/net/phy/sfp.c                                          |   17 +
 drivers/net/tap.c                                              |    7 
 drivers/net/tun.c                                              |    5 
 drivers/net/usb/qmi_wwan.c                                     |    1 
 drivers/net/wireless/ath/ath10k/ahb.c                          |    5 
 drivers/net/wireless/ath/ath10k/core.c                         |   25 +
 drivers/net/wireless/ath/ath10k/core.h                         |    5 
 drivers/net/wireless/ath/ath10k/mac.c                          |   15 -
 drivers/net/wireless/ath/ath10k/pci.c                          |    7 
 drivers/net/wireless/ath/ath10k/sdio.c                         |    5 
 drivers/net/wireless/ath/ath10k/snoc.c                         |    6 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c         |   32 ++
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c                 |   18 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h                |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                  |   26 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                |   20 +
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h             |    2 
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c           |   12 
 drivers/net/wireless/mediatek/mt76/mt7915/init.c               |   18 -
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                |   24 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h             |    1 
 drivers/net/wireless/microchip/wilc1000/netdev.c               |    2 
 drivers/net/wireless/microchip/wilc1000/wlan.c                 |   15 -
 drivers/net/wireless/microchip/wilc1000/wlan.h                 |    3 
 drivers/net/wireless/ti/wl12xx/main.c                          |    3 
 drivers/net/wireless/ti/wlcore/main.c                          |   15 -
 drivers/net/wireless/ti/wlcore/wlcore.h                        |    3 
 drivers/net/xen-netback/netback.c                              |   12 
 drivers/nvme/host/core.c                                       |   20 +
 drivers/nvme/host/nvme.h                                       |    2 
 drivers/nvme/host/rdma.c                                       |   18 +
 drivers/nvme/host/tcp.c                                        |   18 +
 drivers/pci/pci.c                                              |    9 
 drivers/phy/mediatek/phy-mtk-hdmi.c                            |    1 
 drivers/phy/mediatek/phy-mtk-mipi-dsi.c                        |    1 
 drivers/scsi/libiscsi.c                                        |  148 +++++-----
 drivers/scsi/scsi_transport_iscsi.c                            |   40 ++
 drivers/staging/fwserial/fwserial.c                            |    2 
 drivers/staging/most/sound/sound.c                             |    2 
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-ctl.c      |    6 
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c      |    2 
 drivers/staging/vc04_services/bcm2835-audio/bcm2835.c          |    6 
 drivers/tty/n_tty.c                                            |   87 ++++-
 drivers/tty/tty_io.c                                           |   28 +
 drivers/tty/vt/consolemap.c                                    |    2 
 drivers/vfio/vfio_iommu_type1.c                                |   15 -
 drivers/video/fbdev/udlfb.c                                    |    1 
 fs/btrfs/transaction.c                                         |   11 
 fs/erofs/super.c                                               |    4 
 fs/f2fs/namei.c                                                |    8 
 fs/f2fs/segment.h                                              |    4 
 fs/jfs/jfs_filsys.h                                            |    1 
 fs/jfs/jfs_mount.c                                             |   10 
 fs/namei.c                                                     |   43 +-
 fs/xfs/xfs_iops.c                                              |    2 
 include/linux/netdevice.h                                      |    3 
 include/linux/swap.h                                           |    1 
 include/net/bluetooth/hci.h                                    |    8 
 include/uapi/linux/pkt_cls.h                                   |    2 
 kernel/sched/core.c                                            |   17 -
 kernel/sched/sched.h                                           |    1 
 mm/hugetlb.c                                                   |   22 -
 mm/page_io.c                                                   |    5 
 mm/swapfile.c                                                  |   13 
 net/bluetooth/amp.c                                            |    3 
 net/bluetooth/hci_core.c                                       |   21 -
 net/bridge/br_sysfs_if.c                                       |    9 
 net/core/dev.c                                                 |   42 ++
 net/core/dev_ioctl.c                                           |   20 -
 net/core/pktgen.c                                              |    2 
 net/core/rtnetlink.c                                           |    2 
 net/core/skbuff.c                                              |   14 
 net/dsa/tag_rtl4_a.c                                           |   43 +-
 net/hsr/hsr_framereg.c                                         |    9 
 net/hsr/hsr_framereg.h                                         |    1 
 net/hsr/hsr_main.h                                             |    1 
 net/iucv/af_iucv.c                                             |    1 
 net/mptcp/options.c                                            |   22 -
 net/mptcp/protocol.c                                           |    3 
 net/mptcp/protocol.h                                           |   11 
 net/mptcp/subflow.c                                            |    6 
 net/psample/psample.c                                          |    4 
 net/sched/cls_flower.c                                         |   39 ++
 security/smack/smackfs.c                                       |   21 +
 security/tomoyo/file.c                                         |   16 -
 security/tomoyo/network.c                                      |    8 
 security/tomoyo/util.c                                         |   24 -
 sound/pci/hda/patch_realtek.c                                  |   13 
 sound/soc/intel/boards/bytcr_rt5640.c                          |   63 +++-
 sound/soc/intel/boards/bytcr_rt5651.c                          |   13 
 sound/soc/intel/boards/sof_sdw.c                               |   15 -
 sound/soc/intel/common/soc-intel-quirks.h                      |   25 +
 sound/soc/qcom/lpass-cpu.c                                     |    1 
 sound/usb/implicit.c                                           |    3 
 sound/usb/quirks-table.h                                       |  117 +++++++
 sound/usb/quirks.c                                             |   20 +
 tools/testing/selftests/bpf/xdpxceiver.c                       |    1 
 132 files changed, 1513 insertions(+), 585 deletions(-)

Alex Elder (1):
      net: ipa: avoid field overflow

Alex Williamson (1):
      vfio/type1: Use follow_pte()

Alexander Egorenkov (1):
      net/af_iucv: remove WARN_ONCE on malformed RX packets

Alexandre Ghiti (1):
      riscv: Get rid of MAX_EARLY_MAPPING_SIZE

Ard Biesheuvel (1):
      crypto: tcrypt - avoid signed overflow in byte count

Björn Töpel (1):
      selftests/bpf: Remove memory leak

Boris Brezillon (1):
      phy: mediatek: Add missing MODULE_DEVICE_TABLE()

Borislav Petkov (1):
      EDAC/amd64: Do not load on family 0x15, model 0x13

Chao Leng (3):
      nvme-core: add cancel tagset helpers
      nvme-rdma: add clean action for failed reconnection
      nvme-tcp: add clean action for failed reconnection

Chao Yu (1):
      f2fs: fix to set/clear I_LINKABLE under i_lock

Chris Leech (2):
      scsi: iscsi: Ensure sysfs attributes are limited to PAGE_SIZE
      scsi: iscsi: Verify lengths on passthrough PDUs

Chris Mi (1):
      net: psample: Fix netlink skb length with tunnel info

Christian Gromm (1):
      staging: most: sound: add sanity check for function argument

Claire Chang (1):
      Bluetooth: hci_h5: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for btrtl

Cong Wang (1):
      net: fix dev_ifsioc_locked() race condition

DENG Qingfang (1):
      net: ag71xx: remove unnecessary MTU reservation

Dan Carpenter (1):
      media: zr364xx: fix memory leaks in probe()

Defang Bo (1):
      drm/amdgpu: Add check to prevent IH overflow

Di Zhu (1):
      pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()

Dinghao Liu (1):
      staging: fwserial: Fix error handling in fwserial_create

Eckhart Mohr (1):
      ALSA: hda/realtek: Add quirk for Clevo NH55RZQ

Eric Dumazet (1):
      tcp: fix tcp_rmem documentation

Fangrui Song (1):
      x86/build: Treat R_386_PLT32 relocation as R_386_PC32

Gao Xiang (1):
      erofs: fix shift-out-of-bounds of blkszbits

Geert Uytterhoeven (1):
      dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/

Gopal Tiwari (1):
      Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data

Greg Kroah-Hartman (1):
      Linux 5.11.4

Hans Verkuil (1):
      media: v4l2-ctrls.c: fix shift-out-of-bounds in std_validate

Hans de Goede (9):
      Bluetooth: Add new HCI_QUIRK_NO_SUSPEND_NOTIFIER quirk
      brcmfmac: Add DMI nvram filename quirk for Predia Basic tablet
      brcmfmac: Add DMI nvram filename quirk for Voyo winpad A15 tablet
      ASoC: Intel: bytcr_rt5640: Add new BYT_RT5640_NO_SPEAKERS quirk-flag
      ASoC: Intel: Add DMI quirk table to soc_intel_is_byt_cr()
      ASoC: Intel: bytcr_rt5640: Add quirk for the Estar Beauty HD MID 7316R tablet
      ASoC: Intel: bytcr_rt5640: Add quirk for the Voyo Winpad A15 tablet
      ASoC: Intel: bytcr_rt5651: Add quirk for the Jumper EZpad 7 tablet
      ASoC: Intel: bytcr_rt5640: Add quirk for the Acer One S1002 tablet

Heiner Kallweit (1):
      x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk

Ihab Zhaika (1):
      iwlwifi: add new cards for So and Qu family

Jack Wang (3):
      RDMA/rtrs: Do not signal for heatbeat
      RDMA/rtrs-clt: Use bitmask to check sess->flags
      RDMA/rtrs-srv: Do not signal REG_MR

Jaegeuk Kim (1):
      f2fs: handle unallocated section and zone on pinned/atgc

Jan Beulich (2):
      Xen/gnttab: handle p2m update errors on a per-slot basis
      xen-netback: respect gnttab_map_refs()'s return value

Jens Axboe (2):
      fs: make unlazy_walk() error handling consistent
      swap: fix swapfile read/write offset

Jim Mattson (1):
      perf/x86/kvm: Add Cascade Lake Xeon steppings to isolation_ucodes[]

Jingwen Chen (1):
      drm/amd/amdgpu: add error handling to amdgpu_virt_read_pf2vf_data

Jiri Slaby (1):
      vt/consolemap: do font sum unsigned

Joakim Zhang (1):
      can: flexcan: add CAN wakeup function for i.MX8QM

John David Anglin (1):
      parisc: Bump 64-bit IRQ stack size to 64 KB

Josef Bacik (2):
      nbd: handle device refs for DESTROY_ON_DISCONNECT properly
      btrfs: fix error handling in commit_fs_roots

Juerg Haefliger (1):
      staging: bcm2835-audio: Replace unsafe strcpy() with strscpy()

Juergen Gross (1):
      xen: fix p2m size in dom0 for disabled memory hotplug case

Juri Lelli (1):
      sched/features: Fix hrtick reprogramming

Lech Perczak (1):
      net: usb: qmi_wwan: support ZTE P685M modem

Lee Duncan (1):
      scsi: iscsi: Restrict sessions and handles to admin capabilities

Li Xinhai (1):
      mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

Linus Torvalds (5):
      tty: fix up iterate_tty_read() EOVERFLOW handling
      tty: fix up hung_up_tty_read() conversion
      tty: clean up legacy leftovers from n_tty line discipline
      tty: teach n_tty line discipline about the new "cookie continuations"
      tty: teach the n_tty ICANON case about the new "cookie continuations" too

Linus Walleij (1):
      net: dsa: tag_rtl4_a: Support also egress tags

Marco Elver (1):
      net: fix up truesize of cloned skb in skb_prepare_for_shift()

Marco Wenzel (1):
      net: hsr: add support for EntryForgetTime

Miaoqing Pan (1):
      ath10k: fix wmi mgmt tx queue full due to race condition

Nicholas Kazlauskas (1):
      drm/amd/display: Guard against NULL pointer deref when get_i2c_info fails

Nirmoy Das (1):
      PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse

Olivia Mackintosh (3):
      ALSA: usb-audio: Add support for Pioneer DJM-750
      ALSA: usb-audio: Add DJM450 to Pioneer format quirk
      ALSA: usb-audio: Add DJM-450 to the quirks table

Pali Rohár (1):
      net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant

Paolo Abeni (3):
      mptcp: fix spurious retransmissions
      mptcp: do not wakeup listener for MPJ subflows
      mptcp: fix DATA_FIN generation on early shutdown

Peter Zijlstra (1):
      sched/core: Allow try_invoke_on_locked_down_task() with irqs disabled

Pierre-Louis Bossart (1):
      ASoC: Intel: sof-sdw: indent and add quirks consistently

Rander Wang (1):
      ASoC: Intel: sof_sdw: detect DMIC number based on mach params

Randy Dunlap (1):
      JFS: more checks for invalid superblock

Ricardo Ribalda (1):
      media: uvcvideo: Allow entities with no pads

Russell King (1):
      dt-bindings: ethernet-controller: fix fixed-link specification

Ryder Lee (2):
      mt76: mt7915: reset token when mac_reset happens
      mt76: mt7615: reset token when mac_reset happens

Sabyrzhan Tasbolatov (1):
      smackfs: restrict bytes count in smackfs write functions

Sean Young (1):
      media: mceusb: sanity check for prescaler value

Stephen Boyd (1):
      ASoC: qcom: Remove useless debug print

Takashi Iwai (1):
      ALSA: hda/realtek: Apply dual codec quirks for MSI Godlike X570 board

Tetsuo Handa (1):
      tomoyo: ignore data race while checking quota

Tian Tao (1):
      drm/hisilicon: Fix use-after-free

Tony Lindgren (1):
      wlcore: Fix command execute failure 19 for wl12xx

Vamshi K Sthambamkadi (1):
      Bluetooth: btusb: fix memory leak on suspend and resume

Vladimir Oltean (1):
      net: bridge: use switchdev for port flags set through sysfs too

Vsevolod Kozlov (1):
      wilc1000: Fix use of void pointer as a wrong struct type

Wen Gong (1):
      ath10k: prevent deinitializing NAPI twice

Werner Sembach (1):
      ALSA: hda/realtek: Add quirk for Intel NUC 10

Yumei Huang (1):
      xfs: Fix assert failure in xfs_setattr_size()

Zqiang (1):
      udlfb: Fix memory leak in dlfb_usb_probe

wenxu (1):
      net/sched: cls_flower: Reject invalid ct_state flags rules

