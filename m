Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1F524747B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392090AbgHQTKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730763AbgHQPlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:41:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8FA922BF3;
        Mon, 17 Aug 2020 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678901;
        bh=dqN28fFHKcKUXZCsnnS70x5h3FnBvgSDMO9fNIg+DR8=;
        h=From:To:Cc:Subject:Date:From;
        b=cptqqdmA7afQVknye3yBziilpJHk/U4FRHOYasdsZ+vL8Vb8Hqv8rzxXu4yTU5CfH
         hTM/wsEpXk2KS7Iw75EHMgOozzVUcD23JyInE+RQDKTWTLVSgoF9FXVEPs4nL4hHhn
         l0g/boMylt2ZbmczVZew9ipZMim1CSkkeZ3GqtWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 000/393] 5.7.16-rc1 review
Date:   Mon, 17 Aug 2020 17:10:50 +0200
Message-Id: <20200817143819.579311991@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.16-rc1
X-KernelTest-Deadline: 2020-08-19T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.7.16 release.
There are 393 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.16-rc1

Jens Axboe <axboe@kernel.dk>
    io_uring: hold 'ctx' reference around task_work queue + execute

Jens Axboe <axboe@kernel.dk>
    io_uring: enable lookup of links holding inflight files

Jens Axboe <axboe@kernel.dk>
    io_uring: add missing REQ_F_COMP_LOCKED for nested requests

Jens Axboe <axboe@kernel.dk>
    task_work: only grab task signal lock when needed

Guoyu Huang <hgy5945@gmail.com>
    io_uring: Fix NULL pointer dereference in loop_rw_iter()

Jens Axboe <axboe@kernel.dk>
    io_uring: sanitize double poll handling

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/gmap: improve THP splitting

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/numa: set node distance to LOCAL_DISTANCE

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix inability to use DASD with DIAG driver

Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
    drm/xen-front: Fix misused IS_ERR_OR_NULL checks

Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
    xen/gntdev: Fix dmabuf import with non-zero sgt offset

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: make the balloon wait interruptible

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: fix accounting in alloc_xenballooned_pages error path

Kees Cook <keescook@chromium.org>
    firmware_loader: EFI firmware loader must handle pre-allocated buffer

Jon Derrick <jonathan.derrick@intel.com>
    irqdomain/treewide: Free firmware node after domain removal

Jonathan McDowell <noodles@earth.li>
    firmware: qcom_scm: Fix legacy convention SCM accessors

Nathan Huckleberry <nhuck@google.com>
    ARM: 8992/1: Fix unwind_frame for clang-built kernels

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Extend all Exynos5800 A15's OPPs with max voltage data

Sven Schnelle <svens@stackframe.org>
    parisc: mask out enable and reserved bits from sba imask

John David Anglin <dave.anglin@bell.net>
    parisc: Implement __smp_store_release and __smp_load_acquire barriers

John David Anglin <dave.anglin@bell.net>
    parisc: Do not use an ordered store in pa_tlb_lock()

Helge Deller <deller@gmx.de>
    Revert "parisc: Revert "Release spinlocks using ordered store""

Helge Deller <deller@gmx.de>
    Revert "parisc: Use ldcw instruction for SMP spinlock release barrier"

Helge Deller <deller@gmx.de>
    Revert "parisc: Drop LDCW barrier in CAS code when running UP"

Helge Deller <deller@gmx.de>
    Revert "parisc: Improve interrupt handling in arch_spin_lock_flags()"

Gao Xiang <hsiangkao@redhat.com>
    erofs: fix extended inode could cross boundary

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    mtd: spi-nor: intel-spi: Simulate WRDI command

Sivaprakash Murugesan <sivaprak@codeaurora.org>
    mtd: rawnand: qcom: avoid write to unavailable register

Christian Eggers <ceggers@arri.de>
    spi: spidev: Align buffers for DMA

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: Fix indentaion of devfreq_summary debugfs node

Marc Zyngier <maz@kernel.org>
    PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent

Romain Naour <romain.naour@gmail.com>
    include/asm-generic/vmlinux.lds.h: align ro_after_init

Ivan Kokshaysky <ink@jurassic.park.msu.ru>
    cpufreq: dt: fix oops on armada37xx

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: Fix locking issues with governors

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't return layout segments that are in use

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't move layouts to plh_return_segs list while in use

Jens Axboe <axboe@kernel.dk>
    io_uring: fail poll arm on queue proc failure

Jens Axboe <axboe@kernel.dk>
    io_uring: use TWA_SIGNAL for task_work uncondtionally

Jens Axboe <axboe@kernel.dk>
    io_uring: set ctx sq/cq entry count earlier

Dave Airlie <airlied@redhat.com>
    drm/ttm/nouveau: don't call tt destroy callback on alloc failure.

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    media: media-request: Fix crash if memory allocation fails

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    driver core: Fix probe_count imbalance in really_probe()

Zheng Bin <zhengbin13@huawei.com>
    9p: Fix memory leak in v9fs_mount

Maxim Levitsky <mlevitsk@redhat.com>
    kvm: x86: replace kvm_spec_ctrl_test_value with runtime test on the host

Eric Biggers <ebiggers@google.com>
    fs/minix: reject too-large maximum file size

Eric Biggers <ebiggers@google.com>
    fs/minix: don't allow getting deleted inodes

Eric Biggers <ebiggers@google.com>
    fs/minix: check return value of sb_getblk()

Jakub Kicinski <kuba@kernel.org>
    bitfield.h: don't compile-time validate _val in FIELD_FIT

Frederic Weisbecker <frederic@kernel.org>
    tick/nohz: Narrow down noise while setting current task's tick dependency

Mikulas Patocka <mpatocka@redhat.com>
    crypto: cpt - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified

John Allen <john.allen@amd.com>
    crypto: ccp - Fix use of merged scatterlists

Tom Rix <trix@redhat.com>
    crypto: qat - fix double free in qat_uclo_create_batch_init_list

Mikulas Patocka <mpatocka@redhat.com>
    crypto: hisilicon - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified

Matteo Croce <mcroce@linux.microsoft.com>
    pstore: Fix linking when crypto API disabled

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    tpm: Unify the mismatching TPM space buffer sizes

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: add quirk for Pioneer DDJ-RB

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109

Mirko Dietrich <buzz@l4m1.de>
    ALSA: usb-audio: Creative USB X-Fi Pro SB1095 volume knob support

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - fix the micmute led status for Lenovo ThinkCentre AIO

Max Gurtovoy <maxg@mellanox.com>
    vdpasim: protect concurrent access to iommu iotlb

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: gadget: always zeroed TRB buffer when enable endpoint

Brant Merryman <brant.merryman@silabs.com>
    USB: serial: cp210x: enable usb generic throttle/unthrottle

Brant Merryman <brant.merryman@silabs.com>
    USB: serial: cp210x: re-enable auto-RTS on open

Marek Behún <marek.behun@nic.cz>
    net: phy: marvell10g: fix null pointer dereference

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix potential null pointer dereference in vsock_poll()

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    net: initialize fastreuse on inet_inherit_port

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    net: refactor bind_bucket fastreuse into helper

Ronak Doshi <doshir@vmware.com>
    vmxnet3: use correct tcp hdr length when packet is encapsulated

Jason Baron <jbaron@akamai.com>
    tcp: correct read of TFO keys on big endian systems

Ira Weiny <ira.weiny@intel.com>
    net/tls: Fix kmap usage

Miaohe Lin <linmiaohe@huawei.com>
    net: Set fput_needed iff FDPUT_FPUT is set

Johan Hovold <johan@kernel.org>
    net: phy: fix memory leak in device-create error path

Qingyu Li <ieatmuttonchuan@gmail.com>
    net/nfc/rawsock.c: add CAP_NET_RAW check.

Miaohe Lin <linmiaohe@huawei.com>
    net: Fix potential memory leak in proto_register()

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Added needed_headroom and a skb->len check

John Ogness <john.ogness@linutronix.de>
    af_packet: TPACKET_V3: fix fill status rwlock imbalance

Jian Cai <caij2003@gmail.com>
    crypto: aesni - add compatibility with IAS

Eric Dumazet <edumazet@google.com>
    x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix ("SUNRPC: Add "@len" parameter to gss_unwrap()")

Scott Mayhew <smayhew@redhat.com>
    nfsd: avoid a NULL dereference in __cld_pipe_upcall()

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix page leak in svc_rdma_recv_read_chunk()

Kamal Dasu <kdasu.kdev@gmail.com>
    mtd: rawnand: brcmnand: Don't default to edu transfer

Drew Fustini <drew@beagleboard.org>
    pinctrl-single: fix pcs_parse_pinconf() return value

Pavel Machek <pavel@ucw.cz>
    ocfs2: fix unbalanced locking

Wang Hai <wanghai38@huawei.com>
    dlm: Fix kobject memleak

Dan Carpenter <dan.carpenter@oracle.com>
    media: mtk-mdp: Fix a refcounting bug on error in init

Dean Nelson <dnelson@redhat.com>
    net: thunderx: initialize VF's mailbox mutex before first usage

Ahmad Fatoum <a.fatoum@pengutronix.de>
    gpio: don't use same lockdep class for all devm_gpiochip_add_data users

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: fix eth hash table allocation

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: check dereferencing null pointer

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: fix unreachable code

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: fix dereference null return value

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: use 32-bit unsigned integer

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: spider_net: Fix the size used in a 'dma_free_coherent()' call

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: sgi: ioc3-eth: Fix the size used in some 'dma_free_coherent()' calls

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    liquidio: Fix wrong return value in cn23xx_get_pf_num()

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    net: ethernet: aquantia: Fix wrong return value

Josef Bacik <josef@toxicpanda.com>
    ftrace: Fix ftrace_trace_task return value

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Delete extra dump stack that gives nothing

Alex Vesker <valex@mellanox.com>
    net/mlx5: DR, Change push vlan action sequence

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    tools, bpftool: Fix wrong return value in do_dump()

Andrii Nakryiko <andriin@fb.com>
    tools, build: Propagate build failures from tools/build/Makefile.build

Wang Hai <wanghai38@huawei.com>
    wl1251: fix always return 0 error

Wang Hai <wanghai38@huawei.com>
    qtnfmac: Missing platform_device_unregister() on error in qtnf_core_mac_alloc()

Yan-Hsuan Chuang <yhchuang@realtek.com>
    rtw88: coex: only skip coex triggered by BT info

Tsang-Shian Lin <thlin@realtek.com>
    rtw88: fix short GI capability based on current bandwidth

Tsang-Shian Lin <thlin@realtek.com>
    rtw88: fix LDPC field for RA info

Florian Westphal <fw@strlen.de>
    netfilter: nft_meta: fix iifgroup matching

Surabhi Boob <surabhi.boob@intel.com>
    ice: Graceful error handling in HW table calloc failure

Vignesh Sridhar <vignesh.sridhar@intel.com>
    ice: Clear and free XLT entries on reset

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't process empty bridge port events

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: tolerate pre-filled RX buffer

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: Fix value of FSL_SAI_CR1_RFW_MASK

Jerry Crunchtime <jerry.c.t@web.de>
    libbpf: Fix register in PT_REGS MIPS macros

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: soc-core: Fix regression causing sysfs entries to disappear

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm-formatters: fix sclk inversion

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdmin: fix g12a skew

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm-interface: fix link fmt setup

Sandipan Das <sandipan@linux.ibm.com>
    selftests/powerpc: Fix online CPU selection

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/hotplug-cpu: Remove double free in error path

Sven Auhagen <sven.auhagen@voleatech.de>
    cpufreq: ap806: fix cpufreq driver needs ap cpu clk

Hanjun Guo <guohanjun@huawei.com>
    PCI: Release IVRS table in AMD ACS quirk

Mark Zhang <markz@mellanox.com>
    RDMA/netlink: Remove CAP_NET_RAW check when dump a raw QP

Tiezhu Yang <yangtiezhu@loongson.cn>
    nvmem: sprd: Fix return value of sprd_efuse_probe()

Harish <harish@linux.ibm.com>
    selftests/powerpc: Fix CPU affinity for child process

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/boot: Fix CONFIG_PPC_MPC52XX references

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/32s: Fix CONFIG_BOOK3S_601 uses

Oliver O'Halloran <oohall@gmail.com>
    selftests/powerpc: Squash spurious errors due to device removal

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush

Brian Foster <bfoster@redhat.com>
    xfs: fix inode allocation block res calculation precedence

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Fix VLAN set-up

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Fix VLAN semantics

Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
    Bluetooth: hci_qca: Stop collecting memdump again for command timeout during SSR

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: Fix suspend notifier race

Nicolas Boichat <drinkcat@chromium.org>
    Bluetooth: hci_serdev: Only unregister device if it was registered

Nicolas Boichat <drinkcat@chromium.org>
    Bluetooth: hci_h5: Set HCI_UART_RESET_ON_INIT to correct flags

Ismael Ferreras Morezuelas <swyterzone@gmail.com>
    Bluetooth: btusb: Fix and detect most of the Chinese Bluetooth controllers

Tom Rix <trix@redhat.com>
    power: supply: check if calc_soc succeeded in pm860x_init_battery

Dan Carpenter <dan.carpenter@oracle.com>
    Smack: prevent underflow in smk_set_cipso()

Dan Carpenter <dan.carpenter@oracle.com>
    Smack: fix another vsscanf out of bounds

Li Heng <liheng40@huawei.com>
    RDMA/core: Fix return error value in _ib_modify_qp() to negative

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: cadence: Fix updating Vendor ID and Subsystem Vendor ID register

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: cadence: Fix cdns_pcie_{host|ep}_setup() error path

Finn Thain <fthain@telegraphics.com.au>
    macintosh/via-macii: Access autopoll_devs when inside lock

Chris Packham <chris.packham@alliedtelesis.co.nz>
    net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration

Finn Thain <fthain@telegraphics.com.au>
    scsi: mesh: Fix panic after host or bus reset

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Clear affinity hint

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_uac2: fix AC Interface Header Descriptor wTotalLength

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc2: Fix error path in gadget registration

Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
    thermal: int340x: processor_thermal: fix: update Jasper Lake PCI id

Yu Kuai <yukuai3@huawei.com>
    MIPS: OCTEON: add missing put_device() call in dwc3_octeon_device_init()

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: hdac_hda: fix deadlock after PCM open error

Dan Murphy <dmurphy@ti.com>
    ASoC: tas2770: Fix reset gpio property name

YueHaibing <yuehaibing@huawei.com>
    tools/bpftool: Fix error handing in do_skeleton()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Tolerate not converging code shrinking

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Use brcl for jumping to exit_ip if necessary

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Fix sign extension in branch_ku

Russell King <rmk+kernel@armlinux.org.uk>
    phy: armada-38x: fix NETA lockup when repeatedly switching speeds

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix possible memory leak in mt7615_mcu_wtbl_sta_add

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7615: fix potential memory leak in mcu message handler

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/perf: Fix missing is_sier_aviable() during build

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Fix save/restore during cpu idle

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: tmc: Fix TMC mode read in tmc_read_unprepare_etb()

Mike Leach <mike.leach@linaro.org>
    coresight: etmv4: Counter values not saved on disable

Mike Leach <mike.leach@linaro.org>
    coresight: etmv4: Fix resource selector constant

Dan Carpenter <dan.carpenter@oracle.com>
    thermal: ti-soc-thermal: Fix reversed condition in ti_thermal_expose_sensor()

Kars Mulder <kerneldev@karsmulder.nl>
    usb: core: fix quirks_param_set() writing to a const pointer

Taniya Das <tdas@codeaurora.org>
    clk: qcom: gcc: Make disp gpll0 branch aon for sc7180/sdm845

Johan Hovold <johan@kernel.org>
    USB: serial: iuu_phoenix: fix led-activity helpers

Hauke Mehrtens <hauke@hauke-m.de>
    spi: lantiq-ssc: Fix warning by using WQ_MEM_RECLAIM

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: Restore RGB32, BGR32

Marco Felsch <m.felsch@pengutronix.de>
    drm/imx: tve: fix regulator_disable error path

Philipp Zabel <p.zabel@pengutronix.de>
    drm/imx: fix use after free

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/pkeys: Use PVR check instead of cpu feature

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: move irq registration to init

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: s5p-g2d: Fix a memory leak in an error handling path in 'g2d_probe()'

Oliver Neukum <oneukum@suse.com>
    go7007: add sanity checking for endpoints

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    PCI/ASPM: Add missing newline in sysfs 'policy'

Jing Xiangfeng <jingxiangfeng@huawei.com>
    ASoC: meson: fixes the missed kfree() for axg_card_add_tdm_loopback

Colin Ian King <colin.king@canonical.com>
    staging: rtl8192u: fix a dubious looking mask before a shift

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Fail rule parsing when the KEY_CHECK hook is combined with an invalid cond

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Fail rule parsing when the KEXEC_CMDLINE hook is combined with an invalid cond

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Fail rule parsing when buffer hook functions have an invalid action

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Free the entire rule if it fails to parse

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Free the entire rule when deleting a list of rules

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Have the LSM free its audit rule

Mikhail Malygin <m.malygin@yadro.com>
    RDMA/rxe: Prevent access to wr->next ptr afrer wr is posted to send queue

Yuval Basson <ybason@marvell.com>
    RDMA/qedr: SRQ's bug fixes

Milton Miller <miltonm@us.ibm.com>
    powerpc/vdso: Fix vdso cpu truncation

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: don't online CPUs for partition suspend

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: remove cede offline state for CPUs

Amir Goldstein <amir73il@gmail.com>
    kernfs: do not call fsnotify() with name without a parent

Dan Carpenter <dan.carpenter@oracle.com>
    mwifiex: Prevent memory corruption handling keys

John Garry <john.garry@huawei.com>
    scsi: scsi_debug: Add check for sdebug_max_queue during module init

Tom Rix <trix@redhat.com>
    drm/bridge: sil_sii8620: initialize return of sii8620_readb

Chuhong Yuan <hslester96@gmail.com>
    mmc: sdhci-of-arasan: Add missed checks for devm_clk_register()

Marek Szyprowski <m.szyprowski@samsung.com>
    phy: exynos5-usbdrd: Calibrating makes sense only for USB2.0 PHY

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: panel: simple: Fix bpc for LG LB070WV8 panel

Kai-Heng Feng <kai.heng.feng@canonical.com>
    leds: core: Flush scheduled work for system suspend

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    kobject: Avoid premature parent object freeing in kobject_cleanup()

Marek Vasut <marex@denx.de>
    drm/stm: repair runtime power management

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: Fix bpf programs with kprobe/sys_connect event

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Fix pci_cfg_wait queue locking problem

Zhu Yanjun <yanjunz@mellanox.com>
    RDMA/rxe: Skip dgid check in loopback mode

Andreas Gruenbacher <agruenba@redhat.com>
    iomap: Make sure iomap_end is called after iomap_begin

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix reflink quota reservation accounting error

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't eat an EIO/ENOSPC writeback error when scrubbing data fork

Dariusz Marcinkiewicz <darekm@google.com>
    media: cros-ec-cec: do not bail on device_init_wakeup failure

Chuhong Yuan <hslester96@gmail.com>
    media: exynos4-is: Add missed check for pinctrl_lookup_state()

Chuhong Yuan <hslester96@gmail.com>
    media: tvp5150: Add missed media_entity_cleanup()

Helen Koike <helen.koike@collabora.com>
    media: staging: rkisp1: rsz: fix resolution limitation on sink pad

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: staging: rkisp1: rsz: supported formats are the isp's src formats, not sink formats

Dan Carpenter <dan.carpenter@oracle.com>
    media: allegro: Fix some NULL vs IS_ERR() checks in probe

Dan Carpenter <dan.carpenter@oracle.com>
    media: firewire: Using uninitialized values in node_probe()

Julian Anastasov <ja@ssi.bg>
    ipvs: allow connection reuse for unconfirmed conntrack

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: eesox: Fix different dev_id between request_irq() and free_irq()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: powertec: Fix different dev_id between request_irq() and free_irq()

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/core: Fix bogus WARN_ON during ib_unregister_device_queued()

Tony Nguyen <anthony.l.nguyen@intel.com>
    iavf: Fix updating statistics

Wei Yongjun <weiyongjun1@huawei.com>
    iavf: fix error return code in iavf_init_get_resources()

Phil Elwell <phil@raspberrypi.com>
    staging: vchiq_arm: Add a matching unregister call

Colin Ian King <colin.king@canonical.com>
    drm/radeon: fix array out-of-bounds read and write issues

Colin Ian King <colin.king@canonical.com>
    drm/amdgpu: ensure 0 is returned for success in jpeg_v2_5_wait_for_idle

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Move pipe reference to trace array instead of current_tracer

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: am65-cpsw-nuss: restore vlan configuration while down/up

Kees Cook <keescook@chromium.org>
    lkdtm: Make arch-specific tests always available

Kees Cook <keescook@chromium.org>
    selftests/lkdtm: Reset WARN_ONCE to avoid false negatives

Kees Cook <keescook@chromium.org>
    lkdtm: Avoid more compiler optimizations for bad writes

Wang Hai <wanghai38@huawei.com>
    cxl: Fix kobject memleak

Emil Velikov <emil.velikov@collabora.com>
    drm/mipi: use dcs write for mipi_dsi_dcs_set_tear_scanline

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()

Mark Starovoytov <mstarovoitov@marvell.com>
    net: atlantic: MACSec offload statistics checkpatch fix

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: bxt_rt298: add missing .owner field

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add missing .owner field

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: cml_rt1011_rt5682: add missing .owner field

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: nocodec: add missing .owner field

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: fix condition for number of buffer acquire retries

Colin Ian King <colin.king@canonical.com>
    staging: most: avoid null pointer dereference when iface is null

Chuhong Yuan <hslester96@gmail.com>
    media: omap3isp: Add missed v4l2_ctrl_handler_free() for preview_init_entities()

Chuhong Yuan <hslester96@gmail.com>
    media: marvell-ccic: Add missed v4l2_async_notifier_cleanup()

Arnd Bergmann <arnd@arndb.de>
    media: cxusb-analog: fix V4L2 dependency

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: btmtksdio: fix up firmware download sequence

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: btusb: fix up firmware download sequence

Arnd Bergmann <arnd@arndb.de>
    leds: lm355x: avoid enum conversion warning

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/fixmap: Fix FIX_EARLY_DEBUG_BASE when page size is 256k

Joe Perches <joe@perches.com>
    powerpc/mm: Fix typo in IS_ENABLED()

Álvaro Fernández Rojas <noltari@gmail.com>
    clk: bcm63xx-gate: fix last clock availability

Colin Ian King <colin.king@canonical.com>
    drm/arm: fix unintentional integer overflow on left shift

Steven Price <steven.price@arm.com>
    drm/panfrost: Fix inbalance of devfreq record_busy/idle()

Lubomir Rintel <lkundrak@v3.sk>
    drm/etnaviv: Fix error path on failure to enable bus clk

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix imprecise load calculation in devfreq window

Chuhong Yuan <hslester96@gmail.com>
    iio: amplifiers: ad8366: Change devm_gpiod_get() to optional and add the missed check

Tomasz Duszynski <tomasz.duszynski@octakon.com>
    iio: improve IIO_CONCENTRATION channel type description

Balakrishna Godavarthi <bgodavar@codeaurora.org>
    Bluetooth: hci_qca: Increase SoC idle timeout to 200ms

Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
    Bluetooth: hci_qca: Bug fix during SSR timeout

Evan Green <evgreen@chromium.org>
    ath10k: Acquire tx_lock in tx error paths

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: Allow suspend even when preparation has failed

Matthias Kaehlcke <mka@chromium.org>
    Bluetooth: hci_qca: Only remove TX clock vote after TX is completed

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: hci_qca: Fix an error pointer dereference

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    video: pxafb: Fix the function used to balance a 'dma_alloc_coherent()' call

Dejin Zheng <zhengdejin5@gmail.com>
    console: newport_con: fix an issue about leak related system resources

Dejin Zheng <zhengdejin5@gmail.com>
    video: fbdev: sm712fb: fix an issue about iounmap for a wrong address

Pali Rohár <pali@kernel.org>
    btmrvl: Fix firmware filename for sd8997 chipset

Pali Rohár <pali@kernel.org>
    btmrvl: Fix firmware filename for sd8977 chipset

Pali Rohár <pali@kernel.org>
    mwifiex: Fix firmware filename for sd8997 chipset

Pali Rohár <pali@kernel.org>
    mwifiex: Fix firmware filename for sd8977 chipset

Qiushi Wu <wu000273@umn.edu>
    agp/intel: Fix a memory leak on module initialisation failure

Emil Velikov <emil.velikov@collabora.com>
    drm/amdgpu: use the unlocked drm_gem_object_put

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Fix off-by-one error in clock choice

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Clear old error bits before AUX transfers

Dan Carpenter <dan.carpenter@oracle.com>
    drm/gem: Fix a leak in drm_gem_objects_lookup()

Rob Clark <robdclark@chromium.org>
    drm/msm: ratelimit crtc event overflow error

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - silence .setkey in case of bad key length

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix stalled deferred requests

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix racy overflow count reporting

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Do not increment operation_region reference counts for field units

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: free per-trans reserved space when a subvolume gets dropped

Qu Wenruo <wqu@suse.com>
    btrfs: allow btrfs_truncate_block() to fallback to nocow for data space reservation

Coly Li <colyli@suse.de>
    bcache: fix super block seq numbers comparision in register_cache_set()

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix a BUG_ON in ddebug_describe_flags

Danesh Petigara <danesh.petigara@broadcom.com>
    usb: bdc: Halt controller on suspend

Sasi Kumar <sasi.kumar@broadcom.com>
    bdc: Fix bug causing crash after multiple disconnects

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: net2280: fix memory leak on probe error handling paths

shirley her <shirley.her@bayhubtech.com>
    mmc: sdhci-pci-o2micro: Bug fix for O2 host controller Seabird1

Nick Desaulniers <ndesaulniers@google.com>
    x86/uaccess: Make __get_user_size() Clang compliant on 32-bit

Shannon Nelson <snelson@pensando.io>
    ionic: update eid test for overflow

Evan Quan <evan.quan@amd.com>
    drm/amd/powerplay: suppress compile error around BUG_ON

Dmitry Osipenko <digetx@gmail.com>
    gpu: host1x: debug: Fix multiple channels emitting messages simultaneously

Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
    iwlegacy: Check the return value of pcie_capability_read_*()

Armas Spann <zappel@retarded.farm>
    platform/x86: asus-nb-wmi: add support for ASUS ROG Zephyrus G14 and G15

Wright Feng <wright.feng@cypress.com>
    brcmfmac: set state of hanger slot to FREE when flushing PSQ

Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>
    brcmfmac: To fix Bss Info flag definition Bug

Wright Feng <wright.feng@cypress.com>
    brcmfmac: keep SDIO watchdog running when console_interval is non-zero

Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
    Bluetooth: hci_qca: Bug fixes for SSR

Wenbo Zhang <ethercflow@gmail.com>
    bpf: Fix fds_example SIGSEGV error

Evan Quan <evan.quan@amd.com>
    drm/amd/powerplay: fix compile error with ARCH=arc

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: properly guard the calls to swSMU functions

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display bail early in dm_pp_get_static_clocks

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Improve DisplayPort monitor interop

Paul E. McKenney <paulmck@kernel.org>
    mm/mmap.c: Add cond_resched() for exit_mmap() CPU stalls

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    irqchip/irq-mtk-sysirq: Replace spinlock with raw_spinlock

Antoine Tenart <antoine.tenart@bootlin.com>
    net: phy: mscc: restore the base page in vsc8514/8584_config_init

Christian König <christian.koenig@amd.com>
    drm/radeon: disable AGP by default

Michael Tretter <m.tretter@pengutronix.de>
    drm/debugfs: fix plain echo to connector "force" attribute

Akhil P Oommen <akhilpo@codeaurora.org>
    drm/msm: Fix a null pointer access in msm_gem_shrinker_count()

Akhil P Oommen <akhilpo@codeaurora.org>
    drm: msm: a6xx: fix gpu failure after system resume

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: clear dual mode of u3port when disable device

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix lockdep splat from btrfs_dump_space_info

Masahiro Yamada <yamada.masahiro@socionext.com>
    mmc: sdhci-cadence: do not use hardware tuning for SD mode

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: fix multiple instances of reference count leaks

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: fix reference count leak in nouveau_debugfs_strap_peek

Krzysztof Kozlowski <krzk@kernel.org>
    memory: samsung: exynos5422-dmc: Do not ignore return code of regmap_read()

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/etnaviv: fix ref count leak via pm_runtime_get_sync

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    arm64: dts: hisilicon: hikey: fixes to comply with adi, adv7533 DT binding

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv50-: Fix disabling dithering

Zhao Heming <heming.zhao@suse.com>
    md-cluster: fix wild pointer of unlock_all_bitmaps()

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Add missing quirk flags for usb_host_hs

Evgeny Novikov <novikov@ispras.ru>
    video: fbdev: neofb: fix memory leak in neo_scan_monitor()

Evgeny Novikov <novikov@ispras.ru>
    video: fbdev: savage: fix memory leak on error handling path in probe

Sedat Dilek <sedat.dilek@gmail.com>
    crypto: aesni - Fix build with LLVM_IAS=1

Aditya Pakki <pakki001@umn.edu>
    drm/radeon: Fix reference count leaks caused by pm_runtime_get_sync

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu: avoid dereferencing a NULL pointer

Paul E. McKenney <paulmck@kernel.org>
    fs/btrfs: Add cond_resched() for try_release_extent_mapping() stalls

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix req->work corruption

Luis Chamberlain <mcgrof@kernel.org>
    loop: be paranoid on exit and prevent new additions / removals

Lihong Kou <koulihong@huawei.com>
    Bluetooth: add a mutex lock to avoid UAF in do_enale_set

Guillaume Tucker <guillaume.tucker@collabora.com>
    ARM: exynos: clear L310_AUX_CTRL_FULL_LINE_ZERO in default l2c_aux_val

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix encoding destination ports into multicast IPv4 address

Maulik Shah <mkshah@codeaurora.org>
    soc: qcom: rpmh-rsc: Set suppress_bind_attrs flag

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/tilcdc: fix leak & null ref in panel_connector_get_modes

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    block: don't do revalidate zones on invalid devices

Hannes Reinecke <hare@suse.de>
    nvme-multipath: do not fall back to __nvme_find_path() for non-optimized paths

Martin Wilck <mwilck@suse.com>
    nvme-multipath: fix logic for non-optimized paths

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix controller reset hang during traffic

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix controller reset hang during traffic

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/gic-v4.1: Use GFP_ATOMIC flag in allocate_vpe_l1_table()

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7038-l1: Guard uses of cpu_logical_map

Tiezhu Yang <yangtiezhu@loongson.cn>
    irqchip/loongson-liointc: Fix potential dead lock

Colin Ian King <colin.king@canonical.com>
    md: raid0/linear: fix dereference before null check on pointer mddev

Kees Cook <keescook@chromium.org>
    seccomp: Fix ioctl number for SECCOMP_IOCTL_NOTIF_ID_VALID

Tiezhu Yang <yangtiezhu@loongson.cn>
    irqchip/ti-sci-inta: Fix return value about devm_ioremap_resource()

Stephen Smalley <stephen.smalley.work@gmail.com>
    scripts/selinux/mdp: fix initial SID handling

Chengming Zhou <zhouchengming@bytedance.com>
    iocost: Fix check condition of iocg abs_vdebt

Yu Kuai <yukuai3@huawei.com>
    ARM: socfpga: PM: add missing put_device() call in socfpga_setup_ocram_self_refresh()

Jon Lin <jon.lin@rock-chips.com>
    spi: rockchip: Fix error in SPI slave pio read

Sibi Sankar <sibis@codeaurora.org>
    soc: qcom: pdr: Reorder the PD state indication ack

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: fix mmc0 tuning error on Khadas VIM3

Dmitry Vyukov <dvyukov@google.com>
    io_uring: fix sq array offset calculation

Vladimir Zapolskiy <vz@mleia.com>
    regulator: fix memory leak on error path of regulator_register()

Gregory Herrero <gregory.herrero@oracle.com>
    recordmcount: only record relocation of type R_AARCH64_CALL26 on arm64.

Tyler Hicks <tyhicks@linux.microsoft.com>
    tpm: Require that all digests are present in TCG_PCR_EVENT2 structures

Dilip Kota <eswara.kota@linux.intel.com>
    spi: lantiq: fix: Rx overflow error in full duplex mode

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sunxi: bananapi-m2-plus-v1.2: Fix CPU supply voltages

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sunxi: bananapi-m2-plus-v1.2: Add regulator supply to all CPU cores

Dejin Zheng <zhengdejin5@gmail.com>
    reset: intel: fix a compile warning about REG_OFFSET redefined

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Disable frequency scaling for FSYS bus on Odroid XU3 family

yu kuai <yukuai3@huawei.com>
    ARM: at91: pm: add missing put_device() call in at91_pm_sram_init()

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    ARM: dts: gose: Fix ports node name for adv7612

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    arm64: dts: renesas: Fix SD Card/eMMC interface device node names

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    ARM: dts: gose: Fix ports node name for adv7180

Lu Wei <luwei32@huawei.com>
    platform/x86: intel-vbtn: Fix return value check in check_acpi_dev()

Lu Wei <luwei32@huawei.com>
    platform/x86: intel-hid: Fix return value check in check_acpi_dev()

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Fix IOP status/control register writes

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Don't send IOP message until channel is idle

Sudeep Holla <sudeep.holla@arm.com>
    clk: scmi: Fix min and max rate when registering clocks with discrete rates

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - allow xts requests not multiple of block

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix initialization of struct uclamp_rq

Alim Akhtar <alim.akhtar@samsung.com>
    arm64: dts: exynos: Fix silent hang after boot on Espresso

Ondrej Jirman <megous@megous.com>
    arm64: dts: sun50i-pinephone: dldo4 must not be >= 1.8V

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix SCMI genpd domain probing

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcu/tree: Repeat the monitor if any free channel is busy

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: exynos: MCPM: Restore big.LITTLE cpuidle support

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix resource leak on error path

Luis Chamberlain <mcgrof@kernel.org>
    blktrace: fix debugfs use after free

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memory: tegra: Fix an error handling path in tegra186_emc_probe()

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Replace invalid bias-pull-none property

Herbert Xu <herbert@gondor.apana.org.au>
    crc-t10dif: Fix potential crypto notify dead-lock

Qiushi Wu <wu000273@umn.edu>
    EDAC: Fix reference count leaks

Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
    arm64: dts: rockchip: fix rk3399-puma gmac reset gpio

Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
    arm64: dts: rockchip: fix rk3399-puma vcc5v0-host gpio

Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
    arm64: dts: rockchip: fix rk3368-lion gmac reset gpio

Peng Liu <iwtbavbm@gmail.com>
    sched: correct SD_flags returned by tl->sd_flags()

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix NOHZ next idle balance

Giovanni Gherdovich <ggherdovich@suse.cz>
    x86, sched: Bail out of frequency invariance if turbo_freq/base_freq gives 0

Giovanni Gherdovich <ggherdovich@suse.cz>
    x86, sched: Bail out of frequency invariance if turbo frequency is unknown

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix oops when counting IMC uncore events on some TGL

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    x86/mce/inject: Fix a wrong assignment of i_mce.status

Erwan Le Ray <erwan.leray@st.com>
    ARM: dts: stm32: fix uart7_pins_a comments in stm32mp15-pinctrl

Grant Likely <grant.likely@secretlab.ca>
    HID: input: Fix devices that return multiple bytes in battery report

Jens Axboe <axboe@kernel.dk>
    io_uring: abstract out task work running

Will Chen <chenwi@google.com>
    kunit: capture stderr on all make subprocess calls

Nick Desaulniers <ndesaulniers@google.com>
    tracepoint: Mark __tracepoint_string's __used


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio            |   3 +-
 Documentation/core-api/cpu_hotplug.rst             |   7 -
 Makefile                                           |   4 +-
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi      |   6 -
 arch/arm/boot/dts/exynos5800.dtsi                  |   6 +-
 arch/arm/boot/dts/r8a7793-gose.dts                 |   4 +-
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi           |   8 +-
 arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi |  18 +-
 arch/arm/kernel/stacktrace.c                       |  24 +++
 arch/arm/mach-at91/pm.c                            |  11 +-
 arch/arm/mach-exynos/exynos.c                      |   2 +-
 arch/arm/mach-exynos/mcpm-exynos.c                 |  10 +-
 arch/arm/mach-socfpga/pm.c                         |   8 +-
 .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |   2 +-
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi |   1 -
 .../boot/dts/amlogic/meson-sm1-khadas-vim3l.dts    |   4 +
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts    |   1 +
 arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts  |  11 +
 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts     |   2 +-
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi         |  10 +-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi          |   8 +-
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi          |   8 +-
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi          |   6 +-
 arch/arm64/boot/dts/renesas/r8a77951.dtsi          |   8 +-
 arch/arm64/boot/dts/renesas/r8a77960.dtsi          |   8 +-
 arch/arm64/boot/dts/renesas/r8a77961.dtsi          |   8 +-
 arch/arm64/boot/dts/renesas/r8a77965.dtsi          |   8 +-
 arch/arm64/boot/dts/renesas/r8a77990.dtsi          |   6 +-
 arch/arm64/boot/dts/renesas/r8a77995.dtsi          |   2 +-
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi      |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   4 +-
 arch/m68k/mac/iop.c                                |  21 +-
 arch/mips/cavium-octeon/octeon-usb.c               |   5 +-
 arch/mips/pci/pci-xtalk-bridge.c                   |   3 +
 arch/parisc/include/asm/barrier.h                  |  61 ++++++
 arch/parisc/include/asm/spinlock.h                 |  33 +--
 arch/parisc/kernel/entry.S                         |  48 +++--
 arch/parisc/kernel/syscall.S                       |  24 +--
 arch/powerpc/boot/Makefile                         |   2 +-
 arch/powerpc/boot/serial.c                         |   2 +-
 arch/powerpc/include/asm/fixmap.h                  |   2 +-
 arch/powerpc/include/asm/perf_event.h              |   2 +
 arch/powerpc/include/asm/ptrace.h                  |   2 +-
 arch/powerpc/include/asm/rtas.h                    |   2 -
 arch/powerpc/include/asm/timex.h                   |   2 +-
 arch/powerpc/kernel/rtas.c                         | 122 +----------
 arch/powerpc/kernel/vdso.c                         |   2 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |   5 +-
 arch/powerpc/mm/book3s64/pkeys.c                   |  16 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       | 171 ++-------------
 arch/powerpc/platforms/pseries/offline_states.h    |  38 ----
 arch/powerpc/platforms/pseries/pmem.c              |   1 -
 arch/powerpc/platforms/pseries/smp.c               |  28 +--
 arch/powerpc/platforms/pseries/suspend.c           |  22 +-
 arch/s390/include/asm/topology.h                   |   6 -
 arch/s390/mm/gmap.c                                |  27 ++-
 arch/s390/net/bpf_jit_comp.c                       |  54 +++--
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            |  14 +-
 arch/x86/crypto/aesni-intel_asm.S                  |   6 +-
 arch/x86/events/intel/uncore_snb.c                 |   3 +-
 arch/x86/include/asm/uaccess.h                     |   5 +-
 arch/x86/kernel/apic/io_apic.c                     |   5 +
 arch/x86/kernel/cpu/mce/inject.c                   |   2 +-
 arch/x86/kernel/process_64.c                       |   2 +-
 arch/x86/kernel/smpboot.c                          |  17 +-
 arch/x86/kvm/svm/svm.c                             |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 arch/x86/kvm/x86.c                                 |  38 ++--
 arch/x86/kvm/x86.h                                 |   2 +-
 block/blk-iocost.c                                 |   2 +-
 block/blk-zoned.c                                  |   3 +
 drivers/acpi/acpica/exprep.c                       |   4 -
 drivers/acpi/acpica/utdelete.c                     |   6 +-
 drivers/base/dd.c                                  |   7 +-
 drivers/base/firmware_loader/fallback_platform.c   |   5 +-
 drivers/block/loop.c                               |   4 +
 drivers/bluetooth/btmrvl_sdio.c                    |   8 +-
 drivers/bluetooth/btmtksdio.c                      |  16 +-
 drivers/bluetooth/btusb.c                          |  90 +++++++-
 drivers/bluetooth/hci_h5.c                         |   2 +-
 drivers/bluetooth/hci_qca.c                        | 104 ++++++---
 drivers/bluetooth/hci_serdev.c                     |   3 +-
 drivers/bus/ti-sysc.c                              |   6 +-
 drivers/char/agp/intel-gtt.c                       |   4 +-
 drivers/char/tpm/tpm-chip.c                        |   9 +-
 drivers/char/tpm/tpm.h                             |   5 +-
 drivers/char/tpm/tpm2-space.c                      |  26 ++-
 drivers/char/tpm/tpmrm-dev.c                       |   2 +-
 drivers/clk/bcm/clk-bcm63xx-gate.c                 |   1 +
 drivers/clk/clk-scmi.c                             |  22 +-
 drivers/clk/qcom/gcc-sc7180.c                      |   2 +-
 drivers/clk/qcom/gcc-sdm845.c                      |   4 +-
 drivers/cpufreq/Kconfig.arm                        |   1 +
 drivers/cpufreq/armada-37xx-cpufreq.c              |   1 +
 drivers/cpufreq/cpufreq.c                          |  58 +++--
 drivers/crypto/caam/caamalg.c                      |   2 +-
 drivers/crypto/caam/caamalg_qi.c                   |   2 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |   1 +
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |  12 +-
 drivers/crypto/cavium/cpt/request_manager.h        |   2 +
 drivers/crypto/ccp/ccp-dev.h                       |   1 +
 drivers/crypto/ccp/ccp-ops.c                       |  37 +++-
 drivers/crypto/ccree/cc_cipher.c                   |  30 +--
 drivers/crypto/hisilicon/sec/sec_algs.c            |  34 +--
 drivers/crypto/qat/qat_common/qat_algs.c           |  22 +-
 drivers/crypto/qat/qat_common/qat_uclo.c           |   9 +-
 drivers/devfreq/devfreq.c                          |  11 +-
 drivers/devfreq/rk3399_dmc.c                       |  42 ++--
 drivers/edac/edac_device_sysfs.c                   |   1 +
 drivers/edac/edac_pci_sysfs.c                      |   2 +-
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |  12 +-
 drivers/firmware/qcom_scm.c                        |   7 +-
 drivers/gpio/gpiolib-devres.c                      |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  19 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c   |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   4 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  16 +-
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |  11 +-
 drivers/gpu/drm/amd/powerplay/arcturus_ppt.c       |  14 +-
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c          |   3 +-
 drivers/gpu/drm/arm/malidp_planes.c                |   2 +-
 drivers/gpu/drm/bridge/sil-sii8620.c               |   2 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   8 +-
 drivers/gpu/drm/drm_debugfs.c                      |   8 +-
 drivers/gpu/drm/drm_gem.c                          |   4 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   6 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  19 +-
 drivers/gpu/drm/imx/dw_hdmi-imx.c                  |  15 +-
 drivers/gpu/drm/imx/imx-drm-core.c                 |   3 +-
 drivers/gpu/drm/imx/imx-ldb.c                      |  15 +-
 drivers/gpu/drm/imx/imx-tve.c                      |  35 ++--
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |  21 +-
 drivers/gpu/drm/imx/parallel-display.c             |  15 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  18 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   2 +-
 drivers/gpu/drm/msm/msm_gem.c                      |  36 ++--
 drivers/gpu/drm/nouveau/dispnv50/head.c            |  24 ++-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |   4 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   8 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   4 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |   9 +-
 drivers/gpu/drm/panel/panel-simple.c               |   2 +-
 drivers/gpu/drm/panfrost/panfrost_job.c            |   5 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   2 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   4 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   9 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   4 +-
 drivers/gpu/drm/stm/ltdc.c                         |   3 +
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |   6 +-
 drivers/gpu/drm/ttm/ttm_tt.c                       |   3 -
 drivers/gpu/drm/xen/xen_drm_front.c                |   4 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c            |   8 +-
 drivers/gpu/drm/xen/xen_drm_front_kms.c            |   2 +-
 drivers/gpu/host1x/debug.c                         |   4 +
 drivers/gpu/ipu-v3/ipu-common.c                    |   2 +
 drivers/hid/hid-input.c                            |   6 +-
 drivers/hwtracing/coresight/coresight-etm4x.c      |  22 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |   6 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |  13 +-
 drivers/iio/amplifiers/ad8366.c                    |   7 +-
 drivers/infiniband/core/device.c                   |  11 +-
 drivers/infiniband/core/nldev.c                    |   3 -
 drivers/infiniband/core/verbs.c                    |   2 +-
 drivers/infiniband/hw/qedr/qedr.h                  |   4 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  22 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |   6 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   5 +-
 drivers/iommu/intel_irq_remapping.c                |   8 +
 drivers/irqchip/irq-bcm7038-l1.c                   |   8 +
 drivers/irqchip/irq-gic-v3-its.c                   |   4 +-
 drivers/irqchip/irq-loongson-liointc.c             |   1 +
 drivers/irqchip/irq-mtk-sysirq.c                   |   8 +-
 drivers/irqchip/irq-ti-sci-inta.c                  |   2 +-
 drivers/leds/led-class.c                           |   1 +
 drivers/leds/leds-lm355x.c                         |   7 +-
 drivers/macintosh/via-macii.c                      |   9 +-
 drivers/md/bcache/super.c                          |   9 +-
 drivers/md/md-cluster.c                            |   1 +
 drivers/md/md.c                                    |   9 +-
 drivers/media/firewire/firedtv-fw.c                |   2 +
 drivers/media/i2c/tvp5150.c                        |   8 +-
 drivers/media/mc/mc-request.c                      |  31 +--
 drivers/media/platform/cros-ec-cec/cros-ec-cec.c   |   6 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   3 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |   2 +
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c      |  16 +-
 drivers/media/platform/omap3isp/isppreview.c       |   4 +-
 drivers/media/platform/s5p-g2d/g2d.c               |  28 +--
 drivers/media/usb/dvb-usb/Kconfig                  |   1 +
 drivers/media/usb/go7007/go7007-usb.c              |  11 +-
 drivers/memory/samsung/exynos5422-dmc.c            |  12 +-
 drivers/memory/tegra/tegra186-emc.c                |  16 +-
 drivers/mfd/ioc3.c                                 |   6 +
 drivers/misc/cxl/sysfs.c                           |   2 +-
 drivers/misc/lkdtm/bugs.c                          |  49 +++--
 drivers/misc/lkdtm/lkdtm.h                         |   2 -
 drivers/misc/lkdtm/perms.c                         |  22 +-
 drivers/misc/lkdtm/usercopy.c                      |   7 +-
 drivers/mmc/host/sdhci-cadence.c                   | 123 +++++------
 drivers/mmc/host/sdhci-of-arasan.c                 |   4 +
 drivers/mmc/host/sdhci-pci-o2micro.c               |   6 +
 drivers/most/core.c                                |   4 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   5 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |   7 +-
 drivers/mtd/spi-nor/controllers/intel-spi.c        |   9 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   1 -
 drivers/net/dsa/rtl8366.c                          |  35 +++-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |   6 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c  |   2 +-
 .../ethernet/cavium/liquidio/cn23xx_pf_device.c    |   2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   2 +-
 drivers/net/ethernet/freescale/fman/fman.c         |   3 +-
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |   4 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h     |   2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |   3 +-
 drivers/net/ethernet/freescale/fman/fman_port.c    |   9 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c    |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   9 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  42 ++--
 drivers/net/ethernet/mscc/ocelot.c                 |  16 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                |   4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  19 ++
 drivers/net/ethernet/toshiba/spider_net.c          |   4 +-
 drivers/net/phy/marvell10g.c                       |  18 +-
 drivers/net/phy/mscc/mscc_main.c                   |   9 +
 drivers/net/phy/phy_device.c                       |   8 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   3 +-
 drivers/net/wan/lapbether.c                        |  10 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   4 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |   2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   4 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   6 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   4 +-
 drivers/net/wireless/marvell/mwifiex/sdio.h        |   4 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  22 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  13 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   5 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |   3 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  11 +-
 drivers/net/wireless/ti/wl1251/event.c             |   2 +-
 drivers/nvme/host/multipath.c                      |  17 +-
 drivers/nvme/host/rdma.c                           |  12 +-
 drivers/nvme/host/tcp.c                            |  12 +-
 drivers/nvmem/sprd-efuse.c                         |   4 +-
 drivers/parisc/sba_iommu.c                         |   2 +-
 drivers/pci/access.c                               |   8 +-
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   9 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |  15 +-
 drivers/pci/controller/vmd.c                       |   3 +
 drivers/pci/pcie/aspm.c                            |   1 +
 drivers/pci/quirks.c                               |   2 +
 drivers/phy/marvell/phy-armada38x-comphy.c         |  45 +++-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  61 +++---
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |   4 +-
 drivers/pinctrl/pinctrl-single.c                   |  11 +-
 drivers/platform/x86/asus-nb-wmi.c                 |  82 ++++++++
 drivers/platform/x86/intel-hid.c                   |   2 +-
 drivers/platform/x86/intel-vbtn.c                  |   2 +-
 drivers/power/supply/88pm860x_battery.c            |   6 +-
 drivers/regulator/core.c                           |  18 +-
 drivers/reset/reset-intel-gw.c                     |  24 +--
 drivers/s390/block/dasd_diag.c                     |  25 ++-
 drivers/s390/net/qeth_core_main.c                  |  20 +-
 drivers/s390/net/qeth_l2_main.c                    |   4 +
 drivers/scsi/arm/cumana_2.c                        |   2 +-
 drivers/scsi/arm/eesox.c                           |   2 +-
 drivers/scsi/arm/powertec.c                        |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   9 +-
 drivers/scsi/mesh.c                                |   8 +-
 drivers/scsi/scsi_debug.c                          |   6 +
 drivers/scsi/ufs/ufshcd.c                          |  18 +-
 drivers/scsi/ufs/ufshcd.h                          |   2 +-
 drivers/soc/qcom/pdr_interface.c                   |   4 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   1 +
 drivers/spi/spi-lantiq-ssc.c                       |  12 +-
 drivers/spi/spi-rockchip.c                         |   2 +-
 drivers/spi/spidev.c                               |  21 +-
 drivers/staging/media/allegro-dvt/allegro-core.c   |   8 +-
 drivers/staging/media/rkisp1/rkisp1-resizer.c      |  12 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   2 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |   1 +
 .../int340x_thermal/processor_thermal_device.c     |   2 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   2 +-
 drivers/usb/cdns3/gadget.c                         |   3 +-
 drivers/usb/core/quirks.c                          |  16 +-
 drivers/usb/dwc2/platform.c                        |   4 +-
 drivers/usb/gadget/function/f_uac2.c               |   7 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              |  13 +-
 drivers/usb/gadget/udc/bdc/bdc_ep.c                |  16 +-
 drivers/usb/gadget/udc/net2280.c                   |   4 +-
 drivers/usb/mtu3/mtu3_core.c                       |   6 +-
 drivers/usb/serial/cp210x.c                        |  19 ++
 drivers/usb/serial/iuu_phoenix.c                   |  14 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |  31 ++-
 drivers/video/console/newport_con.c                |  12 +-
 drivers/video/fbdev/neofb.c                        |   1 +
 drivers/video/fbdev/pxafb.c                        |   4 +-
 drivers/video/fbdev/savage/savagefb_driver.c       |   2 +
 drivers/video/fbdev/sm712fb.c                      |   2 +
 drivers/xen/balloon.c                              |  12 +-
 drivers/xen/gntdev-dmabuf.c                        |   8 +
 fs/9p/v9fs.c                                       |   5 +-
 fs/btrfs/ctree.h                                   |   2 +
 fs/btrfs/extent-tree.c                             |   8 +
 fs/btrfs/extent_io.c                               |   2 +
 fs/btrfs/file.c                                    |  12 +-
 fs/btrfs/inode.c                                   |  44 +++-
 fs/btrfs/space-info.c                              |   2 +-
 fs/dlm/lockspace.c                                 |   6 +-
 fs/erofs/inode.c                                   | 121 +++++++----
 fs/io_uring.c                                      | 233 ++++++++++++++++-----
 fs/iomap/apply.c                                   |  13 +-
 fs/kernfs/file.c                                   |   2 +-
 fs/minix/inode.c                                   |  36 +++-
 fs/minix/itree_common.c                            |   8 +-
 fs/nfs/pnfs.c                                      |  46 ++--
 fs/nfsd/nfs4recover.c                              |  24 +--
 fs/ocfs2/dlmglue.c                                 |   8 +-
 fs/pstore/platform.c                               |   5 +-
 fs/xfs/libxfs/xfs_trans_space.h                    |   2 +-
 fs/xfs/scrub/bmap.c                                |  22 +-
 fs/xfs/xfs_qm.c                                    |   1 +
 fs/xfs/xfs_reflink.c                               |  21 +-
 include/asm-generic/vmlinux.lds.h                  |   1 +
 include/linux/bitfield.h                           |   2 +-
 include/linux/gpio/driver.h                        |  13 +-
 include/linux/tpm.h                                |   1 +
 include/linux/tpm_eventlog.h                       |  11 +-
 include/linux/tracepoint.h                         |   2 +-
 include/net/bluetooth/bluetooth.h                  |   2 +
 include/net/bluetooth/hci.h                        |  11 +
 include/net/inet_connection_sock.h                 |   4 +
 include/net/ip_vs.h                                |  10 +-
 include/net/tcp.h                                  |   2 +
 include/uapi/linux/seccomp.h                       |   3 +-
 kernel/rcu/tree.c                                  |   9 +-
 kernel/sched/core.c                                |  21 +-
 kernel/sched/fair.c                                |  23 +-
 kernel/sched/topology.c                            |   2 +-
 kernel/seccomp.c                                   |   9 +
 kernel/signal.c                                    |  16 +-
 kernel/task_work.c                                 |   8 +-
 kernel/time/tick-sched.c                           |  22 +-
 kernel/trace/blktrace.c                            |  18 +-
 kernel/trace/ftrace.c                              |   3 -
 kernel/trace/trace.c                               |  12 +-
 kernel/trace/trace.h                               |   9 +-
 lib/crc-t10dif.c                                   |  54 +++--
 lib/dynamic_debug.c                                |  23 +-
 lib/kobject.c                                      |  33 ++-
 mm/mmap.c                                          |   1 +
 net/bluetooth/6lowpan.c                            |   5 +
 net/bluetooth/hci_core.c                           |  28 ++-
 net/core/sock.c                                    |  25 ++-
 net/ipv4/inet_connection_sock.c                    |  97 +++++----
 net/ipv4/inet_hashtables.c                         |   1 +
 net/ipv4/sysctl_net_ipv4.c                         |  16 +-
 net/ipv4/tcp.c                                     |  16 +-
 net/ipv4/tcp_fastopen.c                            |  23 ++
 net/netfilter/ipvs/ip_vs_core.c                    |  12 +-
 net/netfilter/nft_meta.c                           |   2 +-
 net/nfc/rawsock.c                                  |   7 +-
 net/packet/af_packet.c                             |   9 +-
 net/socket.c                                       |   2 +-
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |   2 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   1 -
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |  28 ++-
 net/tls/tls_device.c                               |   3 +-
 net/vmw_vsock/af_vsock.c                           |   2 +-
 samples/bpf/fds_example.c                          |   3 +-
 samples/bpf/map_perf_test_kern.c                   |   9 +-
 samples/bpf/test_map_in_map_kern.c                 |   9 +-
 samples/bpf/test_probe_write_user_kern.c           |   9 +-
 scripts/recordmcount.c                             |   6 +
 scripts/selinux/mdp/mdp.c                          |  23 +-
 security/integrity/ima/ima.h                       |   5 +
 security/integrity/ima/ima_policy.c                | 102 ++++++++-
 security/smack/smackfs.c                           |   6 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/hdac_hda.c                        |   7 +-
 sound/soc/codecs/tas2770.c                         |   3 +-
 sound/soc/fsl/fsl_sai.c                            |   5 +-
 sound/soc/fsl/fsl_sai.h                            |   2 +-
 sound/soc/intel/boards/bxt_rt298.c                 |   2 +
 sound/soc/intel/boards/cml_rt1011_rt5682.c         |   1 +
 sound/soc/intel/boards/sof_sdw.c                   |   1 +
 sound/soc/meson/axg-card.c                         |   2 +-
 sound/soc/meson/axg-tdm-formatter.c                |  11 +-
 sound/soc/meson/axg-tdm-formatter.h                |   1 -
 sound/soc/meson/axg-tdm-interface.c                |  26 ++-
 sound/soc/meson/axg-tdmin.c                        |  16 +-
 sound/soc/meson/axg-tdmout.c                       |   3 -
 sound/soc/soc-core.c                               |   5 +-
 sound/soc/sof/nocodec.c                            |   1 +
 sound/usb/card.h                                   |   1 +
 sound/usb/mixer_quirks.c                           |   1 +
 sound/usb/pcm.c                                    |   6 +
 sound/usb/quirks-table.h                           |  64 +++++-
 sound/usb/quirks.c                                 |   3 +
 sound/usb/stream.c                                 |   1 +
 tools/bpf/bpftool/btf.c                            |   2 +-
 tools/bpf/bpftool/gen.c                            |   5 +-
 tools/build/Build.include                          |   3 +-
 tools/lib/bpf/bpf_tracing.h                        |   4 +-
 tools/testing/kunit/kunit_kernel.py                |   6 +-
 tools/testing/selftests/lkdtm/run.sh               |   6 +
 tools/testing/selftests/lkdtm/tests.txt            |   1 +
 .../selftests/powerpc/benchmarks/context_switch.c  |  21 +-
 .../testing/selftests/powerpc/eeh/eeh-functions.sh |  11 +-
 tools/testing/selftests/powerpc/utils.c            |  37 ++--
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   2 +-
 419 files changed, 3293 insertions(+), 1963 deletions(-)


