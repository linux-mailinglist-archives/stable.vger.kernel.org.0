Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8009937C0C1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhELOyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231405AbhELOx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 239CB6141C;
        Wed, 12 May 2021 14:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831167;
        bh=YnkgBnTBl+c48Ka1ek51RMEv/kXpg8vanyNc9FC9kAU=;
        h=From:To:Cc:Subject:Date:From;
        b=h9pj9FAa4rrc7t4lHNXR5uhvL+M0BoW+9SWuWix8WUTJH/jqpo8NB7XwA4LDIazvk
         Wjb5U2BjovMCayChffMiuz05JdquKbqAVEGQem5bTC72jUmOIoLpB4xqRYg9RW93rK
         T9L6sQyKoj3K3I/9P0Czn9K6roypy2ffIOqZTId4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/244] 5.4.119-rc1 review
Date:   Wed, 12 May 2021 16:46:11 +0200
Message-Id: <20210512144743.039977287@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.119-rc1
X-KernelTest-Deadline: 2021-05-14T14:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.119 release.
There are 244 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.119-rc1

Quentin Perret <qperret@google.com>
    Revert "fdt: Properly handle "no-map" field in the memory region"

Quentin Perret <qperret@google.com>
    Revert "of/fdt: Make sure no-map does not remove already reserved regions"

Xin Long <lucien.xin@gmail.com>
    sctp: delay auto_asconf init until binding the first addr

Xin Long <lucien.xin@gmail.com>
    Revert "net/sctp: fix race condition in sctp_destroy_sock"

Arnd Bergmann <arnd@arndb.de>
    smp: Fix smp_call_function_single_async prototype

Jonathon Reinhart <jonathon.reinhart@gmail.com>
    net: Only allow init netns to set default tcp cong to a restricted algo

Jane Chu <jane.chu@oracle.com>
    mm/memory-failure: unnecessary amount of unmapping

Wang Wensheng <wangwensheng4@huawei.com>
    mm/sparse: add the missing sparse_buffer_fini() in error branch

Dan Carpenter <dan.carpenter@oracle.com>
    kfifo: fix ternary sign extension bugs

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:nfc:digital: Fix a double free in digital_tg_recv_dep_req

Linus Lüssing <linus.luessing@c0d3.blue>
    net: bridge: mcast: fix broken length + header check for MRDv6 Adv.

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    RDMA/bnxt_re: Fix a double free in bnxt_qplib_alloc_res

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    RDMA/siw: Fix a use after free in siw_alloc_mr

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix RX consumer index logic in the error path.

Petr Machata <petrm@nvidia.com>
    selftests: net: mirror_gre_vlan_bridge_1q: Make an FDB entry static

Phillip Potter <phil@philpotter.co.uk>
    net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Dan Carpenter <dan.carpenter@oracle.com>
    bnxt_en: fix ternary sign extension bug in bnxt_show_temp()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/52xx: Fix an invalid ASM expression ('addi' used instead of 'add')

Shuah Khan <skhan@linuxfoundation.org>
    ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock

Toke Høiland-Jørgensen <toke@redhat.com>
    ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Martin Schiller <ms@dev.tdt.de>
    net: phy: intel-xway: enable integrated led functions

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: renesas: ravb: Fix a stuck issue when a lot of frames are received

Colin Ian King <colin.king@canonical.com>
    net: davinci_emac: Fix incorrect masking of tx and rx error channel

Colin Ian King <colin.king@canonical.com>
    ALSA: usb: midi: don't return -ENOMEM when usb_urb_ep_type_check fails

Sindhu Devale <sindhu.devale@intel.com>
    RDMA/i40iw: Fix error unwinding when i40iw_hmc_sd_one fails

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/cxgb4: add missing qpid increment

Alexander Lobakin <alobakin@pm.me>
    gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check

Stefano Garzarella <sgarzare@redhat.com>
    vsock/vmci: log once the failed queue pair allocation

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    mwl8k: Fix a double Free in mwl8k_probe_hw

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: sh7760: fix IRQ error path

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: 8821ae: upgrade PHY and RF parameters

Tyrel Datwyler <tyreld@linux.ibm.com>
    powerpc/pseries: extract host bridge from pci_bus prior to bus removal

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: pci-legacy: stop using of_pci_range_to_resource

Vitaly Chikunov <vt@altlinux.org>
    perf beauty: Fix fsconfig generator

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/gvt: Fix error code in intel_gvt_init_device()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: correct reset polarity

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Fix xmon command "dxi"

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: sh7760: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: jz4780: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: emev2: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: cadence: add IRQ check

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: sprd: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: omap: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: imx-lpi2c: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: img-scb: fix reference leak when pm_runtime_get_sync fails

Wang Wensheng <wangwensheng4@huawei.com>
    RDMA/srpt: Fix error return code in srpt_cm_req_recv()

Colin Ian King <colin.king@canonical.com>
    net: thunderx: Fix unintentional sign extension issue

Colin Ian King <colin.king@canonical.com>
    cxgb4: Fix unintentional sign extension issues

Wang Wensheng <wangwensheng4@huawei.com>
    IB/hfi1: Fix error return code in parse_platform_config()

Wang Wensheng <wangwensheng4@huawei.com>
    RDMA/qedr: Fix error return code in qedr_iw_connect()

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV P9: Restore host CTRL SPR after guest exit

Colin Ian King <colin.king@canonical.com>
    mt7601u: fix always true expression

Johannes Berg <johannes.berg@intel.com>
    mac80211: bail out if cipher schemes are invalid

Randy Dunlap <rdunlap@infradead.org>
    powerpc: iommu: fix build when neither PCI or IBMVIO is set

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix PMU constraint check for EBB events

Jordan Niethe <jniethe5@gmail.com>
    powerpc/64s: Fix pte update for kernel memory on radix

Colin Ian King <colin.king@canonical.com>
    liquidio: Fix unintented sign extension of a left shift of a u16

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ASoC: simple-card: fix possible uninitialized single_cpu local variable

Alexandru Elisei <alexandru.elisei@arm.com>
    KVM: arm64: Initialize VCPU mdcr_el2 before loading it

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls

Álvaro Fernández Rojas <noltari@gmail.com>
    mips: bmips: fix syscon-reboot nodes

Salil Mehta <salil.mehta@huawei.com>
    net: hns3: Limiting the scope of vector_ring_chain variable

Dan Carpenter <dan.carpenter@oracle.com>
    nfc: pn533: prevent potential memory corruption

Andrew Scull <ascull@google.com>
    bug: Remove redundant condition check in report_bug

Jia Zhou <zhou.jia2@zte.com.cn>
    ALSA: core: remove redundant spin_lock pair in snd_card_disconnect

Chen Huang <chenhuang5@huawei.com>
    powerpc: Fix HAVE_HARDLOCKUP_DETECTOR_ARCH build configuration

Eric Dumazet <edumazet@google.com>
    inet: use bigger hash table for IP ID generation

Nathan Chancellor <nathan@kernel.org>
    powerpc/prom: Mark identical_pvr_fixup as __init

Nathan Chancellor <nathan@kernel.org>
    powerpc/fadump: Mark fadump_calculate_reserve_size as __init

Xie He <xie.he.0141@gmail.com>
    net: lapbether: Prevent racing when checking whether the netif is running

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars

Maxim Mikityanskiy <maxtram95@gmail.com>
    HID: plantronics: Workaround for double volume key presses

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    drivers/block/null_blk/main: Fix a double free in null_init.

Waiman Long <longman@redhat.com>
    sched/debug: Fix cgroup_path[] serialization

Nathan Chancellor <nathan@kernel.org>
    x86/events/amd/iommu: Fix sysfs type mismatch

Dan Carpenter <dan.carpenter@oracle.com>
    HSI: core: fix resource leaks in hsi_add_client_from_dt()

Niklas Cassel <niklas.cassel@wdc.com>
    nvme-pci: don't simple map sgl when sgls are disabled

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    mfd: stm32-timers: Avoid clearing auto reload register

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Fix invalid state machine BUG_ON()

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: sni_53c710: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: sun3x_esp: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: jazz_esp: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: hisi_sas: Fix IRQ checks

Colin Ian King <colin.king@canonical.com>
    clk: uniphier: Fix potential infinite loop

Chen Hui <clare.chenhui@huawei.com>
    clk: qcom: a53-pll: Add missing MODULE_DEVICE_TABLE

Quanyang Wang <quanyang.wang@windriver.com>
    clk: zynqmp: move zynqmp_pll_set_mode out of round_rate callback

Jason Gunthorpe <jgg@nvidia.com>
    vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ctrls.c: fix race condition in hdl->requests list

Hannes Reinecke <hare@suse.de>
    nvme: retrigger ANA log update if group descriptor isn't found

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix incorrect locking in state_change sk callback

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: block BH in sk state_change sk callback

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    ata: libahci_platform: fix IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sata_mv: add IRQ checks

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_ipx4xx_cf: fix IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_arasan_cf: fix IRQ check

Masami Hiramatsu <mhiramat@kernel.org>
    x86/kprobes: Fix to check non boostable prefixes correctly

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: fix build error with AMD_IOMMU_V2=m

Colin Ian King <colin.king@canonical.com>
    media: m88rs6000t: avoid potential out-of-bounds reads on arrays

Jia-Ju Bai <baijiaju1990@gmail.com>
    media: platform: sunxi: sun6i-csi: fix error return code of sun6i_video_start_streaming()

Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
    media: aspeed: fix clock handling logic

Yang Yingliang <yangyingliang@huawei.com>
    media: omap4iss: return error code when omap4iss_get() failed

Colin Ian King <colin.king@canonical.com>
    media: vivid: fix assignment of dev->fbuf_out_flags

Dan Carpenter <dan.carpenter@oracle.com>
    soc: aspeed: fix a ternary sign expansion bug

Paul Durrant <pdurrant@amazon.com>
    xen-blkback: fix compatibility bug with single page rings

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    ttyprintk: Add TTY hangup callback.

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix hibernation between host and device modes.

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix host mode hibernation exit with remote wakeup flow.

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Increase wait time for VMbus unload

Ingo Molnar <mingo@kernel.org>
    x86/platform/uv: Fix !KEXEC build failure

Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
    platform/x86: pmc_atom: Match all Beckhoff Automation baytrail boards with critclk_systems DMI table

Ye Bin <yebin10@huawei.com>
    usbip: vudc: fix missing unlock on error in usbip_sockfd_store()

Dan Carpenter <dan.carpenter@oracle.com>
    node: fix device cleanups in error handling code

He Ying <heying24@huawei.com>
    firmware: qcom-scm: Fix QCOM_SCM configuration

Johan Hovold <johan@kernel.org>
    serial: core: return early on unsupported ioctls

Johan Hovold <johan@kernel.org>
    tty: fix return value for unsupported ioctls

Johan Hovold <johan@kernel.org>
    tty: actually undefine superseded ASYNC flags

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix TIOCGSERIAL implementation

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix unprivileged TIOCCSERIAL

Colin Ian King <colin.king@canonical.com>
    usb: gadget: r8a66597: Add missing null check on return from platform_get_resource

Wang Li <wangli74@huawei.com>
    spi: fsl-lpspi: Fix PM reference leak in lpspi_prepare_xfer_hardware()

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Fix determining base CPU frequency

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Fix driver cleanup when registration failed

Pali Rohár <pali@kernel.org>
    clk: mvebu: armada-37xx-periph: Fix workaround for switching from L1 to L0

Pali Rohár <pali@kernel.org>
    clk: mvebu: armada-37xx-periph: Fix switching CPU freq from 250 Mhz to 1 GHz

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Fix the AVS value for load L1

Marek Behún <kabel@kernel.org>
    clk: mvebu: armada-37xx-periph: remove .set_parent method for CPU PM clock

Marek Behún <kabel@kernel.org>
    cpufreq: armada-37xx: Fix setting TBG parent for load levels

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    crypto: qat - Fix a double free in adf_create_ring

Nathan Chancellor <nathan@kernel.org>
    ACPI: CPPC: Replace cppc_attr with kobj_attribute

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: mdt_loader: Detect truncated read of segments

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: mdt_loader: Validate that p_filesz < p_memsz

William A. Kennington III <wak@google.com>
    spi: Fix use-after-free with devm_spi_alloc_*

Dong Aisheng <aisheng.dong@nxp.com>
    PM / devfreq: Use more accurate returned new_freq as resume_freq

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix unprivileged TIOCCSERIAL

Colin Ian King <colin.king@canonical.com>
    staging: rtl8192u: Fix potential infinite loop

Arnd Bergmann <arnd@arndb.de>
    irqchip/gic-v3: Fix OF_BAD_ADDR error handling

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    mtd: rawnand: gpmi: Fix a double free in gpmi_nand_init

Finn Thain <fthain@telegraphics.com.au>
    m68k: mvme147,mvme16x: Don't wipe PCC timer config bits

Rander Wang <rander.wang@intel.com>
    soundwire: stream: fix memory leak in stream config error path

gexueyuan <gexueyuan@gmail.com>
    memory: pl353: fix mask of ECC page_size config register

Yang Yingliang <yangyingliang@huawei.com>
    USB: gadget: udc: fix wrong pointer passed to IS_ERR() and PTR_ERR()

Tao Ren <rentao.bupt@gmail.com>
    usb: gadget: aspeed: fix dma map failure

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix error path in adf_isr_resource_alloc()

Geert Uytterhoeven <geert+renesas@glider.be>
    phy: marvell: ARMADA375_USBCLUSTER_PHY should not default to y, unconditionally

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: bus: Fix device found flag correctly

Pan Bian <bianpan2016@163.com>
    bus: qcom: Put child node before return

Michael Walle <michael@walle.cc>
    mtd: require write permissions for locking and badblock ioctls

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Complete OUT requests on short packets

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Don't DMA more than the buffer can take

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Mask GRP2 interrupts we don't handle

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Remove a dubious condition leading to fotg210_done

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Fix EP0 IN requests bigger than two packets

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Fix DMA on EP0 for length > max packet size

Tong Zhang <ztong0001@gmail.com>
    crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init

Tong Zhang <ztong0001@gmail.com>
    crypto: qat - don't release uninitialized resources

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Check for DMA mapping error

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Check if driver is present before calling ->setup()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()

Otavio Pontes <otavio.pontes@intel.com>
    x86/microcode: Check for offline CPUs before requesting new microcode

Vladimir Barinov <vladimir.barinov@cogentembedded.com>
    arm64: dts: renesas: r8a77980: Fix vin4-7 endpoint binding

Antonio Borneo <antonio.borneo@foss.st.com>
    spi: stm32: drop devres version of spi_register_master

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: sm8150: fix number of pins in 'gpio-ranges'

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    mtd: rawnand: qcom: Return actual error code instead of -ENODEV

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    mtd: Handle possible -EPROBE_DEFER from parse_mtd_partitions()

Álvaro Fernández Rojas <noltari@gmail.com>
    mtd: rawnand: brcmnand: fix OOB R/W with Hamming ECC

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: rawnand: fsmc: Fix error code in fsmc_nand_probe()

Meng Li <Meng.Li@windriver.com>
    regmap: set debugfs_name to NULL after it is freed

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpci: Check ROLE_CONTROL while interpreting CC_STATUS

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix tx_empty condition

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix incorrect characters on console

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Snow

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Midas family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct MUIC interrupt trigger level on Midas family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family

Colin Ian King <colin.king@canonical.com>
    memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Revert d3cb25a12138 completely

Dan Carpenter <dan.carpenter@oracle.com>
    ovl: fix missing revert_creds() on error path

Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
    Revert "i3c master: fix missing destroy_workqueue() on error in i3c_master_register"

Sean Christopherson <seanjc@google.com>
    KVM: Stop looking for coalesced MMIO zones if the bus is destroyed

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check in !64-bit

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: split kvm_s390_real_to_abs

David Hildenbrand <david@redhat.com>
    s390: fix detection of vector enhancements facility 1 vs. vector packed decimal facility

Heiko Carstens <hca@linux.ibm.com>
    KVM: s390: fix guarded storage control register handling

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: split kvm_s390_logical_to_effective

Sami Loone <sami@loone.fi>
    ALSA: hda/realtek: ALC285 Thinkpad jack pin quirk is unreachable

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Remove redundant entry for ALC861 Haier/Uniwill devices

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC662 quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order remaining ALC269 quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Lenovo quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Sony quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 ASUS quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Dell quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Acer quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 HP quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Clevo quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Sony quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Reject non-zero src_y and src_x for video planes

Colin Ian King <colin.king@canonical.com>
    drm/radeon: fix copy of uninitialized variable back to userspace

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Don't try to map pages that are already mapped

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Clear MMU irqs before handling the fault

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: Fix array overrun in rtw_get_tx_power_params()

Johannes Berg <johannes.berg@intel.com>
    cfg80211: scan: drop entry from hidden_list on overflow

Dan Carpenter <dan.carpenter@oracle.com>
    ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Reinstate platform `__div64_32' handler

Jan Glauber <jglauber@digitalocean.com>
    md: Fix missing unused status line of /proc/mdstat

Zhao Heming <heming.zhao@suse.com>
    md: md_open returns -EBUSY when entering racing area

Christoph Hellwig <hch@lst.de>
    md: factor out a mddev_find_locked helper from mddev_find

Christoph Hellwig <hch@lst.de>
    md: split mddev_find

Heming Zhao <heming.zhao@suse.com>
    md-cluster: fix use-after-free issue when removing rdev

Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
    md/bitmap: wait for external bitmap writes to complete during tear down

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    misc: vmw_vmci: explicitly initialize vmci_datagram payload

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct

Hans de Goede <hdegoede@redhat.com>
    misc: lis3lv02d: Fix false-positive WARN on various HP models

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:adis16201: Fix wrong axis assignment that prevents loading

Arun Easi <aeasi@marvell.com>
    PCI: Allow VPD access for QLogic ISP2722

Maciej W. Rozycki <macro@orcam.me.uk>
    FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: pci-rt2880: fix slot 0 configuration

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: pci-mt7620: fix PLL lock check

Lukasz Majczak <lma@semihalf.com>
    ASoC: Intel: kbl_da7219_max98927: Fix kabylake_ssp_fixup function

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: samsung: tm2_wm5110: check of of_parse return value

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: improve bandwidth scheduling with TT

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: remove or operator for setting schedule parameters

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: update power supply once partner accepts

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Address incorrect values of tcpm psy for fixed supply

Johan Hovold <johan@kernel.org>
    staging: fwserial: fix TIOCSSERIAL permission check

Johan Hovold <johan@kernel.org>
    tty: moxa: fix TIOCSSERIAL permission check

Johan Hovold <johan@kernel.org>
    staging: fwserial: fix TIOCSSERIAL jiffies conversions

Johan Hovold <johan@kernel.org>
    USB: serial: ti_usb_3410_5052: fix TIOCSSERIAL permission check

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix TIOCSSERIAL jiffies conversions

Johan Hovold <johan@kernel.org>
    USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions

Johan Hovold <johan@kernel.org>
    tty: amiserial: fix TIOCSSERIAL permission check

Johan Hovold <johan@kernel.org>
    tty: moxa: fix TIOCSSERIAL jiffies conversions

Johan Hovold <johan@kernel.org>
    Revert "USB: cdc-acm: fix rounding error in TIOCSSERIAL"

Or Cohen <orcohen@paloaltonetworks.com>
    net/nfc: fix use-after-free llcp_sock_bind/connect

Lin Ma <linma@zju.edu.cn>
    bluetooth: eliminate the potential race condition when removing the HCI controller

Taehee Yoo <ap420073@gmail.com>
    hsr: use netdev_err() instead of WARN_ONCE()

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: verify AMP hci_chan before amp_destroy


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/exynos4412-midas.dtsi            |   6 +-
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |   2 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   2 +-
 arch/arm/boot/dts/exynos5250-snow-common.dtsi      |   2 +-
 arch/arm/boot/dts/uniphier-pxs2.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   2 +-
 arch/arm64/boot/dts/renesas/r8a77980.dtsi          |  16 +-
 arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi   |   2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi   |   4 +-
 arch/arm64/include/asm/kvm_host.h                  |   1 +
 arch/arm64/kvm/debug.c                             |  88 ++--
 arch/m68k/include/asm/mvme147hw.h                  |   3 +
 arch/m68k/mvme147/config.c                         |  14 +-
 arch/m68k/mvme16x/config.c                         |  14 +-
 arch/mips/boot/dts/brcm/bcm3368.dtsi               |   2 +-
 arch/mips/boot/dts/brcm/bcm63268.dtsi              |   2 +-
 arch/mips/boot/dts/brcm/bcm6358.dtsi               |   2 +-
 arch/mips/boot/dts/brcm/bcm6362.dtsi               |   2 +-
 arch/mips/boot/dts/brcm/bcm6368.dtsi               |   2 +-
 arch/mips/include/asm/div64.h                      |  57 ++-
 arch/mips/pci/pci-legacy.c                         |   9 +-
 arch/mips/pci/pci-mt7620.c                         |   5 +-
 arch/mips/pci/pci-rt2880.c                         |  37 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/Kconfig.debug                         |   1 +
 arch/powerpc/include/asm/book3s/64/radix.h         |   6 +-
 arch/powerpc/kernel/fadump.c                       |   2 +-
 arch/powerpc/kernel/prom.c                         |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |   3 +
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   4 +-
 arch/powerpc/perf/isa207-common.c                  |   4 +-
 arch/powerpc/platforms/52xx/lite5200_sleep.S       |   2 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |   4 +-
 arch/powerpc/sysdev/xive/common.c                  |  14 +-
 arch/s390/kernel/setup.c                           |   4 +-
 arch/s390/kvm/gaccess.h                            |  54 ++-
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/events/amd/iommu.c                        |   6 +-
 arch/x86/kernel/cpu/microcode/core.c               |   8 +-
 arch/x86/kernel/kprobes/core.c                     |  17 +-
 arch/x86/kvm/vmx/nested.c                          |   2 +-
 drivers/acpi/cppc_acpi.c                           |  14 +-
 drivers/ata/libahci_platform.c                     |   4 +-
 drivers/ata/pata_arasan_cf.c                       |  15 +-
 drivers/ata/pata_ixp4xx_cf.c                       |   6 +-
 drivers/ata/sata_mv.c                              |   4 +
 drivers/base/node.c                                |  26 +-
 drivers/base/regmap/regmap-debugfs.c               |   1 +
 drivers/block/null_blk_zoned.c                     |   1 +
 drivers/block/xen-blkback/common.h                 |   1 +
 drivers/block/xen-blkback/xenbus.c                 |  38 +-
 drivers/bus/qcom-ebi2.c                            |   4 +-
 drivers/char/ttyprintk.c                           |  11 +
 drivers/clk/clk-ast2600.c                          |   4 +-
 drivers/clk/mvebu/armada-37xx-periph.c             |  83 ++--
 drivers/clk/qcom/a53-pll.c                         |   1 +
 drivers/clk/uniphier/clk-uniphier-mux.c            |   4 +-
 drivers/clk/zynqmp/pll.c                           |  12 +-
 drivers/cpufreq/armada-37xx-cpufreq.c              |  76 +++-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |   4 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |   4 +-
 drivers/crypto/qat/qat_common/adf_isr.c            |  29 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |   1 +
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |  17 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |   4 +-
 drivers/devfreq/devfreq.c                          |   2 +-
 drivers/firmware/Kconfig                           |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.c             |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.h             |   9 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  17 +
 drivers/gpu/drm/i915/gvt/gvt.c                     |   8 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |  13 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   1 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-plantronics.c                      |  60 ++-
 drivers/hsi/hsi_core.c                             |   3 +-
 drivers/hv/channel_mgmt.c                          |  30 +-
 drivers/i2c/busses/i2c-cadence.c                   |   5 +-
 drivers/i2c/busses/i2c-emev2.c                     |   5 +-
 drivers/i2c/busses/i2c-img-scb.c                   |   4 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   2 +-
 drivers/i2c/busses/i2c-jz4780.c                    |   5 +-
 drivers/i2c/busses/i2c-omap.c                      |   8 +-
 drivers/i2c/busses/i2c-sh7760.c                    |   5 +-
 drivers/i2c/busses/i2c-sprd.c                      |   4 +-
 drivers/i3c/master.c                               |   5 +-
 drivers/iio/accel/adis16201.c                      |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   1 +
 drivers/infiniband/hw/cxgb4/resource.c             |   2 +-
 drivers/infiniband/hw/hfi1/firmware.c              |   1 +
 drivers/infiniband/hw/i40iw/i40iw_pble.c           |   6 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |   4 +-
 drivers/infiniband/sw/siw/siw_mem.c                |   4 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   1 +
 drivers/irqchip/irq-gic-v3-mbi.c                   |   2 +-
 drivers/md/md-bitmap.c                             |   2 +
 drivers/md/md.c                                    |  73 +--
 drivers/media/platform/aspeed-video.c              |   9 +-
 .../media/platform/sunxi/sun6i-csi/sun6i_video.c   |   4 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |   2 +-
 drivers/media/tuners/m88rs6000t.c                  |   6 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  17 +-
 drivers/memory/omap-gpmc.c                         |   7 +-
 drivers/memory/pl353-smc.c                         |   2 +-
 drivers/mfd/stm32-timers.c                         |   7 +-
 drivers/misc/lis3lv02d/lis3lv02d.c                 |  21 +-
 drivers/misc/vmw_vmci/vmci_doorbell.c              |   2 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |   2 +-
 drivers/mtd/mtdchar.c                              |   8 +-
 drivers/mtd/mtdcore.c                              |   3 +
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   6 +
 drivers/mtd/nand/raw/fsmc_nand.c                   |   2 +
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   2 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  10 +-
 .../net/ethernet/cavium/liquidio/cn23xx_pf_regs.h  |   2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  22 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c      |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  35 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   4 +-
 drivers/net/fddi/defxx.c                           |  47 +-
 drivers/net/geneve.c                               |   4 +-
 drivers/net/phy/intel-xway.c                       |  21 +
 drivers/net/wan/lapbether.c                        |  32 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   3 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c     |   6 +-
 drivers/net/wireless/marvell/mwl8k.c               |   1 +
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c | 500 +++++++++++++++------
 drivers/net/wireless/realtek/rtw88/phy.c           |   5 +-
 drivers/nfc/pn533/pn533.c                          |   3 +
 drivers/nvme/host/multipath.c                      |   4 +
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/nvme/target/tcp.c                          |   4 +-
 drivers/of/fdt.c                                   |  12 +-
 drivers/pci/vpd.c                                  |   1 -
 drivers/phy/marvell/Kconfig                        |   4 +-
 drivers/platform/x86/pmc_atom.c                    |  28 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  57 ++-
 drivers/scsi/jazz_esp.c                            |   4 +-
 drivers/scsi/sni_53c710.c                          |   5 +-
 drivers/scsi/sun3x_esp.c                           |   4 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |   4 +-
 drivers/soc/qcom/mdt_loader.c                      |  17 +
 drivers/soundwire/bus.c                            |   3 +-
 drivers/soundwire/stream.c                         |  10 +-
 drivers/spi/spi-fsl-lpspi.c                        |   2 +-
 drivers/spi/spi-stm32.c                            |   3 +-
 drivers/spi/spi.c                                  |   9 +-
 drivers/staging/fwserial/fwserial.c                |  10 +-
 drivers/staging/greybus/uart.c                     |  13 +-
 drivers/staging/media/omap4iss/iss.c               |   4 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   2 +-
 drivers/tty/amiserial.c                            |   1 +
 drivers/tty/moxa.c                                 |  18 +-
 drivers/tty/serial/serial_core.c                   |   6 +-
 drivers/tty/serial/stm32-usart.c                   |  17 +-
 drivers/tty/serial/stm32-usart.h                   |   3 -
 drivers/tty/tty_io.c                               |   8 +-
 drivers/usb/class/cdc-acm.c                        |  16 +-
 drivers/usb/dwc2/core_intr.c                       | 154 ++++---
 drivers/usb/dwc2/hcd.c                             |  10 +-
 drivers/usb/gadget/udc/aspeed-vhub/core.c          |   3 +-
 drivers/usb/gadget/udc/aspeed-vhub/epn.c           |   2 +-
 drivers/usb/gadget/udc/fotg210-udc.c               |  26 +-
 drivers/usb/gadget/udc/pch_udc.c                   |  49 +-
 drivers/usb/gadget/udc/r8a66597-udc.c              |   2 +
 drivers/usb/gadget/udc/snps_udc_plat.c             |   4 +-
 drivers/usb/host/xhci-mtk-sch.c                    |  80 +++-
 drivers/usb/host/xhci-mtk.h                        |   6 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   9 +-
 drivers/usb/serial/usb_wwan.c                      |   9 +-
 drivers/usb/typec/tcpm/tcpci.c                     |  21 +-
 drivers/usb/typec/tcpm/tcpm.c                      | 105 +++--
 drivers/usb/usbip/vudc_sysfs.c                     |   2 +
 drivers/vfio/mdev/mdev_sysfs.c                     |   2 +-
 fs/overlayfs/copy_up.c                             |   3 +-
 include/linux/hid.h                                |   2 +
 include/linux/kvm_host.h                           |   4 +-
 include/linux/smp.h                                |   2 +-
 include/linux/spi/spi.h                            |   3 +
 include/linux/tty_driver.h                         |   2 +-
 include/net/addrconf.h                             |   1 -
 include/net/bluetooth/hci_core.h                   |   1 +
 include/uapi/linux/tty_flags.h                     |   4 +-
 kernel/sched/debug.c                               |  42 +-
 kernel/smp.c                                       |  10 +-
 kernel/up.c                                        |   2 +-
 lib/bug.c                                          |  33 +-
 mm/memory-failure.c                                |   2 +-
 mm/sparse.c                                        |   1 +
 net/bluetooth/hci_event.c                          |   3 +-
 net/bluetooth/hci_request.c                        |  12 +-
 net/bridge/br_multicast.c                          |  33 +-
 net/core/dev.c                                     |   8 +-
 net/hsr/hsr_framereg.c                             |   3 +-
 net/ipv4/route.c                                   |  42 +-
 net/ipv4/tcp_cong.c                                |   4 +
 net/ipv6/mcast_snoop.c                             |  12 +-
 net/mac80211/main.c                                |   7 +-
 net/nfc/digital_dep.c                              |   2 +
 net/nfc/llcp_sock.c                                |   4 +
 net/sctp/socket.c                                  |  38 +-
 net/vmw_vsock/vmci_transport.c                     |   3 +-
 net/wireless/scan.c                                |   2 +
 samples/kfifo/bytestream-example.c                 |   8 +-
 samples/kfifo/inttype-example.c                    |   8 +-
 samples/kfifo/record-example.c                     |   8 +-
 sound/core/init.c                                  |   2 -
 sound/pci/hda/patch_realtek.c                      | 127 +++---
 sound/soc/codecs/ak5558.c                          |   4 +-
 sound/soc/generic/audio-graph-card.c               |   2 +-
 sound/soc/generic/simple-card.c                    |   2 +-
 sound/soc/intel/boards/kbl_da7219_max98927.c       |  38 +-
 sound/soc/samsung/tm2_wm5110.c                     |   2 +-
 sound/usb/card.c                                   |  14 +-
 sound/usb/midi.c                                   |   2 +-
 sound/usb/quirks.c                                 |  16 +-
 sound/usb/usbaudio.h                               |   2 +
 tools/perf/trace/beauty/fsconfig.sh                |   7 +-
 tools/perf/util/symbol_fprintf.c                   |   2 +-
 .../net/forwarding/mirror_gre_vlan_bridge_1q.sh    |   2 +-
 virt/kvm/arm/arm.c                                 |   2 +
 virt/kvm/coalesced_mmio.c                          |  19 +-
 virt/kvm/kvm_main.c                                |  10 +-
 233 files changed, 2110 insertions(+), 1110 deletions(-)


