Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16630469AB6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347921AbhLFPJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:09:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57238 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346326AbhLFPHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:07:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38792612C1;
        Mon,  6 Dec 2021 15:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B25FC341C2;
        Mon,  6 Dec 2021 15:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803053;
        bh=ge39c/ksOquy8dAuMz4b9MiLhpgSeBW4qWzHZXFI3+M=;
        h=From:To:Cc:Subject:Date:From;
        b=Udi09/UXY0iBPpVbWdO0a9p6LcnCqwRr75/j0cfYmlZ/VyWdswbqTrpUfY3dnq7QE
         k2TslmGZg4BX3zqBVWvWGCtNFp+v5epxTIRhbiADmH6eKcGhGVyTFB9oEWCWF8FUyu
         ttqdAQMhzmaxl5q4Wu68Piu8zEp0kOXYiEOzOm/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 000/106] 4.14.257-rc1 review
Date:   Mon,  6 Dec 2021 15:55:08 +0100
Message-Id: <20211206145555.386095297@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.257-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.257-rc1
X-KernelTest-Deadline: 2021-12-08T14:55+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.257 release.
There are 106 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.257-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.257-rc1

Helge Deller <deller@gmx.de>
    parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Johan Hovold <johan@kernel.org>
    serial: core: fix transmit-buffer reset and memleak

Pierre Gondois <Pierre.Gondois@arm.com>
    serial: pl011: Add ACPI SBSA UART match id

Sven Eckelmann <sven@narfation.org>
    tty: serial: msm_serial: Deactivate RX DMA for polling support

Joerg Roedel <jroedel@suse.de>
    x86/64/mm: Map all kernel memory into trampoline_pgd

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Maciej W. Rozycki <macro@orcam.me.uk>
    vgacon: Propagate console boot parameters before calling `vc_resize'

Helge Deller <deller@gmx.de>
    parisc: Fix "make install" on newer debian releases

Helge Deller <deller@gmx.de>
    parisc: Fix KBUILD_IMAGE for self-extracting kernel

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Keep smc_close_final rc during active close

William Kucharski <william.kucharski@oracle.com>
    net/rds: correct socket tunable error in rds_tcp_tune()

Sven Schuchmann <schuchmann@schleissheimer.de>
    net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Zhou Qingyang <zhou1615@umn.edu>
    net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()

Arnd Bergmann <arnd@arndb.de>
    siphash: use _unaligned version by default

Benjamin Poirier <bpoirier@nvidia.com>
    net: mpls: Fix notifications when deleting a device

Zhou Qingyang <zhou1615@umn.edu>
    net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()

Randy Dunlap <rdunlap@infradead.org>
    natsemi: xtensa: fix section mismatch warnings

Linus Torvalds <torvalds@linux-foundation.org>
    fget: check that the fd still exists after getting a ref to it

Jens Axboe <axboe@kernel.dk>
    fs: add fget_many() and fput_many()

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Limit max data_size of the kretprobe instances

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Ian Rogers <irogers@google.com>
    perf hist: Fix memory leak of a perf_hpp_fmt

Teng Qi <starmiku1207184332@gmail.com>
    net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

zhangyue <zhangyue1@kylinos.cn>
    net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

Teng Qi <starmiku1207184332@gmail.com>
    ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Unblock session then wake up error handler

Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>
    thermal: core: Reset previous low and high trip during thermal zone init

Wang Yugui <wangyugui@e16-tech.com>
    btrfs: check-integrity: fix a warning on write caching disabled disk

Vasily Gorbik <gor@linux.ibm.com>
    s390/setup: avoid using memblock_enforce_memory_limit

Slark Xiao <slark_xiao@163.com>
    platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

liuguoqiang <liuguoqiang@uniontech.com>
    net: return correct error code

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: take PMD sharing into account when flushing tlb/caches

Benjamin Coddington <bcodding@redhat.com>
    NFSv42: Fix pagecache invalidation after COPY/CLONE

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
    ipc: WARN if trying to remove ipc object which is absent

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
    shm: extend forced shm destroy to support objects from several IPC nses

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

David Hildenbrand <david@redhat.com>
    proc/vmcore: fix clearing user buffer by properly using clear_user()

Nadav Amit <namit@vmware.com>
    hugetlbfs: flush TLBs correctly after huge_pmd_unshare

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

Frederick Lawler <fred@fredlawl.com>
    PCI: Add PCI_EXP_LNKCTL2_TLS* macros

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix PCIe Max Payload Size setting

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Configure PCIe resources from 'ranges' DT property

Evan Wang <xswang@marvell.com>
    PCI: aardvark: Remove PCIe outbound window configuration

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Update comment about disabling link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix compilation on s390

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Don't touch PCIe registers if no card connected

Thomas Petazzoni <thomas.petazzoni@bootlin.com>
    PCI: aardvark: Introduce an advk_pcie_valid_device() helper

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

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    PCI: aardvark: Fix I/O space page leak

David Hildenbrand <david@redhat.com>
    s390/mm: validate VMA in PGSTE manipulation functions

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check pid filtering when creating events

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: fix incorrect used length reported to the guest

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

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: handle iftypes as u32

Takashi Iwai <tiwai@suse.de>
    ASoC: topology: Add missing rwsem around snd_ctl_remove() calls

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Add interrupt properties to GPIO node

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Fix I2C controller interrupt

yangxingwu <xingwu.yang@gmail.com>
    netfilter: ipvs: Fix reuse connection if RS weight is 0

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
 arch/parisc/Makefile                               |   5 +
 arch/parisc/install.sh                             |   1 +
 arch/parisc/kernel/time.c                          |  24 +-
 arch/s390/include/asm/tlb.h                        |  14 +
 arch/s390/kernel/setup.c                           |   3 -
 arch/s390/mm/pgtable.c                             |  13 +
 arch/sh/include/asm/tlb.h                          |  10 +
 arch/um/include/asm/tlb.h                          |  12 +
 arch/x86/realmode/init.c                           |  12 +-
 drivers/android/binder.c                           |   2 +-
 drivers/ata/sata_fsl.c                             |  20 +-
 drivers/block/xen-blkfront.c                       | 126 ++++--
 drivers/gpu/drm/vc4/vc4_bo.c                       |   2 +-
 drivers/hid/wacom_wac.c                            |   8 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/media/cec/cec-adap.c                       |   1 +
 drivers/net/ethernet/dec/tulip/de4x5.c             |  34 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   4 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   9 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  10 +-
 drivers/net/usb/lan78xx.c                          |   2 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/xen-netfront.c                         | 257 +++++++-----
 drivers/pci/host/pci-aardvark.c                    | 463 +++++++++++++++++----
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  28 +-
 drivers/platform/x86/thinkpad_acpi.c               |  12 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |   6 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   3 +-
 drivers/staging/typec/tcpm.c                       |   4 -
 drivers/thermal/thermal_core.c                     |   2 +
 drivers/tty/hvc/hvc_xen.c                          |  17 +-
 drivers/tty/serial/amba-pl011.c                    |   1 +
 drivers/tty/serial/msm_serial.c                    |   3 +
 drivers/tty/serial/serial_core.c                   |  13 +-
 drivers/usb/core/hub.c                             |  23 +-
 drivers/usb/host/xhci-ring.c                       |  21 +-
 drivers/usb/serial/option.c                        |   5 +
 drivers/vhost/vsock.c                              |   2 +-
 drivers/video/console/vgacon.c                     |  14 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  27 +-
 fs/btrfs/disk-io.c                                 |  14 +-
 fs/file.c                                          |  19 +-
 fs/file_table.c                                    |   9 +-
 fs/fuse/dev.c                                      |  14 +-
 fs/nfs/nfs42proc.c                                 |   5 +-
 fs/nfs/nfs42xdr.c                                  |   3 +-
 fs/proc/vmcore.c                                   |  15 +-
 include/asm-generic/tlb.h                          |   2 +
 include/linux/file.h                               |   2 +
 include/linux/fs.h                                 |   4 +-
 include/linux/ipc_namespace.h                      |  15 +
 include/linux/kprobes.h                            |   2 +
 include/linux/sched/task.h                         |   2 +-
 include/linux/shm.h                                |  13 +-
 include/linux/siphash.h                            |  14 +-
 include/net/nfc/nci_core.h                         |   1 +
 include/net/nl802154.h                             |   7 +-
 include/uapi/linux/pci_regs.h                      |   5 +
 include/xen/interface/io/ring.h                    | 293 +++++++------
 ipc/shm.c                                          | 176 ++++++--
 ipc/util.c                                         |   6 +-
 kernel/kprobes.c                                   |   3 +
 kernel/power/hibernate.c                           |   6 +-
 kernel/trace/trace.h                               |  24 +-
 kernel/trace/trace_events.c                        |   7 +
 lib/siphash.c                                      |  12 +-
 mm/hugetlb.c                                       |  72 +++-
 mm/memory.c                                        |  10 +
 net/ipv4/devinet.c                                 |   2 +-
 net/ipv4/tcp_cubic.c                               |   5 +-
 net/ipv6/ip6_output.c                              |   2 +-
 net/mpls/af_mpls.c                                 |  68 ++-
 net/netfilter/ipvs/ip_vs_core.c                    |   8 +-
 net/nfc/nci/core.c                                 |  19 +-
 net/rds/tcp.c                                      |   2 +-
 net/smc/af_smc.c                                   |   8 +-
 net/smc/smc_close.c                                |  10 +
 sound/pci/ctxfi/ctamixer.c                         |  14 +-
 sound/pci/ctxfi/ctdaio.c                           |  16 +-
 sound/pci/ctxfi/ctresource.c                       |   7 +-
 sound/pci/ctxfi/ctresource.h                       |   4 +-
 sound/pci/ctxfi/ctsrc.c                            |   7 +-
 sound/soc/soc-topology.c                           |   3 +
 tools/perf/ui/hist.c                               |  28 +-
 tools/perf/util/hist.h                             |   1 -
 99 files changed, 1591 insertions(+), 670 deletions(-)


