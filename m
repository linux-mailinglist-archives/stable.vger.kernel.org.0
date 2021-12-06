Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D73469A58
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345533AbhLFPHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:07:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37666 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345753AbhLFPFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:05:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 708CAB8111A;
        Mon,  6 Dec 2021 15:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCBDC341C2;
        Mon,  6 Dec 2021 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802890;
        bh=k0jOFn6iUEFBasrAcYM5fpX2ztJgVGk9MdECo3o/6mc=;
        h=From:To:Cc:Subject:Date:From;
        b=EMnhSR/aJ9QJoOa24cWDzL6Dif0miBYEOmTgW32XYd/DR5T49YgT3bt1JnAn571B8
         UJb66KcR8Z9mc2dtU8e9WtPIZNS1Ph9QXqGCHi4nexoFOt79ppi4umOKxAdO6lfc8T
         /aveEbY3RpinWM4uHixmIaCc314k5+uF2LXV57Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/62] 4.9.292-rc1 review
Date:   Mon,  6 Dec 2021 15:55:43 +0100
Message-Id: <20211206145549.155163074@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.292-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.292-rc1
X-KernelTest-Deadline: 2021-12-08T14:55+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.292 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.292-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.292-rc1

Johan Hovold <johan@kernel.org>
    serial: core: fix transmit-buffer reset and memleak

Pierre Gondois <Pierre.Gondois@arm.com>
    serial: pl011: Add ACPI SBSA UART match id

Sven Eckelmann <sven@narfation.org>
    tty: serial: msm_serial: Deactivate RX DMA for polling support

Maciej W. Rozycki <macro@orcam.me.uk>
    vgacon: Propagate console boot parameters before calling `vc_resize'

Helge Deller <deller@gmx.de>
    parisc: Fix "make install" on newer debian releases

William Kucharski <william.kucharski@oracle.com>
    net/rds: correct socket tunable error in rds_tcp_tune()

Arnd Bergmann <arnd@arndb.de>
    siphash: use _unaligned version by default

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

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: fix incorrect used length reported to the guest

Nadav Amit <namit@vmware.com>
    hugetlbfs: flush TLBs correctly after huge_pmd_unshare

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check pid filtering when creating events

Eric Dumazet <edumazet@google.com>
    tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
    PM: hibernate: use correct mode for swsusp_close()

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

Lee Jones <lee.jones@linaro.org>
    staging: ion: Prevent incorrect reference counting behavour


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |   2 +
 arch/arm/include/asm/tlb.h                         |   8 +
 arch/arm/mach-socfpga/core.h                       |   2 +-
 arch/arm/mach-socfpga/platsmp.c                    |   8 +-
 arch/ia64/include/asm/tlb.h                        |  10 +
 arch/parisc/install.sh                             |   1 +
 arch/s390/include/asm/tlb.h                        |  14 ++
 arch/s390/kernel/setup.c                           |   3 -
 arch/sh/include/asm/tlb.h                          |  10 +
 arch/um/include/asm/tlb.h                          |  12 +
 drivers/android/binder.c                           |   2 +-
 drivers/ata/sata_fsl.c                             |  20 +-
 drivers/block/xen-blkfront.c                       | 126 ++++++----
 drivers/gpu/drm/vc4/vc4_bo.c                       |   2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |  34 +--
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   4 +
 drivers/net/ethernet/natsemi/xtsonic.c             |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  10 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/xen-netfront.c                         | 257 +++++++++++++--------
 drivers/platform/x86/thinkpad_acpi.c               |  12 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |   6 +-
 drivers/staging/android/ion/ion.c                  |   6 +
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   3 +-
 drivers/thermal/thermal_core.c                     |   2 +
 drivers/tty/hvc/hvc_xen.c                          |  17 +-
 drivers/tty/serial/amba-pl011.c                    |   1 +
 drivers/tty/serial/msm_serial.c                    |   3 +
 drivers/tty/serial/serial_core.c                   |  13 +-
 drivers/usb/core/hub.c                             |  23 +-
 drivers/usb/serial/option.c                        |   5 +
 drivers/vhost/vsock.c                              |   2 +-
 drivers/video/console/vgacon.c                     |  14 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  27 ++-
 fs/file.c                                          |  19 +-
 fs/file_table.c                                    |   9 +-
 fs/fuse/dev.c                                      |  14 +-
 fs/nfs/nfs42proc.c                                 |   5 +-
 fs/nfs/nfs42xdr.c                                  |   3 +-
 fs/proc/vmcore.c                                   |  15 +-
 include/asm-generic/tlb.h                          |   2 +
 include/linux/file.h                               |   2 +
 include/linux/fs.h                                 |   4 +-
 include/linux/ipc_namespace.h                      |  15 ++
 include/linux/kprobes.h                            |   2 +
 include/linux/sched.h                              |   2 +-
 include/linux/shm.h                                |  13 +-
 include/linux/siphash.h                            |  14 +-
 include/net/nfc/nci_core.h                         |   1 +
 include/net/nl802154.h                             |   7 +-
 include/xen/interface/io/ring.h                    | 257 ++++++++++-----------
 ipc/shm.c                                          | 176 ++++++++++----
 kernel/kprobes.c                                   |   3 +
 kernel/power/hibernate.c                           |   6 +-
 kernel/trace/trace.h                               |  24 +-
 kernel/trace/trace_events.c                        |   7 +
 lib/siphash.c                                      |  12 +-
 mm/hugetlb.c                                       |  72 +++++-
 mm/memory.c                                        |  16 ++
 net/ipv4/devinet.c                                 |   2 +-
 net/ipv4/tcp_cubic.c                               |   5 +-
 net/nfc/nci/core.c                                 |  19 +-
 net/rds/tcp.c                                      |   2 +-
 sound/pci/ctxfi/ctamixer.c                         |  14 +-
 sound/pci/ctxfi/ctdaio.c                           |  16 +-
 sound/pci/ctxfi/ctresource.c                       |   7 +-
 sound/pci/ctxfi/ctresource.h                       |   4 +-
 sound/pci/ctxfi/ctsrc.c                            |   7 +-
 sound/soc/soc-topology.c                           |   3 +
 71 files changed, 967 insertions(+), 481 deletions(-)


