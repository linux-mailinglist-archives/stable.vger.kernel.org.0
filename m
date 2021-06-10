Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53163A2CC3
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 15:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhFJNUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 09:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230506AbhFJNUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 09:20:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0864E61374;
        Thu, 10 Jun 2021 13:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623331086;
        bh=wlS3MB7D+wKUE+V74CrLaDZHoDNe3AUsQwmppM/ebzw=;
        h=From:To:Cc:Subject:Date:From;
        b=ed0ZDVMl9nJazKGyiUdZaOnXo+ONg5lfjK2ZZXQFlpRZR7LQbpJ5Dik4MZB/7UyZh
         +1Y1M6kqZuTnnZVwfglBPQ/gBwn95TCLtHQcArC5C6Ins4yV0W2xrBtCOYP8Zxo770
         VyL+uIcnNogp/diB4L86TV91ZmqmavVKZxuDWoFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.43
Date:   Thu, 10 Jun 2021 15:17:53 +0200
Message-Id: <16233310739628@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.43 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                        |    2 
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi                      |    6 
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi                          |   12 
 arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi                      |    2 
 arch/arm/boot/dts/imx7d-meerkat96.dts                           |    2 
 arch/arm/boot/dts/imx7d-pico.dtsi                               |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts |    5 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                  |    4 
 arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi             |    4 
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi                       |    2 
 arch/arm64/kvm/sys_regs.c                                       |   42 +-
 arch/powerpc/kernel/kprobes.c                                   |    4 
 arch/riscv/kernel/vdso/Makefile                                 |    4 
 arch/x86/include/asm/apic.h                                     |    1 
 arch/x86/include/asm/disabled-features.h                        |    7 
 arch/x86/include/asm/fpu/api.h                                  |    6 
 arch/x86/include/asm/fpu/internal.h                             |    7 
 arch/x86/include/asm/kvm_para.h                                 |   10 
 arch/x86/kernel/apic/apic.c                                     |    1 
 arch/x86/kernel/apic/vector.c                                   |   20 +
 arch/x86/kernel/fpu/xstate.c                                    |   57 ---
 arch/x86/kernel/kvm.c                                           |   92 +++-
 arch/x86/kernel/kvmclock.c                                      |   26 -
 arch/x86/kvm/svm/svm.c                                          |    8 
 arch/x86/mm/mem_encrypt_identity.c                              |   11 
 drivers/acpi/acpica/utdelete.c                                  |    8 
 drivers/bus/ti-sysc.c                                           |   57 ++-
 drivers/firmware/efi/cper.c                                     |    4 
 drivers/firmware/efi/fdtparams.c                                |    3 
 drivers/firmware/efi/libstub/file.c                             |    2 
 drivers/firmware/efi/memattr.c                                  |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c                         |   16 
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c                          |    4 
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c                          |    4 
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c                           |    1 
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c                           |    5 
 drivers/gpu/drm/i915/selftests/i915_request.c                   |    4 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                         |    3 
 drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c                        |   51 --
 drivers/hid/hid-logitech-hidpp.c                                |    1 
 drivers/hid/hid-magicmouse.c                                    |    2 
 drivers/hid/hid-multitouch.c                                    |   10 
 drivers/hid/i2c-hid/i2c-hid-core.c                              |   13 
 drivers/hid/usbhid/hid-pidff.c                                  |    1 
 drivers/hwmon/dell-smm-hwmon.c                                  |    4 
 drivers/hwmon/pmbus/isl68137.c                                  |    4 
 drivers/i2c/busses/i2c-qcom-geni.c                              |   21 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                      |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                 |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c            |   14 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c            |    9 
 drivers/net/ethernet/chelsio/cxgb4/sge.c                        |    6 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                     |    7 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                      |   15 
 drivers/net/ethernet/intel/ice/ice_ethtool.c                    |   51 --
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h                 |    1 
 drivers/net/ethernet/intel/ice/ice_lib.c                        |    2 
 drivers/net/ethernet/intel/ice/ice_txrx.c                       |   24 -
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c                |   19 -
 drivers/net/ethernet/intel/ice/ice_xsk.c                        |   16 
 drivers/net/ethernet/intel/igb/igb_main.c                       |   10 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                   |   16 
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c                    |   21 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c               |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c            |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                 |    9 
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c              |    3 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c        |    3 
 drivers/net/usb/cdc_ncm.c                                       |   12 
 drivers/net/wireguard/Makefile                                  |    3 
 drivers/net/wireguard/allowedips.c                              |  189 +++++-----
 drivers/net/wireguard/allowedips.h                              |   14 
 drivers/net/wireguard/main.c                                    |   17 
 drivers/net/wireguard/peer.c                                    |   27 +
 drivers/net/wireguard/peer.h                                    |    3 
 drivers/net/wireguard/selftest/allowedips.c                     |  165 ++++----
 drivers/net/wireguard/socket.c                                  |    2 
 drivers/net/xen-netback/interface.c                             |    6 
 drivers/nvme/host/rdma.c                                        |    5 
 drivers/nvme/target/core.c                                      |   33 -
 drivers/tee/optee/call.c                                        |    6 
 drivers/tee/optee/optee_msg.h                                   |    6 
 drivers/tty/serial/stm32-usart.c                                |   22 -
 drivers/usb/dwc2/core_intr.c                                    |    4 
 drivers/vfio/pci/Kconfig                                        |    1 
 drivers/vfio/pci/vfio_pci_config.c                              |    2 
 drivers/vfio/platform/vfio_platform_common.c                    |    2 
 fs/btrfs/extent-tree.c                                          |   12 
 fs/btrfs/file-item.c                                            |   10 
 fs/btrfs/inode.c                                                |   19 -
 fs/btrfs/reflink.c                                              |   38 +-
 fs/btrfs/tree-checker.c                                         |   16 
 fs/btrfs/tree-log.c                                             |   13 
 fs/ext4/extents.c                                               |   43 +-
 fs/ext4/fast_commit.c                                           |  182 ++++-----
 fs/ext4/fast_commit.h                                           |    7 
 fs/ext4/ialloc.c                                                |    6 
 fs/ext4/mballoc.c                                               |    2 
 fs/ext4/super.c                                                 |   11 
 fs/gfs2/glock.c                                                 |    2 
 fs/io_uring.c                                                   |    6 
 fs/ocfs2/file.c                                                 |   55 ++
 include/linux/mlx5/mlx5_ifc.h                                   |    2 
 include/linux/platform_data/ti-sysc.h                           |    1 
 include/linux/usb/usbnet.h                                      |    2 
 include/net/caif/caif_dev.h                                     |    2 
 include/net/caif/cfcnfg.h                                       |    2 
 include/net/caif/cfserl.h                                       |    1 
 include/net/tls.h                                               |   10 
 init/main.c                                                     |    2 
 kernel/bpf/helpers.c                                            |   19 -
 kernel/trace/bpf_trace.c                                        |   32 -
 lib/lz4/lz4_decompress.c                                        |    6 
 lib/lz4/lz4defs.h                                               |    1 
 mm/debug_vm_pgtable.c                                           |    4 
 mm/hugetlb.c                                                    |   14 
 mm/page_alloc.c                                                 |    2 
 net/bluetooth/hci_core.c                                        |    7 
 net/bluetooth/hci_sock.c                                        |    4 
 net/caif/caif_dev.c                                             |   13 
 net/caif/caif_usb.c                                             |   14 
 net/caif/cfcnfg.c                                               |   16 
 net/caif/cfserl.c                                               |    5 
 net/core/devlink.c                                              |    4 
 net/core/neighbour.c                                            |    1 
 net/core/sock.c                                                 |   16 
 net/dsa/tag_8021q.c                                             |    2 
 net/ieee802154/nl-mac.c                                         |    4 
 net/ieee802154/nl-phy.c                                         |    4 
 net/ipv6/route.c                                                |    8 
 net/mptcp/subflow.c                                             |   17 
 net/netfilter/ipvs/ip_vs_ctl.c                                  |    2 
 net/netfilter/nf_conntrack_proto.c                              |    2 
 net/netfilter/nf_tables_api.c                                   |    4 
 net/netfilter/nfnetlink_cthelper.c                              |    8 
 net/netfilter/nft_ct.c                                          |    2 
 net/nfc/llcp_sock.c                                             |    2 
 net/sched/act_ct.c                                              |   10 
 net/tipc/bearer.c                                               |   94 +++-
 net/tls/tls_device.c                                            |   60 ++-
 net/tls/tls_device_fallback.c                                   |    7 
 net/tls/tls_main.c                                              |    1 
 samples/vfio-mdev/mdpy-fb.c                                     |   13 
 sound/core/timer.c                                              |    3 
 sound/pci/hda/hda_codec.c                                       |    5 
 sound/pci/hda/patch_realtek.c                                   |    1 
 tools/perf/util/dwarf-aux.c                                     |    8 
 tools/perf/util/probe-finder.c                                  |    3 
 tools/testing/selftests/wireguard/netns.sh                      |    1 
 tools/testing/selftests/wireguard/qemu/kernel.config            |    1 
 150 files changed, 1259 insertions(+), 924 deletions(-)

Ahelenia Ziemiańska (1):
      HID: multitouch: require Finger field to mark Win8 reports as MT

Alexander Aring (1):
      net: sock: fix in-kernel mark setting

Alexey Makhalov (1):
      ext4: fix memory leak in ext4_fill_super

Anand Jain (1):
      btrfs: fix unmountable seed device after fstrim

Ariel Levkovich (1):
      net/sched: act_ct: Fix ct template allocation for zone 0

Armin Wolf (1):
      hwmon: (dell-smm-hwmon) Fix index values

Arnd Bergmann (1):
      HID: i2c-hid: fix format string mismatch

Aya Levin (1):
      net/mlx5e: Fix incompatible casting

Bob Peterson (1):
      gfs2: fix scheduling while atomic bug in glocks

Brett Creeley (2):
      ice: Fix allowing VF to request more/less queues via virtchnl
      ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared

Carlos M (1):
      ALSA: hda: Fix for mute key LED for HP Pavilion 15-CK0xx

Changbin Du (1):
      efi/fdt: fix panic when no valid fdt found

Coco Li (1):
      ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions

Dan Carpenter (1):
      efi/libstub: prevent read overflow in find_file_option()

Daniel Borkmann (1):
      bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks

Dave Ertman (1):
      ice: Allow all LLDP packets from PF to Tx

David Ahern (1):
      neighbour: allow NUD_NOARP entries to be forced GCed

Ding Hui (1):
      mm/page_alloc: fix counting of free pages after take off from buddy

Dmitry Baryshkov (1):
      drm/msm/dpu: always use mdp device to scale bandwidth

Erik Kaneda (1):
      ACPICA: Clean up context mutex during object deletion

Fabio Estevam (2):
      ARM: dts: imx7d-meerkat96: Fix the 'tuning-step' property
      ARM: dts: imx7d-pico: Fix the 'tuning-step' property

Filipe Manana (1):
      btrfs: fix deadlock when cloning inline extents and low on available space

Florian Westphal (1):
      netfilter: conntrack: unregister ipv4 sockopts on error unwind

Gao Xiang (1):
      lib/lz4: explicitly support in-place decompression

Geert Uytterhoeven (1):
      ARM: dts: imx: emcon-avari: Fix nxp,pca8574 #gpio-cells

Gerald Schaefer (1):
      mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()

Grant Grundler (1):
      net: usb: cdc_ncm: don't spew notifications

Grant Peltier (1):
      hwmon: (pmbus/isl68137) remove READ_TEMPERATURE_3 for RAA228228

Greg Kroah-Hartman (1):
      Linux 5.10.43

Haiyue Wang (1):
      ice: handle the VF VSI rebuild failure

Harshad Shirwadkar (1):
      ext4: fix fast commit alignment issues

Heiner Kallweit (1):
      efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared

Hoang Le (2):
      tipc: add extack messages for bearer/media failure
      tipc: fix unique bearer names sanity check

Hui Wang (1):
      ALSA: hda: update the power_state during the direct-complete

James Zhu (3):
      drm/amdgpu/vcn3: add cancel_delayed_work_sync before power gate
      drm/amdgpu/jpeg2.5: add cancel_delayed_work_sync before power gate
      drm/amdgpu/jpeg3: add cancel_delayed_work_sync before power gate

Jason A. Donenfeld (9):
      wireguard: do not use -O3
      wireguard: peer: allocate in kmem_cache
      wireguard: use synchronize_net rather than synchronize_rcu
      wireguard: selftests: remove old conntrack kconfig value
      wireguard: selftests: make sure rp_filter is disabled on vethc
      wireguard: allowedips: initialize list head in selftest
      wireguard: allowedips: remove nodes in O(1)
      wireguard: allowedips: allocate nodes in kmem_cache
      wireguard: allowedips: free empty intermediate nodes when removing single node

Jens Wiklander (1):
      optee: use export_uuid() to copy client UUID

Jisheng Zhang (1):
      riscv: vdso: fix and clean-up Makefile

Johan Hovold (2):
      serial: stm32: fix threaded interrupt handling
      HID: magicmouse: fix NULL-deref on disconnect

Johnny Chuang (1):
      HID: i2c-hid: Skip ELAN power-on command after reset

Josef Bacik (6):
      btrfs: tree-checker: do not error out if extent ref hash doesn't match
      btrfs: mark ordered extent and inode with error if we fail to finish
      btrfs: fix error handling in btrfs_del_csums
      btrfs: return errors from btrfs_del_csums in cleanup_ref_head
      btrfs: fixup error handling in fixup_inode_link_counts
      btrfs: abort in rename_exchange if we fail to insert the second ref

Julian Anastasov (1):
      ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

Junxiao Bi (1):
      ocfs2: fix data corruption by fallocate

Krzysztof Kozlowski (1):
      nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect

Li Huafei (1):
      perf probe: Fix NULL pointer dereference in convert_variable_location()

Lin Ma (2):
      Bluetooth: fix the erroneous flush_work() order
      Bluetooth: use correct lock to prevent UAF of hdev object

Luben Tuikov (1):
      drm/amdgpu: Don't query CE and UE errors

Lucas Stach (1):
      arm64: dts: zii-ultra: fix 12V_MAIN voltage

Maciej Fijalkowski (1):
      ice: simplify ice_run_xdp

Magnus Karlsson (8):
      igb: add correct exception tracing for XDP
      ixgbevf: add correct exception tracing for XDP
      i40e: optimize for XDP_REDIRECT in xsk path
      i40e: add correct exception tracing for XDP
      ice: optimize for XDP_REDIRECT in xsk path
      ice: add correct exception tracing for XDP
      ixgbe: optimize for XDP_REDIRECT in xsk path
      ixgbe: add correct exception tracing for XDP

Marc Zyngier (1):
      KVM: arm64: Fix debug register indexing

Marek Vasut (1):
      ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators

Mark Rutland (1):
      pid: take a reference when initializing `cad_pid`

Max Gurtovoy (2):
      vfio/platform: fix module_put call in error flow
      nvmet: fix freeing unallocated p2pmem

Maxim Mikityanskiy (2):
      net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
      net/tls: Fix use-after-free after the TLS device goes down and up

Michael Walle (2):
      arm64: dts: ls1028a: fix memory node
      arm64: dts: freescale: sl28: var4: fix RGMII clock and voltage

Michal Vokáč (1):
      ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch

Mina Almasry (1):
      mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY

Moshe Shemesh (1):
      net/mlx5: Check firmware sync reset requested is set before trying to abort it

Naveen N. Rao (1):
      powerpc/kprobes: Fix validation of prefixed instructions across page boundary

Nirmoy Das (1):
      drm/amdgpu: make sure we unpin the UVD BO

Pablo Neira Ayuso (3):
      netfilter: nft_ct: skip expectations for confirmed conntrack
      netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches
      netfilter: nf_tables: missing error reporting for not selected expressions

Paolo Abeni (1):
      mptcp: always parse mptcp options for MPC reqsk

Parav Pandit (1):
      devlink: Correct VIRTUAL port to not have phys_port attributes

Paul Blakey (1):
      net/sched: act_ct: Offload connections with commit action

Paul Greenwalt (1):
      ice: report supported and advertised autoneg using PHY capabilities

Pavel Begunkov (2):
      io_uring: fix link timeout refs
      io_uring: use better types for cflags

Pavel Skripkin (4):
      net: caif: added cfserl_release function
      net: caif: add proper error handling
      net: caif: fix memory leak in caif_device_notify
      net: caif: fix memory leak in cfusbl_device_notify

Phil Elwell (1):
      usb: dwc2: Fix build in periphal-only mode

Phillip Potter (1):
      ext4: fix memory leak in ext4_mb_init_backend on error path.

Pu Wen (1):
      x86/sev: Check SME/SEV support in CPUID first

Rahul Lakkireddy (2):
      cxgb4: fix regression with HASH tc prio value update
      cxgb4: avoid link re-train during TC-MQPRIO configuration

Randy Dunlap (1):
      vfio/pci: zap_vma_ptes() needs MMU

Rasmus Villemoes (1):
      efi: cper: fix snprintf() use in cper_dimm_err_location()

Ritesh Harjani (1):
      ext4: fix accessing uninit percpu counter variable with fast_commit

Roger Pau Monne (1):
      xen-netback: take a reference to the RX task thread

Roi Dayan (1):
      net/mlx5e: Check for needed capability for cvlan matching

Roja Rani Yarubandi (2):
      i2c: qcom-geni: Add shutdown callback for i2c
      i2c: qcom-geni: Suspend and resume the bus during SYSTEM_SLEEP_PM ops

Sagi Grimberg (1):
      nvme-rdma: fix in-casule data send for chained sgls

Sean Christopherson (1):
      KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode

Takashi Iwai (1):
      ALSA: timer: Fix master timer notification

Thomas Gleixner (2):
      x86/cpufeatures: Force disable X86_FEATURE_ENQCMD and remove update_pasid()
      x86/apic: Mark _all_ legacy interrupts when IO/APIC is missing

Tobias Klauser (1):
      bpf: Simplify cases in bpf_base_func_proto

Tom Rix (1):
      HID: logitech-hidpp: initialize level variable

Tony Lindgren (2):
      bus: ti-sysc: Fix am335x resume hang for usb otg module
      bus: ti-sysc: Fix flakey idling of uarts and stop using swsup_sidle_act

Vignesh Raghavendra (1):
      arm64: dts: ti: j7200-main: Mark Main NAVSS as dma-coherent

Vitaly Kuznetsov (3):
      x86/kvm: Teardown PV features on boot CPU as well
      x86/kvm: Disable kvmclock on all CPUs on shutdown
      x86/kvm: Disable all PV features on crash

Vladimir Oltean (1):
      net: dsa: tag_8021q: fix the VLAN IDs used for encoding sub-VLANs

Wei Yongjun (2):
      samples: vfio-mdev: fix error handing in mdpy_fb_probe()
      ieee802154: fix error return code in ieee802154_llsec_getparams()

Ye Bin (1):
      ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at failed

Yevgeny Kliteynik (1):
      net/mlx5: DR, Create multi-destination flow table with level less than 64

Zhen Lei (3):
      vfio/pci: Fix error return code in vfio_ecap_init()
      HID: pidff: fix error return code in hid_pidff_init()
      ieee802154: fix error return code in ieee802154_add_iface()

Zhihao Cheng (1):
      drm/i915/selftests: Fix return value check in live_breadcrumbs_smoketest()

