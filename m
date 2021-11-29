Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F051461DBF
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377994AbhK2S3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:18 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48290 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352944AbhK2S1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4863ECE1407;
        Mon, 29 Nov 2021 18:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59F5C53FC7;
        Mon, 29 Nov 2021 18:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210209;
        bh=f5NvBib0upox1lK7ORcIO9/M4sSEe1bZ5mzF1jUpMI8=;
        h=From:To:Cc:Subject:Date:From;
        b=L/gfSwUlS4ThvFoCm2/iQFaVg+r9OwtEcRauPbsJAkU9VVk4z2tIH5fD5cm45aYqF
         Q7OFS2m4MkWyHrzkiapwexHvrcgSFP+wDaQA3QkhVsbzXQ/QOnZFfKqc48E5hvvz4Q
         ioq/3bfy6ATnwUBn8qm64jpzpqBVNIw+yCTKEkvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/92] 5.4.163-rc1 review
Date:   Mon, 29 Nov 2021 19:17:29 +0100
Message-Id: <20211129181707.392764191@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.163-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.163-rc1
X-KernelTest-Deadline: 2021-12-01T18:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.163 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.163-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.163-rc1

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

Miklos Szeredi <mszeredi@redhat.com>
    fuse: release pipe buf after last use

Lin Ma <linma@zju.edu.cn>
    NFC: add NCI_UNREG flag to eliminate the race

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
    shm: extend forced shm destroy to support objects from several IPC nses

David Hildenbrand <david@redhat.com>
    s390/mm: validate VMA in PGSTE manipulation functions

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check pid filtering when creating events

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: fix incorrect used length reported to the guest

Steve French <stfrench@microsoft.com>
    smb3: do not error on fsync when readonly

Weichao Guo <guoweichao@oppo.com>
    f2fs: set SBI_NEED_FSCK flag when inconsistent node block found

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

Huang Pei <huangpei@loongson.cn>
    MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48

Jesse Brandeburg <jesse.brandeburg@intel.com>
    igb: fix netpoll exit with traffic

Maurizio Lombardi <mlombard@redhat.com>
    nvmet: use IOCB_NOWAIT only if the filesystem supports it

Eric Dumazet <edumazet@google.com>
    tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
    PM: hibernate: use correct mode for swsusp_close()

Kumar Thangavel <kumarthangavel.hcl@gmail.com>
    net/ncsi : Add payload to be 32-bit aligned to fix dropped packets

Varun Prakash <varun@chelsio.com>
    nvmet-tcp: fix incomplete data digest send

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Ensure the active closing peer first closes clcsock

Mike Christie <michael.christie@oracle.com>
    scsi: core: sysfs: Fix setting device state to SDEV_RUNNING

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: ipv6: add fib6_nh_release_dsts stub

Diana Wang <na.wang@corigine.com>
    nfp: checking parameter process for rx-usecs/tx-usecs is invalid

Eric Dumazet <edumazet@google.com>
    ipv6: fix typos in __ip6_finish_output()

Nitesh B Venkatesh <nitesh.b.venkatesh@intel.com>
    iavf: Prevent changing static ITR values if adaptive moderation is on

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vc4: fix error code in vc4_create_object()

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix kernel panic during drive powercycle test

Takashi Iwai <tiwai@suse.de>
    ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv42: Don't fail clone() unless the OP_CLONE operation failed

Peng Fan <peng.fan@nxp.com>
    firmware: arm_scmi: pm: Propagate return value to caller

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: handle iftypes as u32

Takashi Iwai <tiwai@suse.de>
    ASoC: topology: Add missing rwsem around snd_ctl_remove() calls

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6routing: Conditionally reset FrontEnd Mixer

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Add interrupt properties to GPIO node

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Fix I2C controller interrupt

yangxingwu <xingwu.yang@gmail.com>
    netfilter: ipvs: Fix reuse connection if RS weight is 0

David Hildenbrand <david@redhat.com>
    proc/vmcore: fix clearing user buffer by properly using clear_user()

Marek Behún <kabel@kernel.org>
    arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function

Marek Behún <kabel@kernel.org>
    pinctrl: armada-37xx: Correct PWM pins definitions

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for bus mastering and PCI_COMMAND on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Simplify initialization of rootcap on virtual bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Implement re-issuing config requests on CRS response

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix PCIe Max Payload Size setting

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Configure PCIe resources from 'ranges' DT property

Russell King <rmk+kernel@armlinux.org.uk>
    PCI: pci-bridge-emul: Fix array overruns, improve safety

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Update comment about disabling link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix compilation on s390

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Don't touch PCIe registers if no card connected

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Replace custom macros by standard linux/pci_regs.h macros

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Issue PERST via GPIO

Marek Behún <marek.behun@nic.cz>
    PCI: aardvark: Improve link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Train link immediately after enabling training

Grzegorz Jaszczyk <jaz@semihalf.com>
    PCI: aardvark: Fix big endian support

Remi Pommarel <repk@triplefau.lt>
    PCI: aardvark: Wait for endpoint to be ready before training link

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()

Dylan Hung <dylan_hung@aspeedtech.com>
    mdio: aspeed: Fix "Link is Down" issue

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix ADMA for PAGE_SIZE >= 64KiB

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

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()

Noralf Trønnes <noralf@tronnes.org>
    staging/fbtft: Fix backlight

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts

Helge Deller <deller@gmx.de>
    Revert "parisc: Fix backtrace to always include init funtion names"

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: copy sequence field for the reply

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

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: nexthop: fix null pointer dereference when IPv6 is not enabled

Nathan Chancellor <nathan@kernel.org>
    usb: dwc2: hcd_queue: Fix use of floating point literal

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix ISOC flow for elapsed frames

Mingjie Zhang <superzmj@fibocom.com>
    USB: serial: option: add Fibocom FM101-GL variants

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910S1 0x9200 composition


-------------

Diffstat:

 .../pinctrl/marvell,armada-37xx-pinctrl.txt        |   8 +-
 Documentation/networking/ipvs-sysctl.txt           |   3 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |   4 +-
 arch/arm/mach-socfpga/core.h                       |   2 +-
 arch/arm/mach-socfpga/platsmp.c                    |   8 +-
 arch/arm64/boot/dts/marvell/armada-3720-db.dts     |   3 +
 .../boot/dts/marvell/armada-3720-espressobin.dts   |   1 +
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   4 -
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   2 +-
 arch/mips/Kconfig                                  |   2 +-
 arch/parisc/kernel/vmlinux.lds.S                   |   3 +-
 arch/powerpc/kvm/book3s_hv_builtin.c               |   5 +-
 arch/s390/mm/pgtable.c                             |  13 +
 drivers/android/binder.c                           |   2 +-
 drivers/block/xen-blkfront.c                       | 126 +++--
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |   4 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   2 +-
 drivers/hid/wacom_wac.c                            |   8 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/media/cec/cec-adap.c                       |   1 +
 drivers/mmc/host/sdhci.c                           |  21 +-
 drivers/mmc/host/sdhci.h                           |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  30 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  11 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |   3 -
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +-
 drivers/net/phy/mdio-aspeed.c                      |   7 +
 drivers/net/xen-netfront.c                         | 255 +++++----
 drivers/nvme/target/io-cmd-file.c                  |   4 +-
 drivers/nvme/target/tcp.c                          |   7 +-
 drivers/pci/controller/pci-aardvark.c              | 576 +++++++++++++++++----
 drivers/pci/pci-bridge-emul.c                      |  11 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  17 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   2 +-
 drivers/scsi/scsi_sysfs.c                          |   2 +-
 drivers/staging/fbtft/fb_ssd1351.c                 |   4 -
 drivers/staging/fbtft/fbtft-core.c                 |   9 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   3 +-
 drivers/tty/hvc/hvc_xen.c                          |  17 +-
 drivers/usb/core/hub.c                             |  23 +-
 drivers/usb/dwc2/gadget.c                          |  17 +-
 drivers/usb/dwc2/hcd_queue.c                       |   2 +-
 drivers/usb/serial/option.c                        |   5 +
 drivers/usb/typec/tcpm/fusb302.c                   |   6 +-
 drivers/vhost/vsock.c                              |   2 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  27 +-
 fs/cifs/file.c                                     |  35 +-
 fs/f2fs/node.c                                     |   1 +
 fs/fuse/dev.c                                      |  10 +-
 fs/nfs/nfs42xdr.c                                  |   3 +-
 fs/proc/vmcore.c                                   |  16 +-
 include/linux/ipc_namespace.h                      |  15 +
 include/linux/sched/task.h                         |   2 +-
 include/net/ip6_fib.h                              |   1 +
 include/net/ipv6_stubs.h                           |   1 +
 include/net/nfc/nci_core.h                         |   1 +
 include/net/nl802154.h                             |   7 +-
 include/xen/interface/io/ring.h                    | 293 ++++++-----
 ipc/shm.c                                          | 189 +++++--
 kernel/power/hibernate.c                           |   6 +-
 kernel/trace/trace.h                               |  24 +-
 kernel/trace/trace_events.c                        |   7 +
 kernel/trace/trace_uprobe.c                        |   1 +
 net/8021q/vlan.c                                   |   3 -
 net/8021q/vlan_dev.c                               |   3 +
 net/ipv4/nexthop.c                                 |  35 +-
 net/ipv4/tcp_cubic.c                               |   5 +-
 net/ipv6/af_inet6.c                                |   1 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/route.c                                   |  19 +
 net/ncsi/ncsi-cmd.c                                |  24 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   8 +-
 net/nfc/nci/core.c                                 |  19 +-
 net/smc/af_smc.c                                   |   8 +-
 net/smc/smc_close.c                                |   6 +
 sound/pci/ctxfi/ctamixer.c                         |  14 +-
 sound/pci/ctxfi/ctdaio.c                           |  16 +-
 sound/pci/ctxfi/ctresource.c                       |   7 +-
 sound/pci/ctxfi/ctresource.h                       |   4 +-
 sound/pci/ctxfi/ctsrc.c                            |   7 +-
 sound/soc/qcom/qdsp6/q6routing.c                   |   6 +-
 sound/soc/soc-topology.c                           |   3 +
 85 files changed, 1464 insertions(+), 617 deletions(-)


