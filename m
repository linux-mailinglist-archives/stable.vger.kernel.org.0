Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0B3246F9F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390150AbgHQRtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388695AbgHQQM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:12:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0125820B1F;
        Mon, 17 Aug 2020 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680744;
        bh=hbWRcol1bo6EpOCPqHtJmkzXsN/DuWSrcCiupy3Mkis=;
        h=From:To:Cc:Subject:Date:From;
        b=xorJR5Dzy8TEbgn+JatvuFhAeiXkkzOKDgneGIlvn13ECmkhtTVs+6N/zcOIjLXvb
         6RhFpffVqF1lmoVrMOvF6TDJ3RknUnMux8jt9gN/bzL0PRmqLxSwwsvWa38ridPHLr
         xfXW0rYcPcyjKwGlMoN9qvyv+IjGQjb5c+G81e+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/168] 4.19.140-rc1 review
Date:   Mon, 17 Aug 2020 17:15:31 +0200
Message-Id: <20200817143733.692105228@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.140-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.140-rc1
X-KernelTest-Deadline: 2020-08-19T14:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.140 release.
There are 168 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.140-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.140-rc1

Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
    xen/gntdev: Fix dmabuf import with non-zero sgt offset

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: make the balloon wait interruptible

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: fix accounting in alloc_xenballooned_pages error path

Jon Derrick <jonathan.derrick@intel.com>
    irqdomain/treewide: Free firmware node after domain removal

Nathan Huckleberry <nhuck@google.com>
    ARM: 8992/1: Fix unwind_frame for clang-built kernels

Sven Schnelle <svens@stackframe.org>
    parisc: mask out enable and reserved bits from sba imask

John David Anglin <dave.anglin@bell.net>
    parisc: Implement __smp_store_release and __smp_load_acquire barriers

Sivaprakash Murugesan <sivaprak@codeaurora.org>
    mtd: rawnand: qcom: avoid write to unavailable register

Christian Eggers <ceggers@arri.de>
    spi: spidev: Align buffers for DMA

Romain Naour <romain.naour@gmail.com>
    include/asm-generic/vmlinux.lds.h: align ro_after_init

Ivan Kokshaysky <ink@jurassic.park.msu.ru>
    cpufreq: dt: fix oops on armada37xx

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't return layout segments that are in use

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't move layouts to plh_return_segs list while in use

Dave Airlie <airlied@redhat.com>
    drm/ttm/nouveau: don't call tt destroy callback on alloc failure.

Zheng Bin <zhengbin13@huawei.com>
    9p: Fix memory leak in v9fs_mount

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: add quirk for Pioneer DDJ-RB

Eric Biggers <ebiggers@google.com>
    fs/minix: reject too-large maximum file size

Eric Biggers <ebiggers@google.com>
    fs/minix: don't allow getting deleted inodes

Eric Biggers <ebiggers@google.com>
    fs/minix: check return value of sb_getblk()

Jakub Kicinski <kuba@kernel.org>
    bitfield.h: don't compile-time validate _val in FIELD_FIT

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

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109

Mirko Dietrich <buzz@l4m1.de>
    ALSA: usb-audio: Creative USB X-Fi Pro SB1095 volume knob support

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - fix the micmute led status for Lenovo ThinkCentre AIO

Brant Merryman <brant.merryman@silabs.com>
    USB: serial: cp210x: enable usb generic throttle/unthrottle

Brant Merryman <brant.merryman@silabs.com>
    USB: serial: cp210x: re-enable auto-RTS on open

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    net: initialize fastreuse on inet_inherit_port

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    net: refactor bind_bucket fastreuse into helper

Ira Weiny <ira.weiny@intel.com>
    net/tls: Fix kmap usage

Miaohe Lin <linmiaohe@huawei.com>
    net: Set fput_needed iff FDPUT_FPUT is set

Qingyu Li <ieatmuttonchuan@gmail.com>
    net/nfc/rawsock.c: add CAP_NET_RAW check.

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Added needed_headroom and a skb->len check

John Ogness <john.ogness@linutronix.de>
    af_packet: TPACKET_V3: fix fill status rwlock imbalance

Jian Cai <caij2003@gmail.com>
    crypto: aesni - add compatibility with IAS

Eric Dumazet <edumazet@google.com>
    x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix page leak in svc_rdma_recv_read_chunk()

Drew Fustini <drew@beagleboard.org>
    pinctrl-single: fix pcs_parse_pinconf() return value

Pavel Machek <pavel@ucw.cz>
    ocfs2: fix unbalanced locking

Wang Hai <wanghai38@huawei.com>
    dlm: Fix kobject memleak

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

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    liquidio: Fix wrong return value in cn23xx_get_pf_num()

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    net: ethernet: aquantia: Fix wrong return value

Andrii Nakryiko <andriin@fb.com>
    tools, build: Propagate build failures from tools/build/Makefile.build

Wang Hai <wanghai38@huawei.com>
    wl1251: fix always return 0 error

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't process empty bridge port events

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm-interface: fix link fmt setup

Sandipan Das <sandipan@linux.ibm.com>
    selftests/powerpc: Fix online CPU selection

Hanjun Guo <guohanjun@huawei.com>
    PCI: Release IVRS table in AMD ACS quirk

Harish <harish@linux.ibm.com>
    selftests/powerpc: Fix CPU affinity for child process

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/boot: Fix CONFIG_PPC_MPC52XX references

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Fix VLAN set-up

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Fix VLAN semantics

Nicolas Boichat <drinkcat@chromium.org>
    Bluetooth: hci_serdev: Only unregister device if it was registered

Nicolas Boichat <drinkcat@chromium.org>
    Bluetooth: hci_h5: Set HCI_UART_RESET_ON_INIT to correct flags

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

Chris Packham <chris.packham@alliedtelesis.co.nz>
    net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration

Finn Thain <fthain@telegraphics.com.au>
    scsi: mesh: Fix panic after host or bus reset

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc2: Fix error path in gadget registration

Yu Kuai <yukuai3@huawei.com>
    MIPS: OCTEON: add missing put_device() call in dwc3_octeon_device_init()

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: tmc: Fix TMC mode read in tmc_read_unprepare_etb()

Dan Carpenter <dan.carpenter@oracle.com>
    thermal: ti-soc-thermal: Fix reversed condition in ti_thermal_expose_sensor()

Kars Mulder <kerneldev@karsmulder.nl>
    usb: core: fix quirks_param_set() writing to a const pointer

Johan Hovold <johan@kernel.org>
    USB: serial: iuu_phoenix: fix led-activity helpers

Marco Felsch <m.felsch@pengutronix.de>
    drm/imx: tve: fix regulator_disable error path

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/pkeys: Use PVR check instead of cpu feature

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    PCI/ASPM: Add missing newline in sysfs 'policy'

Colin Ian King <colin.king@canonical.com>
    staging: rtl8192u: fix a dubious looking mask before a shift

Mikhail Malygin <m.malygin@yadro.com>
    RDMA/rxe: Prevent access to wr->next ptr afrer wr is posted to send queue

Yuval Basson <ybason@marvell.com>
    RDMA/qedr: SRQ's bug fixes

Milton Miller <miltonm@us.ibm.com>
    powerpc/vdso: Fix vdso cpu truncation

Dan Carpenter <dan.carpenter@oracle.com>
    mwifiex: Prevent memory corruption handling keys

John Garry <john.garry@huawei.com>
    scsi: scsi_debug: Add check for sdebug_max_queue during module init

Tom Rix <trix@redhat.com>
    drm/bridge: sil_sii8620: initialize return of sii8620_readb

Marek Szyprowski <m.szyprowski@samsung.com>
    phy: exynos5-usbdrd: Calibrating makes sense only for USB2.0 PHY

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: panel: simple: Fix bpc for LG LB070WV8 panel

Kai-Heng Feng <kai.heng.feng@canonical.com>
    leds: core: Flush scheduled work for system suspend

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Fix pci_cfg_wait queue locking problem

Zhu Yanjun <yanjunz@mellanox.com>
    RDMA/rxe: Skip dgid check in loopback mode

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix reflink quota reservation accounting error

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't eat an EIO/ENOSPC writeback error when scrubbing data fork

Chuhong Yuan <hslester96@gmail.com>
    media: exynos4-is: Add missed check for pinctrl_lookup_state()

Dan Carpenter <dan.carpenter@oracle.com>
    media: firewire: Using uninitialized values in node_probe()

Julian Anastasov <ja@ssi.bg>
    ipvs: allow connection reuse for unconfirmed conntrack

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: eesox: Fix different dev_id between request_irq() and free_irq()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: powertec: Fix different dev_id between request_irq() and free_irq()

Colin Ian King <colin.king@canonical.com>
    drm/radeon: fix array out-of-bounds read and write issues

Wang Hai <wanghai38@huawei.com>
    cxl: Fix kobject memleak

Emil Velikov <emil.velikov@collabora.com>
    drm/mipi: use dcs write for mipi_dsi_dcs_set_tear_scanline

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: bxt_rt298: add missing .owner field

Chuhong Yuan <hslester96@gmail.com>
    media: omap3isp: Add missed v4l2_ctrl_handler_free() for preview_init_entities()

Arnd Bergmann <arnd@arndb.de>
    leds: lm355x: avoid enum conversion warning

Colin Ian King <colin.king@canonical.com>
    drm/arm: fix unintentional integer overflow on left shift

Lubomir Rintel <lkundrak@v3.sk>
    drm/etnaviv: Fix error path on failure to enable bus clk

Tomasz Duszynski <tomasz.duszynski@octakon.com>
    iio: improve IIO_CONCENTRATION channel type description

Evan Green <evgreen@chromium.org>
    ath10k: Acquire tx_lock in tx error paths

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    video: pxafb: Fix the function used to balance a 'dma_alloc_coherent()' call

Dejin Zheng <zhengdejin5@gmail.com>
    console: newport_con: fix an issue about leak related system resources

Dejin Zheng <zhengdejin5@gmail.com>
    video: fbdev: sm712fb: fix an issue about iounmap for a wrong address

Qiushi Wu <wu000273@umn.edu>
    agp/intel: Fix a memory leak on module initialisation failure

Rob Clark <robdclark@chromium.org>
    drm/msm: ratelimit crtc event overflow error

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Do not increment operation_region reference counts for field units

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

Dmitry Osipenko <digetx@gmail.com>
    gpu: host1x: debug: Fix multiple channels emitting messages simultaneously

Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
    iwlegacy: Check the return value of pcie_capability_read_*()

Wright Feng <wright.feng@cypress.com>
    brcmfmac: set state of hanger slot to FREE when flushing PSQ

Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>
    brcmfmac: To fix Bss Info flag definition Bug

Wright Feng <wright.feng@cypress.com>
    brcmfmac: keep SDIO watchdog running when console_interval is non-zero

Paul E. McKenney <paulmck@kernel.org>
    mm/mmap.c: Add cond_resched() for exit_mmap() CPU stalls

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    irqchip/irq-mtk-sysirq: Replace spinlock with raw_spinlock

Christian König <christian.koenig@amd.com>
    drm/radeon: disable AGP by default

Michael Tretter <m.tretter@pengutronix.de>
    drm/debugfs: fix plain echo to connector "force" attribute

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: clear dual mode of u3port when disable device

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: fix multiple instances of reference count leaks

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/etnaviv: fix ref count leak via pm_runtime_get_sync

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    arm64: dts: hisilicon: hikey: fixes to comply with adi, adv7533 DT binding

Zhao Heming <heming.zhao@suse.com>
    md-cluster: fix wild pointer of unlock_all_bitmaps()

Evgeny Novikov <novikov@ispras.ru>
    video: fbdev: neofb: fix memory leak in neo_scan_monitor()

Sedat Dilek <sedat.dilek@gmail.com>
    crypto: aesni - Fix build with LLVM_IAS=1

Aditya Pakki <pakki001@umn.edu>
    drm/radeon: Fix reference count leaks caused by pm_runtime_get_sync

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu: avoid dereferencing a NULL pointer

Paul E. McKenney <paulmck@kernel.org>
    fs/btrfs: Add cond_resched() for try_release_extent_mapping() stalls

Luis Chamberlain <mcgrof@kernel.org>
    loop: be paranoid on exit and prevent new additions / removals

Lihong Kou <koulihong@huawei.com>
    Bluetooth: add a mutex lock to avoid UAF in do_enale_set

Maulik Shah <mkshah@codeaurora.org>
    soc: qcom: rpmh-rsc: Set suppress_bind_attrs flag

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/tilcdc: fix leak & null ref in panel_connector_get_modes

Yu Kuai <yukuai3@huawei.com>
    ARM: socfpga: PM: add missing put_device() call in socfpga_setup_ocram_self_refresh()

Dilip Kota <eswara.kota@linux.intel.com>
    spi: lantiq: fix: Rx overflow error in full duplex mode

yu kuai <yukuai3@huawei.com>
    ARM: at91: pm: add missing put_device() call in at91_pm_sram_init()

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    ARM: dts: gose: Fix ports node name for adv7612

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

Alim Akhtar <alim.akhtar@samsung.com>
    arm64: dts: exynos: Fix silent hang after boot on Espresso

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix SCMI genpd domain probing

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix resource leak on error path

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Replace invalid bias-pull-none property

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

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    x86/mce/inject: Fix a wrong assignment of i_mce.status

Yang Yingliang <yangyingliang@huawei.com>
    cgroup: add missing skcd->no_refcnt check in cgroup_sk_clone()

Grant Likely <grant.likely@secretlab.ca>
    HID: input: Fix devices that return multiple bytes in battery report

Nick Desaulniers <ndesaulniers@google.com>
    tracepoint: Mark __tracepoint_string's __used


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio            |  3 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/r8a7793-gose.dts                 |  4 +-
 arch/arm/kernel/stacktrace.c                       | 24 ++++++
 arch/arm/mach-at91/pm.c                            | 11 ++-
 arch/arm/mach-socfpga/pm.c                         |  8 +-
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts    |  1 +
 arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts  | 11 +++
 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts     |  2 +-
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi         | 10 +--
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi      |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |  4 +-
 arch/m68k/mac/iop.c                                | 21 ++---
 arch/mips/cavium-octeon/octeon-usb.c               |  5 +-
 arch/parisc/include/asm/barrier.h                  | 61 ++++++++++++++
 arch/powerpc/boot/Makefile                         |  2 +-
 arch/powerpc/boot/serial.c                         |  2 +-
 arch/powerpc/kernel/vdso.c                         |  2 +-
 arch/powerpc/mm/pkeys.c                            | 16 ++--
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            | 14 +---
 arch/x86/crypto/aesni-intel_asm.S                  |  6 +-
 arch/x86/kernel/apic/io_apic.c                     |  5 ++
 arch/x86/kernel/cpu/mcheck/mce-inject.c            |  2 +-
 arch/x86/kernel/ptrace.c                           |  2 +-
 drivers/acpi/acpica/exprep.c                       |  4 -
 drivers/acpi/acpica/utdelete.c                     |  6 +-
 drivers/block/loop.c                               |  4 +
 drivers/bluetooth/hci_h5.c                         |  2 +-
 drivers/bluetooth/hci_serdev.c                     |  3 +-
 drivers/char/agp/intel-gtt.c                       |  4 +-
 drivers/clk/clk-scmi.c                             | 22 ++++-
 drivers/cpufreq/armada-37xx-cpufreq.c              |  1 +
 drivers/crypto/cavium/cpt/cptvf_algs.c             |  1 +
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       | 12 +--
 drivers/crypto/cavium/cpt/request_manager.h        |  2 +
 drivers/crypto/ccp/ccp-dev.h                       |  1 +
 drivers/crypto/ccp/ccp-ops.c                       | 37 ++++++---
 drivers/crypto/ccree/cc_cipher.c                   | 30 ++++---
 drivers/crypto/hisilicon/sec/sec_algs.c            | 34 ++++----
 drivers/crypto/qat/qat_common/qat_uclo.c           |  9 ++-
 drivers/edac/edac_device_sysfs.c                   |  1 +
 drivers/edac/edac_pci_sysfs.c                      |  2 +-
 drivers/firmware/arm_scmi/scmi_pm_domain.c         | 12 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          | 19 +++--
 drivers/gpu/drm/arm/malidp_planes.c                |  2 +-
 drivers/gpu/drm/bridge/sil-sii8620.c               |  2 +-
 drivers/gpu/drm/drm_debugfs.c                      |  8 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |  6 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              | 19 +++--
 drivers/gpu/drm/imx/imx-tve.c                      | 20 ++---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |  2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  8 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  4 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |  9 +--
 drivers/gpu/drm/panel/panel-simple.c               |  2 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |  2 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  4 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |  9 +--
 drivers/gpu/drm/radeon/radeon_kms.c                |  4 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |  6 +-
 drivers/gpu/drm/ttm/ttm_tt.c                       |  3 -
 drivers/gpu/host1x/debug.c                         |  4 +
 drivers/hid/hid-input.c                            |  6 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c    | 13 ++-
 drivers/infiniband/core/verbs.c                    |  2 +-
 drivers/infiniband/hw/qedr/qedr.h                  |  4 +-
 drivers/infiniband/hw/qedr/verbs.c                 | 22 +++--
 drivers/infiniband/sw/rxe/rxe_recv.c               |  6 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |  5 +-
 drivers/iommu/intel_irq_remapping.c                |  8 ++
 drivers/irqchip/irq-mtk-sysirq.c                   |  8 +-
 drivers/leds/led-class.c                           |  1 +
 drivers/leds/leds-lm355x.c                         |  7 +-
 drivers/md/bcache/super.c                          |  9 ++-
 drivers/md/md-cluster.c                            |  1 +
 drivers/media/firewire/firedtv-fw.c                |  2 +
 drivers/media/platform/exynos4-is/media-dev.c      |  3 +
 drivers/media/platform/omap3isp/isppreview.c       |  4 +-
 drivers/misc/cxl/sysfs.c                           |  2 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |  7 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  1 -
 drivers/net/dsa/rtl8366.c                          | 35 +++++---
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c  |  2 +-
 .../ethernet/cavium/liquidio/cn23xx_pf_device.c    |  2 +-
 drivers/net/ethernet/freescale/fman/fman.c         |  3 +-
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |  4 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h     |  2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |  3 +-
 drivers/net/ethernet/freescale/fman/fman_port.c    |  9 ++-
 drivers/net/ethernet/freescale/fman/fman_tgec.c    |  2 +-
 drivers/net/ethernet/toshiba/spider_net.c          |  4 +-
 drivers/net/wan/lapbether.c                        | 10 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |  4 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  4 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  6 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |  4 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 22 +++--
 drivers/net/wireless/ti/wl1251/event.c             |  2 +-
 drivers/parisc/sba_iommu.c                         |  2 +-
 drivers/pci/access.c                               |  8 +-
 drivers/pci/controller/pcie-cadence-host.c         |  9 ++-
 drivers/pci/controller/vmd.c                       |  3 +
 drivers/pci/pcie/aspm.c                            |  1 +
 drivers/pci/quirks.c                               |  2 +
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |  4 +-
 drivers/pinctrl/pinctrl-single.c                   | 11 ++-
 drivers/platform/x86/intel-hid.c                   |  2 +-
 drivers/platform/x86/intel-vbtn.c                  |  2 +-
 drivers/power/supply/88pm860x_battery.c            |  6 +-
 drivers/s390/net/qeth_l2_main.c                    |  4 +
 drivers/scsi/arm/cumana_2.c                        |  2 +-
 drivers/scsi/arm/eesox.c                           |  2 +-
 drivers/scsi/arm/powertec.c                        |  2 +-
 drivers/scsi/mesh.c                                |  8 +-
 drivers/scsi/scsi_debug.c                          |  6 ++
 drivers/soc/qcom/rpmh-rsc.c                        |  1 +
 drivers/spi/spi-lantiq-ssc.c                       | 10 +++
 drivers/spi/spidev.c                               | 21 +++--
 drivers/staging/rtl8192u/r8192U_core.c             |  2 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  2 +-
 drivers/usb/core/quirks.c                          | 16 +++-
 drivers/usb/dwc2/platform.c                        |  4 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              | 13 ++-
 drivers/usb/gadget/udc/bdc/bdc_ep.c                | 16 ++--
 drivers/usb/gadget/udc/net2280.c                   |  4 +-
 drivers/usb/mtu3/mtu3_core.c                       |  6 +-
 drivers/usb/serial/cp210x.c                        | 19 +++++
 drivers/usb/serial/iuu_phoenix.c                   | 14 ++--
 drivers/video/console/newport_con.c                | 12 ++-
 drivers/video/fbdev/neofb.c                        |  1 +
 drivers/video/fbdev/pxafb.c                        |  4 +-
 drivers/video/fbdev/sm712fb.c                      |  2 +
 drivers/xen/balloon.c                              | 12 ++-
 drivers/xen/gntdev-dmabuf.c                        |  8 ++
 fs/9p/v9fs.c                                       |  5 +-
 fs/btrfs/extent_io.c                               |  2 +
 fs/dlm/lockspace.c                                 |  6 +-
 fs/minix/inode.c                                   | 36 ++++++++-
 fs/minix/itree_common.c                            |  8 +-
 fs/nfs/pnfs.c                                      | 46 ++++-------
 fs/ocfs2/dlmglue.c                                 |  8 +-
 fs/pstore/platform.c                               |  5 +-
 fs/xfs/scrub/bmap.c                                | 22 ++++-
 fs/xfs/xfs_reflink.c                               | 21 +++--
 include/asm-generic/vmlinux.lds.h                  |  1 +
 include/linux/bitfield.h                           |  2 +-
 include/linux/tracepoint.h                         |  2 +-
 include/net/inet_connection_sock.h                 |  4 +
 include/net/ip_vs.h                                | 10 +--
 kernel/cgroup/cgroup.c                             |  2 +
 kernel/sched/fair.c                                | 23 +++---
 kernel/sched/topology.c                            |  2 +-
 lib/dynamic_debug.c                                | 23 +++---
 mm/mmap.c                                          |  1 +
 net/bluetooth/6lowpan.c                            |  5 ++
 net/ipv4/inet_connection_sock.c                    | 93 ++++++++++++----------
 net/ipv4/inet_hashtables.c                         |  1 +
 net/netfilter/ipvs/ip_vs_core.c                    | 12 +--
 net/nfc/rawsock.c                                  |  7 +-
 net/packet/af_packet.c                             |  9 ++-
 net/socket.c                                       |  2 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  | 28 +++++--
 net/tls/tls_device.c                               |  3 +-
 security/smack/smackfs.c                           |  6 +-
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/intel/boards/bxt_rt298.c                 |  2 +
 sound/soc/meson/axg-tdm-interface.c                | 26 +++---
 sound/usb/card.h                                   |  1 +
 sound/usb/mixer_quirks.c                           |  1 +
 sound/usb/pcm.c                                    |  6 ++
 sound/usb/quirks-table.h                           | 64 ++++++++++++++-
 sound/usb/quirks.c                                 |  3 +
 sound/usb/stream.c                                 |  1 +
 tools/build/Build.include                          |  3 +-
 .../selftests/powerpc/benchmarks/context_switch.c  | 21 +++--
 tools/testing/selftests/powerpc/utils.c            | 37 ++++++---
 177 files changed, 1086 insertions(+), 489 deletions(-)


