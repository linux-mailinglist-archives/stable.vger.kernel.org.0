Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2472660B9F6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiJXUXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbiJXUW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:22:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFDD804B3;
        Mon, 24 Oct 2022 11:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E639AB81366;
        Mon, 24 Oct 2022 12:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCC9C433D6;
        Mon, 24 Oct 2022 12:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613810;
        bh=JkpP0RC9CjlJmCLmMjLGy+QGCKsQmR6fba69lusUleE=;
        h=From:To:Cc:Subject:Date:From;
        b=JavhQ9/nFfIaE+nS+9Cp/tGD79wODYATTOflu0nOwTe0rGVmwW3ji68LXY9TjI38P
         fproxFseavXeyzXRSZh3CDWNzx2bwwEcB2gucXo3DVr0IZoIUxVhLJrWX/m8msN7xY
         IP6pZYo/A6NjIx6XA3R/NdSnOj0CW7gcWo+2kSMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.10 000/390] 5.10.150-rc1 review
Date:   Mon, 24 Oct 2022 13:26:37 +0200
Message-Id: <20221024113022.510008560@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.150-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.150-rc1
X-KernelTest-Deadline: 2022-10-26T11:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.150 release.
There are 390 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.150-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.150-rc1

Martin Liska <mliska@suse.cz>
    gcov: support GCC 12.1 and newer compilers

Chao Yu <chao@kernel.org>
    f2fs: fix wrong condition to trigger background checkpoint correctly

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: intel_powerclamp: Use first online CPU as control_cpu

Eric Dumazet <edumazet@google.com>
    inet: fully convert sk->sk_rx_dst to RCU rules

Jerry Lee 李修賢 <jerrylee@qnap.com>
    ext4: continue to expand file system when the target size doesn't reach

Shuah Khan <skhan@linuxfoundation.org>
    Revert "drm/amdgpu: use dirty framebuffer helper"

Shuah Khan <skhan@linuxfoundation.org>
    Revert "drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega"

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net/ieee802154: don't warn zero-sized raw_sendmsg()

Alexander Aring <aahringo@redhat.com>
    Revert "net/ieee802154: reject zero-sized raw_sendmsg()"

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: return -EINVAL for unknown addr type

Liu Shixin <liushixin2@huawei.com>
    mm: hugetlb: fix UAF in hugetlb_handle_userfault

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/af_unix: defer registered files gc to io_uring release

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: correct pinned_vm accounting

Sergey Shtylyov <s.shtylyov@omp.ru>
    arm64: topology: fix possible overflow in amu_fie_setup()

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc

Maxime Ripard <maxime@cerno.tech>
    clk: bcm2835: Make peripheral PLLC critical

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: idmouse: fix an uninit-value in idmouse_open

Varun Prakash <varun@chelsio.com>
    nvmet-tcp: add bounds check on Transfer Tag

Keith Busch <kbusch@kernel.org>
    nvme: copy firmware_rev on each init

Xiaoke Wang <xkernel.wang@foxmail.com>
    staging: rtl8723bs: fix a potential memory leak in rtw_init_cmd_priv()

sunghwan jung <onenowy@gmail.com>
    Revert "usb: storage: Add quirk for Samsung Fit flash"

Robin Guo <guoweibin@inspur.com>
    usb: musb: Fix musb_gadget.c rxstate overflow bug

Jianglei Nie <niejianglei2021@163.com>
    usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()

Logan Gunthorpe <logang@deltatee.com>
    md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d

Hyunwoo Kim <imv4bel@gmail.com>
    HID: roccat: Fix use-after-free in roccat_read()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: intel: fix error handling on dai registration issues

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Don't overwrite msg->buf during write commands

Coly Li <colyli@suse.de>
    bcache: fix set_at_max_writeback_rate() for multiple attached devices

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    ata: libahci_platform: Sanity check the DT child nodes number

Yu Kuai <yukuai3@huawei.com>
    blk-throttle: prevent overflow while calculating wait time

Nam Cao <namcaov@gmail.com>
    staging: vt6655: fix potential memory leak

Wei Yongjun <weiyongjun1@huawei.com>
    power: supply: adp5061: fix out-of-bounds read in adp5061_get_chg_type()

Shigeru Yoshida <syoshida@redhat.com>
    nbd: Fix hung when signal interrupts nbd_start_device_ioctl()

Letu Ren <fantasquex@gmail.com>
    scsi: 3w-9xxx: Avoid disabling device if failing to enable it

Justin Chen <justinpopo6@gmail.com>
    usb: host: xhci-plat: suspend/resume clks for brcm

Justin Chen <justinpopo6@gmail.com>
    usb: host: xhci-plat: suspend and resume clocks

Quanyang Wang <quanyang.wang@windriver.com>
    clk: zynqmp: pll: rectify rate rounding in zynqmp_pll_round_rate

Zheyu Ma <zheyuma97@gmail.com>
    media: cx88: Fix a null-ptr-deref bug in buffer_prepare()

Ian Nam <young.kwan.nam@xilinx.com>
    clk: zynqmp: Fix stack-out-of-bounds in strncpy`

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: try to fix super block errors

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    arm64: dts: imx8mq-librem5: Add bq25895 as max17055's power supply

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix validatation termination record after EXTRA_CONTEXT

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6sx: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6sll: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6sl: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6qp: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6dl: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6q: add missing properties for sram

Haibo Chen <haibo.chen@nxp.com>
    ARM: dts: imx7d-sdb: config the max pressure for tsc2046

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Remove interface for periodic interrupt 1

Khaled Almahallawy <khaled.almahallawy@intel.com>
    drm/dp: Don't rewrite link config when setting phy test pattern

Richard Acayan <mailingradian@gmail.com>
    mmc: sdhci-msm: add compatible string check for sdm670

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/meson: explicitly remove aggregate driver at module unload time

hongao <hongao@uniontech.com>
    drm/amdgpu: fix initial connector audio value

Jairaj Arava <jairaj.arava@intel.com>
    ASoC: SOF: pci: Change DMI match info to support all Chrome platforms

Hans de Goede <hdegoede@redhat.com>
    platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading

Jameson Thies <jthies@google.com>
    platform/chrome: cros_ec: Notify the PM of wake events during resume

Maya Matuszczyk <maccraft123mc@gmail.com>
    drm: panel-orientation-quirks: Add quirk for Anbernic Win600

Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
    drm/vc4: vec: Fix timings for VEC modes

Lucas Stach <l.stach@pengutronix.de>
    drm: bridge: dw_hdmi: only trigger hotplug event on link change

Vivek Kasireddy <vivek.kasireddy@intel.com>
    udmabuf: Set ubuf->sg = NULL if the creation of sg table fails

David Gow <davidgow@google.com>
    drm/amd/display: fix overflow on MIN_I64 definition

Zeng Jingxiang <linuszeng@tencent.com>
    gpu: lontium-lt9611: Fix NULL pointer dereference in lt9611_connector_init()

Javier Martinez Canillas <javierm@redhat.com>
    drm: Prevent drm_copy_field() to attempt copying a NULL pointer

Javier Martinez Canillas <javierm@redhat.com>
    drm: Use size_t type for len variable in drm_copy_field()

Jianglei Nie <niejianglei2021@163.com>
    drm/nouveau/nouveau_bo: fix potential memory leak in nouveau_bo_alloc()

Andrew Gaul <gaul@gaul.org>
    r8152: Rate limit overflow messages

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix user-after-free

Liu Jian <liujian56@huawei.com>
    net: If sock is dead don't access sock's sk_wq in sk_stream_wait_memory

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: correctly set BBP register 86 for MT7620

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: set SoC wmac clock register

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: set VGC gain for both chains of MT7620

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: bcm: check the result of can_send() in bcm_can_tx()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()

Patrick Rudolph <patrick.rudolph@9elements.com>
    regulator: core: Prevent integer underflow

Alexander Coffin <alex.coffin@matician.com>
    wifi: brcmfmac: fix use-after-free bug in brcmf_netdev_start_xmit()

Khalid Masum <khalid.masum.92@gmail.com>
    xfrm: Update ipcomp_scratches with NULL when freed

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-race around tcp_md5sig_pool_populated

Mike Pattrick <mkp@redhat.com>
    openvswitch: Fix overreporting of drops in dropwatch

Mike Pattrick <mkp@redhat.com>
    openvswitch: Fix double reporting of drops in dropwatch

Quentin Monnet <quentin@isovalent.com>
    bpftool: Clear errno after libcap's checks

Wright Feng <wright.feng@cypress.com>
    wifi: brcmfmac: fix invalid address access when enabling SCAN log level

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix use-after-free on source server when doing inter-server copy

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data

Kees Cook <keescook@chromium.org>
    x86/entry: Work around Clang __bdos() bug

Kees Cook <keescook@chromium.org>
    ARM: decompressor: Include .data.rel.ro.local

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash

Chao Qin <chao.qin@intel.com>
    powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue

Kees Cook <keescook@chromium.org>
    MIPS: BCM47XX: Cast memcmp() of function to (void *)

Arvid Norlander <lkml@vorpal.se>
    ACPI: video: Add Toshiba Satellite/Portege Z830 quirk

Zqiang <qiang1.zhang@intel.com>
    rcu-tasks: Convert RCU_LOCKDEP_WARN() to WARN_ONCE()

Michal Hocko <mhocko@suse.com>
    rcu: Back off upon fill_page_cache_func() allocation failure

Stefan Berger <stefanb@linux.ibm.com>
    selftest: tpm2: Add Client.__del__() to close /dev/tpm* handle

Chao Yu <chao@kernel.org>
    f2fs: fix to account FS_CP_DATA_IO correctly

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid REQ_TIME and CP_TIME collision

Zhang Qilong <zhangqilong3@huawei.com>
    f2fs: fix race condition on setting FI_NO_EXTENT flag

Shuai Xue <xueshuai@linux.alibaba.com>
    ACPI: APEI: do not add task_work to kernel thread to avoid memory leak

Vincent Knecht <vincent.knecht@mailoo.org>
    thermal/drivers/qcom/tsens-v0_1: Fix MSM8939 fourth sensor hw_id

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: cavium - prevent integer overflow loading firmware

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: marvell/octeontx - prevent integer overflows

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    kbuild: rpm-pkg: fix breakage when V=1 is used

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: remove the target in signal traps when interrupted

Yipeng Zou <zouyipeng@huawei.com>
    tracing: kprobe: Make gen test module work in arm and riscv

Yipeng Zou <zouyipeng@huawei.com>
    tracing: kprobe: Fix kprobe event gen test module on exit

Robin Murphy <robin.murphy@arm.com>
    iommu/iova: Fix module config properly

Damian Muszynski <damian.muszynski@intel.com>
    crypto: qat - fix DMA transfer direction

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use pre-allocated buffers in datapath

Hui Tang <tanghui20@huawei.com>
    crypto: qat - fix use of 'dma_map_single'

Peter Harliman Liem <pliem@maxlinear.com>
    crypto: inside-secure - Change swab to swab32

Koba Ko <koba.ko@canonical.com>
    crypto: ccp - Release dma channels before dmaengine unrgister

Ignat Korchagin <ignat@cloudflare.com>
    crypto: akcipher - default implementation for setting a private key

Dan Carpenter <dan.carpenter@oracle.com>
    iommu/omap: Fix buffer overflow in debugfs

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset

Kshitiz Varshney <kshitiz.varshney@nxp.com>
    hwrng: imx-rngc - Moving IRQ handler registering after imx_rngc_irq_mask_clear()

Ye Weihua <yeweihua4@huawei.com>
    crypto: hisilicon/zip - fix mismatch in get/set sgl_sge_nr

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: sahara - don't sleep when in softirq

Pali Rohár <pali@kernel.org>
    powerpc: Fix SPE Power ISA properties for e500v1 platforms

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix GENERIC_CPU build flags for PPC970 / G5

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition

Zheng Yongjun <zhengyongjun3@huawei.com>
    powerpc/powernv: add missing of_node_put() in opal_export_attrs()

Liang He <windhl@126.com>
    powerpc/pci_dn: Add missing of_node_put()

Liang He <windhl@126.com>
    powerpc/sysdev/fsl_msi: Add missing of_node_put()

Nathan Chancellor <nathan@kernel.org>
    powerpc/math_emu/efp: Include module.h

Jack Wang <jinpu.wang@ionos.com>
    mailbox: bcm-ferxrm-mailbox: Fix error check for dma_map_sg

Joel Stanley <joel@jms.id.au>
    clk: ast2600: BCLK comes from EPLL

Miaoqian Lin <linmq006@gmail.com>
    clk: ti: dra7-atl: Fix reference leak in of_dra7_atl_clk_probe

Stefan Wahren <stefan.wahren@i2se.com>
    clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clk: baikal-t1: Add SATA internal ref clock buffer

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clk: baikal-t1: Add shared xGMAC ref/ptp clocks internal parent

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clk: baikal-t1: Fix invalid xGMAC PTP clock divider

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clk: vc5: Fix 5P49V6901 outputs disabling when enabling FOD

David Collins <collinsd@codeaurora.org>
    spmi: pmic-arb: correct duplicate APID to PPID mapping logic

Dave Jiang <dave.jiang@intel.com>
    dmaengine: ioat: stop mod_timer from resurrecting deleted timer in __cleanup()

Chen-Yu Tsai <wenst@chromium.org>
    clk: mediatek: mt8183: mfgcfg: Propagate rate changes to parent

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mfd: sm501: Add check for platform_driver_register()

Dan Carpenter <dan.carpenter@oracle.com>
    mfd: fsl-imx25: Fix check for platform_get_irq() errors

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: lp8788: Fix an error handling path in lp8788_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: fsl-imx25: Fix an error handling path in mx25_tsadc_setup_irq()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: intel_soc_pmic: Fix an error handling path in intel_soc_pmic_i2c_probe()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    fsi: core: Check error number after calling ida_simple_get

Robert Marko <robimarko@gmail.com>
    clk: qcom: apss-ipq6018: mark apcs_alias0_core_clk as critical

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername()

Duoming Zhou <duoming@zju.edu.cn>
    scsi: libsas: Fix use-after-free bug in smp_execute_task_sg()

Pali Rohár <pali@kernel.org>
    serial: 8250: Fix restoring termios speed after suspend

Guilherme G. Piccoli <gpiccoli@igalia.com>
    firmware: google: Test spinlock on panic path to avoid lockups

Nam Cao <namcaov@gmail.com>
    staging: vt6655: fix some erroneous memory clean-up loops

Dongliang Mu <mudongliangabcd@gmail.com>
    phy: qualcomm: call clk_disable_unprepare in the error handling

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: disable dma rx/tx use flags in lpuart_dma_shutdown

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Toggle IER bits on only after irq has been set up

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    serial: 8250: Add an empty line and remove some useless {}

Dan Carpenter <dan.carpenter@oracle.com>
    drivers: serial: jsm: fix some leaks in probe

Albert Briscoe <albertsbriscoe@gmail.com>
    usb: gadget: function: fix dangling pnp_string in f_printer.c

Mario Limonciello <mario.limonciello@amd.com>
    xhci: Don't show warning for reinit on known broken suspend

Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
    IB: Set IOVA/LENGTH on IB_MR in core/uverbs layers

Mark Zhang <markzhang@nvidia.com>
    RDMA/cm: Use SLID in the work completion as the DLID in responder side

Logan Gunthorpe <logang@deltatee.com>
    md/raid5: Ensure stripe_fill happens on non-read IO with journal

Saurabh Sengar <ssengar@linux.microsoft.com>
    md: Replace snprintf with scnprintf

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: rawnand: meson: fix bit map use in meson_nfc_ecc_correct()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_has_dipm()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_has_ncq_autosense()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_has_devslp()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_sense_reporting_enabled() and ata_id_has_sense_reporting()

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Always consume all skbuf data in sk_data_ready() upcall.

Pali Rohár <pali@kernel.org>
    mtd: rawnand: fsl_elbc: Fix none ECC mode

William Dean <williamsukatube@gmail.com>
    mtd: devices: docg3: check the return value of devm_ioremap() in the probe

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: drop EXPORTed dynamic_debug_exec_queries

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: let query-modname override actual module name

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix module.dyndbg handling

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix static_branch manipulation

Jie Hai <haijie1@huawei.com>
    dmaengine: hisilicon: Add multi-thread support for a DMA channel

Jie Hai <haijie1@huawei.com>
    dmaengine: hisilicon: Fix CQ head update

Jie Hai <haijie1@huawei.com>
    dmaengine: hisilicon: Disable channels when unregister hisi_dma

Dan Carpenter <dan.carpenter@oracle.com>
    fpga: prevent integer overflow in dfl_feature_ioctl_set_irq()

Hangyu Hua <hbh25y@gmail.com>
    misc: ocxl: fix possible refcount leak in afu_ioctl()

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix the error caused by qp->sk

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix "kernel NULL pointer dereference" error

Miaoqian Lin <linmq006@gmail.com>
    media: xilinx: vipp: Fix refcount leak in xvip_graph_dma_init

Xu Qiang <xuqiang36@huawei.com>
    media: meson: vdec: add missing clk_disable_unprepare on error in vdec_hevc_start()

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    tty: xilinx_uartps: Fix the ignore_status

Liang He <windhl@126.com>
    media: exynos4-is: fimc-is: Add of_node_put() when breaking out of loop

Jack Wang <jinpu.wang@ionos.com>
    HSI: omap_ssi_port: Fix dma_map_sg error check

Miaoqian Lin <linmq006@gmail.com>
    HSI: omap_ssi: Fix refcount leak in ssi_probe

Miaoqian Lin <linmq006@gmail.com>
    clk: tegra20: Fix refcount leak in tegra20_clock_init

Miaoqian Lin <linmq006@gmail.com>
    clk: tegra: Fix refcount leak in tegra114_clock_init

Miaoqian Lin <linmq006@gmail.com>
    clk: tegra: Fix refcount leak in tegra210_clock_init

Liang He <windhl@126.com>
    clk: sprd: Hold reference returned by of_get_parent()

Liang He <windhl@126.com>
    clk: berlin: Add of_node_put() for of_get_parent()

Liang He <windhl@126.com>
    clk: qoriq: Hold reference returned by of_get_parent()

Liang He <windhl@126.com>
    clk: oxnas: Hold reference returned by of_get_parent()

Liang He <windhl@126.com>
    clk: meson: Hold reference returned by of_get_parent()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: common: debug: Check non-standard control requests

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: common: move function's kerneldoc next to its definition

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: common: add function to get interval expressed in us unit

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: common: Parse for USB SSP genXxY

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: ch9: Add USB 3.2 SSP attributes

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: ABI: Fix wrong format of differential capacitance channel ABI.

Nuno Sá <nuno.sa@analog.com>
    iio: inkern: only release the device node when done with it

Claudiu Beznea <claudiu.beznea@microchip.com>
    iio: adc: at91-sama5d2_adc: disable/prepare buffer on suspend/resume

Claudiu Beznea <claudiu.beznea@microchip.com>
    iio: adc: at91-sama5d2_adc: lock around oversampling and sample freq

Claudiu Beznea <claudiu.beznea@microchip.com>
    iio: adc: at91-sama5d2_adc: check return status for pressure and touch

Claudiu Beznea <claudiu.beznea@microchip.com>
    iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ARM: dts: exynos: fix polarity of VBUS GPIO of Origen

Mark Rutland <mark.rutland@arm.com>
    arm64: ftrace: fix module PLTs with mcount

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: Drop CMDLINE_* dependency on ATAGS

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ARM: dts: exynos: correct s5k6a3 reset polarity on Midas family

Dmitry Osipenko <digetx@gmail.com>
    soc/tegra: fuse: Drop Kconfig dependency on TEGRA20_APB_DMA

Randy Dunlap <rdunlap@infradead.org>
    ia64: export memory_add_physaddr_to_nid to fix cxl build error

Michael Walle <michael@walle.cc>
    ARM: dts: kirkwood: lsxl: remove first ethernet port

Michael Walle <michael@walle.cc>
    ARM: dts: kirkwood: lsxl: fix serial line

Marek Behún <kabel@kernel.org>
    ARM: dts: turris-omnia: Fix mpp26 pin name and comment

Liang He <windhl@126.com>
    soc: qcom: smem_state: Add refcounting for the 'state->of_node'

Liang He <windhl@126.com>
    soc: qcom: smsm: Fix refcount leak bugs in qcom_smsm_probe()

Liang He <windhl@126.com>
    memory: of: Fix refcount leak bug in of_lpddr3_get_ddr_timings()

Liang He <windhl@126.com>
    memory: of: Fix refcount leak bug in of_get_ddr_timings()

Liang He <windhl@126.com>
    memory: pl353-smc: Fix refcount leak bug in pl353_smc_probe()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Don't skip notification handling during PM operation

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: mt6660: Fix PM disable depth imbalance in mt6660_i2c_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: wmt-sdmmc: Fix an error handling path in wmt_mci_probe()

Andreas Pape <apape@de.adit-jv.com>
    ALSA: dmaengine: increment buffer pointer atomically

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: da7219: Fix an error handling path in da7219_register_dai_clks()

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: correct 1.62G link rate at dp_catalog_ctrl_config_msa()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: index dpu_kms->hw_vbif using vbif_idx

Liang He <windhl@126.com>
    ASoC: eureka-tlv320: Hold reference returned from of_find_xxx API

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()

Liang He <windhl@126.com>
    drm/omap: dss: Fix refcount leak bugs

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: beep: Simplify keep-power-at-enable behavior

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: rsnd: Add check for rsnd_mod_power_on

Zheyu Ma <zheyuma97@gmail.com>
    drm/bridge: megachips: Fix a null pointer dereference bug

Randy Dunlap <rdunlap@infradead.org>
    drm: fix drm_mipi_dbi build errors

Hans de Goede <hdegoede@redhat.com>
    platform/x86: msi-laptop: Fix resource cleanup

Hans de Goede <hdegoede@redhat.com>
    platform/x86: msi-laptop: Fix old-ec check for backlight registering

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Fix mute/unmute

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Drop conflicting set_bias_level power setting

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Allow mono streams

Dan Carpenter <dan.carpenter@oracle.com>
    platform/chrome: fix memory corruption in ioctl

Rustam Subkhankulov <subkhankulov@ispras.ru>
    platform/chrome: fix double-free in chromeos_laptop_prepare()

Liang He <windhl@126.com>
    drm:pl111: Add of_node_put() when breaking out of for_each_available_child_of_node()

Simon Ser <contact@emersion.fr>
    drm/dp_mst: fix drm_dp_dpcd_read return value checks

Chen-Yu Tsai <wenst@chromium.org>
    drm/bridge: parade-ps8640: Fix regulator supply order

Maxime Ripard <maxime@cerno.tech>
    drm/mipi-dsi: Detach devices when removing the host

Dan Carpenter <dan.carpenter@oracle.com>
    drm/bridge: Avoid uninitialized variable warning

Alvin Šipraga <alsi@bang-olufsen.dk>
    drm: bridge: adv7511: fix CEC power down control register offset

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: mvpp2: fix mvpp2 debugfs leak

Eric Dumazet <edumazet@google.com>
    once: add DO_ONCE_SLOW() for sleepable contexts

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net/ieee802154: reject zero-sized raw_sendmsg()

Jianglei Nie <niejianglei2021@163.com>
    bnx2x: fix potential memory leak in bnx2x_tpa_stop()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()

Marek Szyprowski <m.szyprowski@samsung.com>
    spi: Ensure that sg_table won't be used after being freed

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited

Xin Long <lucien.xin@gmail.com>
    sctp: handle the error returned from sctp_auth_asoc_init_active_key

Duoming Zhou <duoming@zju.edu.cn>
    mISDN: fix use-after-free bugs in l1oip timer handlers

Junichi Uekawa <uekawa@chromium.org>
    vhost/vsock: Use kvmalloc/kvfree for larger packets.

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix AIFS written to REG_EDCA_*_PARAM

Vincent Whitchurch <vincent.whitchurch@axis.com>
    spi: s3c64xx: Fix large transfers with DMA

Phil Sutter <phil@nwl.cc>
    netfilter: nft_fib: Fix for rpath check with VRF devices

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not handling link timeouts propertly

Asmaa Mnebhi <asmaa@nvidia.com>
    i2c: mlxbf: support lock mechanism

Zhang Qilong <zhangqilong3@huawei.com>
    spi/omap100k:Fix PM disable depth imbalance in omap1_spi100k_probe

Zhang Qilong <zhangqilong3@huawei.com>
    spi: dw: Fix PM disable depth imbalance in dw_spi_bt1_probe

Luciano Leão <lucianorsleao@gmail.com>
    x86/cpu: Include the header of init_ia32_feat_ctl()'s prototype

Kees Cook <keescook@chromium.org>
    x86/microcode/AMD: Track patch allocation size explicitly

Jesus Fernandez Manzano <jesus.manzano@galgus.net>
    wifi: ath11k: fix number of VHT beamformee spatial streams

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: hci_{ldisc,serdev}: check percpu_init_rwsem() failure

Lee Jones <lee@kernel.org>
    bpf: Ensure correct locking around vulnerable function find_vpid()

Zheng Yongjun <zhengyongjun3@huawei.com>
    net: fs_enet: Fix wrong check in do_pd_setup

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Remove copy-paste leftover in gen2_update_rate_mask

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration

Lorenz Bauer <oss@lmb.io>
    bpf: btf: fix truncated last_member_type_id in btf_struct_resolve

Neil Armstrong <narmstrong@baylibre.com>
    spi: meson-spicc: do not rely on busy flag in pow2 clk ops

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix skb misuse in TX queue selection

Xu Qiang <xuqiang36@huawei.com>
    spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()

Xu Qiang <xuqiang36@huawei.com>
    spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()

Ian Rogers <irogers@google.com>
    selftests/xsk: Avoid use-after-free on ctx

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend

Arnd Bergmann <arnd@arndb.de>
    Bluetooth: btusb: fix excessive stack usage

Mark Chen <Mark-YW.Chen@mediatek.com>
    Bluetooth: btusb: Fine-tune mt7663 mechanism.

Kohei Tarumizu <tarumizu.kohei@fujitsu.com>
    x86/resctrl: Fix to restore to original value when re-enabling hardware prefetch register

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: mt7621: Fix an error message in mt7621_spi_probe()

Lam Thai <lamthai@arista.com>
    bpftool: Fix a wrong type cast in btf_dumper_int

Hari Chandrakanthan <quic_haric@quicinc.com>
    wifi: mac80211: allow bw change during channel switch in mesh

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    leds: lm3601x: Don't use mutex after it was destroyed

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nfsd: Fix a memory leak in an error handling path

Sami Tolvanen <samitolvanen@google.com>
    objtool: Preserve special st_shndx indexes in elf_update_symbol

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9247/1: mm: set readonly for MT_MEMORY_RO with ARM_LPAE

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9244/1: dump: Fix wrong pg_level in walk_pmd()

Lin Yujun <linyujun809@huawei.com>
    MIPS: SGI-IP27: Fix platform-device leak in bridge_platform_create()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    MIPS: SGI-IP27: Free some unused memory

Kees Cook <keescook@chromium.org>
    sh: machvec: Use char[] for section boundaries

Ondrej Mosnacek <omosnace@redhat.com>
    userfaultfd: open userfaultfds with O_RDONLY

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    selinux: use "grep -E" instead of "egrep"

Steve French <stfrench@microsoft.com>
    smb3: must initialize two ACL struct fields to zero

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix watermark calculations for gen12+ MC CCS modifier

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix watermark calculations for gen12+ RC CCS modifier

Jianglei Nie <niejianglei2021@163.com>
    drm/nouveau: fix a use-after-free in nouveau_gem_prime_import_sg_table()

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv140-: Disable interlacing

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: greybus: audio_helper: remove unused and wrong debugfs usage

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Unconditionally purge queued/injected events on nested "exit"

Michal Luczaj <mhal@rbox.co>
    KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    media: cedrus: Set the platform driver data earlier

Ard Biesheuvel <ardb@kernel.org>
    efi: libstub: drop pointless get_memory_map() call

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Explicitly enable lane adapter hotplug events at startup

Waiman Long <longman@redhat.com>
    tracing: Disable interrupt or preemption before acquiring arch_spinlock_t

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Fix race between reset page and reading page

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Add ring_buffer_wake_waiters()

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Check pending waiters when doing wake ups as well

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Have the shortest_full queue be the shortest not longest

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Allow splice to read previous partially read pages

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Properly unset FTRACE_HASH_FL_MOD

Rik van Riel <riel@surriel.com>
    livepatch: fix race between fork and KLP transition

Ye Bin <yebin10@huawei.com>
    ext4: update 'state->fc_regions_size' after successful memory allocation

Ye Bin <yebin10@huawei.com>
    ext4: fix potential memory leak in ext4_fc_record_regions()

Ye Bin <yebin10@huawei.com>
    ext4: fix potential memory leak in ext4_fc_record_modified_inode()

Ye Bin <yebin10@huawei.com>
    ext4: fix miss release buffer head in ext4_fc_write_inode

Jinke Han <hanjinke.666@bytedance.com>
    ext4: place buffer head allocation before handle start

Zhang Yi <yi.zhang@huawei.com>
    ext4: ext4_read_bh_lock() should submit IO if the buffer isn't uptodate

Lukas Czerner <lczerner@redhat.com>
    ext4: don't increase iversion counter for ea_inodes

Jan Kara <jack@suse.cz>
    ext4: fix check for block being out of directory size

Lalith Rajendran <lalithkraj@google.com>
    ext4: make ext4_lazyinit_thread freezable

Baokun Li <libaokun1@huawei.com>
    ext4: fix null-ptr-deref in ext4_write_info

Jan Kara <jack@suse.cz>
    ext4: avoid crash when inline data creation follows DIO write

Ye Bin <yebin10@huawei.com>
    jbd2: add miss release buffer head in fc_do_one_pass()

Ye Bin <yebin10@huawei.com>
    jbd2: fix potential use-after-free in jbd2_fc_wait_bufs

Ye Bin <yebin10@huawei.com>
    jbd2: fix potential buffer head reference count leak

Andrew Perepechko <anserper@ya.ru>
    jbd2: wake up journal waiters in FIFO order, not LIFO

Kees Cook <keescook@chromium.org>
    hardening: Remove Clang's enable flag for -ftrivial-auto-var-init=zero

Kees Cook <keescook@chromium.org>
    hardening: Avoid harmless Clang option under CONFIG_INIT_STACK_ALL_ZERO

Kees Cook <keescook@chromium.org>
    hardening: Clarify Kconfig text for auto-var-init

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on summary info

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on destination blkaddr during recovery

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: increase the limit for reserve_root

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between quota enable and quota rescan ioctl

Hyunwoo Kim <imv4bel@gmail.com>
    fbdev: smscufx: Fix use-after-free in ufx_ops_open()

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Populate sysfs attributes for vport

Pali Rohár <pali@kernel.org>
    powerpc/boot: Explicitly disable usage of SPE instructions

Zhang Rui <rui.zhang@intel.com>
    powercap: intel_rapl: Use standard Energy Unit for SPR Dram RAPL domain

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Let drivers request full 16550A feature probing

Maciej W. Rozycki <macro@orcam.me.uk>
    PCI: Sanitise firmware BAR assignments behind a PCI-PCI bridge

Carlos Llamas <cmllamas@google.com>
    mm/mmap: undo ->mmap() when arch_validate_flags() fails

Jeffle Xu <jefflexu@linux.alibaba.com>
    block: fix inflight statistics of part0

Takashi Iwai <tiwai@suse.de>
    drm/udl: Restore display mode on resume

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Check whether transferred 2D BO is shmem

Rishabh Bhatnagar <risbhat@amazon.com>
    nvme-pci: set min_align_mask before calculating max_hw_sectors

Huacai Chen <chenhuacai@loongson.cn>
    UM: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Fangrui Song <maskray@google.com>
    riscv: Pass -mno-relax only on lld < 15.0.0

Andrew Bresticker <abrestic@rivosinc.com>
    riscv: Make VM_WRITE imply VM_READ

Andrew Bresticker <abrestic@rivosinc.com>
    riscv: Allow PROT_WRITE-only mmap()

Helge Deller <deller@gmx.de>
    parisc: fbdev/stifb: Align graphics memory size to 4MB

Maciej W. Rozycki <macro@orcam.me.uk>
    RISC-V: Make port I/O string accessors actually work

Linus Walleij <linus.walleij@linaro.org>
    regulator: qcom_rpm: Fix circular deferral regression

Liang He <windhl@126.com>
    hwmon: (gsc-hwmon) Call of_node_get() before of_find_xxx API

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: wcd934x: fix order of Slimbus unprepare/disable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: wcd9335: fix order of Slimbus unprepare/disable

Patryk Duda <pdk@semihalf.com>
    platform/chrome: cros_ec_proto: Update version on GET_NEXT_EVENT failure

Zhihao Cheng <chengzhihao1@huawei.com>
    quota: Check next/prev free block number after reading from quota file

Andri Yngvason <andri@yngvason.is>
    HID: multitouch: Add memory barriers

Alexander Aring <aahringo@redhat.com>
    fs: dlm: handle -EBUSY first in lock arg validation

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix race between test_bit() and queue_work()

Wenchao Chen <wenchao.chen@unisoc.com>
    mmc: sdhci-sprd: Fix minimum clock limit

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix CAN state after restart

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix TX queue out of sync after restart

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix overread with an invalid command

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb: Fix use of uninitialized completion

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    usb: add quirks for Lenovo OneLink+ Dock

Eddie James <eajames@linux.ibm.com>
    iio: pressure: dps310: Reset chip after timeout

Eddie James <eajames@linux.ibm.com>
    iio: pressure: dps310: Refactor startup procedure

Nuno Sá <nuno.sa@analog.com>
    iio: adc: ad7923: fix channel readings for some variants

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    iio: ltc2497: Fix reading conversion results

Michael Hennerich <michael.hennerich@analog.com>
    iio: dac: ad5593r: Fix i2c read protocol requirements

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: destage dirty pages before re-reading them for cache=none

Tudor Ambarus <tudor.ambarus@microchip.com>
    mtd: rawnand: atmel: Unmap streaming DMA mappings

Saranya Gopal <saranya.gopal@intel.com>
    ALSA: hda/realtek: Add Intel Reference SSID to support headset keys

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add quirk for ASUS GV601R laptop

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Correct pin configs for ASUS G533Z

Callum Osmotherly <callum.osmotherly@gmail.com>
    ALSA: hda/realtek: remove ALC289_FIXUP_DUAL_SPK for Dell 5530

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix NULL dererence at error path

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential memory leaks

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Drop register_mutex in snd_rawmidi_free()

Takashi Iwai <tiwai@suse.de>
    ALSA: oss: Fix potential deadlock at unregistration


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio            |   2 +-
 Makefile                                           |  10 +-
 arch/arm/Kconfig                                   |   1 -
 arch/arm/boot/compressed/vmlinux.lds.S             |   2 +
 arch/arm/boot/dts/armada-385-turris-omnia.dts      |   4 +-
 arch/arm/boot/dts/exynos4412-midas.dtsi            |   2 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |   2 +-
 arch/arm/boot/dts/imx6dl.dtsi                      |   3 +
 arch/arm/boot/dts/imx6q.dtsi                       |   3 +
 arch/arm/boot/dts/imx6qp.dtsi                      |   6 +
 arch/arm/boot/dts/imx6sl.dtsi                      |   3 +
 arch/arm/boot/dts/imx6sll.dtsi                     |   3 +
 arch/arm/boot/dts/imx6sx.dtsi                      |   6 +
 arch/arm/boot/dts/imx7d-sdb.dts                    |   7 +-
 arch/arm/boot/dts/kirkwood-lsxl.dtsi               |  16 +-
 arch/arm/mm/dump.c                                 |   2 +-
 arch/arm/mm/mmu.c                                  |   4 +
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi  |   1 +
 arch/arm64/kernel/ftrace.c                         |  17 +-
 arch/arm64/kernel/topology.c                       |   2 +-
 arch/ia64/mm/numa.c                                |   1 +
 arch/mips/bcm47xx/prom.c                           |   4 +-
 arch/mips/sgi-ip27/ip27-xtalk.c                    |  74 ++++--
 arch/powerpc/Makefile                              |   2 +-
 arch/powerpc/boot/Makefile                         |   1 +
 arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi    |  51 ++++
 arch/powerpc/boot/dts/fsl/mpc8540ads.dts           |   2 +-
 arch/powerpc/boot/dts/fsl/mpc8541cds.dts           |   2 +-
 arch/powerpc/boot/dts/fsl/mpc8555cds.dts           |   2 +-
 arch/powerpc/boot/dts/fsl/mpc8560ads.dts           |   2 +-
 arch/powerpc/kernel/pci_dn.c                       |   1 +
 arch/powerpc/math-emu/math_efp.c                   |   1 +
 arch/powerpc/platforms/powernv/opal.c              |   1 +
 arch/powerpc/sysdev/fsl_msi.c                      |   2 +
 arch/riscv/Makefile                                |   2 +
 arch/riscv/include/asm/io.h                        |  16 +-
 arch/riscv/kernel/sys_riscv.c                      |   3 -
 arch/riscv/mm/fault.c                              |   3 +-
 arch/sh/include/asm/sections.h                     |   2 +-
 arch/sh/kernel/machvec.c                           |  10 +-
 arch/um/kernel/um_arch.c                           |   2 +-
 arch/x86/include/asm/hyperv-tlfs.h                 |   4 +-
 arch/x86/include/asm/microcode.h                   |   1 +
 arch/x86/kernel/cpu/feat_ctl.c                     |   2 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   3 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c          |  12 +-
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  30 ++-
 arch/x86/kvm/vmx/vmx.c                             |  12 +-
 arch/x86/xen/enlighten_pv.c                        |   3 +-
 block/blk-mq.c                                     |   3 +-
 block/blk-throttle.c                               |   8 +-
 crypto/akcipher.c                                  |   8 +
 drivers/acpi/acpi_video.c                          |  16 ++
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/ata/libahci_platform.c                     |  14 +-
 drivers/block/nbd.c                                |   6 +-
 drivers/bluetooth/btusb.c                          |  47 +++-
 drivers/bluetooth/hci_ldisc.c                      |   7 +-
 drivers/bluetooth/hci_serdev.c                     |  10 +-
 drivers/char/hw_random/imx-rngc.c                  |  14 +-
 drivers/clk/baikal-t1/ccu-div.c                    |  65 +++++
 drivers/clk/baikal-t1/ccu-div.h                    |  10 +
 drivers/clk/baikal-t1/clk-ccu-div.c                |  26 +-
 drivers/clk/bcm/clk-bcm2835.c                      |   8 +-
 drivers/clk/berlin/bg2.c                           |   5 +-
 drivers/clk/berlin/bg2q.c                          |   6 +-
 drivers/clk/clk-ast2600.c                          |   2 +-
 drivers/clk/clk-oxnas.c                            |   6 +-
 drivers/clk/clk-qoriq.c                            |  10 +-
 drivers/clk/clk-versaclock5.c                      |   2 +-
 drivers/clk/mediatek/clk-mt8183-mfgcfg.c           |   6 +-
 drivers/clk/meson/meson-aoclk.c                    |   5 +-
 drivers/clk/meson/meson-eeclk.c                    |   5 +-
 drivers/clk/meson/meson8b.c                        |   5 +-
 drivers/clk/qcom/apss-ipq6018.c                    |   2 +-
 drivers/clk/sprd/common.c                          |   9 +-
 drivers/clk/tegra/clk-tegra114.c                   |   1 +
 drivers/clk/tegra/clk-tegra20.c                    |   1 +
 drivers/clk/tegra/clk-tegra210.c                   |   1 +
 drivers/clk/ti/clk-dra7-atl.c                      |   9 +-
 drivers/clk/zynqmp/clkc.c                          |   7 +
 drivers/clk/zynqmp/pll.c                           |  31 ++-
 drivers/crypto/cavium/cpt/cptpf_main.c             |   6 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |   6 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c          |   4 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   8 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |  18 +-
 drivers/crypto/qat/qat_common/qat_algs.c           | 109 +++++----
 drivers/crypto/qat/qat_common/qat_crypto.h         |  24 ++
 drivers/crypto/sahara.c                            |  18 +-
 drivers/dma-buf/udmabuf.c                          |   9 +-
 drivers/dma/hisi_dma.c                             |  28 +--
 drivers/dma/ioat/dma.c                             |   6 +-
 drivers/firmware/efi/libstub/fdt.c                 |   8 -
 drivers/firmware/google/gsmi.c                     |   9 +
 drivers/fpga/dfl.c                                 |   2 +-
 drivers/fsi/fsi-core.c                             |   3 +
 drivers/gpu/drm/Kconfig                            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   2 -
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |  25 ++
 drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c    |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  16 +-
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |   6 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  35 +--
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h  |   3 +-
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h  |   8 +-
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |   5 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c       |   4 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   3 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |   4 +-
 drivers/gpu/drm/bridge/parade-ps8640.c             |   4 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |  13 +-
 drivers/gpu/drm/drm_bridge.c                       |   4 +-
 drivers/gpu/drm/drm_dp_helper.c                    |   9 -
 drivers/gpu/drm/drm_dp_mst_topology.c              |   6 +-
 drivers/gpu/drm/drm_ioctl.c                        |   8 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   1 +
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/i915/intel_pm.c                    |   8 +-
 drivers/gpu/drm/meson/meson_drv.c                  |   8 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |  12 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c           |  29 +--
 drivers/gpu/drm/msm/dp/dp_catalog.c                |   2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   4 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   3 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   1 -
 drivers/gpu/drm/omapdrm/dss/dss.c                  |   3 +
 drivers/gpu/drm/pl111/pl111_versatile.c            |   1 +
 drivers/gpu/drm/udl/udl_modeset.c                  |   3 -
 drivers/gpu/drm/vc4/vc4_vec.c                      |   4 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   2 +-
 drivers/hid/hid-multitouch.c                       |   8 +-
 drivers/hid/hid-roccat.c                           |   4 +
 drivers/hsi/controllers/omap_ssi_core.c            |   1 +
 drivers/hsi/controllers/omap_ssi_port.c            |   8 +-
 drivers/hwmon/gsc-hwmon.c                          |   1 +
 drivers/i2c/busses/i2c-mlxbf.c                     |  44 +++-
 drivers/iio/adc/ad7923.c                           |   4 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |  28 ++-
 drivers/iio/adc/ltc2497.c                          |  13 +
 drivers/iio/dac/ad5593r.c                          |  46 ++--
 drivers/iio/inkern.c                               |   6 +-
 drivers/iio/pressure/dps310.c                      | 262 +++++++++++++--------
 drivers/infiniband/core/cm.c                       |  14 +-
 drivers/infiniband/core/uverbs_cmd.c               |   5 +-
 drivers/infiniband/core/verbs.c                    |   2 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   1 -
 drivers/infiniband/hw/mlx4/mr.c                    |   1 -
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  10 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |  27 ++-
 drivers/iommu/omap-iommu-debug.c                   |   6 +-
 drivers/isdn/mISDN/l1oip.h                         |   1 +
 drivers/isdn/mISDN/l1oip_core.c                    |  13 +-
 drivers/leds/leds-lm3601x.c                        |   2 -
 drivers/mailbox/bcm-flexrm-mailbox.c               |   8 +-
 drivers/md/bcache/writeback.c                      |  73 ++++--
 drivers/md/raid0.c                                 |   2 +-
 drivers/md/raid5.c                                 |  14 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |   9 +-
 drivers/media/pci/cx88/cx88-video.c                |  43 ++--
 drivers/media/platform/exynos4-is/fimc-is.c        |   1 +
 drivers/media/platform/xilinx/xilinx-vipp.c        |   9 +-
 drivers/memory/of_memory.c                         |   2 +
 drivers/memory/pl353-smc.c                         |   1 +
 drivers/mfd/fsl-imx25-tsadc.c                      |  34 ++-
 drivers/mfd/intel_soc_pmic_core.c                  |   1 +
 drivers/mfd/lp8788-irq.c                           |   3 +
 drivers/mfd/lp8788.c                               |  12 +-
 drivers/mfd/sm501.c                                |   7 +-
 drivers/misc/ocxl/file.c                           |   2 +
 drivers/mmc/host/au1xmmc.c                         |   3 +-
 drivers/mmc/host/sdhci-msm.c                       |   1 +
 drivers/mmc/host/sdhci-sprd.c                      |   2 +-
 drivers/mmc/host/wmt-sdmmc.c                       |   5 +-
 drivers/mtd/devices/docg3.c                        |   7 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   1 +
 drivers/mtd/nand/raw/fsl_elbc_nand.c               |  28 ++-
 drivers/mtd/nand/raw/meson_nand.c                  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |   2 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   3 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  79 +++++++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   1 +
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c   |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |  10 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  13 +-
 drivers/net/usb/r8152.c                            |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  54 +++--
 drivers/net/wireless/ath/ath11k/mac.c              |  25 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |  43 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |  12 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  34 ++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  75 +++++-
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/pci.c                            |   3 +-
 drivers/nvme/target/tcp.c                          |  11 +-
 drivers/pci/setup-res.c                            |  11 +
 drivers/phy/qualcomm/phy-qcom-usb-hsic.c           |   6 +-
 drivers/platform/chrome/chromeos_laptop.c          |  24 +-
 drivers/platform/chrome/cros_ec.c                  |   8 +-
 drivers/platform/chrome/cros_ec_chardev.c          |   3 +
 drivers/platform/chrome/cros_ec_proto.c            |  32 +++
 drivers/platform/x86/msi-laptop.c                  |  14 +-
 drivers/power/supply/adp5061.c                     |   6 +-
 drivers/powercap/intel_rapl_common.c               |   4 +-
 drivers/regulator/core.c                           |   2 +-
 drivers/regulator/qcom_rpm-regulator.c             |  24 +-
 drivers/scsi/3w-9xxx.c                             |   2 +-
 drivers/scsi/iscsi_tcp.c                           |  73 ++++--
 drivers/scsi/iscsi_tcp.h                           |   2 +
 drivers/scsi/libsas/sas_expander.c                 |   2 +-
 drivers/scsi/qedf/qedf_main.c                      |  21 ++
 drivers/soc/qcom/smem_state.c                      |   3 +-
 drivers/soc/qcom/smsm.c                            |  20 +-
 drivers/soc/tegra/Kconfig                          |   1 -
 drivers/soundwire/cadence_master.c                 |   9 +-
 drivers/soundwire/intel.c                          |   1 -
 drivers/spi/spi-dw-bt1.c                           |   4 +-
 drivers/spi/spi-meson-spicc.c                      |   6 +-
 drivers/spi/spi-mt7621.c                           |   8 +-
 drivers/spi/spi-omap-100k.c                        |   1 +
 drivers/spi/spi-qup.c                              |  21 +-
 drivers/spi/spi-s3c64xx.c                          |   9 +
 drivers/spi/spi.c                                  |   2 +
 drivers/spmi/spmi-pmic-arb.c                       |  13 +-
 drivers/staging/greybus/audio_helper.c             |  11 -
 drivers/staging/media/meson/vdec/vdec_hevc.c       |   6 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   4 +-
 drivers/staging/rtl8723bs/core/rtw_cmd.c           |  16 +-
 drivers/staging/vt6655/device_main.c               |   8 +-
 drivers/thermal/intel/intel_powerclamp.c           |   4 +-
 drivers/thermal/qcom/tsens-v0_1.c                  |   2 +-
 drivers/thunderbolt/switch.c                       |  24 ++
 drivers/thunderbolt/tb.h                           |   1 +
 drivers/thunderbolt/tb_regs.h                      |   1 +
 drivers/thunderbolt/usb4.c                         |  20 ++
 drivers/tty/serial/8250/8250_core.c                |  19 +-
 drivers/tty/serial/8250/8250_port.c                |  18 +-
 drivers/tty/serial/fsl_lpuart.c                    |   2 +
 drivers/tty/serial/jsm/jsm_driver.c                |   3 +-
 drivers/tty/serial/xilinx_uartps.c                 |   2 +
 drivers/usb/common/common.c                        | 102 +++++++-
 drivers/usb/common/debug.c                         |  78 ++++--
 drivers/usb/core/devices.c                         |  21 +-
 drivers/usb/core/endpoint.c                        |  35 +--
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/gadget/function/f_printer.c            |  12 +-
 drivers/usb/host/xhci-mem.c                        |   7 +-
 drivers/usb/host/xhci-plat.c                       |  18 +-
 drivers/usb/host/xhci.c                            |   3 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/misc/idmouse.c                         |   8 +-
 drivers/usb/musb/musb_gadget.c                     |   3 +
 drivers/usb/storage/unusual_devs.h                 |   6 -
 drivers/vhost/vsock.c                              |   2 +-
 drivers/video/fbdev/smscufx.c                      |  14 +-
 drivers/video/fbdev/stifb.c                        |   2 +-
 fs/btrfs/qgroup.c                                  |  15 ++
 fs/btrfs/scrub.c                                   |  36 +++
 fs/cifs/file.c                                     |   9 +
 fs/cifs/smb2pdu.c                                  |   7 +-
 fs/dlm/ast.c                                       |   6 +-
 fs/dlm/lock.c                                      |  16 +-
 fs/ext4/fast_commit.c                              |  40 ++--
 fs/ext4/file.c                                     |   6 +
 fs/ext4/inode.c                                    |  14 +-
 fs/ext4/namei.c                                    |   2 +-
 fs/ext4/resize.c                                   |   2 +-
 fs/ext4/super.c                                    |  19 +-
 fs/f2fs/checkpoint.c                               |  23 +-
 fs/f2fs/data.c                                     |   4 +-
 fs/f2fs/extent_cache.c                             |   3 +-
 fs/f2fs/f2fs.h                                     |  27 ++-
 fs/f2fs/gc.c                                       |  10 +-
 fs/f2fs/recovery.c                                 |  23 +-
 fs/f2fs/segment.c                                  |  47 ++--
 fs/f2fs/super.c                                    |   4 +-
 fs/io_uring.c                                      |   8 +-
 fs/jbd2/commit.c                                   |   2 +-
 fs/jbd2/journal.c                                  |  10 +-
 fs/jbd2/recovery.c                                 |   1 +
 fs/jbd2/transaction.c                              |   6 +-
 fs/nfsd/nfs4recover.c                              |   4 +-
 fs/nfsd/nfs4state.c                                |   5 +
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/quota/quota_tree.c                              |  38 +++
 fs/userfaultfd.c                                   |   4 +-
 include/linux/ata.h                                |  39 +--
 include/linux/dynamic_debug.h                      |  11 +-
 include/linux/iova.h                               |   2 +-
 include/linux/once.h                               |  28 +++
 include/linux/ring_buffer.h                        |   2 +-
 include/linux/serial_8250.h                        |   1 +
 include/linux/serial_core.h                        |   3 +-
 include/linux/skbuff.h                             |   2 +
 include/linux/tcp.h                                |   2 +-
 include/linux/usb/ch9.h                            |  62 +----
 include/net/ieee802154_netdev.h                    |  12 +-
 include/net/sock.h                                 |   2 +-
 include/net/tcp.h                                  |   5 +-
 include/uapi/linux/usb/ch9.h                       |  13 +
 kernel/bpf/btf.c                                   |   2 +-
 kernel/bpf/syscall.c                               |   2 +
 kernel/cgroup/cpuset.c                             |  18 +-
 kernel/gcov/gcc_4_7.c                              |  18 +-
 kernel/livepatch/transition.c                      |  18 +-
 kernel/rcu/tasks.h                                 |   2 +-
 kernel/rcu/tree.c                                  |  17 +-
 kernel/trace/ftrace.c                              |   8 +-
 kernel/trace/kprobe_event_gen_test.c               |  49 +++-
 kernel/trace/ring_buffer.c                         |  87 ++++++-
 kernel/trace/trace.c                               |  23 ++
 lib/dynamic_debug.c                                |  45 +---
 lib/once.c                                         |  30 +++
 mm/hugetlb.c                                       |  29 +--
 mm/mmap.c                                          |   5 +-
 net/bluetooth/hci_core.c                           |  34 ++-
 net/bluetooth/hci_sysfs.c                          |   3 +
 net/bluetooth/l2cap_core.c                         |  17 +-
 net/can/bcm.c                                      |   7 +-
 net/core/stream.c                                  |   3 +-
 net/ieee802154/socket.c                            |   4 +
 net/ipv4/af_inet.c                                 |   2 +-
 net/ipv4/inet_hashtables.c                         |   4 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |   3 +
 net/ipv4/tcp.c                                     |  19 +-
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_ipv4.c                                |  11 +-
 net/ipv4/tcp_output.c                              |  19 +-
 net/ipv4/udp.c                                     |   6 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |   6 +-
 net/ipv6/tcp_ipv6.c                                |  11 +-
 net/ipv6/udp.c                                     |   4 +-
 net/mac80211/cfg.c                                 |   3 -
 net/openvswitch/datapath.c                         |  18 +-
 net/rds/tcp.c                                      |   2 +-
 net/sctp/auth.c                                    |  18 +-
 net/unix/garbage.c                                 |  20 ++
 net/vmw_vsock/virtio_transport_common.c            |   2 +-
 net/xfrm/xfrm_ipcomp.c                             |   1 +
 scripts/Kbuild.include                             |  23 +-
 scripts/package/mkspec                             |   4 +-
 scripts/selinux/install_policy.sh                  |   2 +-
 security/Kconfig.hardening                         |  63 +++--
 sound/core/pcm_dmaengine.c                         |   8 +-
 sound/core/rawmidi.c                               |   2 -
 sound/core/sound_oss.c                             |  13 +-
 sound/pci/hda/hda_beep.c                           |  15 +-
 sound/pci/hda/hda_beep.h                           |   1 +
 sound/pci/hda/patch_hdmi.c                         |   6 -
 sound/pci/hda/patch_realtek.c                      |  11 +-
 sound/pci/hda/patch_sigmatel.c                     |  25 +-
 sound/soc/codecs/da7219.c                          |   5 +-
 sound/soc/codecs/mt6660.c                          |   8 +-
 sound/soc/codecs/tas2764.c                         |  78 ++----
 sound/soc/codecs/wcd9335.c                         |   2 +-
 sound/soc/codecs/wcd934x.c                         |   2 +-
 sound/soc/codecs/wm5102.c                          |   6 +-
 sound/soc/codecs/wm5110.c                          |   6 +-
 sound/soc/codecs/wm8997.c                          |   6 +-
 sound/soc/fsl/eukrea-tlv320.c                      |   8 +-
 sound/soc/sh/rcar/ctu.c                            |   6 +-
 sound/soc/sh/rcar/dvc.c                            |   6 +-
 sound/soc/sh/rcar/mix.c                            |   6 +-
 sound/soc/sh/rcar/src.c                            |   5 +-
 sound/soc/sh/rcar/ssi.c                            |   4 +-
 sound/soc/sof/sof-pci-dev.c                        |   2 +-
 sound/usb/endpoint.c                               |   6 +-
 tools/bpf/bpftool/btf_dumper.c                     |   2 +-
 tools/bpf/bpftool/main.c                           |  10 +
 tools/lib/bpf/xsk.c                                |   6 +-
 tools/objtool/elf.c                                |   7 +-
 tools/perf/util/intel-pt.c                         |   9 +-
 .../selftests/arm64/signal/testcases/testcases.c   |   2 +-
 tools/testing/selftests/tpm2/tpm2.py               |   4 +
 380 files changed, 3236 insertions(+), 1455 deletions(-)


