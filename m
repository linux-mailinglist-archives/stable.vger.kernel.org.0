Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DED4B49EB
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346382AbiBNKSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:18:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347934AbiBNKQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AF77C784;
        Mon, 14 Feb 2022 01:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9513C61374;
        Mon, 14 Feb 2022 09:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC02C340E9;
        Mon, 14 Feb 2022 09:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832430;
        bh=Uv1El7zQegsa1/gFE8RYADSqSdvGI/kJVqr/BYxKbZc=;
        h=From:To:Cc:Subject:Date:From;
        b=JsqK4N29tW+xNFmF/HM5/pN1X5X8w7sf/W5HfQYfUxzl9cJwVWDg13CHYqdnCj3Yj
         txaO0znY3NpnPms2w/uDGlKuYrYwm1YEc3+adzGVf3mrrTIQDoUMWt/lOzS5n30A9+
         nl/U4TBmREqtw2hr6Kbml37Ga9KTl/hePZx3oB6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.16 000/203] 5.16.10-rc1 review
Date:   Mon, 14 Feb 2022 10:24:04 +0100
Message-Id: <20220214092510.221474733@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.16.10-rc1
X-KernelTest-Deadline: 2022-02-16T09:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.16.10 release.
There are 203 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.16.10-rc1

Vijayanand Jitta <quic_vjitta@quicinc.com>
    iommu: Fix potential use-after-free during probe

Chia-Wei Wang <chiawei_wang@aspeedtech.com>
    docs/ABI: testing: aspeed-uart-routing: Escape asterisk

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix missing fclose() on error paths

Song Liu <song@kernel.org>
    perf: Fix list corruption in perf_cgroup_switch()

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: imx8mq: fix lcdif port node

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: octeon: Fix missed PTR->PTR_WD conversion

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Reduce log messages seen after firmware download

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Remove NVMe support if kernel has NVME_FC disabled

Nathan Chancellor <nathan@kernel.org>
    Makefile.extrawarn: Move -Wunaligned-access to W=1

Tadeusz Struk <tadeusz.struk@linaro.org>
    sched/fair: Fix fault in reweight_entity

Reinette Chatre <reinette.chatre@intel.com>
    x86/sgx: Silence softlockup detection when releasing large enclaves

Slark Xiao <slark_xiao@163.com>
    bus: mhi: pci_generic: Add mru_default for Cinterion MV31-W

Slark Xiao <slark_xiao@163.com>
    bus: mhi: pci_generic: Add mru_default for Foxconn SDX55

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: verify the driver availability for path_event call

Kees Cook <keescook@chromium.org>
    signal: HANDLER_EXIT should clear SIGNAL_UNKILLABLE

Kees Cook <keescook@chromium.org>
    seccomp: Invalidate seccomp mode to catch death failures

Roman Gushchin <guro@fb.com>
    mm: memcg: synchronize objcg lists with a dedicated spinlock

Mel Gorman <mgorman@suse.de>
    mm: vmscan: remove deadlock due to throttling failing to make progress

Yang Shi <shy828301@gmail.com>
    fs/proc: task_mmu.c: don't read mapcount for migration entry

Mathias Krause <minipli@grsecurity.net>
    iio: buffer: Fix file related error handling in IIO_BUFFER_GET_FD_IOCTL

Kishon Vijay Abraham I <kishon@ti.com>
    phy: ti: Fix missing sentinel for clk_div_table

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup-dectlk: Restore pitch setting

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add CPI Bulk Coin Recycler id

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add NCR Retail IO box id

Stephan Brunner <s.brunner@stephan-brunner.net>
    USB: serial: ch341: add support for GW Instek USB2.0-Serial devices

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add ZTE MF286D modem

Cameron Williams <cang1@live.co.uk>
    USB: serial: ftdi_sio: add support for Brainboxes US-159/235/320

Jann Horn <jannh@google.com>
    usb: raw-gadget: fix handling of dual-direction-capable endpoints

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: gadget: f_uac2: Define specific wTerminalType

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: gadget: rndis: check size of RNDIS_MSG_SET command

Szymon Heidrich <szymon.heidrich@gmail.com>
    USB: gadget: validate interface OS descriptor requests

Adam Ford <aford173@gmail.com>
    usb: gadget: udc: renesas_usb3: Fix host to USB_ROLE_NONE transition

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: dwc3: gadget: Prevent core from processing stale TRBs

Sean Anderson <sean.anderson@seco.com>
    usb: ulpi: Call of_node_put correctly

Sean Anderson <sean.anderson@seco.com>
    usb: ulpi: Move of_node_put to ulpi_dev_release

Jann Horn <jannh@google.com>
    net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: dwc2: drd: fix soft connect when gadget is unconfigured"

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: dwc2: drd: fix soft connect when gadget is unconfigured

Jonas Malaco <jonas@protocubo.io>
    eeprom: ee1004: limit i2c reads to I2C_SMBUS_BLOCK_MAX

TATSUKAWA KOSUKE (立川 江介) <tatsu-ab1@nec.com>
    n_tty: wake up poll(POLLRDNORM) on receiving data

Jakob Koschel <jakobkoschel@gmail.com>
    vt_ioctl: add array_index_nospec to VT_ACTIVATE

Jakob Koschel <jakobkoschel@gmail.com>
    vt_ioctl: fix array_index_nospec in vt_setactivate

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: fix use-after-free in mv88e6xxx_mdios_unregister

Colin Foster <colin.foster@in-advantage.com>
    net: mscc: ocelot: fix mutex lock error during ethtool stats read

Dave Ertman <david.m.ertman@intel.com>
    ice: Avoid RTNL lock when re-creating auxiliary device

Dave Ertman <david.m.ertman@intel.com>
    ice: Fix KASAN error in LAG NETDEV_UNREGISTER handler

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: fix IPIP and SIT TSO offload

Dan Carpenter <dan.carpenter@oracle.com>
    ice: fix an error code in ice_cfg_phy_fec()

Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
    dpaa2-eth: unregister the netdev before disconnecting from the PHY

Kishen Maloor <kishen.maloor@intel.com>
    mptcp: netlink: process IPv6 addrs in creating listening sockets

Yang Wang <KevinYang.Wang@amd.com>
    drm/amd/pm: fix hwmon node of power1_label create issue

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix panic when DSA master device unbinds on shutdown

Raju Rangoju <Raju.Rangoju@amd.com>
    net: amd-xgbe: disable interrupts during pci removal

Jon Maloy <jmaloy@redhat.com>
    tipc: rate limit warning for received illegal binding update

Joel Stanley <joel@jms.id.au>
    net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE

Eric Dumazet <edumazet@google.com>
    veth: fix races around rq->rx_notify_masked

Antoine Tenart <atenart@kernel.org>
    net: fix a memleak when uncloning an skb dst and its metadata

Antoine Tenart <atenart@kernel.org>
    net: do not keep the dst cache when uncloning an skb dst and its metadata

Louis Peens <louis.peens@corigine.com>
    nfp: flower: fix ida_idx not being released

Eric Dumazet <edumazet@google.com>
    ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path

Cai Huoqing <cai.huoqing@linux.dev>
    net: ethernet: litex: Add the dependency on HAS_IOMEM

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: don't release napi in __ibmvnic_open()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq_gswip: don't use devres for mdiobus

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mt7530: fix kernel bug in mdiobus_free() when unbinding

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: seville: register the mdiobus under devres

Colin Foster <colin.foster@in-advantage.com>
    net: dsa: ocelot: seville: utilize of_mdiobus_register

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: don't use devres for mdiobus

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: bcm_sf2: don't use devres for mdiobus

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: ar9331: register the mdiobus under devres

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: don't use devres for mdiobus

Mahesh Bandewar <maheshb@google.com>
    bonding: pair enable_port with slave_arr_updates

Tao Liu <xliutaox@google.com>
    gve: Recording rx queue before sending to napi

NeilBrown <neilb@suse.de>
    SUNRPC: lock against ->sock changing during sysfs read

Helge Deller <deller@gmx.de>
    fbcon: Avoid 'cap' set but not used warning

Niklas Cassel <niklas.cassel@wdc.com>
    gpio: sifive: use the correct register to read output values

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: Never return internal error codes to user space

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/module: fix building test_modules_helpers.o with clang

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    drm/panel: simple: Assign data from panel_dpi_probe() correctly

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix all IP traffic getting trapped to CPU with PTP over IP

Eric Dumazet <edumazet@google.com>
    tcp: take care of mixed splice()/sendmsg(MSG_ZEROCOPY) case

Samuel Mendoza-Jonas <samjonas@amazon.com>
    ixgbevf: Require large buffers for build_skb on 82599VF

Lutz Koschorreck <theleks@ko-hh.de>
    arm64: dts: meson-sm1-odroid: fix boot loop after reboot

Dongjin Kim <tobetter@gmail.com>
    arm64: dts: meson-sm1-bananapi-m5: fix wrong GPIO domain for GPIOE_2

Lutz Koschorreck <theleks@ko-hh.de>
    arm64: dts: meson-sm1-odroid: use correct enable-gpio pin for tf-io regulator

Dongjin Kim <tobetter@gmail.com>
    arm64: dts: meson-g12b-odroid-n2: fix typo 'dio2133'

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: disable helper autoassign

Florian Westphal <fw@strlen.de>
    netfilter: nft_payload: don't allow th access for fragments

Steen Hegelund <steen.hegelund@microchip.com>
    net: sparx5: Fix get_stat64 crash in tcpdump

Mathias Krause <minipli@grsecurity.net>
    misc: fastrpc: avoid double fput() on failed usercopy

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Allow DBLCLK modes even if horz timing is odd.

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Avoid duplicate uncached readdir calls on eof

trondmy@kernel.org <trondmy@kernel.org>
    NFS: Don't skip directory entries when doing uncached readdir

trondmy@kernel.org <trondmy@kernel.org>
    NFS: Don't overfill uncached readdir pages

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: aggregator: Fix calling into sleeping GPIO controllers

Liu Ying <victor.liu@nxp.com>
    phy: dphy: Correct clk_pre parameter

Mark Brown <broonie@kernel.org>
    arm64: Enable Cortex-A510 erratum 2051678 by default

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: f_fs: Fix use-after-free for epfile

Martin Kepplinger <martink@posteo.de>
    arm64: dts: imx8mq: fix mipi_csi bidirectional port numbers

Rob Herring <robh@kernel.org>
    ARM: dts: imx7ulp: Fix 'assigned-clocks-parents' typo

Dan Carpenter <dan.carpenter@oracle.com>
    phy: stm32: fix a refcount leak in stm32_usbphyc_pll_enable()

Robert Hancock <robert.hancock@calian.com>
    phy: xilinx: zynqmp: Fix bus width setting for SGMII

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-udoo: Properly describe the SD card detect

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    staging: fbtft: Fix error path in fbtft_driver_module_init()

Jens Wiklander <jens.wiklander@linaro.org>
    optee: add error checks in optee_ffa_do_call_with_arg()

Jerome Forissier <jerome@forissier.org>
    tee: optee: do not check memref size on return from Secure World

Al Cooper <alcooperx@gmail.com>
    phy: broadcom: Kconfig: Fix PHY_BRCM_USB config option

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8b: Fix the UART device-tree schema validation

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8: Fix the UART device-tree schema validation

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson: Fix the UART compatible strings

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix timer regression for beagleboard revision c

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Workaround broken BIOS DBUF configuration on TGL/RKL

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Populate pipe dbuf slices more accurately during readout

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Allow !join_mbus cases for adlp+ dbuf configuration

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Disable DRRS on IVB/HSW port != A

Brian Norris <briannorris@chromium.org>
    drm/rockchip: vop: Correct RK3399 VOP register fields

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: change pipe policy for DCN 2.0

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: s2idle: ACPI: Fix wakeup interrupts handling

Robin Murphy <robin.murphy@arm.com>
    ACPI/IORT: Check node revision for PMCG resources

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix bogus request completion when failing to send AER

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: socfpga: fix missing RESET_CONTROLLER

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: Fix boot regression on Skomer

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from hog group

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI/portdrv: Do not setup up IRQs if there are no users"

Andreas Gruenbacher <agruenba@redhat.com>
    Revert "gfs2: check context in gfs2_glock_put"

Bob Peterson <rpeterso@redhat.com>
    gfs2: Fix gfs2_release for non-writers regression

Changbin Du <changbin.du@intel.com>
    riscv: eliminate unreliable __builtin_frame_address(1)

Palmer Dabbelt <palmer@rivosinc.com>
    riscv/mm: Add XIP_FIXUP for phys_ram_base

Pingfan Liu <kernelfans@gmail.com>
    riscv: cpu-hotplug: clear cpu from numa map when teardown

Myrtle Shah <gatecat@ds0.me>
    riscv: Fix XIP_FIXUP_FLASH_OFFSET

Aurelien Jarno <aurelien@aurel32.net>
    riscv: fix build with binutils 2.38

Jim Mattson <jmattson@google.com>
    KVM: x86: Report deprecated x87 features in supported CPUID

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS blocking shadow

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Don't kill SEV guest if SMAP erratum triggers in usermode

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: Also filter MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER

Hou Wenlong <houwenlong93@linux.alibaba.com>
    KVM: eventfd: Fix false positive RCU usage warning

Marco Elver <elver@google.com>
    kasan: test: fix compatibility with FORTIFY_SOURCE

James Morse <james.morse@arm.com>
    arm64: cpufeature: List early Cortex-A510 parts as having broken dbm

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: errata: Add detection for TRBE trace data corruption

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: errata: Add detection for TRBE invalid prohibited states

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: errata: Add detection for TRBE ignored system register writes

Jisheng Zhang <jszhang@kernel.org>
    net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: Fix build error due to PTR used in more places

Wu Zheng <wu.zheng@intel.com>
    nvme-pci: add the IGNORE_DEV_SUBNQN quirk for Intel P4500/P4600 SSDs

James Clark <james.clark@arm.com>
    perf: Always wake the parent event

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: use msleep rather than udelay for long delays

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: adjust msleep limit in dp_wait_for_training_aux_rd_interval

Zhan Liu <zhan.liu@amd.com>
    drm/amd/display: Correct MPC split policy for DCN301

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    PM: hibernate: Remove register_nosave_region_late()

Jisheng Zhang <jszhang@kernel.org>
    net: stmmac: reduce unnecessary wakeups from eee sw timer

Tong Zhang <ztong0001@gmail.com>
    scsi: myrs: Fix crash in error case

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: Treat link loss as fatal error

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: Use generic error code in ufshcd_set_dev_pwr_mode()

John Garry <john.garry@huawei.com>
    scsi: pm8001: Fix bogus FW crash for maxcpus=1

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Change context reset messages to ratelimited

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Fix refcount issue when LOGO is received during TMF

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Add stag_work to all the vports

Xiaoke Wang <xkernel.wang@foxmail.com>
    scsi: ufs: ufshcd-pltfrm: Check the return value of devm_kstrdup()

ZouMingzhe <mingzhe.zou@easystack.cn>
    scsi: target: iscsi: Make sure the np under each tpg is unique

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: errata: Update ARM64_ERRATUM_[2119858|2224489] with Cortex-X2 ranges

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: Add Cortex-X2 CPU part definition

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/module: test loading modules with a lot of relocations

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/fixmap: Fix VM debug warning on unmap

Victor Nogueira <victor@mojatatu.com>
    net: sched: Clarify error message when qdisc kind is unknown

Raymond Jay Golo <rjgolo@gmail.com>
    drm: panel-orientation-quirks: Add quirk for the 1Netbook OneXPlayer

Padmanabha Srinivasaiah <treasure4paddy@gmail.com>
    drm/vc4: Fix deadlock on DSI device attach error

Peter Zijlstra <peterz@infradead.org>
    sched: Avoid double preemption in __cond_resched_*lock*()

Andi Kleen <ak@linux.intel.com>
    x86/perf: Avoid warning for Arch LBR without XSAVE

Stephane Eranian <eranian@google.com>
    perf/x86/rapl: fix AMD event handling

Sander Vanheule <sander@svanheule.net>
    irqchip/realtek-rtl: Service all pending interrupts

Anna Schumaker <Anna.Schumaker@Netapp.com>
    sunrpc: Fix potential race conditions in rpc_sysfs_xprt_state_change()

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/sunrpc: fix reference count leaks in rpc_sysfs_xprt_state_change

Olga Kornievskaia <kolga@netapp.com>
    SUNRPC allow for unspecified transport time in rpc_clnt_add_xprt

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 handle port presence in fs_location server string

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 expose nfs_parse_server_name function

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1 query for fs_location attr on a new file system

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 store server support for fs_location attribute

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 remove zero number of fs_locations entries error check

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: Fix uninitialised variable in devicenotify

Xiaoke Wang <xkernel.wang@foxmail.com>
    nfs: nfs4clinet: check the return value of kstrdup()

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 only print the label when its queried

NeilBrown <neilb@suse.de>
    NFS: change nfs_access_get_cached to only report the mask

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix the behavior of READ near OFFSET_MAX

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix offset type in I/O trace points

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clamp WRITE offsets

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix ia_size underflow

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix NFSv3 SETATTR/CREATE's handling of large file sizes

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix initialisation of nfs_client cl_flags field

Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
    net: phy: marvell: Fix MDI-x polarity setting in 88e1118-compatible PHYs

Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
    net: phy: marvell: Fix RGMII Tx/Rx delays setting in 88e1121-compatible PHYs

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix error path in isotp_sendmsg() to unlock wait queue

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix potential CAN frame reception race in isotp_rcv()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mmc: sh_mmcif: Check for null res pointer

Andrey Skvortsov <andrej.skvortzov@gmail.com>
    mmc: core: Wait for command setting 'Power Off Notification' bit to complete

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mmc: sdhci-of-esdhc: Check for error num after setting mask

Stefan Berger <stefanb@linux.ibm.com>
    ima: Do not print policy rule with inactive LSM labels

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Allow template selection with ima_template[_fmt]= after ima_hash=

Stefan Berger <stefanb@linux.ibm.com>
    ima: Remove ima_policy file before directory

Eric Biggers <ebiggers@google.com>
    ima: fix reference leak in asymmetric_verify()

Paul Moore <paul@paul-moore.com>
    audit: don't deref the syscall args when checking the openat2 open_how::flags

Xiaoke Wang <xkernel.wang@foxmail.com>
    integrity: check the return value of audit_log_start()


-------------

Diffstat:

 .../ABI/testing/sysfs-driver-aspeed-uart-routing   |   6 +-
 Documentation/arm64/silicon-errata.rst             |  12 ++
 .../devicetree/bindings/arm/omap/omap.txt          |   3 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/imx23-evk.dts                    |   1 -
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                |   5 +-
 arch/arm/boot/dts/imx7ulp.dtsi                     |   2 +-
 arch/arm/boot/dts/meson.dtsi                       |   8 +-
 arch/arm/boot/dts/meson8.dtsi                      |  24 +--
 arch/arm/boot/dts/meson8b.dtsi                     |  24 +--
 arch/arm/boot/dts/omap3-beagle-ab4.dts             |  47 ++++++
 arch/arm/boot/dts/omap3-beagle.dts                 |  33 ----
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts     |   4 -
 arch/arm/mach-socfpga/Kconfig                      |   2 +
 arch/arm64/Kconfig                                 |  82 +++++++++-
 .../boot/dts/amlogic/meson-g12b-odroid-n2.dtsi     |   4 +-
 .../boot/dts/amlogic/meson-sm1-bananapi-m5.dts     |   2 +-
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi  |   2 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |  10 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/kernel/cpu_errata.c                     |  29 ++++
 arch/arm64/kernel/cpufeature.c                     |   3 +
 arch/arm64/tools/cpucaps                           |   3 +
 arch/mips/cavium-octeon/octeon-memcpy.S            |   2 +-
 arch/mips/include/asm/asm.h                        |   4 +-
 arch/mips/include/asm/ftrace.h                     |   4 +-
 arch/mips/include/asm/r4kcache.h                   |   4 +-
 arch/mips/include/asm/unaligned-emul.h             | 176 ++++++++++-----------
 arch/mips/kernel/mips-r2-to-r6-emul.c              | 104 ++++++------
 arch/mips/kernel/r2300_fpu.S                       |   6 +-
 arch/mips/kernel/r4k_fpu.S                         |   2 +-
 arch/mips/kernel/relocate_kernel.S                 |  22 +--
 arch/mips/kernel/scall32-o32.S                     |  10 +-
 arch/mips/kernel/scall64-n32.S                     |   2 +-
 arch/mips/kernel/scall64-n64.S                     |   2 +-
 arch/mips/kernel/scall64-o32.S                     |  10 +-
 arch/mips/kernel/syscall.c                         |   8 +-
 arch/mips/lib/csum_partial.S                       |   4 +-
 arch/mips/lib/memcpy.S                             |   4 +-
 arch/mips/lib/memset.S                             |   2 +-
 arch/mips/lib/strncpy_user.S                       |   4 +-
 arch/mips/lib/strnlen_user.S                       |   2 +-
 arch/powerpc/include/asm/book3s/32/pgtable.h       |   1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   2 +
 arch/powerpc/include/asm/fixmap.h                  |   6 +-
 arch/powerpc/include/asm/nohash/32/pgtable.h       |   1 +
 arch/powerpc/include/asm/nohash/64/pgtable.h       |   1 +
 arch/powerpc/mm/pgtable.c                          |   9 ++
 arch/riscv/Makefile                                |   6 +
 arch/riscv/kernel/cpu-hotplug.c                    |   2 +
 arch/riscv/kernel/head.S                           |  11 +-
 arch/riscv/kernel/stacktrace.c                     |   9 +-
 arch/riscv/mm/init.c                               |   1 +
 arch/s390/Kconfig                                  |  15 ++
 arch/s390/lib/Makefile                             |   3 +
 arch/s390/lib/test_modules.c                       |  32 ++++
 arch/s390/lib/test_modules.h                       |  53 +++++++
 arch/s390/lib/test_modules_helpers.c               |  13 ++
 arch/x86/events/intel/lbr.c                        |   3 +
 arch/x86/events/rapl.c                             |   9 +-
 arch/x86/kernel/cpu/sgx/encl.c                     |   2 +
 arch/x86/kvm/cpuid.c                               |  13 +-
 arch/x86/kvm/svm/svm.c                             |  16 +-
 arch/x86/kvm/vmx/evmcs.c                           |   1 +
 arch/x86/kvm/vmx/evmcs.h                           |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |  25 +++
 drivers/accessibility/speakup/speakup_dectlk.c     |   1 +
 drivers/acpi/arm64/iort.c                          |  14 +-
 drivers/acpi/ec.c                                  |  10 ++
 drivers/acpi/sleep.c                               |  15 +-
 drivers/base/power/wakeup.c                        |  41 ++++-
 drivers/bus/mhi/pci_generic.c                      |   2 +
 drivers/clocksource/timer-ti-dm-systimer.c         |   2 +-
 drivers/gpio/gpio-aggregator.c                     |  18 ++-
 drivers/gpio/gpio-sifive.c                         |   2 +-
 drivers/gpio/gpiolib-cdev.c                        |   6 +-
 drivers/gpio/gpiolib-sysfs.c                       |   7 +-
 drivers/gpio/gpiolib.h                             |  12 ++
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   6 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   2 +-
 .../drm/amd/display/dc/dcn301/dcn301_resource.c    |   2 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   3 +-
 drivers/gpu/drm/bridge/nwl-dsi.c                   |  12 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  12 ++
 drivers/gpu/drm/i915/display/intel_display.c       |   1 +
 drivers/gpu/drm/i915/display/intel_drrs.c          |   8 +
 drivers/gpu/drm/i915/intel_pm.c                    | 143 ++++++++++++++---
 drivers/gpu/drm/i915/intel_pm.h                    |   1 +
 drivers/gpu/drm/panel/panel-simple.c               |   1 +
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c        |   8 +-
 drivers/gpu/drm/vc4/vc4_dsi.c                      |  14 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   2 +
 drivers/iio/industrialio-buffer.c                  |  14 +-
 drivers/iommu/iommu.c                              |   9 +-
 drivers/irqchip/irq-realtek-rtl.c                  |   8 +-
 drivers/misc/eeprom/ee1004.c                       |   3 +
 drivers/misc/fastrpc.c                             |   9 +-
 drivers/mmc/core/sd.c                              |   8 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   8 +-
 drivers/mmc/host/sh_mmcif.c                        |   3 +
 drivers/net/bonding/bond_3ad.c                     |   3 +-
 drivers/net/dsa/bcm_sf2.c                          |   7 +-
 drivers/net/dsa/lantiq_gswip.c                     |  14 +-
 drivers/net/dsa/mt7530.c                           |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  15 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   4 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |   6 +-
 drivers/net/dsa/qca/ar9331.c                       |   3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c           |   3 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  13 +-
 drivers/net/ethernet/intel/ice/ice.h               |   3 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   3 +-
 drivers/net/ethernet/intel/ice/ice_lag.c           |  34 +++-
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h     |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  28 +++-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  13 +-
 drivers/net/ethernet/litex/Kconfig                 |   2 +-
 .../net/ethernet/microchip/sparx5/sparx5_ethtool.c |   2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  19 ++-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  12 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  13 +-
 drivers/net/mdio/mdio-aspeed.c                     |   1 +
 drivers/net/phy/marvell.c                          |  17 +-
 drivers/net/usb/ax88179_178a.c                     |  68 ++++----
 drivers/net/veth.c                                 |  13 +-
 drivers/nvme/host/pci.c                            |   3 +-
 drivers/nvme/host/tcp.c                            |  10 +-
 drivers/pci/pcie/portdrv_core.c                    |  47 ++----
 drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c      |   3 +-
 drivers/phy/broadcom/Kconfig                       |   3 +-
 drivers/phy/phy-core-mipi-dphy.c                   |   4 +-
 drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c   |   3 +-
 drivers/phy/st/phy-stm32-usbphyc.c                 |   2 +-
 drivers/phy/ti/phy-j721e-wiz.c                     |   1 +
 drivers/phy/xilinx/phy-zynqmp.c                    |  11 +-
 drivers/s390/cio/device.c                          |   2 +-
 drivers/scsi/lpfc/lpfc.h                           |  13 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   4 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   8 +-
 drivers/scsi/myrs.c                                |   3 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  16 +-
 drivers/scsi/pm8001/pm80xx_hwi.h                   |   6 +-
 drivers/scsi/qedf/qedf_io.c                        |   1 +
 drivers/scsi/qedf/qedf_main.c                      |   7 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   7 +
 drivers/scsi/ufs/ufshcd.c                          |   9 +-
 drivers/scsi/ufs/ufshci.h                          |   3 +-
 drivers/staging/fbtft/fbtft.h                      |   5 +-
 drivers/target/iscsi/iscsi_target_tpg.c            |   3 +
 drivers/tee/optee/ffa_abi.c                        |  15 +-
 drivers/tee/optee/smc_abi.c                        |  10 --
 drivers/tty/n_tty.c                                |   4 +-
 drivers/tty/vt/vt_ioctl.c                          |   3 +-
 drivers/usb/common/ulpi.c                          |  10 +-
 drivers/usb/dwc2/gadget.c                          |   2 +-
 drivers/usb/dwc3/gadget.c                          |  13 ++
 drivers/usb/gadget/composite.c                     |   3 +
 drivers/usb/gadget/function/f_fs.c                 |  56 +++++--
 drivers/usb/gadget/function/f_uac2.c               |   4 +-
 drivers/usb/gadget/function/rndis.c                |   9 +-
 drivers/usb/gadget/legacy/raw_gadget.c             |   2 +-
 drivers/usb/gadget/udc/renesas_usb3.c              |   2 +
 drivers/usb/serial/ch341.c                         |   1 +
 drivers/usb/serial/cp210x.c                        |   2 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   3 +
 drivers/usb/serial/option.c                        |   2 +
 drivers/video/fbdev/core/fbcon.c                   |   7 +-
 fs/gfs2/file.c                                     |   7 +-
 fs/gfs2/glock.c                                    |   3 -
 fs/nfs/callback.h                                  |   2 +-
 fs/nfs/callback_proc.c                             |   2 +-
 fs/nfs/callback_xdr.c                              |  18 +--
 fs/nfs/client.c                                    |   9 +-
 fs/nfs/dir.c                                       |  44 ++++--
 fs/nfs/nfs4_fs.h                                   |  12 +-
 fs/nfs/nfs4client.c                                |   5 +-
 fs/nfs/nfs4namespace.c                             |  19 ++-
 fs/nfs/nfs4proc.c                                  |  96 ++++++++---
 fs/nfs/nfs4state.c                                 |   6 +-
 fs/nfs/nfs4xdr.c                                   |   9 +-
 fs/nfsd/nfs3proc.c                                 |  13 +-
 fs/nfsd/nfs3xdr.c                                  |   2 +-
 fs/nfsd/nfs4proc.c                                 |  13 +-
 fs/nfsd/nfs4xdr.c                                  |   8 +-
 fs/nfsd/trace.h                                    |  14 +-
 fs/nfsd/vfs.c                                      |   4 +
 fs/proc/task_mmu.c                                 |  40 +++--
 include/linux/memcontrol.h                         |   5 +-
 include/linux/nfs_fs.h                             |   5 +-
 include/linux/nfs_fs_sb.h                          |   2 +-
 include/linux/nfs_xdr.h                            |   1 +
 include/linux/suspend.h                            |  15 +-
 include/net/dst_metadata.h                         |  14 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |   2 +-
 kernel/auditsc.c                                   |   2 +-
 kernel/events/core.c                               |  16 +-
 kernel/power/main.c                                |   5 +-
 kernel/power/process.c                             |   2 +-
 kernel/power/snapshot.c                            |  21 +--
 kernel/power/suspend.c                             |   2 -
 kernel/sched/core.c                                |  23 ++-
 kernel/seccomp.c                                   |  10 ++
 kernel/signal.c                                    |   5 +-
 lib/test_kasan.c                                   |   5 +
 mm/memcontrol.c                                    |  10 +-
 mm/vmscan.c                                        |   4 +-
 net/can/isotp.c                                    |  29 +++-
 net/dsa/dsa2.c                                     |  25 +--
 net/ipv4/ipmr.c                                    |   2 +
 net/ipv4/tcp.c                                     |  33 ++--
 net/ipv6/ip6mr.c                                   |   2 +
 net/mptcp/pm_netlink.c                             |   8 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +-
 net/netfilter/nft_exthdr.c                         |   2 +-
 net/netfilter/nft_payload.c                        |   9 +-
 net/sched/sch_api.c                                |   2 +-
 net/sunrpc/clnt.c                                  |   5 +-
 net/sunrpc/sysfs.c                                 |  46 +++---
 net/sunrpc/xprtsock.c                              |   7 +-
 net/tipc/name_distr.c                              |   2 +-
 scripts/Makefile.extrawarn                         |   1 +
 scripts/kconfig/confdata.c                         |  12 +-
 security/integrity/digsig_asymmetric.c             |  15 +-
 security/integrity/ima/ima_fs.c                    |   2 +-
 security/integrity/ima/ima_policy.c                |   8 +
 security/integrity/ima/ima_template.c              |  10 +-
 security/integrity/integrity_audit.c               |   2 +
 virt/kvm/eventfd.c                                 |   8 +-
 234 files changed, 1811 insertions(+), 860 deletions(-)


