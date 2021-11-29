Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E89A461DA5
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378282AbhK2S1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:27:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59076 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350198AbhK2SZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:25:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB234B815D2;
        Mon, 29 Nov 2021 18:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F99C53FAD;
        Mon, 29 Nov 2021 18:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210099;
        bh=eiwQLt4zZGtLLmSnpkvYDjBCMzfEKtlYlt+nbr2p85E=;
        h=From:To:Cc:Subject:Date:From;
        b=OvASJd8EjSXnFklU07CqzzRV18yCMmJsXg044TWS1FiIlsHjxmGLMMyAKBjfiiEj8
         yW4TfDutAqToJYQfB+NgDSukSUUcxYJjbgKofEk4K7PEYJd0c8zGLq/Lc945ceABkY
         nZSg+kYCPU+tiXu62CUE0/dG04cvuk5TXOLyPGFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/69] 4.19.219-rc1 review
Date:   Mon, 29 Nov 2021 19:17:42 +0100
Message-Id: <20211129181703.670197996@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.219-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.219-rc1
X-KernelTest-Deadline: 2021-12-01T18:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.219 release.
There are 69 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.219-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.219-rc1

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

Nadav Amit <namit@vmware.com>
    hugetlbfs: flush TLBs correctly after huge_pmd_unshare

David Hildenbrand <david@redhat.com>
    s390/mm: validate VMA in PGSTE manipulation functions

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check pid filtering when creating events

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: fix incorrect used length reported to the guest

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix VF RSS failed problem after PF enable multi-TCs

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Don't call clcsock shutdown twice when smc shutdown

Huang Pei <huangpei@loongson.cn>
    MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48

Eric Dumazet <edumazet@google.com>
    tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
    PM: hibernate: use correct mode for swsusp_close()

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Ensure the active closing peer first closes clcsock

Eric Dumazet <edumazet@google.com>
    ipv6: fix typos in __ip6_finish_output()

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

Marek Behún <marek.behun@nic.cz>
    arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function

Miquel Raynal <miquel.raynal@bootlin.com>
    arm64: dts: marvell: armada-37xx: declare PCIe reset pin

Marek Behún <kabel@kernel.org>
    pinctrl: armada-37xx: Correct PWM pins definitions

Gregory CLEMENT <gregory.clement@bootlin.com>
    pinctrl: armada-37xx: add missing pin: PCIe1 Wakeup

Marek Behún <marek.behun@nic.cz>
    pinctrl: armada-37xx: Correct mpp definitions

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix checking for link up via LTSSM state

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix PCIe Max Payload Size setting

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Configure PCIe resources from 'ranges' DT property

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Update comment about disabling link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix compilation on s390

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Don't touch PCIe registers if no card connected

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Indicate error in 'val' when config read fails

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Replace custom macros by standard linux/pci_regs.h macros

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Issue PERST via GPIO

Marek Behún <marek.behun@nic.cz>
    PCI: aardvark: Improve link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Train link immediately after enabling training

Remi Pommarel <repk@triplefau.lt>
    PCI: aardvark: Wait for endpoint to be ready before training link

Wen Yang <wen.yang99@zte.com.cn>
    PCI: aardvark: Fix a leaked reference by adding missing of_node_put()

David Hildenbrand <david@redhat.com>
    proc/vmcore: fix clearing user buffer by properly using clear_user()

Randy Dunlap <rdunlap@infradead.org>
    xtensa: use CONFIG_USE_OF instead of CONFIG_OF

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix pid filtering when triggers are attached

Stefano Stabellini <stefano.stabellini@xilinx.com>
    xen: detect uninitialized xenbus in xenbus_init

Stefano Stabellini <stefano.stabellini@xilinx.com>
    xen: don't continue xenstore initialization in case of errors

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix page stealing

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts

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

Nathan Chancellor <nathan@kernel.org>
    usb: dwc2: hcd_queue: Fix use of floating point literal

Mingjie Zhang <superzmj@fibocom.com>
    USB: serial: option: add Fibocom FM101-GL variants

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910S1 0x9200 composition


-------------

Diffstat:

 .../pinctrl/marvell,armada-37xx-pinctrl.txt        |  26 +-
 Documentation/networking/ipvs-sysctl.txt           |   3 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |   4 +-
 arch/arm/include/asm/tlb.h                         |   8 +
 arch/arm/mach-socfpga/core.h                       |   2 +-
 arch/arm/mach-socfpga/platsmp.c                    |   8 +-
 arch/arm64/boot/dts/marvell/armada-3720-db.dts     |   3 +
 .../boot/dts/marvell/armada-3720-espressobin.dts   |   3 +
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   9 +
 arch/ia64/include/asm/tlb.h                        |  10 +
 arch/mips/Kconfig                                  |   2 +-
 arch/s390/include/asm/tlb.h                        |  16 +
 arch/s390/mm/pgtable.c                             |  13 +
 arch/sh/include/asm/tlb.h                          |  10 +
 arch/um/include/asm/tlb.h                          |  12 +
 arch/xtensa/include/asm/vectors.h                  |   2 +-
 arch/xtensa/kernel/setup.c                         |  12 +-
 arch/xtensa/mm/mmu.c                               |   2 +-
 drivers/android/binder.c                           |   2 +-
 drivers/block/xen-blkfront.c                       | 126 ++++--
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |   4 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   2 +-
 drivers/hid/wacom_wac.c                            |   8 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/media/cec/cec-adap.c                       |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/xen-netfront.c                         | 257 +++++++-----
 drivers/pci/controller/pci-aardvark.c              | 436 ++++++++++++++++++---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  28 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   3 +-
 drivers/tty/hvc/hvc_xen.c                          |  17 +-
 drivers/usb/core/hub.c                             |  23 +-
 drivers/usb/dwc2/hcd_queue.c                       |   2 +-
 drivers/usb/serial/option.c                        |   5 +
 drivers/vhost/vsock.c                              |   2 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  27 +-
 fs/fuse/dev.c                                      |  14 +-
 fs/nfs/nfs42xdr.c                                  |   3 +-
 fs/proc/vmcore.c                                   |  15 +-
 include/asm-generic/tlb.h                          |   2 +
 include/net/nfc/nci_core.h                         |   1 +
 include/net/nl802154.h                             |   7 +-
 include/xen/interface/io/ring.h                    | 293 +++++++-------
 kernel/power/hibernate.c                           |   6 +-
 kernel/trace/trace.h                               |  24 +-
 kernel/trace/trace_events.c                        |   7 +
 mm/hugetlb.c                                       |  23 +-
 mm/memory.c                                        |  10 +
 net/ipv4/tcp_cubic.c                               |   5 +-
 net/ipv6/ip6_output.c                              |   2 +-
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
 63 files changed, 1157 insertions(+), 452 deletions(-)


