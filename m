Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4E21F435
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfEOK6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbfEOK6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:58:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA53320881;
        Wed, 15 May 2019 10:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917913;
        bh=asH40bIXYZ3fRyNit2sIbJEQ1mmYkpptWG94Gp/P8zM=;
        h=From:To:Cc:Subject:Date:From;
        b=GOI+f6RS2S/HpyrYB5shXyV/Ljvre/zUW11iwcQnq6cQjnwD4OBnCAh/FhLARbNe1
         vjkQAVwR7aSL7y3MPen94q19mGX0gtUCNFBWCK9dz5AoxCyDNsPw1KFEE0Tfm0h4V1
         /xDqwzAVSXr6tLejXVQqTpKkaFGyYXX4FcApV2Nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 3.18 00/86] 3.18.140-stable review
Date:   Wed, 15 May 2019 12:54:37 +0200
Message-Id: <20190515090642.339346723@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-3.18.140-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-3.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 3.18.140-rc1
X-KernelTest-Deadline: 2019-05-17T09:06+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.18.140 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 17 May 2019 09:04:45 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.18.140-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-3.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.18.140-rc1

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/booke64: set RI in default MSR

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl

Jarod Wilson <jarod@redhat.com>
    bonding: fix arp_validate toggling in active-backup mode

David Ahern <dsahern@gmail.com>
    ipv4: Fix raw socket lookup for local traffic

Hangbin Liu <liuhangbin@gmail.com>
    vlan: disable SIOCSHWTSTAMP in container

YueHaibing <yuehaibing@huawei.com>
    packet: Fix error path in packet_init

Christophe Leroy <christophe.leroy@c-s.fr>
    net: ucc_geth - fix Oops when changing number of buffers in the ring

Tobin C. Harding <tobin@kernel.org>
    bridge: Fix error path for kobject_init_and_add()

Johan Hovold <johan@kernel.org>
    USB: serial: fix unthrottle races

Oliver Neukum <oneukum@suse.com>
    USB: serial: use variable for status

Nigel Croxon <ncroxon@redhat.com>
    Don't jump to compute_result state from check_result state

Lucas Stach <l.stach@pengutronix.de>
    gpu: ipu-v3: dp: fix CSC handling

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/net: correct the return value for run_netsocktests

Arnd Bergmann <arnd@arndb.de>
    s390: ctcm: fix ctcm_new_device error return code

Dan Williams <dan.j.williams@intel.com>
    init: initialize jump labels before command line option parsing

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    tools lib traceevent: Fix missing equality check for strcmp

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3270: fix lockdep false positive on view->lock

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/dasd: Fix capacity calculation for large volumes

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys

Sven Van Asbroeck <thesven73@gmail.com>
    iio: adc: xilinx: fix potential use-after-free on remove

Gustavo A. R. Silva <gustavo@embeddedor.com>
    platform/x86: sony-laptop: Fix unintentional fall-through

Francesco Ruggeri <fruggeri@arista.com>
    netfilter: compat: initialize all fields in xt_init

Ben Hutchings <ben@decadent.org.uk>
    timer/debug: Change /proc/timer_stats from 0644 to 0600

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Align minimum encryption key size for LE and BR/EDR connections

Young Xiao <YangX92@hotmail.com>
    Bluetooth: hidp: fix buffer overflow

Andrew Vasquez <andrewv@marvell.com>
    scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS routines

Prasad Sodagudi <psodagud@codeaurora.org>
    genirq: Prevent use-after-free and work list corruption

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Set exclusion range correctly

Varun Prakash <varun@chelsio.com>
    scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Annaliese McDermond <nh6z@nh6z.net>
    ASoC: tlv320aic32x4: Fix Common Pins

Daniel Mack <daniel@zonque.org>
    ASoC: cs4270: Set auto-increment bit for register writes

Rander Wang <rander.wang@linux.intel.com>
    ASoC:soc-pcm:fix a codec fixup issue in TDM case

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: fix a race condition when smp task timeout

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: v4l2: i2c: ov7670: Fix PLL bypass register values

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac write calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac read calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: allow adt751x to use internal vref for all dacs

Malte Leip <malte@leip.net>
    usb: usbip: fix isoc packet num validation in get_pipe

Arnd Bergmann <arnd@arndb.de>
    ARM: iop: don't use using 64-bit DMA masks

Arnd Bergmann <arnd@arndb.de>
    ARM: orion: don't use using 64-bit DMA masks

Guenter Roeck <linux@roeck-us.net>
    xsysace: Fix error handling in ace_setup

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: fix memory leak for resv_map

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Fix calculation of sub-channel count

Al Viro <viro@zeniv.linux.org.uk>
    jffs2: fix use-after-free on symlink traversal

Konstantin Khorenko <khorenko@virtuozzo.com>
    bonding: show full hw address in sysfs for slave entries

Arvind Sankar <niveditas98@gmail.com>
    igb: Fix WARN_ONCE on runtime suspend

Geert Uytterhoeven <geert+renesas@glider.be>
    rtc: sh: Fix invalid alarm warning for non-enabled alarm

He, Bo <bo.he@intel.com>
    HID: debug: fix race condition with between rdesc_show() and device removal

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug caused by duplicate interface PM usage counter

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: media: disable tlg2300 driver

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix unterminated string returned by usb_string()

Alan Stern <stern@rowland.harvard.edu>
    USB: w1 ds2490: Fix bug caused by improper use of altsetting array

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Fix protection fault after device removal

Eric Dumazet <edumazet@google.com>
    ipv6/flowlabel: wait rcu grace period before put_pid()

Willem de Bruijn <willemb@google.com>
    packet: validate msg_namelen in send directly

Willem de Bruijn <willemb@google.com>
    ipv6: invert flowlabel sharing check in process and user mode

Shmulik Ladkani <shmulik@metanetworks.com>
    ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Changbin Du <changbin.du@gmail.com>
    kconfig/[mn]conf: handle backspace (^H) key

raymond pang <raymondpangxd@gmail.com>
    libata: fix using DMA buffers on stack

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RSCN

Al Viro <viro@zeniv.linux.org.uk>
    ceph: fix use-after-free on symlink traversal

Mukesh Ojha <mojha@codeaurora.org>
    usb: u132-hcd: fix resource leak

Kangjie Lu <kjlu@umn.edu>
    scsi: qla4xxx: fix a potential NULL pointer dereference

Wen Yang <wen.yang99@zte.com.cn>
    net: ibm: fix possible object reference leak

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Set initial carrier state to down

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Delay requesting IRQ until opened

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Reassert reset pin if chip ID check fails

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Dequeue RX packets explicitly

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2272: Fix net2272_dequeue()

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2280: Fix overrun of OUT messages

Aditya Pakki <pakki001@umn.edu>
    qlcnic: Avoid potential NULL pointer dereference

Vinod Koul <vkoul@kernel.org>
    net: stmmac: move stmmac_check_ether_addr() to driver probe

Hangbin Liu <liuhangbin@gmail.com>
    team: fix possible recursive locking when add slaves

Eric Dumazet <edumazet@google.com>
    ipv4: add sanity checks in ipv4_link_failure()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "block/loop: Use global lock for ioctl() operation."

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.

YueHaibing <yuehaibing@huawei.com>
    fs/proc/proc_sysctl.c: Fix a NULL pointer dereference

Linus Torvalds <torvalds@linux-foundation.org>
    slip: make slhc_free() silently accept an error pointer

NeilBrown <neilb@suse.com>
    sunrpc: don't mark uninitialised items as VALID.

Jeff Layton <jlayton@kernel.org>
    ceph: ensure d_name stability in ceph_dentry_hash()

Xie XiuQi <xiexiuqi@huawei.com>
    sched/numa: Fix a possible divide-by-zero

Peter Zijlstra <peterz@infradead.org>
    trace: Fix preempt_enable_no_resched() abuse

Aurelien Jarno <aurelien@aurel32.net>
    MIPS: scall64-o32: Fix indirect syscall number load


-------------

Diffstat:

 Documentation/usb/power-management.txt             | 14 ++++--
 Makefile                                           |  4 +-
 arch/arm/mach-iop13xx/setup.c                      |  8 +--
 arch/arm/mach-iop13xx/tpmi.c                       | 10 ++--
 arch/arm/plat-iop/adma.c                           |  6 +--
 arch/arm/plat-orion/common.c                       |  4 +-
 arch/mips/kernel/scall64-o32.S                     |  2 +-
 arch/powerpc/include/asm/reg_booke.h               |  2 +-
 arch/x86/kvm/trace.h                               |  4 +-
 drivers/ata/libata-zpodd.c                         | 34 +++++++++----
 drivers/block/loop.c                               | 47 +++++++++---------
 drivers/block/loop.h                               |  1 +
 drivers/block/xsysace.c                            |  2 +
 drivers/gpu/ipu-v3/ipu-dp.c                        | 12 +++--
 drivers/hid/hid-debug.c                            |  5 ++
 drivers/hid/hid-input.c                            |  4 ++
 drivers/iio/adc/xilinx-xadc-core.c                 |  2 +-
 drivers/iommu/amd_iommu_init.c                     |  2 +-
 drivers/md/raid5.c                                 | 19 ++------
 drivers/media/i2c/ov7670.c                         | 16 +++---
 drivers/media/usb/tlg2300/Kconfig                  |  1 +
 drivers/net/bonding/bond_options.c                 |  7 ---
 drivers/net/bonding/bond_sysfs_slave.c             |  4 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |  8 ++-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |  1 +
 drivers/net/ethernet/intel/igb/e1000_defines.h     |  2 +
 drivers/net/ethernet/intel/igb/igb_main.c          | 57 +++-------------------
 drivers/net/ethernet/micrel/ks8851.c               | 36 +++++++-------
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |  2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  4 +-
 drivers/net/slip/slhc.c                            |  2 +-
 drivers/net/team/team.c                            |  6 +++
 drivers/platform/x86/sony-laptop.c                 |  8 +--
 drivers/rtc/rtc-sh.c                               |  2 +-
 drivers/s390/block/dasd_eckd.c                     |  6 +--
 drivers/s390/char/con3270.c                        |  2 +-
 drivers/s390/char/fs3270.c                         |  3 +-
 drivers/s390/char/raw3270.c                        |  3 +-
 drivers/s390/char/raw3270.h                        |  4 +-
 drivers/s390/char/tty3270.c                        |  3 +-
 drivers/s390/net/ctcm_main.c                       |  1 +
 drivers/s390/scsi/zfcp_fc.c                        | 21 ++++++--
 drivers/scsi/csiostor/csio_scsi.c                  |  5 +-
 drivers/scsi/libsas/sas_expander.c                 |  9 ++--
 drivers/scsi/qla2xxx/qla_attr.c                    |  4 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |  2 +
 drivers/scsi/storvsc_drv.c                         | 13 ++++-
 drivers/staging/iio/addac/adt7316.c                | 22 ++++++---
 drivers/usb/core/driver.c                          | 13 -----
 drivers/usb/core/message.c                         |  4 +-
 drivers/usb/gadget/udc/net2272.c                   |  1 +
 drivers/usb/gadget/udc/net2280.c                   |  4 +-
 drivers/usb/host/u132-hcd.c                        |  3 ++
 drivers/usb/misc/yurex.c                           |  1 +
 drivers/usb/serial/generic.c                       | 57 ++++++++++++++++------
 drivers/usb/storage/realtek_cr.c                   | 13 ++---
 drivers/usb/usbip/stub_rx.c                        | 18 ++-----
 drivers/usb/usbip/usbip_common.h                   |  7 +++
 drivers/virt/fsl_hypervisor.c                      | 29 ++++++-----
 drivers/w1/masters/ds2490.c                        |  6 +--
 fs/ceph/dir.c                                      |  6 ++-
 fs/ceph/inode.c                                    |  2 +-
 fs/hugetlbfs/inode.c                               | 20 +++++---
 fs/jffs2/readinode.c                               |  5 --
 fs/jffs2/super.c                                   |  5 +-
 fs/nfs/super.c                                     |  3 +-
 fs/proc/proc_sysctl.c                              |  6 ++-
 include/linux/usb.h                                |  2 -
 include/net/bluetooth/hci_core.h                   |  3 ++
 init/main.c                                        |  4 +-
 kernel/irq/manage.c                                |  4 +-
 kernel/sched/fair.c                                |  4 ++
 kernel/time/timer_stats.c                          |  2 +-
 kernel/trace/ring_buffer.c                         |  2 +-
 net/8021q/vlan_dev.c                               |  4 +-
 net/bluetooth/hci_conn.c                           |  8 +++
 net/bluetooth/hidp/sock.c                          |  1 +
 net/bridge/br_if.c                                 | 13 +++--
 net/bridge/netfilter/ebtables.c                    |  3 +-
 net/ipv4/ip_output.c                               |  1 +
 net/ipv4/raw.c                                     |  4 +-
 net/ipv4/route.c                                   | 32 ++++++++----
 net/ipv6/ip6_flowlabel.c                           | 23 +++++----
 net/netfilter/x_tables.c                           |  2 +-
 net/packet/af_packet.c                             | 48 ++++++++++++------
 net/sunrpc/cache.c                                 |  3 ++
 scripts/kconfig/lxdialog/inputbox.c                |  3 +-
 scripts/kconfig/nconf.c                            |  2 +-
 scripts/kconfig/nconf.gui.c                        |  3 +-
 sound/soc/codecs/cs4270.c                          |  1 +
 sound/soc/codecs/tlv320aic32x4.c                   |  2 +
 sound/soc/soc-pcm.c                                |  7 ++-
 tools/lib/traceevent/event-parse.c                 |  2 +-
 tools/testing/selftests/net/run_netsocktests       |  2 +-
 94 files changed, 474 insertions(+), 350 deletions(-)


