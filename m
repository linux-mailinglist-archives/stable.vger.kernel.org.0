Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664F735EDE0
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 08:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349509AbhDNGzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 02:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243063AbhDNGzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 02:55:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D4CB611F2;
        Wed, 14 Apr 2021 06:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618383298;
        bh=F9dxd+euF/zODQ7DoWU4XRLdOibzexnuOVriGJLifQI=;
        h=From:To:Cc:Subject:Date:From;
        b=Rp6DVoU4UxEXOufYvubr8RphWW5Z7CjPatlisMM7/HCMnNKEb2ZRcWoNHHIVfFZiE
         sOzT0RB5gu8vEgb+cYB33k1sojg0dxxt/6Otv2QH4ZAy6aMnJskjUwCLYe6FfsPW8Q
         pzFf2TjMT5yfPegYwhjmtjukdFFUT6GlSam09PL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.14
Date:   Wed, 14 Apr 2021 08:54:50 +0200
Message-Id: <16183832907103@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.14 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/ethernet-controller.yaml |    2 
 Makefile                                                       |    2 
 arch/arm/boot/dts/armada-385-turris-omnia.dts                  |    4 
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi                   |    2 
 arch/arm/mach-omap2/omap-secure.c                              |   39 ++
 arch/arm/mach-omap2/omap-secure.h                              |    1 
 arch/arm/mach-omap2/pmic-cpcap.c                               |    4 
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h                 |    2 
 arch/arm64/boot/dts/freescale/imx8mq-pinfunc.h                 |    2 
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi                  |    6 
 arch/ia64/include/asm/ptrace.h                                 |    8 
 arch/nds32/mm/cacheflush.c                                     |    2 
 arch/parisc/include/asm/cmpxchg.h                              |    2 
 arch/powerpc/kernel/Makefile                                   |    4 
 arch/powerpc/kernel/ptrace/Makefile                            |    4 
 arch/powerpc/kernel/ptrace/ptrace-decl.h                       |   14 
 arch/powerpc/kernel/ptrace/ptrace-fpu.c                        |   10 
 arch/powerpc/kernel/ptrace/ptrace-novsx.c                      |    8 
 arch/powerpc/kernel/ptrace/ptrace-view.c                       |    2 
 arch/s390/kernel/cpcmd.c                                       |    6 
 arch/x86/include/asm/smp.h                                     |    2 
 arch/x86/kernel/smpboot.c                                      |   26 -
 arch/x86/kernel/traps.c                                        |    4 
 arch/x86/kvm/mmu/mmu.c                                         |   13 
 arch/x86/kvm/mmu/tdp_iter.c                                    |   30 -
 arch/x86/kvm/mmu/tdp_iter.h                                    |   11 
 arch/x86/kvm/mmu/tdp_mmu.c                                     |   99 +++--
 arch/x86/kvm/mmu/tdp_mmu.h                                     |   18 
 drivers/acpi/processor_idle.c                                  |    4 
 drivers/base/dd.c                                              |    8 
 drivers/char/agp/Kconfig                                       |    2 
 drivers/clk/clk.c                                              |   47 +-
 drivers/clk/qcom/camcc-sc7180.c                                |   50 +-
 drivers/clk/socfpga/clk-gate.c                                 |    2 
 drivers/gpio/gpiolib.c                                         |   12 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                        |    2 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c            |    3 
 drivers/gpu/drm/i915/display/intel_acpi.c                      |   22 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                          |    6 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c                     |    4 
 drivers/gpu/drm/msm/msm_drv.c                                  |    1 
 drivers/gpu/drm/radeon/radeon_ttm.c                            |    4 
 drivers/gpu/drm/vc4/vc4_crtc.c                                 |   17 
 drivers/i2c/busses/i2c-designware-master.c                     |    1 
 drivers/i2c/busses/i2c-jz4780.c                                |    4 
 drivers/i2c/i2c-core-base.c                                    |    7 
 drivers/infiniband/core/addr.c                                 |    4 
 drivers/infiniband/hw/cxgb4/cm.c                               |    3 
 drivers/infiniband/hw/hfi1/affinity.c                          |   21 -
 drivers/infiniband/hw/hfi1/hfi.h                               |    1 
 drivers/infiniband/hw/hfi1/init.c                              |   10 
 drivers/infiniband/hw/hfi1/netdev_rx.c                         |    3 
 drivers/infiniband/hw/qedr/verbs.c                             |    3 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                         |    2 
 drivers/net/can/spi/mcp251x.c                                  |   24 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                   |    6 
 drivers/net/dsa/lantiq_gswip.c                                 |  195 ++++++++--
 drivers/net/ethernet/amd/xgbe/xgbe.h                           |    6 
 drivers/net/ethernet/cadence/macb_main.c                       |    7 
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c                 |   23 -
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                     |    3 
 drivers/net/ethernet/freescale/gianfar.c                       |    6 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c      |    4 
 drivers/net/ethernet/intel/i40e/i40e.h                         |    1 
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c                 |    3 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                 |   55 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |   11 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                    |   12 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c             |    9 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                     |    4 
 drivers/net/ethernet/intel/ice/ice.h                           |    4 
 drivers/net/ethernet/intel/ice/ice_common.c                    |    2 
 drivers/net/ethernet/intel/ice/ice_controlq.h                  |    4 
 drivers/net/ethernet/intel/ice/ice_dcb.c                       |   76 ++-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c                   |   47 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c                    |   52 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c                   |    8 
 drivers/net/ethernet/intel/ice/ice_lib.c                       |    7 
 drivers/net/ethernet/intel/ice/ice_main.c                      |   53 ++
 drivers/net/ethernet/intel/ice/ice_switch.c                    |   15 
 drivers/net/ethernet/intel/ice/ice_txrx.c                      |    2 
 drivers/net/ethernet/intel/ice/ice_type.h                      |   17 
 drivers/net/ethernet/mellanox/mlx5/core/dev.c                  |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                   |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c             |   36 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h              |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c     |   18 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c           |   22 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |   21 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c               |    5 
 drivers/net/ethernet/mellanox/mlx5/core/eq.c                   |   13 
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h                 |   15 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c            |    7 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c             |    7 
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c               |    2 
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c                  |    1 
 drivers/net/ethernet/netronome/nfp/flower/main.h               |    8 
 drivers/net/ethernet/netronome/nfp/flower/metadata.c           |   16 
 drivers/net/ethernet/netronome/nfp/flower/offload.c            |   48 ++
 drivers/net/geneve.c                                           |   24 +
 drivers/net/ieee802154/atusb.c                                 |    1 
 drivers/net/phy/bcm-phy-lib.c                                  |   13 
 drivers/net/tun.c                                              |   48 ++
 drivers/net/usb/hso.c                                          |   33 -
 drivers/net/vxlan.c                                            |   18 
 drivers/net/wan/hdlc_fr.c                                      |    5 
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c             |    2 
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c       |   31 -
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c            |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c           |   35 +
 drivers/of/property.c                                          |   11 
 drivers/platform/x86/intel-hid.c                               |   16 
 drivers/ras/cec.c                                              |   15 
 drivers/regulator/bd9571mwv-regulator.c                        |    4 
 drivers/remoteproc/pru_rproc.c                                 |    2 
 drivers/remoteproc/qcom_pil_info.c                             |    2 
 drivers/scsi/pm8001/pm8001_hwi.c                               |    8 
 drivers/scsi/ufs/ufshcd.c                                      |   31 -
 drivers/soc/fsl/qbman/qman.c                                   |    2 
 drivers/target/iscsi/iscsi_target.c                            |    3 
 drivers/thunderbolt/retimer.c                                  |    4 
 drivers/usb/usbip/stub_dev.c                                   |   11 
 drivers/usb/usbip/usbip_common.h                               |    3 
 drivers/usb/usbip/usbip_event.c                                |    2 
 drivers/usb/usbip/vhci_hcd.c                                   |    1 
 drivers/usb/usbip/vhci_sysfs.c                                 |   30 +
 drivers/usb/usbip/vudc_dev.c                                   |    1 
 drivers/usb/usbip/vudc_sysfs.c                                 |    5 
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                             |    4 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                              |   40 +-
 drivers/xen/events/events_base.c                               |   12 
 fs/cifs/Kconfig                                                |    3 
 fs/cifs/Makefile                                               |    5 
 fs/cifs/cifsfs.c                                               |    3 
 fs/cifs/connect.c                                              |   17 
 fs/direct-io.c                                                 |    5 
 fs/file.c                                                      |   21 -
 fs/hostfs/hostfs_kern.c                                        |    7 
 fs/namei.c                                                     |    8 
 fs/ocfs2/aops.c                                                |   11 
 fs/ocfs2/file.c                                                |    8 
 include/linux/avf/virtchnl.h                                   |    2 
 include/linux/mlx5/mlx5_ifc.h                                  |   10 
 include/linux/skmsg.h                                          |    7 
 include/linux/virtio_net.h                                     |    2 
 include/net/act_api.h                                          |   12 
 include/net/netns/xfrm.h                                       |    4 
 include/net/red.h                                              |    4 
 include/net/sock.h                                             |    9 
 include/net/xfrm.h                                             |    4 
 include/uapi/linux/can.h                                       |    2 
 include/uapi/linux/rfkill.h                                    |   80 +++-
 kernel/bpf/inode.c                                             |    2 
 kernel/bpf/stackmap.c                                          |   12 
 kernel/bpf/verifier.c                                          |    5 
 kernel/gcov/clang.c                                            |   29 -
 kernel/locking/lockdep.c                                       |    2 
 kernel/workqueue.c                                             |    2 
 mm/percpu-internal.h                                           |    2 
 mm/percpu-stats.c                                              |    9 
 mm/percpu.c                                                    |   14 
 net/batman-adv/translation-table.c                             |    2 
 net/can/bcm.c                                                  |   10 
 net/can/isotp.c                                                |   11 
 net/can/raw.c                                                  |   14 
 net/core/skmsg.c                                               |   12 
 net/core/sock.c                                                |   12 
 net/core/xdp.c                                                 |    3 
 net/dsa/dsa2.c                                                 |    8 
 net/ethtool/eee.c                                              |    4 
 net/hsr/hsr_device.c                                           |    1 
 net/hsr/hsr_forward.c                                          |    6 
 net/ieee802154/nl-mac.c                                        |    7 
 net/ieee802154/nl802154.c                                      |   23 -
 net/ipv4/ah4.c                                                 |    2 
 net/ipv4/esp4.c                                                |    2 
 net/ipv4/esp4_offload.c                                        |   17 
 net/ipv4/udp.c                                                 |    4 
 net/ipv6/ah6.c                                                 |    2 
 net/ipv6/esp6.c                                                |    2 
 net/ipv6/esp6_offload.c                                        |   17 
 net/ipv6/raw.c                                                 |    2 
 net/ipv6/route.c                                               |    8 
 net/mac80211/mlme.c                                            |    5 
 net/mac80211/tx.c                                              |    2 
 net/mac802154/llsec.c                                          |    2 
 net/mptcp/protocol.c                                           |  100 ++---
 net/ncsi/ncsi-manage.c                                         |   20 -
 net/nfc/llcp_sock.c                                            |   10 
 net/openvswitch/conntrack.c                                    |    8 
 net/qrtr/qrtr.c                                                |    5 
 net/rds/message.c                                              |    3 
 net/rfkill/core.c                                              |    7 
 net/sched/act_api.c                                            |   48 +-
 net/sched/cls_api.c                                            |   16 
 net/sched/sch_teql.c                                           |    3 
 net/sctp/ipv6.c                                                |    7 
 net/tipc/crypto.c                                              |    3 
 net/tipc/socket.c                                              |    2 
 net/wireless/nl80211.c                                         |   10 
 net/wireless/scan.c                                            |   14 
 net/wireless/sme.c                                             |    2 
 net/xfrm/xfrm_compat.c                                         |   12 
 net/xfrm/xfrm_device.c                                         |    2 
 net/xfrm/xfrm_interface.c                                      |    3 
 net/xfrm/xfrm_output.c                                         |   10 
 net/xfrm/xfrm_state.c                                          |   10 
 security/selinux/ss/avtab.c                                    |  101 +----
 security/selinux/ss/avtab.h                                    |    2 
 security/selinux/ss/conditional.c                              |   12 
 security/selinux/ss/services.c                                 |  157 ++++++--
 security/selinux/ss/sidtab.c                                   |   21 +
 security/selinux/ss/sidtab.h                                   |    4 
 sound/drivers/aloop.c                                          |   11 
 sound/pci/hda/patch_conexant.c                                 |    1 
 sound/pci/hda/patch_realtek.c                                  |   16 
 sound/soc/codecs/wm8960.c                                      |    8 
 sound/soc/intel/atom/sst-mfld-platform-pcm.c                   |    6 
 sound/soc/sof/intel/hda-dsp.c                                  |   15 
 sound/soc/sunxi/sun4i-codec.c                                  |    5 
 tools/lib/bpf/ringbuf.c                                        |    2 
 tools/lib/bpf/xsk.c                                            |   57 +-
 tools/perf/builtin-inject.c                                    |    2 
 tools/perf/util/block-info.c                                   |    6 
 224 files changed, 2058 insertions(+), 1018 deletions(-)

Adrian Hunter (1):
      perf inject: Fix repipe usage

Ahmed S. Darwish (1):
      net: xfrm: Localize sequence counter per network namespace

Al Viro (2):
      LOOKUP_MOUNTPOINT: we are cleaning "jumped" flag too late
      hostfs: fix memory handling in follow_link()

Alex Deucher (1):
      drm/amdgpu/smu7: fix CAC setting on TOPAZ

Alexander Aring (8):
      net: ieee802154: nl-mac: fix check on panid
      net: ieee802154: fix nl802154 del llsec key
      net: ieee802154: fix nl802154 del llsec dev
      net: ieee802154: fix nl802154 add llsec key
      net: ieee802154: fix nl802154 del llsec devkey
      net: ieee802154: forbid monitor for set llsec params
      net: ieee802154: forbid monitor for del llsec seclevel
      net: ieee802154: stop dump llsec params for monitors

Alexander Gordeev (1):
      s390/cpcmd: fix inline assembly register clobbering

Andy Shevchenko (2):
      i2c: designware: Adjust bus_freq_hz when refuse high speed mode set
      gpiolib: Read "gpio-line-names" from a firmware node

Anirudh Rayabharam (1):
      net: hso: fix null-ptr-deref during tty device unregistration

Anirudh Venkataramanan (2):
      ice: Continue probe on link/PHY errors
      ice: Use port number instead of PF ID for WoL

Antoine Tenart (2):
      vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
      geneve: do not modify the shared tunnel info when PMTU triggers an ICMP reply

Ariel Levkovich (1):
      net/mlx5e: Fix mapping of ct_label zero

Arkadiusz Kubalewski (4):
      i40e: Fix sparse warning: missing error code 'err'
      i40e: Fix sparse error: 'vsi->netdev' could be null
      i40e: Fix sparse error: uninitialized symbol 'ring'
      i40e: Fix sparse errors in i40e_txrx.c

Arnd Bergmann (3):
      remoteproc: qcom: pil_info: avoid 64-bit division
      soc/fsl: qbman: fix conflicting alignment attributes
      lockdep: Address clang -Wformat warning printing for %hd

Aya Levin (3):
      net/mlx5e: Fix ethtool indication of connector type
      net/mlx5: Fix PPLM register mapping
      net/mlx5: Fix PBMC register mapping

Bastian Germann (1):
      ASoC: sunxi: sun4i-codec: fill ASoC card owner

Ben Gardon (5):
      KVM: x86/mmu: change TDP MMU yield function returns to match cond_resched
      KVM: x86/mmu: Merge flush and non-flush tdp_mmu_iter_cond_resched
      KVM: x86/mmu: Rename goal_gfn to next_last_level_gfn
      KVM: x86/mmu: Ensure forward progress when yielding in TDP MMU iter
      KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed

Ben Greear (1):
      mac80211: fix time-is-after bug in mlme

Bruce Allan (1):
      ice: fix memory allocation call

Can Guo (2):
      scsi: ufs: core: Fix task management request completion timeout
      scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs

Carlos Leija (1):
      ARM: OMAP4: PM: update ROM return address for OSWR and OFF

Chinh T Cao (2):
      ice: Refactor DCB related variables out of the ice_port_info struct
      ice: Recognize 860 as iSCSI port in CEE mode

Christian Brauner (1):
      file: fix close_range() for unshare+cloexec

Christophe Leroy (2):
      powerpc/vdso: Make sure vdso_wrapper.o is rebuilt everytime vdso.so is rebuilt
      powerpc/ptrace: Don't return error when getting/setting FP regs without CONFIG_PPC_FPU_REGS

Ciara Loftus (3):
      libbpf: Ensure umem pointer is non-NULL before dereferencing
      libbpf: Restore umem state after socket create failure
      libbpf: Only create rx and tx XDP rings when necessary

Claudiu Beznea (1):
      net: macb: restore cmp registers on resume path

Claudiu Manoil (1):
      gianfar: Handle error code at MAC address change

Dan Carpenter (2):
      thunderbolt: Fix a leak in tb_retimer_add()
      thunderbolt: Fix off by one in tb_port_find_retimer()

Daniel Jurgens (1):
      net/mlx5: Don't request more than supported EQs

Dave Ertman (1):
      ice: remove DCBNL_DEVRESET bit from PF state

Dave Marchevsky (1):
      bpf: Refcount task stack in bpf_get_task_stack

Dmitry Baryshkov (1):
      drm/msm: a6xx: fix version check for the A650 SQE microcode

Dmitry Safonov (1):
      xfrm/compat: Cleanup WARN()s that can be user-triggered

Dom Cobley (1):
      drm/vc4: crtc: Reduce PV fifo threshold on hvs4

Du Cheng (1):
      cfg80211: remove WARN_ON() in cfg80211_sme_connect

Eli Cohen (3):
      vdpa/mlx5: Fix suspend/resume index restoration
      net/mlx5: Fix HW spec violation configuring uplink
      vdpa/mlx5: Fix wrong use of bit numbers

Eric Dumazet (2):
      net: ensure mac header is set in virtio_net_hdr_to_skb()
      sch_red: fix off-by-one checks in red_check_params()

Eryk Rybak (2):
      i40e: Fix kernel oops when i40e driver removes VF's
      i40e: Fix display statistics for veb_tc

Evan Nimmo (1):
      xfrm: Use actual socket sk instead of skb socket for xfrm_output_resume

Eyal Birger (1):
      xfrm: interface: fix ipv4 pmtu check to honor ip header df

Fabio Pricoco (1):
      ice: Increase control queue timeout

Florian Fainelli (1):
      net: phy: broadcom: Only advertise EEE for supported modes

Gao Xiang (1):
      parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers

Geert Uytterhoeven (1):
      regulator: bd9571mwv: Fix AVS and DVFS voltage range

Greg Kroah-Hartman (1):
      Linux 5.11.14

Gregory CLEMENT (1):
      Revert "arm64: dts: marvell: armada-cp110: Switch to per-port SATA interrupts"

Grzegorz Siwik (1):
      i40e: Fix parameters in aq_get_phy_register()

Guangbin Huang (1):
      net: hns3: clear VF down state bit before request link status

Guennadi Liakhovetski (1):
      ASoC: SOF: Intel: HDA: fix core status verification

Hans de Goede (2):
      ASoC: intel: atom: Stop advertising non working S24LE support
      platform/x86: intel-hid: Fix spurious wakeups caused by tablet-mode events during suspend

Helge Deller (1):
      parisc: parisc-agp requires SBA IOMMU driver

Ido Schimmel (1):
      mlxsw: spectrum: Fix ECN marking in tunnel decapsulation

Ilya Lipnitskiy (1):
      of: property: fw_devlink: do not link ".*,nr-gpios"

Ilya Maximets (1):
      openvswitch: fix send of uninitialized stack memory in ct limit reply

Jacek Bułatek (1):
      ice: Fix for dereference of NULL pointer

Jack Qiu (1):
      fs: direct-io: fix missing sdio->boundary

Jin Yao (1):
      perf report: Fix wrong LBR block sorting

Johannes Berg (6):
      rfkill: revert back to old userspace API by default
      iwlwifi: pcie: properly set LTR workarounds on 22000 devices
      nl80211: fix beacon head validation
      nl80211: fix potential leak of ACL params
      cfg80211: check S1G beacon compat element length
      mac80211: fix TXQ AC confusion

John Fastabend (2):
      bpf, sockmap: Fix sk->prot unhash op reset
      bpf, sockmap: Fix incorrect fwd_alloc accounting

Jonas Holmberg (1):
      ALSA: aloop: Fix initialization of controls

Kalyan Thota (1):
      drm/msm/disp/dpu1: program 3d_merge only if block is attached

Kamal Heib (1):
      RDMA/qedr: Fix kernel panic when trying to access recv_cq

Krzysztof Goreczny (1):
      ice: prevent ice_open and ice_stop during reset

Krzysztof Kozlowski (1):
      clk: socfpga: fix iomem pointer cast on 64-bit

Kumar Kartikeya Dwivedi (1):
      net: sched: bump refcount for new action in ACT replace mode

Kurt Kanzenbach (1):
      net: hsr: Reset MAC header for Tx path

Leon Romanovsky (1):
      RDMA/addr: Be strict with gid size

Loic Poulain (1):
      net: qrtr: Fix memory leak on qrtr_tx_wait failure

Lorenz Bauer (1):
      bpf: link: Refuse non-O_RDWR flags in BPF_OBJ_GET

Luca Coelho (1):
      iwlwifi: fix 11ax disabled bit in the regulatory capability flags

Luca Fancellu (1):
      xen/evtchn: Change irq_info lock to raw_spinlock_t

Lukasz Bartosik (2):
      clk: fix invalid usage of list cursor in register
      clk: fix invalid usage of list cursor in unregister

Lv Yunlong (5):
      ethernet/netronome/nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx
      drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit
      ethernet: myri10ge: Fix a use after free in myri10ge_sw_tso
      net:tipc: Fix a double free in tipc_sk_mcast_rcv
      net/rds: Fix a use after free in rds_message_map_pages

Maciej Żenczykowski (1):
      net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()

Maciek Borzecki (1):
      cifs: escape spaces in share names

Magnus Karlsson (1):
      i40e: fix receiving of single packets in xsk zero-copy mode

Maor Dickman (1):
      net/mlx5: Delete auxiliary bus driver eth-rep first

Marc Kleine-Budde (2):
      can: uapi: can.h: mark union inside struct can_frame packed
      can: mcp251x: fix support for half duplex SPI host controllers

Marek Behún (1):
      ARM: dts: turris-omnia: configure LED[2]/INTn pin as interrupt pin

Martin Blumenstingl (3):
      net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock
      net: dsa: lantiq_gswip: Don't use PHY auto polling
      net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits

Mateusz Palczewski (1):
      i40e: Added Asym_Pause to supported link modes

Maxim Kochetkov (1):
      net: dsa: Fix type was not set for devlink port

Md Haris Iqbal (1):
      RDMA/rtrs-clt: Close rtrs client conn before destroying rtrs clt session files

Mike Marciniszyn (1):
      IB/hfi1: Fix probe time panic when AIP is enabled with a buggy BIOS

Mike Rapoport (1):
      nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff

Milton Miller (1):
      net/ncsi: Avoid channel_monitor hrtimer deadlock

Muhammad Usama Anjum (1):
      net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh

Nick Desaulniers (1):
      gcov: re-fix clang-11+ support

Norbert Ciosek (1):
      virtchnl: Fix layout of RSS structures

Norman Maurer (1):
      net: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);

Oliver Hartkopp (2):
      can: bcm/raw: fix msg_namelen values depending on CAN_REQUIRED_SIZE
      can: isotp: fix msg_namelen values depending on CAN_REQUIRED_SIZE

Oliver Stäbler (1):
      arm64: dts: imx8mm/q: Fix pad control of SD1_DATA0

Ondrej Mosnacek (3):
      selinux: make nslot handling in avtab more robust
      selinux: fix cond_list corruption when changing booleans
      selinux: fix race between old and new sidtab

Ong Boon Leong (1):
      xdp: fix xdp_return_frame() kernel BUG throw for page_pool memory model

Paolo Abeni (3):
      net: let skb_orphan_partial wake-up waiters.
      mptcp: forbit mcast-related sockopt on MPTCP sockets
      mptcp: revert "mptcp: provide subflow aware release function"

Paolo Bonzini (1):
      KVM: x86/mmu: preserve pending TLB flush across calls to kvm_tdp_mmu_zap_sp

Pavel Skripkin (3):
      drivers: net: fix memory leak in atusb_probe
      drivers: net: fix memory leak in peak_usb_create_dev
      net: mac802154: Fix general protection fault

Pavel Tikhomirov (1):
      net: sched: sch_teql: fix null-pointer dereference

Pedro Tammela (1):
      libbpf: Fix bail out from 'ringbuf_process_ring()' on error

Phillip Potter (1):
      net: tun: set tun->dev->addr_len during TUNSETLINK processing

Potnuri Bharat Teja (1):
      RDMA/cxgb4: check for ipv6 address properly while destroying listener

Raed Salem (1):
      net/mlx5: Fix placement of log_max_flow_counter

Rafał Miłecki (1):
      dt-bindings: net: ethernet-controller: fix typo in NVMEM

Rahul Lakkireddy (1):
      cxgb4: avoid collecting SGE_QBASE regs during traffic

Robert Malz (1):
      ice: Cleanup fltr list in case of allocation issues

Roman Bolshakov (1):
      scsi: target: iscsi: Fix zero tag inside a trace event

Roman Gushchin (1):
      percpu: make pcpu_nr_empty_pop_pages per chunk type

Rui Salvaterra (1):
      ARM: dts: turris-omnia: fix hardware buffer management

Saravana Kannan (1):
      driver core: Fix locking bug in deferred_probe_timeout_work_func()

Sean Christopherson (3):
      KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range zap
      KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
      KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages

Sergei Trofimovich (1):
      ia64: fix user_stack_pointer() for ptrace()

Shengjiu Wang (1):
      ASoC: wm8960: Fix wrong bclk and lrclk with pll enabled for some chips

Shuah Khan (4):
      usbip: add sysfs_lock to synchronize sysfs code paths
      usbip: stub-dev synchronize sysfs code paths
      usbip: vudc synchronize sysfs code paths
      usbip: synchronize event handler with sysfs code paths

Shyam Prasad N (1):
      cifs: On cifs_reconnect, resolve the hostname again.

Shyam Sundar S K (1):
      amd-xgbe: Update DMA coherency values

Si-Wei Liu (1):
      vdpa/mlx5: should exclude header length and fcs from mtu

Stefan Riedmueller (1):
      ARM: dts: imx6: pbab01: Set vmmc supply for both SD interfaces

Steffen Klassert (2):
      xfrm: Fix NULL pointer dereference on policy lookup
      xfrm: Provide private skb extensions for segmented and hw offloaded ESP packets

Stephen Boyd (1):
      drm/msm: Set drvdata to NULL when msm_drm_init() fails

Suman Anna (1):
      remoteproc: pru: Fix firmware loading crashes on K3 SoCs

Takashi Iwai (3):
      ALSA: hda/realtek: Fix speaker amp setup on Acer Aspire E1
      ALSA: hda/conexant: Apply quirk for another HP ZBook G5 model
      drm/i915: Fix invalid access to ACPI _DSM objects

Taniya Das (1):
      clk: qcom: camcc: Update the clock ops for the SC7180

Tariq Toukan (1):
      net/mlx5e: Guarantee room for XSK wakeup NOP on async ICOSQ

Tetsuo Handa (1):
      batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field

Thomas Tai (1):
      x86/traps: Correct exc_general_protection() and math_error() return paths

Toke Høiland-Jørgensen (1):
      bpf: Enforce that struct_ops programs be GPL-only

Tony Lindgren (1):
      ARM: OMAP4: Fix PMIC voltage domains for bionic

Viswas G (1):
      scsi: pm80xx: Fix chip initialization failure

Vitaly Kuznetsov (1):
      ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m

Vlad Buslov (3):
      net: sched: fix action overwrite reference counting
      net: sched: fix err handler in tcf_action_init()
      Revert "net: sched: bump refcount for new action in ACT replace mode"

Wengang Wang (1):
      ocfs2: fix deadlock between setattr and dio_end_io_write

William Roche (1):
      RAS/CEC: Correct ce_add_elem()'s returned values

Wolfram Sang (1):
      i2c: turn recovery error on init to debug

Wong Vee Khee (1):
      ethtool: fix incorrect datatype in set_eee ops

Xiaoming Ni (4):
      nfc: fix refcount leak in llcp_sock_bind()
      nfc: fix refcount leak in llcp_sock_connect()
      nfc: fix memory leak in llcp_sock_connect()
      nfc: Avoid endless loops caused by repeated llcp_sock_connect()

Xin Long (2):
      esp: delete NETIF_F_SCTP_CRC bit from features for esp offload
      tipc: increment the tmp aead refcnt before attaching it

Yinjun Zhang (1):
      nfp: flower: ignore duplicate merge hints from FW

Yongxin Liu (1):
      ice: fix memory leak of aRFS after resuming from suspend

Yunjian Wang (1):
      net: cls_api: Fix uninitialised struct field bo->unlocked_driver_cb

Zqiang (1):
      workqueue: Move the position of debug_work_activate() in __queue_work()

xinhui pan (2):
      drm/radeon: Fix size overflow
      drm/amdgpu: Fix size overflow

周琰杰 (Zhou Yanjie) (1):
      I2C: JZ4780: Fix bug for Ingenic X1000.

