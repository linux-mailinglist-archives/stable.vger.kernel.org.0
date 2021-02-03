Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625EB30E6B1
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhBCXFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233628AbhBCXFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:05:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A54AD64F55;
        Wed,  3 Feb 2021 23:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612393471;
        bh=rnNS1u+Ct6fYuqLWT64yYtbd7EsvKdPw2Ma5ewaD5Zs=;
        h=From:To:Cc:Subject:Date:From;
        b=HpFjAwaXVrGFNmI7Y/XBTeC/hU2zU0lL+7nvRk6BdJj4G/yn2aLCjKaNyVdIX2Z4C
         coPLDgmg42DrOp2fg27y6HVnS0vpHgnyTYYtfMD/G0MKwsZr5lbyvhxQh9OGqTwBYH
         F1P5wRCypGH5/+OLQBJ0l/B/oN5QlI//P01NXol4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.95
Date:   Thu,  4 Feb 2021 00:04:24 +0100
Message-Id: <1612393465157153@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.95 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virt/kvm/api.txt                             |    3 
 Makefile                                                   |    2 
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi                      |    2 
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi              |    4 
 arch/arm/mach-imx/suspend-imx6.S                           |    1 
 arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi    |    7 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi             |    2 
 arch/x86/kvm/vmx/nested.c                                  |   13 +
 arch/x86/kvm/vmx/pmu_intel.c                               |    6 
 arch/x86/kvm/x86.c                                         |    5 
 drivers/acpi/device_sysfs.c                                |   20 --
 drivers/block/nbd.c                                        |    8 +
 drivers/block/xen-blkfront.c                               |   20 --
 drivers/firmware/imx/Kconfig                               |    1 
 drivers/gpu/drm/i915/i915_drv.h                            |    2 
 drivers/gpu/drm/nouveau/nouveau_svm.c                      |    4 
 drivers/infiniband/hw/cxgb4/qp.c                           |    2 
 drivers/iommu/dmar.c                                       |   45 ++++-
 drivers/leds/led-triggers.c                                |   10 -
 drivers/media/rc/rc-main.c                                 |    4 
 drivers/net/can/dev.c                                      |    2 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c         |   11 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c               |   24 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            |   15 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          |    1 
 drivers/net/team/team.c                                    |    6 
 drivers/net/usb/qmi_wwan.c                                 |    1 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c            |   14 +
 drivers/net/wireless/mediatek/mt7601u/dma.c                |    5 
 drivers/nvme/host/multipath.c                              |    2 
 drivers/s390/crypto/vfio_ap_drv.c                          |    6 
 drivers/s390/crypto/vfio_ap_ops.c                          |  100 ++++++++-----
 drivers/s390/crypto/vfio_ap_private.h                      |   12 -
 drivers/soc/atmel/soc.c                                    |   13 +
 drivers/tee/optee/call.c                                   |    4 
 drivers/xen/xenbus/xenbus_probe.c                          |   31 ++++
 fs/btrfs/block-group.c                                     |   10 +
 fs/btrfs/ctree.h                                           |    3 
 fs/btrfs/free-space-tree.c                                 |   10 +
 fs/nfs/pnfs.c                                              |    1 
 include/linux/intel-iommu.h                                |    2 
 include/net/tcp.h                                          |    2 
 include/uapi/linux/icmpv6.h                                |    1 
 kernel/kexec_core.c                                        |    2 
 kernel/power/swap.c                                        |    2 
 net/ipv4/tcp_input.c                                       |   10 -
 net/ipv4/tcp_recovery.c                                    |    5 
 net/ipv6/icmp.c                                            |    8 -
 net/ipv6/reassembly.c                                      |   33 ++++
 net/mac80211/ieee80211_i.h                                 |    1 
 net/mac80211/iface.c                                       |    6 
 net/netfilter/nft_dynset.c                                 |    4 
 net/nfc/netlink.c                                          |    1 
 net/nfc/rawsock.c                                          |    2 
 net/rxrpc/call_accept.c                                    |    1 
 net/wireless/wext-core.c                                   |    5 
 net/xfrm/xfrm_input.c                                      |    2 
 net/xfrm/xfrm_policy.c                                     |   30 ++-
 sound/pci/hda/patch_realtek.c                              |    1 
 sound/pci/hda/patch_via.c                                  |    2 
 sound/soc/intel/skylake/skl-topology.c                     |   13 -
 sound/soc/soc-topology.c                                   |    2 
 tools/testing/selftests/net/forwarding/router_mpath_nh.sh  |    2 
 tools/testing/selftests/net/forwarding/router_multipath.sh |    2 
 tools/testing/selftests/net/xfrm_policy.sh                 |   45 +++++
 virt/kvm/kvm_main.c                                        |    1 
 66 files changed, 434 insertions(+), 183 deletions(-)

Andrea Righi (1):
      leds: trigger: fix potential deadlock with libata

Baoquan He (1):
      kernel: kexec: remove the lock operation of system_transition_mutex

Bartosz Golaszewski (1):
      iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built

Bharat Gooty (1):
      arm64: dts: broadcom: Fix USB DMA address translation for Stingray

Claudiu Beznea (1):
      drivers: soc: atmel: add null entry at the end of at91_soc_allowed_list[]

Corinna Vinschen (1):
      igc: fix link speed advertising

Dan Carpenter (2):
      can: dev: prevent potential information leak in can_fill_info()
      ASoC: topology: Fix memory corruption in soc_tplg_denum_create_values()

Daniel Wagner (1):
      nvme-multipath: Early exit if no path is available

Danielle Ratson (1):
      selftests: forwarding: Specify interface when invoking mausezahn

David Woodhouse (2):
      xen: Fix XenStore initialisation for XS_LOCAL
      iommu/vt-d: Gracefully handle DMAR units with no supported address widths

Eyal Birger (1):
      xfrm: fix disable_xfrm sysctl when used on xfrm interfaces

Giacinto Cifelli (1):
      net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family

Greg Kroah-Hartman (1):
      Linux 5.4.95

Hangbin Liu (2):
      ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
      IPv6: reply ICMP error if the first fragment don't include all headers

Ivan Vecera (1):
      team: protect features update by RCU to avoid deadlock

Jay Zhou (1):
      KVM: x86: get smi pending status correctly

Jian-Hong Pan (1):
      ALSA: hda/realtek: Enable headset of ASUS B1400CEPE with ALC256

Johannes Berg (4):
      wext: fix NULL-ptr-dereference with cfg80211's lack of commit()
      iwlwifi: pcie: use jiffies for memory read spin time limit
      iwlwifi: pcie: reschedule in long-running memory reads
      mac80211: pause TX while changing interface type

Josef Bacik (2):
      nbd: freeze the queue while we're adding connections
      btrfs: fix possible free space tree corruption with online conversion

Kai-Heng Feng (1):
      ACPI: sysfs: Prefer "compatible" modalias

Kamal Heib (1):
      RDMA/cxgb4: Fix the reported max_recv_sge value

Karol Herbst (1):
      drm/nouveau/svm: fail NOUVEAU_SVM_INIT ioctl on unsupported devices

Koen Vandeputte (1):
      ARM: dts: imx6qdl-gw52xx: fix duplicate regulator naming

Laurent Badel (1):
      PM: hibernate: flush swap writer after marking

Like Xu (2):
      KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]
      KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()

Lorenzo Bianconi (2):
      mt7601u: fix kernel crash unplugging the device
      mt7601u: fix rx buffer refcounting

Maor Dickman (1):
      net/mlx5e: Reduce tc unsupported key print level

Marc Zyngier (1):
      KVM: Forbid the use of tagged userspace addresses for memslots

Marco Felsch (1):
      ARM: dts: imx6qdl-kontron-samx6i: fix i2c_lcd/cam default status

Max Krummenacher (1):
      ARM: imx: build suspend-imx6.S with arm instruction set

Maxim Levitsky (1):
      KVM: nVMX: Sync unsync'd vmcs02 state to vmcs12 on migration

Michael Walle (1):
      arm64: dts: ls1028a: fix the offset of the reset register

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: add timeout extension to template

Pan Bian (2):
      NFC: fix resource leak when target index is invalid
      NFC: fix possible resource leak

Parav Pandit (1):
      net/mlx5e: E-switch, Fix rate calculation for overflow

Pengcheng Yang (1):
      tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN

Po-Hsu Lin (1):
      selftests: xfrm: fix test return value override issue in xfrm_policy.sh

Randy Dunlap (1):
      firmware: imx: select SOC_BUS to fix firmware build

Ricardo Ribalda (1):
      ASoC: Intel: Skylake: skl-topology: Fix OOPs ib skl_tplg_complete

Roger Pau Monne (1):
      xen-blkfront: allow discard-* nodes to be optional

Roi Dayan (1):
      net/mlx5: Fix memory leak on flow table creation error flow

Rouven Czerwinski (1):
      tee: optee: replace might_sleep with cond_resched

Sean Young (1):
      media: rc: ensure that uevent can be read directly after rc device register

Shmulik Ladkani (1):
      xfrm: Fix oops in xfrm_replay_advance_bmp

Stefan Assmann (1):
      i40e: acquire VSI pointer only after VF is initialized

Sudeep Holla (1):
      drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs

Takashi Iwai (1):
      ALSA: hda/via: Apply the workaround generically for Clevo machines

Takeshi Misawa (1):
      rxrpc: Fix memory leak in rxrpc_lookup_local

Tony Krowiak (1):
      s390/vfio-ap: No need to disable IRQ after queue reset

Trond Myklebust (1):
      pNFS/NFSv4: Fix a layout segment leak in pnfs_layout_process()

Umesh Nerlige Ramappa (1):
      drm/i915: Check for all subplatform bits

Visa Hankala (1):
      xfrm: Fix wraparound in xfrm_policy_addr_delta()

