Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A316D02D8
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 13:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjC3LRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 07:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbjC3LQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 07:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07D94EF1;
        Thu, 30 Mar 2023 04:16:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35A0BB82101;
        Thu, 30 Mar 2023 11:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3ABC433EF;
        Thu, 30 Mar 2023 11:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680174983;
        bh=hSs9j2pQMwM4OwSKBfIlINlWGjmezOqfQvMTJ7rBGI4=;
        h=From:To:Cc:Subject:Date:From;
        b=1e/WM1QHcg+Af86wlbW71+PbDC6Cv3no8sC0DqJGUvat7pjytD6seKnvNc4Em0RPG
         1S/bulOEp3/Jaxq7M+6cTkl/gfcBsN/+CrkFIHuy4CZzO1FWcvjqvDpPLRGLJBqtwe
         yvBpFzZ4rY+4kKjxre9x+x0C/N/nSbPpmCfttpIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.22
Date:   Thu, 30 Mar 2023 13:16:15 +0200
Message-Id: <1680174975234192@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.22 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/boot/dts/e60k02.dtsi                                  |    1 
 arch/arm/boot/dts/e70k02.dtsi                                  |    1 
 arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts                   |    1 
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts                  |    6 
 arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts           |    2 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                      |    5 
 arch/arm64/boot/dts/freescale/imx93.dtsi                       |   16 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                           |    2 
 arch/arm64/boot/dts/qcom/sm8150.dtsi                           |    4 
 arch/arm64/boot/dts/qcom/sm8450.dtsi                           |    1 
 arch/m68k/kernel/traps.c                                       |    4 
 arch/m68k/mm/motorola.c                                        |   10 
 arch/riscv/Kconfig                                             |   22 
 arch/riscv/Makefile                                            |   10 
 arch/riscv/include/asm/tlbflush.h                              |    2 
 arch/riscv/include/uapi/asm/setup.h                            |    8 
 arch/riscv/mm/context.c                                        |    2 
 arch/riscv/mm/tlbflush.c                                       |    2 
 arch/sh/include/asm/processor_32.h                             |    1 
 arch/sh/kernel/signal_32.c                                     |    3 
 arch/x86/events/amd/core.c                                     |    3 
 arch/x86/kernel/fpu/xstate.c                                   |   30 
 drivers/acpi/x86/s2idle.c                                      |   24 
 drivers/acpi/x86/utils.c                                       |   37 -
 drivers/atm/idt77252.c                                         |   11 
 drivers/bluetooth/btqcomsmd.c                                  |   17 
 drivers/bluetooth/btsdio.c                                     |    1 
 drivers/bluetooth/btusb.c                                      |   10 
 drivers/bus/imx-weim.c                                         |    2 
 drivers/firmware/arm_scmi/mailbox.c                            |   37 +
 drivers/firmware/efi/libstub/smbios.c                          |    2 
 drivers/firmware/efi/sysfb_efi.c                               |    5 
 drivers/firmware/sysfb.c                                       |    4 
 drivers/firmware/sysfb_simplefb.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                            |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c                       |   41 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                     |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                        |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                     |    2 
 drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c                         |   14 
 drivers/gpu/drm/amd/amdgpu/nv.c                                |    2 
 drivers/gpu/drm/amd/amdgpu/vi.c                                |   17 
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c                          |  364 ++--------
 drivers/gpu/drm/amd/amdkfd/kfd_crat.h                          |   12 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                        |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c                      |  245 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_topology.h                      |    5 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c     |   19 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                  |    9 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c              |    3 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c             |    4 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c          |    1 
 drivers/gpu/drm/bridge/lontium-lt8912b.c                       |    4 
 drivers/gpu/drm/i915/display/intel_display.c                   |    1 
 drivers/gpu/drm/i915/display/intel_fbdev.c                     |   28 
 drivers/gpu/drm/i915/gt/intel_gt.c                             |    4 
 drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c                 |   30 
 drivers/gpu/drm/i915/i915_active.c                             |    3 
 drivers/gpu/drm/i915/i915_gpu_error.h                          |    2 
 drivers/gpu/drm/meson/meson_drv.c                              |   13 
 drivers/gpu/drm/tiny/cirrus.c                                  |    2 
 drivers/hid/hid-cp2112.c                                       |    1 
 drivers/hid/hid-logitech-hidpp.c                               |    2 
 drivers/hid/intel-ish-hid/ipc/ipc.c                            |    9 
 drivers/hwmon/hwmon.c                                          |    7 
 drivers/hwmon/it87.c                                           |    4 
 drivers/i2c/busses/i2c-hisi.c                                  |    6 
 drivers/i2c/busses/i2c-imx-lpi2c.c                             |    4 
 drivers/i2c/busses/i2c-mxs.c                                   |   18 
 drivers/i2c/busses/i2c-xgene-slimpro.c                         |    3 
 drivers/interconnect/qcom/osm-l3.c                             |    2 
 drivers/interconnect/qcom/qcm2290.c                            |    4 
 drivers/interconnect/qcom/sm8450.c                             |   98 --
 drivers/md/dm-crypt.c                                          |   16 
 drivers/md/dm-stats.c                                          |    7 
 drivers/md/dm-stats.h                                          |    2 
 drivers/md/dm-thin.c                                           |    2 
 drivers/md/dm.c                                                |    4 
 drivers/net/dsa/b53/b53_mmap.c                                 |    2 
 drivers/net/dsa/mt7530.c                                       |   49 -
 drivers/net/ethernet/google/gve/gve_ethtool.c                  |    5 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                    |    8 
 drivers/net/ethernet/intel/iavf/iavf_common.c                  |    2 
 drivers/net/ethernet/intel/iavf/iavf_main.c                    |   13 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                    |    2 
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                |    2 
 drivers/net/ethernet/intel/ice/ice_sriov.c                     |    8 
 drivers/net/ethernet/intel/igb/igb_main.c                      |    2 
 drivers/net/ethernet/intel/igbvf/netdev.c                      |    8 
 drivers/net/ethernet/intel/igbvf/vf.c                          |   13 
 drivers/net/ethernet/intel/igc/igc_main.c                      |   20 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c           |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c      |    9 
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c             |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |    6 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c |    3 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c              |    1 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c     |   19 
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c             |  216 +----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c             |    4 
 drivers/net/ethernet/natsemi/sonic.c                           |    4 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c                    |    5 
 drivers/net/ethernet/qualcomm/emac/emac.c                      |    6 
 drivers/net/ethernet/stmicro/stmmac/common.h                   |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c                |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c              |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c           |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |   30 
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                   |   41 -
 drivers/net/ethernet/toshiba/ps3_gelic_net.h                   |    5 
 drivers/net/ethernet/xircom/xirc2ps_cs.c                       |    5 
 drivers/net/ieee802154/ca8210.c                                |    2 
 drivers/net/mdio/acpi_mdio.c                                   |   10 
 drivers/net/mdio/mdio-thunder.c                                |    1 
 drivers/net/mdio/of_mdio.c                                     |   12 
 drivers/net/phy/mdio_devres.c                                  |   11 
 drivers/net/phy/phy.c                                          |   23 
 drivers/net/usb/asix_devices.c                                 |   32 
 drivers/net/usb/cdc_mbim.c                                     |    5 
 drivers/net/usb/lan78xx.c                                      |   18 
 drivers/net/usb/qmi_wwan.c                                     |    1 
 drivers/net/usb/smsc95xx.c                                     |    6 
 drivers/platform/chrome/cros_ec_chardev.c                      |    2 
 drivers/platform/x86/intel/int3472/tps68470_board_data.c       |    5 
 drivers/power/supply/bq24190_charger.c                         |    1 
 drivers/power/supply/da9150-charger.c                          |    1 
 drivers/scsi/device_handler/scsi_dh_alua.c                     |    6 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                         |    3 
 drivers/scsi/lpfc/lpfc_init.c                                  |    2 
 drivers/scsi/lpfc/lpfc_sli.c                                   |   12 
 drivers/scsi/mpi3mr/mpi3mr_app.c                               |    4 
 drivers/scsi/mpi3mr/mpi3mr_fw.c                                |   19 
 drivers/scsi/mpi3mr/mpi3mr_transport.c                         |   15 
 drivers/scsi/qla2xxx/qla_gbl.h                                 |    1 
 drivers/scsi/qla2xxx/qla_init.c                                |    3 
 drivers/scsi/qla2xxx/qla_isr.c                                 |    3 
 drivers/scsi/qla2xxx/qla_os.c                                  |   21 
 drivers/scsi/scsi_devinfo.c                                    |    1 
 drivers/scsi/storvsc_drv.c                                     |   16 
 drivers/soc/qcom/llcc-qcom.c                                   |    6 
 drivers/target/iscsi/iscsi_target_parameters.c                 |   12 
 drivers/tee/amdtee/core.c                                      |   29 
 drivers/thunderbolt/debugfs.c                                  |   12 
 drivers/thunderbolt/nhi.c                                      |   49 -
 drivers/thunderbolt/nhi_regs.h                                 |    6 
 drivers/thunderbolt/quirks.c                                   |   13 
 drivers/thunderbolt/retimer.c                                  |   23 
 drivers/thunderbolt/sb_regs.h                                  |    1 
 drivers/thunderbolt/switch.c                                   |    4 
 drivers/thunderbolt/tb.h                                       |   12 
 drivers/thunderbolt/usb4.c                                     |   36 
 drivers/tty/hvc/hvc_xen.c                                      |   19 
 drivers/ufs/core/ufshcd.c                                      |    1 
 drivers/usb/cdns3/cdns3-pci-wrap.c                             |    5 
 drivers/usb/cdns3/cdnsp-ep0.c                                  |   19 
 drivers/usb/cdns3/cdnsp-pci.c                                  |   27 
 drivers/usb/chipidea/ci.h                                      |    2 
 drivers/usb/chipidea/core.c                                    |   11 
 drivers/usb/chipidea/otg.c                                     |    5 
 drivers/usb/dwc2/drd.c                                         |    3 
 drivers/usb/dwc2/platform.c                                    |   16 
 drivers/usb/dwc3/gadget.c                                      |   14 
 drivers/usb/gadget/function/u_audio.c                          |    2 
 drivers/usb/misc/onboard_usb_hub.c                             |    1 
 drivers/usb/misc/onboard_usb_hub.h                             |    1 
 drivers/usb/storage/unusual_uas.h                              |    7 
 drivers/usb/typec/tcpm/tcpm.c                                  |   28 
 drivers/usb/typec/ucsi/ucsi.c                                  |   11 
 drivers/usb/typec/ucsi/ucsi_acpi.c                             |    2 
 fs/btrfs/zoned.c                                               |   14 
 fs/cifs/cached_dir.c                                           |   37 -
 fs/cifs/cifs_debug.c                                           |   46 -
 fs/cifs/cifsfs.c                                               |    9 
 fs/cifs/cifssmb.c                                              |    6 
 fs/cifs/connect.c                                              |   14 
 fs/cifs/fs_context.h                                           |    2 
 fs/cifs/link.c                                                 |    2 
 fs/cifs/smb2inode.c                                            |    1 
 fs/cifs/smb2ops.c                                              |   27 
 fs/cifs/smb2pdu.c                                              |   12 
 fs/cifs/trace.h                                                |   12 
 fs/ksmbd/auth.c                                                |    5 
 fs/ksmbd/connection.c                                          |   11 
 fs/ksmbd/connection.h                                          |    3 
 fs/ksmbd/smb2pdu.c                                             |   20 
 fs/ksmbd/smb_common.c                                          |   27 
 fs/ksmbd/smb_common.h                                          |   30 
 fs/ksmbd/transport_rdma.c                                      |    2 
 fs/ksmbd/transport_tcp.c                                       |   35 
 fs/lockd/clnt4xdr.c                                            |    9 
 fs/lockd/xdr4.c                                                |   13 
 fs/nfs/read.c                                                  |    3 
 fs/nfsd/vfs.c                                                  |    9 
 fs/nilfs2/ioctl.c                                              |    2 
 fs/super.c                                                     |   15 
 fs/verity/verify.c                                             |   12 
 include/linux/acpi_mdio.h                                      |    9 
 include/linux/context_tracking.h                               |    1 
 include/linux/context_tracking_state.h                         |    2 
 include/linux/lockd/xdr4.h                                     |    1 
 include/linux/nvme-tcp.h                                       |    5 
 include/linux/of_mdio.h                                        |   22 
 include/linux/stmmac.h                                         |    2 
 include/linux/sysfb.h                                          |    9 
 io_uring/filetable.c                                           |    3 
 io_uring/net.c                                                 |   25 
 io_uring/rsrc.c                                                |    1 
 kernel/bpf/core.c                                              |    2 
 kernel/entry/common.c                                          |    5 
 kernel/events/core.c                                           |    4 
 kernel/sched/core.c                                            |    3 
 kernel/sched/fair.c                                            |   54 +
 kernel/trace/trace_hwlat.c                                     |    4 
 lib/maple_tree.c                                               |   24 
 lib/test_maple_tree.c                                          |   48 +
 mm/kfence/Makefile                                             |    2 
 mm/kfence/core.c                                               |   10 
 mm/ksm.c                                                       |   11 
 mm/page_alloc.c                                                |    3 
 mm/slab.c                                                      |    2 
 net/bluetooth/hci_core.c                                       |   23 
 net/bluetooth/hci_sync.c                                       |   68 +
 net/bluetooth/iso.c                                            |    9 
 net/bluetooth/l2cap_core.c                                     |  117 ++-
 net/bluetooth/mgmt.c                                           |    9 
 net/dsa/tag_brcm.c                                             |   10 
 net/ipv4/ip_gre.c                                              |    4 
 net/ipv6/ip6_gre.c                                             |    4 
 net/mac80211/wme.c                                             |    6 
 net/mptcp/protocol.c                                           |   63 -
 net/mptcp/protocol.h                                           |    6 
 net/mptcp/subflow.c                                            |  116 ---
 net/sched/act_mirred.c                                         |   23 
 net/xdp/xdp_umem.c                                             |   13 
 security/keys/request_key.c                                    |    9 
 sound/soc/amd/yc/acp6x-mach.c                                  |   14 
 tools/bootconfig/test-bootconfig.sh                            |   12 
 tools/testing/selftests/bpf/prog_tests/btf.c                   |   28 
 tools/testing/selftests/net/forwarding/tc_actions.sh           |   49 +
 tools/testing/selftests/x86/amx.c                              |  108 ++
 241 files changed, 2334 insertions(+), 1436 deletions(-)

AKASHI Takahiro (1):
      igc: fix the validation logic for taprio's gate list

Abel Vesa (1):
      soc: qcom: llcc: Fix slice configuration values for SC8280XP

Adrien Thierry (1):
      scsi: ufs: core: Add soft dependency on governor_simpleondemand

Ahmed Zaki (1):
      iavf: do not track VLAN 0 filters

Akihiko Odaki (1):
      igbvf: Regard vf reset nack as success

Al Viro (1):
      sh: sanitize the flags on sigreturn

Alexander Aring (1):
      ca8210: fix mac_len negative array access

Alexander Lobakin (2):
      iavf: fix inverted Rx hash condition leading to disabled hash
      iavf: fix non-tunneled IPv6 UDP packet type and hashing

Alexander Stein (3):
      arm64: dts: imx93: add missing #address-cells and #size-cells to i2c nodes
      i2c: imx-lpi2c: check only for enabled interrupt flags
      usb: misc: onboard-hub: add support for Microchip USB2517 USB 2.0 hub

Alexandr Sapozhnikov (1):
      drm/cirrus: NULL-check pipe->plane.state->fb in cirrus_pipe_update()

Alexandre Ghiti (1):
      riscv: Bump COMMAND_LINE_SIZE value to 1024

Alvin Šipraga (1):
      usb: gadget: u_audio: don't let userspace block driver unbind

Andrew Halaney (1):
      arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio

Andrzej Hajda (1):
      drm/i915/gt: perform uc late init after probe error injection

Ard Biesheuvel (1):
      efi/libstub: smbios: Use length member instead of record struct size

Arınç ÜNAL (3):
      net: dsa: mt7530: move enabling disabling core clock to mt7530_pll_setup()
      net: dsa: mt7530: move lowering TRGMII driving to mt7530_setup()
      net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case

Aurabindo Pillai (1):
      drm/amd/display: fix k1 k2 divider programming for phantom streams

Breno Leitao (1):
      perf/x86/amd/core: Always clear status for idx

Brian Gix (1):
      Bluetooth: Remove "Power-on" check from Mesh feature

Caleb Sander (1):
      nvme-tcp: fix nvme_tcp_term_pdu to match spec

Chang S. Bae (2):
      x86/fpu/xstate: Prevent false-positive warning in __copy_xstate_uabi_buf()
      selftests/x86/amx: Add a ptrace test

ChenXiaoSong (1):
      ksmbd: fix possible refcount leak in smb2_open()

Coly Li (1):
      dm thin: fix deadlock when swapping to thin device

Costa Shulyupin (1):
      tracing/hwlat: Replace sched_setaffinity with set_cpus_allowed_ptr

Cristian Marussi (1):
      firmware: arm_scmi: Fix device node validation for mailbox transport

Cruise Hung (1):
      drm/amd/display: Fix DP MST sinks removal issue

Dan Carpenter (1):
      net/mlx5: E-Switch, Fix an Oops in error handling code

Daniel Borkmann (1):
      bpf: Adjust insufficient default bpf_jit_limit

Daniel Lezcano (1):
      thermal/drivers/mellanox: Use generic thermal_zone_get_trip() function

Daniel Scally (1):
      platform/x86: int3472: Add GPIOs to Surface Go 3 Board data

Daniel Wagner (1):
      scsi: qla2xxx: Add option to disable FC2 Target support

Daniil Tatianin (1):
      qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info

Danny Kaehn (1):
      HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded

Dave Wysochanski (1):
      NFS: Fix /proc/PID/io read_bytes for buffered reads

David Howells (1):
      keys: Do not cache key in task struct if key is requested from kernel thread

Davide Caratti (2):
      net/sched: act_mirred: better wording on protection against excessive stack growth
      act_mirred: use the backlog for nested calls to mirred ingress

Dmitry Baryshkov (2):
      interconnect: qcom: osm-l3: fix icc_onecell_data allocation
      interconnect: qcom: sm8450: switch to qcom_icc_rpmh_* function

Duc Anh Le (1):
      ASoC: amd: yc: Add DMI entries to support HP OMEN 16-n0xxx (8A43)

Dylan Jhong (1):
      riscv: mm: Fix incorrect ASID argument when flushing TLB

Emeel Hakim (1):
      net/mlx5e: Overcome slow response for first macsec ASO WQE

Enrico Sau (2):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
      net: usb: qmi_wwan: add Telit 0x1080 composition

Eric Bernstein (1):
      drm/amd/display: Include virtual signal to set k1 and k2 values

Eric Biggers (1):
      fscrypt: destroy keyring after security_sb_delete()

Eric Dumazet (1):
      erspan: do not use skb_mac_header() in ndo_start_xmit()

Fabrice Gasnier (1):
      usb: dwc2: fix a devres leak in hw_enable upon suspend resume

Felix Fietkau (1):
      wifi: mac80211: fix qos on mesh interfaces

Florian Fainelli (2):
      net: phy: Ensure state transitions are processed from phy_stop()
      net: mdio: fix owner field for mdio buses registered using ACPI

Frank Crawford (1):
      hwmon (it87): Fix voltage scaling for chips with 10.9mV ADCs

Frederic Weisbecker (1):
      entry/rcu: Check TIF_RESCHED _after_ delayed RCU wake-up

Gaosheng Cui (1):
      intel/igbvf: free irq on the error path in igbvf_request_msix()

Gavin Li (2):
      net/mlx5e: Set uplink rep as NETNS_LOCAL
      net/mlx5e: Block entering switchdev mode with ns inconsistency

Geert Uytterhoeven (1):
      mm/slab: Fix undefined init_cache_node_node() for NUMA and !SMP

Geoff Levand (2):
      net/ps3_gelic_net: Fix RX sk_buff length
      net/ps3_gelic_net: Use dma_mapping_error

Gil Fine (1):
      thunderbolt: Add missing UNSET_INBOUND_SBTX for retimer access

Grant Grundler (1):
      net: asix: fix modprobe "sysfs: cannot create duplicate filename"

Greg Kroah-Hartman (1):
      Linux 6.1.22

Hans de Goede (3):
      efi: sysfb_efi: Fix DMI quirks not working for simpledrm
      usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()
      usb: ucsi_acpi: Increase the command completion timeout

Hersen Wu (2):
      drm/amd/display: Set dcn32 caps.seamless_odm
      drm/amd/display: fix wrong index used in dccg32_set_dpstreamclk

Howard Chung (1):
      Bluetooth: mgmt: Fix MGMT add advmon with RSSI command

Ido Schimmel (2):
      mlxsw: core_thermal: Fix fan speed in maximum cooling state
      mlxsw: spectrum_fid: Fix incorrect local port type

Ivan Bornyakov (1):
      bus: imx-weim: fix branch condition evaluates to a garbage value

Jakob Koschel (1):
      scsi: lpfc: Avoid usage of list iterator variable after loop

Jeff Layton (2):
      nfsd: don't replace page in rq_pages if it's a continuation of last page
      lockd: set file_lock start and end when decoding nlm4 testargs

Jens Axboe (1):
      io_uring/net: avoid sending -ECONNABORTED on repeated connection requests

Jiasheng Jiang (2):
      octeontx2-vf: Add missing free for alloc_percpu
      dm stats: check for and propagate alloc_percpu failure

Jochen Henneberg (1):
      net: stmmac: Fix for mismatched host/device DMA address width

Joel Selvaraj (1):
      scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR

Johan Hovold (1):
      drm/meson: fix missing component unbind on bind errors

John Harrison (2):
      drm/i915/guc: Rename GuC register state capture node to be more obvious
      drm/i915/guc: Fix missing ecodes

Joseph Hunkeler (1):
      ASoC: amd: yp: Add OMEN by HP Gaming Laptop 16z-n000 to quirks

Josh Poimboeuf (1):
      entry: Fix noinstr warning in __enter_from_user_mode()

Joshua Washington (1):
      gve: Cache link_speed value from device

Justin Tee (1):
      scsi: lpfc: Check kzalloc() in lpfc_sli4_cgn_params_read()

Kai-Heng Feng (1):
      drm/amdgpu/nv: Apply ASPM quirk on Intel ADL + AMD Navi

Kal Conley (1):
      xsk: Add missing overflow check in xdp_umem_reg

Kang Chen (1):
      scsi: hisi_sas: Check devm_add_action() return value

Kars de Jong (1):
      m68k: mm: Fix systems with memory at end of 32-bit address space

Konrad Dybcio (1):
      interconnect: qcom: qcm2290: Fix MASTER_SNOC_BIMC_NRT

Krishna chaitanya chundru (1):
      arm64: dts: qcom: sc7280: Mark PCIe controller as cache coherent

Krzysztof Kozlowski (1):
      arm64: dts: imx8mm-nitrogen-r2: fix WM8960 clock name

Lama Kayal (1):
      net/mlx5: Fix steering rules cleanup

Li Zetao (1):
      atm: idt77252: fix kmemleak when rmmod idt77252

Liam R. Howlett (3):
      test_maple_tree: add more testing for mas_empty_area()
      maple_tree: fix mas_skip_node() end slot detection
      mm/ksm: fix race with VMA iteration and mm_struct teardown

Liang He (1):
      net: mdio: thunder: Add missing fwnode_handle_put()

Lin Ma (1):
      igb: revert rtnl_lock() that causes deadlock

Lorenz Bauer (1):
      selftests/bpf: check that modifier resolves after pointer

Luiz Augusto von Dentz (3):
      Bluetooth: hci_core: Detect if an ACL packet is in fact an ISO packet
      Bluetooth: btusb: Remove detection of ISO packets over bulk
      Bluetooth: L2CAP: Fix responding with wrong PDU type

Ma Jun (2):
      drm/amdkfd: Fix the warning of array-index-out-of-bounds
      drm/amdkfd: Fix the memory overrun

Maher Sanalla (1):
      net/mlx5: Read the TC mapping of all priorities on ETS query

Manivannan Sadhasivam (2):
      arm64: dts: qcom: sm8450: Mark UFS controller as cache coherent
      arm64: dts: qcom: sm8150: Fix the iommu mask used for PCIe controllers

Marco Elver (1):
      kfence: avoid passing -g for test

Marek Vasut (1):
      arm64: dts: imx8mn: specify #sound-dai-cells for SAI nodes

Mario Limonciello (5):
      thunderbolt: Disable interrupt auto clear for rings
      thunderbolt: Use const qualifier for `ring_interrupt_index`
      ACPI: x86: Drop quirk for HP Elitebook
      ACPI: x86: utils: Add Cezanne to the list for forcing StorageD3Enable
      drm/amd: Fix initialization mistake for NBIO 7.3.0

Masami Hiramatsu (Google) (1):
      bootconfig: Fix testcase to increase max node

Matheus Castello (1):
      drm/bridge: lt8912b: return EPROBE_DEFER if bridge is not found

Matthias Schiffer (1):
      i2c: mxs: ensure that DMA buffers are safe for DMA

Maurizio Lombardi (1):
      scsi: target: iscsi: Fix an error message in iscsi_check_key()

Maxime Bizon (1):
      net: mdio: fix owner field for mdio buses registered using device-tree

Michael Kelley (1):
      scsi: storvsc: Handle BlockSize change in Hyper-V VHD/VHDX file

Michael Schmitz (1):
      m68k: Only force 030 bus error if PC not in exception table

Michal Swiatkowski (1):
      ice: check if VF exists before mode check

Mika Westerberg (3):
      thunderbolt: Use scale field when allocating USB3 bandwidth
      thunderbolt: Call tb_check_quirks() after initializing adapters
      thunderbolt: Fix memory leak in margining

Mike Snitzer (1):
      dm crypt: avoid accessing uninitialized tasklet

Mikulas Patocka (1):
      dm crypt: add cond_resched() to dmcrypt_write()

Min Li (1):
      Bluetooth: Fix race condition in hci_cmd_sync_clear

Muchun Song (1):
      mm: kfence: fix using kfence_metadata without initialization in show_object()

Namjae Jeon (7):
      ksmbd: add low bound validation to FSCTL_SET_ZERO_DATA
      ksmbd: add low bound validation to FSCTL_QUERY_ALLOCATED_RANGES
      ksmbd: fix wrong signingkey creation when encryption is AES256
      ksmbd: set FILE_NAMED_STREAMS attribute in FS_ATTRIBUTE_INFORMATION
      ksmbd: don't terminate inactive sessions after a few seconds
      ksmbd: return STATUS_NOT_SUPPORTED on unsupported smb2.0 dialect
      ksmbd: return unsupported error on smb1 mount

Naohiro Aota (1):
      btrfs: zoned: fix btrfs_can_activate_zone() to support DUP profile

Nathan Chancellor (1):
      riscv: Handle zicsr/zifencei issues between clang and binutils

Nathan Huckleberry (1):
      fsverity: Remove WQ_UNBOUND from fsverity read workqueue

Nilesh Javali (1):
      scsi: qla2xxx: Perform lockless command completion in abort path

Nirmoy Das (2):
      drm/i915: Print return value on error
      drm/i915/active: Fix missing debug object activation

Paolo Abeni (3):
      mptcp: refactor passive socket initialization
      mptcp: use the workqueue to destroy unaccepted sockets
      mptcp: fix UaF in listener shutdown

Pauli Virtanen (1):
      Bluetooth: ISO: fix timestamped HCI ISO data packet parsing

Paulo Alcantara (1):
      cifs: fix dentry lookups in directory handle cache

Pawel Laszczak (3):
      usb: cdns3: Fix issue with using incorrect PCI device function
      usb: cdnsp: Fixes issue with redundant Status Stage
      usb: cdnsp: changes PCI Device ID to fix conflict with CNDS3 driver

Peng Fan (3):
      ARM: dts: imx6sll: e70k02: fix usbotg1 pinctrl
      ARM: dts: imx6sll: e60k02: fix usbotg1 pinctrl
      ARM: dts: imx6sl: tolino-shine2hd: fix usbotg1 pinctrl

Peter Collingbourne (1):
      Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"

Phinex Hung (1):
      hwmon: fix potential sensor registration fail if of_node is missing

Prike Liang (1):
      drm/amdkfd: introduce dummy cache info for property asic

Quinn Tran (1):
      scsi: qla2xxx: Synchronize the IOCB count to be in order

Radoslaw Tyl (1):
      i40e: fix flow director packet filter programming

Rafał Szalecki (1):
      HID: logitech-hidpp: Add support for Logitech MX Master 3S mouse

Ranjan Kumar (4):
      scsi: mpi3mr: Driver unload crashes host when enhanced logging is enabled
      scsi: mpi3mr: Wait for diagnostic save during controller init
      scsi: mpi3mr: NVMe command size greater than 8K fails
      scsi: mpi3mr: Bad drive in topology results kernel crash

Reka Norman (1):
      HID: intel-ish-hid: ipc: Fix potential use-after-free in work function

Rijo Thomas (1):
      tee: amdtee: fix race condition in amdtee_open_session

Roger Pau Monne (1):
      hvc/xen: prevent concurrent accesses to the shared ring

Ryusuke Konishi (1):
      nilfs2: fix kernel-infoleak in nilfs_ioctl_wrap_copy()

Saaem Rizvi (1):
      drm/amd/display: Remove OTG DIV register write for Virtual signals.

Sanjay R Mehta (1):
      thunderbolt: Add quirk to disable CLx

Savino Dicanosa (1):
      io_uring/rsrc: fix null-ptr-deref in io_file_bitmap_get()

Shyam Prasad N (6):
      cifs: lock chan_lock outside match_session
      cifs: append path to open_enter trace event
      cifs: do not poll server interfaces too regularly
      cifs: empty interface list when server doesn't support query interfaces
      cifs: dump pending mids for all channels in DebugData
      cifs: print session id while listing open files

Song Liu (1):
      perf: fix perf_event_context->time

Stefan Assmann (1):
      iavf: fix hang on reboot with ice

Stephan Gerhold (1):
      Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Steve French (2):
      smb3: lower default deferred close timeout to address perf regression
      smb3: fix unusable share after force unmount failure

Sungwoo Kim (1):
      Bluetooth: HCI: Fix global-out-of-bounds

Swapnil Patel (1):
      drm/amd/display: Update clock table to include highest clock setting

Szymon Heidrich (2):
      net: usb: smsc95xx: Limit packet length to skb->len
      net: usb: lan78xx: Limit packet length to skb->len

Tejas Upadhyay (1):
      drm/i915/fbdev: lock the fbdev obj before vma pin

Tim Huang (2):
      drm/amdgpu: skip ASIC reset for APUs when go to S4
      drm/amdgpu: reposition the gpu reset checking for reuse

Tom Rix (1):
      thunderbolt: Rename shadowed variables bit to interrupt_bit and auto_clear_bit

Tzung-Bi Shih (1):
      platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl

Ville Syrjälä (1):
      drm/i915: Preserve crtc_state->inherited during state clearing

Vincent Guittot (1):
      sched/fair: Sanitize vruntime of entity being migrated

Wei Chen (1):
      i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()

Wei Fang (1):
      arm64: dts: imx8dxl-evk: Disable hibernation mode of AR8031 for EQOS

Wesley Cheng (1):
      usb: dwc3: gadget: Add 1ms delay after end transfer command without IOC

Xu Yang (4):
      usb: typec: tcpm: fix create duplicate source-capabilities file
      usb: typec: tcpm: fix warning when handle discover_identity message
      usb: chipdea: core: fix return -EINVAL if request role is the same with current role
      usb: chipidea: core: fix possible concurrent when switch role

Yang Jihong (1):
      perf/core: Fix perf_output_begin parameter is incorrectly invoked in perf_event_bpf_output

Yaroslav Furman (1):
      uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2

Yicong Yang (1):
      i2c: hisi: Only use the completion interrupt to finish the transfer

Yifan Zhang (1):
      drm/amdkfd: add GC 11.0.4 KFD support

Yu Kuai (1):
      scsi: scsi_dh_alua: Fix memleak for 'qdata' in alua_activate()

Zhang Changzhong (1):
      net/sonic: use dma_mapping_error() for error check

Zhang Qiao (1):
      sched/fair: sanitize vruntime of entity being placed

Zheng Wang (5):
      power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition
      power: supply: da9150: Fix use after free bug in da9150_charger_remove due to race condition
      xirc2ps_cs: Fix use after free bug in xirc2ps_detach
      net: qcom/emac: Fix use after free bug in emac_remove due to race condition
      Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work

Zhengping Jiang (1):
      Bluetooth: hci_sync: Resume adv with no RPA when active scan

Ziyang Huang (1):
      usb: dwc2: drd: fix inconsistent mode if role-switch-default-mode="host"

lyndonli (1):
      drm/amdgpu: Fix call trace warning and hang when removing amdgpu device

Álvaro Fernández Rojas (2):
      net: dsa: b53: mmap: fix device tree support
      net: dsa: tag_brcm: legacy: fix daisy-chained switches

