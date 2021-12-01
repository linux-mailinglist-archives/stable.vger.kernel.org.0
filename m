Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D038A46499B
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 09:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347945AbhLAI3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 03:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbhLAI3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 03:29:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D10C061574;
        Wed,  1 Dec 2021 00:26:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A49CEB81DE4;
        Wed,  1 Dec 2021 08:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1126C53FD0;
        Wed,  1 Dec 2021 08:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638347189;
        bh=yVo9wzCaUpDopqUeGGMqTJmd1R/r8+TBKcvgIti315Y=;
        h=From:To:Cc:Subject:Date:From;
        b=uABFrxZ/k8Z+gFV7R1MsW/YwQ0VXdpKFveNiPYW2PC7E3HoQj2t/5hua15XoVD7Yk
         0FTt5qyIf0b6QIktVjFA5ESkOQNRUqLOMzJV8l/yiPP0z40B3J5KyoNTGXgHrcawyI
         rW+jE0OO35saZzRhN5NElZHq1MLgaIkqzyHSe8VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.6
Date:   Wed,  1 Dec 2021 09:26:25 +0100
Message-Id: <16383471855080@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.6 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/sysctl/kernel.rst                 |    2 
 Documentation/networking/ipvs-sysctl.rst                    |    3 
 Makefile                                                    |    2 
 arch/arm/boot/dts/bcm2711.dtsi                              |    8 
 arch/arm/boot/dts/bcm5301x.dtsi                             |    4 
 arch/arm/mach-socfpga/core.h                                |    2 
 arch/arm/mach-socfpga/platsmp.c                             |    8 
 arch/arm64/include/asm/pgalloc.h                            |    2 
 arch/arm64/include/asm/uaccess.h                            |   48 ++
 arch/mips/Kconfig                                           |    2 
 arch/mips/kernel/cpu-probe.c                                |    4 
 arch/parisc/kernel/vmlinux.lds.S                            |    3 
 arch/powerpc/kernel/head_32.h                               |    6 
 arch/powerpc/kvm/book3s_hv_builtin.c                        |    5 
 arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts |   13 
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi           |   33 -
 arch/x86/include/asm/xen/hypervisor.h                       |    5 
 block/blk-core.c                                            |    4 
 block/blk-mq.c                                              |   13 
 block/blk-mq.h                                              |    2 
 block/blk-sysfs.c                                           |   10 
 block/elevator.c                                            |   10 
 block/genhd.c                                               |    2 
 drivers/acpi/cppc_acpi.c                                    |    9 
 drivers/acpi/property.c                                     |   11 
 drivers/android/binder.c                                    |    2 
 drivers/cpufreq/intel_pstate.c                              |    7 
 drivers/firmware/arm_scmi/base.c                            |   15 
 drivers/firmware/arm_scmi/scmi_pm_domain.c                  |    4 
 drivers/firmware/arm_scmi/sensors.c                         |    2 
 drivers/firmware/arm_scmi/virtio.c                          |   10 
 drivers/firmware/arm_scmi/voltage.c                         |    2 
 drivers/firmware/smccc/soc_id.c                             |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c                      |    3 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                      |   15 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                       |   46 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    9 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c        |   20 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c         |   24 -
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c         |    6 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c       |   28 -
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c       |   10 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c       |   58 +-
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c                     |    2 
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c                     |   19 
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c           |   22 +
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gm200.c             |    6 
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gp102.c             |    6 
 drivers/gpu/drm/vc4/vc4_bo.c                                |    2 
 drivers/hid/hid-input.c                                     |    6 
 drivers/hid/hid-magicmouse.c                                |    7 
 drivers/hid/wacom_wac.c                                     |    8 
 drivers/hid/wacom_wac.h                                     |    1 
 drivers/i2c/busses/i2c-virtio.c                             |   14 
 drivers/iommu/amd/iommu_v2.c                                |    6 
 drivers/iommu/intel/iommu.c                                 |    6 
 drivers/iommu/rockchip-iommu.c                              |    4 
 drivers/media/cec/core/cec-adap.c                           |    1 
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c               |   41 --
 drivers/mmc/host/sdhci-esdhc-imx.c                          |    2 
 drivers/mmc/host/sdhci.c                                    |   21 -
 drivers/mmc/host/sdhci.h                                    |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c          |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c   |    4 
 drivers/net/ethernet/intel/iavf/iavf.h                      |    3 
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c              |   33 +
 drivers/net/ethernet/intel/iavf/iavf_main.c                 |   51 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c             |   47 ++
 drivers/net/ethernet/intel/ice/ice_lib.c                    |    9 
 drivers/net/ethernet/intel/ice/ice_main.c                   |   18 
 drivers/net/ethernet/intel/igb/igb_main.c                   |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c             |   14 
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c  |    8 
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c              |    2 
 drivers/net/ethernet/microchip/lan743x_main.c               |   12 
 drivers/net/ethernet/mscc/ocelot.c                          |   11 
 drivers/net/ethernet/netronome/nfp/nfp_net.h                |    3 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c        |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |  127 ++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c       |    2 
 drivers/net/ipa/ipa_cmd.c                                   |   16 
 drivers/net/ipa/ipa_cmd.h                                   |    6 
 drivers/net/ipa/ipa_endpoint.c                              |    2 
 drivers/net/ipa/ipa_main.c                                  |    6 
 drivers/net/ipa/ipa_modem.c                                 |    6 
 drivers/net/ipa/ipa_smp2p.c                                 |   21 -
 drivers/net/ipa/ipa_smp2p.h                                 |    7 
 drivers/net/mdio/mdio-aspeed.c                              |    7 
 drivers/net/phy/phylink.c                                   |   26 +
 drivers/net/usb/smsc95xx.c                                  |   55 +-
 drivers/nvme/target/io-cmd-file.c                           |    4 
 drivers/nvme/target/tcp.c                                   |    7 
 drivers/pci/controller/pci-aardvark.c                       |  242 ++++--------
 drivers/scsi/mpt3sas/mpt3sas_base.c                         |    4 
 drivers/scsi/mpt3sas/mpt3sas_base.h                         |    4 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                        |   59 ++
 drivers/scsi/qla2xxx/qla_edif.c                             |    2 
 drivers/scsi/scsi_debug.c                                   |    5 
 drivers/scsi/scsi_sysfs.c                                   |    2 
 drivers/scsi/sd.c                                           |    7 
 drivers/staging/fbtft/fb_ssd1351.c                          |    4 
 drivers/staging/fbtft/fbtft-core.c                          |    9 
 drivers/staging/greybus/audio_helper.c                      |    8 
 drivers/staging/r8188eu/core/rtw_mlme_ext.c                 |    6 
 drivers/staging/r8188eu/os_dep/ioctl_linux.c                |    8 
 drivers/staging/r8188eu/os_dep/mlme_linux.c                 |    2 
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c                |    3 
 drivers/usb/chipidea/ci_hdrc_imx.c                          |   18 
 drivers/usb/core/hub.c                                      |   24 -
 drivers/usb/dwc2/gadget.c                                   |   17 
 drivers/usb/dwc2/hcd_queue.c                                |    2 
 drivers/usb/dwc3/core.c                                     |    8 
 drivers/usb/dwc3/core.h                                     |    2 
 drivers/usb/dwc3/gadget.c                                   |   39 +
 drivers/usb/host/xhci-tegra.c                               |   41 +-
 drivers/usb/serial/option.c                                 |    5 
 drivers/usb/serial/pl2303.c                                 |    1 
 drivers/usb/typec/tcpm/fusb302.c                            |    6 
 drivers/vdpa/vdpa_sim/vdpa_sim.c                            |    7 
 drivers/vhost/vsock.c                                       |    2 
 drivers/xen/xenbus/xenbus_probe.c                           |   27 +
 fs/ceph/super.c                                             |   11 
 fs/cifs/cifs_debug.c                                        |    2 
 fs/cifs/cifsglob.h                                          |    1 
 fs/cifs/connect.c                                           |    7 
 fs/erofs/utils.c                                            |    8 
 fs/f2fs/checkpoint.c                                        |    3 
 fs/f2fs/node.c                                              |    1 
 fs/fuse/dev.c                                               |   10 
 fs/io_uring.c                                               |   70 ++-
 fs/iomap/buffered-io.c                                      |   11 
 fs/ksmbd/smb2pdu.c                                          |   30 -
 fs/nfs/nfs42proc.c                                          |    4 
 fs/nfs/nfs42xdr.c                                           |    3 
 fs/proc/vmcore.c                                            |   16 
 include/net/ip6_fib.h                                       |    1 
 include/net/ipv6_stubs.h                                    |    1 
 include/net/nl802154.h                                      |    7 
 kernel/cpu.c                                                |    7 
 kernel/events/core.c                                        |    3 
 kernel/locking/rwsem.c                                      |  171 ++++----
 kernel/power/hibernate.c                                    |    6 
 kernel/sched/core.c                                         |    4 
 kernel/trace/trace.h                                        |   24 -
 kernel/trace/trace_events.c                                 |   10 
 kernel/trace/trace_uprobe.c                                 |    1 
 net/8021q/vlan.c                                            |    3 
 net/8021q/vlan_dev.c                                        |    3 
 net/ethtool/ioctl.c                                         |    2 
 net/ipv4/nexthop.c                                          |   35 +
 net/ipv4/tcp_cubic.c                                        |    5 
 net/ipv6/af_inet6.c                                         |    1 
 net/ipv6/ip6_output.c                                       |    2 
 net/ipv6/route.c                                            |   19 
 net/mptcp/options.c                                         |   32 -
 net/mptcp/protocol.c                                        |   51 ++
 net/mptcp/protocol.h                                        |   17 
 net/ncsi/ncsi-cmd.c                                         |   24 -
 net/netfilter/ipvs/ip_vs_core.c                             |    8 
 net/netfilter/nf_conntrack_netlink.c                        |    6 
 net/netfilter/nf_flow_table_offload.c                       |    4 
 net/sched/sch_ets.c                                         |    8 
 net/smc/af_smc.c                                            |   12 
 net/smc/smc_close.c                                         |    6 
 net/smc/smc_core.c                                          |   35 -
 net/tls/tls_main.c                                          |   47 +-
 net/tls/tls_sw.c                                            |   40 +
 net/unix/af_unix.c                                          |    3 
 sound/hda/intel-dsp-config.c                                |    9 
 sound/pci/ctxfi/ctamixer.c                                  |   14 
 sound/pci/ctxfi/ctdaio.c                                    |   16 
 sound/pci/ctxfi/ctresource.c                                |    7 
 sound/pci/ctxfi/ctresource.h                                |    4 
 sound/pci/ctxfi/ctsrc.c                                     |    7 
 sound/pci/hda/patch_realtek.c                               |   28 +
 sound/soc/codecs/lpass-rx-macro.c                           |    2 
 sound/soc/codecs/wcd934x.c                                  |    3 
 sound/soc/codecs/wcd938x.c                                  |    3 
 sound/soc/qcom/qdsp6/q6asm-dai.c                            |   19 
 sound/soc/qcom/qdsp6/q6routing.c                            |    6 
 sound/soc/soc-topology.c                                    |    3 
 sound/soc/sof/intel/hda-bus.c                               |   17 
 sound/soc/sof/intel/hda-dsp.c                               |    3 
 sound/soc/sof/intel/hda.c                                   |   16 
 sound/soc/stm/stm32_i2s.c                                   |    2 
 186 files changed, 1694 insertions(+), 972 deletions(-)

Adamos Ttofari (1):
      cpufreq: intel_pstate: Add Ice Lake server to out-of-band IDs

Adrian Hunter (1):
      mmc: sdhci: Fix ADMA for PAGE_SIZE >= 64KiB

Albert Wang (1):
      usb: dwc3: gadget: Fix null pointer exception

Alex Bee (1):
      iommu/rockchip: Fix PAGE_DESC_HI_MASKs for RK3568

Alex Deucher (3):
      drm/amdgpu/pm: fix powerplay OD interface
      drm/amdgpu/gfx10: add wraparound gpu counter check for APUs as well
      drm/amdgpu/gfx9: switch to golden tsc registers for renoir+

Alex Elder (3):
      net: ipa: directly disable ipa-setup-ready interrupt
      net: ipa: separate disabling setup from modem stop
      net: ipa: kill ipa_cmd_pipeline_clear()

Alex Williamson (1):
      iommu/vt-d: Fix unmap_pages support

Alexander Aring (1):
      net: ieee802154: handle iftypes as u32

Amit Cohen (1):
      mlxsw: spectrum: Protect driver from buggy firmware

Andreas Gruenbacher (1):
      iomap: Fix inline extent handling in iomap_readpage

Arnd Bergmann (1):
      media: v4l2-core: fix VIDIOC_DQEVENT handling on non-x86

Ben Skeggs (1):
      drm/nouveau: recognise GA106

Benjamin Coddington (1):
      NFSv42: Fix pagecache invalidation after COPY/CLONE

Brett Creeley (1):
      iavf: Fix VLAN feature flags after VFR

Chao Yu (1):
      f2fs: quota: fix potential deadlock

Christophe JAILLET (1):
      ksmbd: Fix an error handling path in 'smb2_sess_setup()'

Christophe Leroy (1):
      powerpc/32: Fix hardlockup on vmap stack overflow

Claudia Pellegrino (1):
      HID: magicmouse: prevent division by 0 on scroll

Cristian Marussi (3):
      firmware: arm_scmi: Fix null de-reference on error path
      firmware: arm_scmi: Fix type error assignment in voltage protocol
      firmware: arm_scmi: Fix type error in sensor protocol

Damien Le Moal (1):
      scsi: sd: Fix sd_do_mode_sense() buffer length handling

Dan Carpenter (6):
      usb: chipidea: ci_hdrc_imx: fix potential error pointer dereference in probe
      staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()
      staging: r8188eu: fix a memory leak in rtw_wx_read32()
      drm/nouveau/acr: fix a couple NULL vs IS_ERR() checks
      scsi: qla2xxx: edif: Fix off by one bug in qla_edif_app_getfcinfo()
      drm/vc4: fix error code in vc4_create_object()

Daniele Palmas (1):
      USB: serial: option: add Telit LE910S1 0x9200 composition

David Hildenbrand (1):
      proc/vmcore: fix clearing user buffer by properly using clear_user()

Davide Caratti (1):
      net/sched: sch_ets: don't peek at classes beyond 'nbands'

Diana Wang (1):
      nfp: checking parameter process for rx-usecs/tx-usecs is invalid

Dmitry Osipenko (1):
      usb: xhci: tegra: Check padctrl interrupt presence in device tree

Dylan Hung (1):
      mdio: aspeed: Fix "Link is Down" issue

Eric Dumazet (3):
      mptcp: fix delack timer
      ipv6: fix typos in __ip6_finish_output()
      tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Fabio Aiuto (1):
      usb: dwc3: leave default DMA for PCI devices

Fabio M. De Francesco (1):
      staging: r8188eu: Use kzalloc() with GFP_ATOMIC in atomic context

Florent Fourcot (2):
      netfilter: ctnetlink: fix filtering with CTA_TUPLE_REPLY
      netfilter: ctnetlink: do not erase error code with EINVAL

Florian Fainelli (3):
      ARM: dts: BCM5301X: Fix I2C controller interrupt
      ARM: dts: BCM5301X: Add interrupt properties to GPIO node
      ARM: dts: bcm2711: Fix PCIe interrupts

Greg Kroah-Hartman (1):
      Linux 5.15.6

Guangbin Huang (1):
      net: hns3: fix VF RSS failed problem after PF enable multi-TCs

Guo DaXing (1):
      net/smc: Fix loop in smc_listen

Hans Verkuil (1):
      media: cec: copy sequence field for the reply

Hans de Goede (1):
      HID: input: Fix parsing of HID_CP_CONSUMER_CONTROL fields

Heiner Kallweit (1):
      lan743x: fix deadlock in lan743x_phy_link_status_change()

Helge Deller (1):
      Revert "parisc: Fix backtrace to always include init funtion names"

Holger Assmann (1):
      net: stmmac: retain PTP clock time during SIOCSHWTSTAMP ioctls

Huang Jianan (1):
      erofs: fix deadlock when shrink erofs slab

Huang Pei (2):
      MIPS: loongson64: fix FTLB configuration
      MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48

Jakub Kicinski (3):
      tls: splice_read: fix record type check
      tls: splice_read: fix accessing pre-processed records
      tls: fix replacing proto_ops

Jason Gerecke (1):
      HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts

Jedrzej Jagielski (1):
      iavf: Fix refreshing iavf adapter stats on ethtool request

Jeff Layton (1):
      ceph: properly handle statfs on multifs setups

Jesse Brandeburg (1):
      igb: fix netpoll exit with traffic

Jie Wang (1):
      net: hns3: fix incorrect components info of ethtool --reset command

Jiri Olsa (1):
      tracing/uprobe: Fix uprobe_perf_open probes iteration

Joel Stanley (1):
      drm/aspeed: Fix vga_pw sysfs output

Joerg Roedel (1):
      iommu/amd: Clarify AMD IOMMUv2 initialization messages

Johan Hovold (1):
      USB: serial: pl2303: fix GC type detection

Juergen Gross (2):
      x86/pvh: add prototype for xen_pvh_init()
      xen/pvh: add missing prototype to header

Julian Wiedmann (1):
      ethtool: ioctl: fix potential NULL deref in ethtool_set_coalesce()

Kai Vehmanen (1):
      ASoC: SOF: Intel: hda: fix hotplug when only codec is suspended

Karsten Graul (1):
      net/smc: Fix NULL pointer dereferencing in smc_vlan_by_tcpsk()

Krzysztof Kozlowski (2):
      riscv: dts: microchip: fix board compatible
      riscv: dts: microchip: drop duplicated MMC/SDHC node

Kumar Thangavel (1):
      net/ncsi : Add payload to be 32-bit aligned to fix dropped packets

Larry Finger (1):
      staging: r8188eu: Fix breakage introduced when 5G code was removed

Longpeng (1):
      vdpa_sim: avoid putting an uninitialized iova_domain

Maciej Fijalkowski (1):
      ice: fix vsi->txq_map sizing

Marco Elver (1):
      perf: Ignore sigtrap for tracepoints destined for other tasks

Marek Behún (2):
      PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()
      net: marvell: mvpp2: increase MTU limit when XDP enabled

Mark Rutland (2):
      arm64: uaccess: avoid blocking within critical sections
      sched/scs: Reset task stack state in bringup_cpu()

Marta Plantykow (1):
      ice: avoid bpf_prog refcount underflow

Martyn Welch (1):
      net: usb: Correct PHY handling of smsc95xx

Mathias Nyman (2):
      usb: hub: Fix usb enumeration issue due to address0 race
      usb: hub: Fix locking issues with address0_mutex

Maurizio Lombardi (1):
      nvmet: use IOCB_NOWAIT only if the filesystem supports it

Mauro Carvalho Chehab (1):
      docs: accounting: update delay-accounting.rst reference

Michael Kelley (1):
      firmware: smccc: Fix check for ARCH_SOC_ID not implemented

Michael Straube (1):
      staging: r8188eu: use GFP_ATOMIC under spinlock

Mike Christie (1):
      scsi: core: sysfs: Fix setting device state to SDEV_RUNNING

Miklos Szeredi (1):
      fuse: release pipe buf after last use

Minas Harutyunyan (1):
      usb: dwc2: gadget: Fix ISOC flow for elapsed frames

Ming Lei (2):
      blk-mq: cancel blk-mq dispatch work in both blk_cleanup_queue and disk_release()
      block: avoid to quiesce queue in elevator_init_mq

Mingjie Zhang (1):
      USB: serial: option: add Fibocom FM101-GL variants

Mohammed Gamal (1):
      drm/hyperv: Fix device removal on Gen1 VMs

Namjae Jeon (3):
      ksmbd: downgrade addition info error msg to debug in smb2_get_info_sec()
      ksmbd: contain default data stream even if xattr is empty
      ksmbd: fix memleak in get_file_stream_info()

Nathan Chancellor (1):
      usb: dwc2: hcd_queue: Fix use of floating point literal

Nicholas Kazlauskas (2):
      drm/amd/display: Fix DPIA outbox timeout after GPU reset
      drm/amd/display: Set plane update flags for all planes in reset

Nicholas Piggin (1):
      KVM: PPC: Book3S HV: Prevent POWER7/8 TLB flush flushing SLB

Nikolay Aleksandrov (3):
      net: nexthop: fix null pointer dereference when IPv6 is not enabled
      net: ipv6: add fib6_nh_release_dsts stub
      net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group

Nitesh B Venkatesh (1):
      iavf: Prevent changing static ITR values if adaptive moderation is on

Noralf Trønnes (1):
      staging/fbtft: Fix backlight

Olivier Moysan (1):
      ASoC: stm32: i2s: fix 32 bits channel length without mclk

Ondrej Jirman (1):
      usb: typec: fusb302: Fix masking of comparator and bc_lvl interrupts

Pali Rohár (3):
      PCI: aardvark: Implement re-issuing config requests on CRS response
      PCI: aardvark: Simplify initialization of rootcap on virtual bridge
      PCI: aardvark: Fix link training

Paolo Abeni (1):
      mptcp: use delegate action to schedule 3rd ack retrans

Pavel Begunkov (3):
      io_uring: correct link-list traversal locking
      io_uring: fail cancellation for EXITING tasks
      io_uring: fix link traversal locking

Peng Fan (1):
      firmware: arm_scmi: pm: Propagate return value to caller

Philip Yang (1):
      drm/amdgpu: IH process reset count when restart

Pierre-Louis Bossart (1):
      ALSA: intel-dsp-config: add quirk for JSL devices based on ES8336 codec

Pingfan Liu (1):
      arm64: mm: Fix VM_BUG_ON(mm != &init_mm) for trans_pgd

Rafael J. Wysocki (2):
      ACPI: CPPC: Add NULL pointer check to cppc_get_perf()
      cpufreq: intel_pstate: Fix active mode offline/online EPP handling

Roman Li (1):
      drm/amd/display: Fix OLED brightness control on eDP

Russell King (Oracle) (2):
      net: phylink: Force link down and retrigger resolve on interface change
      net: phylink: Force retrigger in case of latched link-fail indicator

Sakari Ailus (1):
      ACPI: Get acpi_device's parent from the parent field

Shin'ichiro Kawasaki (1):
      scsi: scsi_debug: Zero clear zones at reset write pointer

Shyam Prasad N (2):
      cifs: nosharesock should not share socket with future sessions
      cifs: nosharesock should be set on new server

Sreekanth Reddy (3):
      scsi: mpt3sas: Fix kernel panic during drive powercycle test
      scsi: mpt3sas: Fix system going into read-only mode
      scsi: mpt3sas: Fix incorrect system timestamp

Srinivas Kandagatla (5):
      ASoC: qdsp6: q6routing: Conditionally reset FrontEnd Mixer
      ASoC: qdsp6: q6asm: fix q6asm_dai_prepare error handling
      ASoC: codecs: wcd938x: fix volatile register range
      ASoC: codecs: wcd934x: return error code correctly from hw_params
      ASoC: codecs: lpass-rx-macro: fix HPHR setting CLSH mask

Stefano Garzarella (1):
      vhost/vsock: fix incorrect used length reported to the guest

Stefano Stabellini (2):
      xen: don't continue xenstore initialization in case of errors
      xen: detect uninitialized xenbus in xenbus_init

Steven Rostedt (VMware) (2):
      tracing: Fix pid filtering when triggers are attached
      tracing: Check pid filtering when creating events

Takashi Iwai (5):
      ALSA: ctxfi: Fix out-of-range access
      ALSA: hda/realtek: Fix LED on HP ProBook 435 G7
      staging: greybus: Add missing rwsem around snd_ctl_remove() calls
      ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
      ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE

Thinh Nguyen (3):
      usb: dwc3: core: Revise GHWPARAMS9 offset
      usb: dwc3: gadget: Ignore NoStream after End Transfer
      usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer

Thomas Weißschuh (1):
      HID: input: set usage type to key on keycode remap

Thomas Zeitlhofer (1):
      PM: hibernate: use correct mode for swsusp_close()

Tim Harvey (1):
      mmc: sdhci-esdhc-imx: disable CMDQ support

Todd Kjos (1):
      binder: fix test regression due to sender_euid change

Tony Lu (2):
      net/smc: Ensure the active closing peer first closes clcsock
      net/smc: Don't call clcsock shutdown twice when smc shutdown

Trond Myklebust (1):
      NFSv42: Don't fail clone() unless the OP_CLONE operation failed

Varun Prakash (1):
      nvmet-tcp: fix incomplete data digest send

Vincent Guittot (1):
      firmware: arm_scmi: Fix base agent discover response

Vincent Whitchurch (2):
      af_unix: fix regression in read after shutdown
      i2c: virtio: disable timeout handling

Vladimir Oltean (2):
      net: mscc: ocelot: don't downgrade timestamping RX filters in SIOCSHWTSTAMP
      net: mscc: ocelot: correctly report the timestamping RX filters in ethtool

Volodymyr Mytnyk (2):
      net: marvell: prestera: fix brige port operation
      net: marvell: prestera: fix double free issue on err path

Waiman Long (1):
      locking/rwsem: Make handoff bit handling more consistent

Weichao Guo (1):
      f2fs: set SBI_NEED_FSCK flag when inconsistent node block found

Werner Sembach (1):
      ALSA: hda/realtek: Add quirk for ASRock NUC Box 1100

Will Mortensen (1):
      netfilter: flowtable: fix IPv6 tunnel addr match

Yannick Vignon (1):
      net: stmmac: Disable Tx queues when reconfiguring the interface

Ye Bin (1):
      io_uring: fix soft lockup when call __io_remove_buffers

Ziyang Xuan (1):
      net: vlan: fix underflow for the real_dev refcnt

yangxingwu (1):
      netfilter: ipvs: Fix reuse connection if RS weight is 0

