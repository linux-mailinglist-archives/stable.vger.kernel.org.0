Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC71E14F5B
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfEFOec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbfEFOeb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42BB5204EC;
        Mon,  6 May 2019 14:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153269;
        bh=Q5SHAohQTPTYgp/txwM6iilizpyOCnEuHs5qK9lJmW4=;
        h=From:To:Cc:Subject:Date:From;
        b=D8halO1OSO43fMrwiEdRzZHvRtQgyB+qrd5vDFzltID0gtw7dAkk2XRFQN5cxrgLa
         LMui+MUaFd3ITxGMlMGllVmALbG2GoWL4mLbzam3yCZggb5wTW7hOj4KrhpBARL0tt
         5y3J2zzb/Zv2YsPipdyKCb/ksJAWWAXQDeKW5RXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.0 000/122] 5.0.14-stable review
Date:   Mon,  6 May 2019 16:30:58 +0200
Message-Id: <20190506143054.670334917@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.0.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.0.14-rc1
X-KernelTest-Deadline: 2019-05-08T14:31+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.0.14 release.
There are 122 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 08 May 2019 02:29:09 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.0.14-rc1

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: v4l2: i2c: ov7670: Fix PLL bypass register values

Nicolas Le Bayon <nicolas.le.bayon@st.com>
    i2c: i2c-stm32f7: Fix SDADEL minimum formula

Peter Zijlstra <peterz@infradead.org>
    x86/mm/tlb: Revert "x86/mm: Align TLB invalidation info"

Qian Cai <cai@lca.pw>
    x86/mm: Fix a crash with kmemleak_scan()

Baoquan He <bhe@redhat.com>
    x86/mm/KASLR: Fix the size of the direct mapping section

David Müller <dave.mueller@gmx.ch>
    clk: x86: Add system specific quirk to mark clocks as critical

Tony Luck <tony.luck@intel.com>
    x86/mce: Improve error message when kernel cannot recover, p2

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/hash: Handle mmap_min_addr correctly in get_unmapped_area topdown search

Alexander Wetzel <alexander@wetzel-home.de>
    mac80211: Honor SW_CRYPTO_CONTROL for unicast keys in AP VLAN mode

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: never allow relabeling on context mounts

Stephen Smalley <sds@tycho.nsa.gov>
    selinux: avoid silent denials in permissive mode under RCU walk

Anson Huang <anson.huang@nxp.com>
    gpio: mxc: add check to return defer probe if clock tree NOT ready

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: stmfts - acknowledge that setting brightness is a blocking call

Anson Huang <anson.huang@nxp.com>
    Input: snvs_pwrkey - initialize necessary driver data before enabling IRQ

Yuval Avnery <yuvalav@mellanox.com>
    IB/core: Destroy QP if XRC QP fails

Daniel Jurgens <danielj@mellanox.com>
    IB/core: Fix potential memory leak while creating MAD agents

Daniel Jurgens <danielj@mellanox.com>
    IB/core: Unregister notifier before freeing MAD security

Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
    platform/x86: intel_pmc_core: Handle CFL regmap properly

Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
    platform/x86: intel_pmc_core: Fix PCH IP name

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: lapic: Check for in-kernel LAPIC before deferencing apic pointer

Yu Zhang <yu.c.zhang@linux.intel.com>
    kvm: vmx: Fix typos in vmentry/vmexit control setting

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Remove a rogue "rax" clobber from nested_vmx_check_vmentry_hw()

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Save RSI to an unused output in the vCPU-run asm blob

Arnaud Pouliquen <arnaud.pouliquen@st.com>
    ASoC: stm32: fix sai driver name initialisation

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: dpcm: skip missing substream while applying symmetry

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm_adsp: Correct handling of compressed streams that restart

Chen-Yu Tsai <wens@csie.org>
    ASoC: sunxi: sun50i-codec-analog: Rename hpvcc regulator supply to cpvdd

Jiada Wang <jiada_wang@mentor.com>
    ASoC: rsnd: gen: fix SSI9 4/5/6/7 busif related register address

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5651: Revert "Fix DMIC map headsetmic mapping"

Bart Van Assche <bvanassche@acm.org>
    scsi: RDMA/srpt: Fix a credit leak for aborted commands

John Garry <john.garry@huawei.com>
    scsi: hisi_sas: Fix to only call scsi_get_prot_op() for non-NULL scsi_cmnd

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac write calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix handling of dac high resolution option

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac read calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: allow adt751x to use internal vref for all dacs

Thinh Nguyen <thinh.nguyen@synopsys.com>
    usb: dwc3: Reset num_trbs after skipping

Jeffrey Hugo <jhugo@codeaurora.org>
    clk: qcom: Add missing freq for usb30_master_clk on 8998

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: mediatek: fix up an error path to restore bdev->tx_state

Brian Norris <briannorris@chromium.org>
    Bluetooth: btusb: request wake pin with NOAUTOEN

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd: Update generic hardware cache events for Family 17h

Arnd Bergmann <arnd@arndb.de>
    ARM: iop: don't use using 64-bit DMA masks

Arnd Bergmann <arnd@arndb.de>
    ARM: orion: don't use using 64-bit DMA masks

Kirill Smelkov <kirr@nexedi.com>
    fs: stream_open - opener for stream-like files so that read and write can run simultaneously without deadlock

Guenter Roeck <linux@roeck-us.net>
    xsysace: Fix error handling in ace_setup

John Pittman <jpittman@redhat.com>
    null_blk: prevent crash from bad home_node value

Randy Dunlap <rdunlap@infradead.org>
    sh: fix multiple function definition build errors

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: fix memory leak for resv_map

Catalin Marinas <catalin.marinas@arm.com>
    kmemleak: powerpc: skip scanning holes in the .bss section

David Rientjes <rientjes@google.com>
    KVM: SVM: prevent DBG_DECRYPT and DBG_ENCRYPT overflow

Varun Prakash <varun@chelsio.com>
    libcxgb: fix incorrect ppmax calculation

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix WARNING when remove HNS driver with SMMU enabled

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: fix ICMP6 neighbor solicitation messages discard problem

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix probabilistic memory overwrite when HNS driver initialized

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Use NAPI_POLL_WEIGHT for hns driver

Liubin Shu <shuliubin@huawei.com>
    net: hns: fix KASAN: use-after-free in hns_nic_net_xmit_hw()

Wei Li <liwei391@huawei.com>
    arm64: fix wrong check of on_sdei_stack in nmi context

Dongli Zhang <dongli.zhang@oracle.com>
    blk-mq: do not reset plug->rq_count before the list is sorted

Peng Hao <peng.hao2@zte.com.cn>
    arm/mach-at91/pm : fix possible object reference leak

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Fix calculation of sub-channel count

Xose Vazquez Perez <xose.vazquez@gmail.com>
    scsi: core: add new RDAC LENOVO/DE_Series device

Louis Taylor <louis@kragniz.eu>
    vfio/pci: use correct format characters

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for Assistant key

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: da9063: set uie_unsupported when relevant

Shenghui Wang <shhuiw@foxmail.com>
    block: use blk_free_flush_queue() to free hctx->fq in blk_mq_init_hctx

Andreas Kemnade <andreas@kemnade.info>
    mfd: twl-core: Disable IRQ while suspended

Al Viro <viro@zeniv.linux.org.uk>
    debugfs: fix use-after-free on symlink traversal

Al Viro <viro@zeniv.linux.org.uk>
    jffs2: fix use-after-free on symlink traversal

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't log oversized frames

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: fix dropping of multi-descriptor RX frames

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't overwrite discard_frame status

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't stop NAPI processing when dropping a packet

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: ratelimit RX error logs

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: use correct DMA buffer size in the RX descriptor

Konstantin Khorenko <khorenko@virtuozzo.com>
    bonding: show full hw address in sysfs for slave entries

Omri Kahalon <omrik@mellanox.com>
    net/mlx5: E-Switch, Fix esw manager vport indication for more vport commands

Roi Dayan <roid@mellanox.com>
    net/mlx5: E-Switch, Protect from invalid memory access in offload fdb table

Jesper Dangaard Brouer <brouer@redhat.com>
    xdp: fix cpumap redirect SKB creation bug

Xi Wang <wangxi11@huawei.com>
    net: hns3: fix compile error

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    HID: quirks: Fix keyboard + touchpad on Lenovo Miix 630

Alan Kao <alankao@andestech.com>
    riscv: fix accessing 8-byte variable from RV32

Stefan Assmann <sassmann@kpanic.de>
    i40e: fix WoL support check

Ivan Vecera <ivecera@redhat.com>
    ixgbe: fix mdio bus registration

Arvind Sankar <niveditas98@gmail.com>
    igb: Fix WARN_ONCE on runtime suspend

Jacob Keller <jacob.e.keller@intel.com>
    i40e: fix i40e_ptp_adjtime when given a negative delta

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix dcan clkctrl clock for am3

Axel Lin <axel.lin@ingics.com>
    reset: meson-audio-arb: Fix missing .owner setting of reset_controller_dev

Douglas Anderson <dianders@chromium.org>
    ARM: dts: rockchip: Fix gpu opp node names for rk3288

Anders Roxell <anders.roxell@linaro.org>
    batman-adv: fix warning in function batadv_v_elp_get_throughput

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_global hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_local hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce claim hash refcnt only for removed entry

Julia Lawall <Julia.Lawall@lip6.fr>
    ARM: OMAP2+: add missing of_node_put after of_device_is_available

Geert Uytterhoeven <geert+renesas@glider.be>
    rtc: sh: Fix invalid alarm warning for non-enabled alarm

Stephen Boyd <swboyd@chromium.org>
    rtc: cros-ec: Fail suspend/resume if wake IRQ can't be configured

He, Bo <bo.he@intel.com>
    HID: debug: fix race condition with between rdesc_show() and device removal

Kangjie Lu <kjlu@umn.edu>
    HID: logitech: check the return value of create_singlethread_workqueue

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: Increase maximum report size allowed by hid_field_extract()

Leonidas P. Papadakos <papadakospan@gmail.com>
    arm64: dts: rockchip: fix rk3328-roc-cc gmac2io tx/rx_delay

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: lapic: Convert guest TSC to host time domain if necessary

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: lapic: Allow user to disable adaptive tuning of timer advancement

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: lapic: Track lapic timer advance per vCPU

Liran Alon <liran.alon@oracle.com>
    KVM: x86: Consider LAPIC TSC-Deadline timer expired if deadline too short

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: lapic: Disable timer advancement if adaptive tuning goes haywire

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug caused by duplicate interface PM usage counter

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix unterminated string returned by usb_string()

Malte Leip <malte@leip.net>
    usb: usbip: fix isoc packet num validation in get_pipe

Alan Stern <stern@rowland.harvard.edu>
    USB: dummy-hcd: Fix failure to give back unlinked URBs

Alan Stern <stern@rowland.harvard.edu>
    USB: w1 ds2490: Fix bug caused by improper use of altsetting array

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Fix protection fault after device removal

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Apply the fixup for ASUS Q325UAR

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Dell AIO speaker noise

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new Dell platform for headset mode

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: Prevent runtime suspend of adapter when Host Notify is required

Anson Huang <anson.huang@nxp.com>
    i2c: imx: correct the method of getting private data in notifier_call

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    i2c: synquacer: fix enumeration of slave devices

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't attempt to rename ERR_PTR() debugfs dirs

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: marvell: Clean the controller state before each operation

Douglas Anderson <dianders@chromium.org>
    mwifiex: Make resume actually do something useful again on SDIO cards

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: fix driver operation for 5350

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: memset: fix build with L1_CACHE_SHIFT != 6

Tycho Andersen <tycho@tycho.ws>
    seccomp: Make NEW_LISTENER and TSYNC flags exclusive

Kees Cook <keescook@chromium.org>
    selftests/seccomp: Prepare for exclusive seccomp flags


-------------

Diffstat:

 Documentation/driver-api/usb/power-management.rst  |  14 +-
 Makefile                                           |   4 +-
 arch/arc/lib/memset-archs.S                        |   4 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                   |   4 +-
 arch/arm/boot/dts/rk3288.dtsi                      |  12 +-
 arch/arm/mach-at91/pm.c                            |   6 +-
 arch/arm/mach-iop13xx/setup.c                      |   8 +-
 arch/arm/mach-iop13xx/tpmi.c                       |  10 +-
 arch/arm/mach-omap2/display.c                      |   4 +-
 arch/arm/plat-iop/adma.c                           |   6 +-
 arch/arm/plat-orion/common.c                       |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts     |   4 +-
 arch/arm64/kernel/sdei.c                           |   6 +
 arch/powerpc/kernel/kvm.c                          |   7 +
 arch/powerpc/mm/slice.c                            |  10 +-
 arch/riscv/include/asm/uaccess.h                   |   2 +-
 arch/sh/boards/of-generic.c                        |   4 +-
 arch/x86/events/amd/core.c                         | 111 ++++++-
 arch/x86/kernel/cpu/mce/severity.c                 |   5 +
 arch/x86/kvm/lapic.c                               |  73 +++--
 arch/x86/kvm/lapic.h                               |   4 +-
 arch/x86/kvm/svm.c                                 |  12 +-
 arch/x86/kvm/vmx/nested.c                          |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   6 +-
 arch/x86/kvm/vmx/vmx.h                             |   8 +-
 arch/x86/kvm/x86.c                                 |  15 +-
 arch/x86/kvm/x86.h                                 |   2 -
 arch/x86/mm/init.c                                 |   6 +
 arch/x86/mm/kaslr.c                                |   2 +-
 arch/x86/mm/tlb.c                                  |   2 +-
 block/blk-mq.c                                     |   5 +-
 drivers/block/null_blk_main.c                      |   5 +
 drivers/block/xsysace.c                            |   2 +
 drivers/bluetooth/btmtkuart.c                      |   2 +
 drivers/bluetooth/btusb.c                          |   2 +-
 drivers/clk/qcom/gcc-msm8998.c                     |   1 +
 drivers/clk/x86/clk-pmc-atom.c                     |  14 +-
 drivers/gpio/gpio-mxc.c                            |   5 +-
 drivers/hid/hid-core.c                             |   6 +-
 drivers/hid/hid-debug.c                            |   5 +
 drivers/hid/hid-input.c                            |   1 +
 drivers/hid/hid-logitech-hidpp.c                   |   8 +-
 drivers/hid/hid-quirks.c                           |   5 +-
 drivers/i2c/busses/i2c-imx.c                       |   4 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |   2 +-
 drivers/i2c/busses/i2c-synquacer.c                 |   2 +
 drivers/i2c/i2c-core-base.c                        |   4 +
 drivers/infiniband/core/security.c                 |  11 +-
 drivers/infiniband/core/verbs.c                    |  41 ++-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  11 +
 drivers/input/keyboard/snvs_pwrkey.c               |   6 +-
 drivers/input/touchscreen/stmfts.c                 |  30 +-
 drivers/media/i2c/ov7670.c                         |  16 +-
 drivers/mfd/twl-core.c                             |  23 ++
 drivers/mtd/nand/raw/marvell_nand.c                |  12 +-
 drivers/net/bonding/bond_sysfs_slave.c             |   4 +-
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c |   9 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |   4 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |  33 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c    |   2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |  12 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |   5 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h     |   2 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  57 +---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   1 +
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    |  22 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |  22 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |  12 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  34 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |   3 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +-
 drivers/platform/x86/intel_pmc_core.c              |   4 +-
 drivers/platform/x86/pmc_atom.c                    |  21 ++
 drivers/reset/reset-meson-audio-arb.c              |   1 +
 drivers/rtc/rtc-cros-ec.c                          |   4 +-
 drivers/rtc/rtc-da9063.c                           |   7 +
 drivers/rtc/rtc-sh.c                               |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   3 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/scsi_dh.c                             |   1 +
 drivers/scsi/storvsc_drv.c                         |  13 +-
 drivers/staging/iio/addac/adt7316.c                |  34 +-
 drivers/usb/core/driver.c                          |  13 -
 drivers/usb/core/message.c                         |   4 +-
 drivers/usb/dwc3/gadget.c                          |   2 +
 drivers/usb/gadget/udc/dummy_hcd.c                 |  19 +-
 drivers/usb/misc/yurex.c                           |   1 +
 drivers/usb/storage/realtek_cr.c                   |  13 +-
 drivers/usb/usbip/stub_rx.c                        |  12 +-
 drivers/usb/usbip/usbip_common.h                   |   7 +
 drivers/vfio/pci/vfio_pci.c                        |   4 +-
 drivers/w1/masters/ds2490.c                        |   6 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   4 +-
 fs/debugfs/inode.c                                 |  13 +-
 fs/hugetlbfs/inode.c                               |  20 +-
 fs/jffs2/readinode.c                               |   5 -
 fs/jffs2/super.c                                   |   5 +-
 fs/open.c                                          |  18 +
 fs/read_write.c                                    |   5 +-
 include/linux/fs.h                                 |   4 +
 include/linux/platform_data/x86/clk-pmc-atom.h     |   3 +
 include/linux/usb.h                                |   2 -
 kernel/bpf/cpumap.c                                |  13 +-
 kernel/seccomp.c                                   |  17 +-
 mm/kmemleak.c                                      |  16 +-
 net/batman-adv/bat_v_elp.c                         |   6 +-
 net/batman-adv/bridge_loop_avoidance.c             |  16 +-
 net/batman-adv/translation-table.c                 |  32 +-
 net/mac80211/debugfs_netdev.c                      |   2 +-
 net/mac80211/key.c                                 |   9 +-
 scripts/coccinelle/api/stream_open.cocci           | 363 +++++++++++++++++++++
 security/selinux/avc.c                             |  23 +-
 security/selinux/hooks.c                           |  44 ++-
 security/selinux/include/avc.h                     |   1 +
 sound/pci/hda/patch_realtek.c                      |  13 +
 sound/soc/codecs/wm_adsp.c                         |   3 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |   2 +-
 sound/soc/sh/rcar/gen.c                            |  24 ++
 sound/soc/sh/rcar/rsnd.h                           |  27 ++
 sound/soc/sh/rcar/ssiu.c                           |  24 +-
 sound/soc/soc-pcm.c                                |   7 +-
 sound/soc/stm/stm32_sai_sub.c                      |   2 +-
 sound/soc/sunxi/sun50i-codec-analog.c              |   4 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |  34 +-
 132 files changed, 1343 insertions(+), 429 deletions(-)


