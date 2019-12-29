Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50DCD12CA39
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfL2RWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:22:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfL2RWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:22:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22E5E208E4;
        Sun, 29 Dec 2019 17:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640165;
        bh=hjVDHUHbxVSURojlHGXed8Dh9u+D0dreEkKFLymr2IA=;
        h=From:To:Cc:Subject:Date:From;
        b=aZKDuAsPRHhhSt3qPKIq9q5gzUJmBcPQGY4QU9NVu9Pmq+yKBRgtMe0bT+3k46Gih
         DrCiqoLSuaLPsYrKT4EaR0rziSLnHUrA56auHjw8EtVmrwsUy6LGWAisuGQMRCqmtR
         sEfUFAVVlYRIb2uJJxue+Pgcu/mW0HPR0Z+W3l7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/161] 4.14.161-stable review
Date:   Sun, 29 Dec 2019 18:17:28 +0100
Message-Id: <20191229162355.500086350@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.161-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.161-rc1
X-KernelTest-Deadline: 2019-12-31T16:24+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.161 release.
There are 161 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.161-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.161-rc1

Mike Christie <mchristi@redhat.com>
    nbd: fix shutdown and recv work deadlock v2

Yangbo Lu <yangbo.lu@nxp.com>
    mmc: sdhci-of-esdhc: fix P2020 errata handling

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci: Update the tuning failed messages to pr_debug level

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    mmc: sdhci-of-esdhc: Revert "mmc: sdhci-of-esdhc: add erratum A-009204 support"

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/irq: fix stack overflow verification

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/MCE/AMD: Allow Reserved types to be overwritten in smca_banks[]

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    x86/MCE/AMD: Do not use rdmsr_safe_on_cpu() in smca_configure()

Will Deacon <will@kernel.org>
    KVM: arm64: Ensure 'params' is initialised when looking up sys register

Dan Carpenter <dan.carpenter@oracle.com>
    ext4: unlock on error in ext4_expand_extra_isize()

Jan Kara <jack@suse.cz>
    ext4: check for directory entries too close to block end

Jan Kara <jack@suse.cz>
    ext4: fix ext4_empty_dir() for directories with holes

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: gsc_hpdi: check dma_alloc_coherent() return value

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY 128 bytes

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Elkhart Lake SOC support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Comet Lake PCH-V support

Erkka Talvitie <erkka.talvitie@vincit.fi>
    USB: EHCI: Do not return -EPIPE when hub is disconnected

Suwan Kim <suwan.kim027@gmail.com>
    usbip: Fix error path of vhci_recv_ret_submit()

Suwan Kim <suwan.kim027@gmail.com>
    usbip: Fix receive error in vhci-hcd when using scatter-gather

Josef Bacik <josef@toxicpanda.com>
    btrfs: abort transaction after failed inode updates in create_subvol

Dan Carpenter <dan.carpenter@oracle.com>
    btrfs: return error pointer from alloc_test_extent_buffer

Sven Schnelle <svens@linux.ibm.com>
    s390/ftrace: fix endless recursion in function_graph tracer

Guenter Roeck <linux@roeck-us.net>
    usb: xhci: Fix build warning seen with CONFIG_PM=n

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: mediatek: fix CMD_TA to 2 for MT8173 HS200/HS400 mode

Faiz Abbas <faiz_abbas@ti.com>
    Revert "mmc: sdhci: Fix incorrect switch to HS mode"

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in scrub_missing_raid56_worker()

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in reada_start_machine_worker()

Russell King <rmk+kernel@armlinux.org.uk>
    net: phy: initialise phydev speed and duplex sanely

Mike Rapoport <rppt@linux.ibm.com>
    mips: fix build when "48 bits virtual memory" is enabled

Hewenliang <hewenliang4@huawei.com>
    libtraceevent: Fix memory leakage in copy_filter_type

Michael Ellerman <mpe@ellerman.id.au>
    crypto: vmx - Avoid weird build failures

Thomas Pedersen <thomas@adapt-ip.com>
    mac80211: consider QoS Null frames for STA_NULLFUNC_ACKED

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun4i-ss - Fix 64-bit size_t warnings on sun4i-ss-hash.c

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: sun4i-ss - Fix 64-bit size_t warnings

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fbtft: Make sure string is NULL terminated

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: check kasprintf() return value

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Add some Intel instructions to the opcode map

Chuhong Yuan <hslester96@gmail.com>
    spi: st-ssc4: add missed pm_runtime_disable

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in run_ordered_work()

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in end_workqueue_fn()

Eugeniu Rosca <erosca@de.adit-jv.com>
    mmc: tmio: Add MMC_CAP_ERASE to allow erase/discard/trim requests

Ard Biesheuvel <ardb@kernel.org>
    crypto: virtio - deal with unsupported input sizes

Chuhong Yuan <hslester96@gmail.com>
    spi: tegra20-slink: add missed clk_unprepare

Wang Xuerui <wangxuerui@qiniu.com>
    iwlwifi: mvm: fix unaligned read of rx_pkt_status

Lianbo Jiang <lijiang@redhat.com>
    x86/crash: Add a forward declaration of struct kimage

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: Register drivers only after CPU devices have been registered

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    parport: load lowlevel driver if ports not found

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/disassembler: don't hide instruction addresses

Yu-Hsuan Hsu <yuhsuan@chromium.org>
    ASoC: Intel: kbl_rt5663_rt5514_max98927: Add dmic format constraint

Ben Zhang <benzh@chromium.org>
    ASoC: rt5677: Mark reg RT5677_PWR_ANLG2 as volatile

Chuhong Yuan <hslester96@gmail.com>
    spi: pxa2xx: Add missed security checks

Robert Richter <rrichter@marvell.com>
    EDAC/ghes: Fix grain calculation

Chuhong Yuan <hslester96@gmail.com>
    media: si470x-i2c: add missed operations in remove

Mike Isely <isely@pobox.com>
    media: pvrusb2: Fix oops on tear-down when radio support is not present

Andrew Jeffery <andrew@aj.id.au>
    fsi: core: Fix small accesses and unaligned offsets via sysfs

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix get invalid tx rate for Mesh metric

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Filter out instances except for inlined subroutine and subprogram

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Skip end-of-sequence and non statement lines

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show calling lines of inlined functions

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Return a better scope DIE if there is no best scope

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Skip overlapped location on searching variables

Ian Rogers <irogers@google.com>
    perf parse: If pmu configuration fails free terms

Pan Bian <bianpan2016@163.com>
    drm/amdgpu: fix potential double drop fence reference

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to probe a function which has no entry pc

James Clark <James.Clark@arm.com>
    libsubcmd: Use -O0 with DEBUG=1

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show inlined function callsite without entry_pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show ranges of variables in functions without entry_pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to probe an inline function which has no entry pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Walk function lines in lexical blocks

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to list probe event with correct line number

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to find range-only function instance

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: fix memory leak in rtl92c_set_fw_rsvdpagepkt()

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Limit max amount of slave instances

Pan Bian <bianpan2016@163.com>
    spi: img-spfi: fix potential double release

Manish Chopra <manishc@marvell.com>
    bnx2x: Fix PF-VF communication over multi-cos queues.

Marcel Holtmann <marcel@holtmann.org>
    rfkill: allocate static minor

Vandana BN <bnvandana@gmail.com>
    media: v4l2-core: fix touch support in v4l_g_fmt

Kangjie Lu <kjlu@umn.edu>
    media: rcar_drif: fix a memory disclosure

Manjunath Patil <manjunath.b.patil@oracle.com>
    ixgbe: protect TX timestamping from API misuse

Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
    pinctrl: amd: fix __iomem annotation in amd_gpio_irq_handler()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix advertising duplicated flags

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: dln2-adc: fix iio_triggered_buffer_postenable() position

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Fix duplicate TCLK1_B

Darrick J. Wong <darrick.wong@oracle.com>
    loop: fix no-unmap write-zeroes request behavior

John Garry <john.garry@huawei.com>
    libata: Ensure ata_port probe has completed before detach

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: add mm_pxd_folded() checks to pxd_free()

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/time: ensure get_clock_monotonic() returns monotonic values

Stephan Gerhold <stephan@gerhold.net>
    phy: qcom-usb-hs: Fix extcon double register after power cycle

Mao Wenan <maowenan@huawei.com>
    net: dsa: LAN9303: select REGMAP when LAN9303 enable

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Allocate gather copy for host1x

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix memory leak in user qp and mr

Grygorii Strashko <grygorii.strashko@ti.com>
    net: phy: dp83867: enable robust auto-mdix

Yunfeng Ye <yeyunfeng@huawei.com>
    arm64: psci: Reduce the waiting time for cpu_psci_cpu_kill()

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Prevent inconsistent state when moving an interrupt

Chris Chiu <chiu@endlessm.com>
    rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot

Kangjie Lu <kjlu@umn.edu>
    drm/gma500: fix memory disclosures due to uninitialized bytes

Benjamin Berg <bberg@redhat.com>
    x86/mce: Lower throttling MCE messages' priority to warning

Mattijs Korpershoek <mkorpershoek@baylibre.com>
    Bluetooth: hci_core: fix init for HCI_USER_CHANNEL

Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
    Bluetooth: missed cpu_to_le16 conversion in hci_init4_req

Miquel Raynal <miquel.raynal@bootlin.com>
    iio: adc: max1027: Reset the device at probe time

Ingo Rohloff <ingo.rohloff@lauterbach.com>
    usb: usbfs: Suppress problematic bind and unbind uevents.

Jin Yao <yao.jin@linux.intel.com>
    perf report: Add warning when libunwind not compiled in

Leo Yan <leo.yan@linaro.org>
    perf test: Report failure for mmap events

Daniel Kurtz <djkurtz@chromium.org>
    drm/bridge: dw-hdmi: Restore audio when setting a mode

Sami Tolvanen <samitolvanen@google.com>
    x86/mm: Use the correct function type for native_set_fixmap()

Stephan Gerhold <stephan@gerhold.net>
    extcon: sm5502: Reset registers during initialization

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance failure about invalid sizeimage

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: ensure buffers are cleaned up properly in abort cases

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance failure causing a kernel panic

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: Make sure YUYV is set as default format

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance failure about frame sequence number

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance warning about invalid pixel format

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: Fix Motion Vector vpdma stride

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: cx88: Fix some error handling path in 'cx8800_initdev()'

Navid Emamdoost <navid.emamdoost@gmail.com>
    mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring

Bart Van Assche <bvanassche@acm.org>
    block: Fix writeback throttling W=1 compiler warnings

Daniel T. Lee <danieltimlee@gmail.com>
    samples: pktgen: fix proc_cmd command result check logic

Matthias Kaehlcke <mka@chromium.org>
    drm/bridge: dw-hdmi: Refuse DDC/CI transfers on the internal I2C controller

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-funcs.h: add status_req checks

Yang Yingliang <yangyingliang@huawei.com>
    media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()

Yizhuo <yzhai003@ucr.edu>
    regulator: max8907: Fix the usage of uninitialized variable in max8907_regulator_probe()

Tony Lindgren <tony@atomide.com>
    hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not idled

Veeraiyan Chidambaram <veeraiyan.chidambaram@in.bosch.com>
    usb: renesas_usbhs: add suspend event support in gadget mode

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
    selftests/bpf: Correct path to include msg + path

Will Deacon <will@kernel.org>
    pinctrl: devicetree: Avoid taking direct reference to device name string

Ben Greear <greearb@candelatech.com>
    ath10k: fix offchannel tx failure when no ath10k_mac_tx_frm_has_freq

Loic Poulain <loic.poulain@linaro.org>
    media: venus: core: Fix msm8996 frequency table

Nathan Chancellor <natechancellor@gmail.com>
    tools/power/cpupower: Fix initializer override in hsw_ext_cstates

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix stored crop rectangle not in sync with hardware

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix stored frame format not in sync with hardware

Benoit Parrot <bparrot@ti.com>
    media: i2c: ov2659: Fix missing 720p register config

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix crop rectangle alignment not passed back

Benoit Parrot <bparrot@ti.com>
    media: i2c: ov2659: fix s_stream return value

Benoit Parrot <bparrot@ti.com>
    media: am437x-vpfe: Setting STD to current value is not an error

Max Gurtovoy <maxg@mellanox.com>
    IB/iser: bound protection_sg size by data_sg size

Allen Pais <allen.pais@oracle.com>
    libertas: fix a potential NULL pointer dereference

Navid Emamdoost <navid.emamdoost@gmail.com>
    rtlwifi: prevent memory leak in rtl_usb_probe

Connor Kuehl <connor.kuehl@canonical.com>
    staging: rtl8188eu: fix possible null dereference

Navid Emamdoost <navid.emamdoost@gmail.com>
    staging: rtl8192u: fix multiple memory leaks on error path

Lukasz Majewski <lukma@denx.de>
    spi: Add call to spi_slave_abort() function when spidev driver is released

Krzysztof Wilczynski <kw@linux.com>
    iio: light: bh1750: Resolve compiler warning and make code more readable

Brian Masney <masneyb@onstation.org>
    drm/bridge: analogix-anx78xx: silence -EPROBE_DEFER warnings

Sean Paul <seanpaul@chromium.org>
    drm: mst: Fix query_payload ack reply struct

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Avoid endless loop

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Keep power on during processing DSP response

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Avoid possible info leaks from PCM stream buffers

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix removal logic of the tree mod log that leads to use-after-free issues

Josef Bacik <josef@toxicpanda.com>
    btrfs: handle ENOENT in btrfs_uuid_tree_iterate

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not leak reloc root if we fail to read the fs root

Josef Bacik <josef@toxicpanda.com>
    btrfs: skip log replay on orphaned roots

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not call synchronize_srcu() in inode_tree_del

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't double lock the subvol_sem for rename exchange

Xin Long <lucien.xin@gmail.com>
    sctp: fully initialize v4 addr in some functions

Manish Chopra <manishc@marvell.com>
    qede: Fix multicast mac configuration

Cristian Birsan <cristian.birsan@microchip.com>
    net: usb: lan78xx: Fix suspend/resume PHY register access error

Ben Hutchings <ben@decadent.org.uk>
    net: qlogic: Fix error paths in ql_alloc_large_buffers()

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: nfc: nci: fix a possible sleep-in-atomic-context bug in nci_uart_tty_receive()

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix a BUG trigered by wrong bytes_compl

Geert Uytterhoeven <geert@linux-m68k.org>
    net: dst: Force 4-byte alignment of dst_metrics

Russell King <rmk+kernel@armlinux.org.uk>
    mod_devicetable: fix PHY module format

Chuhong Yuan <hslester96@gmail.com>
    fjes: fix missed check in fjes_acpi_add

Mao Wenan <maowenan@huawei.com>
    af_packet: set defaule value for tmo


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/kernel/psci.c                           | 15 +++---
 arch/arm64/kvm/sys_regs.c                          |  5 +-
 arch/mips/include/asm/pgtable-64.h                 |  9 +++-
 arch/powerpc/kernel/irq.c                          |  4 +-
 arch/s390/include/asm/pgalloc.h                    | 16 ++++++-
 arch/s390/include/asm/timex.h                      | 16 ++++---
 arch/s390/kernel/dis.c                             | 13 ++---
 arch/sh/include/cpu-sh4/cpu/sh7734.h               |  2 +-
 arch/x86/include/asm/crash.h                       |  2 +
 arch/x86/include/asm/fixmap.h                      |  2 +-
 arch/x86/kernel/apic/io_apic.c                     |  9 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd.c               |  4 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |  2 +-
 arch/x86/lib/x86-opcode-map.txt                    | 18 ++++---
 arch/x86/mm/pgtable.c                              |  4 +-
 drivers/ata/libata-core.c                          |  3 ++
 drivers/block/loop.c                               | 26 ++++++----
 drivers/block/nbd.c                                |  6 +--
 drivers/char/hw_random/omap3-rom-rng.c             |  3 +-
 drivers/cpufreq/cpufreq.c                          |  7 +++
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          | 22 +++++----
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            | 12 ++---
 drivers/crypto/virtio/virtio_crypto_algs.c         | 12 ++++-
 drivers/crypto/vmx/Makefile                        |  6 +--
 drivers/edac/ghes_edac.c                           | 10 +++-
 drivers/extcon/extcon-sm5502.c                     |  4 ++
 drivers/extcon/extcon-sm5502.h                     |  2 +
 drivers/fsi/fsi-core.c                             | 31 ++++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_test.c           |  2 +
 drivers/gpu/drm/bridge/analogix-anx78xx.c          |  8 +++-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          | 12 ++++-
 drivers/gpu/drm/gma500/oaktrail_crtc.c             |  2 +
 drivers/gpu/host1x/job.c                           | 11 +++--
 drivers/hwtracing/intel_th/pci.c                   | 10 ++++
 drivers/iio/adc/dln2-adc.c                         | 20 +++++---
 drivers/iio/adc/max1027.c                          |  8 ++++
 drivers/iio/light/bh1750.c                         |  4 +-
 drivers/infiniband/hw/qedr/verbs.c                 | 12 ++++-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |  1 +
 drivers/media/i2c/ov2659.c                         | 18 +++++--
 drivers/media/i2c/ov6650.c                         | 42 ++++++++--------
 drivers/media/pci/cx88/cx88-video.c                | 11 +++--
 drivers/media/platform/am437x/am437x-vpfe.c        |  4 ++
 drivers/media/platform/qcom/venus/core.c           |  9 ++--
 drivers/media/platform/rcar_drif.c                 |  1 +
 drivers/media/platform/ti-vpe/vpdma.h              |  1 +
 drivers/media/platform/ti-vpe/vpe.c                | 52 ++++++++++++++------
 drivers/media/radio/si470x/radio-si470x-i2c.c      |  2 +
 drivers/media/usb/b2c2/flexcop-usb.c               |  8 +++-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |  9 +++-
 drivers/media/v4l2-core/v4l2-ioctl.c               | 33 +++++++------
 drivers/mmc/host/mtk-sd.c                          |  3 ++
 drivers/mmc/host/sdhci-of-esdhc.c                  |  7 +--
 drivers/mmc/host/sdhci.c                           |  8 ++--
 drivers/mmc/host/tmio_mmc_core.c                   |  2 +-
 drivers/net/dsa/Kconfig                            |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  | 16 +++++--
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  3 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |  8 ++--
 drivers/net/fjes/fjes_main.c                       |  3 ++
 drivers/net/phy/dp83867.c                          | 15 ++++--
 drivers/net/phy/phy_device.c                       |  4 +-
 drivers/net/usb/lan78xx.c                          |  1 +
 drivers/net/wireless/ath/ath10k/mac.c              | 22 ++++-----
 drivers/net/wireless/ath/ath10k/txrx.c             |  2 +
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  3 +-
 drivers/net/wireless/marvell/libertas/if_sdio.c    |  5 ++
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  5 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  3 ++
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  2 +
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  5 +-
 drivers/parport/share.c                            | 21 ++++++++
 drivers/phy/qualcomm/phy-qcom-usb-hs.c             |  7 ++-
 drivers/pinctrl/devicetree.c                       | 25 ++++++++--
 drivers/pinctrl/pinctrl-amd.c                      |  3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |  4 +-
 drivers/platform/x86/hp-wmi.c                      |  2 +-
 drivers/regulator/max8907-regulator.c              | 15 ++++--
 drivers/spi/spi-img-spfi.c                         |  2 +
 drivers/spi/spi-pxa2xx.c                           |  6 +++
 drivers/spi/spi-st-ssc4.c                          |  3 ++
 drivers/spi/spi-tegra20-slink.c                    |  5 +-
 drivers/spi/spidev.c                               |  3 ++
 drivers/staging/comedi/drivers/gsc_hpdi.c          | 10 ++++
 drivers/staging/fbtft/fbtft-core.c                 |  2 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |  4 +-
 drivers/staging/rtl8192u/r8192U_core.c             | 17 +++++--
 drivers/usb/core/devio.c                           | 15 +++++-
 drivers/usb/host/ehci-q.c                          | 13 ++++-
 drivers/usb/host/xhci-pci.c                        |  2 +-
 drivers/usb/renesas_usbhs/common.h                 |  3 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             | 12 +++--
 drivers/usb/usbip/usbip_common.c                   |  3 ++
 drivers/usb/usbip/vhci_rx.c                        | 13 +++--
 fs/btrfs/async-thread.c                            | 56 +++++++++++++++++-----
 fs/btrfs/ctree.c                                   |  2 +-
 fs/btrfs/disk-io.c                                 |  2 +-
 fs/btrfs/extent_io.c                               |  6 ++-
 fs/btrfs/inode.c                                   | 12 ++---
 fs/btrfs/ioctl.c                                   | 10 +++-
 fs/btrfs/reada.c                                   | 10 ++--
 fs/btrfs/relocation.c                              |  1 +
 fs/btrfs/scrub.c                                   |  3 +-
 fs/btrfs/tests/free-space-tree-tests.c             |  6 +--
 fs/btrfs/tests/qgroup-tests.c                      |  4 +-
 fs/btrfs/tree-log.c                                | 23 ++++++++-
 fs/btrfs/uuid-tree.c                               |  2 +
 fs/ext4/dir.c                                      |  5 ++
 fs/ext4/inode.c                                    |  4 +-
 fs/ext4/namei.c                                    | 32 +++++++------
 include/drm/drm_dp_mst_helper.h                    |  2 +-
 include/linux/miscdevice.h                         |  1 +
 include/linux/mod_devicetable.h                    |  4 +-
 include/net/dst.h                                  |  2 +-
 include/trace/events/wbt.h                         | 12 +++--
 include/uapi/linux/cec-funcs.h                     |  6 ++-
 net/bluetooth/hci_core.c                           | 13 +++--
 net/bluetooth/hci_request.c                        |  9 ++++
 net/mac80211/status.c                              |  3 +-
 net/nfc/nci/uart.c                                 |  2 +-
 net/packet/af_packet.c                             |  3 +-
 net/rfkill/core.c                                  |  9 +++-
 net/sctp/protocol.c                                |  5 ++
 samples/bpf/cgroup_helpers.c                       |  2 +-
 samples/pktgen/functions.sh                        | 17 ++++---
 sound/core/pcm_native.c                            |  4 ++
 sound/core/timer.c                                 | 10 ++++
 sound/pci/hda/patch_ca0132.c                       |  7 ++-
 sound/soc/codecs/rt5677.c                          |  1 +
 .../soc/intel/boards/kbl_rt5663_rt5514_max98927.c  |  3 ++
 tools/lib/subcmd/Makefile                          |  4 +-
 tools/lib/traceevent/parse-filter.c                |  9 +++-
 tools/objtool/arch/x86/lib/x86-opcode-map.txt      | 18 ++++---
 tools/perf/builtin-report.c                        |  7 +++
 tools/perf/tests/task-exit.c                       |  1 +
 tools/perf/util/dwarf-aux.c                        | 56 +++++++++++++++++-----
 tools/perf/util/parse-events.c                     |  9 +++-
 tools/perf/util/probe-finder.c                     | 45 +++++++++++++++--
 .../cpupower/utils/idle_monitor/hsw_ext_idle.c     |  1 -
 146 files changed, 959 insertions(+), 353 deletions(-)


