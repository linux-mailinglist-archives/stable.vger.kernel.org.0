Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C587160A27D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiJXLou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiJXLn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:43:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F0072EE4;
        Mon, 24 Oct 2022 04:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F045EB81154;
        Mon, 24 Oct 2022 11:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED62BC433D6;
        Mon, 24 Oct 2022 11:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611553;
        bh=0Ud4jqYWEVHAucrG69Gl7OrieBWsvzWOQ/LDFm+YUuE=;
        h=From:To:Cc:Subject:Date:From;
        b=mfxnE5mjaMGlJ7S7pyXd7maHTqopf1sreYaYD8ozaJLO+RwCXgMk4/GkWnpq02RQ6
         351Xwt6NuIoDClrF2yr04GqbSaQzjPdB4jTZAhsol7cbIQo5bAYIhg45Oy9erMnahu
         1yhMNlOI4slag/lNyVo2lcx0A1SuG8QsasSrGinQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 4.9 000/159] 4.9.331-rc1 review
Date:   Mon, 24 Oct 2022 13:29:14 +0200
Message-Id: <20221024112949.358278806@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.331-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.331-rc1
X-KernelTest-Deadline: 2022-10-26T11:29+00:00
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

This is the start of the stable review cycle for the 4.9.331 release.
There are 159 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.331-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.331-rc1

Martin Liska <mliska@suse.cz>
    gcov: support GCC 12.1 and newer compilers

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: intel_powerclamp: Use first online CPU as control_cpu

Eric Dumazet <edumazet@google.com>
    inet: fully convert sk->sk_rx_dst to RCU rules

Jerry Lee 李修賢 <jerrylee@qnap.com>
    ext4: continue to expand file system when the target size doesn't reach

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net/ieee802154: don't warn zero-sized raw_sendmsg()

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: return -EINVAL for unknown addr type

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: idmouse: fix an uninit-value in idmouse_open

sunghwan jung <onenowy@gmail.com>
    Revert "usb: storage: Add quirk for Samsung Fit flash"

Robin Guo <guoweibin@inspur.com>
    usb: musb: Fix musb_gadget.c rxstate overflow bug

Jianglei Nie <niejianglei2021@163.com>
    usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()

Hyunwoo Kim <imv4bel@gmail.com>
    HID: roccat: Fix use-after-free in roccat_read()

Letu Ren <fantasquex@gmail.com>
    scsi: 3w-9xxx: Avoid disabling device if failing to enable it

Zheyu Ma <zheyuma97@gmail.com>
    media: cx88: Fix a null-ptr-deref bug in buffer_prepare()

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

hongao <hongao@uniontech.com>
    drm/amdgpu: fix initial connector audio value

Hans de Goede <hdegoede@redhat.com>
    platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading

Javier Martinez Canillas <javierm@redhat.com>
    drm: Prevent drm_copy_field() to attempt copying a NULL pointer

Javier Martinez Canillas <javierm@redhat.com>
    drm: Use size_t type for len variable in drm_copy_field()

Andrew Gaul <gaul@gaul.org>
    r8152: Rate limit overflow messages

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix user-after-free

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: bcm: check the result of can_send() in bcm_can_tx()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()

Khalid Masum <khalid.masum.92@gmail.com>
    xfrm: Update ipcomp_scratches with NULL when freed

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-race around tcp_md5sig_pool_populated

Mike Pattrick <mkp@redhat.com>
    openvswitch: Fix overreporting of drops in dropwatch

Mike Pattrick <mkp@redhat.com>
    openvswitch: Fix double reporting of drops in dropwatch

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash

Chao Qin <chao.qin@intel.com>
    powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue

Kees Cook <keescook@chromium.org>
    MIPS: BCM47XX: Cast memcmp() of function to (void *)

Arvid Norlander <lkml@vorpal.se>
    ACPI: video: Add Toshiba Satellite/Portege Z830 quirk

Zhang Qilong <zhangqilong3@huawei.com>
    f2fs: fix race condition on setting FI_NO_EXTENT flag

Dan Carpenter <dan.carpenter@oracle.com>
    iommu/omap: Fix buffer overflow in debugfs

Pali Rohár <pali@kernel.org>
    powerpc: Fix SPE Power ISA properties for e500v1 platforms

Liang He <windhl@126.com>
    powerpc/pci_dn: Add missing of_node_put()

Nathan Chancellor <nathan@kernel.org>
    powerpc/math_emu/efp: Include module.h

Miaoqian Lin <linmq006@gmail.com>
    clk: ti: dra7-atl: Fix reference leak in of_dra7_atl_clk_probe

Stefan Wahren <stefan.wahren@i2se.com>
    clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration

Dave Jiang <dave.jiang@intel.com>
    dmaengine: ioat: stop mod_timer from resurrecting deleted timer in __cleanup()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mfd: sm501: Add check for platform_driver_register()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: lp8788: Fix an error handling path in lp8788_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: intel_soc_pmic: Fix an error handling path in intel_soc_pmic_i2c_probe()

Pali Rohár <pali@kernel.org>
    serial: 8250: Fix restoring termios speed after suspend

Guilherme G. Piccoli <gpiccoli@igalia.com>
    firmware: google: Test spinlock on panic path to avoid lockups

Dan Carpenter <dan.carpenter@oracle.com>
    drivers: serial: jsm: fix some leaks in probe

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_has_dipm()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_has_ncq_autosense()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_has_devslp()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_sense_reporting_enabled() and ata_id_has_sense_reporting()

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: let query-modname override actual module name

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix module.dyndbg handling

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix the error caused by qp->sk

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix "kernel NULL pointer dereference" error

Miaoqian Lin <linmq006@gmail.com>
    media: xilinx: vipp: Fix refcount leak in xvip_graph_dma_init

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

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: ABI: Fix wrong format of differential capacitance channel ABI.

Nuno Sá <nuno.sa@analog.com>
    iio: inkern: only release the device node when done with it

Claudiu Beznea <claudiu.beznea@microchip.com>
    iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ARM: dts: exynos: fix polarity of VBUS GPIO of Origen

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: Drop CMDLINE_* dependency on ATAGS

Michael Walle <michael@walle.cc>
    ARM: dts: kirkwood: lsxl: remove first ethernet port

Michael Walle <michael@walle.cc>
    ARM: dts: kirkwood: lsxl: fix serial line

Liang He <windhl@126.com>
    soc: qcom: smem_state: Add refcounting for the 'state->of_node'

Liang He <windhl@126.com>
    soc: qcom: smsm: Fix refcount leak bugs in qcom_smsm_probe()

Liang He <windhl@126.com>
    memory: of: Fix refcount leak bug in of_get_ddr_timings()

Andreas Pape <apape@de.adit-jv.com>
    ALSA: dmaengine: increment buffer pointer atomically

Liang He <windhl@126.com>
    ASoC: eureka-tlv320: Hold reference returned from of_find_xxx API

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()

Hans de Goede <hdegoede@redhat.com>
    platform/x86: msi-laptop: Fix old-ec check for backlight registering

Maxime Ripard <maxime@cerno.tech>
    drm/mipi-dsi: Detach devices when removing the host

Jianglei Nie <niejianglei2021@163.com>
    bnx2x: fix potential memory leak in bnx2x_tpa_stop()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited

Duoming Zhou <duoming@zju.edu.cn>
    mISDN: fix use-after-free bugs in l1oip timer handlers

Zhang Qilong <zhangqilong3@huawei.com>
    spi/omap100k:Fix PM disable depth imbalance in omap1_spi100k_probe

Zheng Yongjun <zhengyongjun3@huawei.com>
    net: fs_enet: Fix wrong check in do_pd_setup

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration

Xu Qiang <xuqiang36@huawei.com>
    spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()

Xu Qiang <xuqiang36@huawei.com>
    spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()

Hari Chandrakanthan <quic_haric@quicinc.com>
    wifi: mac80211: allow bw change during channel switch in mesh

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()

Kees Cook <keescook@chromium.org>
    sh: machvec: Use char[] for section boundaries

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    selinux: use "grep -E" instead of "egrep"

Michal Luczaj <mhal@rbox.co>
    KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Fix race between reset page and reading page

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Check pending waiters when doing wake ups as well

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Allow splice to read previous partially read pages

Jinke Han <hanjinke.666@bytedance.com>
    ext4: place buffer head allocation before handle start

Lalith Rajendran <lalithkraj@google.com>
    ext4: make ext4_lazyinit_thread freezable

Baokun Li <libaokun1@huawei.com>
    ext4: fix null-ptr-deref in ext4_write_info

Jan Kara <jack@suse.cz>
    ext4: avoid crash when inline data creation follows DIO write

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free bug of struct nilfs_root

Hyunwoo Kim <imv4bel@gmail.com>
    fbdev: smscufx: Fix use-after-free in ufx_ops_open()

Maciej W. Rozycki <macro@orcam.me.uk>
    PCI: Sanitise firmware BAR assignments behind a PCI-PCI bridge

Huacai Chen <chenhuacai@loongson.cn>
    UM: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Helge Deller <deller@gmx.de>
    parisc: fbdev/stifb: Align graphics memory size to 4MB

Linus Walleij <linus.walleij@linaro.org>
    regulator: qcom_rpm: Fix circular deferral regression

Zhihao Cheng <chengzhihao1@huawei.com>
    quota: Check next/prev free block number after reading from quota file

Alexander Aring <aahringo@redhat.com>
    fs: dlm: handle -EBUSY first in lock arg validation

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix race between test_bit() and queue_work()

Michael Hennerich <michael.hennerich@analog.com>
    iio: dac: ad5593r: Fix i2c read protocol requirements

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix NULL dererence at error path

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential memory leaks

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Drop register_mutex in snd_rawmidi_free()

Takashi Iwai <tiwai@suse.de>
    ALSA: oss: Fix potential deadlock at unregistration

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use expired timer rather than wq for mixing fast pool

Cameron Gutman <aicommander@gmail.com>
    Input: xpad - fix wireless 360 controller breaking after suspend

Pavel Rojtberg <rojtberg@gmail.com>
    Input: xpad - add supported devices as contributed on github

Jason A. Donenfeld <Jason@zx2c4.com>
    random: restore O_NONBLOCK support

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: avoid mac80211 warning on bad rate

Jason A. Donenfeld <Jason@zx2c4.com>
    random: avoid reading two cache lines on irq randomness

Frank Wunderlich <frank-w@public-files.de>
    USB: serial: qcserial: add new usb-id for Dell branded EM7455

Linus Torvalds <torvalds@linux-foundation.org>
    scsi: stex: Properly zero out the passthrough command structure

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix position reporting on Poulsbo

Jason A. Donenfeld <Jason@zx2c4.com>
    random: clamp credited irq bits to maximum mixed

Hu Weiwen <sehuww@mail.scut.edu.cn>
    ceph: don't truncate file in atomic_open

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix leak of nilfs_root in case of writer thread creation failure

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix 300 bps rate for SIO

Tadeusz Struk <tadeusz.struk@linaro.org>
    usb: mon: make mmapped memory read only

Lukas Straub <lukasstraub2@web.de>
    um: Cleanup compiler warning in arch/x86/um/tls_32.c

Lukas Straub <lukasstraub2@web.de>
    um: Cleanup syscall_handler_t cast in syscalls_32.h

Haimin Zhang <tcs.kernel@gmail.com>
    net/ieee802154: fix uninit value bug in dgram_sendmsg

Sergei Antonov <saproj@gmail.com>
    ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: fix UAF/GPF bug in nilfs_mdt_destroy

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: fix function graph tracer and unwinder dependencies

Sami Tolvanen <samitolvanen@google.com>
    Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Florian Fainelli <f.fainelli@gmail.com>
    clk: iproc: Do not rely on node name for correct PLL setup

Lori Hikichi <lhikichi@broadcom.com>
    clk: iproc: Minor tidy up of iproc pll data structures

Wang Yufen <wangyufen@huawei.com>
    selftests: Fix the if conditions of in test_extra_filter()

Michael Kelley <mikelley@microsoft.com>
    nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme: add new line after variable declatation

Peilin Ye <peilin.ye@bytedance.com>
    usbnet: Fix memory leak in usbnet_disconnect()

Yang Yingliang <yangyingliang@huawei.com>
    Input: melfas_mip4 - fix return value check in mip4_probe()

Brian Norris <briannorris@chromium.org>
    Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

Maurizio Lombardi <mlombard@redhat.com>
    mm: prevent page_frag_alloc() from corrupting the memory

Sergei Antonov <saproj@gmail.com>
    mmc: moxart: fix 4-bit bus width and remove 8-bit bus width

ChenXiaoSong <chenxiaosong2@huawei.com>
    ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Frank Wunderlich <frank-w@public-files.de>
    net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

Hongling Zeng <zenghongling@kylinos.cn>
    uas: ignore UAS for Thinkplus chips

Hongling Zeng <zenghongling@kylinos.cn>
    usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS

Hongling Zeng <zenghongling@kylinos.cn>
    uas: add no-uas quirk for Hiksemi usb_disk


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio            |  2 +-
 .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  4 +-
 Makefile                                           |  4 +-
 arch/arm/Kconfig                                   |  3 +-
 arch/arm/Kconfig.debug                             |  6 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |  2 +-
 arch/arm/boot/dts/imx6dl.dtsi                      |  3 +
 arch/arm/boot/dts/imx6q.dtsi                       |  3 +
 arch/arm/boot/dts/imx6qp.dtsi                      |  6 ++
 arch/arm/boot/dts/imx6sl.dtsi                      |  3 +
 arch/arm/boot/dts/imx7d-sdb.dts                    |  7 +-
 arch/arm/boot/dts/kirkwood-lsxl.dtsi               | 16 ++--
 arch/arm/boot/dts/moxart-uc7112lx.dts              |  2 +-
 arch/arm/boot/dts/moxart.dtsi                      |  4 +-
 arch/mips/bcm47xx/prom.c                           |  4 +-
 arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi    | 51 ++++++++++++
 arch/powerpc/boot/dts/fsl/mpc8540ads.dts           |  2 +-
 arch/powerpc/boot/dts/fsl/mpc8541cds.dts           |  2 +-
 arch/powerpc/boot/dts/fsl/mpc8555cds.dts           |  2 +-
 arch/powerpc/boot/dts/fsl/mpc8560ads.dts           |  2 +-
 arch/powerpc/kernel/pci_dn.c                       |  1 +
 arch/powerpc/math-emu/math_efp.c                   |  1 +
 arch/sh/include/asm/sections.h                     |  2 +-
 arch/sh/kernel/machvec.c                           | 10 +--
 arch/um/kernel/um_arch.c                           |  2 +-
 arch/x86/kvm/emulate.c                             |  2 +-
 arch/x86/um/shared/sysdep/syscalls_32.h            |  5 +-
 arch/x86/um/tls_32.c                               |  6 --
 drivers/acpi/acpi_video.c                          | 16 ++++
 drivers/char/random.c                              | 22 +++--
 drivers/clk/bcm/clk-bcm2835.c                      |  6 +-
 drivers/clk/bcm/clk-iproc-pll.c                    | 95 ++++++++++------------
 drivers/clk/tegra/clk-tegra114.c                   |  1 +
 drivers/clk/tegra/clk-tegra20.c                    |  1 +
 drivers/clk/tegra/clk-tegra210.c                   |  1 +
 drivers/clk/ti/clk-dra7-atl.c                      |  9 +-
 drivers/dma/ioat/dma.c                             |  6 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  8 +-
 drivers/firmware/google/gsmi.c                     |  9 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  7 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 ---
 drivers/gpu/drm/drm_ioctl.c                        |  8 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |  1 +
 drivers/hid/hid-roccat.c                           |  4 +
 drivers/hsi/controllers/omap_ssi_core.c            |  1 +
 drivers/hsi/controllers/omap_ssi_port.c            |  8 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |  2 +-
 drivers/iio/dac/ad5593r.c                          | 46 ++++++-----
 drivers/iio/inkern.c                               |  6 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 | 10 ++-
 drivers/input/joystick/xpad.c                      | 20 ++++-
 drivers/input/touchscreen/melfas_mip4.c            |  2 +-
 drivers/iommu/omap-iommu-debug.c                   |  6 +-
 drivers/isdn/mISDN/l1oip.h                         |  1 +
 drivers/isdn/mISDN/l1oip_core.c                    | 13 +--
 drivers/media/pci/cx88/cx88-vbi.c                  |  9 +-
 drivers/media/pci/cx88/cx88-video.c                | 43 +++++-----
 drivers/media/platform/exynos4-is/fimc-is.c        |  1 +
 drivers/media/platform/xilinx/xilinx-vipp.c        |  9 +-
 drivers/memory/of_memory.c                         |  1 +
 drivers/mfd/intel_soc_pmic_core.c                  |  1 +
 drivers/mfd/lp8788-irq.c                           |  3 +
 drivers/mfd/lp8788.c                               | 12 ++-
 drivers/mfd/sm501.c                                |  7 +-
 drivers/mmc/host/au1xmmc.c                         |  3 +-
 drivers/mmc/host/moxart-mmc.c                      | 17 +---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  1 +
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c   |  2 +-
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/usb/r8152.c                            |  4 +-
 drivers/net/usb/usbnet.c                           |  7 +-
 drivers/net/wireless/ath/ath10k/mac.c              | 54 ++++++------
 drivers/net/wireless/mac80211_hwsim.c              |  2 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 18 ++--
 drivers/nvme/host/core.c                           |  9 +-
 drivers/pci/setup-res.c                            | 11 +++
 drivers/platform/x86/msi-laptop.c                  | 11 +--
 drivers/powercap/intel_rapl.c                      |  3 +
 drivers/regulator/qcom_rpm-regulator.c             | 24 +++---
 drivers/scsi/3w-9xxx.c                             |  2 +-
 drivers/scsi/stex.c                                | 17 ++--
 drivers/soc/qcom/smem_state.c                      |  3 +-
 drivers/soc/qcom/smsm.c                            | 20 +++--
 drivers/spi/spi-omap-100k.c                        |  1 +
 drivers/spi/spi-qup.c                              | 21 ++++-
 drivers/thermal/intel_powerclamp.c                 |  4 +-
 drivers/tty/serial/8250/8250_port.c                |  7 +-
 drivers/tty/serial/jsm/jsm_driver.c                |  3 +-
 drivers/tty/serial/xilinx_uartps.c                 |  2 +
 drivers/usb/host/xhci-mem.c                        |  7 +-
 drivers/usb/misc/idmouse.c                         |  8 +-
 drivers/usb/mon/mon_bin.c                          |  5 ++
 drivers/usb/musb/musb_gadget.c                     |  3 +
 drivers/usb/serial/ftdi_sio.c                      |  3 +-
 drivers/usb/serial/qcserial.c                      |  1 +
 drivers/usb/storage/unusual_devs.h                 |  6 --
 drivers/usb/storage/unusual_uas.h                  | 21 +++++
 drivers/video/fbdev/smscufx.c                      | 14 +++-
 drivers/video/fbdev/stifb.c                        |  2 +-
 fs/ceph/file.c                                     |  9 +-
 fs/dlm/ast.c                                       |  6 +-
 fs/dlm/lock.c                                      | 16 ++--
 fs/ext4/file.c                                     |  6 ++
 fs/ext4/inode.c                                    |  7 ++
 fs/ext4/resize.c                                   |  2 +-
 fs/ext4/super.c                                    |  3 +-
 fs/f2fs/extent_cache.c                             |  3 +-
 fs/inode.c                                         |  7 +-
 fs/nilfs2/inode.c                                  | 20 ++++-
 fs/nilfs2/segment.c                                | 21 +++--
 fs/ntfs/super.c                                    |  3 +-
 fs/quota/quota_tree.c                              | 38 +++++++++
 include/linux/ata.h                                | 39 +++++----
 include/linux/dynamic_debug.h                      |  2 +-
 include/linux/tcp.h                                |  2 +-
 include/net/ieee802154_netdev.h                    | 43 ++++++++++
 include/net/sock.h                                 |  2 +-
 include/net/tcp.h                                  |  5 +-
 include/scsi/scsi_cmnd.h                           |  2 +-
 kernel/gcov/gcc_4_7.c                              | 18 +++-
 kernel/trace/ring_buffer.c                         | 46 ++++++++++-
 lib/dynamic_debug.c                                | 11 ++-
 mm/page_alloc.c                                    | 12 +++
 net/bluetooth/hci_sysfs.c                          |  3 +
 net/bluetooth/l2cap_core.c                         | 17 +++-
 net/can/bcm.c                                      |  7 +-
 net/ieee802154/socket.c                            | 46 ++++++-----
 net/ipv4/af_inet.c                                 |  2 +-
 net/ipv4/tcp.c                                     | 19 +++--
 net/ipv4/tcp_input.c                               |  2 +-
 net/ipv4/tcp_ipv4.c                                | 13 +--
 net/ipv4/tcp_output.c                              | 19 +++--
 net/ipv4/udp.c                                     |  6 +-
 net/ipv6/tcp_ipv6.c                                | 11 ++-
 net/mac80211/cfg.c                                 |  3 -
 net/openvswitch/datapath.c                         | 18 ++--
 net/rds/tcp.c                                      |  2 +-
 net/xfrm/xfrm_ipcomp.c                             |  1 +
 scripts/Makefile.extrawarn                         |  1 +
 scripts/selinux/install_policy.sh                  |  2 +-
 sound/core/pcm_dmaengine.c                         |  8 +-
 sound/core/rawmidi.c                               |  2 -
 sound/core/sound_oss.c                             | 13 ++-
 sound/pci/hda/hda_intel.c                          |  3 +-
 sound/soc/fsl/eukrea-tlv320.c                      |  8 +-
 sound/usb/endpoint.c                               |  6 +-
 tools/perf/util/intel-pt.c                         |  9 +-
 tools/testing/selftests/net/reuseport_bpf.c        |  2 +-
 149 files changed, 960 insertions(+), 471 deletions(-)


