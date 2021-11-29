Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AB64626A1
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhK2Wz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbhK2WzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672A6C125CF7;
        Mon, 29 Nov 2021 10:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08C28B815A9;
        Mon, 29 Nov 2021 18:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B72C53FAD;
        Mon, 29 Nov 2021 18:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210503;
        bh=IUSPYSvvXCrOvhkblyLVILI9dSNbHZSUYQRc3qXfdoA=;
        h=From:To:Cc:Subject:Date:From;
        b=IKc845JRtKVaEvUL/TMdOfHY7IIZ3w/Jli7U8b0k7xl02ghd/7uZvNSLbl7F49S6b
         J8NWvCH9Emzkp39VacsaaIUOkc+tk3ndb7uJNQPsscNJyTzMogYsVJ4lWif257OFIr
         XOz3sR64tO3KqdT06FCJIGxfK4Eh4+yy6nVzQz18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/121] 5.10.83-rc1 review
Date:   Mon, 29 Nov 2021 19:17:11 +0100
Message-Id: <20211129181711.642046348@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.83-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.83-rc1
X-KernelTest-Deadline: 2021-12-01T18:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.83 release.
There are 121 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.83-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.83-rc1

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: switch to golden tsc registers for renoir+

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: platform: fix build warning when with !CONFIG_PM_SLEEP

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
    shm: extend forced shm destroy to support objects from several IPC nses

David Hildenbrand <david@redhat.com>
    s390/mm: validate VMA in PGSTE manipulation functions

Juergen Gross <jgross@suse.com>
    tty: hvc: replace BUG_ON() with negative return value

Juergen Gross <jgross@suse.com>
    xen/netfront: don't trust the backend response data blindly

Juergen Gross <jgross@suse.com>
    xen/netfront: disentangle tx_skb_freelist

Juergen Gross <jgross@suse.com>
    xen/netfront: don't read data from request on the ring page

Juergen Gross <jgross@suse.com>
    xen/netfront: read response from backend only once

Juergen Gross <jgross@suse.com>
    xen/blkfront: don't trust the backend response data blindly

Juergen Gross <jgross@suse.com>
    xen/blkfront: don't take local copy of a request from the ring page

Juergen Gross <jgross@suse.com>
    xen/blkfront: read response from backend only once

Juergen Gross <jgross@suse.com>
    xen: sync include/xen/interface/io/ring.h with Xen's newest version

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check pid filtering when creating events

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: fix incorrect used length reported to the guest

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Clarify AMD IOMMUv2 initialization messages

Steve French <stfrench@microsoft.com>
    smb3: do not error on fsync when readonly

Jeff Layton <jlayton@kernel.org>
    ceph: properly handle statfs on multifs setups

Weichao Guo <guoweichao@oppo.com>
    f2fs: set SBI_NEED_FSCK flag when inconsistent node block found

Mark Rutland <mark.rutland@arm.com>
    sched/scs: Reset task stack state in bringup_cpu()

Arjun Roy <arjunroy@google.com>
    tcp: correctly handle increased zerocopy args struct size

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: correctly report the timestamping RX filters in ethtool

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: don't downgrade timestamping RX filters in SIOCSHWTSTAMP

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix VF RSS failed problem after PF enable multi-TCs

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Don't call clcsock shutdown twice when smc shutdown

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: vlan: fix underflow for the real_dev refcnt

Davide Caratti <dcaratti@redhat.com>
    net/sched: sch_ets: don't peek at classes beyond 'nbands'

Jakub Kicinski <kuba@kernel.org>
    tls: fix replacing proto_ops

Jakub Kicinski <kuba@kernel.org>
    tls: splice_read: fix record type check

Huang Pei <huangpei@loongson.cn>
    MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48

Huang Pei <huangpei@loongson.cn>
    MIPS: loongson64: fix FTLB configuration

Jesse Brandeburg <jesse.brandeburg@intel.com>
    igb: fix netpoll exit with traffic

Maurizio Lombardi <mlombard@redhat.com>
    nvmet: use IOCB_NOWAIT only if the filesystem supports it

Guo DaXing <guodaxing@huawei.com>
    net/smc: Fix loop in smc_listen

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: Fix NULL pointer dereferencing in smc_vlan_by_tcpsk()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: Force retrigger in case of latched link-fail indicator

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: Force link down and retrigger resolve on interface change

Heiner Kallweit <hkallweit1@gmail.com>
    lan743x: fix deadlock in lan743x_phy_link_status_change()

Eric Dumazet <edumazet@google.com>
    tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Set plane update flags for all planes in reset

Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
    PM: hibernate: use correct mode for swsusp_close()

Kumar Thangavel <kumarthangavel.hcl@gmail.com>
    net/ncsi : Add payload to be 32-bit aligned to fix dropped packets

Varun Prakash <varun@chelsio.com>
    nvmet-tcp: fix incomplete data digest send

Marek Behún <kabel@kernel.org>
    net: marvell: mvpp2: increase MTU limit when XDP enabled

Amit Cohen <amcohen@nvidia.com>
    mlxsw: spectrum: Protect driver from buggy firmware

Danielle Ratson <danieller@nvidia.com>
    mlxsw: Verify the accessed index doesn't exceed the array length

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Ensure the active closing peer first closes clcsock

Huang Jianan <huangjianan@oppo.com>
    erofs: fix deadlock when shrink erofs slab

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: scsi_debug: Zero clear zones at reset write pointer

Mike Christie <michael.christie@oracle.com>
    scsi: core: sysfs: Fix setting device state to SDEV_RUNNING

Marta Plantykow <marta.a.plantykow@intel.com>
    ice: avoid bpf_prog refcount underflow

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: fix vsi->txq_map sizing

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: ipv6: add fib6_nh_release_dsts stub

Holger Assmann <h.assmann@pengutronix.de>
    net: stmmac: retain PTP clock time during SIOCSHWTSTAMP ioctls

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume

Diana Wang <na.wang@corigine.com>
    nfp: checking parameter process for rx-usecs/tx-usecs is invalid

Eric Dumazet <edumazet@google.com>
    ipv6: fix typos in __ip6_finish_output()

Michael Kelley <mikelley@microsoft.com>
    firmware: smccc: Fix check for ARCH_SOC_ID not implemented

Eric Dumazet <edumazet@google.com>
    mptcp: fix delack timer

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: intel-dsp-config: add quirk for JSL devices based on ES8336 codec

Nitesh B Venkatesh <nitesh.b.venkatesh@intel.com>
    iavf: Prevent changing static ITR values if adaptive moderation is on

Volodymyr Mytnyk <vmytnyk@marvell.com>
    net: marvell: prestera: fix double free issue on err path

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vc4: fix error code in vc4_create_object()

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix kernel panic during drive powercycle test

Dan Carpenter <dan.carpenter@oracle.com>
    drm/nouveau/acr: fix a couple NULL vs IS_ERR() checks

Takashi Iwai <tiwai@suse.de>
    ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv42: Don't fail clone() unless the OP_CLONE operation failed

Peng Fan <peng.fan@nxp.com>
    firmware: arm_scmi: pm: Propagate return value to caller

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: handle iftypes as u32

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: return error code correctly from hw_params

Takashi Iwai <tiwai@suse.de>
    ASoC: topology: Add missing rwsem around snd_ctl_remove() calls

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6asm: fix q6asm_dai_prepare error handling

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6routing: Conditionally reset FrontEnd Mixer

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: bcm2711: Fix PCIe interrupts

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Add interrupt properties to GPIO node

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Fix I2C controller interrupt

Will Mortensen <willmo@gmail.com>
    netfilter: flowtable: fix IPv6 tunnel addr match

yangxingwu <xingwu.yang@gmail.com>
    netfilter: ipvs: Fix reuse connection if RS weight is 0

Florent Fourcot <florent.fourcot@wifirst.fr>
    netfilter: ctnetlink: do not erase error code with EINVAL

Florent Fourcot <florent.fourcot@wifirst.fr>
    netfilter: ctnetlink: fix filtering with CTA_TUPLE_REPLY

David Hildenbrand <david@redhat.com>
    proc/vmcore: fix clearing user buffer by properly using clear_user()

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Simplify initialization of rootcap on virtual bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Implement re-issuing config requests on CRS response

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Update comment about disabling link training

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix hardlockup on vmap stack overflow

Dylan Hung <dylan_hung@aspeedtech.com>
    mdio: aspeed: Fix "Link is Down" issue

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix ADMA for PAGE_SIZE >= 64KiB

Tim Harvey <tharvey@gateworks.com>
    mmc: sdhci-esdhc-imx: disable CMDQ support

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix pid filtering when triggers are attached

Jiri Olsa <jolsa@redhat.com>
    tracing/uprobe: Fix uprobe_perf_open probes iteration

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV: Prevent POWER7/8 TLB flush flushing SLB

Stefano Stabellini <stefano.stabellini@xilinx.com>
    xen: detect uninitialized xenbus in xenbus_init

Stefano Stabellini <stefano.stabellini@xilinx.com>
    xen: don't continue xenstore initialization in case of errors

Miklos Szeredi <mszeredi@redhat.com>
    fuse: release pipe buf after last use

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()

Takashi Iwai <tiwai@suse.de>
    staging: greybus: Add missing rwsem around snd_ctl_remove() calls

Noralf Trønnes <noralf@tronnes.org>
    staging/fbtft: Fix backlight

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts

Helge Deller <deller@gmx.de>
    Revert "parisc: Fix backtrace to always include init funtion names"

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: copy sequence field for the reply

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix LED on HP ProBook 435 G7

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for ASRock NUC Box 1100

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Fix out-of-range access

Todd Kjos <tkjos@google.com>
    binder: fix test regression due to sender_euid change

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix locking issues with address0_mutex

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix usb enumeration issue due to address0 race

Ondrej Jirman <megous@megous.com>
    usb: typec: fusb302: Fix masking of comparator and bc_lvl interrupts

Dan Carpenter <dan.carpenter@oracle.com>
    usb: chipidea: ci_hdrc_imx: fix potential error pointer dereference in probe

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: nexthop: fix null pointer dereference when IPv6 is not enabled

Albert Wang <albertccwang@google.com>
    usb: dwc3: gadget: Fix null pointer exception

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Ignore NoStream after End Transfer

Nathan Chancellor <nathan@kernel.org>
    usb: dwc2: hcd_queue: Fix use of floating point literal

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix ISOC flow for elapsed frames

Mingjie Zhang <superzmj@fibocom.com>
    USB: serial: option: add Fibocom FM101-GL variants

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910S1 0x9200 composition

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: Get acpi_device's parent from the parent field

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix toctou on read-only map's constant scalar tracking


-------------

Diffstat:

 Documentation/networking/ipvs-sysctl.rst           |   3 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |   8 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |   4 +-
 arch/arm/mach-socfpga/core.h                       |   2 +-
 arch/arm/mach-socfpga/platsmp.c                    |   8 +-
 arch/mips/Kconfig                                  |   2 +-
 arch/mips/kernel/cpu-probe.c                       |   4 +-
 arch/parisc/kernel/vmlinux.lds.S                   |   3 +-
 arch/powerpc/kernel/head_32.h                      |   6 +-
 arch/powerpc/kvm/book3s_hv_builtin.c               |   5 +-
 arch/s390/mm/pgtable.c                             |  13 +
 drivers/acpi/property.c                            |  11 +-
 drivers/android/binder.c                           |   2 +-
 drivers/block/xen-blkfront.c                       | 126 ++++++----
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |   4 +-
 drivers/firmware/smccc/soc_id.c                    |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  46 +++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gm200.c    |   6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gp102.c    |   6 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   2 +-
 drivers/hid/wacom_wac.c                            |   8 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/iommu/amd/iommu_v2.c                       |   6 +-
 drivers/media/cec/core/cec-adap.c                  |   1 +
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 -
 drivers/mmc/host/sdhci.c                           |  21 +-
 drivers/mmc/host/sdhci.h                           |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  30 ++-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   9 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  18 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  14 +-
 .../ethernet/marvell/prestera/prestera_switchdev.c |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |   4 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   5 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |   3 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   3 +
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   4 +
 drivers/net/ethernet/microchip/lan743x_main.c      |  12 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  11 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |   3 -
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 139 ++++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  44 ++++
 drivers/net/mdio/mdio-aspeed.c                     |   7 +
 drivers/net/phy/phylink.c                          |  26 +-
 drivers/net/xen-netfront.c                         | 272 ++++++++++++--------
 drivers/nvme/target/io-cmd-file.c                  |   4 +-
 drivers/nvme/target/tcp.c                          |   7 +-
 drivers/pci/controller/pci-aardvark.c              | 235 ++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   2 +-
 drivers/scsi/scsi_debug.c                          |   5 +
 drivers/scsi/scsi_sysfs.c                          |   2 +-
 drivers/staging/fbtft/fb_ssd1351.c                 |   4 -
 drivers/staging/fbtft/fbtft-core.c                 |   9 +-
 drivers/staging/greybus/audio_helper.c             |   8 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   3 +-
 drivers/tty/hvc/hvc_xen.c                          |  17 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  18 +-
 drivers/usb/core/hub.c                             |  24 +-
 drivers/usb/dwc2/gadget.c                          |  17 +-
 drivers/usb/dwc2/hcd_queue.c                       |   2 +-
 drivers/usb/dwc3/gadget.c                          |  39 ++-
 drivers/usb/serial/option.c                        |   5 +
 drivers/usb/typec/tcpm/fusb302.c                   |   6 +-
 drivers/vhost/vsock.c                              |   2 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  27 +-
 fs/ceph/super.c                                    |  11 +-
 fs/cifs/file.c                                     |  35 ++-
 fs/erofs/utils.c                                   |   8 +-
 fs/f2fs/node.c                                     |   1 +
 fs/fuse/dev.c                                      |  10 +-
 fs/nfs/nfs42xdr.c                                  |   3 +-
 fs/proc/vmcore.c                                   |  16 +-
 include/linux/bpf.h                                |   3 +-
 include/linux/ipc_namespace.h                      |  15 ++
 include/linux/sched/task.h                         |   2 +-
 include/net/ip6_fib.h                              |   1 +
 include/net/ipv6_stubs.h                           |   1 +
 include/net/nl802154.h                             |   7 +-
 include/xen/interface/io/ring.h                    | 278 ++++++++++++---------
 ipc/shm.c                                          | 189 ++++++++++----
 kernel/bpf/syscall.c                               |  57 +++--
 kernel/bpf/verifier.c                              |  17 +-
 kernel/cpu.c                                       |   7 +
 kernel/power/hibernate.c                           |   6 +-
 kernel/sched/core.c                                |   4 -
 kernel/trace/trace.h                               |  24 +-
 kernel/trace/trace_events.c                        |  10 +
 kernel/trace/trace_uprobe.c                        |   1 +
 net/8021q/vlan.c                                   |   3 -
 net/8021q/vlan_dev.c                               |   3 +
 net/ipv4/nexthop.c                                 |  35 ++-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_cubic.c                               |   5 +-
 net/ipv6/af_inet6.c                                |   1 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/route.c                                   |  19 ++
 net/mptcp/options.c                                |   3 +-
 net/ncsi/ncsi-cmd.c                                |  24 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   8 +-
 net/netfilter/nf_conntrack_netlink.c               |   6 +-
 net/netfilter/nf_flow_table_offload.c              |   4 +-
 net/sched/sch_ets.c                                |   8 +-
 net/smc/af_smc.c                                   |  12 +-
 net/smc/smc_close.c                                |   6 +
 net/smc/smc_core.c                                 |  35 +--
 net/tls/tls_main.c                                 |  47 +++-
 net/tls/tls_sw.c                                   |  23 +-
 sound/hda/intel-dsp-config.c                       |   9 +
 sound/pci/ctxfi/ctamixer.c                         |  14 +-
 sound/pci/ctxfi/ctdaio.c                           |  16 +-
 sound/pci/ctxfi/ctresource.c                       |   7 +-
 sound/pci/ctxfi/ctresource.h                       |   4 +-
 sound/pci/ctxfi/ctsrc.c                            |   7 +-
 sound/pci/hda/patch_realtek.c                      |  28 +++
 sound/soc/codecs/wcd934x.c                         |   3 +-
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  19 +-
 sound/soc/qcom/qdsp6/q6routing.c                   |   6 +-
 sound/soc/soc-topology.c                           |   3 +
 124 files changed, 1597 insertions(+), 842 deletions(-)


