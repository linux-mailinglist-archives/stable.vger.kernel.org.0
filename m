Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908B82C0789
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732569AbgKWMmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732693AbgKWMlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38D6E2076E;
        Mon, 23 Nov 2020 12:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135301;
        bh=YvLGjW28TW97gAXxSqCpNc0PWE5pelBKQJYGZgrjbcg=;
        h=From:To:Cc:Subject:Date:From;
        b=Qp1AWlbYTGRTJmj6rrL6XKErQn9nXYU+b3PxvD0O9i7Qf2HHLOwePBvyhcCr5TSAF
         3AS4Oz5p4cNr9JnW39HI20EKFuDDELKifCGmdvGscyarER/oZ7w1eO61azj8cFEcn5
         2kbaHyhufmP84ADHUKqx1U1QIk+JSuL9WLT3c1H4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 000/252] 5.9.11-rc1 review
Date:   Mon, 23 Nov 2020 13:19:10 +0100
Message-Id: <20201123121835.580259631@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.11-rc1
X-KernelTest-Deadline: 2020-11-25T12:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.9.11 release.
There are 252 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.11-rc1

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()

Muchun Song <songmuchun@bytedance.com>
    mm: memcg/slab: fix root memcg vmstats

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: fix readahead_page_batch for retry entries

Jens Axboe <axboe@kernel.dk>
    mm: never attempt async page lock if we've transferred data already

Chen Yu <yu.c.chen@intel.com>
    x86/microcode/intel: Check patch signature before saving microcode for early loading

Amir Goldstein <amir73il@gmail.com>
    fanotify: fix logic of reporting name info with watched parent

Mickaël Salaün <mic@linux.microsoft.com>
    seccomp: Set PF_SUPERPRIV when checking capability

Mickaël Salaün <mic@linux.microsoft.com>
    ptrace: Set PF_SUPERPRIV when checking capability

Christoph Hellwig <hch@lst.de>
    blk-cgroup: fix a hd_struct leak in blkcg_fill_root_iostats

Manish Narani <manish.narani@xilinx.com>
    mmc: sdhci-of-arasan: Issue DLL reset explicitly

Manish Narani <manish.narani@xilinx.com>
    mmc: sdhci-of-arasan: Use Mask writes for Tap delays

Manish Narani <manish.narani@xilinx.com>
    mmc: sdhci-of-arasan: Allow configuring zero tap values

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Prefer SDR25 timing for High Speed mode for BYT-based Intel controllers

Jens Axboe <axboe@kernel.dk>
    io_uring: don't double complete failed reissue request

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/i915/tgl: Fix Media power gate sequence.

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Handle max_bpc==16

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: Add missing pflip irq for dcn2.0

Chris Co <chrco@microsoft.com>
    Drivers: hv: vmbus: Allow cleanup of VMBUS_CONNECT_CPU if disconnected

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix null pointer dereference for ERP requests

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf.c: fix file permission for cpum_sfb_size

Heiko Carstens <hca@linux.ibm.com>
    s390: fix system call exit path

Johannes Berg <johannes.berg@intel.com>
    mac80211: free sta in sta_info_insert_finish() on errors

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix tx status processing corner case

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: remove deferred sampling code

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: disable preemption around cache alias management calls

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix TLBTEMP area placement

Bob Peterson <rpeterso@redhat.com>
    gfs2: Fix regression in freeze_go_sync

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: workaround self-referent regulators

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: avoid resolve_supply() infinite recursion

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: fix memory leak with repeated set_machine_constraints()

Sean Nyekjaer <sean@geanix.com>
    regulator: pfuze100: limit pfuze-support-disable-sw to pfuze{100,200}

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835aux: Fix use-after-free on unbind

Lukas Wunner <lukas@wunner.de>
    spi: npcm-fiu: Don't leak SPI master in probe error path

Lukas Wunner <lukas@wunner.de>
    spi: Introduce device-managed SPI controller allocation

Lukas Wunner <lukas@wunner.de>
    spi: lpspi: Fix use-after-free on unbind

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: agilex/stratix10: Fix qspi node compatible

Zheng Zengkai <zhengzengkai@huawei.com>
    serial: ar933x_uart: disable clk on error handling path in probe

Olivier Moysan <olivier.moysan@st.com>
    iio: adc: stm32-adc: fix a regression when using dma and irq

Paul Cercueil <paul@crapouillou.net>
    iio/adc: ingenic: Fix battery VREF for JZ4770 SoC

Paul Cercueil <paul@crapouillou.net>
    iio/adc: ingenic: Fix AUX/VBAT readings when touchscreen is used

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: set 10ms as min shub slave timeout

Gwendal Grignou <gwendal@chromium.org>
    iio: cros_ec: Use default frequencies when EC returns invalid information

Fabien Parent <fparent@baylibre.com>
    iio: adc: mediatek: fix unset field

Hans de Goede <hdegoede@redhat.com>
    iio: accel: kxcjk1013: Add support for KIOX010A ACPI DSM for setting tablet-mode

Hans de Goede <hdegoede@redhat.com>
    iio: accel: kxcjk1013: Replace is_smo8500_device with an acpi_type enum

Guenter Roeck <linux@roeck-us.net>
    ACPI: fan: Initialize performance state sysfs attribute

Gao Xiang <hsiangkao@redhat.com>
    xfs: fix forkoff miscalculation related to XFS_LITINO(mp)

Jan Kara <jack@suse.cz>
    ext4: fix bogus warning in ext4_update_dx_flag()

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    iio: light: fix kconfig dependency bug for VCNL4035

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-pci: avoid to request pci bus resources

Brian O'Keefe <bokeefe@alum.wpi.edu>
    staging: rtl8723bs: Add 024c:0627 to the list of SDIO device-ids

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    efivarfs: fix memory leak in efivarfs_create()

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-dj: Fix an error in mse_bluetooth_descriptor

Fugang Duan <fugang.duan@nxp.com>
    tty: serial: imx: keep console clocks always on

Sam Nobs <samuel.nobs@taitradio.com>
    tty: serial: imx: fix potential deadlock

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - HP Headset Mic can't detect after boot

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek: Add some Clove SSID in the ALC293(ALC1220)

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add supported mute Led for HP

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add supported for Lenovo ThinkPad Headset Button

Takashi Iwai <tiwai@suse.de>
    ALSA: mixart: Fix mutex deadlock

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: ctl: fix error path at adding user-defined element set

Joakim Tjernlund <joakim.tjernlund@infinera.com>
    ALSA: usb-audio: Add delay quirk for all Logitech USB devices

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: firewire: Clean up a locking issue in copy_resp_to_buf()

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Do not let the line discipline be used several times

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-dj: Fix Dinovo Mini when paired with a MX5x00 receiver

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-dj: Handle quad/bluetooth keyboards with a builtin trackpad

Lars Povlsen <lars.povlsen@microchip.com>
    HID: mcp2221: Fix GPIO output handling

Harry Cutts <hcutts@chromium.org>
    HID: logitech-hidpp: Add PID for MX Anywhere 2

David Howells <dhowells@redhat.com>
    afs: Fix speculative status fetch going out of order wrt to modifications

Yicong Yang <yangyicong@hisilicon.com>
    libfs: fix error cast of negative value in simple_attr_write()

Peter Zijlstra <peterz@infradead.org>
    sched: Fix rq->nr_iowait ordering

Peter Zijlstra <peterz@infradead.org>
    sched: Fix data-race in wakeup

Quentin Perret <qperret@google.com>
    sched/fair: Fix overutilized update in enqueue_task_fair()

Arvind Sankar <nivedita@alum.mit.edu>
    efi/x86: Free efi_pgd with free_pages()

David Lechner <david@lechnology.com>
    counter/ti-eqep: Fix regmap max_register

Ard Biesheuvel <ardb@kernel.org>
    efi/arm: set HSCTLR Thumb2 bit correctly for HVC calls from HYP

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Use truesize with sk_rmem_schedule()

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: On receive programs try to fast track SK_PASS ingress

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Skb verdict SK_PASS to self already checked rmem limits

Kees Cook <keescook@chromium.org>
    selftests/seccomp: sh: Fix register names

Kees Cook <keescook@chromium.org>
    selftests/seccomp: powerpc: Fix typo in macro variable name

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: revert "xfs: fix rmap key and record comparison functions"

Luo Meng <luomeng12@huawei.com>
    fail_function: Remove a redundant mutex unlock

Daniel Xu <dxu@dxuuu.xyz>
    lib/strncpy_from_user.c: Mask out bytes after NUL terminator.

Jiri Olsa <jolsa@kernel.org>
    libbpf: Fix VERSIONED_SYM_COUNT number parsing

Nishanth Menon <nm@ti.com>
    regulator: ti-abb: Fix array out of bound read access on the first transition

Guenter Roeck <linux@roeck-us.net>
    ASOC: Intel: kbl_rt5663_rt5514_max98927: Do not try to disable disabled clock

Yu Kuai <yukuai3@huawei.com>
    xfs: return corresponding errcode if xfs_initialize_perag() fail

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: ensure inobt record walks always make forward progress

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: directory scrub should check the null bestfree entries too

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: strengthen rmap record flags checking

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix the minrecs logic when dealing with inode root child blocks

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    can: m_can: process interrupt only when not runtime suspended

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: flexcan_chip_start(): fix erroneous flexcan_transceiver_enable() during bus-off recovery

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    iommu/vt-d: Avoid panic if iommu init fails in tboot system

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iommu/vt-d: Move intel_iommu_gfx_mapped to Intel IOMMU header

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: fix error codes in channel_register()

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_hydra: Fix KCAN bittiming limits

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: Fix KCAN bittiming limits

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Fix partial copy_page_to_iter so progress can still be made

Eli Cohen <elic@nvidia.com>
    net/mlx5: E-Switch, Fail mlx5_esw_modify_vport_rate if qos disabled

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/sun4i: dw-hdmi: fix error return code in sun8i_dw_hdmi_bind()

Zhang Qilong <zhangqilong3@huawei.com>
    MIPS: Alchemy: Fix memleak in alchemy_clk_setup_cpu

Wang Hai <wanghai38@huawei.com>
    selftests/bpf: Fix error return code in run_getsockopt_test()

Zhihao Cheng <chengzhihao1@huawei.com>
    spi: cadence-quadspi: Fix error return code in cqspi_probe

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    ASoC: qcom: lpass-platform: Fix memory leak

Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
    ASoC: Intel: KMB: Fix S24_LE configuration

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix mapping of portal size

Faiz Abbas <faiz_abbas@ti.com>
    can: m_can: m_can_stop(): set device to software init mode before closing

Dan Murphy <dmurphy@ti.com>
    can: m_can: Fix freeing of can device from peripherials

Dan Murphy <dmurphy@ti.com>
    can: m_can: m_can_class_free_dev(): introduce new function

Wu Bo <wubo.oduw@gmail.com>
    can: m_can: m_can_handle_state_change(): fix state change

Marc Kleine-Budde <mkl@pengutronix.de>
    can: tcan4x5x: tcan4x5x_can_remove(): fix order of deregistration

Marc Kleine-Budde <mkl@pengutronix.de>
    can: tcan4x5x: tcan4x5x_can_probe(): add missing error checking for devm_regmap_init()

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    can: tcan4x5x: replace depends on REGMAP_SPI with depends on SPI

Zhang Qilong <zhangqilong3@huawei.com>
    can: flexcan: fix failure handling of pm_runtime_get_sync()

Colin Ian King <colin.king@canonical.com>
    can: peak_usb: fix potential integer overflow on shift of a int

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcba_usb: mcba_usb_start_xmit(): first fill skb, then pass to can_put_echo_skb()

Zhang Qilong <zhangqilong3@huawei.com>
    can: ti_hecc: Fix memleak in ti_hecc_probe

Alejandro Concepcion Rodriguez <alejandro@acoro.eu>
    can: dev: can_restart(): post buffer from the right context

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    can: af_can: prevent potential access of uninitialized member in canfd_rcv()

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    can: af_can: prevent potential access of uninitialized member in can_rcv()

Yi-Hung Wei <yihung.wei@gmail.com>
    ip_tunnels: Set tunnel option flag when tunnel metadata is present

Zhang Changzhong <zhangchangzhong@huawei.com>
    IB/hfi1: Fix error return code in hfi1_init_dd()

Wang Hai <wanghai38@huawei.com>
    tools, bpftool: Add missing close before bpftool net attach exit

Jonathan Liu <net147@gmail.com>
    drm: bridge: dw-hdmi: Avoid resetting force in the detect function

Scott Mayhew <smayhew@redhat.com>
    SUNRPC: Fix oops in the rpc_xdr_buf event class

Leo Yan <leo.yan@linaro.org>
    perf lock: Don't free "lock_seq_stat" if read_count isn't zero

Leo Yan <leo.yan@linaro.org>
    perf lock: Correct field name "flags"

Christoph Hellwig <hch@lst.de>
    RMDA/sw: Don't allow drivers using dma_virt_ops on highmem configs

Qinglang Miao <miaoqinglang@huawei.com>
    RDMA/pvrdma: Fix missing kfree() in pvrdma_register_device()

Claire Chang <tientzu@chromium.org>
    rfkill: Fix use-after-free in rfkill_resume()

jingle.wu <jingle.wu@emc.com.tw>
    Input: elan_i2c - fix firmware update on newer ICs

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    Input: resistive-adc-touch - fix kconfig dependency on IIO_BUFFER

Sven Van Asbroeck <thesven73@gmail.com>
    spi: fix client driver breakages when using GPIO descriptors

Paul E. McKenney <paulmck@kernel.org>
    rcu: Don't invoke try_invoke_on_locked_down_task() with irqs disabled

Brendan Higgins <brendanhiggins@google.com>
    kunit: tool: unmark test_data as binary blobs

Tony Lindgren <tony@atomide.com>
    dmaengine: ti: omap-dma: Block PM if SDMA is busy to fix audio

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx50-evk: Fix the chip select 1 IOMUX

Lucas Stach <l.stach@pengutronix.de>
    arm64: dts: imx8mm: fix voltage for 1.6GHz CPU operating point

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Keep VDDA LDO1 always on on DHCOM

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Enable thermal sensor support on stm32mp15xx-dhcor

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Define VIO regulator supply on DHCOM

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix LED5 on STM32MP1 DHCOM PDK2

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix TA3-GPIO-C key on STM32MP1 DHCOM PDK2

Matthew Murrian <matthew.murrian@goctsi.com>
    dmaengine: xilinx_dma: Fix SG capability check for MCDMA

Matthew Murrian <matthew.murrian@goctsi.com>
    dmaengine: xilinx_dma: Fix usage of xilinx_aximcdma_tx_segment

Rijo Thomas <Rijo-john.Thomas@amd.com>
    tee: amdtee: synchronize access to shm list

Rijo Thomas <Rijo-john.Thomas@amd.com>
    tee: amdtee: fix memory leak due to reset of global shm list

Stephen Rothwell <sfr@canb.auug.org.au>
    swiotlb: using SIZE_MAX needs limits.h included

Oleksij Rempel <linux@rempel-privat.de>
    ARM: dts: imx6q-prti6q: fix PHY address

Andrew Lunn <andrew@lunn.ch>
    ARM: dts: vf610-zii-dev-rev-b: Fix MDIO over clocking

Sergey Matyukevich <geomatsi@gmail.com>
    arm: dts: imx6qdl-udoo: fix rgmii phy-mode for ksz9031 phy

Adam Ford <aford173@gmail.com>
    arm64: dts imx8mn: Remove non-existent USB OTG2

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon-som: Fix Choppy BT audio

Biwen Li <biwen.li@nxp.com>
    arm64: dts: fsl: fix endianness issue of rcpm

Nenad Peric <nperic@gmail.com>
    arm64: dts: allwinner: h5: OrangePi Prime: Fix ethernet node

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix wq config registers offset programming

Randy Dunlap <rdunlap@infradead.org>
    MIPS: export has_transparent_hugepage() for modules

Dan Carpenter <dan.carpenter@oracle.com>
    Input: adxl34x - clean up a data type in adxl34x_probe()

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: a64: bananapi-m64: Enable RGMII RX/TX delay on PHY

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: h5: libretech-all-h5-cc: Enable RGMII RX/TX delay on PHY

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sunxi: bananapi-m2-plus: Enable RGMII RX/TX delay on Ethernet PHY

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun9i: Enable both RGMII RX/TX delay on Ethernet PHY

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun8i: a83t: Enable both RGMII RX/TX delay on Ethernet PHY

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun8i: h3: orangepi-plus2e: Enable RGMII RX/TX delay on Ethernet PHY

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun7i: bananapi-m1-plus: Enable RGMII RX/TX delay on Ethernet PHY

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun7i: cubietruck: Enable RGMII RX/TX delay on Ethernet PHY

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun6i: a31-hummingbird: Enable RGMII RX/TX delay on Ethernet PHY

Chen-Yu Tsai <wens@csie.org>
    Revert "arm: sun8i: orangepi-pc-plus: Set EMAC activity LEDs to active high"

Jernej Skrabec <jernej.skrabec@siol.net>
    ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix ethernet node

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: h5: OrangePi PC2: Fix ethernet node

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: a64: Pine64 Plus: Fix ethernet node

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: a64: OrangePi Win: Fix ethernet node

Corentin Labbe <clabbe@baylibre.com>
    arm64: dts: allwinner: Pine H64: Enable both RGMII RX/TX delay

Clément Péron <peron.clem@gmail.com>
    arm64: dts: allwinner: beelink-gs1: Enable both RGMII RX/TX delay

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    usb: dwc2: Avoid leaving the error_debugfs label unused

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: cpu_errata: Apply Erratum 845719 to KRYO2XX Silver

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: kpti: Add KRYO2XX gold/silver CPU cores to kpti safelist

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: Add MIDR value for KRYO2XX gold/silver CPU cores

Bob Peterson <rpeterso@redhat.com>
    gfs2: Fix case in which ail writes are done to jdata holes

Paul Barker <pbarker@konsulko.com>
    hwmon: (pwm-fan) Fix RPM calculation

Zhang Qilong <zhangqilong3@huawei.com>
    gfs2: fix possible reference leak in gfs2_check_blk_type

Darrick J. Wong <darrick.wong@oracle.com>
    vfs: remove lockdep bogosity in __sb_start_write

Richard Weinberger <richard@nod.at>
    um: Call pgtable_pmd_page_dtor() in __pmd_free_tlb()

Will Deacon <will@kernel.org>
    arm64: smp: Tell RCU about CPUs that fail to come online

Will Deacon <will@kernel.org>
    arm64: psci: Avoid printing in cpu_psci_cpu_die()

Will Deacon <will@kernel.org>
    arm64: errata: Fix handling of 1418040 with late CPU onlining

Hans de Goede <hdegoede@redhat.com>
    ACPI: button: Add DMI quirk for Medion Akoya E2228T

Aaron Lewis <aaronlewis@google.com>
    selftests: kvm: Fix the segment descriptor layout to match the actual layout

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: mcp23s08: Print error message when regmap init fails

Can Guo <cang@codeaurora.org>
    scsi: ufs: Try to save power mode change and UIC cmd completion timeout

Can Guo <cang@codeaurora.org>
    scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()

Jianqun Xu <jay.xu@rock-chips.com>
    pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq

Oded Gabbay <ogabbay@kernel.org>
    habanalabs/gaudi: mask WDT error in QMAN

Ian Rogers <irogers@google.com>
    tools, bpftool: Avoid array index warnings.

Tony Lindgren <tony@atomide.com>
    Revert "Revert "gpio: omap: Fix lost edge wake-up interrupts""

Filip Moc <dev@moc6.cz>
    net: usb: qmi_wwan: Set DTR quirk for MR400

Tariq Toukan <tariqt@nvidia.com>
    net/tls: Fix wrong record sn in async mode of device resync

Lorenzo Bianconi <lorenzo@kernel.org>
    net: mvneta: fix possible memory leak in mvneta_swbm_add_rx_fragment

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Free port stats during firmware reset.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix counter overflow logic.

Zhang Qilong <zhangqilong3@huawei.com>
    net: fec: Fix reference count leak in fec series ops

Zhang Qilong <zhangqilong3@huawei.com>
    PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter

Vladyslav Tarasiuk <vladyslavt@nvidia.com>
    net/mlx5: Disable QoS when min_rates on all VFs are zero

Vladyslav Tarasiuk <vladyslavt@nvidia.com>
    net/mlx5: Clear bw_share upon VF disable

Michael Guralnik <michaelgur@nvidia.com>
    net/mlx5: Add handling of port type in rule deletion

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Fix check if netdev is bond slave

Stefano Garzarella <sgarzare@redhat.com>
    vsock: forward all packets to the host when no H2G is registered

Ryan Sharpelletti <sharpelletti@google.com>
    tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate

Xin Long <lucien.xin@gmail.com>
    sctp: change to hold/put transport for proto_unreach_timer

Zhang Changzhong <zhangchangzhong@huawei.com>
    qlcnic: fix error return code in qlcnic_83xx_restart_hw()

Dmitry Bogdanov <dbogdanov@marvell.com>
    qed: fix ILT configuration of SRC block

Zhang Changzhong <zhangchangzhong@huawei.com>
    qed: fix error return code in qed_iwarp_ll2_start()

Dongli Zhang <dongli.zhang@oracle.com>
    page_frag: Recover from memory pressure

Xie He <xie.he.0141@gmail.com>
    net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request

Vadim Fedorenko <vfedorenko@novek.ru>
    net/tls: fix corrupted data in recvmsg

Wong Vee Khee <vee.khee.wong@intel.com>
    net: stmmac: Use rtnl_lock/unlock on netif_set_real_num_rx_queues() call

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: fix direct access to ib_gid_addr->ndev in smc_ib_determine_gid()

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    net: qualcomm: rmnet: Fix incorrect receive packet handling during cleanup

Steen Hegelund <steen.hegelund@microchip.com>
    net: phy: mscc: remove non-MACSec compatible phy

Joel Stanley <joel@jms.id.au>
    net/ncsi: Fix netlink registration

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix refcount leak on kTLS RX resync

Aya Levin <ayal@nvidia.com>
    net/mlx4_core: Fix init_hca fields offset

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: lantiq: Wait for the GPHY firmware to be ready

Paul Moore <paul@paul-moore.com>
    netlabel: fix an uninitialized warning in netlbl_unlabel_staticlist()

Paul Moore <paul@paul-moore.com>
    netlabel: fix our progress tracking in netlbl_unlabel_staticlist()

Alex Elder <elder@linaro.org>
    net: ipa: lock when freeing transaction

Florian Fainelli <f.fainelli@gmail.com>
    net: Have netpoll bring-up DSA management interface

Joel Stanley <joel@jms.id.au>
    net: ftgmac100: Fix crash when removing driver

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: ethernet: ti: cpsw: fix error return code in cpsw_probe()

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw: fix cpts irq after suspend

Wang Qing <wangqing@vivo.com>
    net: ethernet: ti: am65-cpts: update ret when ptp_clock is ERROR

Vincent Stehlé <vincent.stehle@laposte.net>
    net: ethernet: mtk-star-emac: return ok when xmit drops

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: ethernet: mtk-star-emac: fix error return code in mtk_star_enable()

Tobias Waldekranz <tobias@waldekranz.com>
    net: dsa: mv88e6xxx: Avoid VTU corruption on 6097

Taehee Yoo <ap420073@gmail.com>
    netdevsim: set .owner to THIS_MODULE

Heiner Kallweit <hkallweit1@gmail.com>
    net: bridge: add missing counters to ndo_get_stats64 callback

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: b44: fix error return code in b44_init_one()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: core: Use variable timeout for EMAD retries

Sven Van Asbroeck <thesven73@gmail.com>
    lan743x: prevent entire kernel HANG on open, for some platforms

Sven Van Asbroeck <thesven73@gmail.com>
    lan743x: fix issue causing intermittent kernel log warnings

Zhang Qilong <zhangqilong3@huawei.com>
    ipv6: Fix error path to cancel the meseage

Wang Hai <wanghai38@huawei.com>
    inet_diag: Fix error path to cancel the meseage in inet_req_diag_fill()

Jeff Dike <jdike@akamai.com>
    Exempt multicast addresses from five-second neighbor lifetime

Alex Marginean <alexandru.marginean@nxp.com>
    enetc: Workaround for MDIO register access issue

Wang Hai <wanghai38@huawei.com>
    devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: read EEPROM A2h address using page 0

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    atm: nicstar: Unmap DMA on send error

Zhang Changzhong <zhangchangzhong@huawei.com>
    ah6: fix error return code in ah6_input()


-------------

Diffstat:

 Documentation/xtensa/mmu.rst                       |   9 +-
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/head.S                    |   3 +
 arch/arm/boot/dts/imx50-evk.dts                    |   2 +-
 arch/arm/boot/dts/imx6q-prti6q.dts                 |   4 +-
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                |   2 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi      |  19 ++--
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi       |   2 +
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi       |   4 +
 arch/arm/boot/dts/sun6i-a31-hummingbird.dts        |   2 +-
 arch/arm/boot/dts/sun7i-a20-bananapi-m1-plus.dts   |   2 +-
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |   2 +-
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts       |   2 +-
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts   |   2 +-
 arch/arm/boot/dts/sun8i-h3-orangepi-pc-plus.dts    |   5 -
 arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts     |   2 +-
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts  |   2 +-
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts        |   2 +-
 arch/arm/boot/dts/sun9i-a80-optimus.dts            |   2 +-
 arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi      |   2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts          |   3 +
 .../boot/dts/allwinner/sun50i-a64-bananapi-m64.dts |   2 +-
 .../boot/dts/allwinner/sun50i-a64-orangepi-win.dts |   2 +-
 .../boot/dts/allwinner/sun50i-a64-pine64-plus.dts  |   2 +-
 .../allwinner/sun50i-h5-libretech-all-h5-cc.dts    |   2 +-
 .../boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts  |   2 +-
 .../dts/allwinner/sun50i-h5-orangepi-prime.dts     |   2 +-
 .../boot/dts/allwinner/sun50i-h6-beelink-gs1.dts   |   2 +-
 .../boot/dts/allwinner/sun50i-h6-pine-h64.dts      |   2 +-
 .../boot/dts/altera/socfpga_stratix10_socdk.dts    |   2 +-
 .../dts/altera/socfpga_stratix10_socdk_nand.dts    |   2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   1 +
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |   1 +
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |   1 +
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   1 +
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |  30 ------
 arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts |   2 +-
 arch/arm64/include/asm/cpufeature.h                |   2 +
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/kernel/cpu_errata.c                     |   2 +
 arch/arm64/kernel/cpufeature.c                     |   2 +
 arch/arm64/kernel/process.c                        |   5 +-
 arch/arm64/kernel/psci.c                           |   5 +-
 arch/arm64/kernel/smp.c                            |   1 +
 arch/mips/alchemy/common/clock.c                   |   9 +-
 arch/mips/mm/tlb-r4k.c                             |   1 +
 arch/s390/kernel/entry.S                           |   2 +
 arch/s390/kernel/perf_cpum_sf.c                    |   2 +-
 arch/um/include/asm/pgalloc.h                      |   8 +-
 arch/x86/kernel/cpu/microcode/intel.c              |  63 ++---------
 arch/x86/kernel/tboot.c                            |   3 -
 arch/x86/platform/efi/efi_64.c                     |  24 +++--
 arch/xtensa/include/asm/pgtable.h                  |   2 +-
 arch/xtensa/mm/cache.c                             |  14 +++
 block/blk-cgroup.c                                 |   1 +
 drivers/accessibility/speakup/spk_ttyio.c          |  12 ++-
 drivers/acpi/button.c                              |  13 ++-
 drivers/acpi/fan.c                                 |   1 +
 drivers/atm/nicstar.c                              |   2 +
 drivers/counter/ti-eqep.c                          |   4 +-
 drivers/dma/dmaengine.c                            |  17 +--
 drivers/dma/idxd/device.c                          |  31 +++---
 drivers/dma/idxd/idxd.h                            |   3 +-
 drivers/dma/idxd/init.c                            |   5 +
 drivers/dma/idxd/registers.h                       |  25 ++++-
 drivers/dma/idxd/submit.c                          |   2 +-
 drivers/dma/ti/omap-dma.c                          |  37 ++++---
 drivers/dma/xilinx/xilinx_dma.c                    |  36 +++++--
 drivers/gpio/gpio-omap.c                           |  12 ++-
 .../amd/display/dc/irq/dcn20/irq_service_dcn20.c   |   4 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |   6 --
 drivers/gpu/drm/i915/display/intel_display.c       |   3 +-
 drivers/gpu/drm/i915/gt/intel_rc6.c                |  22 +++-
 drivers/gpu/drm/i915/i915_reg.h                    |  12 +--
 drivers/gpu/drm/i915/intel_pm.c                    |  13 ---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |   1 +
 drivers/hid/hid-logitech-dj.c                      |  22 +++-
 drivers/hid/hid-logitech-hidpp.c                   |  26 +++++
 drivers/hid/hid-mcp2221.c                          |  48 +++++++--
 drivers/hv/hv.c                                    |   8 +-
 drivers/hwmon/pwm-fan.c                            |  16 +--
 drivers/iio/accel/kxcjk-1013.c                     |  51 ++++++++-
 drivers/iio/adc/ingenic-adc.c                      |  34 ++++--
 drivers/iio/adc/mt6577_auxadc.c                    |   6 +-
 drivers/iio/adc/stm32-adc-core.c                   |  41 +++-----
 drivers/iio/adc/stm32-adc.c                        |  50 ++++++++-
 .../common/cros_ec_sensors/cros_ec_sensors_core.c  |  16 ++-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c       |   6 +-
 drivers/iio/light/Kconfig                          |   1 +
 drivers/infiniband/Kconfig                         |   3 +
 drivers/infiniband/hw/hfi1/chip.c                  |   3 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |   2 +-
 drivers/infiniband/sw/rdmavt/Kconfig               |   3 +-
 drivers/infiniband/sw/rxe/Kconfig                  |   2 +-
 drivers/infiniband/sw/siw/Kconfig                  |   1 +
 drivers/input/misc/adxl34x.c                       |   2 +-
 drivers/input/mouse/elan_i2c.h                     |   2 +-
 drivers/input/mouse/elan_i2c_core.c                |   3 +-
 drivers/input/mouse/elan_i2c_i2c.c                 |  10 +-
 drivers/input/mouse/elan_i2c_smbus.c               |   2 +-
 drivers/input/touchscreen/Kconfig                  |   1 +
 drivers/iommu/intel/iommu.c                        |   5 +-
 .../misc/habanalabs/include/gaudi/gaudi_masks.h    |   1 -
 drivers/mmc/host/sdhci-of-arasan.c                 |  51 ++++-----
 drivers/mmc/host/sdhci-pci-core.c                  |  13 ++-
 drivers/net/can/dev.c                              |   2 +-
 drivers/net/can/flexcan.c                          |  26 +++--
 drivers/net/can/kvaser_pciefd.c                    |   4 +-
 drivers/net/can/m_can/Kconfig                      |   3 +-
 drivers/net/can/m_can/m_can.c                      |  18 +++-
 drivers/net/can/m_can/m_can.h                      |   1 +
 drivers/net/can/m_can/m_can_platform.c             |  23 +++--
 drivers/net/can/m_can/tcan4x5x.c                   |  32 ++++--
 drivers/net/can/ti_hecc.c                          |  13 ++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   2 +-
 drivers/net/can/usb/mcba_usb.c                     |   4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   4 +-
 drivers/net/dsa/lantiq_gswip.c                     |  11 ++
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            |  59 +++++++++--
 drivers/net/ethernet/broadcom/b44.c                |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |   4 +
 drivers/net/ethernet/freescale/enetc/Kconfig       |   1 +
 drivers/net/ethernet/freescale/enetc/enetc.c       |  62 ++++++++---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    | 115 +++++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c  |   8 +-
 drivers/net/ethernet/freescale/fec_main.c          |  12 +--
 drivers/net/ethernet/marvell/mvneta.c              |   5 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   6 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  13 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  20 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   7 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   3 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  13 +--
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.h          |   3 -
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |  12 ++-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   3 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +
 drivers/net/ethernet/ti/am65-cpts.c                |   3 +-
 drivers/net/ethernet/ti/cpsw.c                     |  11 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   9 +-
 drivers/net/geneve.c                               |   3 +-
 drivers/net/ipa/gsi_trans.c                        |  15 ++-
 drivers/net/netdevsim/dev.c                        |   2 +
 drivers/net/netdevsim/health.c                     |   1 +
 drivers/net/netdevsim/udp_tunnels.c                |   1 +
 drivers/net/phy/mscc/mscc_macsec.c                 |   1 -
 drivers/net/usb/qmi_wwan.c                         |   2 +-
 drivers/pinctrl/pinctrl-mcp23s08_spi.c             |   2 +
 drivers/pinctrl/pinctrl-rockchip.c                 |   2 +
 drivers/regulator/core.c                           |  38 ++++---
 drivers/regulator/pfuze100-regulator.c             |  13 ++-
 drivers/regulator/ti-abb-regulator.c               |  12 ++-
 drivers/s390/block/dasd.c                          |   6 ++
 drivers/scsi/ufs/ufshcd.c                          |  32 +++++-
 drivers/scsi/ufs/ufshcd.h                          |   2 +
 drivers/spi/spi-bcm2835aux.c                       |  21 ++--
 drivers/spi/spi-cadence-quadspi.c                  |   2 +
 drivers/spi/spi-fsl-lpspi.c                        |   3 -
 drivers/spi/spi-npcm-fiu.c                         |   2 +-
 drivers/spi/spi.c                                  |  81 +++++++++++----
 drivers/staging/mt7621-pci/pci-mt7621.c            |  15 +--
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |   1 +
 drivers/tee/amdtee/amdtee_private.h                |   8 +-
 drivers/tee/amdtee/core.c                          |  26 +++--
 drivers/tty/serial/ar933x_uart.c                   |   6 +-
 drivers/tty/serial/imx.c                           |  30 ++----
 drivers/usb/dwc2/platform.c                        |   3 +
 fs/afs/dir.c                                       |   1 +
 fs/afs/inode.c                                     |   8 ++
 fs/afs/internal.h                                  |   1 +
 fs/efivarfs/super.c                                |   1 +
 fs/ext4/ext4.h                                     |   3 +-
 fs/gfs2/aops.c                                     |   2 +-
 fs/gfs2/glops.c                                    |  13 ++-
 fs/gfs2/log.c                                      |   2 +
 fs/gfs2/rgrp.c                                     |  10 +-
 fs/io_uring.c                                      |   1 -
 fs/libfs.c                                         |   6 +-
 fs/notify/fsnotify.c                               |  12 ++-
 fs/super.c                                         |  33 +-----
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   8 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |  16 +--
 fs/xfs/scrub/bmap.c                                |   8 +-
 fs/xfs/scrub/btree.c                               |  45 ++++----
 fs/xfs/scrub/dir.c                                 |  21 +++-
 fs/xfs/xfs_iwalk.c                                 |  27 ++++-
 fs/xfs/xfs_mount.c                                 |  11 +-
 include/drm/intel-gtt.h                            |   5 +-
 include/linux/intel-iommu.h                        |   2 +-
 include/linux/pagemap.h                            |   2 +
 include/linux/pm_runtime.h                         |  21 ++++
 include/linux/sched.h                              |  16 ++-
 include/linux/spi/spi.h                            |  19 ++++
 include/linux/swiotlb.h                            |   1 +
 include/net/ip_tunnels.h                           |   7 +-
 include/net/neighbour.h                            |   1 +
 include/net/tls.h                                  |  16 ++-
 include/trace/events/sunrpc.h                      |   3 +-
 kernel/fail_function.c                             |   5 +-
 kernel/ptrace.c                                    |  16 +--
 kernel/rcu/tree.c                                  |   2 +-
 kernel/rcu/tree_stall.h                            |  22 +++-
 kernel/sched/core.c                                |  15 ++-
 kernel/sched/fair.c                                |   3 +-
 kernel/seccomp.c                                   |   5 +-
 kernel/trace/bpf_trace.c                           |  10 ++
 lib/strncpy_from_user.c                            |  19 +++-
 mm/filemap.c                                       |  18 +++-
 mm/huge_memory.c                                   |   9 +-
 mm/memcontrol.c                                    |   9 +-
 mm/page_alloc.c                                    |   5 +
 net/bridge/br_device.c                             |   1 +
 net/can/af_can.c                                   |  38 +++++--
 net/core/devlink.c                                 |   6 +-
 net/core/neighbour.c                               |   2 +
 net/core/netpoll.c                                 |  22 +++-
 net/core/skmsg.c                                   |  94 +++++++++++++----
 net/ipv4/arp.c                                     |   6 ++
 net/ipv4/inet_diag.c                               |   4 +-
 net/ipv4/tcp_bbr.c                                 |   2 +-
 net/ipv4/tcp_bpf.c                                 |  18 ++--
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/ah6.c                                     |   3 +-
 net/ipv6/ndisc.c                                   |   7 ++
 net/mac80211/rc80211_minstrel.c                    |  27 +----
 net/mac80211/rc80211_minstrel.h                    |   1 -
 net/mac80211/sta_info.c                            |  14 +--
 net/ncsi/ncsi-manage.c                             |   5 -
 net/ncsi/ncsi-netlink.c                            |  22 +---
 net/ncsi/ncsi-netlink.h                            |   3 -
 net/netlabel/netlabel_unlabeled.c                  |  17 ++-
 net/rfkill/core.c                                  |   3 +
 net/sctp/input.c                                   |   4 +-
 net/sctp/sm_sideeffect.c                           |   4 +-
 net/sctp/transport.c                               |   2 +-
 net/smc/smc_ib.c                                   |   6 +-
 net/tls/tls_device.c                               |  37 +++++--
 net/tls/tls_sw.c                                   |   2 +-
 net/vmw_vsock/af_vsock.c                           |   2 +-
 net/x25/af_x25.c                                   |   1 +
 sound/core/control.c                               |   2 +-
 sound/firewire/fireworks/fireworks_transaction.c   |   4 +-
 sound/pci/hda/patch_realtek.c                      |  85 ++++++++++++++-
 sound/pci/mixart/mixart_core.c                     |   5 +-
 .../soc/intel/boards/kbl_rt5663_rt5514_max98927.c  |   2 +
 sound/soc/intel/keembay/kmb_platform.c             |   6 +-
 sound/soc/qcom/lpass-platform.c                    |   5 +-
 sound/usb/quirks.c                                 |  10 +-
 tools/bpf/bpftool/feature.c                        |   7 +-
 tools/bpf/bpftool/net.c                            |  18 ++--
 tools/lib/bpf/Makefile                             |   2 +
 tools/perf/builtin-lock.c                          |   4 +-
 tools/testing/kunit/.gitattributes                 |   1 -
 .../selftests/bpf/prog_tests/sockopt_multi.c       |   3 +-
 .../selftests/kvm/include/x86_64/processor.h       |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   3 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   8 +-
 265 files changed, 1920 insertions(+), 914 deletions(-)


