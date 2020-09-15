Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4F226B576
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgIOXox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgIOOdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D11023BEC;
        Tue, 15 Sep 2020 14:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179898;
        bh=IDvI303r24V0ytJ8sB6U0JSCHbsRhcLkB9Jowv8T8o8=;
        h=From:To:Cc:Subject:Date:From;
        b=ncooD8BcZHpfvzl4lvGY/gNXnIOOJbVN6nzi7C6I7H1coCqKSXA5wohf/9dxCdv+/
         Sjayl/ouratWCCrZU7AWjDDDGJolK1JK0NZvsbnbP3Tpd+TnvcBGRnRJ3kXU2tBGw+
         Kbn9tGk2Qf+T9F/AeEHUa5Mly46mFAghabDsY3k4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.8 000/177] 5.8.10-rc1 review
Date:   Tue, 15 Sep 2020 16:11:11 +0200
Message-Id: <20200915140653.610388773@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.10-rc1
X-KernelTest-Deadline: 2020-09-17T14:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.10 release.
There are 177 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.10-rc1

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm: Enable expanded apriv support for a650

Rob Clark <robdclark@chromium.org>
    drm/msm/gpu: make ringbuffer readonly

Utkarsh Patel <utkarsh.h.patel@intel.com>
    usb: typec: intel_pmc_mux: Do not configure SBU and HSL Orientation in Alternate modes

Utkarsh Patel <utkarsh.h.patel@intel.com>
    usb: typec: intel_pmc_mux: Do not configure Altmode HPD High

Madhusudanarao Amara <madhusudanarao.amara@intel.com>
    usb: typec: intel_pmc_mux: Un-register the USB role switch

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: acpi: Check the _DEP dependencies

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: Fix out of sync data toggle if a configured device is reconfigured

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: support dynamic Quectel USB compositions

Patrick Riphagen <patrick.riphagen@xsens.com>
    USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter

Zeng Tao <prime.zeng@hisilicon.com>
    usb: core: fix slab-out-of-bounds Read in read_descriptors

Sivaprakash Murugesan <sivaprak@codeaurora.org>
    phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init

Vaibhav Agarwal <vaibhav.sr@gmail.com>
    staging: greybus: audio: fix uninitialized value issue

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    video: fbdev: fix OOB read in vga_8planes_imageblit()

Chris Healy <cphealy@gmail.com>
    ARM: dts: vfxxx: Add syscon compatible with OCOTP

Robin Gong <yibin.gong@nxp.com>
    arm64: dts: imx8mp: correct sdma1 clk setting

Kees Cook <keescook@chromium.org>
    test_firmware: Test platform fw loading on non-EFI systems

Vladis Dronov <vdronov@redhat.com>
    debugfs: Fix module state check condition

Amjad Ouled-Ameur <aouledameur@baylibre.com>
    Revert "usb: dwc3: meson-g12a: fix shared reset control use"

Rustam Kovhaev <rkovhaev@gmail.com>
    KVM: fix memory leak in kvm_io_bus_unregister_dev()

Lai Jiangshan <laijs@linux.alibaba.com>
    kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Do not try to map PUDs when they are folded into PMD

Wanpeng Li <wanpengli@tencent.com>
    KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit

Linus Torvalds <torvalds@linux-foundation.org>
    vgacon: remove software scrollback support

Linus Torvalds <torvalds@linux-foundation.org>
    fbcon: remove now unusued 'softback_lines' cursor() argument

Linus Torvalds <torvalds@linux-foundation.org>
    fbcon: remove soft scrollback code

Mark Bloch <markb@mellanox.com>
    RDMA/mlx4: Read pkey table length instead of hardcoded value

Yi Zhang <yi.zhang@redhat.com>
    RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars

Ilya Dryomov <idryomov@gmail.com>
    rbd: require global CAP_SYS_ADMIN for mapping and unmapping

James Smart <james.smart@broadcom.com>
    nvme: Revert: Fix controller creation races with teardown flow

Chris Packham <chris.packham@alliedtelesis.co.nz>
    mmc: sdhci-of-esdhc: Don't walk device-tree on every interrupt

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdio: Use mmc_pre_req() / mmc_post_req()

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm: Disable the RPTR shadow

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm: Disable preemption on all 5xx targets

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm: Split the a5xx preemption record

Linus Walleij <linus.walleij@linaro.org>
    drm/tve200: Stabilize enable/disable

Hou Pu <houpu@bytedance.com>
    scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

James Smart <james.smart@broadcom.com>
    scsi: lpfc: Fix setting IRQ affinity with an empty CPU mask

Varun Prakash <varun@chelsio.com>
    scsi: target: iscsi: Fix data digest calculation

Vadym Kochan <vadym.kochan@plvision.eu>
    misc: eeprom: at24: register nvmem only after eeprom is ready to use

Dmitry Osipenko <digetx@gmail.com>
    regulator: core: Fix slab-out-of-bounds in regulator_unlock_recursive()

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: plug of_node leak in regulator_register()'s error path

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: push allocation in set_consumer_device_supply() out of lock

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: push allocations in create_regulator() outside of lock

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: push allocation in regulator_init_coupling() outside of lock

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    kobject: Restore old behaviour of kobject_del(NULL)

Nikunj A. Dadhania <nikunj.dadhania@linux.intel.com>
    thunderbolt: Disable ports that are not implemented

Prateek Sood <prsood@codeaurora.org>
    firmware_loader: fix memory leak for paged buffer

Filipe Manana <fdmanana@suse.com>
    btrfs: fix wrong address when faulting in pages in the search ioctl

Josef Bacik <josef@toxicpanda.com>
    btrfs: free data reloc tree on failed mount

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix lockdep splat in add_missing_dev

Qu Wenruo <wqu@suse.com>
    btrfs: require only sector size alignment for parent eb bytenr

Rustam Kovhaev <rkovhaev@gmail.com>
    staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:mma8452: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:mma7455: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: kxsd9: Fix alignment of local buffer.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:chemical:ccs811: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:max44000 Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:magnetometer:ak8975 Fix alignment and data leak issues.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc081c Fix alignment and data leak issues

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:max1118 Fix alignment of timestamp and data leak issues

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ina2xx Fix timestamp alignment issue.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc084s021 Fix alignment and data leak issues.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:bmc150-accel: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:proximity:mb1232: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:ltr501 Fix timestamp alignment issue.

Gwendal Grignou <gwendal@chromium.org>
    iio: cros_ec: Set Gyroscope default frequency to 25Hz

Maxim Kochetkov <fido_max@inbox.ru>
    iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set

Angelo Compagnucci <angelo.compagnucci@gmail.com>
    iio: adc: mcp3422: fix locking scope

Leon Romanovsky <leonro@nvidia.com>
    gcov: Disable gcov build with GCC 10

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Do not use IOMMUv2 functionality when SME is active

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Do not force direct mapping when SME is active

Sandeep Raghuraman <sandy.8925@gmail.com>
    drm/amdgpu: Fix bug in reporting voltage for CIK

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc: Change the default of hard_header_len to 0

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: use consistent HDAudio spelling in comments/docs

Rander Wang <rander.wang@intel.com>
    ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled

Rander Wang <rander.wang@intel.com>
    ALSA: hda: hdmi - add Rocketlake support

Jessica Yu <jeyu@kernel.org>
    arm64/module: set trampoline section flags regardless of CONFIG_DYNAMIC_FTRACE

Francisco Jerez <currojerez@riseup.net>
    cpufreq: intel_pstate: Fix intel_pstate_get_hwp_max() for turbo disabled

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Refuse to turn off with HWP enabled

Evgeniy Didin <Evgeniy.Didin@synopsys.com>
    ARC: [plat-hsdk]: Switch ethernet phy-mode to rgmii-id

Dinghao Liu <dinghao.liu@zju.edu.cn>
    HID: elan: Fix memleak in elan_input_configured

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_cisco: Add hard_header_len

Nicholas Miell <nmiell@gmail.com>
    HID: microsoft: Add rumble support for the 8bitdo SN30 Pro+ controller

Nirenjan Krishnan <nirenjan@gmail.com>
    HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for all Saitek X52 devices

Tong Zhang <ztong0001@gmail.com>
    nvme-pci: cancel nvme device request before disabling

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix reset hang if controller died in the middle of a reset

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix timeout handler

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: serialize controller teardown sequences

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix reset hang if controller died in the middle of a reset

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix timeout handler

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: serialize controller teardown sequences

Sagi Grimberg <sagi@grimberg.me>
    nvme: have nvme_wait_freeze_timeout return if it timed out

Sagi Grimberg <sagi@grimberg.me>
    nvme-fabrics: don't check state NVME_CTRL_NEW for request acceptance

Ziye Yang <ziye.yang@intel.com>
    nvmet-tcp: Fix NULL dereference when a connect data comes in h2cdata pdu

Sean Young <sean@mess.org>
    media: gpio-ir-tx: spinlock is not needed to disable interrupts

Vineet Gupta <vgupta@synopsys.com>
    irqchip/eznps: Fix build error for !ARC700 builds

Vineet Gupta <vgupta@synopsys.com>
    ARC: show_regs: fix r12 printing and simplify

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: initialize the shortform attr header padding entry

Amar Singhal <asinghal@codeaurora.org>
    cfg80211: Adjust 6 GHz frequency to channel conversion

Felix Fietkau <nbd@nbd.name>
    mac80211: reduce packet loss event false positives

Shay Bar <shay.bar@celeno.com>
    wireless: fix wrong 160/80+80 MHz setting

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Set network_header before transmitting

Brian Foster <bfoster@redhat.com>
    xfs: fix off-by-one in inode alloc block reservation calculation

Yi Li <yili@winhong.com>
    net: hns3: Fix for geneve tx checksum bug

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    drivers/dma/dma-jz4780: Fix race condition between probe and irq handler

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda/tegra: Program WAKEEN register for Tegra

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda: Fix 2 channel swapping for Tegra

Ye Bin <yebin10@huawei.com>
    scsi: qedf: Fix null ptr reference in qedf_stag_change_work

Dinghao Liu <dinghao.liu@zju.edu.cn>
    firestream: Fix memleak in fs_open

Dinghao Liu <dinghao.liu@zju.edu.cn>
    NFC: st95hf: Fix memleak in st95hf_in_send_cmd

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Added needed_tailroom

Stefano Brivio <sbrivio@redhat.com>
    netfilter: nft_set_rbtree: Detect partial overlap with start endpoint match

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: allow sctp hearbeat after connection re-use

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: Do not override watch and ejtag feature

Hanjun Guo <guohanjun@huawei.com>
    dmaengine: acpi: Put the CSRT table after using it

Vineet Gupta <vgupta@synopsys.com>
    ARC: HSDK: wireup perf irq

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: always allow writing '0' to MSR_KVM_ASYNC_PF_EN

Chenyi Qiang <chenyi.qiang@intel.com>
    KVM: nVMX: Fix the update value of nested load IA32_PERF_GLOBAL_CTRL control

Florian Fainelli <f.fainelli@gmail.com>
    arm64: dts: ns2: Fixed QSPI compatible string

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Fixed QSPI compatible string

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: NSP: Fixed QSPI compatible string

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: bcm: HR2: Fixed QSPI compatible string

Sagi Grimberg <sagi@grimberg.me>
    IB/isert: Fix unaligned immediate-data handling

Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
    RDMA/rtrs-srv: Set .release function for rtrs srv device during device init

Ritesh Harjani <riteshh@linux.ibm.com>
    block: Set same_page to false in __bio_try_merge_page if ret is false

Dan Carpenter <dan.carpenter@oracle.com>
    spi: stm32: fix pm_runtime_get_sync() error checking

Sagi Grimberg <sagi@grimberg.me>
    nvme-fabrics: allow to queue requests for live queues

Tycho Andersen <tycho@tycho.pizza>
    seccomp: don't leak memory when filter install races

Christoph Hellwig <hch@lst.de>
    block: restore a specific error code in bdev_del_partition

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm7xx: Fix timeout calculation

Filipe Manana <fdmanana@suse.com>
    btrfs: fix NULL pointer dereference after failure to create snapshot

Marek Vasut <marex@denx.de>
    spi: stm32: Rate-limit the 'Communication suspended' message

Douglas Anderson <dianders@chromium.org>
    mmc: sdhci-msm: Add retries when all tuning phases are found valid

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci-acpi: Clear amd_sdhci_host on reset

Fugang Duan <fugang.duan@nxp.com>
    ARM: dts: imx6sx: fix the pad QSPI1B_SCLK mux mode for uart3

Alexandru Elisei <alexandru.elisei@arm.com>
    KVM: arm64: Update page shift if stage 2 block mapping not supported

Maxime Ripard <maxime@cerno.tech>
    drm/sun4i: backend: Disable alpha on the lowest plane on the A20

Maxime Ripard <maxime@cerno.tech>
    drm/sun4i: backend: Support alpha property on lowest plane

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Fix DE2 YVU handling

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: fix possible padata_works_lock deadlock

Mike Tipton <mdtipton@codeaurora.org>
    interconnect: qcom: Fix small BW votes being truncated to zero

Josh Poimboeuf <jpoimboe@redhat.com>
    Revert "kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled"

Tom Rix <trix@redhat.com>
    soundwire: fix double free of dangling pointer

Tomas Henzl <thenzl@redhat.com>
    scsi: mpt3sas: Don't call disable_irq from IRQ poll handler

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Don't call disable_irq from process IRQ poll

Kamal Heib <kamalheib1@gmail.com>
    RDMA/core: Fix reported speed and width

Xi Wang <wangxi11@huawei.com>
    RDMA/core: Fix unsafe linked list traversal after failing to allocate CQ

Gerd Hoffmann <kraxel@redhat.com>
    drm/virtio: fix unblank

Luo Jiaxing <luojiaxing@huawei.com>
    scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA

Angelo Compagnucci <angelo.compagnucci@gmail.com>
    iio: adc: mcp3422: fix locking on error path

René Rebe <rene@exactcode.com>
    scsi: qla2xxx: Fix regression on sparc64

Ondrej Jirman <megous@megous.com>
    drm/sun4i: Fix dsi dcs long write function

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: dts: imx8mq: Fix TMU interrupt property

Yu Kuai <yukuai3@huawei.com>
    drm/sun4i: add missing put_device() call in sun8i_r40_tcon_tv_set_mux()

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Remove the qp from list only if the qp destroy succeeds

Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
    RDMA/bnxt_re: Fix driver crash on unaligned PSN entry address

Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
    RDMA/bnxt_re: Static NQ depth allocation

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the qp table indexing

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Do not report transparent vlan from QP1

Kamal Heib <kamalheib1@gmail.com>
    RDMA/rxe: Fix panic when calling kmem_cache_create()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/rxe: Drop pointless checks in rxe_init_ports

Dinghao Liu <dinghao.liu@zju.edu.cn>
    RDMA/rxe: Fix memleak in rxe_mem_init_user

Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
    RDMA/rtrs-srv: Replace device_register with device_initialize and device_add

Chris Healy <cphealy@gmail.com>
    ARM: dts: imx7d-zii-rmu2: fix rgmii phy-mode for ksz9031 phy

Rob Herring <robh@kernel.org>
    arm64: dts: imx: Add missing imx8mm-beacon-kit.dtb to build

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx7ulp: Correct gpio ranges

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    ARM: dts: ls1021a: fix QuadSPI-memory reg range

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/timers: Turn off timeout setting

David Shah <dave@ds0.me>
    ARM: dts: omap5: Fix DSI base address and clocks

Dinh Nguyen <dinguyen@kernel.org>
    ARM: dts: socfpga: fix register entry for timer3 on Arria10

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: remove superfluous lock in regulator_resolve_coupling()

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: push allocation in regulator_ena_gpio_request() out of lock

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-som-lv-baseboard: Fix missing video

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-som-lv-baseboard: Fix broken audio

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-torpedo-baseboard: Fix broken audio

Jing Xiangfeng <jingxiangfeng@huawei.com>
    ARM: OMAP2+: Fix an IS_ERR() vs NULL check in _get_pwrdm()


-------------

Diffstat:

 Documentation/sound/designs/timestamping.rst       |   2 +-
 Makefile                                           |   8 +-
 arch/arc/boot/dts/hsdk.dts                         |   6 +-
 arch/arc/kernel/troubleshoot.c                     |  77 ++---
 arch/arc/plat-eznps/include/plat/ctop.h            |   1 -
 arch/arm/boot/dts/bcm-hr2.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |   2 +-
 arch/arm/boot/dts/imx6sx-pinfunc.h                 |   2 +-
 arch/arm/boot/dts/imx7d-zii-rmu2.dts               |   2 +-
 arch/arm/boot/dts/imx7ulp.dtsi                     |   8 +-
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi    |  29 +-
 arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi   |   2 +
 arch/arm/boot/dts/ls1021a.dtsi                     |   2 +-
 arch/arm/boot/dts/omap5.dtsi                       |  20 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi             |   2 +-
 arch/arm/boot/dts/vfxxx.dtsi                       |   2 +-
 arch/arm/mach-omap2/omap-iommu.c                   |   2 +-
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi   |   2 +-
 arch/arm64/boot/dts/freescale/Makefile             |   1 +
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   2 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   2 +-
 arch/arm64/kernel/module-plts.c                    |   3 +-
 arch/arm64/kvm/mmu.c                               |   8 +-
 .../asm/mach-loongson64/cpu-feature-overrides.h    |   2 -
 arch/powerpc/configs/pasemi_defconfig              |   1 -
 arch/powerpc/configs/ppc6xx_defconfig              |   1 -
 arch/x86/configs/i386_defconfig                    |   1 -
 arch/x86/configs/x86_64_defconfig                  |   1 -
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   1 +
 arch/x86/kvm/x86.c                                 |   2 +-
 block/bio.c                                        |   4 +-
 block/partitions/core.c                            |   2 +-
 drivers/atm/firestream.c                           |   1 +
 drivers/base/firmware_loader/firmware.h            |   2 +
 drivers/base/firmware_loader/main.c                |  17 +-
 drivers/block/rbd.c                                |  12 +
 drivers/cpufreq/intel_pstate.c                     |  14 +-
 drivers/dma/acpi-dma.c                             |   4 +-
 drivers/dma/dma-jz4780.c                           |  38 +--
 drivers/firmware/efi/embedded-firmware.c           |  10 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   3 +-
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c              |   5 +
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  10 +
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c              |  10 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  14 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.h              |   1 +
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c          |  25 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  13 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |  27 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   2 +-
 drivers/gpu/drm/msm/msm_gpu.h                      |  11 +
 drivers/gpu/drm/msm/msm_ringbuffer.c               |   3 +-
 drivers/gpu/drm/sun4i/sun4i_backend.c              |   4 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |   8 +-
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c             |   4 +-
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c             |   2 +-
 drivers/gpu/drm/tve200/tve200_display.c            |  22 +-
 drivers/gpu/drm/virtio/virtgpu_display.c           |  11 +
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   1 +
 drivers/gpu/drm/virtio/virtgpu_plane.c             |   4 +-
 drivers/hid/hid-elan.c                             |   2 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-microsoft.c                        |   2 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/i2c/busses/i2c-npcm7xx.c                   |   8 +-
 drivers/iio/accel/bmc150-accel-core.c              |  15 +-
 drivers/iio/accel/kxsd9.c                          |  16 +-
 drivers/iio/accel/mma7455_core.c                   |  16 +-
 drivers/iio/accel/mma8452.c                        |  11 +-
 drivers/iio/adc/ina2xx-adc.c                       |  11 +-
 drivers/iio/adc/max1118.c                          |  10 +-
 drivers/iio/adc/mcp3422.c                          |  16 +-
 drivers/iio/adc/ti-adc081c.c                       |  11 +-
 drivers/iio/adc/ti-adc084s021.c                    |  10 +-
 drivers/iio/adc/ti-ads1015.c                       |  10 +
 drivers/iio/chemical/ccs811.c                      |  13 +-
 .../common/cros_ec_sensors/cros_ec_sensors_core.c  |   5 +-
 drivers/iio/light/ltr501.c                         |  15 +-
 drivers/iio/light/max44000.c                       |  12 +-
 drivers/iio/magnetometer/ak8975.c                  |  16 +-
 drivers/iio/proximity/mb1232.c                     |  17 +-
 drivers/infiniband/core/cq.c                       |   4 +-
 drivers/infiniband/core/verbs.c                    |   2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  43 ++-
 drivers/infiniband/hw/bnxt_re/main.c               |   3 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  26 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |  10 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   5 +
 drivers/infiniband/hw/mlx4/main.c                  |   3 +-
 drivers/infiniband/sw/rxe/rxe.c                    |   7 +-
 drivers/infiniband/sw/rxe/rxe.h                    |   2 +
 drivers/infiniband/sw/rxe/rxe_mr.c                 |   1 +
 drivers/infiniband/sw/rxe/rxe_sysfs.c              |   5 +
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  93 +++---
 drivers/infiniband/ulp/isert/ib_isert.h            |  41 ++-
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c       |  16 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   9 +
 drivers/interconnect/qcom/bcm-voter.c              |  27 +-
 drivers/iommu/amd/iommu.c                          |   7 +-
 drivers/iommu/amd/iommu_v2.c                       |   7 +
 drivers/media/rc/gpio-ir-tx.c                      |  16 +-
 drivers/misc/eeprom/at24.c                         |  11 +-
 drivers/mmc/core/sdio_ops.c                        |  39 +--
 drivers/mmc/host/sdhci-acpi.c                      |  31 +-
 drivers/mmc/host/sdhci-msm.c                       |  18 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |  10 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   6 +-
 drivers/net/wan/hdlc.c                             |   2 +-
 drivers/net/wan/hdlc_cisco.c                       |   1 +
 drivers/net/wan/lapbether.c                        |   3 +
 drivers/nfc/st95hf/core.c                          |   2 +-
 drivers/nvme/host/core.c                           |   8 +-
 drivers/nvme/host/fabrics.c                        |  13 +-
 drivers/nvme/host/nvme.h                           |   3 +-
 drivers/nvme/host/pci.c                            |   4 +-
 drivers/nvme/host/rdma.c                           |  68 +++--
 drivers/nvme/host/tcp.c                            |  80 +++--
 drivers/nvme/target/tcp.c                          |  10 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |  16 +-
 drivers/phy/qualcomm/phy-qcom-qmp.h                |   2 +
 drivers/regulator/core.c                           | 155 +++++-----
 drivers/scsi/libsas/sas_ata.c                      |   5 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   1 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +-
 drivers/scsi/qedf/qedf_main.c                      |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   2 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   6 +-
 drivers/soundwire/stream.c                         |   8 +-
 drivers/spi/spi-stm32.c                            |   8 +-
 drivers/staging/greybus/audio_topology.c           |  29 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |   5 -
 drivers/staging/wlan-ng/prism2usb.c                |  19 +-
 drivers/target/iscsi/iscsi_target.c                |  17 +-
 drivers/target/iscsi/iscsi_target_login.c          |   6 +-
 drivers/target/iscsi/iscsi_target_login.h          |   3 +-
 drivers/target/iscsi/iscsi_target_nego.c           |   3 +-
 drivers/thunderbolt/switch.c                       |   1 +
 drivers/thunderbolt/tb.h                           |   2 +-
 drivers/usb/core/message.c                         |  91 +++---
 drivers/usb/core/sysfs.c                           |   5 +
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |  15 +-
 drivers/usb/serial/ftdi_sio.c                      |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   1 +
 drivers/usb/serial/option.c                        |  22 +-
 drivers/usb/typec/mux/intel_pmc_mux.c              |  14 +-
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |   4 +
 drivers/video/console/Kconfig                      |  46 ---
 drivers/video/console/vgacon.c                     | 221 +-------------
 drivers/video/fbdev/core/bitblit.c                 |  11 +-
 drivers/video/fbdev/core/fbcon.c                   | 334 +--------------------
 drivers/video/fbdev/core/fbcon.h                   |   2 +-
 drivers/video/fbdev/core/fbcon_ccw.c               |  11 +-
 drivers/video/fbdev/core/fbcon_cw.c                |  11 +-
 drivers/video/fbdev/core/fbcon_ud.c                |  11 +-
 drivers/video/fbdev/core/tileblit.c                |   2 +-
 drivers/video/fbdev/vga16fb.c                      |   2 +-
 fs/btrfs/disk-io.c                                 |   2 +
 fs/btrfs/extent-tree.c                             |  19 +-
 fs/btrfs/ioctl.c                                   |   3 +-
 fs/btrfs/print-tree.c                              |  12 +-
 fs/btrfs/transaction.c                             |   1 +
 fs/btrfs/volumes.c                                 |  10 +
 fs/debugfs/file.c                                  |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   4 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |   4 +-
 fs/xfs/libxfs/xfs_trans_space.h                    |   2 +-
 include/linux/efi_embedded_fw.h                    |   6 +-
 include/linux/netfilter/nf_conntrack_sctp.h        |   2 +
 include/soc/nps/common.h                           |   6 +
 kernel/gcov/Kconfig                                |   1 +
 kernel/padata.c                                    |   5 +-
 kernel/seccomp.c                                   |  13 +-
 lib/kobject.c                                      |   6 +-
 lib/test_firmware.c                                |   9 +
 net/mac80211/sta_info.h                            |   4 +-
 net/mac80211/status.c                              |  31 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |  39 ++-
 net/netfilter/nft_set_rbtree.c                     |  34 ++-
 net/wireless/chan.c                                |  15 +-
 net/wireless/util.c                                |   8 +-
 sound/hda/hdac_device.c                            |   2 +
 sound/hda/intel-dsp-config.c                       |  10 +-
 sound/pci/hda/hda_tegra.c                          |   7 +
 sound/pci/hda/patch_hdmi.c                         |   6 +
 sound/x86/Kconfig                                  |   2 +-
 tools/testing/selftests/timers/Makefile            |   1 +
 tools/testing/selftests/timers/settings            |   1 +
 virt/kvm/kvm_main.c                                |  21 +-
 193 files changed, 1322 insertions(+), 1411 deletions(-)


