Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4AE106D07
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbfKVK5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:57:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730640AbfKVK5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67CFD20715;
        Fri, 22 Nov 2019 10:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420220;
        bh=P+hibzYKFkCWX2CB20Qu+jIcxxL08AOPDANBGi6Bkr8=;
        h=From:To:Cc:Subject:Date:From;
        b=b3Qets0h//dgnQVwGAm0joGTuq3YYGewZ2+kYXFgtwH0Zh+jzkJNITwQEe2votvp3
         qZ0/8uXW/odRozzejzvgXVTbYk/6wLtm4QnXh45mC0HKrlYHNBxSDcUP43ImnkdOEE
         Ak/+yDV2+dZBgcpr3efPpy+G8S6tCXt9yhw3S6qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/220] 4.19.86-stable review
Date:   Fri, 22 Nov 2019 11:26:05 +0100
Message-Id: <20191122100912.732983531@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.86-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.86-rc1
X-KernelTest-Deadline: 2019-11-24T10:09+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.86 release.
There are 220 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.86-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.86-rc1

Reinette Chatre <reinette.chatre@intel.com>
    x86/resctrl: Fix rdt_find_domain() return value and checks

Takeshi Saito <takeshi.saito.xv@renesas.com>
    mmc: tmio: fix SCC error handling to avoid false positive CRC error

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/time: Fix clockevent_decrementer initalisation for PR KVM

Alan Mikhak <alan.mikhak@sifive.com>
    tools: PCI: Fix broken pcitest compilation

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    PM / devfreq: Fix static checker warning in try_then_request_governor

Hans de Goede <hdegoede@redhat.com>
    ACPI / LPSS: Use acpi_lpss_* instead of acpi_subsys_* functions for hibernate

Yuchung Cheng <ycheng@google.com>
    tcp: start receiver buffer autotuning sooner

Roger Quadros <rogerq@ti.com>
    ARM: dts: omap5: Fix dual-role mode on Super-Speed port

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_switchdev: Check notification relevance based on upper device

Huibin Hong <huibin.hong@rock-chips.com>
    spi: rockchip: initialize dma_slave_config properly

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix sampling/reporting of CCK rates in HT mode

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix CCK rate group streams value

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix using short preamble CCK rates on HT clients

zhong jiang <zhongjiang@huawei.com>
    misc: cxl: Fix possible null pointer dereference

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_compat: do not dump private area

Eric Dumazet <edumazet@google.com>
    net: sched: avoid writing on noop_qdisc

Petr Machata <petrm@mellanox.com>
    selftests: forwarding: Have lldpad_app_wait_set() wait for unknown, too

Kun Yi <kunyi@google.com>
    hwmon: (npcm-750-pwm-fan) Change initial pwm target to 255

Nicolin Chen <nicoleotsuka@gmail.com>
    hwmon: (ina3221) Fix INA3221_CONFIG_MODE macros

Thierry Reding <treding@nvidia.com>
    hwmon: (pwm-fan) Silence error on probe deferral

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775) Fix names of DIMM temperature sources

Guenter Roeck <linux@roeck-us.net>
    hwmon: (k10temp) Support all Family 15h Model 6xh and Model 7xh processors

Colin Ian King <colin.king@canonical.com>
    scsi: arcmsr: clean up clang warning on extraneous parentheses

Linus Walleij <linus.walleij@linaro.org>
    pinctrl: gemini: Fix up TVC clock group

Colin Ian King <colin.king@canonical.com>
    orangefs: rate limit the client not running info message

Thomas Gleixner <tglx@linutronix.de>
    x86/mm: Do not warn about PCI BIOS W+X mappings

Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
    ARM: 8802/1: Call syscall_trace_exit even when system call skipped

Trent Piepho <tpiepho@impinj.com>
    spi: spidev: Fix OF tree warning logic

Linus Walleij <linus.walleij@linaro.org>
    pinctrl: gemini: Mask and set properly

Hieu Tran Dang <dangtranhieu2012@gmail.com>
    spi: fsl-lpspi: Prevent FIFO under/overrun by default

Marek Vasut <marex@denx.de>
    gpio: syscon: Fix possible NULL ptr usage

Jesper Dangaard Brouer <brouer@redhat.com>
    net: fix generic XDP to handle if eth header was mangled

Wenwen Wang <wang6495@umn.edu>
    bpf: btf: Fix a missing check bug

Bjorn Helgaas <bhelgaas@google.com>
    x86/kexec: Correct KEXEC_BACKUP_SRC_END off-by-one error

Zhoujie Wu <zjwu@marvell.com>
    lightnvm: pblk: consider max hw sectors supported for max_write_pgs

Wei Yongjun <weiyongjun1@huawei.com>
    lightnvm: pblk: fix error handling of pblk_lines_init()

Javier González <javier@javigon.com>
    lightnvm: do no update csecs and sos on 1.2

Javier González <javier@javigon.com>
    lightnvm: pblk: guarantee mw_cunits on read buffer

Hans Holmberg <hans.holmberg@cnexlabs.com>
    lightnvm: pblk: fix write amplificiation calculation

Javier González <javier@javigon.com>
    lightnvm: pblk: guarantee emeta on line close

Matias Bjørling <mb@lightnvm.io>
    lightnvm: pblk: fix incorrect min_write_pgs

Matias Bjørling <mb@lightnvm.io>
    lightnvm: pblk: fix rqd.error return value in pblk_blk_erase_sync

Connor McAdams <conmanx360@gmail.com>
    ALSA: hda/ca0132 - Fix input effect controls for desktop cards

Vikash Garodia <vgarodia@codeaurora.org>
    media: venus: vdec: fix decoded data size

Colin Ian King <colin.king@canonical.com>
    media: cx231xx: fix potential sign-extension overflow on large shift

Tim Smith <tim.smith@citrix.com>
    GFS2: Flush the GFS2 delete workqueue before stopping the kernel threads

Wenwen Wang <wang6495@umn.edu>
    media: isif: fix a NULL pointer dereference bug

He Zhe <zhe.he@windriver.com>
    printk: Give error on attempt to set log buffer length to over 2G

Vignesh R <vigneshr@ti.com>
    mfd: ti_am335x_tscadc: Keep ADC interface on if child is wakeup capable

Nathan Chancellor <natechancellor@gmail.com>
    backlight: lm3639: Unconditionally call led_classdev_unregister

Borislav Petkov <bp@suse.de>
    proc/vmcore: Fix i386 build error of missing copy_oldmem_page_encrypted()

Vasily Gorbik <gor@linux.ibm.com>
    s390/kasan: avoid user access code instrumentation

Vasily Gorbik <gor@linux.ibm.com>
    s390/kasan: avoid instrumentation of early C code

Vasily Gorbik <gor@linux.ibm.com>
    s390/kasan: avoid vdso instrumentation

Ludovic Barre <ludovic.barre@st.com>
    mmc: mmci: expand startbiterr to irqmask and error check

Reinette Chatre <reinette.chatre@intel.com>
    x86/intel_rdt: CBM overlap should also check for overlap with CDP peer

Reinette Chatre <reinette.chatre@intel.com>
    x86/intel_rdt: Introduce utility to obtain CDP peer

Yogesh Gaur <yogeshnarayan.gaur@nxp.com>
    mtd: devices: m25p80: Make sure WRITE_EN is issued before each write

Nathan Chancellor <natechancellor@gmail.com>
    mtd: spi-nor: cadence-quadspi: Use proper enum for dma_[un]map_single

Nathan Chancellor <natechancellor@gmail.com>
    media: cx18: Don't check for address of video_dev

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: dw9807-vcm: Fix probe error handling

Rajmohan Mani <rajmohan.mani@intel.com>
    media: dw9714: Fix error handling in probe function

Nathan Chancellor <natechancellor@gmail.com>
    platform/x86: mlx-platform: Properly use mlxplat_mlxcpld_msn201x_items

Shenghui Wang <shhuiw@foxmail.com>
    bcache: recal cached_dev_sectors on detach

Shenghui Wang <shhuiw@foxmail.com>
    bcache: account size of buckets used in uuid write to ca->meta_sectors_written

Geert Uytterhoeven <geert+renesas@glider.be>
    reset: Fix potential use-after-free in __of_reset_control_get()

Randy Dunlap <rdunlap@infradead.org>
    fbdev: fix broken menu dependencies

Dan Carpenter <dan.carpenter@oracle.com>
    fbdev: sbuslib: integer overflow in sbusfb_ioctl_helper()

Dan Carpenter <dan.carpenter@oracle.com>
    fbdev: sbuslib: use checked version of put_user()

Sam Ravnborg <sam@ravnborg.org>
    atmel_lcdfb: support native-mode display-timings

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    mmc: renesas_sdhi_internal_dmac: set scatter/gather max segment size

Masaharu Hayakawa <masaharu.hayakawa.ry@renesas.com>
    mmc: tmio: Fix SCC error detection

Fabrizio Castro <fabrizio.castro@bp.renesas.com>
    mmc: renesas_sdhi_internal_dmac: Whitelist r8a774a1

Andy Lutomirski <luto@kernel.org>
    x86/fsgsbase/64: Fix ptrace() to read the FS/GS base accurately

Björn Töpel <bjorn.topel@intel.com>
    xsk: proper AF_XDP socket teardown ordering

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: don't send keys when entering D3

Ronald Tschalär <ronald@innovation.ch>
    ACPI / SBS: Fix rare oops when removing modules

Li RongQing <lirongqing@baidu.com>
    xfrm: use correct size to initialise sp->ovec

Radu Solea <radu.solea@nxp.com>
    crypto: mxs-dcp - Fix AES issues

Radu Solea <radu.solea@nxp.com>
    crypto: mxs-dcp - Fix SHA null hashes and output length

Wolfram Sang <wsa+renesas@sang-engineering.com>
    dmaengine: rcar-dmac: set scatter/gather max segment size

Borislav Petkov <bp@suse.de>
    x86/olpc: Fix build error with CONFIG_MFD_CS5535=m

Lianbo Jiang <lijiang@redhat.com>
    kexec: Allocate decrypted control pages for kdump if SME is enabled

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom: q6v5: Fix a race condition on fatal crash

Suman Anna <s-anna@ti.com>
    remoteproc: Check for NULL firmwares in sysfs interface

Davide Caratti <dcaratti@redhat.com>
    tc-testing: fix build of eBPF programs

Jian Shen <shenjian15@huawei.com>
    net: hns3: Fix for rx vlan id handle to support Rev 0x21 hardware

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    soc: fsl: bman_portals: defer probe after bman's probe

Julian Sax <jsbc@gmx.de>
    Input: silead - try firmware reload after unsuccessful resume

Martin Kepplinger <martink@posteo.de>
    Input: st1232 - set INPUT_PROP_DIRECT property

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: zx2967: use core to detect 'no zero length' quirk

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: tegra: use core to detect 'no zero length' quirk

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: qup: use core to detect 'no zero length' quirk

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: omap: use core to detect 'no zero length' quirk

Bob Peterson <rpeterso@redhat.com>
    gfs2: slow the deluge of io error messages

Hans Verkuil <hans.verkuil@cisco.com>
    media: cec-gpio: select correct Signal Free Time

Hugues Fruchet <hugues.fruchet@st.com>
    media: ov5640: fix framerate update

Rami Rosen <ramirose@gmail.com>
    dmaengine: ioat: fix prototype of ioat_enumerate_channels

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.x: fix lock recovery during delegation recall

He Zhe <zhe.he@windriver.com>
    printk: Correct wrong casting

Florian Fainelli <f.fainelli@gmail.com>
    i2c: brcmstb: Allow enabling the driver on DSL SoCs

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: Use clk_hw API for calling clk framework from clk notifiers

Joonyoung Shim <jy0922.shim@samsung.com>
    clk: samsung: exynos5420: Define CLK_SECKEY gate clock only or Exynos5420

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: Use NOIRQ stage for Exynos5433 clocks suspend/resume

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    qtnfmac: drop error reports for out-of-bounds key indexes

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    qtnfmac: inform wireless core about supported extended capabilities

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    qtnfmac: pass sgi rate info flag to wireless core

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
    qtnfmac: request userspace to do OBSS scanning if FW can not

Chung-Hsien Hsu <stanley.hsu@cypress.com>
    brcmfmac: fix full timeout waiting for action frame on-channel tx

Chung-Hsien Hsu <stanley.hsu@cypress.com>
    brcmfmac: reduce timeout for action frame scan

Borislav Petkov <bp@suse.de>
    cpu/SMT: State SMT is disabled even with nosmt and without "=force"

Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
    mtd: physmap_of: Release resources on error

SolidHal <hal@halemmerich.com>
    usb: dwc2: disable power_down on rockchip devices

Johan Hovold <johan@kernel.org>
    USB: serial: cypress_m8: fix interrupt-out transfer length

Cameron Kaiser <spectre@floodgap.com>
    KVM: PPC: Book3S PR: Exiting split hack mode needs to fixup both PC and LR

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: return proper error when FW returns HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED

Michael Pobega <mpobega@neverware.com>
    ALSA: hda/sigmatel - Disable automute for Elo VuPoint

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: i2c: adv748x: Support probing a single output

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: rcar-vin: fix redeclaration of symbol

Nathan Chancellor <natechancellor@gmail.com>
    media: pxa_camera: Fix check for pdev->dev.of_node

Matthias Reichl <hias@horus.com>
    media: rc: ir-rc6-decoder: enable toggle bit for Kathrein RCU-676 remote

Nathan Chancellor <natechancellor@gmail.com>
    qed: Avoid implicit enum conversion in qed_ooo_submit_tx_buffers

Nathan Chancellor <natechancellor@gmail.com>
    ata: ep93xx: Use proper enums for directions

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/radix: Explicitly flush ERAT with local LPID invalidation

Anton Blanchard <anton@ozlabs.org>
    powerpc/time: Use clockevents_register_device(), fixing an issue with large decrementer

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: qdsp6: q6asm-dai: checking NULL vs IS_ERR()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: menu: Fix wakeup statistics updates for polling state

Bob Moore <robert.moore@intel.com>
    ACPICA: Never run _REG on system_memory and system_IO

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Return error on error from dev_pm_opp_get_opp_count()

Jordan Crouse <jcrouse@codeaurora.org>
    msm/gpu/a6xx: Force of_dma_configure to setup DMA for GMU

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: smem: Support rx peak for size less than 4 bytes

Nathan Chancellor <natechancellor@gmail.com>
    IB/mlx4: Avoid implicit enumerated type conversion

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Limit the size of extend sge of sq

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Bugfix for CM test

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Submit bad wr when post send wr exception

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Bugfix for reserved qp number

Zhu Yanjun <yanjun.zhu@oracle.com>
    IB/rxe: avoid srq memory leak

Wei Yongjun <weiyongjun1@huawei.com>
    IB/mthca: Fix error return code in __mthca_init_one()

Radoslaw Tyl <radoslawx.tyl@intel.com>
    ixgbe: Fix crash with VFs and flow director on interface flap

Nathan Chancellor <natechancellor@gmail.com>
    i40e: Use proper enum in i40e_ndo_set_vf_link_state

Radoslaw Tyl <radoslawx.tyl@intel.com>
    ixgbe: Fix ixgbe TX hangs with XDP_TX beyond queue limit

NeilBrown <neilb@suse.com>
    md: allow metadata updates while suspending an array - fix

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Fix forward to queue group logic

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    clocksource/drivers/sh_cmt: Fix clocksource width for 32-bit machines

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    clocksource/drivers/sh_cmt: Fixup for 64-bit machines

Gustavo Pimentel <gustavo.pimentel@synopsys.com>
    tools: PCI: Fix compilation warnings

Chen Yu <yu.c.chen@intel.com>
    PM / hibernate: Check the success of generating md5 digest before hibernation

Nathan Chancellor <natechancellor@gmail.com>
    mtd: rawnand: sh_flctl: Use proper enum for flctl_dma_fifo0_transfer

Tudor Ambarus <tudor.ambarus@microchip.com>
    ARM: dts: at91: sama5d2_ptc_ek: fix bootloader env offsets

Tudor Ambarus <tudor.ambarus@microchip.com>
    ARM: dts: at91: at91sam9x5cm: fix addressable nand flash size

Tudor Ambarus <tudor.ambarus@microchip.com>
    ARM: dts: at91: sama5d4_xplained: fix addressable nand flash size

zhong jiang <zhongjiang@huawei.com>
    powerpc/xive: Move a dereference below a NULL test

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/pseries: Fix how we iterate over the DTL entries

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/pseries: Fix DTL buffer registration

Nathan Chancellor <natechancellor@gmail.com>
    cxgb4: Use proper enum in IEEE_FAUX_SYNC

Nathan Chancellor <natechancellor@gmail.com>
    cxgb4: Use proper enum in cxgb4_dcb_handle_fw_update

Dan Carpenter <dan.carpenter@oracle.com>
    mei: samples: fix a signedness bug in amt_host_if_call()

Jon Derrick <jonathan.derrick@intel.com>
    x86/PCI: Apply VMD's AERSID fixup generically

Chuck Lever <chuck.lever@oracle.com>
    sunrpc: Fix connect metrics

Nishanth Menon <nm@ti.com>
    clk: keystone: Enable TISCI clocks if K3_ARCH

Gabriel Krisman Bertazi <krisman@collabora.co.uk>
    ext4: fix build error when DX_DEBUG is defined

Keyon Jie <yang.jie@linux.intel.com>
    ALSA: hda: Fix mismatch for register mask and value in ext controller.

Nathan Chancellor <natechancellor@gmail.com>
    dmaengine: timb_dma: Use proper enum in td_prep_slave_sg

Nathan Chancellor <natechancellor@gmail.com>
    dmaengine: ep93xx: Return proper enum in ep93xx_dma_chan_direction

Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
    printk: CON_PRINTBUFFER console registration is a bit racy

Petr Mladek <pmladek@suse.com>
    printk: Do not miss new messages when replaying the log

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Inform the userspace about TCE update failures

Guenter Roeck <linux@roeck-us.net>
    watchdog: w83627hf_wdt: Support NCT6796D, NCT6797D, NCT6798D

Romain Izard <romain.izard.pro@gmail.com>
    watchdog: sama5d4: fix timeout-sec usage

Wolfram Sang <wsa+renesas@sang-engineering.com>
    watchdog: renesas_wdt: stop when unregistering

Wolfram Sang <wsa+renesas@sang-engineering.com>
    watchdog: core: fix null pointer dereference when releasing cdev

Miquel Raynal <miquel.raynal@bootlin.com>
    irqchip/irq-mvebu-icu: Fix wrong private data retrieval

Andrew Zaborowski <andrew.zaborowski@intel.com>
    nl80211: Fix a GET_KEY reply attribute

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Check ENBLSLPM before sending ep command

Jia-Ju Bai <baijiaju1990@gmail.com>
    usb: gadget: udc: fotg210-udc: Fix a sleep-in-atomic-context bug in fotg210_get_status()

Vakul Garg <vakul.garg@nxp.com>
    selftests/tls: Fix recv(MSG_PEEK) & splice() test cases

Simon Wunderlich <sw@simonwunderlich.de>
    ath9k: fix reporting calculated new FFT upper max

Vincent Donnefort <vincent.donnefort@arm.com>
    PM / devfreq: stopping the governor before device_unregister()

Matthias Kaehlcke <mka@chromium.org>
    PM / devfreq: Fix handling of min/max_freq == 0

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    PM / devfreq: Fix devfreq_add_device() when drivers are built as modules.

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Allow using driver or DSL SoCs

Nathan Chancellor <natechancellor@gmail.com>
    rtlwifi: btcoex: Use proper enumerated types for Wi-Fi only interface

Ben Greear <greearb@candelatech.com>
    ath10k: fix vdev-start timeout on error

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/numa: Report correct memblock range for the dummy node

Suzuki K Poulose <suzuki.poulose@arm.com>
    kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table

Zhen Lei <thunder.leizhen@huawei.com>
    iommu/arm-smmu-v3: Fix unexpected CMD_SYNC timeout

Robin Murphy <robin.murphy@arm.com>
    iommu/io-pgtable-arm: Fix race handling in split_blk_unmap()

Felix Fietkau <nbd@nbd.name>
    mt76: fix handling ps-poll frames

Felix Fietkau <nbd@nbd.name>
    mt76x2: disable WLAN core before probe

Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
    mt76x2: fix tx power configuration for VHT mcs 9

Dennis Dalessandro <dennis.dalessandro@intel.com>
    IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds

Michael J. Ruhl <michael.j.ruhl@intel.com>
    IB/hfi1: Error path MAD response size is incorrect

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: keep lazytime on remount

Hans de Goede <hdegoede@redhat.com>
    ACPI / LPSS: Resume BYT/CHT I2C controllers from resume_noirq

Hans de Goede <hdegoede@redhat.com>
    ACPI / LPSS: Make acpi_lpss_find_device() also find PCI devices

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix priority queue fairness

Yuchung Cheng <ycheng@google.com>
    tcp: up initial rmem to 128KB and SYN rwin to around 64KB

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun8i: h3: bpi-m2-plus: Fix address for external RGMII Ethernet PHY

Philipp Rossak <embed3d@gmail.com>
    ARM: dts: sun8i: h3-h5: ir register size should be the whole memory block

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: return correct errno in f2fs_gc

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: Fix loss of coal configuration while doing reset

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: Fix for netdev not up problem when setting mtu

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: omap5: enable OTG role for DWC3 controller

Vignesh R <vigneshr@ti.com>
    ARM: dts: dra7: Enable workaround for errata i870 in PCIe host mode

YueHaibing <yuehaibing@huawei.com>
    net: xen-netback: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: ovs: fix return type of ndo_start_xmit function

Wang YanQing <udknight@gmail.com>
    bpf, x32: Fix bug for BPF_JMP | {BPF_JSGT, BPF_JSLE, BPF_JSLT, BPF_JSGE}

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_K shift by 0

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_X shift by 0

Wang YanQing <udknight@gmail.com>
    bpf, x32: Fix bug for BPF_ALU64 | BPF_NEG

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbdev: Ditch fb_edid_add_monspecs

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: fix updating the node span

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: don't access uninitialized memmaps in shrink_pgdat_span()

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: Fix idr_get_next race with idr_remove

Dan Carpenter <dan.carpenter@oracle.com>
    net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "OPP: Protect dev_list with opp_table lock"

Julia Lawall <Julia.Lawall@lip6.fr>
    tee: optee: add missing of_node_put after of_device_is_available

Hsin-Yi Wang <hsinyi@chromium.org>
    i2c: mediatek: modify threshold passed to i2c_get_dma_safe_msg_buf()

Leilk Liu <leilk.liu@mediatek.com>
    spi: mediatek: use correct mata->xfer_len when in fifo transfer


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts          |   8 +-
 arch/arm/boot/dts/at91-sama5d4_xplained.dts        |   2 +-
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |   2 +-
 arch/arm/boot/dts/dra7.dtsi                        |   2 +
 arch/arm/boot/dts/omap5-board-common.dtsi          |   5 +
 arch/arm/boot/dts/sun8i-h3-bananapi-m2-plus.dts    |   2 +-
 arch/arm/boot/dts/sunxi-h3-h5.dtsi                 |   2 +-
 arch/arm/kernel/entry-common.S                     |   9 +-
 arch/arm64/lib/clear_user.S                        |   1 +
 arch/arm64/lib/copy_from_user.S                    |   1 +
 arch/arm64/lib/copy_in_user.S                      |   1 +
 arch/arm64/lib/copy_to_user.S                      |   1 +
 arch/arm64/mm/numa.c                               |   2 +-
 arch/powerpc/kernel/time.c                         |  19 +-
 arch/powerpc/kvm/book3s.c                          |   3 +
 arch/powerpc/kvm/book3s_64_vio.c                   |   8 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c                |   6 +-
 arch/powerpc/mm/tlb-radix.c                        |   1 +
 arch/powerpc/platforms/pseries/dtl.c               |   4 +-
 arch/powerpc/sysdev/xive/common.c                  |   7 +-
 arch/s390/boot/Makefile                            |   1 +
 arch/s390/boot/compressed/Makefile                 |   1 +
 arch/s390/kernel/Makefile                          |   2 +
 arch/s390/kernel/vdso32/Makefile                   |   3 +-
 arch/s390/kernel/vdso64/Makefile                   |   3 +-
 arch/s390/lib/Makefile                             |   4 +
 arch/x86/Kconfig                                   |   3 +-
 arch/x86/include/asm/kexec.h                       |   2 +-
 arch/x86/kernel/cpu/intel_rdt.c                    |   2 +-
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c        |   2 +-
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c           | 112 ++++-
 arch/x86/kernel/ptrace.c                           |  62 ++-
 arch/x86/mm/dump_pagetables.c                      |  35 +-
 arch/x86/net/bpf_jit_comp32.c                      | 524 ++++++++-------------
 arch/x86/pci/fixup.c                               |  12 +-
 arch/x86/power/hibernate_64.c                      |  11 +-
 drivers/acpi/acpi_lpss.c                           |  74 ++-
 drivers/acpi/acpica/acevents.h                     |   2 +
 drivers/acpi/acpica/aclocal.h                      |   2 +-
 drivers/acpi/acpica/evregion.c                     |  17 +-
 drivers/acpi/acpica/evrgnini.c                     |   6 +-
 drivers/acpi/acpica/evxfregn.c                     |   1 -
 drivers/acpi/osl.c                                 |   1 +
 drivers/acpi/sbshc.c                               |   2 +
 drivers/ata/Kconfig                                |   3 +-
 drivers/ata/pata_ep93xx.c                          |   8 +-
 drivers/clk/Makefile                               |   1 +
 drivers/clk/keystone/Kconfig                       |   2 +-
 drivers/clk/samsung/clk-cpu.c                      |   6 +-
 drivers/clk/samsung/clk-cpu.h                      |   2 +-
 drivers/clk/samsung/clk-exynos5420.c               |   3 +-
 drivers/clk/samsung/clk-exynos5433.c               |   2 +-
 drivers/clocksource/sh_cmt.c                       |  78 ++-
 drivers/cpuidle/governors/menu.c                   |  10 +
 drivers/cpuidle/poll_state.c                       |   6 +-
 drivers/crypto/mxs-dcp.c                           |  80 +++-
 drivers/devfreq/devfreq.c                          | 104 +++-
 drivers/dma/ioat/init.c                            |   7 +-
 drivers/dma/sh/rcar-dmac.c                         |   3 +
 drivers/dma/timb_dma.c                             |   2 +-
 drivers/gpio/gpio-syscon.c                         |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   2 +-
 drivers/hwmon/ina3221.c                            |   6 +-
 drivers/hwmon/k10temp.c                            |   5 +-
 drivers/hwmon/nct6775.c                            |  16 +-
 drivers/hwmon/npcm750-pwm-fan.c                    |   2 +-
 drivers/hwmon/pwm-fan.c                            |   8 +-
 drivers/i2c/busses/Kconfig                         |   7 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   8 +-
 drivers/i2c/busses/i2c-omap.c                      |   8 +-
 drivers/i2c/busses/i2c-qup.c                       |  14 +-
 drivers/i2c/busses/i2c-tegra.c                     |   4 +-
 drivers/i2c/busses/i2c-zx2967.c                    |   8 +-
 drivers/infiniband/hw/hfi1/mad.c                   |   4 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   2 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   4 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   2 +
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  29 +-
 drivers/infiniband/hw/mthca/mthca_main.c           |   3 +-
 drivers/infiniband/sw/rxe/rxe_srq.c                |  10 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |   3 +-
 drivers/input/touchscreen/silead.c                 |  13 +
 drivers/input/touchscreen/st1232.c                 |   1 +
 drivers/iommu/arm-smmu-v3.c                        |   8 +-
 drivers/iommu/io-pgtable-arm.c                     |   9 +-
 drivers/irqchip/irq-mvebu-icu.c                    |   2 +-
 drivers/lightnvm/pblk-core.c                       |  32 +-
 drivers/lightnvm/pblk-init.c                       |  10 +-
 drivers/lightnvm/pblk-sysfs.c                      |   3 +-
 drivers/md/bcache/super.c                          |   6 +
 drivers/md/md.c                                    |  22 +-
 drivers/media/cec/cec-pin.c                        |  20 +
 drivers/media/i2c/adv748x/adv748x-core.c           |  25 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c           |  18 +-
 drivers/media/i2c/adv748x/adv748x.h                |   2 +
 drivers/media/i2c/dw9714.c                         |   3 +-
 drivers/media/i2c/dw9807-vcm.c                     |   3 +-
 drivers/media/i2c/ov5640.c                         |   7 +-
 drivers/media/pci/cx18/cx18-driver.c               |   2 +-
 drivers/media/platform/davinci/isif.c              |   3 +-
 drivers/media/platform/pxa_camera.c                |   2 +-
 drivers/media/platform/qcom/venus/vdec.c           |   3 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   1 -
 drivers/media/rc/ir-rc6-decoder.c                  |   9 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   2 +-
 drivers/mfd/ti_am335x_tscadc.c                     |  13 +
 drivers/misc/cxl/guest.c                           |   2 -
 drivers/mmc/host/mmci.c                            |  27 +-
 drivers/mmc/host/mmci.h                            |   6 +-
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |   9 +
 drivers/mmc/host/tmio_mmc_core.c                   |   5 +-
 drivers/mtd/devices/m25p80.c                       |  23 +-
 drivers/mtd/maps/physmap_of_core.c                 |  27 +-
 drivers/mtd/nand/raw/sh_flctl.c                    |   4 +-
 drivers/mtd/spi-nor/cadence-quadspi.c              |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c     |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h     |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 109 ++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |  14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  24 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   9 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |  13 +-
 drivers/net/usb/cdc_ncm.c                          |   2 +-
 drivers/net/wireless/ath/ath10k/core.h             |   1 +
 drivers/net/wireless/ath/ath10k/mac.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  19 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   8 +-
 drivers/net/wireless/ath/ath9k/common-spectral.c   |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  26 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   4 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   6 +
 .../wireless/mediatek/mt76/mt76x2_init_common.c    |   4 +
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c    |   1 +
 .../net/wireless/mediatek/mt76/mt76x2_phy_common.c |   4 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  25 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   6 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  16 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   1 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |   2 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |   6 +-
 drivers/net/xen-netback/interface.c                |   3 +-
 drivers/nvme/host/lightnvm.c                       |   3 +
 drivers/opp/core.c                                 |  23 +-
 drivers/opp/cpu.c                                  |   2 -
 drivers/opp/opp.h                                  |   2 +-
 drivers/pinctrl/pinctrl-gemini.c                   |  47 +-
 drivers/platform/x86/mlx-platform.c                |   2 +-
 drivers/remoteproc/qcom_q6v5.c                     |   3 +-
 drivers/remoteproc/remoteproc_sysfs.c              |   5 +
 drivers/reset/core.c                               |  15 +-
 drivers/rpmsg/qcom_glink_smem.c                    |  12 +-
 drivers/s390/char/Makefile                         |   1 +
 drivers/scsi/arcmsr/arcmsr_hba.c                   |   6 +-
 drivers/soc/fsl/qbman/bman_portal.c                |  10 +-
 drivers/spi/spi-fsl-lpspi.c                        |   2 +-
 drivers/spi/spi-mt65xx.c                           |   4 +-
 drivers/spi/spi-rockchip.c                         |   3 +
 drivers/spi/spidev.c                               |   8 +-
 drivers/tee/optee/core.c                           |   4 +-
 drivers/usb/dwc2/params.c                          |   1 +
 drivers/usb/dwc3/gadget.c                          |  29 +-
 drivers/usb/gadget/udc/fotg210-udc.c               |   2 +-
 drivers/usb/serial/cypress_m8.c                    |   2 +-
 drivers/video/backlight/lm3639_bl.c                |   6 +-
 drivers/video/fbdev/Kconfig                        |  34 +-
 drivers/video/fbdev/atmel_lcdfb.c                  |  43 +-
 drivers/video/fbdev/core/fbmon.c                   |  96 ----
 drivers/video/fbdev/core/modedb.c                  |  57 ---
 drivers/video/fbdev/sbuslib.c                      |  28 +-
 drivers/watchdog/renesas_wdt.c                     |   1 +
 drivers/watchdog/sama5d4_wdt.c                     |   6 +-
 drivers/watchdog/w83627hf_wdt.c                    |   8 +-
 drivers/watchdog/watchdog_dev.c                    |  10 +-
 fs/ext4/namei.c                                    |   2 +-
 fs/f2fs/gc.c                                       |   2 +-
 fs/f2fs/super.c                                    |   1 +
 fs/gfs2/incore.h                                   |   1 +
 fs/gfs2/log.c                                      |   7 +-
 fs/gfs2/super.c                                    |   2 +-
 fs/gfs2/util.c                                     |  13 +-
 fs/nfs/delegation.c                                |   6 +-
 fs/orangefs/orangefs-sysfs.c                       |   2 +-
 fs/proc/vmcore.c                                   |  10 +
 include/linux/cpuidle.h                            |   1 +
 include/linux/fb.h                                 |   3 -
 include/linux/platform_data/dma-ep93xx.h           |   2 +-
 include/linux/sunrpc/sched.h                       |   2 -
 include/rdma/ib_verbs.h                            |   2 +-
 kernel/bpf/btf.c                                   |   3 +
 kernel/cpu.c                                       |   1 +
 kernel/kexec_core.c                                |   6 +
 kernel/printk/printk.c                             |  42 +-
 lib/idr.c                                          |  15 +-
 mm/memory_hotplug.c                                |  77 +--
 net/core/dev.c                                     |  14 +
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_input.c                               |  27 +-
 net/ipv4/tcp_output.c                              |  25 +-
 net/mac80211/rc80211_minstrel_ht.c                 |  20 +-
 net/netfilter/nft_compat.c                         |  24 +-
 net/openvswitch/vport-internal_dev.c               |   5 +-
 net/sched/sch_generic.c                            |  14 +-
 net/sunrpc/sched.c                                 | 109 +++--
 net/sunrpc/xprt.c                                  |  14 +-
 net/sunrpc/xprtrdma/transport.c                    |   6 +-
 net/sunrpc/xprtsock.c                              |  10 +-
 net/wireless/nl80211.c                             |   2 +-
 net/xdp/xdp_umem.c                                 |  11 +-
 net/xdp/xsk.c                                      |  13 +-
 net/xfrm/xfrm_input.c                              |   2 +-
 samples/mei/mei-amt-version.c                      |   2 +-
 sound/hda/ext/hdac_ext_controller.c                |  22 +-
 sound/pci/hda/patch_ca0132.c                       |   8 +-
 sound/pci/hda/patch_sigmatel.c                     |  20 +
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |   5 +-
 tools/pci/pcitest.c                                |   7 +-
 tools/testing/radix-tree/idr-test.c                |  52 ++
 tools/testing/selftests/net/forwarding/lib.sh      |   2 +-
 tools/testing/selftests/net/tls.c                  |  20 +-
 tools/testing/selftests/tc-testing/bpf/Makefile    |  29 ++
 tools/testing/selftests/tc-testing/bpf/action.c    |  23 +
 .../selftests/tc-testing/tc-tests/actions/bpf.json |  16 +-
 tools/testing/selftests/tc-testing/tdc_config.py   |   4 +-
 virt/kvm/arm/mmu.c                                 |   3 +-
 229 files changed, 1885 insertions(+), 1392 deletions(-)


