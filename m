Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7C4419A2C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbhI0RHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235515AbhI0RGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4AF8611C0;
        Mon, 27 Sep 2021 17:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762301;
        bh=mSZnnZSIb+wyVceWkwgKYaYyNxzHzbZQYDyWbuEHOug=;
        h=From:To:Cc:Subject:Date:From;
        b=taWpbXsTMfhJlfJ1Alo4M2huQtAULIkDgZTv3llf9wYAr+wJJBujudn/Tsc0LvzT7
         fUD+DjdWlk3nKYR4TjV8g0RGp5ZqblrjxwipUlndURb5UzO4cfYC/xsi2oGKDTILan
         n6V+pSguUl6gwQIAWXMbQwowaE7gZI3IMwHhDHew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/68] 5.4.150-rc1 review
Date:   Mon, 27 Sep 2021 19:01:56 +0200
Message-Id: <20210927170219.901812470@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.150-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.150-rc1
X-KernelTest-Deadline: 2021-09-29T17:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.150 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.150-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.150-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    qnx4: work around gcc false positive warning bug

Juergen Gross <jgross@suse.com>
    xen/balloon: fix balloon kthread freezing

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: armada-37xx: Extend PCIe MEM space

Antoine Tenart <atenart@kernel.org>
    thermal/drivers/int340x: Do not set a wrong tcc offset on resume

Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
    EDAC/synopsys: Fix wrong value type assignment for edac_mode

Linus Torvalds <torvalds@linux-foundation.org>
    spi: Fix tegra20 build with CONFIG_PM=n

Guenter Roeck <linux@roeck-us.net>
    net: 6pack: Fix tx timeout and slot time

Guenter Roeck <linux@roeck-us.net>
    alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile

Dan Li <ashimida@linux.alibaba.com>
    arm64: Mark __stack_chk_guard as __ro_after_init

Helge Deller <deller@gmx.de>
    parisc: Use absolute_pointer() to define PAGE0

Linus Torvalds <torvalds@linux-foundation.org>
    qnx4: avoid stringop-overread errors

Linus Torvalds <torvalds@linux-foundation.org>
    sparc: avoid stringop-overread errors

Guenter Roeck <linux@roeck-us.net>
    net: i825xx: Use absolute_pointer for memcpy from fixed memory location

Guenter Roeck <linux@roeck-us.net>
    compiler.h: Introduce absolute_pointer macro

Li Jinlin <lijinlin3@huawei.com>
    blk-cgroup: fix UAF by grabbing blkcg lock before destroying blkg pd

Andreas Larsson <andreas@gaisler.com>
    sparc32: page align size in arch_dma_alloc

Anton Eidelman <anton.eidelman@gmail.com>
    nvme-multipath: fix ANA state updates when a namespace is not present

Juergen Gross <jgross@suse.com>
    xen/balloon: use a kernel thread instead a workqueue

Bixuan Cui <cuibixuan@huawei.com>
    bpf: Add oversize check before call kvcalloc()

zhang kai <zhangkaiheb@126.com>
    ipv6: delay fib6_sernum increase in fib6_add

Guenter Roeck <linux@roeck-us.net>
    m68k: Double cast io functions to unsigned long

Jesper Nilsson <jesper.nilsson@axis.com>
    net: stmmac: allow CSR clock of 300MHz

Tong Zhang <ztong0001@gmail.com>
    net: macb: fix use after free on rmmod

Zhihao Cheng <chengzhihao1@huawei.com>
    blktrace: Fix uaf in blk_trace access after removing by sysfs

Christoph Hellwig <hch@lst.de>
    md: fix a lock order reversal in md_alloc

Kaige Fu <kaige.fu@linux.alibaba.com>
    irqchip/gic-v3-its: Fix potential VPE leak on error

Randy Dunlap <rdunlap@infradead.org>
    irqchip/goldfish-pic: Select GENERIC_IRQ_CHIP to fix build

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: lpfc: Use correct scnprintf() limit

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: qla2xxx: Restore initiator in dual mode

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: fix a sign extension bug

Dan Carpenter <dan.carpenter@oracle.com>
    thermal/core: Potential buffer overflow in thermal_build_list_of_policies()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    fpga: machxo2-spi: Fix missing error code in machxo2_write_complete()

Tom Rix <trix@redhat.com>
    fpga: machxo2-spi: Return an error on failure

Randy Dunlap <rdunlap@infradead.org>
    tty: synclink_gt: rename a conflicting function name

Jiri Slaby <jslaby@suse.cz>
    tty: synclink_gt, drop unneeded forward declarations

Baokun Li <libaokun1@huawei.com>
    scsi: iscsi: Adjust iface sysfs attr detection

Aya Levin <ayal@nvidia.com>
    net/mlx4_en: Don't allow aRFS for encapsulated packets

Shai Malin <smalin@marvell.com>
    qed: rdma - don't wait for resources under hw error recovery flow

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    gpio: uniphier: Fix void functions to remove return value

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: add missing error check in smc_clc_prfx_set()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix TX timeout when TX ring size is set to the smallest

Claudiu Manoil <claudiu.manoil@nxp.com>
    enetc: Fix illegal access when reading affinity_hint

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86/intel: punit_ipc: Drop wrong use of ACPI_PTR()

David Howells <dhowells@redhat.com>
    afs: Fix incorrect triggering of sillyrename on 3rd-party invalidation

Johan Hovold <johan@kernel.org>
    net: hso: fix muxed tty registration

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: fix driver's tx_empty callback

Kishon Vijay Abraham I <kishon@ti.com>
    xhci: Set HCD flag to defer primary roothub registration

Qu Wenruo <wqu@suse.com>
    btrfs: prevent __btrfs_dump_space_info() to underflow its free space

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: fix up erofs_lookup tracepoint

Dan Carpenter <dan.carpenter@oracle.com>
    mcb: fix error handling in mcb_alloc_bus()

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add device id for Foxconn T99W265

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    USB: serial: option: remove duplicate USB device ID

Carlo Lobrano <c.lobrano@gmail.com>
    USB: serial: option: add Telit LN920 compositions

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    USB: serial: mos7840: remove duplicated 0xac24 device ID

Kishon Vijay Abraham I <kishon@ti.com>
    usb: core: hcd: Add support for deferring roothub registration

Julian Sikorski <belegdol@gmail.com>
    Re-enable UAS for LaCie Rugged USB3-FW with fk quirk

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix tty use after free

Todd Kjos <tkjos@google.com>
    binder: make sure fd closes complete

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix minor-number release

Uwe Brandt <uwe.brandt@gmail.com>
    USB: serial: cp210x: add ID for GW Instek GDM-834x Digital Multimeter

Ondrej Zary <linux@zary.sk>
    usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c

Jan Beulich <jbeulich@suse.com>
    xen/x86: fix PV trap handling on secondary processors

Steve French <stfrench@microsoft.com>
    cifs: fix incorrect check for null pointer in header_assemble

Dan Carpenter <dan.carpenter@oracle.com>
    usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix ISOC transfer complete handling for DDMA

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix ISOC flow for BDMA and Slave

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: r8a66597: fix a loop in set_feature()

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: drop acl cache for directories too


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/include/asm/io.h                        |   6 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |  17 ++
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |  11 +-
 arch/arm64/kernel/process.c                        |   2 +-
 arch/m68k/include/asm/raw_io.h                     |  20 +--
 arch/parisc/include/asm/page.h                     |   2 +-
 arch/sparc/kernel/ioport.c                         |   4 +-
 arch/sparc/kernel/mdesc.c                          |   3 +-
 arch/x86/xen/enlighten_pv.c                        |  15 +-
 block/blk-cgroup.c                                 |   8 +
 drivers/android/binder.c                           |  23 ++-
 drivers/edac/synopsys_edac.c                       |   2 +-
 drivers/fpga/machxo2-spi.c                         |   6 +-
 drivers/gpio/gpio-uniphier.c                       |   4 +-
 drivers/irqchip/Kconfig                            |   1 +
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/mcb/mcb-core.c                             |  12 +-
 drivers/md/md.c                                    |   5 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   5 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/cadence/macb_pci.c            |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   5 +-
 drivers/net/ethernet/i825xx/82596.c                |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   3 +
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |   8 +
 drivers/net/ethernet/qlogic/qed/qed_roce.c         |   8 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/hamradio/6pack.c                       |   4 +-
 drivers/net/usb/hso.c                              |  12 +-
 drivers/nvme/host/multipath.c                      |   7 +-
 drivers/platform/x86/intel_punit_ipc.c             |   3 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   3 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   3 +-
 drivers/scsi/scsi_transport_iscsi.c                |   8 +-
 drivers/spi/spi-tegra20-slink.c                    |   4 +-
 drivers/staging/greybus/uart.c                     |  62 +++----
 .../int340x_thermal/processor_thermal_device.c     |   5 +-
 drivers/thermal/thermal_core.c                     |   7 +-
 drivers/tty/serial/mvebu-uart.c                    |   2 +-
 drivers/tty/synclink_gt.c                          | 101 +++--------
 drivers/usb/class/cdc-acm.c                        |   7 +-
 drivers/usb/class/cdc-acm.h                        |   2 +
 drivers/usb/core/hcd.c                             |  29 +++-
 drivers/usb/dwc2/gadget.c                          | 193 ++++++++++++---------
 drivers/usb/gadget/udc/r8a66597-udc.c              |   2 +-
 drivers/usb/host/xhci.c                            |   1 +
 drivers/usb/musb/tusb6010.c                        |   1 +
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/mos7840.c                       |   2 -
 drivers/usb/serial/option.c                        |  11 +-
 drivers/usb/storage/unusual_devs.h                 |   9 +-
 drivers/usb/storage/unusual_uas.h                  |   2 +-
 drivers/xen/balloon.c                              |  62 +++++--
 fs/afs/dir.c                                       |  46 +----
 fs/btrfs/space-info.c                              |   5 +-
 fs/cifs/connect.c                                  |   5 +-
 fs/cifs/file.c                                     |   2 +-
 fs/ocfs2/dlmglue.c                                 |   3 +-
 fs/qnx4/dir.c                                      |  69 ++++++--
 include/linux/compiler.h                           |   2 +
 include/linux/usb/hcd.h                            |   2 +
 include/trace/events/erofs.h                       |   6 +-
 kernel/bpf/verifier.c                              |   2 +
 kernel/trace/blktrace.c                            |   8 +
 net/ipv6/ip6_fib.c                                 |   3 +-
 net/smc/smc_clc.c                                  |   3 +-
 68 files changed, 509 insertions(+), 382 deletions(-)


