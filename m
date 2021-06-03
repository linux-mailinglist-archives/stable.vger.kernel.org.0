Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E909B399C0C
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 09:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFCHy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 03:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230100AbhFCHyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 03:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D863613E4;
        Thu,  3 Jun 2021 07:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622706758;
        bh=YNGaiwExd7Cu0wmEos75fVUOIiYUJisSLYeXBkGqqWc=;
        h=From:To:Cc:Subject:Date:From;
        b=ys8YcTIsAzoAjC16HcNgd5NqU9o6hiFaoEFyTL+eZkuoSFAEwLkgJUefBds/ZvOH6
         qVwGL/EGrooVcauiDni6bVgoM+H8vxCSQpGWudKPwXCwbaTsl8WUE/776FpQOeIztu
         fLgd7c3DuUl+58riq2aJwxk9SYwRBIhoPGCc1Tww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.42
Date:   Thu,  3 Jun 2021 09:52:28 +0200
Message-Id: <162270674910125@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.42 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/userspace-api/seccomp_filter.rst                     |   16 
 Makefile                                                           |    2 
 arch/arm64/include/asm/kvm_emulate.h                               |    5 
 arch/arm64/kvm/reset.c                                             |   28 +
 arch/mips/alchemy/board-xxs1500.c                                  |    1 
 arch/mips/ralink/of.c                                              |    2 
 arch/openrisc/include/asm/barrier.h                                |    9 
 arch/x86/kvm/x86.c                                                 |    2 
 drivers/acpi/acpi_apd.c                                            |    1 
 drivers/base/core.c                                                |   37 +
 drivers/char/hpet.c                                                |    2 
 drivers/crypto/cavium/nitrox/nitrox_main.c                         |    1 
 drivers/dma/qcom/hidma_mgmt.c                                      |   17 
 drivers/gpio/gpio-cadence.c                                        |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10_3.c               |   12 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                         |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c                             |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                            |    1 
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c                             |    2 
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c                             |    2 
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c                             |    2 
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c                             |    5 
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c                              |    6 
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c                              |    8 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                      |   18 
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c                    |    9 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c            |   10 
 drivers/gpu/drm/i915/display/intel_dp.c                            |    2 
 drivers/gpu/drm/meson/meson_drv.c                                  |    9 
 drivers/i2c/busses/i2c-i801.c                                      |    6 
 drivers/i2c/busses/i2c-mt65xx.c                                    |    5 
 drivers/i2c/busses/i2c-s3c2410.c                                   |    3 
 drivers/i2c/busses/i2c-sh_mobile.c                                 |    2 
 drivers/iio/adc/ad7124.c                                           |   36 -
 drivers/iio/adc/ad7192.c                                           |   19 
 drivers/iio/adc/ad7768-1.c                                         |    8 
 drivers/iio/adc/ad7793.c                                           |    1 
 drivers/iio/adc/ad7923.c                                           |    4 
 drivers/iio/dac/ad5770r.c                                          |   16 
 drivers/iio/gyro/fxas21002c_core.c                                 |    2 
 drivers/interconnect/qcom/bcm-voter.c                              |    4 
 drivers/iommu/intel/dmar.c                                         |    4 
 drivers/iommu/intel/iommu.c                                        |    7 
 drivers/iommu/intel/pasid.c                                        |    3 
 drivers/iommu/virtio-iommu.c                                       |    1 
 drivers/isdn/hardware/mISDN/hfcsusb.c                              |   17 
 drivers/isdn/hardware/mISDN/mISDNinfineon.c                        |   21 -
 drivers/md/dm-snap.c                                               |    2 
 drivers/media/dvb-frontends/sp8870.c                               |    2 
 drivers/media/usb/gspca/cpia1.c                                    |    6 
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c                      |   16 
 drivers/media/usb/gspca/m5602/m5602_po1030.c                       |   14 
 drivers/misc/kgdbts.c                                              |    3 
 drivers/misc/lis3lv02d/lis3lv02d.h                                 |    1 
 drivers/misc/mei/interrupt.c                                       |    3 
 drivers/net/caif/caif_serial.c                                     |    3 
 drivers/net/dsa/mt7530.c                                           |    8 
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c                   |   23 -
 drivers/net/dsa/sja1105/sja1105_main.c                             |   75 ++-
 drivers/net/ethernet/broadcom/bnx2.c                               |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                          |   12 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                          |   10 
 drivers/net/ethernet/cavium/liquidio/lio_main.c                    |   27 -
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c                 |   27 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c                  |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                    |    2 
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c     |   80 +++
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h     |    2 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c        |    6 
 drivers/net/ethernet/freescale/fec_main.c                          |   11 
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c                          |    4 
 drivers/net/ethernet/google/gve/gve_main.c                         |   21 -
 drivers/net/ethernet/google/gve/gve_tx.c                           |    8 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                    |   26 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c             |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                     |   16 
 drivers/net/ethernet/lantiq_xrx200.c                               |   14 
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h                         |   22 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                    |   54 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                        |   67 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h                        |   24 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                    |    4 
 drivers/net/ethernet/mellanox/mlx4/port.c                          |  107 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c                    |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                  |    9 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                    |   10 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                  |    1 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |   38 -
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c                   |    6 
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c                 |    3 
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h                 |    5 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                  |    9 
 drivers/net/ethernet/ti/netcp_core.c                               |    4 
 drivers/net/ipa/ipa.h                                              |    2 
 drivers/net/ipa/ipa_mem.c                                          |    3 
 drivers/net/mdio/mdio-octeon.c                                     |    2 
 drivers/net/mdio/mdio-thunder.c                                    |    1 
 drivers/net/usb/hso.c                                              |   45 +-
 drivers/net/usb/smsc75xx.c                                         |    8 
 drivers/net/wireless/ath/ath10k/htt.h                              |    1 
 drivers/net/wireless/ath/ath10k/htt_rx.c                           |  201 +++++++++-
 drivers/net/wireless/ath/ath10k/rx_desc.h                          |   14 
 drivers/net/wireless/ath/ath11k/dp_rx.c                            |   18 
 drivers/net/wireless/ath/ath11k/dp_rx.h                            |    1 
 drivers/net/wireless/ath/ath11k/mac.c                              |    6 
 drivers/net/wireless/ath/ath6kl/debug.c                            |    5 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c          |    8 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h             |   19 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c            |   42 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c            |    9 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h            |    5 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c             |    8 
 drivers/net/wireless/marvell/libertas/mesh.c                       |   33 -
 drivers/nvme/target/tcp.c                                          |    2 
 drivers/platform/x86/hp-wireless.c                                 |    2 
 drivers/platform/x86/hp_accel.c                                    |   22 +
 drivers/platform/x86/intel_punit_ipc.c                             |    1 
 drivers/platform/x86/touchscreen_dmi.c                             |   43 ++
 drivers/s390/cio/vfio_ccw_cp.c                                     |    4 
 drivers/scsi/BusLogic.c                                            |    6 
 drivers/scsi/BusLogic.h                                            |    2 
 drivers/scsi/libsas/sas_port.c                                     |    4 
 drivers/scsi/pm8001/pm8001_hwi.c                                   |   10 
 drivers/scsi/pm8001/pm8001_init.c                                  |    2 
 drivers/scsi/pm8001/pm8001_sas.c                                   |    7 
 drivers/scsi/pm8001/pm80xx_hwi.c                                   |   12 
 drivers/scsi/ufs/ufs-mediatek.c                                    |    4 
 drivers/spi/spi-fsl-dspi.c                                         |    4 
 drivers/spi/spi.c                                                  |   23 -
 drivers/staging/emxx_udc/emxx_udc.c                                |    4 
 drivers/staging/iio/cdc/ad7746.c                                   |    1 
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c       |    4 
 drivers/thermal/intel/x86_pkg_temp_thermal.c                       |    2 
 drivers/thunderbolt/dma_port.c                                     |   11 
 drivers/thunderbolt/usb4.c                                         |    9 
 drivers/tty/serial/8250/8250.h                                     |    1 
 drivers/tty/serial/8250/8250_aspeed_vuart.c                        |    1 
 drivers/tty/serial/8250/8250_dw.c                                  |    1 
 drivers/tty/serial/8250/8250_pci.c                                 |   47 +-
 drivers/tty/serial/8250/8250_port.c                                |   12 
 drivers/tty/serial/max310x.c                                       |    2 
 drivers/tty/serial/rp2.c                                           |   52 --
 drivers/tty/serial/serial-tegra.c                                  |    2 
 drivers/tty/serial/serial_core.c                                   |    8 
 drivers/tty/serial/sh-sci.c                                        |    4 
 drivers/usb/core/devio.c                                           |   11 
 drivers/usb/core/hub.h                                             |    6 
 drivers/usb/dwc3/gadget.c                                          |   13 
 drivers/usb/gadget/udc/renesas_usb3.c                              |    5 
 drivers/usb/misc/trancevibrator.c                                  |    4 
 drivers/usb/misc/uss720.c                                          |    1 
 drivers/usb/serial/ftdi_sio.c                                      |    3 
 drivers/usb/serial/ftdi_sio_ids.h                                  |    7 
 drivers/usb/serial/option.c                                        |    4 
 drivers/usb/serial/pl2303.c                                        |    1 
 drivers/usb/serial/pl2303.h                                        |    1 
 drivers/usb/serial/ti_usb_3410_5052.c                              |    3 
 drivers/usb/typec/mux.c                                            |    7 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                  |   19 
 fs/afs/dir.c                                                       |    4 
 fs/block_dev.c                                                     |    3 
 fs/btrfs/extent_io.c                                               |    7 
 fs/btrfs/reflink.c                                                 |    5 
 fs/btrfs/tree-log.c                                                |    2 
 fs/cifs/smb2pdu.c                                                  |   13 
 fs/nfs/filelayout/filelayout.c                                     |    2 
 fs/nfs/nfs4file.c                                                  |    2 
 fs/nfs/nfs4proc.c                                                  |    4 
 fs/nfs/pagelist.c                                                  |   21 -
 fs/nfs/pnfs.c                                                      |   15 
 fs/proc/base.c                                                     |    4 
 include/linux/bits.h                                               |    2 
 include/linux/const.h                                              |    8 
 include/linux/device.h                                             |    6 
 include/linux/minmax.h                                             |   10 
 include/linux/mlx5/mpfs.h                                          |   18 
 include/linux/sunrpc/xprt.h                                        |    2 
 include/net/cfg80211.h                                             |    4 
 include/net/netfilter/nf_flow_table.h                              |    1 
 include/net/pkt_cls.h                                              |   11 
 include/net/pkt_sched.h                                            |    7 
 include/net/sch_generic.h                                          |   35 +
 include/net/sock.h                                                 |    4 
 kernel/bpf/verifier.c                                              |   12 
 kernel/seccomp.c                                                   |   30 -
 net/bluetooth/cmtp/core.c                                          |    5 
 net/core/dev.c                                                     |   29 +
 net/core/filter.c                                                  |    1 
 net/core/neighbour.c                                               |    4 
 net/core/sock.c                                                    |    8 
 net/dsa/master.c                                                   |    5 
 net/dsa/slave.c                                                    |   12 
 net/hsr/hsr_device.c                                               |    2 
 net/hsr/hsr_forward.c                                              |   30 +
 net/hsr/hsr_forward.h                                              |    8 
 net/hsr/hsr_main.h                                                 |    4 
 net/hsr/hsr_slave.c                                                |   11 
 net/ipv6/mcast.c                                                   |    3 
 net/ipv6/reassembly.c                                              |    4 
 net/mac80211/ieee80211_i.h                                         |   36 -
 net/mac80211/iface.c                                               |   11 
 net/mac80211/key.c                                                 |    7 
 net/mac80211/key.h                                                 |    2 
 net/mac80211/rx.c                                                  |  150 +++++--
 net/mac80211/sta_info.c                                            |    6 
 net/mac80211/sta_info.h                                            |   33 +
 net/mac80211/wpa.c                                                 |   13 
 net/mptcp/options.c                                                |    1 
 net/mptcp/protocol.c                                               |    6 
 net/mptcp/subflow.c                                                |    1 
 net/netfilter/nf_flow_table_core.c                                 |    3 
 net/netfilter/nf_flow_table_offload.c                              |    7 
 net/netfilter/nft_set_pipapo.c                                     |    4 
 net/netfilter/nft_set_pipapo.h                                     |    2 
 net/netfilter/nft_set_pipapo_avx2.c                                |    3 
 net/openvswitch/meter.c                                            |    8 
 net/packet/af_packet.c                                             |   10 
 net/sched/cls_api.c                                                |    2 
 net/sched/sch_dsmark.c                                             |    3 
 net/sched/sch_fq_pie.c                                             |   19 
 net/sched/sch_generic.c                                            |   50 ++
 net/smc/smc_ism.c                                                  |   26 -
 net/sunrpc/clnt.c                                                  |    7 
 net/sunrpc/xprt.c                                                  |   40 +
 net/sunrpc/xprtrdma/transport.c                                    |   12 
 net/sunrpc/xprtrdma/verbs.c                                        |   18 
 net/sunrpc/xprtrdma/xprt_rdma.h                                    |    1 
 net/tipc/core.c                                                    |    2 
 net/tipc/core.h                                                    |    2 
 net/tipc/msg.c                                                     |    9 
 net/tipc/socket.c                                                  |    5 
 net/tipc/udp_media.c                                               |    2 
 net/tls/tls_sw.c                                                   |   11 
 net/wireless/util.c                                                |    7 
 samples/bpf/xdpsock_user.c                                         |    2 
 scripts/clang-tools/gen_compile_commands.py                        |    2 
 scripts/clang-tools/run-clang-tools.py                             |    2 
 sound/isa/gus/gus_main.c                                           |   13 
 sound/isa/sb/sb16_main.c                                           |   10 
 sound/pci/hda/patch_realtek.c                                      |   46 ++
 sound/soc/codecs/cs35l33.c                                         |    1 
 sound/soc/codecs/cs42l42.c                                         |    3 
 sound/soc/codecs/cs43130.c                                         |   28 -
 sound/soc/qcom/lpass-cpu.c                                         |   12 
 sound/usb/mixer_quirks.c                                           |    2 
 sound/usb/mixer_scarlett_gen2.c                                    |   81 ++--
 sound/usb/mixer_scarlett_gen2.h                                    |    2 
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst                 |    4 
 tools/bpf/bpftool/Documentation/bpftool-prog.rst                   |    2 
 tools/bpf/bpftool/bash-completion/bpftool                          |    6 
 tools/bpf/bpftool/cgroup.c                                         |    3 
 tools/bpf/bpftool/prog.c                                           |    2 
 tools/include/linux/bits.h                                         |    2 
 tools/include/linux/const.h                                        |    8 
 tools/perf/pmu-events/jevents.c                                    |    2 
 tools/perf/scripts/python/exported-sql-viewer.py                   |   12 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c                |    6 
 tools/perf/util/intel-pt.c                                         |    5 
 tools/testing/selftests/gpio/Makefile                              |   24 -
 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json     |    8 
 virt/lib/irqbypass.c                                               |   16 
 265 files changed, 2244 insertions(+), 937 deletions(-)

Adrian Hunter (5):
      perf intel-pt: Fix sample instruction bytes
      perf intel-pt: Fix transaction abort handling
      perf scripts python: exported-sql-viewer.py: Fix copy to clipboard from Top Calls by elapsed Time report
      perf scripts python: exported-sql-viewer.py: Fix Array TypeError
      perf scripts python: exported-sql-viewer.py: Fix warning display

Ajish Koshy (1):
      scsi: pm80xx: Fix drives missing during rmmod/insmod loop

Alaa Emad (2):
      media: dvb: Add check on sp8870_readreg return
      media: gspca: mt9m111: Check write_bridge for timeout

Alan Stern (1):
      USB: usbfs: Don't WARN about excessively large memory allocations

Aleksander Jan Bajkowski (1):
      net: lantiq: fix memory corruption in RX ring

Alex Elder (1):
      net: ipa: memory region array is variable size

Alexander Usyskin (1):
      mei: request autosuspend after sending rx flow control

Alexandru Ardelean (1):
      iio: adc: ad7192: handle regulator voltage error first

Andrew Jeffery (1):
      serial: 8250: Add UART_BUG_TXRACE workaround for Aspeed VUART

Andy Gospodarek (1):
      bnxt_en: Include new P5 HV definition in VF check.

Andy Shevchenko (3):
      iio: dac: ad5770r: Put fwnode in error case during ->probe()
      platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI
      spi: Assume GPIO CS active high in ACPI case

Anirudh Rayabharam (3):
      net: fujitsu: fix potential null-ptr-deref
      net/smc: properly handle workqueue allocation failure
      ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()

Anna Schumaker (1):
      NFSv4: Fix a NULL pointer dereference in pnfs_mark_matching_lsegs_return()

Ariel Levkovich (1):
      net/mlx5: Set term table as an unmanaged flow table

Atul Gopinathan (1):
      serial: max310x: unregister uart driver in case of failure and abort

Aurelien Aptel (1):
      cifs: set server->cipher_type to AES-128-CCM for SMB3.0

Aya Levin (1):
      net/mlx5e: Fix error path of updating netdev queues

Ayush Sawal (1):
      cxgb4/ch_ktls: Clear resources when pf4 device is removed

Bixuan Cui (1):
      iommu/virtio: Add missing MODULE_DEVICE_TABLE

Bjorn Andersson (1):
      usb: typec: mux: Fix matching with typec_altmode_desc

Boris Burkov (1):
      btrfs: return whole extents in fiemap

Catherine Sullivan (2):
      gve: Check TX QPL was actually assigned
      gve: Upgrade memory barrier in poll routine

Chinmay Agarwal (1):
      neighbour: Prevent Race condition in neighbour subsytem

Chris Park (1):
      drm/amd/display: Disconnect non-DP with no EDID

Christian Gmeiner (1):
      serial: 8250_pci: handle FL_NOIRQ board flag

Christian König (1):
      drm/amdgpu: stop touching sched.ready in the backend

Christophe JAILLET (4):
      spi: spi-fsl-dspi: Fix a resource leak in an error handling path
      net: netcp: Fix an error message
      net: mdio: thunder: Fix a double free issue in the .remove function
      net: mdio: octeon: Fix some double free issues

Chunfeng Yun (1):
      usb: core: reduce power-on-good delay time of root hub

Colin Ian King (1):
      serial: tegra: Fix a mask operation that is always true

DENG Qingfang (1):
      net: dsa: mt7530: fix VLAN traffic leaks

Dan Carpenter (7):
      NFS: fix an incorrect limit in filelayout_decode_layout()
      net: dsa: fix a crash if ->get_sset_count() fails
      chelsio/chtls: unlock on error in chtls_pt_recvmsg()
      net: hso: check for allocation failure in hso_create_bulk_serial_device()
      staging: emxx_udc: fix loop in _nbu2ss_nuke()
      ASoC: cs35l33: fix an error code in probe()
      scsi: libsas: Use _safe() loop in sas_resume_port()

Daniele Palmas (1):
      USB: serial: option: add Telit LE910-S1 compositions 0x7010, 0x7011

David Awogbemila (3):
      gve: Update mgmt_msix_idx if num_ntfy changes
      gve: Add NULL pointer checks when freeing irqs.
      gve: Correct SKB queue index validation.

David Howells (1):
      afs: Fix the nlink handling of dir-over-dir rename

Davide Caratti (2):
      net/sched: fq_pie: re-factor fix for fq_pie endless loop
      net/sched: fq_pie: fix OOB access in the traffic path

Dima Chumak (2):
      net/mlx5e: Fix multipath lag activation
      net/mlx5e: Fix nullptr in add_vlan_push_action()

Dominik Andreas Schorpp (1):
      USB: serial: ftdi_sio: add IDs for IDS GmbH Products

Dongliang Mu (1):
      misc/uss720: fix memory leak in uss720_probe

Du Cheng (1):
      net: caif: remove BUG_ON(dev == NULL) in caif_xmit

Eli Cohen (1):
      {net,vdpa}/mlx5: Configure interface MAC into mpfs L2 table

Eric Farman (1):
      vfio-ccw: Check initialized flag in cp_init()

Evan Quan (1):
      drm/amd/pm: correct MGpuFanBoost setting

Felix Fietkau (1):
      perf jevents: Fix getting maximum number of fds

Filipe Manana (1):
      btrfs: release path before starting transaction when cloning inline extent

Francesco Ruggeri (1):
      ipv6: record frag_max_size in atomic fragments in input path

Fugang Duan (1):
      net: fec: fix the potential memory leak in fec_enet_init()

Geert Uytterhoeven (2):
      serial: sh-sci: Fix off-by-one error in FIFO threshold register setting
      i2c: sh_mobile: Use new clock calculation formulas for RZ/G2E

Geoffrey D. Bennett (2):
      ALSA: usb-audio: scarlett2: Fix device hang with ehci-pci
      ALSA: usb-audio: scarlett2: Improve driver startup messages

George McCollister (1):
      net: hsr: fix mac_len checks

Greg Kroah-Hartman (29):
      kgdb: fix gcc-11 warnings harder
      Revert "crypto: cavium/nitrox - add an error message to explain the failure of pci_request_mem_regions"
      Revert "media: usb: gspca: add a missed check for goto_low_power"
      Revert "ALSA: sb: fix a missing check of snd_ctl_add"
      Revert "serial: max310x: pass return value of spi_register_driver"
      Revert "net: fujitsu: fix a potential NULL pointer dereference"
      Revert "net/smc: fix a NULL pointer dereference"
      Revert "net: caif: replace BUG_ON with recovery code"
      Revert "char: hpet: fix a missing check of ioremap"
      Revert "ALSA: gus: add a check of the status of snd_ctl_add"
      Revert "ALSA: usx2y: Fix potential NULL pointer dereference"
      Revert "isdn: mISDNinfineon: fix potential NULL pointer dereference"
      Revert "ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()"
      Revert "isdn: mISDN: Fix potential NULL pointer dereference of kzalloc"
      Revert "dmaengine: qcom_hidma: Check for driver register failure"
      Revert "libertas: add checks for the return value of sysfs_create_group"
      libertas: register sysfs groups properly
      Revert "ASoC: cs43130: fix a NULL pointer dereference"
      ASoC: cs43130: handle errors in cs43130_probe() properly
      Revert "media: dvb: Add check on sp8870_readreg"
      Revert "media: gspca: mt9m111: Check write_bridge for timeout"
      Revert "media: gspca: Check the return value of write_bridge for timeout"
      media: gspca: properly check for errors in po1030_probe()
      Revert "net: liquidio: fix a NULL pointer dereference"
      Revert "brcmfmac: add a check for the status of usb_register"
      brcmfmac: properly check for bus register errors
      i915: fix build warning in intel_dp_get_link_status()
      Revert "Revert "ALSA: usx2y: Fix potential NULL pointer dereference""
      Linux 5.10.42

Gulam Mohamed (1):
      block: fix a race between del_gendisk and BLKRRPART

Hans de Goede (1):
      platform/x86: touchscreen_dmi: Add info for the Chuwi Hi10 Pro (CWI529) tablet

Hoang Le (1):
      Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"

Hou Pu (1):
      nvmet-tcp: fix inline data size comparison in nvmet_tcp_queue_response

Hui Wang (2):
      ALSA: hda/realtek: the bass speaker can't output sound on Yoga 9i
      ALSA: hda/realtek: Headphone volume is controlled by Front mixer

James Zhu (4):
      drm/amdgpu/vcn1: add cancel_delayed_work_sync before power gate
      drm/amdgpu/vcn2.0: add cancel_delayed_work_sync before power gate
      drm/amdgpu/vcn2.5: add cancel_delayed_work_sync before power gate
      drm/amdgpu/jpeg2.0: add cancel_delayed_work_sync before power gate

Jean Delvare (1):
      i2c: i801: Don't generate an interrupt on bus reset

Jeremy Szu (4):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP 855 G8
      ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP Zbook G8
      ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP Zbook Fury 15 G8
      ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP Zbook Fury 17 G8

Jesse Brandeburg (1):
      ixgbe: fix large MTU request from VF

Jian Shen (1):
      net: hns3: put off calling register_netdev() until client initialize complete

Jianbo Liu (1):
      net/mlx5: Set reformat action when needed for termination rules

Jiaran Zhang (1):
      net: hns3: fix incorrect resp_msg issue

Jim Ma (1):
      tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT

Jingwen Chen (1):
      drm/amd/amdgpu: fix refcount leak

Joakim Zhang (1):
      net: stmmac: Fix MAC WoL not working if PHY does not support WoL

Johan Hovold (3):
      net: hso: fix control-request directions
      USB: trancevibrator: fix control-request direction
      net: hso: bail out on interrupt URB allocation failure

Johannes Berg (5):
      mac80211: drop A-MSDUs on old ciphers
      mac80211: add fragment cache to sta_info
      mac80211: check defrag PN against current frame
      mac80211: prevent attacks on TKIP/WEP as well
      mac80211: do not accept/forward invalid EAPOL frames

Jonathan Cameron (5):
      iio: adc: ad7768-1: Fix too small buffer passed to iio_push_to_buffers_with_timestamp()
      iio: adc: ad7124: Fix missbalanced regulator enable / disable on error.
      iio: adc: ad7124: Fix potential overflow due to non sequential channel numbers
      iio: adc: ad7923: Fix undersized rx buffer.
      iio: adc: ad7192: Avoid disabling a clock that was never enabled.

Josef Bacik (1):
      btrfs: do not BUG_ON in link_to_fixup_dir

Julian Wiedmann (1):
      net/smc: remove device from smcd_dev_list after failed device_add()

Jussi Maki (1):
      bpf: Set mac_len in bpf_skb_change_head

Kai-Heng Feng (1):
      platform/x86: hp_accel: Avoid invoking _INI to speed up resume

Kees Cook (1):
      proc: Check /proc/$pid/attr/ writes against file opener

Kevin Wang (1):
      drm/amdkfd: correct sienna_cichlid SDMA RLC register offset error

Krzysztof Kozlowski (1):
      i2c: s3c2410: fix possible NULL pointer deref on read message after write

Lang Yu (1):
      drm/amd/amdgpu: fix a potential deadlock in gpu reset

Liu Jian (1):
      bpftool: Add sock_release help info for cgroup attach/prog load command

Lu Baolu (1):
      iommu/vt-d: Use user privilege for RID2PASID translation

Lucas Stankus (1):
      staging: iio: cdc: ad7746: avoid overwrite of num_channels

Magnus Karlsson (1):
      samples/bpf: Consider frame size in tx_only of xdpsock sample

Marc Zyngier (1):
      KVM: arm64: Prevent mixed-width VM creation

Masahiro Yamada (1):
      scripts/clang-tools: switch explicitly to Python 3

Mathias Nyman (2):
      thunderbolt: usb4: Fix NVM read buffer bounds and offset issue
      thunderbolt: dma_port: Fix NVM read buffer bounds and offset issue

Mathy Vanhoef (4):
      mac80211: assure all fragments are encrypted
      mac80211: prevent mixed key and fragment cache attacks
      mac80211: properly handle A-MSDUs that start with an RFC 1042 header
      cfg80211: mitigate A-MSDU aggregation attacks

Matt Wang (1):
      scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic

Maximilian Luz (1):
      serial: 8250_dw: Add device HID for new AMD UART controller

Michael Chan (1):
      bnxt_en: Fix context memory setup for 64K page size.

Michael Ellerman (3):
      selftests/gpio: Use TEST_GEN_PROGS_EXTENDED
      selftests/gpio: Move include of lib.mk up
      selftests/gpio: Fix build when source tree is read only

Mikulas Patocka (1):
      dm snapshot: properly fix a crash when an origin has no snapshots

Neil Armstrong (1):
      drm/meson: fix shutdown crash when component not probed

NeilBrown (1):
      SUNRPC in case of backlog, hand free slots directly to waiting task

Ondrej Mosnacek (1):
      serial: core: fix suspicious security_locked_down() call

Paolo Abeni (4):
      mptcp: avoid error message on infinite mapping
      mptcp: drop unconditional pr_warn on bad opt
      mptcp: fix data stream corruption
      net: really orphan skbs tied to closing sk

Pavel Skripkin (1):
      net: usb: fix memory leak in smsc75xx_bind

Peter Ujfalusi (1):
      ALSA: hda/realtek: Chain in pop reduction fixup for ThinkStation P340

Peter Wang (1):
      scsi: ufs: ufs-mediatek: Fix power down spec violation

Peter Zijlstra (1):
      openrisc: Define memory barrier mb

Phillip Potter (3):
      isdn: mISDNinfineon: check/cleanup ioremap failure correctly in setup_io
      isdn: mISDN: correctly handle ph_info allocation failure in hfcsusb_ph_info
      dmaengine: qcom_hidma: comment platform_driver_register call

Qii Wang (1):
      i2c: mediatek: Disable i2c start_en and clear intr_stat brfore reset

Rafael J. Wysocki (1):
      drivers: base: Fix device link removal

Raju Rangoju (1):
      cxgb4: avoid accessing registers when clearing filters

Randy Dunlap (2):
      MIPS: alchemy: xxs1500: add gpio-au1000.h header file
      MIPS: ralink: export rt_sysc_membase for rt2880_wdt.c

Randy Wright (1):
      serial: 8250_pci: Add support for new HPE serial device

Richard Fitzgerald (1):
      ASoC: cs42l42: Regmap must use_single_read/write

Richard Sanger (1):
      net: packetmmap: fix only tx timestamp on request

Rikard Falkeborn (1):
      linux/bits.h: fix compilation error with GENMASK

Roi Dayan (2):
      net/mlx5e: Fix null deref accessing lag dev
      netfilter: flowtable: Remove redundant hw refresh bit

Rolf Eike Beer (1):
      iommu/vt-d: Fix sysfs leak in alloc_iommu()

Rui Miguel Silva (1):
      iio: gyro: fxas21002c: balance runtime power in error path

Saeed Mahameed (1):
      net/mlx5e: reset XPS on error flow if netdev isn't registered yet

Sargun Dhillon (2):
      Documentation: seccomp: Fix user notification documentation
      seccomp: Refactor notification handler to prepare for new semantics

Sean MacLennan (1):
      USB: serial: ti_usb_3410_5052: add startech.com device id

Shyam Sundar S K (1):
      platform/x86: hp-wireless: add AMD's hardware id to the supported list

Srinivas Pandruvada (1):
      thermal/drivers/intel: Initialize RW trip to THERMAL_TEMP_INVALID

Sriram R (2):
      ath10k: Validate first subframe of A-MSDU before processing the list
      ath11k: Clear the fragment cache during key install

Stefan Chulski (1):
      net: mvpp2: add buffer header handling in RX

Stefan Roese (1):
      net: ethernet: mtk_eth_soc: Fix packet statistics support for MT7628/88

Stefano Brivio (1):
      netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version

Stephen Boyd (1):
      ASoC: qcom: lpass-cpu: Use optional clk APIs

Steve French (1):
      SMB3: incorrect file id in requests compounded with open

Subbaraman Narayanamurthy (1):
      interconnect: qcom: bcm-voter: add a missing of_node_put()

Taehee Yoo (2):
      mld: fix panic in mld_newpack()
      sch_dsmark: fix a NULL deref in qdisc_reset()

Tao Liu (1):
      openvswitch: meter: fix race when getting now_ms.

Teava Radu (1):
      platform/x86: touchscreen_dmi: Add info for the Mediacom Winpad 7.0 W700 tablet

Thadeu Lima de Souza Cascardo (1):
      Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails

Thinh Nguyen (1):
      usb: dwc3: gadget: Properly track pending and queued SG

Tom Seewald (2):
      char: hpet: add checks after calling ioremap
      net: liquidio: Add missing null pointer checks

Trond Myklebust (3):
      NFS: Fix an Oopsable condition in __nfs_pageio_add_request()
      NFS: Don't corrupt the value of pg_bytes_written in nfs_do_recoalesce()
      SUNRPC: More fixes for backlog congestion

Vlad Buslov (1):
      net: zero-initialize tc skb extension on allocation

Vladimir Oltean (7):
      net: dsa: sja1105: update existing VLANs from the bridge VLAN list
      net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic
      net: dsa: sja1105: error out on unsupported PHY mode
      net: dsa: sja1105: add error handling in sja1105_setup()
      net: dsa: sja1105: call dsa_unregister_switch when allocating memory fails
      net: dsa: sja1105: fix VL lookup command packing for P/Q/R/S
      net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count

Vladyslav Tarasiuk (1):
      net/mlx4: Fix EEPROM dump support

Wanpeng Li (1):
      KVM: X86: Fix vCPU preempted state from guest's point of view

Wen Gong (6):
      mac80211: extend protection against mixed key and fragment cache attacks
      ath10k: add CCMP PN replay protection for fragmented frames for PCIe
      ath10k: drop fragments with multicast DA for PCIe
      ath10k: drop fragments with multicast DA for SDIO
      ath10k: drop MPDU which has discard flag set by firmware for SDIO
      ath10k: Fix TKIP Michael MIC verification for PCIe

Xin Long (2):
      tipc: wait and exit until all work queues are done
      tipc: skb_linearize the head skb when reassembling msgs

Yinjun Zhang (1):
      bpf, offload: Reorder offload callback 'prepare' in verifier

Yoshihiro Shimoda (1):
      usb: gadget: udc: renesas_usb3: Fix a race in usb3_start_pipen()

YueHaibing (1):
      iio: adc: ad7793: Add missing error code in ad7793_setup()

Yunsheng Lin (4):
      net: sched: fix packet stuck problem for lockless qdisc
      net: sched: fix tx action rescheduling issue during deactivation
      net: sched: fix tx action reschedule issue with stopped queue
      net: hns3: check the return of skb_checksum_help()

Zhang Xiaoxu (1):
      NFSv4: Fix v4.0/v4.1 SEEK_DATA return -ENOTSUPP when set NFS_V4_2 config

Zhen Lei (1):
      net: bnx2: Fix error return code in bnx2_init_board()

Zheyu Ma (1):
      serial: rp2: use 'request_firmware' instead of 'request_firmware_nowait'

Zhu Lingshan (1):
      Revert "irqbypass: do not start cons/prod when failed connect"

Zolton Jheng (1):
      USB: serial: pl2303: add device id for ADLINK ND-6530 GC

Zou Wei (2):
      gpio: cadence: Add missing MODULE_DEVICE_TABLE
      interconnect: qcom: Add missing MODULE_DEVICE_TABLE

kernel test robot (1):
      ALSA: usb-audio: scarlett2: snd_scarlett_gen2_controls_create() can be static

xinhui pan (1):
      drm/amdgpu: Fix a use-after-free

zhouchuangao (1):
      fs/nfs: Use fatal_signal_pending instead of signal_pending

