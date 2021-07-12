Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D4E3C62EE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 20:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhGLSw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 14:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230199AbhGLSw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 14:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0A8760240;
        Mon, 12 Jul 2021 18:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626115778;
        bh=bc0HpzidSK3kpI5KldTegLV+eFWnTeS6hNKVlXANkyo=;
        h=From:To:Cc:Subject:Date:From;
        b=enAVPy7+0aij8rjCGnrlzWtu8kt1A18RHEDVafwMWaSJZbUZyVJt6O42UUz4GCZfm
         yGQH5LP1L0l0uHN4RLSyLJn/rQDPXqKQ0IgEzOmHoScIGe/B4qru0N+pTBqPejK39p
         2x9Bealyzeiy2M3IPLtc8vl9TwfFMqknjg/27lC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/598] 5.10.50-rc2 review
Date:   Mon, 12 Jul 2021 20:49:35 +0200
Message-Id: <20210712184832.376480168@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.50-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.50-rc2
X-KernelTest-Deadline: 2021-07-14T18:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.50 release.
There are 598 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 14 Jul 2021 18:45:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.50-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.50-rc2

Valentin Schneider <valentin.schneider@arm.com>
    powerpc/preempt: Don't touch the idle task's preempt_count during hotplug

Joerg Roedel <jroedel@suse.de>
    iommu/dma: Fix compile warning in 32-bit builds

Yang Yingliang <yangyingliang@huawei.com>
    cred: add missing return error code when set_cred_ucounts() failed

Valentin Schneider <valentin.schneider@arm.com>
    s390: preempt: Fix preempt_count initialization

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: qce - fix error return code in qce_skcipher_async_req_handle()

Quat Le <quat.le@oracle.com>
    scsi: core: Retry I/O for Notify (Enable Spinup) Required error

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: exynos4-is: remove a now unused integer

Johan Hovold <johan@kernel.org>
    mmc: vub3000: fix control-request direction

Bean Huo <beanhuo@micron.com>
    mmc: block: Disable CMDQ on the ioctl path

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix blocking inline submission

Long Li <longli@microsoft.com>
    block: return the correct bvec when checking for gaps

Wei Yongjun <weiyongjun1@huawei.com>
    erofs: fix error return code in erofs_read_superblock()

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Replace WARN_ONCE() with dev_err_once() in tpm_tis_status()

Eric Biggers <ebiggers@google.com>
    fscrypt: fix derivation of SipHash keys on big endian CPUs

Eric Biggers <ebiggers@google.com>
    fscrypt: don't ignore minor_hash when hash is 0

Sibi Sankar <sibis@codeaurora.org>
    mailbox: qcom-ipcc: Fix IPCC mbox channel exhaustion

Varun Prakash <varun@chelsio.com>
    scsi: target: cxgbit: Unmap DMA buffer before calling target_execute_cmd()

Javed Hasan <jhasan@marvell.com>
    scsi: fc: Correct RHBA attributes length

Namjae Jeon <namjae.jeon@samsung.com>
    exfat: handle wrong stream entry size in exfat_readdir()

Guo Ren <guoren@linux.alibaba.com>
    csky: syscache: Fixup duplicate cache flush

Randy Dunlap <rdunlap@infradead.org>
    csky: fix syscache.c fallthrough warning

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf llvm: Return -ENOMEM when asprintf() fails

Dave Hansen <dave.hansen@linux.intel.com>
    selftests/vm/pkeys: refill shadow register after implicit kernel write

Dave Hansen <dave.hansen@linux.intel.com>
    selftests/vm/pkeys: handle negative sys_pkey_alloc() return code

Dave Hansen <dave.hansen@linux.intel.com>
    selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really random

Trent Piepho <tpiepho@gmail.com>
    lib/math/rational.c: fix divide by zero

Miaohe Lin <linmiaohe@huawei.com>
    mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page

Miaohe Lin <linmiaohe@huawei.com>
    mm/z3fold: fix potential memory leak in z3fold_destroy_pool()

Ralph Campbell <rcampbell@nvidia.com>
    include/linux/huge_mm.h: remove extern keyword

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: address ref count racing in prep_compound_gigantic_page

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: remove prep_compound_huge_page cleanup

Yanfei Xu <yanfei.xu@windriver.com>
    mm/hugetlb: remove redundant check in preparing and destroying gigantic page

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: use helper huge_page_order and pages_per_huge_page

Miaohe Lin <linmiaohe@huawei.com>
    mm/huge_memory.c: don't discard hugepage if other processes are mapping it

Miaohe Lin <linmiaohe@huawei.com>
    mm/huge_memory.c: add missing read-only THP checking in transparent_hugepage_enabled()

Miaohe Lin <linmiaohe@huawei.com>
    mm/huge_memory.c: remove dedicated macro HPAGE_CACHE_INDEX_MASK

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/pmem: avoid inserting hugepage PTE entry with fsdax if hugepage support is disabled

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Handle concurrent vma faults

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: armada-37xx: Fix reg for standard variant of UART

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: correctly calculate minimal possible baudrate

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: do not allow changing baudrate when uartclk is not available

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ALSA: firewire-lib: Fix 'amdtp_domain_start()' when no AMDTP_OUT_STREAM stream is found

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/papr_scm: Make 'perf_stats' invisible if perf-stats unavailable

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix copy-paste data exposure into newly created tasks

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    powerpc/papr_scm: Properly handle UUID types and API

Nicholas Piggin <npiggin@gmail.com>
    powerpc: Offline CPU in stop_this_cpu()

Vignesh Raghavendra <vigneshr@ti.com>
    serial: 8250: 8250_omap: Fix possible interrupt storm on K3 SoCs

Vignesh Raghavendra <vigneshr@ti.com>
    serial: 8250: 8250_omap: Disable RX interrupt after DMA enable

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    selftests/ftrace: fix event-no-pid on 1-core machine

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    leds: ktd2692: Fix an error handling path

Zhen Lei <thunder.leizhen@huawei.com>
    leds: as3645a: Fix error return code in as3645a_parse_node()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_spdif: Fix unexpected interrupt after suspend

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: Intel: sof_sdw: use mach data for ADL RVP DMIC count

Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
    ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload

Libin Yang <libin.yang@intel.com>
    ASoC: Intel: sof_sdw: add SOF_RT715_DAI_ID_FIX for AlderLake

Chung-Chiang Cheng <shepjeng@gmail.com>
    configfs: fix memleak in configfs_release_bin_file

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    ASoC: atmel-i2s: Fix usage of capture and playback at the same time

Nicholas Piggin <npiggin@gmail.com>
    powerpc/powernv: Fix machine check reporting of async store errors

Marek Szyprowski <m.szyprowski@samsung.com>
    extcon: max8997: Add missing modalias string

Stephan Gerhold <stephan@gerhold.net>
    extcon: sm5502: Drop invalid register write in sm5502_reg_data

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    phy: ti: dm816x: Fix the error handling path in 'dm816x_usb_phy_probe()

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    phy: uniphier-pcie: Fix updating phy parameters

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: stream: Fix test for DP prepare complete

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: mpt3sas: Fix error return value in _scsih_expander_add()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    habanalabs: Fix an error handling path in 'hl_pci_probe()'

Yang Yingliang <yangyingliang@huawei.com>
    mtd: rawnand: marvell: add missing clk_disable_unprepare() on error in marvell_nfc_resume()

Geert Uytterhoeven <geert+renesas@glider.be>
    of: Fix truncation of memory sizes on 32-bit platforms

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Correct definition of CS42L42_ADC_PDN_MASK

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: prox: isl29501: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Actually allow UPF_MAGIC_MULTIPLIER baud rates

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-dts: fix pci address for PCI memory range

Junhao He <hejunhao2@hisilicon.com>
    coresight: core: Fix use of uninitialized pointer

Pavel Skripkin <paskripkin@gmail.com>
    staging: rtl8712: fix memory leak in rtl871x_load_fw_cb

Pavel Skripkin <paskripkin@gmail.com>
    staging: rtl8712: fix error handling in r871xu_drv_init

Dan Carpenter <dan.carpenter@oracle.com>
    staging: gdm724x: check for overflow in gdm_lte_netif_rx()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: gdm724x: check for buffer overflow in gdm_lte_multi_sdu_pkt()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_spdif: Fix error handler with pm_runtime_enable

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: vcnl4000: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: magn: rm3100: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: mxs-lradc: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: hx711: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: at91-sama5d2: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Bond lanes only when dual_link_port != NULL in alloc_dev_default()

Andy Shevchenko <andy.shevchenko@gmail.com>
    eeprom: idt_89hpesx: Restore printing the unsupported fwnode name

Andy Shevchenko <andy.shevchenko@gmail.com>
    eeprom: idt_89hpesx: Put fwnode in matching case during ->probe()

Clément Lassieur <clement@lassieur.org>
    usb: dwc2: Don't reset the core after setting turnaround time

Andrew Gabbasov <andrew_gabbasov@mentor.com>
    usb: gadget: f_fs: Fix setting of device and driver data cross-references

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: mediatek: mtk-btcvsd: Fix an error handling path in 'mtk_btcvsd_snd_probe()'

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: rt5682-sdw: set regcache_cache_only false before reading RT5682_DEVICE_ID

Shuming Fan <shumingf@realtek.com>
    ASoC: rt5682: fix getting the wrong device id when the suspend_stress_test

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt715-sdw: use first_hw_init flag on resume

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt711-sdw: use first_hw_init flag on resume

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt700-sdw: use first_hw_init flag on resume

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt5682-sdw: use first_hw_init flag on resume

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt1308-sdw: use first_hw_init flag on resume

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: max98373-sdw: use first_hw_init flag on resume

Srinath Mannam <srinath.mannam@broadcom.com>
    iommu/dma: Fix IOVA reserve dma ranges

Kees Cook <keescook@chromium.org>
    selftests: splice: Adjust for handler fallback removal

Randy Dunlap <rdunlap@infradead.org>
    s390: appldata depends on PROC_SYSCTL

Niklas Schnelle <schnelle@linux.ibm.com>
    s390: enable HAVE_IOREMAP_PROT

Heiko Carstens <hca@linux.ibm.com>
    s390/irq: select HAVE_IRQ_EXIT_ON_IRQ_STACK

Alexander Monakov <amonakov@ispras.ru>
    iommu/amd: Fix extended features logging

Zhen Lei <thunder.leizhen@huawei.com>
    visorbus: fix error return code in visorchipset_init()

Joachim Fenkes <FENKES@de.ibm.com>
    fsi/sbefifo: Fix reset timeout

Joachim Fenkes <FENKES@de.ibm.com>
    fsi/sbefifo: Clean up correct FIFO when receiving reset request from SBE

Eddie James <eajames@linux.ibm.com>
    fsi: occ: Don't accept response from un-initialized OCC

Eddie James <eajames@linux.ibm.com>
    fsi: scom: Reset the FSI2PIB engine for any error

Colin Ian King <colin.king@canonical.com>
    fsi: core: Fix return of error values on failures

Andreas Kemnade <andreas@kemnade.info>
    mfd: rn5t618: Fix IRQ trigger by changing it to level mode

Randy Dunlap <rdunlap@infradead.org>
    mfd: mp2629: Select MFD_CORE to fix build error

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Flush block work before unblock

Randy Dunlap <rdunlap@infradead.org>
    scsi: FlashPoint: Rename si_flags field

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: lp50xx: Put fwnode in error case during ->probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    leds: lm3697: Don't spam logs when probe is deferred

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: lm3692x: Put fwnode in any case during ->probe()

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: lm36274: Put fwnode in error case during ->probe()

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: lm3532: select regmap I2C API

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: class: The -ENOTSUPP should never be seen by user space

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: nozomi: Fix the error handling path of 'nozomi_card_init()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    firmware: stratix10-svc: Fix a resource leak in an error handling path

Yu Kuai <yukuai3@huawei.com>
    char: pcmcia: error out if 'num_bytes_read' is greater than 4 in set_protocol()

Dave Stevenson <dave.stevenson@raspberrypi.com>
    staging: mmal-vchiq: Fix incorrect static vchiq_instance.

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: arasan: Ensure proper configuration for the asserted target

Corentin Labbe <clabbe@baylibre.com>
    mtd: partitions: redboot: seek fis-index-block in the right node

Adrian Hunter <adrian.hunter@intel.com>
    perf scripting python: Fix tuple_set_u64()

Zhen Lei <thunder.leizhen@huawei.com>
    Input: hil_kbd - fix error return code in hil_dev_connect()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: tidyup loop on rsnd_adg_clk_query()

Andy Shevchenko <andy.shevchenko@gmail.com>
    backlight: lm3630a_bl: Put fwnode in error case during ->probe()

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: hisilicon: fix missing clk_disable_unprepare() on error in hi6210_i2s_startup()

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: rk3328: fix missing clk_disable_unprepare() on error in rk3328_platform_probe()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: cros_ec_sensors: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: chemical: atlas: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: tcs3472: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: tcs3414: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: isl29125: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: magn: bmc150: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: magn: hmc5843: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: prox: as3935: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: prox: pulsed-light: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: prox: srf08: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: humidity: am2315: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: gyro: bmg160: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: vf610: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-ads1015: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: stk8ba50: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: stk8312: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: mxc4005: Fix overread of data and alignment issue.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: kxcjk-1013: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: hid: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: bma180: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Nuno Sa <nuno.sa@analog.com>
    iio: adis16475: do not return ints in irq handlers

Nuno Sa <nuno.sa@analog.com>
    iio: adis16400: do not return ints in irq handlers

Nuno Sa <nuno.sa@analog.com>
    iio: adis_buffer: do not return ints in irq handlers

Arnd Bergmann <arnd@arndb.de>
    mwifiex: re-fix for unaligned accesses

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: nozomi: Fix a resource leak in an error handling function

Dan Carpenter <dan.carpenter@oracle.com>
    serial: 8250_omap: fix a timeout loop condition

Michael Walle <michael@walle.cc>
    serial: fsl_lpuart: remove RTSCTS handling from get_mctrl()

Michael Walle <michael@walle.cc>
    serial: fsl_lpuart: don't modify arbitrary data on lpuart32

Paul E. McKenney <paulmck@kernel.org>
    rcu: Invoke rcu_spawn_core_kthreads() from rcu_spawn_gp_kthread()

Stephen Boyd <swboyd@chromium.org>
    ASoC: rt5682: Disable irq on shutdown

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    staging: fbtft: Don't spam logs when probe is deferred

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    staging: fbtft: Rectify GPIO handling

Wei Li <liwei391@huawei.com>
    MIPS: Fix PKMAP with 32-bit MIPS huge page support

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Always release restrack object

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Don't access NULL-cleared mpi pointer

Menglong Dong <dong.menglong@zte.com.cn>
    net: tipc: fix FB_MTU eat two pages

Pavel Skripkin <paskripkin@gmail.com>
    net: sched: fix warning in tcindex_alloc_perfect_hash

Vadim Fedorenko <vfedorenko@novek.ru>
    net: lwtunnel: handle MTU calculation in forwading

Muchun Song <songmuchun@bytedance.com>
    writeback: fix obtain a reference to a freeing memcg css

Robert Hancock <robert.hancock@calian.com>
    clk: si5341: Update initialization magic

Robert Hancock <robert.hancock@calian.com>
    clk: si5341: Check for input clock presence and PLL lock on startup

Robert Hancock <robert.hancock@calian.com>
    clk: si5341: Avoid divide errors due to bogus register contents

Robert Hancock <robert.hancock@calian.com>
    clk: si5341: Wait for DEVICE_READY on startup

Jonathan Marek <jonathan@marek.ca>
    clk: qcom: clk-alpha-pll: fix CAL_L write in alpha_pll_fabia_prepare

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    clk: actions: Fix AHPPREDIV-H-AHB clock chain on Owl S500 SoC

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    clk: actions: Fix bisp_factor_table based clocks on Owl S500 SoC

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    clk: actions: Fix SD clocks factor table on Owl S500 SoC

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    clk: actions: Fix UART clock dividers on Owl S500 SoC

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix handling of HCI_LE_Advertising_Set_Terminated event

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix Set Extended (Scan Response) Data

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix not sending Set Extended Scan Response

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid

Petr Oros <poros@redhat.com>
    Revert "be2net: disable bh with spin_lock in be_process_mcc"

Bailey Forrest <bcf@google.com>
    gve: Fix swapped vars when fetching max queues

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cma: Fix incorrect Packet Lifetime calculation

Gary Lin <glin@suse.com>
    bpfilter: Specify the log level for the kmsg message

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix NULL pointer dereference in sja1105_reload_cbs()

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Check the PCIm state

Eric Dumazet <edumazet@google.com>
    ipv6: fix out-of-bound access in ip6_parse_tlv()

Antoine Tenart <atenart@kernel.org>
    net: atlantic: fix the macsec key length

Antoine Tenart <atenart@kernel.org>
    net: phy: mscc: fix macsec key length

Antoine Tenart <atenart@kernel.org>
    net: macsec: fix the length used to copy the key for offloading

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cma: Protect RMW with qp_mutex

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: free tx_pool if tso_pool alloc fails

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: set ltb->buff to NULL after freeing

Dany Madden <drt@linux.ibm.com>
    Revert "ibmvnic: remove duplicate napi_schedule call in open function"

Jan Sokolowski <jan.sokolowski@intel.com>
    i40e: Fix missing rtnl locking when setting up pf switch

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix autoneg disabling for non-10GBaseT links

Dinghao Liu <dinghao.liu@zju.edu.cn>
    i40e: Fix error handling in i40e_vsi_open

Maciej Żenczykowski <maze@google.com>
    bpf: Do not change gso_size during bpf_skb_change_proto()

Norbert Slusarek <nslusarek@gmx.net>
    can: j1939: j1939_sk_setsockopt(): prevent allocation of j1939 filter for optlen == 0

Eric Dumazet <edumazet@google.com>
    ipv6: exthdrs: do not blindly use init_net

Jian-Hong Pan <jhp@endlessos.org>
    net: bcmgenet: Fix attaching to PYH failed on RPi 4B

Ping-Ke Shih <pkshih@realtek.com>
    mac80211: remove iwlwifi specific workaround NDPs of null_response

Zhen Lei <thunder.leizhen@huawei.com>
    drm/msm/dpu: Fix error return code in dpu_mdss_init()

Zhen Lei <thunder.leizhen@huawei.com>
    drm/msm: Fix error return code in msm_drm_init()

John Fastabend <john.fastabend@gmail.com>
    bpf: Fix null ptr deref with mixed tail calls and subprogs

Eric Dumazet <edumazet@google.com>
    ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()

Dongliang Mu <mudongliangabcd@gmail.com>
    ieee802154: hwsim: Fix memory leak in hwsim_add_one

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    tc-testing: fix list handling

Vignesh Raghavendra <vigneshr@ti.com>
    net: ti: am65-cpsw-nuss: Fix crash when changing number of TX queues

Miao Wang <shankerwangmiao@gmail.com>
    net/ipv4: swap flow ports when validating source

Jakub Kicinski <kuba@kernel.org>
    ip6_tunnel: fix GRE6 segmentation

Eric Dumazet <edumazet@google.com>
    vxlan: add missing rcu_read_lock() in neigh_reduce()

Po-Hao Huang <phhuang@realtek.com>
    rtw88: 8822c: fix lc calibration timing

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: increase PNVM load timeout

Ayush Sawal <ayush.sawal@chelsio.com>
    xfrm: Fix xfrm offload fallback fail case

Eric Dumazet <edumazet@google.com>
    pkt_sched: sch_qfq: fix qfq_change_class() error path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables_offload: check FLOW_DISSECTOR_KEY_BASIC in VLAN transfer logic

Jakub Kicinski <kuba@kernel.org>
    tls: prevent oversized sendfile() hangs by ignoring MSG_MORE

Yunsheng Lin <linyunsheng@huawei.com>
    net: sched: add barrier to ensure correct ordering for lockless qdisc

Antoine Tenart <atenart@kernel.org>
    vrf: do not push non-ND strict packets with a source LLA through packet taps again

Pavel Skripkin <paskripkin@gmail.com>
    net: ethernet: ezchip: fix error handling

Pavel Skripkin <paskripkin@gmail.com>
    net: ethernet: ezchip: fix UAF in nps_enet_remove

Pavel Skripkin <paskripkin@gmail.com>
    net: ethernet: aeroflex: fix UAF in greth_of_remove

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix NULL pointer dereference in tx_prepare_skb()

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: fix possible NULL pointer dereference in mt76_tx

Wang Hai <wanghai38@huawei.com>
    samples/bpf: Fix the error return code of xdp_redirect's main()

Wang Hai <wanghai38@huawei.com>
    samples/bpf: Fix Segmentation fault for xdp_redirect command

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-srv: Set minimal max_send_wr and max_recv_wr

Tony Ambardar <tony.ambardar@gmail.com>
    bpf: Fix libelf endian handling in resolv_btfids

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Fix broken Tx ring validation

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Fix missing validation for skb and unaligned mode

Daniel Xu <dxu@dxuuu.xyz>
    selftests/bpf: Whitelist test_progs.h from .gitignore

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix qp reference counting for atomic ops

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_tproxy: restrict support to TCP and UDP transport protocols

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_osf: check for TCP packet before further processing

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_exthdr: check for IPv6 packet before further processing

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Don't add slave port to unaffiliated list

Liu Shixin <liushixin2@huawei.com>
    netlabel: Fix memory leak in netlbl_mgmt_add_common

Seevalamuthu Mariappan <seevalam@codeaurora.org>
    ath11k: send beacon template after vdev_start/restart during csa

Yang Li <yang.lee@linux.alibaba.com>
    ath10k: Fix an error code in ath10k_add_interface()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ath11k: Fix an error handling path in ath11k_core_fetch_board_data_api_n()

Hang Zhang <zh.nvgt@gmail.com>
    cw1200: Revert unnecessary patches that fix unreal use-after-free bugs

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    brcmsmac: mac80211_if: Fix a resource leak in an error handling path

Tong Tiangen <tongtiangen@huawei.com>
    brcmfmac: Fix a double-free in brcmf_sdio_bus_reset

Alvin Šipraga <ALSI@bang-olufsen.dk>
    brcmfmac: correctly report average RSSI in station info

Alvin Šipraga <ALSI@bang-olufsen.dk>
    brcmfmac: fix setting of station info chains bitmask

Zhen Lei <thunder.leizhen@huawei.com>
    ssb: Fix error return code in ssb_bus_scan()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Move hal_buf allocation to devm_kmalloc in probe

Lucas Stach <l.stach@pengutronix.de>
    clk: imx8mq: remove SYS PLL 1/2 clock gates

Dongliang Mu <mudongliangabcd@gmail.com>
    ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others

Randy Dunlap <rdunlap@infradead.org>
    wireless: carl9170: fix LEDS build errors & warnings

Yang Yingliang <yangyingliang@huawei.com>
    ath10k: add missing error return code in ath10k_pci_probe()

Yang Yingliang <yangyingliang@huawei.com>
    ath10k: go to path err_unsupported when chip id is not supported

Zhihao Cheng <chengzhihao1@huawei.com>
    tools/bpftool: Fix error return code in do_batch()

Colin Ian King <colin.king@canonical.com>
    drm: qxl: ensure surf.data is ininitialized

Luca Ceresoli <luca@lucaceresoli.net>
    clk: vc5: fix output disabling when enabling a FOD

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Fix error path of hpd-gpios

Kees Cook <keescook@chromium.org>
    drm/pl111: Actually fix CONFIG_VEXPRESS_CONFIG depends

Kamal Heib <kamalheib1@gmail.com>
    RDMA/rxe: Fix failure during driver load

Kees Cook <keescook@chromium.org>
    drm/pl111: depend on CONFIG_VEXPRESS_CONFIG

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Sanitize WQ state received from the userspace

Boris Sukholitko <boris.sukholitko@broadcom.com>
    net/sched: act_vlan: Fix modify to allow 0

Xin Long <lucien.xin@gmail.com>
    xfrm: remove the fragment check for ipv6 beet mode

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra30: Use 300MHz for video decoder by default

Zhen Lei <thunder.leizhen@huawei.com>
    ehea: fix error return code in ehea_restart_qps()

Gioh Kim <gi-oh.kim@cloud.ionos.com>
    RDMA/rtrs-clt: Fix memory leak of not-freed sess->stats and stats->pcpu_stats

Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
    RDMA/rtrs-clt: Check if the queue_depth has changed during a reconnection

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-srv: Fix memory leak when having multiple sessions

Gioh Kim <gi-oh.kim@cloud.ionos.com>
    RDMA/rtrs-srv: Fix memory leak of unfreed rtrs_srv_stats object

Gioh Kim <gi-oh.kim@cloud.ionos.com>
    RDMA/rtrs: Do not reset hb_missed_max after re-connection

Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
    RDMA/rtrs-clt: Check state of the rtrs_clt_sess before reading its stats

Bart Van Assche <bvanassche@acm.org>
    RDMA/srp: Fix a recently introduced memory leak

Jianguo Wu <wujianguo@chinatelecom.cn>
    mptcp: generate subflow hmac after mptcp_finish_join()

Jianguo Wu <wujianguo@chinatelecom.cn>
    mptcp: fix pr_debug in mptcp_token_new_connect

Colin Ian King <colin.king@canonical.com>
    drm/rockchip: cdn-dp: fix sign extension on an int multiply for a u64 result

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/rockchip: lvds: Fix an error handling path

Thomas Hebb <tommyhebb@gmail.com>
    drm/rockchip: dsi: move all lane config except LCDC mux to bind()

Yang Yingliang <yangyingliang@huawei.com>
    drm/rockchip: cdn-dp-core: add missing clk_disable_unprepare() on error in cdn_dp_grf_write()

Alex Bee <knaerzche@gmail.com>
    drm: rockchip: set alpha_en to 0 if it is not used

Yang Yingliang <yangyingliang@huawei.com>
    net: ftgmac100: add missing error return code in ftgmac100_probe()

Jerome Brunet <jbrunet@baylibre.com>
    clk: meson: g12a: fix gp0 and hifi ranges

Wei Yongjun <weiyongjun1@huawei.com>
    net: qrtr: ns: Fix error return code in qrtr_ns_init()

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix cpu updates of coherent multisample surfaces

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Mark a surface gpu-dirty after the SVGA3dCmdDXGenMips command

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a77990: JTAG pins do not have pull-down capabilities

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a7796: Add missing bias for PRESET# pin

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net: pch_gbe: Propagate error from devm_gpio_request_one()

Andy Shevchenko <andy.shevchenko@gmail.com>
    net: mvpp2: Put fwnode in error case during ->probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    video: fbdev: imxfb: Fix an error message

Takashi Iwai <tiwai@suse.de>
    drm/ast: Fix missing conversions to managed API

Yingjie Wang <wangyingjie55@126.com>
    drm/amd/dc: Fix a missing check bug in dm_dp_mst_detect()

Douglas Anderson <dianders@chromium.org>
    drm/bridge: Fix the stop condition of drm_bridge_chain_pre_enable()

Robert Foss <robert.foss@linaro.org>
    drm/bridge/sii8620: fix dependency on extcon

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: xfrm_state_mtu should return at least 1280 for ipv6

Liu Shixin <liushixin2@huawei.com>
    mm/page_alloc: fix counting of managed_pages

Lorenzo Stoakes <lstoakes@gmail.com>
    mm: page_alloc: refactor setup_per_zone_lowmem_reserve()

Waiman Long <longman@redhat.com>
    mm: memcg/slab: properly set up gfp flags for objcg pointer array

Miaohe Lin <linmiaohe@huawei.com>
    mm/shmem: fix shmem_swapin() race with swapoff

Miaohe Lin <linmiaohe@huawei.com>
    swap: fix do_swap_page() race with swapoff

Anshuman Khandual <anshuman.khandual@arm.com>
    mm/debug_vm_pgtable: ensure THP availability via has_transparent_hugepage()

Anshuman Khandual <anshuman.khandual@arm.com>
    mm/debug_vm_pgtable/basic: iterate over entire protection_map[]

Anshuman Khandual <anshuman.khandual@arm.com>
    mm/debug_vm_pgtable/basic: add validation for dirtiness after write protect

Jan Kara <jack@suse.cz>
    dax: fix ENOMEM handling in grab_mapping_entry()

Dan Carpenter <dan.carpenter@oracle.com>
    ocfs2: fix snprintf() checking

Ming Lei <ming.lei@redhat.com>
    blk-mq: update hctx->dispatch_busy in case of real scheduler

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Make cpufreq_online() call driver->offline() on errors

Nathan Chancellor <nathan@kernel.org>
    ACPI: bgrt: Fix CFI violation

Dwaipayan Ray <dwaipayanray1@gmail.com>
    ACPI: Use DEVICE_ATTR_<RW|RO|WO> macros

Zhang Yi <yi.zhang@huawei.com>
    blk-wbt: make sure throttle is enabled properly

Zhang Yi <yi.zhang@huawei.com>
    blk-wbt: introduce a new disable state to prevent false positive by rwb_enabled()

Xiaofei Tan <tanxiaofei@huawei.com>
    ACPI: APEI: fix synchronous external aborts in user-mode

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    extcon: extcon-max8997: Fix IRQ freeing at error path

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Save and restore timer TIOCP_CFG

Christoph Hellwig <hch@lst.de>
    mark pstore-blk as broken

Krzysztof Wilczyński <kw@linux.com>
    ACPI: sysfs: Fix a buffer overrun problem with description_show()

Mario Limonciello <mario.limonciello@amd.com>
    nvme-pci: look for StorageD3Enable on companion ACPI device instead

Ming Lei <ming.lei@redhat.com>
    block: avoid double io accounting for flush request

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM / fan: Put fan device IDs into separate header file

YueHaibing <yuehaibing@huawei.com>
    PM / devfreq: Add missing error code in devfreq_add_device()

Philipp Zabel <p.zabel@pengutronix.de>
    media: video-mux: Skip dangling endpoints

Ezequiel Garcia <ezequiel@collabora.com>
    media: v4l2-async: Clean v4l2_async_notifier_add_fwnode_remote_subdev

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    psi: Fix race between psi_trigger_create/destroy

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: nx - Fix RCU warning in nx842_OF_upd_status

Mirko Vogt <mirko-dev|linux@nanl.de>
    spi: spi-sun6i: Fix chipselect/clock bug

Peter Zijlstra <peterz@infradead.org>
    lockdep/selftests: Fix selftests vs PROVE_RAW_LOCK_NESTING

Peter Zijlstra <peterz@infradead.org>
    lockdep: Fix wait-type for empty stack

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix uclamp_tg_restrict()

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/rt: Fix Deadline utilization tracking during policy change

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/rt: Fix RT utilization tracking during policy change

Joerg Roedel <jroedel@suse.de>
    x86/sev: Split up runtime #VC handler for correct state tracking

Joerg Roedel <jroedel@suse.de>
    x86/sev: Make sure IRQs are disabled while GHCB is active

David Sterba <dsterba@suse.com>
    btrfs: clear log tree recovering status if starting transaction fails

Axel Lin <axel.lin@ingics.com>
    regulator: hi655x: Fix pass wrong pointer to config.driver_data

Alexandru Elisei <alexandru.elisei@arm.com>
    KVM: arm64: Don't zero the cycle count register when PMCR_EL0.P is set

Tuan Phan <tuanphan@os.amperecomputing.com>
    perf/arm-cmn: Fix invalid pointer when access dtc object sharing the same IRQ number

Kai Huang <kai.huang@intel.com>
    KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Don't clobber nested MMU's A/D status on EPTP switch

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Ensure 64-bit shift when checking VMFUNC bitmap

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Sync all PGDs on nested transition with shadow paging

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max31790) Fix fan speed reporting for fan7..12

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max31722) Remove non-standard ACPI device IDs

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm70) Revert "hwmon: (lm70) Add support for ACPI"

Stephen Boyd <swboyd@chromium.org>
    hwmon: (lm70) Use device_get_match_data()

Dillon Min <dillon.minfei@gmail.com>
    media: s5p-g2d: Fix a memory leak on ctx->fh.m2m_ctx

Arnd Bergmann <arnd@arndb.de>
    media: subdev: remove VIDIOC_DQEVENT_TIME32 handling

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Fix ttbr0 values stored in struct thread_info for software-pan

Mark Rutland <mark.rutland@arm.com>
    arm64: consistently use reserved_pg_dir

Zhen Lei <thunder.leizhen@huawei.com>
    mmc: usdhi6rol0: fix error return code in usdhi6_probe()

Hongbo Li <herberthbli@tencent.com>
    crypto: sm2 - fix a memory leak in sm2

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    crypto: sm2 - remove unnecessary reset operations

Hangbin Liu <liuhangbin@gmail.com>
    crypto: x86/curve25519 - fix cpu feature checking logic in mod_exit

Zhang Qilong <zhangqilong3@huawei.com>
    crypto: omap-sham - Fix PM reference leak in omap sham ops

Tong Tiangen <tongtiangen@huawei.com>
    crypto: nitrox - fix unchecked variable in nitrox_register_interrupts

Axel Lin <axel.lin@ingics.com>
    regulator: fan53880: Fix vsel_mask setting for FAN53880_BUCK

Gustavo A. R. Silva <gustavoars@kernel.org>
    media: siano: Fix out-of-bounds warnings in smscore_load_firmware_family2()

Randy Dunlap <rdunlap@infradead.org>
    m68k: atari: Fix ATARI_KBD_CORE kconfig unmet dependency warning

Johan Hovold <johan@kernel.org>
    media: gspca/gl860: fix zero-length control requests

Zhen Lei <thunder.leizhen@huawei.com>
    media: tc358743: Fix error return code in tc358743_probe_of()

Dan Carpenter <dan.carpenter@oracle.com>
    media: au0828: fix a NULL vs IS_ERR() check

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    media: exynos4-is: Fix a use after free in isp_video_release

Ezequiel Garcia <ezequiel@collabora.com>
    media: rkvdec: Fix .buf_prepare

Randy Dunlap <rdunlap@infradead.org>
    locking/lockdep: Reduce LOCKDEP dependency list

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_ep93xx: fix deferred probing

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: rc: i2c: Fix an error message

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: ccp - Fix a resource leak in an error handling path

Suman Anna <s-anna@ti.com>
    crypto: sa2ul - Fix pm_runtime enable in sa_ul_probe()

Suman Anna <s-anna@ti.com>
    crypto: sa2ul - Fix leaks on failure paths with sa_dma_init()

Joe Richey <joerichey@google.com>
    x86/elf: Use _BITUL() macro in UAPI headers

Mimi Zohar <zohar@linux.ibm.com>
    evm: fix writing <securityfs>/evm overflow

Sergey Shtylyov <s.shtylyov@omp.ru>
    pata_octeon_cf: avoid WARN_ON() in ata_host_activate()

Josh Poimboeuf <jpoimboe@redhat.com>
    kbuild: Fix objtool dependency for 'OBJECT_FILES_NON_STANDARD_<obj> := n'

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix locking around cpu_util_update_eff()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix wrong implementation of cpu.uclamp.min

Randy Dunlap <rdunlap@infradead.org>
    media: I2C: change 'RST' to "RSET" to fix multiple build errors

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_rb532_cf: fix deferred probing

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sata_highbank: fix deferred probing

Zhen Lei <thunder.leizhen@huawei.com>
    crypto: ux500 - Fix error return code in hash_hw_final()

Corentin Labbe <clabbe@baylibre.com>
    crypto: ixp4xx - update IV after requests

Corentin Labbe <clabbe@baylibre.com>
    crypto: ixp4xx - dma_unmap the correct address

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: hantro: do a PM resume earlier

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: s5p_cec: decrement usage count if disabled

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: venus: Rework error fail recover logic

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Avoid undefined behaviour when counting unused native CSs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Allow to have all native CSs in use along with GPIOs

Roman Gushchin <guro@fb.com>
    writeback, cgroup: increment isw_nr_in_flight before grabbing an inode

Arnd Bergmann <arnd@arndb.de>
    ia64: mca_drv: fix incorrect array size calculation

Petr Mladek <pmladek@suse.com>
    kthread_worker: fix return value when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

Ming Lei <ming.lei@redhat.com>
    block: fix discard request merge

Shawn Guo <shawn.guo@linaro.org>
    mailbox: qcom: Use PLATFORM_DEVID_AUTO to register platform device

Steve French <stfrench@microsoft.com>
    cifs: fix missing spinlock around update to ses->status

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Correct base usage for capacitive ExpressKey status bits

Richard Fitzgerald <rf@opensource.cirrus.com>
    ACPI: tables: Add custom DSDT file as makefile prerequisite

Javier Martinez Canillas <javierm@redhat.com>
    tpm_tis_spi: add missing SPI device ID entries

Paul E. McKenney <paulmck@kernel.org>
    clocksource: Check per-CPU clock synchronization when marked unstable

Paul E. McKenney <paulmck@kernel.org>
    clocksource: Retry clock read if long delays detected

Zhang Rui <rui.zhang@intel.com>
    ACPI: EC: trust DSDT GPE for certain HP laptop

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: improve fallocate emulation

Haiyang Zhang <haiyangz@microsoft.com>
    PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()

Tony Luck <tony.luck@intel.com>
    EDAC/Intel: Do not load EDAC driver when running as a guest

Hannes Reinecke <hare@suse.de>
    nvmet-fc: do not check for invalid target port in nvmet_fc_handle_fcp_rqst()

JK Kim <jongkang.kim2@gmail.com>
    nvme-pci: fix var. type for increasing cq_head

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    platform/x86: toshiba_acpi: Fix missing error code in toshiba_acpi_setup_keyboard()

Luke D. Jones <luke@ljones.dev>
    platform/x86: asus-nb-wmi: Revert "add support for ASUS ROG Zephyrus G14 and G15"

Luke D. Jones <luke@ljones.dev>
    platform/x86: asus-nb-wmi: Revert "Drop duplicate DMI quirk structures"

Ming Lei <ming.lei@redhat.com>
    block: fix race between adding/removing rq qos and normal IO

Hui Wang <hui.wang@canonical.com>
    ACPI: resources: Add checks for ACPI IRQ override

Hanjun Guo <guohanjun@huawei.com>
    ACPI: bus: Call kobject_put() in acpi_init() error path

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Fix memory leak caused by _CID repair function

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix memory leak when fenced

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    drivers: hv: Fix missing error code in vmbus_connect()

Christian Brauner <christian.brauner@ubuntu.com>
    open: don't silently ignore unknown O-flags in openat2()

Richard Fitzgerald <rf@opensource.cirrus.com>
    random32: Fix implicit truncation warning in prandom_seed_state()

Alexander Aring <aahringo@redhat.com>
    fs: dlm: cancel work sync othercon

Ming Lei <ming.lei@redhat.com>
    blk-mq: clear stale request in tags->rq[] before freeing one request pool

Ming Lei <ming.lei@redhat.com>
    blk-mq: grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter

zhangyi (F) <yi.zhang@huawei.com>
    block_dump: remove block_dump feature in mark_inode_dirty()

Chris Chiu <chris.chiu@canonical.com>
    ACPI: EC: Make more Asus laptops use ECDT _GPE

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add info for the Goodix GT912 panel of TM800A550L tablets

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add an extra entry for the upside down Goodix touchscreen on Teclast X89 tablets

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - platform/x86: touchscreen_dmi - Move upside down quirks to touchscreen_dmi.c

Richard Fitzgerald <rf@opensource.cirrus.com>
    lib: vsprintf: Fix handling of number field widths in vsscanf

YueHaibing <yuehaibing@huawei.com>
    hv_utils: Fix passing zero to 'PTR_ERR' warning

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: processor idle: Fix up C-state latency if not ordered

Bixuan Cui <cuibixuan@huawei.com>
    EDAC/ti: Add missing MODULE_DEVICE_TABLE

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: do not use down_interruptible() when unbinding devices

Luke D Jones <luke@ljones.dev>
    ACPI: video: use native backlight for GA401/GA502/GA503

Shuah Khan <skhan@linuxfoundation.org>
    media: Fix Media Controller API config checks

Axel Lin <axel.lin@ingics.com>
    regulator: da9052: Ensure enough delay time for .set_voltage_time_sel

Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>
    regulator: mt6358: Fix vdram2 .vsel_mask

Heiko Carstens <hca@linux.ibm.com>
    KVM: s390: get rid of register asm usage

Boqun Feng <boqun.feng@gmail.com>
    lockding/lockdep: Avoid to find wrong lock dep path in check_irq_usage()

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Fix the dep path printing for backwards BFS

Christophe Leroy <christophe.leroy@csgroup.eu>
    btrfs: disable build on platforms having page size 256K

Qu Wenruo <wqu@suse.com>
    btrfs: don't clear page extent mapped if we're not invalidating the full page

David Sterba <dsterba@suse.com>
    btrfs: sysfs: fix format string for some discard stats

Josef Bacik <josef@toxicpanda.com>
    btrfs: abort transaction if we fail to update the delayed inode

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix error handling in __btrfs_update_delayed_inode

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    KVM: PPC: Book3S HV: Fix TLB management on SMT8 POWER9 and POWER10 processors

Jing Xiangfeng <jingxiangfeng@huawei.com>
    drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max31790) Fix pwmX_enable attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max31790) Report correct current pwm duty cycles

Steve Longerbeam <slongerbeam@gmail.com>
    media: imx-csi: Skip first few frames from a BT.656 source

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: siano: fix device register error path

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvb_net: avoid speculation from net slot

Ard Biesheuvel <ardb@kernel.org>
    crypto: shash - avoid comparing pointers to exported functions under CFI

zpershuai <zpershuai@gmail.com>
    spi: meson-spicc: fix memory leak in meson_spicc_probe

zpershuai <zpershuai@gmail.com>
    spi: meson-spicc: fix a wrong goto jump for avoiding memory leak.

Zheyu Ma <zheyuma97@gmail.com>
    mmc: via-sdmmc: add a check against NULL pointer dereference

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    mmc: sdhci-sprd: use sdhci_sprd_writew

Tong Zhang <ztong0001@gmail.com>
    memstick: rtsx_usb_ms: fix UAF

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvd_usb: memory leak in cinergyt2_fe_attach

Nick Desaulniers <ndesaulniers@google.com>
    Makefile: fix GDB warning with CONFIG_RELR

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/sec - fixup 3des minimum key size declaration

Evgeny Novikov <novikov@ispras.ru>
    media: st-hva: Fix potential NULL pointer dereferences

Zheyu Ma <zheyuma97@gmail.com>
    media: bt8xx: Fix a missing check bug in bt878_probe

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release

Andrzej Pietrasiewicz <andrzej.p@collabora.com>
    media: cedrus: Fix .buf_prepare

Andrzej Pietrasiewicz <andrzej.p@collabora.com>
    media: hantro: Fix .buf_prepare

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    media: em28xx: Fix possible memory leak of em28xx struct

Tong Zhang <ztong0001@gmail.com>
    media: bt878: do not schedule tasklet when it is not setup

Dillon Min <dillon.minfei@gmail.com>
    media: i2c: ov2659: Use clk_{prepare_enable,disable_unprepare}() to set xvclk on/off

Odin Ugedal <odin@uged.al>
    sched/fair: Fix ascii art by relpacing tabs

Tian Tao <tiantao6@hisilicon.com>
    arm64: perf: Convert snprintf to sysfs_emit

Thara Gopinath <thara.gopinath@linaro.org>
    crypto: qce: skcipher: Fix incorrect sg count for dma transfers

Jack Xu <jack.xu@intel.com>
    crypto: qat - remove unused macro in FW loader

Jack Xu <jack.xu@intel.com>
    crypto: qat - check return code of qat_hal_rd_rel_reg()

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx: imx7_mipi_csis: Fix logging of only error event counters

Anirudh Rayabharam <mail@anirudhrb.com>
    media: pvrusb2: fix warning in pvr2_i2c_core_done

Jernej Skrabec <jernej.skrabec@siol.net>
    media: hevc: Fix dependent slice segment flags

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cobalt: fix race condition in setting HPD

Pavel Skripkin <paskripkin@gmail.com>
    media: cpia2: fix memory leak in cpia2_usb_probe

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: sti: fix obj-$(config) targets

Bixuan Cui <cuibixuan@huawei.com>
    crypto: nx - add missing MODULE_DEVICE_TABLE

Łukasz Stelmach <l.stelmach@samsung.com>
    hwrng: exynos - Fix runtime PM imbalance on error

Valentin Schneider <valentin.schneider@arm.com>
    sched/core: Initialize the idle task with preemption disabled

Zou Wei <zou_wei@huawei.com>
    regulator: uniphier: Add missing MODULE_DEVICE_TABLE

Tian Tao <tiantao6@hisilicon.com>
    spi: omap-100k: Fix the length judgment problem

Jay Fang <f.fangjian@huawei.com>
    spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_messages()

Jay Fang <f.fangjian@huawei.com>
    spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: exynos-gsc: fix pm_runtime_get_sync() usage count

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: exynos4-is: fix pm_runtime_get_sync() usage count

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: sti/bdisp: fix pm_runtime_get_sync() usage count

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: sunxi: fix pm_runtime_get_sync() usage count

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: s5p-jpeg: fix pm_runtime_get_sync() usage count

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: mtk-vcodec: fix PM runtime get logic

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: sh_vou: fix pm_runtime_get_sync() usage count

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: am437x: fix pm_runtime_get_sync() usage count

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: s5p: fix pm_runtime_get_sync() usage count

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: mdk-mdp: fix pm_runtime_get_sync() usage count

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: marvel-ccic: fix some issues when getting pm_runtime

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    staging: media: rkvdec: fix pm_runtime_get_sync() usage count

Alexey Gladkov <legion@kernel.org>
    Add a reference to ucounts for each cred

Charles Keepax <ckeepax@opensource.cirrus.com>
    spi: Make of_register_spi_device also set the fwnode

Lukasz Luba <lukasz.luba@arm.com>
    thermal/cpufreq_cooling: Update offline CPUs per-cpu thermal_pressure

Miklos Szeredi <mszeredi@redhat.com>
    fuse: reject internal errno

Miklos Szeredi <mszeredi@redhat.com>
    fuse: check connected before queueing on fpq->io

Miklos Szeredi <mszeredi@redhat.com>
    fuse: ignore PG_workingset after stealing

Greg Kurz <groug@kaod.org>
    fuse: Fix infinite loop in sget_fc()

Greg Kurz <groug@kaod.org>
    fuse: Fix crash if superblock of submount gets killed early

Greg Kurz <groug@kaod.org>
    fuse: Fix crash in fuse_dentry_automount() error path

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Refuse EVM_ALLOW_METADATA_WRITES only if an HMAC key is loaded

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Execute evm_inode_init_security() only when an HMAC key is loaded

Kristian Klausen <kristian@klausen.dk>
    loop: Fix missing discard support when using LOOP_CONFIGURE

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()

Yun Zhou <yun.zhou@windriver.com>
    seq_buf: Make trace_seq_putmem_hex() support data longer than 8

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracepoint: Add tracepoint_probe_register_may_exist() for BPF tracing

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing/histograms: Fix parsing of "sym-offset" modifier

Martin Fuzzey <martin.fuzzey@flowbird.group>
    rsi: fix AP mode with WPA failure due to encrypted EAPOL

Marek Vasut <marex@denx.de>
    rsi: Assign beacon rate settings to the correct rate_info descriptor field

Michael Buesch <m@bues.ch>
    ssb: sdio: Don't overwrite const buffer if block_write fails

Pali Rohár <pali@kernel.org>
    ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()

Ondrej Zary <linux@zary.sk>
    serial_cs: remove wrong GLOBETROTTER.cis entry

Ondrej Zary <linux@zary.sk>
    serial_cs: Add Option International GSM-Ready 56K/ISDN modem

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    serial: sh-sci: Stop dmaengine transfer in sci_stop_tx()

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: fix calculation of clock divisor

Stephan Gerhold <stephan@gerhold.net>
    iio: accel: bma180: Fix BMA25x bandwidth register values

Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
    iio: ltr501: ltr501_read_ps(): add missing endianness conversion

Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
    iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR

Marc Kleine-Budde <mkl@pengutronix.de>
    iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and PS_DATA as volatile, too

frank zago <frank@zago.net>
    iio: light: tcs3472: do not free unallocated IRQ

Yang Yingliang <yangyingliang@huawei.com>
    iio: frequency: adf4350: disable reg and clk on error in adf4350_probe()

Martin Fuzzey <martin.fuzzey@flowbird.group>
    rtc: stm32: Fix unbalanced clk_disable_unprepare() on probe error path

Dinh Nguyen <dinguyen@kernel.org>
    clk: agilex/stratix10: fix bypass representation

Dinh Nguyen <dinguyen@kernel.org>
    clk: agilex/stratix10: remove noc_clk

Dinh Nguyen <dinguyen@kernel.org>
    clk: agilex/stratix10/n5x: fix how the bypass_reg is handled

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    f2fs: Prevent swap file in LFS mode

Janosch Frank <frankja@linux.ibm.com>
    s390: mm: Fix secure storage access exception handling

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: dont call css_wait_for_slow_path() inside a lock

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in nested NPT walk

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs

Nathan Chancellor <nathan@kernel.org>
    KVM: PPC: Book3S HV: Workaround high stack usage with clang

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Handle split-lock #AC exceptions that happen in L2

Robin Murphy <robin.murphy@arm.com>
    perf/smmuv3: Don't trample existing events with global filter

Jann Horn <jannh@google.com>
    mm/gup: fix try_grab_compound_head() race with split_huge_page()

Baochen Qiang <bqiang@codeaurora.org>
    bus: mhi: Wait for M2 state during system resume

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    SUNRPC: Should wake up the privileged task firstly.

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    SUNRPC: Fix the batch tasks count wraparound.

Felix Fietkau <nbd@nbd.name>
    mac80211: remove iwlwifi specific workaround that broke sta NDP tx

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() after RCU is done

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: isotp_release(): omit unintended hrtimer restart on socket release

Oliver Hartkopp <socketcan@hartkopp.net>
    can: gw: synchronize rcu operations before removing gw job entry

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    can: bcm: delay release of struct bcm_op after synchronize_rcu()

Stephen Brennan <stephen.s.brennan@oracle.com>
    ext4: use ext4_grp_locked_error in mb_find_extent

Pan Dong <pandong.peter@bytedance.com>
    ext4: fix avefreec in find_group_orlov

Zhang Yi <yi.zhang@huawei.com>
    ext4: remove check for zero nr_to_scan in ext4_es_scan()

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct the cache_nr in tracepoint ext4_es_shrink_exit

Yang Yingliang <yangyingliang@huawei.com>
    ext4: return error code when ext4_fill_flex_info() fails

Jan Kara <jack@suse.cz>
    ext4: fix overflow in ext4_iomap_alloc()

Anirudh Rayabharam <mail@anirudhrb.com>
    ext4: fix kernel infoleak via ext4_extent_header

Zhang Yi <yi.zhang@huawei.com>
    ext4: cleanup in-core orphan list if ext4_truncate() failed to get a transaction handle

David Sterba <dsterba@suse.com>
    btrfs: clear defrag status of a root if starting transaction fails

David Sterba <dsterba@suse.com>
    btrfs: compression: don't try to compress if we don't have enough pages

Filipe Manana <fdmanana@suse.com>
    btrfs: send: fix invalid path for unlink operations after parent orphanization

Ludovic Desroches <ludovic.desroches@microchip.com>
    ARM: dts: at91: sama5d4: fix pinctrl muxing

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix LED probing

Yang Jihong <yangjihong1@huawei.com>
    arm_pmu: Fix write counter incorrect in ARMv7 big-endian mode

Joerg Roedel <jroedel@suse.de>
    crypto: ccp - Annotate SEV Firmware file names

Kees Cook <keescook@chromium.org>
    crypto: nx - Fix memcpy() over-reading in nonce

Alexander Larkin <avlarkin82@gmail.com>
    Input: joydev - prevent use of not validated data in JSIOCSBTNMAP ioctl

Al Viro <viro@zeniv.linux.org.uk>
    iov_iter_fault_in_readable() should do nothing in xarray case

Al Viro <viro@zeniv.linux.org.uk>
    copy_page_to_iter(): fix ITER_DISCARD case

Kees Cook <keescook@chromium.org>
    selftests/lkdtm: Avoid needing explicit sub-shell

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    ntfs: fix validity check for file name attribute

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix error handling in init_statfs

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix underflow in gfs2_page_mkwrite

Zhangjiantao (Kirin, nanjing) <water.zhangjiantao@huawei.com>
    xhci: solve a double free problem while doing s4

Jing Xiangfeng <jingxiangfeng@huawei.com>
    usb: typec: Add the missed altmode_id_remove() in typec_register_altmode()

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc3: Fix debugfs creation flow

Hannu Hartikainen <hannu@hrtk.in>
    USB: cdc-acm: blacklist Heimann USB Appset device

Moritz Fischer <mdf@kernel.org>
    usb: renesas-xhci: Fix handling of unknown ROM state

Linyu Yuan <linyyuan@codeaurora.com>
    usb: gadget: eem: fix echo command packet response issue

Pavel Skripkin <paskripkin@gmail.com>
    net: can: ems_usb: fix use-after-free in ems_usb_disconnect()

Johan Hovold <johan@kernel.org>
    Input: usbtouchscreen - fix control-request directions

Pavel Skripkin <paskripkin@gmail.com>
    media: dvb-usb: fix wrong definition

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook 830 G8 Notebook PC

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Apply LED fixup for HP Dragonfly G1, too

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix bass speaker DAC mapping for Asus UM431D

Elia Devito <eliadevito@gmail.com>
    ALSA: hda/realtek: Improve fixup for HP Spectre x360 15-df0xxx

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook x360 830 G8

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add another ALC236 variant support

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 630 G8

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 445 G8

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 450 G8

Takashi Iwai <tiwai@suse.de>
    ALSA: intel8x0: Fix breakage at ac97 clock measurement

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: scarlett2: Fix wrong resume call

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: fix stream format for MOTU 8pre FireWire

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix OOB access at proc output

Daehwan Jung <dh10.jung@samsung.com>
    ALSA: usb-audio: fix rate on Ozone Z90 USB headset

Szymon Janc <szymon.janc@codecoup.pl>
    Bluetooth: Remove spurious error message

Connor Abbott <cwabbott0@gmail.com>
    Bluetooth: btqca: Don't modify firmware contents in-place

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: hci_qca: fix potential GPF


-------------

Diffstat:

 Documentation/ABI/testing/evm                      |  26 ++-
 Documentation/ABI/testing/sysfs-bus-papr-pmem      |   8 +-
 Documentation/admin-guide/kernel-parameters.txt    |   6 +
 Documentation/hwmon/max31790.rst                   |   5 +-
 .../userspace-api/media/v4l/ext-ctrls-codec.rst    |   5 +-
 Documentation/vm/arch_pgtable_helpers.rst          |   8 +-
 Makefile                                           |   6 +-
 arch/alpha/kernel/smp.c                            |   1 -
 arch/arc/kernel/smp.c                              |   1 -
 arch/arm/boot/dts/sama5d4.dtsi                     |   2 +-
 arch/arm/boot/dts/ste-href.dtsi                    |   7 +
 arch/arm/kernel/perf_event_v7.c                    |   4 +-
 arch/arm/kernel/smp.c                              |   1 -
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   2 +-
 arch/arm64/include/asm/asm-uaccess.h               |   4 +-
 arch/arm64/include/asm/kernel-pgtable.h            |   6 -
 arch/arm64/include/asm/mmu_context.h               |   8 +-
 arch/arm64/include/asm/pgtable.h                   |   1 +
 arch/arm64/include/asm/preempt.h                   |   2 +-
 arch/arm64/include/asm/uaccess.h                   |   4 +-
 arch/arm64/kernel/entry.S                          |   6 +-
 arch/arm64/kernel/perf_event.c                     |   2 +-
 arch/arm64/kernel/setup.c                          |   2 +-
 arch/arm64/kernel/smp.c                            |   1 -
 arch/arm64/kernel/vmlinux.lds.S                    |   8 +-
 arch/arm64/kvm/pmu-emul.c                          |   1 +
 arch/arm64/mm/proc.S                               |   2 +-
 arch/csky/kernel/smp.c                             |   1 -
 arch/csky/mm/syscache.c                            |  11 +-
 arch/ia64/kernel/mca_drv.c                         |   2 +-
 arch/ia64/kernel/smpboot.c                         |   1 -
 arch/m68k/Kconfig.machine                          |   3 +
 arch/mips/include/asm/highmem.h                    |   2 +-
 arch/mips/kernel/smp.c                             |   1 -
 arch/openrisc/kernel/smp.c                         |   2 -
 arch/parisc/kernel/smp.c                           |   1 -
 arch/powerpc/include/asm/cputhreads.h              |  30 ++++
 arch/powerpc/kernel/mce_power.c                    |  48 +++++-
 arch/powerpc/kernel/process.c                      |  48 ++++--
 arch/powerpc/kernel/smp.c                          |  12 +-
 arch/powerpc/kernel/stacktrace.c                   |  27 ++-
 arch/powerpc/kvm/book3s_hv.c                       |  13 +-
 arch/powerpc/kvm/book3s_hv_builtin.c               |   2 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |   3 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |   2 +-
 arch/powerpc/platforms/cell/smp.c                  |   3 -
 arch/powerpc/platforms/pseries/papr_scm.c          |  62 ++++---
 arch/powerpc/platforms/pseries/smp.c               |   3 -
 arch/riscv/kernel/smpboot.c                        |   1 -
 arch/s390/Kconfig                                  |   4 +-
 arch/s390/boot/uv.c                                |   1 +
 arch/s390/include/asm/pgtable.h                    |  19 +++
 arch/s390/include/asm/preempt.h                    |  16 +-
 arch/s390/include/asm/uv.h                         |   8 +-
 arch/s390/kernel/setup.c                           |   1 +
 arch/s390/kernel/smp.c                             |   2 +-
 arch/s390/kernel/uv.c                              |  10 ++
 arch/s390/kvm/kvm-s390.c                           |  18 +-
 arch/s390/mm/fault.c                               |  26 +++
 arch/sh/kernel/smp.c                               |   2 -
 arch/sparc/kernel/smp_32.c                         |   1 -
 arch/sparc/kernel/smp_64.c                         |   3 -
 arch/x86/crypto/curve25519-x86_64.c                |   2 +-
 arch/x86/entry/entry_64.S                          |   4 +-
 arch/x86/include/asm/idtentry.h                    |  29 ++--
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/preempt.h                     |   2 +-
 arch/x86/include/uapi/asm/hwcap2.h                 |   6 +-
 arch/x86/kernel/sev-es.c                           | 182 ++++++++++++---------
 arch/x86/kernel/smpboot.c                          |   1 -
 arch/x86/kernel/tsc.c                              |   3 +-
 arch/x86/kvm/hyperv.c                              |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  10 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  29 ++--
 arch/x86/kvm/vmx/vmcs.h                            |   5 +
 arch/x86/kvm/vmx/vmx.c                             |   4 +-
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/xtensa/kernel/smp.c                           |   1 -
 block/blk-flush.c                                  |   3 +-
 block/blk-merge.c                                  |   8 +-
 block/blk-mq-tag.c                                 |  49 ++++--
 block/blk-mq-tag.h                                 |   6 +
 block/blk-mq.c                                     |  63 +++++--
 block/blk-mq.h                                     |   1 +
 block/blk-rq-qos.h                                 |  24 +++
 block/blk-wbt.c                                    |  11 +-
 block/blk-wbt.h                                    |   1 +
 crypto/shash.c                                     |  18 +-
 crypto/sm2.c                                       |  99 +++++------
 drivers/acpi/Makefile                              |   5 +
 drivers/acpi/acpi_pad.c                            |  24 +--
 drivers/acpi/acpi_tad.c                            |  14 +-
 drivers/acpi/acpica/nsrepair2.c                    |   7 +
 drivers/acpi/apei/ghes.c                           |  81 +++++++--
 drivers/acpi/bgrt.c                                |  57 ++-----
 drivers/acpi/bus.c                                 |   1 +
 drivers/acpi/device_pm.c                           |   6 +-
 drivers/acpi/device_sysfs.c                        |  46 +++---
 drivers/acpi/dock.c                                |  26 +--
 drivers/acpi/ec.c                                  |  37 ++++-
 drivers/acpi/fan.c                                 |   7 +-
 drivers/acpi/fan.h                                 |  13 ++
 drivers/acpi/power.c                               |   9 +-
 drivers/acpi/processor_idle.c                      |  40 +++++
 drivers/acpi/resource.c                            |   9 +-
 drivers/acpi/video_detect.c                        |  24 +++
 drivers/ata/pata_ep93xx.c                          |   2 +-
 drivers/ata/pata_octeon_cf.c                       |   5 +-
 drivers/ata/pata_rb532_cf.c                        |   6 +-
 drivers/ata/sata_highbank.c                        |   6 +-
 drivers/block/loop.c                               |   1 +
 drivers/bluetooth/btqca.c                          |  27 ++-
 drivers/bluetooth/hci_qca.c                        |   4 +-
 drivers/bus/mhi/core/pm.c                          |   1 +
 drivers/char/hw_random/exynos-trng.c               |   4 +-
 drivers/char/pcmcia/cm4000_cs.c                    |   4 +
 drivers/char/tpm/tpm_tis_core.c                    |  25 ++-
 drivers/char/tpm/tpm_tis_core.h                    |   3 +-
 drivers/char/tpm/tpm_tis_spi_main.c                |   2 +
 drivers/clk/actions/owl-s500.c                     |  75 +++++----
 drivers/clk/clk-si5341.c                           |  77 ++++++++-
 drivers/clk/clk-versaclock5.c                      |  27 ++-
 drivers/clk/imx/clk-imx8mq.c                       |  56 ++-----
 drivers/clk/meson/g12a.c                           |   2 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 +-
 drivers/clk/socfpga/clk-agilex.c                   |  89 ++++++----
 drivers/clk/socfpga/clk-periph-s10.c               |  11 +-
 drivers/clk/socfpga/clk-s10.c                      |  87 +++++++---
 drivers/clk/tegra/clk-tegra30.c                    |   2 +-
 drivers/clocksource/timer-ti-dm.c                  |   6 +
 drivers/cpufreq/cpufreq.c                          |  11 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.c          |   4 +
 drivers/crypto/ccp/sev-dev.c                       |   4 +
 drivers/crypto/ccp/sp-pci.c                        |   6 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   4 +-
 drivers/crypto/ixp4xx_crypto.c                     |  24 ++-
 drivers/crypto/nx/nx-842-pseries.c                 |   9 +-
 drivers/crypto/nx/nx-aes-ctr.c                     |   2 +-
 drivers/crypto/omap-sham.c                         |   4 +-
 drivers/crypto/qat/qat_common/qat_hal.c            |   6 +-
 drivers/crypto/qat/qat_common/qat_uclo.c           |   1 -
 drivers/crypto/qce/skcipher.c                      |  19 ++-
 drivers/crypto/sa2ul.c                             |  22 ++-
 drivers/crypto/ux500/hash/hash_core.c              |   1 +
 drivers/devfreq/devfreq.c                          |   1 +
 drivers/edac/i10nm_base.c                          |   3 +
 drivers/edac/pnd2_edac.c                           |   3 +
 drivers/edac/sb_edac.c                             |   3 +
 drivers/edac/skx_base.c                            |   3 +
 drivers/edac/ti_edac.c                             |   1 +
 drivers/extcon/extcon-max8997.c                    |   3 +-
 drivers/extcon/extcon-sm5502.c                     |   1 -
 drivers/firmware/stratix10-svc.c                   |  22 ++-
 drivers/fsi/fsi-core.c                             |   4 +-
 drivers/fsi/fsi-occ.c                              |   1 +
 drivers/fsi/fsi-sbefifo.c                          |  10 +-
 drivers/fsi/fsi-scom.c                             |  16 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   3 +
 drivers/gpu/drm/ast/ast_main.c                     |   4 +-
 drivers/gpu/drm/bridge/Kconfig                     |   2 +-
 drivers/gpu/drm/drm_bridge.c                       |   3 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c           |   8 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   1 +
 drivers/gpu/drm/pl111/Kconfig                      |   1 +
 drivers/gpu/drm/qxl/qxl_dumb.c                     |   2 +
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   1 +
 drivers/gpu/drm/rockchip/cdn-dp-reg.c              |   2 +-
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |  36 +++-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   1 +
 drivers/gpu/drm/rockchip/rockchip_lvds.c           |   4 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   4 +-
 .../drm/vmwgfx/device_include/svga3d_surfacedefs.h |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  20 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  13 ++
 drivers/hid/hid-core.c                             |  10 +-
 drivers/hid/wacom_wac.h                            |   2 +-
 drivers/hv/connection.c                            |   4 +-
 drivers/hv/hv_util.c                               |   4 +-
 drivers/hwmon/lm70.c                               |  48 +-----
 drivers/hwmon/max31722.c                           |   9 -
 drivers/hwmon/max31790.c                           |  49 +++---
 drivers/hwtracing/coresight/coresight-core.c       |   2 +-
 drivers/iio/accel/bma180.c                         |  19 ++-
 drivers/iio/accel/bma220_spi.c                     |  10 +-
 drivers/iio/accel/hid-sensor-accel-3d.c            |  13 +-
 drivers/iio/accel/kxcjk-1013.c                     |  24 +--
 drivers/iio/accel/mxc4005.c                        |  10 +-
 drivers/iio/accel/stk8312.c                        |  12 +-
 drivers/iio/accel/stk8ba50.c                       |  17 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   3 +-
 drivers/iio/adc/hx711.c                            |   4 +-
 drivers/iio/adc/mxs-lradc-adc.c                    |   3 +-
 drivers/iio/adc/ti-ads1015.c                       |  12 +-
 drivers/iio/adc/ti-ads8688.c                       |   3 +-
 drivers/iio/adc/vf610_adc.c                        |  10 +-
 drivers/iio/chemical/atlas-sensor.c                |   4 +-
 drivers/iio/frequency/adf4350.c                    |   6 +-
 drivers/iio/gyro/bmg160_core.c                     |  10 +-
 drivers/iio/humidity/am2315.c                      |  16 +-
 drivers/iio/imu/adis16400.c                        |   3 -
 drivers/iio/imu/adis16475.c                        |   2 +-
 drivers/iio/imu/adis_buffer.c                      |   3 -
 drivers/iio/light/isl29125.c                       |  10 +-
 drivers/iio/light/ltr501.c                         |  15 +-
 drivers/iio/light/tcs3414.c                        |  10 +-
 drivers/iio/light/tcs3472.c                        |  16 +-
 drivers/iio/light/vcnl4000.c                       |   2 +-
 drivers/iio/light/vcnl4035.c                       |   3 +-
 drivers/iio/magnetometer/bmc150_magn.c             |  11 +-
 drivers/iio/magnetometer/hmc5843.h                 |   8 +-
 drivers/iio/magnetometer/hmc5843_core.c            |   4 +-
 drivers/iio/magnetometer/rm3100-core.c             |   3 +-
 drivers/iio/potentiostat/lmp91000.c                |   4 +-
 drivers/iio/proximity/as3935.c                     |  10 +-
 drivers/iio/proximity/isl29501.c                   |   2 +-
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |  10 +-
 drivers/iio/proximity/srf08.c                      |  14 +-
 drivers/infiniband/core/cma.c                      |  26 ++-
 drivers/infiniband/core/uverbs_cmd.c               |  21 ++-
 drivers/infiniband/hw/mlx4/qp.c                    |   9 +-
 drivers/infiniband/hw/mlx5/main.c                  |   4 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   6 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  10 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   1 -
 drivers/infiniband/sw/rxe/rxe_resp.c               |   2 -
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |  28 +++-
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c       |   1 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  39 +++--
 drivers/infiniband/ulp/rtrs/rtrs.c                 |   1 -
 drivers/infiniband/ulp/srp/ib_srp.c                |  13 +-
 drivers/input/joydev.c                             |   2 +-
 drivers/input/keyboard/Kconfig                     |   3 -
 drivers/input/keyboard/hil_kbd.c                   |   1 +
 drivers/input/touchscreen/goodix.c                 |  52 ------
 drivers/input/touchscreen/usbtouchscreen.c         |   8 +-
 drivers/iommu/amd/init.c                           |   4 +-
 drivers/iommu/dma-iommu.c                          |   6 +-
 drivers/leds/Kconfig                               |   1 +
 drivers/leds/led-class.c                           |   4 -
 drivers/leds/leds-as3645a.c                        |   1 +
 drivers/leds/leds-ktd2692.c                        |  27 ++-
 drivers/leds/leds-lm36274.c                        |   1 +
 drivers/leds/leds-lm3692x.c                        |   8 +-
 drivers/leds/leds-lm3697.c                         |   8 +-
 drivers/leds/leds-lp50xx.c                         |   2 +-
 drivers/mailbox/qcom-apcs-ipc-mailbox.c            |   2 +-
 drivers/mailbox/qcom-ipcc.c                        |   6 +
 drivers/media/cec/platform/s5p/s5p_cec.c           |   7 +-
 drivers/media/common/siano/smscoreapi.c            |  22 +--
 drivers/media/common/siano/smscoreapi.h            |   4 +-
 drivers/media/common/siano/smsdvb-main.c           |   4 +
 drivers/media/dvb-core/dvb_net.c                   |  25 ++-
 drivers/media/i2c/ir-kbd-i2c.c                     |   4 +-
 drivers/media/i2c/ov2659.c                         |  24 ++-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   6 +-
 drivers/media/i2c/s5c73m3/s5c73m3.h                |   2 +-
 drivers/media/i2c/s5k4ecgx.c                       |  10 +-
 drivers/media/i2c/s5k5baf.c                        |   6 +-
 drivers/media/i2c/s5k6aa.c                         |  10 +-
 drivers/media/i2c/tc358743.c                       |   1 +
 drivers/media/mc/Makefile                          |   2 +-
 drivers/media/pci/bt8xx/bt878.c                    |   6 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |   1 +
 drivers/media/pci/cobalt/cobalt-driver.h           |   7 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |  17 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |  15 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   4 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   6 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   4 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  10 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   7 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   5 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   5 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  10 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |  10 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   9 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |   6 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |   4 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |   8 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h  |   2 +-
 drivers/media/platform/omap3isp/isp.c              |  79 ++++-----
 drivers/media/platform/qcom/venus/core.c           |  60 +++++--
 drivers/media/platform/s5p-g2d/g2d.c               |   3 +
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   5 +-
 drivers/media/platform/sh_vou.c                    |   6 +-
 drivers/media/platform/sti/bdisp/Makefile          |   2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   7 +-
 drivers/media/platform/sti/delta/Makefile          |   2 +-
 drivers/media/platform/sti/hva/Makefile            |   2 +-
 drivers/media/platform/sti/hva/hva-hw.c            |   3 +-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c |   9 +-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h |   1 -
 .../platform/sunxi/sun8i-rotate/sun8i_rotate.c     |   2 +-
 drivers/media/platform/video-mux.c                 |  18 +-
 drivers/media/usb/au0828/au0828-core.c             |   4 +-
 drivers/media/usb/cpia2/cpia2.h                    |   1 +
 drivers/media/usb/cpia2/cpia2_core.c               |  12 ++
 drivers/media/usb/cpia2/cpia2_usb.c                |  13 +-
 drivers/media/usb/dvb-usb/cinergyT2-core.c         |   2 +
 drivers/media/usb/dvb-usb/cxusb.c                  |   2 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   8 +-
 drivers/media/usb/gspca/gl860/gl860.c              |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   4 +-
 drivers/media/v4l2-core/v4l2-async.c               |  24 +--
 drivers/media/v4l2-core/v4l2-fh.c                  |   1 +
 drivers/media/v4l2-core/v4l2-subdev.c              |  24 ---
 drivers/memstick/host/rtsx_usb_ms.c                |  10 +-
 drivers/mfd/Kconfig                                |   1 +
 drivers/mfd/rn5t618.c                              |   2 +-
 drivers/misc/eeprom/idt_89hpesx.c                  |   8 +-
 drivers/misc/habanalabs/common/habanalabs_drv.c    |   1 +
 drivers/mmc/core/block.c                           |   8 +
 drivers/mmc/host/sdhci-sprd.c                      |   1 +
 drivers/mmc/host/usdhi6rol0.c                      |   1 +
 drivers/mmc/host/via-sdmmc.c                       |   3 +
 drivers/mmc/host/vub300.c                          |   2 +-
 drivers/mtd/nand/raw/arasan-nand-controller.c      |  90 ++++++----
 drivers/mtd/nand/raw/marvell_nand.c                |   4 +-
 drivers/mtd/parsers/redboot.c                      |   7 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |   4 +-
 drivers/net/can/usb/ems_usb.c                      |   3 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   6 +
 drivers/net/ethernet/aeroflex/greth.c              |   3 +-
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   1 +
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   6 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   2 +
 drivers/net/ethernet/ezchip/nps_enet.c             |   4 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |   6 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   9 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  36 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c         |  24 +--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  17 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |  10 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  18 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |  11 +-
 drivers/net/macsec.c                               |   4 +-
 drivers/net/phy/mscc/mscc_macsec.c                 |   2 +-
 drivers/net/phy/mscc/mscc_macsec.h                 |   2 +-
 drivers/net/vrf.c                                  |  14 +-
 drivers/net/vxlan.c                                |   2 +
 drivers/net/wireless/ath/ath10k/mac.c              |   1 +
 drivers/net/wireless/ath/ath10k/pci.c              |  14 +-
 drivers/net/wireless/ath/ath11k/core.c             |   3 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  10 +-
 drivers/net/wireless/ath/ath9k/main.c              |   5 +
 drivers/net/wireless/ath/carl9170/Kconfig          |   8 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  21 +--
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  37 +++--
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   1 -
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  10 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |   5 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  22 +--
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   6 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   3 -
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   3 +-
 drivers/net/wireless/rsi/rsi_main.h                |   1 -
 drivers/net/wireless/st/cw1200/scan.c              |  17 +-
 drivers/nvme/host/pci.c                            |  26 +--
 drivers/nvme/target/fc.c                           |  10 +-
 drivers/of/fdt.c                                   |   8 +-
 drivers/of/of_reserved_mem.c                       |   8 +-
 drivers/pci/controller/pci-hyperv.c                |   3 +
 drivers/perf/arm-cmn.c                             |   2 +-
 drivers/perf/arm_smmuv3_pmu.c                      |  18 +-
 drivers/perf/fsl_imx8_ddr_perf.c                   |   6 +-
 drivers/phy/socionext/phy-uniphier-pcie.c          |  11 +-
 drivers/phy/ti/phy-dm816x-usb.c                    |  17 +-
 drivers/pinctrl/renesas/pfc-r8a7796.c              |   3 +-
 drivers/pinctrl/renesas/pfc-r8a77990.c             |   8 +-
 drivers/platform/x86/asus-nb-wmi.c                 |  77 ---------
 drivers/platform/x86/toshiba_acpi.c                |   1 +
 drivers/platform/x86/touchscreen_dmi.c             |  85 ++++++++++
 drivers/regulator/da9052-regulator.c               |   3 +-
 drivers/regulator/fan53880.c                       |   2 +-
 drivers/regulator/hi655x-regulator.c               |  16 +-
 drivers/regulator/mt6358-regulator.c               |   2 +-
 drivers/regulator/uniphier-regulator.c             |   1 +
 drivers/rtc/rtc-stm32.c                            |   6 +-
 drivers/s390/cio/chp.c                             |   3 +
 drivers/s390/cio/chsc.c                            |   2 -
 drivers/scsi/FlashPoint.c                          |  32 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   4 +-
 drivers/scsi/scsi_lib.c                            |   1 +
 drivers/scsi/scsi_transport_iscsi.c                |   2 +
 drivers/soundwire/stream.c                         |  13 +-
 drivers/spi/spi-loopback-test.c                    |   2 +-
 drivers/spi/spi-meson-spicc.c                      |   8 +-
 drivers/spi/spi-omap-100k.c                        |   2 +-
 drivers/spi/spi-sun6i.c                            |   6 +-
 drivers/spi/spi-topcliff-pch.c                     |   4 +-
 drivers/spi/spi.c                                  |   8 +-
 drivers/ssb/scan.c                                 |   1 +
 drivers/ssb/sdio.c                                 |   1 -
 drivers/staging/fbtft/fb_agm1264k-fl.c             |  20 +--
 drivers/staging/fbtft/fb_bd663474.c                |   4 -
 drivers/staging/fbtft/fb_ili9163.c                 |   4 -
 drivers/staging/fbtft/fb_ili9320.c                 |   1 -
 drivers/staging/fbtft/fb_ili9325.c                 |   4 -
 drivers/staging/fbtft/fb_ili9340.c                 |   1 -
 drivers/staging/fbtft/fb_s6d1121.c                 |   4 -
 drivers/staging/fbtft/fb_sh1106.c                  |   1 -
 drivers/staging/fbtft/fb_ssd1289.c                 |   4 -
 drivers/staging/fbtft/fb_ssd1325.c                 |   2 -
 drivers/staging/fbtft/fb_ssd1331.c                 |   6 +-
 drivers/staging/fbtft/fb_ssd1351.c                 |   1 -
 drivers/staging/fbtft/fb_upd161704.c               |   4 -
 drivers/staging/fbtft/fb_watterott.c               |   1 -
 drivers/staging/fbtft/fbtft-bus.c                  |   3 +-
 drivers/staging/fbtft/fbtft-core.c                 |  25 ++-
 drivers/staging/fbtft/fbtft-io.c                   |  12 +-
 drivers/staging/gdm724x/gdm_lte.c                  |  20 ++-
 drivers/staging/media/hantro/hantro_drv.c          |  33 ++--
 drivers/staging/media/hantro/hantro_v4l2.c         |   9 +-
 drivers/staging/media/imx/imx-media-csi.c          |  28 ++--
 drivers/staging/media/imx/imx6-mipi-csi2.c         |  19 +--
 drivers/staging/media/imx/imx7-media-csi.c         |  16 +-
 drivers/staging/media/imx/imx7-mipi-csis.c         |  21 +--
 drivers/staging/media/rkisp1/rkisp1-dev.c          |  15 +-
 drivers/staging/media/rkvdec/rkvdec.c              |  12 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c   |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  |   8 +-
 drivers/staging/mt7621-dts/mt7621.dtsi             |   2 +-
 drivers/staging/rtl8712/hal_init.c                 |   3 +
 drivers/staging/rtl8712/os_intfs.c                 |   4 -
 drivers/staging/rtl8712/usb_intf.c                 |  24 +--
 .../staging/vc04_services/vchiq-mmal/mmal-vchiq.c  |   2 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c           |  19 ++-
 drivers/target/iscsi/cxgbit/cxgbit_target.c        |  21 ++-
 drivers/thermal/cpufreq_cooling.c                  |   2 +-
 drivers/thunderbolt/test.c                         |  14 +-
 drivers/tty/nozomi.c                               |   9 +-
 drivers/tty/serial/8250/8250_omap.c                |  62 ++++++-
 drivers/tty/serial/8250/8250_port.c                |  19 ++-
 drivers/tty/serial/8250/serial_cs.c                |   2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  14 +-
 drivers/tty/serial/mvebu-uart.c                    |  18 +-
 drivers/tty/serial/sh-sci.c                        |   8 +
 drivers/usb/class/cdc-acm.c                        |   5 +
 drivers/usb/dwc2/core.c                            |  30 +++-
 drivers/usb/dwc3/core.c                            |   3 +-
 drivers/usb/gadget/function/f_eem.c                |  43 ++++-
 drivers/usb/gadget/function/f_fs.c                 |  65 ++++----
 drivers/usb/host/xhci-mem.c                        |   1 +
 drivers/usb/host/xhci-pci-renesas.c                |  16 +-
 drivers/usb/typec/class.c                          |   4 +-
 drivers/vfio/pci/vfio_pci.c                        |  29 +++-
 drivers/video/backlight/lm3630a_bl.c               |   4 +-
 drivers/video/fbdev/imxfb.c                        |   2 +-
 drivers/visorbus/visorchipset.c                    |   6 +-
 fs/btrfs/Kconfig                                   |   2 +
 fs/btrfs/delayed-inode.c                           |  18 +-
 fs/btrfs/inode.c                                   |  16 +-
 fs/btrfs/send.c                                    |  11 ++
 fs/btrfs/sysfs.c                                   |   4 +-
 fs/btrfs/transaction.c                             |   6 +-
 fs/btrfs/tree-log.c                                |   1 +
 fs/cifs/cifsglob.h                                 |   3 +-
 fs/cifs/connect.c                                  |   5 +-
 fs/cifs/smb2ops.c                                  | 133 +++++++++++++++
 fs/configfs/file.c                                 |  10 +-
 fs/crypto/fname.c                                  |  10 +-
 fs/crypto/keysetup.c                               |  40 ++++-
 fs/dax.c                                           |   3 +-
 fs/dlm/config.c                                    |   9 +
 fs/dlm/lowcomms.c                                  |   2 +-
 fs/erofs/super.c                                   |   1 +
 fs/exec.c                                          |   4 +
 fs/exfat/dir.c                                     |   8 +-
 fs/ext4/extents.c                                  |   3 +
 fs/ext4/extents_status.c                           |   4 +-
 fs/ext4/ialloc.c                                   |  11 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |   9 +-
 fs/ext4/super.c                                    |  10 +-
 fs/f2fs/data.c                                     |   6 +
 fs/fs-writeback.c                                  |  39 ++---
 fs/fuse/dev.c                                      |  12 +-
 fs/fuse/dir.c                                      |  25 ++-
 fs/gfs2/file.c                                     |   4 +-
 fs/gfs2/ops_fstype.c                               |   1 +
 fs/io_uring.c                                      |   2 +-
 fs/ntfs/inode.c                                    |   2 +-
 fs/ocfs2/filecheck.c                               |   6 +-
 fs/ocfs2/stackglue.c                               |   8 +-
 fs/open.c                                          |  14 +-
 fs/proc/task_mmu.c                                 |   2 +-
 fs/pstore/Kconfig                                  |   1 +
 include/asm-generic/preempt.h                      |   2 +-
 include/clocksource/timer-ti-dm.h                  |   1 +
 include/crypto/internal/hash.h                     |   8 +-
 include/dt-bindings/clock/imx8mq-clock.h           |  19 ---
 include/linux/bio.h                                |  12 +-
 include/linux/clocksource.h                        |   2 +-
 include/linux/cred.h                               |   2 +
 include/linux/huge_mm.h                            | 165 ++++++++++---------
 include/linux/iio/common/cros_ec_sensors_core.h    |   2 +-
 include/linux/prandom.h                            |   2 +-
 include/linux/swap.h                               |   9 +
 include/linux/tracepoint.h                         |  10 ++
 include/linux/user_namespace.h                     |   4 +
 include/media/hevc-ctrls.h                         |   3 +-
 include/media/media-dev-allocator.h                |   2 +-
 include/media/v4l2-async.h                         |  15 +-
 include/net/bluetooth/hci.h                        |   6 +-
 include/net/bluetooth/hci_core.h                   |   8 +-
 include/net/ip.h                                   |  12 +-
 include/net/ip6_route.h                            |  16 +-
 include/net/macsec.h                               |   2 +-
 include/net/sch_generic.h                          |  12 ++
 include/net/tc_act/tc_vlan.h                       |   1 +
 include/net/xfrm.h                                 |   1 +
 include/net/xsk_buff_pool.h                        |   9 +-
 include/scsi/fc/fc_ms.h                            |   4 +-
 init/main.c                                        |   6 +-
 kernel/bpf/verifier.c                              |   6 +-
 kernel/cred.c                                      |  41 +++++
 kernel/fork.c                                      |   8 +-
 kernel/kthread.c                                   |  19 ++-
 kernel/locking/lockdep.c                           | 122 +++++++++++++-
 kernel/rcu/tree.c                                  |   2 +-
 kernel/sched/core.c                                |  45 ++---
 kernel/sched/deadline.c                            |   2 +
 kernel/sched/fair.c                                |   8 +-
 kernel/sched/psi.c                                 |  12 +-
 kernel/sched/rt.c                                  |  17 +-
 kernel/smpboot.c                                   |   1 -
 kernel/sys.c                                       |  12 ++
 kernel/time/clocksource.c                          | 113 ++++++++++++-
 kernel/trace/bpf_trace.c                           |   3 +-
 kernel/trace/trace_events_hist.c                   |   7 +
 kernel/tracepoint.c                                |  33 +++-
 kernel/ucount.c                                    |  40 ++++-
 kernel/user_namespace.c                            |   3 +
 lib/Kconfig.debug                                  |   1 -
 lib/iov_iter.c                                     |   9 +-
 lib/kstrtox.c                                      |  13 +-
 lib/kstrtox.h                                      |   2 +
 lib/locking-selftest.c                             |   1 +
 lib/math/rational.c                                |  16 +-
 lib/seq_buf.c                                      |   4 +-
 lib/vsprintf.c                                     |  82 ++++++----
 mm/debug_vm_pgtable.c                              | 149 ++++++++++++++---
 mm/gup.c                                           |  58 +++++--
 mm/huge_memory.c                                   |  19 ++-
 mm/hugetlb.c                                       | 104 ++++++++----
 mm/khugepaged.c                                    |   4 +-
 mm/memcontrol.c                                    |   8 +
 mm/memory.c                                        |  11 +-
 mm/page_alloc.c                                    |  34 ++--
 mm/shmem.c                                         |  17 +-
 mm/slab.h                                          |   1 -
 mm/z3fold.c                                        |   3 +-
 net/bluetooth/hci_event.c                          |  27 +--
 net/bluetooth/hci_request.c                        |  63 +++----
 net/bluetooth/mgmt.c                               |   3 +
 net/bpfilter/main.c                                |   2 +-
 net/can/bcm.c                                      |   7 +-
 net/can/gw.c                                       |   3 +
 net/can/isotp.c                                    |   7 +-
 net/can/j1939/main.c                               |   4 +
 net/can/j1939/socket.c                             |   5 +-
 net/core/filter.c                                  |   4 -
 net/ipv4/esp4.c                                    |   2 +-
 net/ipv4/fib_frontend.c                            |   2 +
 net/ipv4/route.c                                   |   3 +-
 net/ipv6/esp6.c                                    |   2 +-
 net/ipv6/exthdrs.c                                 |  31 ++--
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/mac80211/mlme.c                                |   9 -
 net/mac80211/sta_info.c                            |   5 -
 net/mptcp/subflow.c                                |   6 +-
 net/mptcp/token.c                                  |   6 +-
 net/netfilter/nf_tables_offload.c                  |  17 +-
 net/netfilter/nft_exthdr.c                         |   3 +
 net/netfilter/nft_osf.c                            |   5 +
 net/netfilter/nft_tproxy.c                         |   9 +-
 net/netlabel/netlabel_mgmt.c                       |  19 ++-
 net/qrtr/ns.c                                      |   4 +-
 net/sched/act_vlan.c                               |   7 +-
 net/sched/cls_tcindex.c                            |   2 +-
 net/sched/sch_qfq.c                                |   8 +-
 net/sunrpc/sched.c                                 |  12 +-
 net/tipc/bcast.c                                   |   2 +-
 net/tipc/msg.c                                     |  17 +-
 net/tipc/msg.h                                     |   3 +-
 net/tls/tls_sw.c                                   |   2 +-
 net/xdp/xsk_queue.h                                |  11 +-
 net/xfrm/xfrm_device.c                             |   1 +
 net/xfrm/xfrm_output.c                             |   7 -
 net/xfrm/xfrm_state.c                              |  14 +-
 samples/bpf/xdp_redirect_user.c                    |   4 +-
 scripts/Makefile.build                             |   5 +-
 scripts/tools-support-relr.sh                      |   3 +-
 security/integrity/evm/evm_main.c                  |   5 +-
 security/integrity/evm/evm_secfs.c                 |  13 +-
 sound/firewire/amdtp-stream.c                      |   7 +-
 sound/firewire/motu/motu-protocol-v2.c             |   5 +-
 sound/pci/hda/patch_realtek.c                      |  49 +++++-
 sound/pci/intel8x0.c                               |   2 +-
 sound/soc/atmel/atmel-i2s.c                        |  34 +++-
 sound/soc/codecs/cs42l42.h                         |   2 +-
 sound/soc/codecs/max98373-sdw.c                    |  12 +-
 sound/soc/codecs/max98373.h                        |   2 +-
 sound/soc/codecs/rk3328_codec.c                    |  28 +++-
 sound/soc/codecs/rt1308-sdw.c                      |   2 +-
 sound/soc/codecs/rt5682-i2c.c                      |   1 +
 sound/soc/codecs/rt5682-sdw.c                      |  23 ++-
 sound/soc/codecs/rt700-sdw.c                       |   2 +-
 sound/soc/codecs/rt711-sdw.c                       |   2 +-
 sound/soc/codecs/rt715-sdw.c                       |   2 +-
 sound/soc/fsl/fsl_spdif.c                          |  23 ++-
 sound/soc/hisilicon/hi6210-i2s.c                   |  14 +-
 sound/soc/intel/boards/sof_sdw.c                   |  16 +-
 sound/soc/mediatek/common/mtk-btcvsd.c             |  24 ++-
 sound/soc/sh/rcar/adg.c                            |   4 +-
 sound/usb/format.c                                 |   2 +
 sound/usb/mixer.c                                  |   8 +-
 sound/usb/mixer.h                                  |   1 +
 sound/usb/mixer_scarlett_gen2.c                    |   7 +-
 tools/bpf/bpftool/main.c                           |   4 +-
 tools/bpf/resolve_btfids/main.c                    |   3 +
 tools/perf/util/llvm-utils.c                       |   2 +
 .../util/scripting-engines/trace-event-python.c    | 146 +++++++++--------
 tools/testing/selftests/bpf/.gitignore             |   1 +
 .../selftests/ftrace/test.d/event/event-no-pid.tc  |   7 +
 tools/testing/selftests/lkdtm/run.sh               |  12 +-
 .../testing/selftests/splice/short_splice_read.sh  | 119 +++++++++++---
 .../selftests/tc-testing/plugin-lib/scapyPlugin.py |   2 +-
 tools/testing/selftests/vm/protection_keys.c       |  12 +-
 641 files changed, 5215 insertions(+), 2798 deletions(-)


