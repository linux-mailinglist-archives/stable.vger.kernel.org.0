Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9793A2CB5
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 15:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFJNTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 09:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhFJNTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 09:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54441613DE;
        Thu, 10 Jun 2021 13:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623331066;
        bh=ruoLy3BX0IPTsfHZaJghOiMK9XDq5Ud7fSkPa9nSOU0=;
        h=From:To:Cc:Subject:Date:From;
        b=yoWYANFyC8R4Jxo8YoxQ9PpDPC2UUsv/Ca+9gRBfTVE/yzYJ+Nr5ElFJqYyjE7uZa
         zXp0994xGzqIoQUnrTASr03vartm353oDu4Ig7QqvB4sm9rOXL54kyFdUjFFe2uGNI
         LAvwowYViOC+wHZUSKvryFGxzNMHiRtjuJwCxlms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.125
Date:   Thu, 10 Jun 2021 15:17:43 +0200
Message-Id: <1623331063249180@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.125 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/core-api/xarray.rst                   |   16 -
 Makefile                                            |    2 
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi          |    6 
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi              |   12 +
 arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi          |    2 
 arch/arm/boot/dts/imx7d-meerkat96.dts               |    2 
 arch/arm/boot/dts/imx7d-pico.dtsi                   |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi      |    4 
 arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi |    4 
 arch/arm64/kvm/sys_regs.c                           |   42 ++--
 arch/x86/include/asm/apic.h                         |    1 
 arch/x86/include/asm/kvm_para.h                     |   10 
 arch/x86/kernel/apic/apic.c                         |    1 
 arch/x86/kernel/apic/vector.c                       |   20 +
 arch/x86/kernel/kvm.c                               |   92 ++++++--
 arch/x86/kernel/kvmclock.c                          |   26 --
 arch/x86/kvm/svm.c                                  |    8 
 drivers/acpi/acpica/utdelete.c                      |    8 
 drivers/bus/ti-sysc.c                               |    4 
 drivers/firmware/efi/cper.c                         |    4 
 drivers/firmware/efi/memattr.c                      |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c             |   16 -
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c               |    1 
 drivers/hid/hid-magicmouse.c                        |    2 
 drivers/hid/hid-multitouch.c                        |   10 
 drivers/hid/i2c-hid/i2c-hid-core.c                  |   13 -
 drivers/hid/usbhid/hid-pidff.c                      |    1 
 drivers/hwmon/dell-smm-hwmon.c                      |    4 
 drivers/i2c/busses/i2c-qcom-geni.c                  |   21 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |    1 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c         |    7 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c          |   15 +
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h     |    1 
 drivers/net/ethernet/intel/ice/ice_txrx.c           |    5 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c    |   14 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c   |    3 
 drivers/net/usb/cdc_ncm.c                           |   12 +
 drivers/usb/dwc2/core_intr.c                        |    4 
 drivers/vfio/pci/Kconfig                            |    1 
 drivers/vfio/pci/vfio_pci_config.c                  |    2 
 drivers/vfio/platform/vfio_platform_common.c        |    2 
 drivers/xen/xen-pciback/vpci.c                      |   14 -
 fs/btrfs/extent-tree.c                              |   12 -
 fs/btrfs/file-item.c                                |   10 
 fs/btrfs/inode.c                                    |   12 +
 fs/btrfs/tree-checker.c                             |   16 -
 fs/btrfs/tree-log.c                                 |   13 -
 fs/ext4/extents.c                                   |   43 ++--
 fs/ocfs2/file.c                                     |   55 ++++-
 include/linux/huge_mm.h                             |   19 +
 include/linux/usb/usbnet.h                          |    2 
 include/linux/xarray.h                              |   22 ++
 include/net/caif/caif_dev.h                         |    2 
 include/net/caif/cfcnfg.h                           |    2 
 include/net/caif/cfserl.h                           |    1 
 init/main.c                                         |    2 
 lib/lz4/lz4_decompress.c                            |    6 
 lib/lz4/lz4defs.h                                   |    2 
 lib/test_xarray.c                                   |   65 ++++++
 lib/xarray.c                                        |  208 +++++++++++++++++++-
 mm/filemap.c                                        |   37 ++-
 mm/hugetlb.c                                        |   14 +
 net/bluetooth/hci_core.c                            |    7 
 net/bluetooth/hci_sock.c                            |    4 
 net/caif/caif_dev.c                                 |   13 -
 net/caif/caif_usb.c                                 |   14 +
 net/caif/cfcnfg.c                                   |   16 +
 net/caif/cfserl.c                                   |    5 
 net/core/neighbour.c                                |    1 
 net/ieee802154/nl-mac.c                             |    4 
 net/ieee802154/nl-phy.c                             |    4 
 net/ipv6/route.c                                    |    8 
 net/netfilter/ipvs/ip_vs_ctl.c                      |    2 
 net/netfilter/nf_conntrack_proto.c                  |    2 
 net/netfilter/nfnetlink_cthelper.c                  |    8 
 net/netfilter/nft_ct.c                              |    2 
 net/nfc/llcp_sock.c                                 |    2 
 net/sched/act_ct.c                                  |    3 
 net/tipc/bearer.c                                   |   94 ++++++---
 net/wireless/core.h                                 |    2 
 net/wireless/nl80211.c                              |    7 
 net/wireless/util.c                                 |   39 +++
 samples/vfio-mdev/mdpy-fb.c                         |   13 -
 sound/core/timer.c                                  |    3 
 sound/pci/hda/patch_realtek.c                       |    1 
 sound/usb/mixer_quirks.c                            |    2 
 86 files changed, 925 insertions(+), 294 deletions(-)

Ahelenia Ziemiańska (1):
      HID: multitouch: require Finger field to mark Win8 reports as MT

Anand Jain (1):
      btrfs: fix unmountable seed device after fstrim

Anant Thazhemadam (1):
      nl80211: validate key indexes for cfg80211_registered_device

Ariel Levkovich (1):
      net/sched: act_ct: Fix ct template allocation for zone 0

Armin Wolf (1):
      hwmon: (dell-smm-hwmon) Fix index values

Arnd Bergmann (1):
      HID: i2c-hid: fix format string mismatch

Brett Creeley (1):
      ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared

Carlos M (1):
      ALSA: hda: Fix for mute key LED for HP Pavilion 15-CK0xx

Coco Li (1):
      ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions

Dave Ertman (1):
      ice: Allow all LLDP packets from PF to Tx

David Ahern (1):
      neighbour: allow NUD_NOARP entries to be forced GCed

Erik Kaneda (1):
      ACPICA: Clean up context mutex during object deletion

Fabio Estevam (2):
      ARM: dts: imx7d-meerkat96: Fix the 'tuning-step' property
      ARM: dts: imx7d-pico: Fix the 'tuning-step' property

Florian Westphal (1):
      netfilter: conntrack: unregister ipv4 sockopts on error unwind

Gao Xiang (1):
      lib/lz4: explicitly support in-place decompression

Geert Uytterhoeven (1):
      ARM: dts: imx: emcon-avari: Fix nxp,pca8574 #gpio-cells

Grant Grundler (1):
      net: usb: cdc_ncm: don't spew notifications

Greg Kroah-Hartman (1):
      Linux 5.4.125

Heiner Kallweit (1):
      efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared

Hoang Le (2):
      tipc: add extack messages for bearer/media failure
      tipc: fix unique bearer names sanity check

Jan Beulich (1):
      xen-pciback: redo VF placement in the virtual topology

Johan Hovold (1):
      HID: magicmouse: fix NULL-deref on disconnect

Johnny Chuang (1):
      HID: i2c-hid: Skip ELAN power-on command after reset

Josef Bacik (5):
      btrfs: tree-checker: do not error out if extent ref hash doesn't match
      btrfs: mark ordered extent and inode with error if we fail to finish
      btrfs: fix error handling in btrfs_del_csums
      btrfs: return errors from btrfs_del_csums in cleanup_ref_head
      btrfs: fixup error handling in fixup_inode_link_counts

Julian Anastasov (1):
      ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

Junxiao Bi (1):
      ocfs2: fix data corruption by fallocate

Krzysztof Kozlowski (1):
      nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect

Lin Ma (2):
      Bluetooth: fix the erroneous flush_work() order
      Bluetooth: use correct lock to prevent UAF of hdev object

Luben Tuikov (1):
      drm/amdgpu: Don't query CE and UE errors

Lucas Stach (1):
      arm64: dts: zii-ultra: fix 12V_MAIN voltage

Magnus Karlsson (3):
      ixgbevf: add correct exception tracing for XDP
      i40e: optimize for XDP_REDIRECT in xsk path
      i40e: add correct exception tracing for XDP

Marc Zyngier (1):
      KVM: arm64: Fix debug register indexing

Marek Vasut (1):
      ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators

Mark Rutland (1):
      pid: take a reference when initializing `cad_pid`

Matthew Wilcox (Oracle) (4):
      mm: add thp_order
      XArray: add xa_get_order
      XArray: add xas_split
      mm/filemap: fix storing to a THP shadow entry

Max Gurtovoy (1):
      vfio/platform: fix module_put call in error flow

Michael Chan (1):
      bnxt_en: Remove the setting of dev_port.

Michael Walle (1):
      arm64: dts: ls1028a: fix memory node

Michal Vokáč (1):
      ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch

Mina Almasry (1):
      mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY

Mitch Williams (1):
      ice: write register with correct offset

Nirmoy Das (1):
      drm/amdgpu: make sure we unpin the UVD BO

Pablo Neira Ayuso (2):
      netfilter: nft_ct: skip expectations for confirmed conntrack
      netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches

Pavel Skripkin (4):
      net: caif: added cfserl_release function
      net: caif: add proper error handling
      net: caif: fix memory leak in caif_device_notify
      net: caif: fix memory leak in cfusbl_device_notify

Phil Elwell (1):
      usb: dwc2: Fix build in periphal-only mode

Pierre-Louis Bossart (1):
      ALSA: usb: update old-style static const declaration

Randy Dunlap (1):
      vfio/pci: zap_vma_ptes() needs MMU

Rasmus Villemoes (1):
      efi: cper: fix snprintf() use in cper_dimm_err_location()

Roja Rani Yarubandi (2):
      i2c: qcom-geni: Add shutdown callback for i2c
      i2c: qcom-geni: Suspend and resume the bus during SYSTEM_SLEEP_PM ops

Sean Christopherson (1):
      KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode

Takashi Iwai (1):
      ALSA: timer: Fix master timer notification

Thomas Gleixner (1):
      x86/apic: Mark _all_ legacy interrupts when IO/APIC is missing

Tony Lindgren (1):
      bus: ti-sysc: Fix flakey idling of uarts and stop using swsup_sidle_act

Vitaly Kuznetsov (3):
      x86/kvm: Teardown PV features on boot CPU as well
      x86/kvm: Disable kvmclock on all CPUs on shutdown
      x86/kvm: Disable all PV features on crash

Wei Yongjun (2):
      samples: vfio-mdev: fix error handing in mdpy_fb_probe()
      ieee802154: fix error return code in ieee802154_llsec_getparams()

Ye Bin (1):
      ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at failed

Zhen Lei (3):
      vfio/pci: Fix error return code in vfio_ecap_init()
      HID: pidff: fix error return code in hid_pidff_init()
      ieee802154: fix error return code in ieee802154_add_iface()

