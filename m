Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DD24649D2
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 09:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348003AbhLAImL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 03:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhLAImK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 03:42:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A496C061574;
        Wed,  1 Dec 2021 00:38:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFC13B81E00;
        Wed,  1 Dec 2021 08:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DCCC53FAD;
        Wed,  1 Dec 2021 08:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638347927;
        bh=miq8mXA08PqPWbLbzkS690GG8nGzPZBZ0WAeCL+vQwY=;
        h=From:To:Cc:Subject:Date:From;
        b=Zkw8VTZK4IxtZgLDUpBBH3IHX5RIcoC6Eg9gAVbFK3mdC4LuEmISzaTZqfb43odwc
         y3eL41jai5/heaq46xYQmj2TJ7DqG6Ig9cMZ2NUzgj+q3yJdXtD5ajCD2MJfzg+0Vc
         ge763w6lntVT98zWcy1FMAHmgRRU27j4Nu0+aT0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.83
Date:   Wed,  1 Dec 2021 09:38:43 +0100
Message-Id: <163834792423293@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.83 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/ipvs-sysctl.rst                   |    3 
 Makefile                                                   |    2 
 arch/arm/boot/dts/bcm2711.dtsi                             |    8 
 arch/arm/boot/dts/bcm5301x.dtsi                            |    4 
 arch/arm/mach-socfpga/core.h                               |    2 
 arch/arm/mach-socfpga/platsmp.c                            |    8 
 arch/mips/Kconfig                                          |    2 
 arch/mips/kernel/cpu-probe.c                               |    4 
 arch/parisc/kernel/vmlinux.lds.S                           |    3 
 arch/powerpc/kernel/head_32.h                              |    6 
 arch/powerpc/kvm/book3s_hv_builtin.c                       |    5 
 arch/s390/mm/pgtable.c                                     |   13 
 drivers/acpi/property.c                                    |   11 
 drivers/android/binder.c                                   |    2 
 drivers/block/xen-blkfront.c                               |  126 +++--
 drivers/firmware/arm_scmi/scmi_pm_domain.c                 |    4 
 drivers/firmware/smccc/soc_id.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                      |   46 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c          |    4 
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gm200.c            |    6 
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gp102.c            |    6 
 drivers/gpu/drm/vc4/vc4_bo.c                               |    2 
 drivers/hid/wacom_wac.c                                    |    8 
 drivers/hid/wacom_wac.h                                    |    1 
 drivers/iommu/amd/iommu_v2.c                               |    6 
 drivers/media/cec/core/cec-adap.c                          |    1 
 drivers/mmc/host/sdhci-esdhc-imx.c                         |    2 
 drivers/mmc/host/sdhci.c                                   |   21 
 drivers/mmc/host/sdhci.h                                   |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |    4 
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c             |   30 +
 drivers/net/ethernet/intel/ice/ice_lib.c                   |    9 
 drivers/net/ethernet/intel/ice/ice_main.c                  |   18 
 drivers/net/ethernet/intel/igb/igb_main.c                  |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c            |   14 
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c |    6 
 drivers/net/ethernet/mellanox/mlxsw/minimal.c              |    4 
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c             |    5 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c         |    3 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c      |    3 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   |    4 
 drivers/net/ethernet/microchip/lan743x_main.c              |   12 
 drivers/net/ethernet/mscc/ocelot.c                         |   11 
 drivers/net/ethernet/netronome/nfp/nfp_net.h               |    3 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c       |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac.h               |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |  139 +++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c      |   44 ++
 drivers/net/mdio/mdio-aspeed.c                             |    7 
 drivers/net/phy/phylink.c                                  |   26 +
 drivers/net/xen-netfront.c                                 |  272 +++++++-----
 drivers/nvme/target/io-cmd-file.c                          |    4 
 drivers/nvme/target/tcp.c                                  |    7 
 drivers/pci/controller/pci-aardvark.c                      |  235 ++++------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                       |    2 
 drivers/scsi/scsi_debug.c                                  |    5 
 drivers/scsi/scsi_sysfs.c                                  |    2 
 drivers/staging/fbtft/fb_ssd1351.c                         |    4 
 drivers/staging/fbtft/fbtft-core.c                         |    9 
 drivers/staging/greybus/audio_helper.c                     |    8 
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c               |    3 
 drivers/tty/hvc/hvc_xen.c                                  |   17 
 drivers/usb/chipidea/ci_hdrc_imx.c                         |   18 
 drivers/usb/core/hub.c                                     |   24 -
 drivers/usb/dwc2/gadget.c                                  |   17 
 drivers/usb/dwc2/hcd_queue.c                               |    2 
 drivers/usb/dwc3/gadget.c                                  |   39 +
 drivers/usb/serial/option.c                                |    5 
 drivers/usb/typec/tcpm/fusb302.c                           |    6 
 drivers/vhost/vsock.c                                      |    2 
 drivers/xen/xenbus/xenbus_probe.c                          |   27 +
 fs/ceph/super.c                                            |   11 
 fs/cifs/file.c                                             |   35 +
 fs/erofs/utils.c                                           |    8 
 fs/f2fs/node.c                                             |    1 
 fs/fuse/dev.c                                              |   10 
 fs/nfs/nfs42xdr.c                                          |    3 
 fs/proc/vmcore.c                                           |   16 
 include/linux/bpf.h                                        |    3 
 include/linux/ipc_namespace.h                              |   15 
 include/linux/sched/task.h                                 |    2 
 include/net/ip6_fib.h                                      |    1 
 include/net/ipv6_stubs.h                                   |    1 
 include/net/nl802154.h                                     |    7 
 include/xen/interface/io/ring.h                            |  278 +++++++------
 ipc/shm.c                                                  |  189 ++++++--
 kernel/bpf/syscall.c                                       |   57 +-
 kernel/bpf/verifier.c                                      |   17 
 kernel/cpu.c                                               |    7 
 kernel/power/hibernate.c                                   |    6 
 kernel/sched/core.c                                        |    4 
 kernel/trace/trace.h                                       |   24 -
 kernel/trace/trace_events.c                                |   10 
 kernel/trace/trace_uprobe.c                                |    1 
 net/8021q/vlan.c                                           |    3 
 net/8021q/vlan_dev.c                                       |    3 
 net/ipv4/nexthop.c                                         |   35 +
 net/ipv4/tcp.c                                             |    4 
 net/ipv4/tcp_cubic.c                                       |    5 
 net/ipv6/af_inet6.c                                        |    1 
 net/ipv6/ip6_output.c                                      |    2 
 net/ipv6/route.c                                           |   19 
 net/mptcp/options.c                                        |    3 
 net/ncsi/ncsi-cmd.c                                        |   24 -
 net/netfilter/ipvs/ip_vs_core.c                            |    8 
 net/netfilter/nf_conntrack_netlink.c                       |    6 
 net/netfilter/nf_flow_table_offload.c                      |    4 
 net/sched/sch_ets.c                                        |    8 
 net/smc/af_smc.c                                           |   12 
 net/smc/smc_close.c                                        |    6 
 net/smc/smc_core.c                                         |   35 -
 net/tls/tls_main.c                                         |   47 +-
 net/tls/tls_sw.c                                           |   23 -
 sound/hda/intel-dsp-config.c                               |    9 
 sound/pci/ctxfi/ctamixer.c                                 |   14 
 sound/pci/ctxfi/ctdaio.c                                   |   16 
 sound/pci/ctxfi/ctresource.c                               |    7 
 sound/pci/ctxfi/ctresource.h                               |    4 
 sound/pci/ctxfi/ctsrc.c                                    |    7 
 sound/pci/hda/patch_realtek.c                              |   28 +
 sound/soc/codecs/wcd934x.c                                 |    3 
 sound/soc/qcom/qdsp6/q6asm-dai.c                           |   19 
 sound/soc/qcom/qdsp6/q6routing.c                           |    6 
 sound/soc/soc-topology.c                                   |    3 
 124 files changed, 1596 insertions(+), 841 deletions(-)

Adrian Hunter (1):
      mmc: sdhci: Fix ADMA for PAGE_SIZE >= 64KiB

Albert Wang (1):
      usb: dwc3: gadget: Fix null pointer exception

Alex Deucher (1):
      drm/amdgpu/gfx9: switch to golden tsc registers for renoir+

Alexander Aring (1):
      net: ieee802154: handle iftypes as u32

Alexander Mikhalitsyn (1):
      shm: extend forced shm destroy to support objects from several IPC nses

Amit Cohen (1):
      mlxsw: spectrum: Protect driver from buggy firmware

Arjun Roy (1):
      tcp: correctly handle increased zerocopy args struct size

Christophe Leroy (1):
      powerpc/32: Fix hardlockup on vmap stack overflow

Dan Carpenter (4):
      usb: chipidea: ci_hdrc_imx: fix potential error pointer dereference in probe
      staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()
      drm/nouveau/acr: fix a couple NULL vs IS_ERR() checks
      drm/vc4: fix error code in vc4_create_object()

Daniel Borkmann (1):
      bpf: Fix toctou on read-only map's constant scalar tracking

Daniele Palmas (1):
      USB: serial: option: add Telit LE910S1 0x9200 composition

Danielle Ratson (1):
      mlxsw: Verify the accessed index doesn't exceed the array length

David Hildenbrand (2):
      proc/vmcore: fix clearing user buffer by properly using clear_user()
      s390/mm: validate VMA in PGSTE manipulation functions

Davide Caratti (1):
      net/sched: sch_ets: don't peek at classes beyond 'nbands'

Diana Wang (1):
      nfp: checking parameter process for rx-usecs/tx-usecs is invalid

Dylan Hung (1):
      mdio: aspeed: Fix "Link is Down" issue

Eric Dumazet (3):
      mptcp: fix delack timer
      ipv6: fix typos in __ip6_finish_output()
      tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Florent Fourcot (2):
      netfilter: ctnetlink: fix filtering with CTA_TUPLE_REPLY
      netfilter: ctnetlink: do not erase error code with EINVAL

Florian Fainelli (3):
      ARM: dts: BCM5301X: Fix I2C controller interrupt
      ARM: dts: BCM5301X: Add interrupt properties to GPIO node
      ARM: dts: bcm2711: Fix PCIe interrupts

Greg Kroah-Hartman (1):
      Linux 5.10.83

Guangbin Huang (1):
      net: hns3: fix VF RSS failed problem after PF enable multi-TCs

Guo DaXing (1):
      net/smc: Fix loop in smc_listen

Hans Verkuil (1):
      media: cec: copy sequence field for the reply

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

Jakub Kicinski (2):
      tls: splice_read: fix record type check
      tls: fix replacing proto_ops

Jason Gerecke (1):
      HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts

Jeff Layton (1):
      ceph: properly handle statfs on multifs setups

Jesse Brandeburg (1):
      igb: fix netpoll exit with traffic

Jiri Olsa (1):
      tracing/uprobe: Fix uprobe_perf_open probes iteration

Joakim Zhang (2):
      net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume
      net: stmmac: platform: fix build warning when with !CONFIG_PM_SLEEP

Joerg Roedel (1):
      iommu/amd: Clarify AMD IOMMUv2 initialization messages

Juergen Gross (9):
      xen: sync include/xen/interface/io/ring.h with Xen's newest version
      xen/blkfront: read response from backend only once
      xen/blkfront: don't take local copy of a request from the ring page
      xen/blkfront: don't trust the backend response data blindly
      xen/netfront: read response from backend only once
      xen/netfront: don't read data from request on the ring page
      xen/netfront: disentangle tx_skb_freelist
      xen/netfront: don't trust the backend response data blindly
      tty: hvc: replace BUG_ON() with negative return value

Karsten Graul (1):
      net/smc: Fix NULL pointer dereferencing in smc_vlan_by_tcpsk()

Kumar Thangavel (1):
      net/ncsi : Add payload to be 32-bit aligned to fix dropped packets

Maciej Fijalkowski (1):
      ice: fix vsi->txq_map sizing

Marek Behún (2):
      PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()
      net: marvell: mvpp2: increase MTU limit when XDP enabled

Mark Rutland (1):
      sched/scs: Reset task stack state in bringup_cpu()

Marta Plantykow (1):
      ice: avoid bpf_prog refcount underflow

Mathias Nyman (2):
      usb: hub: Fix usb enumeration issue due to address0 race
      usb: hub: Fix locking issues with address0_mutex

Maurizio Lombardi (1):
      nvmet: use IOCB_NOWAIT only if the filesystem supports it

Michael Kelley (1):
      firmware: smccc: Fix check for ARCH_SOC_ID not implemented

Mike Christie (1):
      scsi: core: sysfs: Fix setting device state to SDEV_RUNNING

Miklos Szeredi (1):
      fuse: release pipe buf after last use

Minas Harutyunyan (1):
      usb: dwc2: gadget: Fix ISOC flow for elapsed frames

Mingjie Zhang (1):
      USB: serial: option: add Fibocom FM101-GL variants

Nathan Chancellor (1):
      usb: dwc2: hcd_queue: Fix use of floating point literal

Nicholas Kazlauskas (1):
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

Ondrej Jirman (1):
      usb: typec: fusb302: Fix masking of comparator and bc_lvl interrupts

Pali Rohár (4):
      PCI: aardvark: Update comment about disabling link training
      PCI: aardvark: Implement re-issuing config requests on CRS response
      PCI: aardvark: Simplify initialization of rootcap on virtual bridge
      PCI: aardvark: Fix link training

Peng Fan (1):
      firmware: arm_scmi: pm: Propagate return value to caller

Pierre-Louis Bossart (1):
      ALSA: intel-dsp-config: add quirk for JSL devices based on ES8336 codec

Russell King (Oracle) (2):
      net: phylink: Force link down and retrigger resolve on interface change
      net: phylink: Force retrigger in case of latched link-fail indicator

Sakari Ailus (1):
      ACPI: Get acpi_device's parent from the parent field

Shin'ichiro Kawasaki (1):
      scsi: scsi_debug: Zero clear zones at reset write pointer

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic during drive powercycle test

Srinivas Kandagatla (3):
      ASoC: qdsp6: q6routing: Conditionally reset FrontEnd Mixer
      ASoC: qdsp6: q6asm: fix q6asm_dai_prepare error handling
      ASoC: codecs: wcd934x: return error code correctly from hw_params

Stefano Garzarella (1):
      vhost/vsock: fix incorrect used length reported to the guest

Stefano Stabellini (2):
      xen: don't continue xenstore initialization in case of errors
      xen: detect uninitialized xenbus in xenbus_init

Steve French (1):
      smb3: do not error on fsync when readonly

Steven Rostedt (VMware) (2):
      tracing: Fix pid filtering when triggers are attached
      tracing: Check pid filtering when creating events

Takashi Iwai (5):
      ALSA: ctxfi: Fix out-of-range access
      ALSA: hda/realtek: Fix LED on HP ProBook 435 G7
      staging: greybus: Add missing rwsem around snd_ctl_remove() calls
      ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
      ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE

Thinh Nguyen (2):
      usb: dwc3: gadget: Ignore NoStream after End Transfer
      usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer

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

Vladimir Oltean (2):
      net: mscc: ocelot: don't downgrade timestamping RX filters in SIOCSHWTSTAMP
      net: mscc: ocelot: correctly report the timestamping RX filters in ethtool

Volodymyr Mytnyk (1):
      net: marvell: prestera: fix double free issue on err path

Weichao Guo (1):
      f2fs: set SBI_NEED_FSCK flag when inconsistent node block found

Werner Sembach (1):
      ALSA: hda/realtek: Add quirk for ASRock NUC Box 1100

Will Mortensen (1):
      netfilter: flowtable: fix IPv6 tunnel addr match

Ziyang Xuan (1):
      net: vlan: fix underflow for the real_dev refcnt

yangxingwu (1):
      netfilter: ipvs: Fix reuse connection if RS weight is 0

