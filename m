Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138FE41A995
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 09:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbhI1HUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 03:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239068AbhI1HUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 03:20:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3284D611CA;
        Tue, 28 Sep 2021 07:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632813538;
        bh=b1nmnolPUe0K33Rzc0S1VASoNziP8l8B2i1sQk2BeOk=;
        h=From:To:Cc:Subject:Date:From;
        b=F9wMWOAxqYzI6vPO+5RAxtUoeawgyZvCw9nlU/TW8wzxoA62XetAfZAklKemlo0xP
         6pS/N6D+klrXFuKPbY3ThL/1+V3ld7+g9hdjx8QZnlTl2w2lfJWKQ1u6KmVPHpBs+Q
         YNYH9ZctZH+zNxUku9TGNIE1/oNUU1vXK9nlGqGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/102] 5.10.70-rc2 review
Date:   Tue, 28 Sep 2021 09:18:56 +0200
Message-Id: <20210928071741.331837387@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.70-rc2
X-KernelTest-Deadline: 2021-09-30T07:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.70 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Sep 2021 07:17:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.70-rc2

Linus Torvalds <torvalds@linux-foundation.org>
    qnx4: work around gcc false positive warning bug

Juergen Gross <jgross@suse.com>
    xen/balloon: fix balloon kthread freezing

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: fix dropped characters with CP2102

Antoine Tenart <atenart@kernel.org>
    thermal/drivers/int340x: Do not set a wrong tcc offset on resume

Borislav Petkov <bp@suse.de>
    EDAC/dmc520: Assign the proper type to dimm->edac_mode

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

Lihong Kou <koulihong@huawei.com>
    block: flush the integrity workqueue in blk_integrity_unregister

Christoph Hellwig <hch@lst.de>
    block: check if a profile is actually registered in blk_integrity_unregister

Simon Ser <contact@emersion.fr>
    amd/display: downgrade validation failure log level

Andreas Larsson <andreas@gaisler.com>
    sparc32: page align size in arch_dma_alloc

Ruozhu Li <liruozhu@huawei.com>
    nvme-rdma: destroy cm id before destroy qp to avoid use after free

Anton Eidelman <anton.eidelman@gmail.com>
    nvme-multipath: fix ANA state updates when a namespace is not present

Juergen Gross <jgross@suse.com>
    xen/balloon: use a kernel thread instead a workqueue

Bixuan Cui <cuibixuan@huawei.com>
    bpf: Add oversize check before call kvcalloc()

Doug Smythies <doug.smythies@gmail.com>
    cpufreq: intel_pstate: Override parameters if HWP forced by BIOS

zhang kai <zhangkaiheb@126.com>
    ipv6: delay fib6_sernum increase in fib6_add

Guenter Roeck <linux@roeck-us.net>
    m68k: Double cast io functions to unsigned long

Ming Lei <ming.lei@redhat.com>
    blk-mq: avoid to iterate over stale request

Jesper Nilsson <jesper.nilsson@axis.com>
    net: stmmac: allow CSR clock of 300MHz

Tong Zhang <ztong0001@gmail.com>
    net: macb: fix use after free on rmmod

Nathan Rossi <nathan.rossi@digi.com>
    net: phylink: Update SFP selected interface on advertising changes

Zhihao Cheng <chengzhihao1@huawei.com>
    blktrace: Fix uaf in blk_trace access after removing by sysfs

Jens Axboe <axboe@kernel.dk>
    io_uring: put provided buffer meta data under memcg accounting

Kees Cook <keescook@chromium.org>
    x86/asm: Fix SETZ size enqcmds() build failure

Dave Jiang <dave.jiang@intel.com>
    x86/asm: Add a missing __iomem annotation in enqcmds()

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

Christoph Hellwig <hch@lst.de>
    nvme: keep ctrl->namespaces ordered

Sami Tolvanen <samitolvanen@google.com>
    treewide: Change list_sort to use const pointers

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix incorrect h2cdata pdu offset accounting

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    fpga: machxo2-spi: Fix missing error code in machxo2_write_complete()

Tom Rix <trix@redhat.com>
    fpga: machxo2-spi: Return an error on failure

Randy Dunlap <rdunlap@infradead.org>
    tty: synclink_gt: rename a conflicting function name

Jiri Slaby <jirislaby@kernel.org>
    tty: synclink_gt, drop unneeded forward declarations

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: Fix the pgr/alua_support_store functions

Baokun Li <libaokun1@huawei.com>
    scsi: iscsi: Adjust iface sysfs attr detection

Sudarsana Reddy Kalluru <skalluru@marvell.com>
    atlantic: Fix issue in the pm resume flow.

Aya Levin <ayal@nvidia.com>
    net/mlx4_en: Don't allow aRFS for encapsulated packets

Shai Malin <smalin@marvell.com>
    qed: rdma - don't wait for resources under hw error recovery flow

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    gpio: uniphier: Fix void functions to remove return value

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix NULL deref in qeth_clear_working_pool_list()

Cristian Marussi <cristian.marussi@arm.com>
    kselftest/arm64: signal: Skip tests if required features are missing

Mark Brown <broonie@kernel.org>
    kselftest/arm64: signal: Add SVE to the set of features we can check for

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: realtek: register the MDIO bus under devres

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: don't allocate the slave_mii_bus using devres

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: fix 'workqueue leaked lock' in smc_conn_abort_work

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: add missing error check in smc_clc_prfx_set()

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: check queue id range before using

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix change RSS 'hfunc' ineffective issue

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix TX timeout when TX ring size is set to the smallest

Claudiu Manoil <claudiu.manoil@nxp.com>
    enetc: Fix uninitialized struct dim_sample field usage

Claudiu Manoil <claudiu.manoil@nxp.com>
    enetc: Fix illegal access when reading affinity_hint

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86/intel: punit_ipc: Drop wrong use of ACPI_PTR()

David Howells <dhowells@redhat.com>
    afs: Fix updating of i_blocks on file/dir extension

David Howells <dhowells@redhat.com>
    afs: Fix incorrect triggering of sillyrename on 3rd-party invalidation

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix memory leak in compat_insnlist()

Johan Hovold <johan@kernel.org>
    net: hso: fix muxed tty registration

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Update intermediate power state for SI

Naohiro Aota <naohiro.aota@wdc.com>
    scsi: sd_zbc: Ensure buffer size is aligned to SECTOR_SIZE

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: fix driver's tx_empty callback

Nishanth Menon <nm@ti.com>
    serial: 8250: 8250_omap: Fix RX_LVL register offset

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

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: balance phy init and exit

Julian Sikorski <belegdol@gmail.com>
    Re-enable UAS for LaCie Rugged USB3-FW with fk quirk

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix tty use after free

Todd Kjos <tkjos@google.com>
    binder: make sure fd closes complete

Rafał Miłecki <rafal@milecki.pl>
    Revert "USB: bcma: Add a check for devm_gpiod_get"

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

Chen Jun <chenjun102@huawei.com>
    mm: fix uninitialized use in overcommit_policy_handler

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: drop acl cache for directories too

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Increase polling delay to 1.5s while waiting for PIO response


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/include/asm/io.h                        |   6 +-
 arch/arm64/kernel/process.c                        |   2 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |   8 +-
 arch/arm64/kvm/vgic/vgic.c                         |   3 +-
 arch/m68k/include/asm/raw_io.h                     |  20 +--
 arch/parisc/include/asm/page.h                     |   2 +-
 arch/sparc/kernel/ioport.c                         |   4 +-
 arch/sparc/kernel/mdesc.c                          |   3 +-
 arch/x86/include/asm/special_insns.h               |   4 +-
 arch/x86/xen/enlighten_pv.c                        |  15 +-
 block/blk-cgroup.c                                 |   8 +
 block/blk-integrity.c                              |   9 +-
 block/blk-mq-sched.c                               |   3 +-
 block/blk-mq-tag.c                                 |   2 +-
 block/blk-mq.c                                     |   3 +-
 drivers/acpi/nfit/core.c                           |   3 +-
 drivers/acpi/numa/hmat.c                           |   3 +-
 drivers/android/binder.c                           |  23 ++-
 drivers/clk/keystone/sci-clk.c                     |   4 +-
 drivers/cpufreq/intel_pstate.c                     |  22 ++-
 drivers/edac/dmc520_edac.c                         |   2 +-
 drivers/edac/synopsys_edac.c                       |   2 +-
 drivers/fpga/machxo2-spi.c                         |   6 +-
 drivers/gpio/gpio-uniphier.c                       |   4 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +-
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c          |   2 +
 drivers/gpu/drm/drm_modes.c                        |   3 +-
 drivers/gpu/drm/i915/gt/intel_engine_user.c        |   3 +-
 drivers/gpu/drm/i915/gvt/debugfs.c                 |   2 +-
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c      |   3 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   4 +-
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.c |   3 +-
 drivers/interconnect/qcom/bcm-voter.c              |   2 +-
 drivers/irqchip/Kconfig                            |   1 +
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/mcb/mcb-core.c                             |  12 +-
 drivers/md/md.c                                    |   5 -
 drivers/md/raid5.c                                 |   3 +-
 drivers/misc/sram.c                                |   4 +-
 drivers/net/dsa/realtek-smi-core.c                 |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   5 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/cadence/macb_pci.c            |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  45 +++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  52 ++++--
 drivers/net/ethernet/i825xx/82596.c                |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   3 +
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |   8 +
 drivers/net/ethernet/qlogic/qed/qed_roce.c         |   8 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/hamradio/6pack.c                       |   4 +-
 drivers/net/phy/phylink.c                          |  30 +++-
 drivers/net/usb/hso.c                              |  12 +-
 drivers/nvme/host/core.c                           |  32 ++--
 drivers/nvme/host/multipath.c                      |   7 +-
 drivers/nvme/host/rdma.c                           |  16 +-
 drivers/nvme/host/tcp.c                            |  13 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |   3 +-
 drivers/pci/controller/pci-aardvark.c              |   2 +-
 drivers/platform/x86/intel_punit_ipc.c             |   3 +-
 drivers/s390/net/qeth_core_main.c                  |   3 +
 drivers/scsi/lpfc/lpfc_attr.c                      |   3 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   3 +-
 drivers/scsi/scsi_transport_iscsi.c                |   8 +-
 drivers/scsi/sd_zbc.c                              |   6 +-
 drivers/spi/spi-loopback-test.c                    |   3 +-
 drivers/spi/spi-tegra20-slink.c                    |   4 +-
 drivers/staging/comedi/comedi_fops.c               |   1 +
 drivers/staging/greybus/uart.c                     |  62 +++----
 drivers/target/target_core_configfs.c              |  32 ++--
 .../int340x_thermal/processor_thermal_device.c     |   5 +-
 drivers/thermal/thermal_core.c                     |   7 +-
 drivers/tty/serial/8250/8250_omap.c                |   2 +-
 drivers/tty/serial/mvebu-uart.c                    |   2 +-
 drivers/tty/synclink_gt.c                          | 101 +++--------
 drivers/usb/class/cdc-acm.c                        |   7 +-
 drivers/usb/class/cdc-acm.h                        |   2 +
 drivers/usb/core/hcd.c                             |  29 +++-
 drivers/usb/dwc2/gadget.c                          | 193 ++++++++++++---------
 drivers/usb/dwc3/core.c                            |  30 ++--
 drivers/usb/gadget/udc/r8a66597-udc.c              |   2 +-
 drivers/usb/host/bcma-hcd.c                        |   5 +-
 drivers/usb/host/xhci.c                            |   1 +
 drivers/usb/musb/tusb6010.c                        |   1 +
 drivers/usb/serial/cp210x.c                        |  47 +++++
 drivers/usb/serial/mos7840.c                       |   2 -
 drivers/usb/serial/option.c                        |  11 +-
 drivers/usb/storage/unusual_devs.h                 |   9 +-
 drivers/usb/storage/unusual_uas.h                  |   2 +-
 drivers/xen/balloon.c                              |  62 +++++--
 fs/afs/dir.c                                       |  46 +----
 fs/afs/dir_edit.c                                  |   4 +-
 fs/afs/inode.c                                     |  10 --
 fs/afs/internal.h                                  |  10 ++
 fs/afs/write.c                                     |   2 +-
 fs/btrfs/raid56.c                                  |   3 +-
 fs/btrfs/space-info.c                              |   5 +-
 fs/btrfs/tree-log.c                                |   3 +-
 fs/btrfs/volumes.c                                 |   3 +-
 fs/cifs/connect.c                                  |   5 +-
 fs/cifs/file.c                                     |   2 +-
 fs/ext4/fsmap.c                                    |   4 +-
 fs/gfs2/glock.c                                    |   3 +-
 fs/gfs2/log.c                                      |   2 +-
 fs/gfs2/lops.c                                     |   3 +-
 fs/io_uring.c                                      |   2 +-
 fs/iomap/buffered-io.c                             |   3 +-
 fs/ocfs2/dlmglue.c                                 |   3 +-
 fs/qnx4/dir.c                                      |  69 ++++++--
 fs/ubifs/gc.c                                      |   7 +-
 fs/ubifs/replay.c                                  |   4 +-
 fs/xfs/scrub/bitmap.c                              |   4 +-
 fs/xfs/xfs_bmap_item.c                             |   4 +-
 fs/xfs/xfs_buf.c                                   |   6 +-
 fs/xfs/xfs_extent_busy.c                           |   4 +-
 fs/xfs/xfs_extent_busy.h                           |   3 +-
 fs/xfs/xfs_extfree_item.c                          |   4 +-
 fs/xfs/xfs_refcount_item.c                         |   4 +-
 fs/xfs/xfs_rmap_item.c                             |   4 +-
 include/linux/compiler.h                           |   2 +
 include/linux/list_sort.h                          |   7 +-
 include/linux/usb/hcd.h                            |   2 +
 include/trace/events/erofs.h                       |   6 +-
 kernel/bpf/verifier.c                              |   2 +
 kernel/trace/blktrace.c                            |   8 +
 lib/list_sort.c                                    |  17 +-
 lib/test_list_sort.c                               |   3 +-
 mm/util.c                                          |   4 +-
 net/dsa/dsa2.c                                     |  12 +-
 net/ipv6/ip6_fib.c                                 |   3 +-
 net/smc/smc_clc.c                                  |   3 +-
 net/smc/smc_core.c                                 |   2 +
 net/tipc/name_table.c                              |   4 +-
 .../testing/selftests/arm64/signal/test_signals.h  |   2 +
 .../selftests/arm64/signal/test_signals_utils.c    |  10 +-
 140 files changed, 862 insertions(+), 593 deletions(-)


