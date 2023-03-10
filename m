Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C076B40D2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjCJNq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCJNqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:46:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EBD10BA7C;
        Fri, 10 Mar 2023 05:46:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D679F617C8;
        Fri, 10 Mar 2023 13:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8168FC4339B;
        Fri, 10 Mar 2023 13:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678455978;
        bh=4FbTdbSgyjQLh1nAyEIBa6//scB8UbzPKAP7UWkYPRk=;
        h=From:To:Cc:Subject:Date:From;
        b=JrPxEuWOYbv0m7RKbWpVp1NTC3frF1QafyEI7/bNjcwCFyrd4oP/8Bg2FJzy9LKsx
         N0kxaBSh/Z9usOFCLtBTQDLonV69/qnGrXB15EpdFca32KnMIIlKEiNR8dspDqLUiU
         5jLOmSP4WeIAGTvHc9mxF6l31ChzWU10mrqdZ0lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.14 000/193] 4.14.308-rc1 review
Date:   Fri, 10 Mar 2023 14:36:22 +0100
Message-Id: <20230310133710.926811681@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.308-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.308-rc1
X-KernelTest-Deadline: 2023-03-12T13:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.308 release.
There are 193 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.308-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.308-rc1

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: powerclamp: Fix cur_state for multi package system

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix listen() regression in 4.14.303.

Vasily Gorbik <gor@linux.ibm.com>
    s390/setup: init jump labels before command line parsing

Vasily Gorbik <gor@linux.ibm.com>
    s390/maccess: add no DAT mode to kernel_write

Nguyen Dinh Phi <phind.uet@gmail.com>
    Bluetooth: hci_sock: purge socket queues in the destruct() callback

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    phy: rockchip-typec: Fix unsigned comparison with less than zero

Daniel Scally <dan.scally@ideasonboard.com>
    usb: uvc: Enumerate valid values for color matching

Kees Cook <keescook@chromium.org>
    USB: ene_usb6250: Allocate enough memory for full object

Kees Cook <keescook@chromium.org>
    usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()

Yulong Zhang <yulong.zhang@metoak.net>
    tools/iio/iio_utils:fix memory leak

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: disable the CTS when send break signal

Sven Schnelle <svens@linux.ibm.com>
    tty: fix out-of-bounds access in tty_driver_lookup_tty()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Handle cameras with invalid descriptors

Darrell Kavanagh <darrell.kavanagh@gmail.com>
    firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3

Jia-Ju Bai <baijiaju1990@gmail.com>
    tracing: Add NULL checks for buffer in ring_buffer_free_read_page()

Dan Carpenter <error27@gmail.com>
    thermal: intel: quark_dts: fix error pointer dereference

Arnd Bergmann <arnd@arndb.de>
    scsi: ipr: Work around fortify-string warning

Eric Dumazet <edumazet@google.com>
    tcp: tcp_check_req() can be called from process context

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: spear320-hmi: correct STMPE GPIO compatible

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: fix memory leak of se_io context in nfc_genl_se_io

Juergen Gross <jgross@suse.com>
    9p/xen: fix connection sequence

Juergen Gross <jgross@suse.com>
    9p/xen: fix version parsing

Eric Dumazet <edumazet@google.com>
    net: fix __dev_kfree_skb_any() vs drop monitor

Hangyu Hua <hbh25y@gmail.com>
    netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()

Li Hua <hucool.lihua@huawei.com>
    watchdog: pcwd_usb: Fix attempting to access uninitialized memory

Chen Jun <chenjun102@huawei.com>
    watchdog: Fix kmemleak in watchdog_cdev_register

ruanjinjie <ruanjinjie@huawei.com>
    watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    x86: um: vdso: Add '%rcx' and '%r11' to the syscall clobber list

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: ubifs_writepage: Mark page dirty after writing inode failed

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: dirty_cow_znode: Fix memleak in error handling path

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Re-statistic cleaned znode count if commit failed

Yang Yingliang <yangyingliang@huawei.com>
    ubi: Fix possible null-ptr-deref in ubi_free_volume()

Li Zetao <lizetao1@huawei.com>
    ubi: Fix unreferenced object reported by kmemleak in ubi_resize_volume()

Li Zetao <lizetao1@huawei.com>
    ubi: Fix use-after-free when volume resizing failed

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Reserve one leb for each journal head while doing budget

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix wrong dirty space budget for dirty inode

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Rectify space budget for ubifs_xrename()

George Kennedy <george.kennedy@oracle.com>
    ubi: ensure that VID header offset + VID header size <= alloc, size

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    pwm: stm32-lp: fix the check on arr and cmp registers update

Liu Shixin via Jfs-discussion <jfs-discussion@lists.sourceforge.net>
    fs/jfs: fix shift exponent db_agl2size negative

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Retire tcindex classifier

Dmitry Goncharov <dgoncharov@users.sf.net>
    kbuild: Port silent mode detection to future gnu make.

Mark Hawrylak <mark.hawrylak@gmail.com>
    drm/radeon: Fix eDP for single-display iMac11,2

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    PCI: Avoid FLR for AMD FCH AHCI adapters

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix slab-out-of-bounds in ses_intf_remove()

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix possible desc_ptr out-of-bounds accesses

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix possible addl_desc_ptr out-of-bounds accesses

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix slab-out-of-bounds in ses_enclosure_data_process()

James Bottomley <jejb@linux.ibm.com>
    scsi: ses: Don't attach if enclosure has no components

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix erroneous link down

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix link failure in NPIV environment

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Fix missing "end_monitor" when machine check fails

Elvira Khabirova <lineprinter0@gmail.com>
    mips: fix syscall_get_nr

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix FEN fault handling

Ilya Dryomov <idryomov@gmail.com>
    rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid XU

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos4

Mikulas Patocka <mpatocka@redhat.com>
    dm flakey: don't corrupt the zero page

Mikulas Patocka <mpatocka@redhat.com>
    dm flakey: fix logic when corrupting a bio

Alexander Wetzel <alexander@wetzel-home.de>
    wifi: cfg80211: Fix use after free for wext

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Use a longer retry limit of 48

Jun Nie <jun.nie@linaro.org>
    ext4: refuse to create ea block when umounted

Jun Nie <jun.nie@linaro.org>
    ext4: optimize ea_inode block expansion

Dmitry Fomin <fomindmitriyfoma@mail.ru>
    ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Drop bogus fwspec-mapping error handling

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix disassociation race

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix association race

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Align ima_file_mmap() parameters with mmap_file LSM hook

KP Singh <kpsingh@kernel.org>
    Documentation/hw-vuln: Document the interaction between IBRS and STIBP

KP Singh <kpsingh@kernel.org>
    x86/speculation: Allow enabling STIBP with legacy IBRS

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Fix mixed steppings support

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Add a @cpu parameter to the reloading functions

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/amd: Remove load_microcode_amd()'s bsp parameter

Yang Jihong <yangjihong1@huawei.com>
    x86/kprobes: Fix arch_check_optimized_kprobe check within optimized_kprobe range

Yang Jihong <yangjihong1@huawei.com>
    x86/kprobes: Fix __recover_optprobed_insn check optimizing logic

Sean Christopherson <seanjc@google.com>
    x86/reboot: Disable SVM, not just VMX, when stopping CPUs

Sean Christopherson <seanjc@google.com>
    x86/reboot: Disable virtualization in an emergency if SVM is supported

Sean Christopherson <seanjc@google.com>
    x86/crash: Disable virt in core NMI crash handler to avoid double shootdown

Sean Christopherson <seanjc@google.com>
    x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)

Jan Kara <jack@suse.cz>
    udf: Fix file corruption when appending just after end of preallocated extent

Jan Kara <jack@suse.cz>
    udf: Do not update file length for failed writes to inline files

Jan Kara <jack@suse.cz>
    udf: Do not bother merging very long extents

Jan Kara <jack@suse.cz>
    udf: Truncate added extents on failed expansion

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix non-auto defrag path not working issue

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix defrag path triggering jbd2 ASSERT

Eric Biggers <ebiggers@google.com>
    f2fs: fix information leak in f2fs_move_inline_dirents()

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: hfsplus: fix UAF issue in hfsplus_put_super

Liu Shixin <liushixin2@huawei.com>
    hfs: fix missing hfs_bnode_get() in __hfs_bnode_create

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix current_kprobe never cleared after kprobes reenter

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler

Johan Hovold <johan+linaro@kernel.org>
    rtc: pm8xxx: fix set-alarm race

Jun ASAKA <JunASAKA@zzy040330.moe>
    wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

William Zhang <william.zhang@broadcom.com>
    spi: bcm63xx-hsspi: Fix multi-bit mode setting

Mike Snitzer <snitzer@kernel.org>
    dm cache: add cond_resched() to various workqueue loops

Mike Snitzer <snitzer@kernel.org>
    dm thin: add cond_resched() to various workqueue loops

Claudiu Beznea <claudiu.beznea@microchip.com>
    pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Kees Cook <keescook@chromium.org>
    regulator: s5m8767: Bounds check id indexing into arrays

Kees Cook <keescook@chromium.org>
    regulator: max77802: Bounds check regulator id against opmode

Kees Cook <keescook@chromium.org>
    ASoC: kirkwood: Iterate over array indexes instead of using pointer math

Jakob Koschel <jkl820.git@gmail.com>
    docs/scripts/gdb: add necessary make scripts_gdb step

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dsi: Add missing check for alloc_ordered_workqueue

Liwei Song <liwei.song@windriver.com>
    drm/radeon: free iio for atombios when driver shutdown

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Fix Lenovo Ideapad Z570 DMI match

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Check syscall_trace_enter() return code

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Add a check for oversized packets

Mark Rutland <mark.rutland@arm.com>
    ACPI: Don't build ACPICA with '-Os'

Pietro Borrello <borrello@diag.uniroma1.it>
    inet: fix fast path in __inet_hash_connect()

Breno Leitao <leitao@debian.org>
    x86/bugs: Reset speculation control settings on init

Jann Horn <jannh@google.com>
    timers: Prevent union confusion from unexpected restart_syscall()

Yang Li <yang.lee@linux.alibaba.com>
    thermal: intel: Fix unsigned comparison with less than zero

Paul E. McKenney <paulmck@kernel.org>
    rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()

Markuss Broks <markuss.broks@gmail.com>
    ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy

Jan Kara <jack@suse.cz>
    udf: Define EFSCORRUPTED error code

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Avoid infinite loop on intent for missing channel

Duoming Zhou <duoming@zju.edu.cn>
    media: usb: siano: Fix use after free bugs caused by do_submit_urb

Duoming Zhou <duoming@zju.edu.cn>
    media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: platform: ti: Add missing check for devm_regulator_get

Randy Dunlap <rdunlap@infradead.org>
    MIPS: vpe-mt: drop physical_memsize

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/lparcfg: add missing RTAS retry status handling

Frederic Barrat <fbarrat@linux.ibm.com>
    powerpc/powernv/ioda: Skip unallocated resources when mapping to PE

Luca Ellero <l.ellero@asem.it>
    Input: ads7846 - don't check penirq immediately for 7845

Luca Ellero <l.ellero@asem.it>
    Input: ads7846 - don't report pressure for ads7845

Samuel Holland <samuel@sholland.org>
    mtd: rawnand: sunxi: Fix the size of the last OOB region

Qiheng Lin <linqiheng@huawei.com>
    mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()

Mike Snitzer <snitzer@kernel.org>
    dm: remove flush_scheduled_work() during local_exit()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    scsi: aic94xx: Add missing check for dma_map_single()

Jonathan Cormier <jcormier@criticallink.com>
    hwmon: (ltc2945) Handle error case in ltc2945_value_store

Haibo Chen <haibo.chen@nxp.com>
    gpio: vf610: connect GPIO label to dev name

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()

Rob Clark <robdclark@chromium.org>
    drm/mediatek: Drop unbalanced obj unref

Daniel Mentz <danielmentz@google.com>
    drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Alexey V. Vissarionov <gremlin@altlinux.org>
    ALSA: hda/ca0132: minor fix for allocation size

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/hdmi: Add missing check for alloc_ordered_workqueue

Liang He <windhl@126.com>
    gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()

Yuan Can <yuancan@huawei.com>
    drm/bridge: megachips: Fix error handling in i2c_register_driver()

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts

Frank Jungclaus <frank.jungclaus@esd.eu>
    can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Dan Carpenter <error27@gmail.com>
    wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()

Randy Dunlap <rdunlap@infradead.org>
    m68k: /proc/hardware should depend on PROC_FS

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rsa-pkcs1pad - Use akcipher_request_complete

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix potential user-after-free

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    cpufreq: davinci: Fix clk use after free

Miaoqian Lin <linmq006@gmail.com>
    irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe

Miaoqian Lin <linmq006@gmail.com>
    irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains

Jack Morgenstein <jackm@nvidia.com>
    net/mlx5: Enhance debug print in page allocation failure

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Add expoline to tail calls

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: seqiv - Handle EBUSY correctly

Armin Wolf <W_Armin@gmx.de>
    ACPI: battery: Fix missing NUL-termination with large strings

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: orinoco: check return value of hermes_write_wordrec()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: nsrepair: handle cases without a return value correctly

Herbert Xu <herbert@gondor.apana.org.au>
    lib/mpi: Fix buffer overrun when SG is too long

Zhen Lei <thunder.leizhen@huawei.com>
    genirq: Fix the return type of kstat_cpu_irqs_sum()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()

Zhang Changzhong <zhangchangzhong@huawei.com>
    wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: ipw2200: fix memory leak in ipw_wdev_init()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: libertas: fix memory leak in lbs_init_adapter()

Martin K. Petersen <martin.petersen@oracle.com>
    block: bio-integrity: Copy flags when bio_integrity_payload is cloned

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: add missing unit address to rng node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: fix SCPI clock dvfs node name

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato

Yang Yingliang <yangyingliang@huawei.com>
    ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix Ethernet MAC address unit name

Qiheng Lin <linqiheng@huawei.com>
    ARM: zynq: Fix refcount leak in zynq_early_slcr_init

Chen Hui <judy.chenhui@huawei.com>
    ARM: OMAP2+: Fix memory leak in realtime_counter_init()

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: asus: use spinlock to safely schedule workers

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: asus: use spinlock to protect concurrent accesses

Luke D. Jones <luke@ljones.dev>
    HID: asus: Remove check for same LED brightness on set

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Florian Zumbiehl <florz@florz.de>
    USB: serial: option: add support for VW/Skoda "Carstick LTE"

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix truncation handling for mod32 dst reg wrt zero

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix 32 bit src register truncation on div/mod

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix subprog verifier bypass by div/mod by 0 exception

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Do not use ax register in interpreter on div/mod

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Assign npages earlier

David Sterba <dsterba@suse.com>
    btrfs: send: limit number of clones and allocated memory size

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: add power-domains property to dp node on rk3288


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst      |  21 +-
 Documentation/dev-tools/gdb-kernel-debugging.rst   |   4 +
 Makefile                                           |  17 +-
 arch/alpha/kernel/traps.c                          |  30 +-
 arch/arm/boot/dts/exynos3250-rinato.dts            |   2 +-
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi         |   2 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |   1 -
 arch/arm/boot/dts/exynos5420.dtsi                  |   2 +-
 arch/arm/boot/dts/rk3288.dtsi                      |   1 +
 arch/arm/boot/dts/spear320-hmi.dts                 |   2 +-
 arch/arm/mach-omap1/timer.c                        |   2 +-
 arch/arm/mach-omap2/timer.c                        |   1 +
 arch/arm/mach-zynq/slcr.c                          |   1 +
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   6 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   2 +-
 arch/m68k/68000/entry.S                            |   2 +
 arch/m68k/Kconfig.devices                          |   1 +
 arch/m68k/coldfire/entry.S                         |   2 +
 arch/m68k/kernel/entry.S                           |   3 +
 arch/mips/include/asm/syscall.h                    |   2 +-
 arch/mips/include/asm/vpe.h                        |   1 -
 arch/mips/kernel/vpe-mt.c                          |   7 +-
 arch/mips/lantiq/prom.c                            |   6 -
 arch/powerpc/platforms/powernv/pci-ioda.c          |   3 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |  20 +-
 arch/s390/kernel/kprobes.c                         |   4 +-
 arch/s390/kernel/setup.c                           |   1 +
 arch/s390/mm/maccess.c                             |  16 +-
 arch/s390/net/bpf_jit_comp.c                       |  12 +-
 arch/x86/include/asm/microcode.h                   |   4 +-
 arch/x86/include/asm/microcode_amd.h               |   4 +-
 arch/x86/include/asm/msr-index.h                   |   4 +
 arch/x86/include/asm/reboot.h                      |   2 +
 arch/x86/include/asm/virtext.h                     |  16 +-
 arch/x86/kernel/cpu/bugs.c                         |  35 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  53 +-
 arch/x86/kernel/cpu/microcode/core.c               |   6 +-
 arch/x86/kernel/crash.c                            |  17 +-
 arch/x86/kernel/kprobes/opt.c                      |   6 +-
 arch/x86/kernel/reboot.c                           |  88 ++-
 arch/x86/kernel/smp.c                              |   6 +-
 arch/x86/kernel/sysfb_efi.c                        |   8 +
 arch/x86/um/vdso/um_vdso.c                         |  12 +-
 block/bio-integrity.c                              |   1 +
 crypto/rsa-pkcs1pad.c                              |  34 +-
 crypto/seqiv.c                                     |   2 +-
 drivers/acpi/acpica/Makefile                       |   2 +-
 drivers/acpi/acpica/nsrepair.c                     |  12 +-
 drivers/acpi/battery.c                             |   2 +-
 drivers/acpi/video_detect.c                        |   2 +-
 drivers/block/rbd.c                                |  20 +-
 drivers/cpufreq/davinci-cpufreq.c                  |   4 +-
 drivers/dma/sh/rcar-dmac.c                         |   5 +-
 drivers/gpio/gpio-vf610.c                          |   2 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |   6 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |  52 ++
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   2 -
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   3 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   4 +
 drivers/gpu/drm/mxsfb/Kconfig                      |   1 +
 drivers/gpu/drm/radeon/atombios_encoders.c         |   5 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   1 +
 drivers/gpu/ipu-v3/ipu-common.c                    |   1 +
 drivers/hid/hid-asus.c                             |  38 +-
 drivers/hwmon/ltc2945.c                            |   2 +
 drivers/iio/accel/mma9551_core.c                   |  10 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |   9 +-
 drivers/input/touchscreen/ads7846.c                |  13 +-
 drivers/irqchip/irq-alpine-msi.c                   |   1 +
 drivers/irqchip/irq-bcm7120-l2.c                   |   3 +-
 drivers/irqchip/irq-mvebu-gicp.c                   |   1 +
 drivers/md/dm-cache-target.c                       |   4 +
 drivers/md/dm-flakey.c                             |  30 +-
 drivers/md/dm-thin.c                               |   2 +
 drivers/md/dm.c                                    |   1 -
 drivers/media/platform/omap3isp/isp.c              |   9 +
 drivers/media/rc/ene_ir.c                          |   3 +-
 drivers/media/usb/siano/smsusb.c                   |   1 +
 drivers/media/usb/uvc/uvc_entity.c                 |   2 +-
 drivers/mfd/pcf50633-adc.c                         |   7 +-
 drivers/mtd/nand/sunxi_nand.c                      |   2 +-
 drivers/mtd/ubi/build.c                            |   7 +
 drivers/mtd/ubi/vmt.c                              |  18 +-
 drivers/mtd/ubi/wl.c                               |  25 +-
 drivers/net/can/usb/esd_usb2.c                     |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   8 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   3 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   4 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   5 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   9 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |   2 +
 drivers/net/wireless/marvell/libertas/cmdresp.c    |   2 +-
 drivers/net/wireless/marvell/libertas/main.c       |   3 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |   6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   5 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  11 +-
 drivers/net/wireless/wl3501_cs.c                   |   2 +-
 drivers/nfc/st-nci/se.c                            |   6 +
 drivers/nfc/st21nfca/se.c                          |   6 +
 drivers/pci/quirks.c                               |   1 +
 drivers/phy/rockchip/phy-rockchip-typec.c          |   3 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                |   4 +-
 drivers/pinctrl/pinctrl-at91.c                     |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   1 +
 drivers/pwm/pwm-stm32-lp.c                         |   2 +-
 drivers/regulator/max77802-regulator.c             |  34 +-
 drivers/regulator/s5m8767.c                        |   6 +-
 drivers/rpmsg/qcom_glink_native.c                  |   1 +
 drivers/rtc/rtc-pm8xxx.c                           |  24 +-
 drivers/scsi/aic94xx/aic94xx_task.c                |   3 +
 drivers/scsi/ipr.c                                 |  41 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   9 +-
 drivers/scsi/ses.c                                 |  64 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |  12 +-
 drivers/thermal/intel_powerclamp.c                 |  20 +-
 drivers/thermal/intel_quark_dts_thermal.c          |  12 +-
 drivers/thermal/intel_soc_dts_iosf.c               |   2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  24 +-
 drivers/tty/tty_io.c                               |   8 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/sysfs.c                           |   5 -
 drivers/usb/host/xhci-mvebu.c                      |   2 +-
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/storage/ene_ub6250.c                   |   2 +-
 drivers/watchdog/at91sam9_wdt.c                    |   7 +-
 drivers/watchdog/pcwd_usb.c                        |   6 +-
 drivers/watchdog/watchdog_dev.c                    |   2 +-
 fs/btrfs/send.c                                    |   6 +-
 fs/ext4/xattr.c                                    |  35 +-
 fs/f2fs/inline.c                                   |  13 +-
 fs/hfs/bnode.c                                     |   1 +
 fs/hfsplus/super.c                                 |   4 +-
 fs/jfs/jfs_dmap.c                                  |   3 +-
 fs/ocfs2/move_extents.c                            |  34 +-
 fs/ubifs/budget.c                                  |   9 +-
 fs/ubifs/dir.c                                     |   5 +
 fs/ubifs/file.c                                    |  12 +-
 fs/ubifs/tnc.c                                     |  24 +-
 fs/udf/file.c                                      |  26 +-
 fs/udf/inode.c                                     |  58 +-
 fs/udf/udf_sb.h                                    |   2 +
 include/drm/drm_mipi_dsi.h                         |   4 +
 include/linux/filter.h                             |  24 +
 include/linux/ima.h                                |   6 +-
 include/linux/kernel_stat.h                        |   2 +-
 include/linux/kprobes.h                            |   2 +
 include/uapi/linux/usb/video.h                     |  30 +
 kernel/bpf/core.c                                  |  39 +-
 kernel/bpf/verifier.c                              |  39 +-
 kernel/irq/irqdomain.c                             |  31 +-
 kernel/kprobes.c                                   |   6 +-
 kernel/rcu/tree_exp.h                              |   2 +
 kernel/time/hrtimer.c                              |   2 +
 kernel/time/posix-stubs.c                          |   2 +
 kernel/time/posix-timers.c                         |   2 +
 kernel/trace/ring_buffer.c                         |   7 +-
 lib/mpi/mpicoder.c                                 |   3 +-
 net/9p/trans_xen.c                                 |  48 +-
 net/bluetooth/hci_sock.c                           |  11 +-
 net/bluetooth/l2cap_core.c                         |  24 -
 net/bluetooth/l2cap_sock.c                         |   8 +
 net/caif/caif_socket.c                             |   1 +
 net/core/dev.c                                     |   4 +-
 net/core/filter.c                                  |   9 +-
 net/core/stream.c                                  |   1 -
 net/ipv4/inet_connection_sock.c                    |   1 +
 net/ipv4/inet_hashtables.c                         |  12 +-
 net/ipv4/tcp_minisocks.c                           |   7 +-
 net/netfilter/nf_conntrack_netlink.c               |   5 +-
 net/nfc/netlink.c                                  |   4 +
 net/sched/Kconfig                                  |  11 -
 net/sched/Makefile                                 |   1 -
 net/sched/cls_tcindex.c                            | 690 ---------------------
 net/wireless/sme.c                                 |  31 +-
 security/integrity/ima/ima_main.c                  |   7 +-
 security/security.c                                |   7 +-
 sound/pci/hda/patch_ca0132.c                       |   2 +-
 sound/pci/ice1712/aureon.c                         |   2 +-
 sound/soc/kirkwood/kirkwood-dma.c                  |   2 +-
 sound/soc/soc-compress.c                           |   2 +-
 tools/iio/iio_utils.c                              |  23 +-
 tools/testing/ktest/ktest.pl                       |   3 +-
 185 files changed, 1175 insertions(+), 1343 deletions(-)


