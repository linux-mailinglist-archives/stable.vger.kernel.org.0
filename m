Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5B941A997
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 09:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbhI1HUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 03:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239264AbhI1HUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 03:20:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C4A761052;
        Tue, 28 Sep 2021 07:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632813546;
        bh=5I2oyJGbBoOys5bXuOurRMZ0zj+piCw0HcntS8ee2nQ=;
        h=From:To:Cc:Subject:Date:From;
        b=M4ifuxlq6ZZnan683p7HDUWaPyioNLas+QhYGhzAkpBtI8Bny40gbR/Yn9p07OIyd
         BIxrbF/IG5pzFHtvqVJWYbl4XmjZdjTGr5o6Xf2AzwHn1ruW2k60fDYpx1oV7edz7o
         xCcdYTjMYdLp8ibf9e51Y/kuYwpLyj1MHvi8BAl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 000/161] 5.14.9-rc2 review
Date:   Tue, 28 Sep 2021 09:19:04 +0200
Message-Id: <20210928071739.782455217@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.9-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.9-rc2
X-KernelTest-Deadline: 2021-09-30T07:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.9 release.
There are 161 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Sep 2021 07:17:13 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.9-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.9-rc2

Jack Pham <jackp@codeaurora.org>
    usb: gadget: f_uac2: Populate SS descriptors' wBytesPerInterval

Jack Pham <jackp@codeaurora.org>
    usb: gadget: f_uac2: Add missing companion descriptor for feedback EP

Dan Carpenter <dan.carpenter@oracle.com>
    nvmet: fix a width vs precision bug in nvmet_subsys_attr_serial_show()

Linus Torvalds <torvalds@linux-foundation.org>
    qnx4: work around gcc false positive warning bug

Juergen Gross <jgross@suse.com>
    xen/balloon: fix balloon kthread freezing

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    software node: balance refcount for managed software nodes

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: fix dropped characters with CP2102

Peter Collingbourne <pcc@google.com>
    arm64: add MTE supported check to thread switching and syscall entry/exit

Marc Zyngier <maz@kernel.org>
    irqchip/armada-370-xp: Fix ack/eoi breakage

Antoine Tenart <atenart@kernel.org>
    thermal/drivers/int340x: Do not set a wrong tcc offset on resume

Juergen Gross <jgross@suse.com>
    x86/setup: Call early_reserve_memory() earlier

Borislav Petkov <bp@suse.de>
    EDAC/dmc520: Assign the proper type to dimm->edac_mode

Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
    EDAC/synopsys: Fix wrong value type assignment for edac_mode

Linus Torvalds <torvalds@linux-foundation.org>
    Revert drm/vc4 hdmi runtime PM changes

Ian Rogers <irogers@google.com>
    libperf evsel: Make use of FD robust.

Linus Torvalds <torvalds@linux-foundation.org>
    spi: Fix tegra20 build with CONFIG_PM=n

Guenter Roeck <linux@roeck-us.net>
    net: 6pack: Fix tx timeout and slot time

Guenter Roeck <linux@roeck-us.net>
    alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile

Dan Li <ashimida@linux.alibaba.com>
    arm64: Mark __stack_chk_guard as __ro_after_init

Simon Ser <contact@emersion.fr>
    amd/display: enable panel orientation quirks

Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
    drm/amd/display: Link training retry fix for abort case

Qingqing Zhuo <qingqing.zhuo@amd.com>
    drm/amd/display: Fix unstable HPCP compliance on Chrome Barcelo

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: make needs_pcie_atomics FW-version dependent

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

Huang Rui <ray.huang@amd.com>
    drm/ttm: fix type mismatch error on sparc64

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

Hamza Mahfooz <someguy@effective-light.com>
    dma-debug: prevent an error message from causing runtime problems

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
    io_uring: don't punt files update to io-wq unconditionally

Jens Axboe <axboe@kernel.dk>
    io_uring: put provided buffer meta data under memcg accounting

Hao Xu <haoxu@linux.alibaba.com>
    io_uring: fix missing set of EPOLLONESHOT for CQ ring overflow

Hao Xu <haoxu@linux.alibaba.com>
    io_uring: fix race between poll completion and cancel_hash insertion

Kees Cook <keescook@chromium.org>
    x86/asm: Fix SETZ size enqcmds() build failure

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

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Unbreak the reset handler

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Retry aborted SCSI commands instead of completing these successfully

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Revert "Utilize Transfer Request List Completion Notification Register"

Bart Van Assche <bvanassche@acm.org>
    scsi: sd_zbc: Support disks with more than 2**32 logical blocks

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: fix a sign extension bug

Dan Carpenter <dan.carpenter@oracle.com>
    thermal/core: Potential buffer overflow in thermal_build_list_of_policies()

Christoph Hellwig <hch@lst.de>
    nvme: keep ctrl->namespaces ordered

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix incorrect h2cdata pdu offset accounting

Jiashuo Liang <liangjs@pku.edu.cn>
    x86/fault: Fix wrong signal when vsyscall fails with pkey

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    fpga: machxo2-spi: Fix missing error code in machxo2_write_complete()

Tom Rix <trix@redhat.com>
    fpga: machxo2-spi: Return an error on failure

Randy Dunlap <rdunlap@infradead.org>
    tty: synclink_gt: rename a conflicting function name

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: Fix the pgr/alua_support_store functions

Baokun Li <libaokun1@huawei.com>
    scsi: iscsi: Adjust iface sysfs attr detection

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: fix dma mapping leaking warning

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: map SVM range with correct access permission

Sudarsana Reddy Kalluru <skalluru@marvell.com>
    atlantic: Fix issue in the pm resume flow.

Aya Levin <ayal@nvidia.com>
    net/mlx4_en: Don't allow aRFS for encapsulated packets

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix forwarding from BLOCKING ports remaining enabled

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: avoid creating duplicate offload entries

Mark Brown <broonie@kernel.org>
    nfc: st-nci: Add SPI ID matching DT compatible

Ido Schimmel <idosch@nvidia.com>
    nexthop: Fix memory leaks in nexthop notification chain listeners

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure tx skbs always have the MPTCP ext

Shai Malin <smalin@marvell.com>
    qed: rdma - don't wait for resources under hw error recovery flow

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    gpio: uniphier: Fix void functions to remove return value

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Make set-debounce-timeout failures non fatal

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix NULL deref in qeth_clear_working_pool_list()

Mark Brown <broonie@kernel.org>
    spi: Revert modalias changes

Cristian Marussi <cristian.marussi@arm.com>
    kselftest/arm64: signal: Skip tests if required features are missing

Mark Brown <broonie@kernel.org>
    kselftest/arm64: signal: Add SVE to the set of features we can check for

Randy Dunlap <rdunlap@infradead.org>
    platform/x86: dell: fix DELL_WMI_PRIVACY dependencies & build error

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: realtek: register the MDIO bus under devres

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: don't allocate the slave_mii_bus using devres

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix dsa_tree_setup error path

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: fix 'workqueue leaked lock' in smc_conn_abort_work

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: add missing error check in smc_clc_prfx_set()

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix a return value error in hclge_get_reset_status()

liaoguojia <liaoguojia@huawei.com>
    net: hns3: check vlan id before using it

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: check queue id range before using

Jiaran Zhang <zhangjiaran@huawei.com>
    net: hns3: fix misuse vf id and vport id in some logs

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix inconsistent vf id print

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix change RSS 'hfunc' ineffective issue

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix TX timeout when TX ring size is set to the smallest

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    napi: fix race inside napi_enable

Christian Lamparter <chunkeey@gmail.com>
    net: bgmac-bcma: handle deferred probe error due to mac-address

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tear down devlink port regions when tearing down the devlink port on error

Randy Dunlap <rdunlap@infradead.org>
    igc: fix build errors for PTP

Claudiu Manoil <claudiu.manoil@nxp.com>
    enetc: Fix uninitialized struct dim_sample field usage

Claudiu Manoil <claudiu.manoil@nxp.com>
    enetc: Fix illegal access when reading affinity_hint

Jason Wang <jasowang@redhat.com>
    virtio-net: fix pages leaking when building skb in big mode

Chuck Lever <chuck.lever@oracle.com>
    NLM: Fix svcxdr_encode_owner()

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    regulator: max14577: Revert "regulator: max14577: Add proper module aliases strings"

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86/intel: punit_ipc: Drop wrong use of ACPI_PTR()

David Howells <dhowells@redhat.com>
    afs: Fix updating of i_blocks on file/dir extension

David Howells <dhowells@redhat.com>
    afs: Fix corruption in reads at fpos 2G-4G from an OpenAFS server

David Howells <dhowells@redhat.com>
    afs: Fix incorrect triggering of sillyrename on 3rd-party invalidation

David Howells <dhowells@redhat.com>
    afs: Fix page leak

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    regulator: qcom-rpmh-regulator: fix pm8009-1 ldo7 resource name

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix memory leak in compat_insnlist()

Robin Murphy <robin.murphy@arm.com>
    arm64: Mitigate MTE issues with str{n}cmp()

dann frazier <dann.frazier@canonical.com>
    arm64: Restore forced disabling of KPTI on ThunderX

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: amd-pmc: Increase the response register timeout

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

Ido Schimmel <idosch@nvidia.com>
    nexthop: Fix division by zero while replacing a resilient group

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: fix up erofs_lookup tracepoint

Sean Christopherson <seanjc@google.com>
    KVM: rseq: Update rseq when processing NOTIFY_RESUME on xfer to KVM guest

Dan Carpenter <dan.carpenter@oracle.com>
    mcb: fix error handling in mcb_alloc_bus()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    misc: genwqe: Fixes DMA mask setting

Johan Hovold <johan@kernel.org>
    misc: bcm-vk: fix tty registration race

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

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: fix race condition before setting doorbell

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: balance phy init and exit

Julian Sikorski <belegdol@gmail.com>
    Re-enable UAS for LaCie Rugged USB3-FW with fk quirk

Rui Miguel Silva <rui.silva@linaro.org>
    usb: isp1760: do not sleep in field register poll

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix tty use after free

Li Li <dualli@google.com>
    binder: fix freeze race

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

Rohith Surabattula <rohiths@microsoft.com>
    cifs: Fix soft lockup during fsstress

Rohith Surabattula <rohiths@microsoft.com>
    cifs: Not to defer close on file when lock is set

Dan Carpenter <dan.carpenter@oracle.com>
    usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix ISOC transfer complete handling for DDMA

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix ISOC flow for BDMA and Slave

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: gadget: u_audio: EP-OUT bInterval in fback frequency

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: r8a66597: fix a loop in set_feature()

Chen Jun <chenjun102@huawei.com>
    mm: fix uninitialized use in overcommit_policy_handler

Weizhao Ouyang <o451686892@gmail.com>
    mm/debug: sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: drop acl cache for directories too

Naoya Horiguchi <naoya.horiguchi@nec.com>
    mm, hwpoison: add is_free_buddy_page() in HWPoisonHandlable()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/include/asm/io.h                        |   6 +-
 arch/arm64/include/asm/assembler.h                 |   5 +
 arch/arm64/include/asm/mte.h                       |   6 +
 arch/arm64/include/asm/string.h                    |   2 +
 arch/arm64/kernel/cpufeature.c                     |   8 +-
 arch/arm64/kernel/mte.c                            |  10 +-
 arch/arm64/kernel/process.c                        |   2 +-
 arch/arm64/lib/strcmp.S                            |   2 +-
 arch/arm64/lib/strncmp.S                           |   2 +-
 arch/m68k/include/asm/raw_io.h                     |  20 +--
 arch/parisc/include/asm/page.h                     |   2 +-
 arch/sparc/kernel/ioport.c                         |   4 +-
 arch/sparc/kernel/mdesc.c                          |   3 +-
 arch/x86/include/asm/pkeys.h                       |   2 -
 arch/x86/include/asm/special_insns.h               |   2 +-
 arch/x86/kernel/setup.c                            |  26 +--
 arch/x86/mm/fault.c                                |  26 ++-
 arch/x86/xen/enlighten_pv.c                        |  15 +-
 block/blk-cgroup.c                                 |   8 +
 block/blk-integrity.c                              |   9 +-
 block/blk-mq-tag.c                                 |   2 +-
 drivers/android/binder.c                           |  58 +++++--
 drivers/android/binder_internal.h                  |   2 +
 drivers/base/swnode.c                              |   3 +
 drivers/comedi/comedi_fops.c                       |   1 +
 drivers/cpufreq/intel_pstate.c                     |  22 ++-
 drivers/edac/dmc520_edac.c                         |   2 +-
 drivers/edac/synopsys_edac.c                       |   2 +-
 drivers/fpga/machxo2-spi.c                         |   6 +-
 drivers/gpio/gpio-uniphier.c                       |   4 +-
 drivers/gpio/gpiolib-acpi.c                        |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  44 +++--
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               | 152 ++++++++++------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  53 +++++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  10 +-
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c          |   2 +
 drivers/gpu/drm/ttm/ttm_pool.c                     |   3 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  44 ++---
 drivers/irqchip/Kconfig                            |   1 +
 drivers/irqchip/irq-armada-370-xp.c                |   4 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/mcb/mcb-core.c                             |  12 +-
 drivers/md/md.c                                    |   5 -
 drivers/misc/bcm-vk/bcm_vk_tty.c                   |   6 +-
 drivers/misc/genwqe/card_base.c                    |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  16 +-
 drivers/net/dsa/mv88e6xxx/devlink.c                |  73 +-------
 drivers/net/dsa/mv88e6xxx/devlink.h                |   6 +-
 drivers/net/dsa/realtek-smi-core.c                 |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   4 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   5 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/cadence/macb_pci.c            |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   7 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  80 ++++++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  10 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  52 ++++--
 drivers/net/ethernet/i825xx/82596.c                |   2 +-
 drivers/net/ethernet/intel/Kconfig                 |   1 +
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   3 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   3 +
 drivers/net/ethernet/mscc/ocelot.c                 |  11 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |   8 +
 drivers/net/ethernet/qlogic/qed/qed_roce.c         |   8 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/hamradio/6pack.c                       |   4 +-
 drivers/net/phy/phylink.c                          |  30 +++-
 drivers/net/usb/hso.c                              |  12 +-
 drivers/net/virtio_net.c                           |   4 +
 drivers/net/vxlan.c                                |   2 +-
 drivers/nfc/st-nci/spi.c                           |   1 +
 drivers/nvme/host/core.c                           |  33 ++--
 drivers/nvme/host/multipath.c                      |   7 +-
 drivers/nvme/host/rdma.c                           |  16 +-
 drivers/nvme/host/tcp.c                            |  13 +-
 drivers/nvme/target/configfs.c                     |   2 +-
 drivers/platform/x86/amd-pmc.c                     |   2 +-
 drivers/platform/x86/dell/Kconfig                  |   3 +-
 drivers/platform/x86/intel_punit_ipc.c             |   3 +-
 drivers/regulator/max14577-regulator.c             |   2 -
 drivers/regulator/qcom-rpmh-regulator.c            |   2 +-
 drivers/s390/net/qeth_core_main.c                  |   3 +
 drivers/scsi/lpfc/lpfc_attr.c                      |   3 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   3 +-
 drivers/scsi/scsi_transport_iscsi.c                |   8 +-
 drivers/scsi/sd_zbc.c                              |   8 +-
 drivers/scsi/ufs/ufshcd.c                          |  81 ++++-----
 drivers/scsi/ufs/ufshcd.h                          |   5 -
 drivers/scsi/ufs/ufshci.h                          |   1 -
 drivers/spi/spi-tegra20-slink.c                    |   4 +-
 drivers/spi/spi.c                                  |   8 -
 drivers/staging/greybus/uart.c                     |  62 +++----
 drivers/target/target_core_configfs.c              |  32 ++--
 .../int340x_thermal/processor_thermal_device.c     |   5 +-
 drivers/thermal/thermal_core.c                     |   7 +-
 drivers/tty/serial/8250/8250_omap.c                |   2 +-
 drivers/tty/serial/mvebu-uart.c                    |   2 +-
 drivers/tty/synclink_gt.c                          |  44 ++---
 drivers/usb/cdns3/cdns3-gadget.c                   |  14 ++
 drivers/usb/class/cdc-acm.c                        |   7 +-
 drivers/usb/class/cdc-acm.h                        |   2 +
 drivers/usb/core/hcd.c                             |  29 +++-
 drivers/usb/dwc2/gadget.c                          | 193 ++++++++++++---------
 drivers/usb/dwc3/core.c                            |  30 ++--
 drivers/usb/gadget/function/f_uac2.c               |  19 +-
 drivers/usb/gadget/function/u_audio.c              |  13 +-
 drivers/usb/gadget/udc/r8a66597-udc.c              |   2 +-
 drivers/usb/host/bcma-hcd.c                        |   5 +-
 drivers/usb/host/xhci.c                            |   1 +
 drivers/usb/isp1760/isp1760-hcd.c                  |   6 +-
 drivers/usb/musb/tusb6010.c                        |   1 +
 drivers/usb/serial/cp210x.c                        |  36 ++++
 drivers/usb/serial/mos7840.c                       |   2 -
 drivers/usb/serial/option.c                        |  11 +-
 drivers/usb/storage/unusual_devs.h                 |   9 +-
 drivers/usb/storage/unusual_uas.h                  |   2 +-
 drivers/xen/balloon.c                              |  62 +++++--
 fs/afs/dir.c                                       |  46 +----
 fs/afs/dir_edit.c                                  |   4 +-
 fs/afs/fs_probe.c                                  |   8 +-
 fs/afs/fsclient.c                                  |  31 ++--
 fs/afs/inode.c                                     |  10 --
 fs/afs/internal.h                                  |  11 ++
 fs/afs/protocol_afs.h                              |  15 ++
 fs/afs/protocol_yfs.h                              |   6 +
 fs/afs/write.c                                     |  12 +-
 fs/btrfs/space-info.c                              |   5 +-
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/connect.c                                  |   5 +-
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/misc.c                                     |   4 +-
 fs/io_uring.c                                      |  13 +-
 fs/lockd/svcxdr.h                                  |  13 +-
 fs/ocfs2/dlmglue.c                                 |   3 +-
 fs/qnx4/dir.c                                      |  69 ++++++--
 include/linux/compiler.h                           |   2 +
 include/linux/pkeys.h                              |   2 +
 include/linux/usb/hcd.h                            |   2 +
 include/net/dsa.h                                  |   8 +
 include/trace/events/erofs.h                       |   6 +-
 include/uapi/linux/android/binder.h                |   7 +
 kernel/bpf/verifier.c                              |   2 +
 kernel/dma/debug.c                                 |   3 +-
 kernel/entry/kvm.c                                 |   4 +-
 kernel/rseq.c                                      |  14 +-
 kernel/trace/blktrace.c                            |   8 +
 mm/debug.c                                         |   3 +-
 mm/memory-failure.c                                |   2 +-
 mm/util.c                                          |   4 +-
 net/core/dev.c                                     |  16 +-
 net/dsa/dsa2.c                                     |  64 ++++++-
 net/ipv4/nexthop.c                                 |  21 ++-
 net/ipv6/ip6_fib.c                                 |   3 +-
 net/mptcp/protocol.c                               |   4 +-
 net/smc/smc_clc.c                                  |   3 +-
 net/smc/smc_core.c                                 |   2 +
 tools/lib/perf/evsel.c                             |  64 ++++---
 .../testing/selftests/arm64/signal/test_signals.h  |   2 +
 .../selftests/arm64/signal/test_signals_utils.c    |  10 +-
 165 files changed, 1441 insertions(+), 863 deletions(-)


