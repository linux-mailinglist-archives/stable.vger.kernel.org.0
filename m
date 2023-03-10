Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E5D6B43A4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbjCJOQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjCJOQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:16:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F53310CC;
        Fri, 10 Mar 2023 06:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C7A561380;
        Fri, 10 Mar 2023 14:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD183C433D2;
        Fri, 10 Mar 2023 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457699;
        bh=1KUeOB1PAeTfk+OasBvzKLiCo8G7DtZS2ZgkobH1BPQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ear1I3i5GgZyydcwo09CAS2cjNANUaVyFiIJ+4plBPhMgQx9jZGtQbYvrVEdvOLgy
         luwnkCj1H3oOuFf7NZD7MgYfbrv+OyyGdJjr+uPoOuxpKlzkfmR+zDn+8apws4pLIi
         TVsfbLODvggZSjPMeb4vZ4R9W8Myrj7MDs7P2puY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.19 000/252] 4.19.276-rc1 review
Date:   Fri, 10 Mar 2023 14:36:10 +0100
Message-Id: <20230310133718.803482157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.276-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.276-rc1
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

This is the start of the stable review cycle for the 4.19.276 release.
There are 252 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.276-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.276-rc1

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: powerclamp: Fix cur_state for multi package system

Eric Biggers <ebiggers@google.com>
    f2fs: fix cgroup writeback accounting with fs-layer encryption

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix race condition with usb_kill_urb

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Provide sync and async uvc_ctrl_status_event

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix listen() regression in 4.19.270

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

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus-fixup:upon error print return values of send and receive

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: disable the CTS when send break signal

Sven Schnelle <svens@linux.ibm.com>
    tty: fix out-of-bounds access in tty_driver_lookup_tty()

Kees Cook <keescook@chromium.org>
    media: uvcvideo: Silence memcpy() run-time false positive warnings

Guenter Roeck <linux@roeck-us.net>
    media: uvcvideo: Handle errors from calls to usb_string

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

George Kennedy <george.kennedy@oracle.com>
    vc_screen: modify vcs_size() handling in vcs_read()

Eric Dumazet <edumazet@google.com>
    tcp: tcp_check_req() can be called from process context

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: spear320-hmi: correct STMPE GPIO compatible

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: fix memory leak of se_io context in nfc_genl_se_io

Zhengchao Shao <shaozhengchao@huawei.com>
    9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()

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
    ubifs: do_rename: Fix wrong space budget when target inode's nlink > 1

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix wrong dirty space budget for dirty inode

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Rectify space budget for ubifs_xrename()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Rectify space budget for ubifs_symlink() if symlink is encrypted

George Kennedy <george.kennedy@oracle.com>
    ubi: ensure that VID header offset + VID header size <= alloc, size

Xiang Yang <xiangyang3@huawei.com>
    um: vector: Fix memory leak in vector_config

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    pwm: stm32-lp: fix the check on arr and cmp registers update

Liu Shixin via Jfs-discussion <jfs-discussion@lists.sourceforge.net>
    fs/jfs: fix shift exponent db_agl2size negative

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Retire tcindex classifier

Dmitry Goncharov <dgoncharov@users.sf.net>
    kbuild: Port silent mode detection to future gnu make.

Arnd Bergmann <arnd@arndb.de>
    wifi: ath9k: use proper statements in conditionals

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
    ktest.pl: Add RUN_TIMEOUT option with default unlimited

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Fix missing "end_monitor" when machine check fails

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Give back console on Ctrt^C on monitor

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu3-cio2: Fix PM runtime usage_count in driver unbind

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

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct HDMI phy compatible in Exynos4

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix current_kprobe never cleared after kprobes reenter

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler

Ilya Leoshkevich <iii@linux.ibm.com>
    s390: discard .interp section

Johan Hovold <johan+linaro@kernel.org>
    rtc: pm8xxx: fix set-alarm race

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    firmware: coreboot: framebuffer: Ignore reserved pixel color bits

Jun ASAKA <JunASAKA@zzy040330.moe>
    wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

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

Roman Li <roman.li@amd.com>
    drm/amd/display: Fix potential null-deref in dm_resume

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer: Fix debug print

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

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: brcmfmac: ensure CLM version is null-terminated to prevent stack-out-of-bounds

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

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: i2c: ov7670: 0 instead of -EINVAL was returned

Duoming Zhou <duoming@zju.edu.cn>
    media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()

Yuan Can <yuancan@huawei.com>
    media: i2c: ov772x: Fix memleak in ov772x_probe()

Nathan Chancellor <nathan@kernel.org>
    powerpc: Remove linker flag from KBUILD_AFLAGS

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: platform: ti: Add missing check for devm_regulator_get

Randy Dunlap <rdunlap@infradead.org>
    MIPS: vpe-mt: drop physical_memsize

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: ensure 4KB alignment for rtas_data_buf

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: make all exports GPL

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/lparcfg: add missing RTAS retry status handling

Chen-Yu Tsai <wenst@chromium.org>
    clk: Honor CLK_OPS_PARENT_ENABLE in clk_core_is_enabled()

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

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix bash specific "==" operator

Randy Dunlap <rdunlap@infradead.org>
    sparc: allow PM configs for sparc32 COMPILE_TEST

Yicong Yang <yangyicong@hisilicon.com>
    perf tools: Fix auto-complete on aarch64

Ian Rogers <irogers@google.com>
    perf llvm: Fix inadvertent file creation

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: jdata writepage fix

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix warning and UAF when destroy the MR list

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix lost destroy smbd connection when MR allocate failed

Benjamin Coddington <bcodding@redhat.com>
    nfsd: fix race to check ls_layouts

Mike Snitzer <snitzer@kernel.org>
    dm: remove flush_scheduled_work() during local_exit()

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (mlxreg-fan) Return zero speed for broken fan

William Zhang <william.zhang@broadcom.com>
    spi: bcm63xx-hsspi: Fix multi-bit mode setting

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-hsspi: fix pm_runtime

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    scsi: aic94xx: Add missing check for dma_map_single()

Jonathan Cormier <jcormier@criticallink.com>
    hwmon: (ltc2945) Handle error case in ltc2945_value_store

Haibo Chen <haibo.chen@nxp.com>
    gpio: vf610: connect GPIO label to dev name

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/mediatek: Clean dangling pointer on bind error path

Rob Clark <robdclark@chromium.org>
    drm/mediatek: Drop unbalanced obj unref

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Don't skip assigning syncpoints to channels

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dpu: Add check for pstates

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: use strscpy instead of strncpy

Daniel Mentz <danielmentz@google.com>
    drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Alexey V. Vissarionov <gremlin@altlinux.org>
    ALSA: hda/ca0132: minor fix for allocation size

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups

Lee Jones <lee.jones@linaro.org>
    pinctrl: pinctrl-rockchip: Fix a bunch of kerneldoc misdemeanours

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/hdmi: Add missing check for alloc_ordered_workqueue

Liang He <windhl@126.com>
    gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dpi: Fix format mapping for RGB565

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dpi: Add option for inverting pixel clock and output enable

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: Clarify definition of the DRM_BUS_FLAG_(PIXDATA|SYNC)_* macros

Yuan Can <yuancan@huawei.com>
    drm/bridge: megachips: Fix error handling in i2c_register_driver()

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC

Roxana Nicolescu <roxana.nicolescu@canonical.com>
    selftest: fib_tests: Always cleanup before exit

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts

Frank Jungclaus <frank.jungclaus@esd.eu>
    can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: crypto4xx - Call dma_unmap_page when done

Dan Carpenter <error27@gmail.com>
    wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    wifi: iwl4965: Add missing check for create_singlethread_workqueue()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    wifi: iwl3945: Add missing check for create_singlethread_workqueue

Conor Dooley <conor.dooley@microchip.com>
    RISC-V: time: initialize hrtimer based broadcast clock event device

Randy Dunlap <rdunlap@infradead.org>
    m68k: /proc/hardware should depend on PROC_FS

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rsa-pkcs1pad - Use akcipher_request_complete

Pietro Borrello <borrello@diag.uniroma1.it>
    rds: rds_rm_zerocopy_callback() correct order for list_add_tail()

Ilya Leoshkevich <iii@linux.ibm.com>
    libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix potential user-after-free

Miaoqian Lin <linmq006@gmail.com>
    irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe

Miaoqian Lin <linmq006@gmail.com>
    irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains

Jack Morgenstein <jackm@nvidia.com>
    net/mlx5: Enhance debug print in page allocation failure

Yang Yingliang <yangyingliang@huawei.com>
    powercap: fix possible name leak in powercap_register_zone()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: seqiv - Handle EBUSY correctly

Armin Wolf <W_Armin@gmx.de>
    ACPI: battery: Fix missing NUL-termination with large strings

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails

Pavel Skripkin <paskripkin@gmail.com>
    ath9k: htc: clean up statistics macros

Wan Jiabing <wanjiabing@vivo.com>
    ath9k: hif_usb: simplify if-if to if-else

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

Mario Limonciello <mario.limonciello@amd.com>
    ACPICA: Drop port I/O validation for some regions

Yang Yingliang <yangyingliang@huawei.com>
    wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas: if_usb: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas_tf: don't call kfree_skb() under spin_lock_irqsave()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()

Zhang Changzhong <zhangchangzhong@huawei.com>
    wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: ipw2200: fix memory leak in ipw_wdev_init()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ipw2x00: switch from 'pci_' to 'dma_' API

Li Zetao <lizetao1@huawei.com>
    wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()

Arnd Bergmann <arnd@arndb.de>
    rtlwifi: fix -Wpointer-sign warning

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: libertas: fix memory leak in lbs_init_adapter()

Yuan Can <yuancan@huawei.com>
    wifi: rsi: Fix memory leak in rsi_coex_attach()

Martin K. Petersen <martin.petersen@oracle.com>
    block: bio-integrity: Copy flags when bio_integrity_payload is cloned

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: add missing unit address to rng node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: meson-axg: enable SCPI

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: fix SCPI clock dvfs node name

Angus Chen <angus.chen@jaguarmicro.com>
    ARM: imx: Call ida_simple_remove() for ida_simple_get

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


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst      |  21 +-
 Documentation/dev-tools/gdb-kernel-debugging.rst   |   4 +
 Makefile                                           |  17 +-
 arch/alpha/kernel/traps.c                          |  30 +-
 arch/arm/boot/dts/exynos3250-rinato.dts            |   2 +-
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi         |   2 +-
 arch/arm/boot/dts/exynos4.dtsi                     |   2 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |   1 -
 arch/arm/boot/dts/exynos5420.dtsi                  |   2 +-
 arch/arm/boot/dts/spear320-hmi.dts                 |   2 +-
 arch/arm/mach-imx/mmdc.c                           |  24 +-
 arch/arm/mach-omap1/timer.c                        |   2 +-
 arch/arm/mach-omap2/timer.c                        |   1 +
 arch/arm/mach-zynq/slcr.c                          |   1 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |  26 +
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   6 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   2 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |   1 +
 arch/m68k/68000/entry.S                            |   2 +
 arch/m68k/Kconfig.devices                          |   1 +
 arch/m68k/coldfire/entry.S                         |   2 +
 arch/m68k/kernel/entry.S                           |   3 +
 arch/mips/include/asm/syscall.h                    |   2 +-
 arch/mips/include/asm/vpe.h                        |   1 -
 arch/mips/kernel/vpe-mt.c                          |   7 +-
 arch/mips/lantiq/prom.c                            |   6 -
 arch/powerpc/Makefile                              |   2 +-
 arch/powerpc/kernel/rtas.c                         |  24 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   3 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |  20 +-
 arch/riscv/kernel/time.c                           |   3 +
 arch/s390/kernel/kprobes.c                         |   4 +-
 arch/s390/kernel/setup.c                           |   1 +
 arch/s390/kernel/vmlinux.lds.S                     |   1 +
 arch/s390/mm/maccess.c                             |  16 +-
 arch/sparc/Kconfig                                 |   2 +-
 arch/um/drivers/vector_kern.c                      |   1 +
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
 block/blk-mq-sched.c                               |   3 +-
 crypto/rsa-pkcs1pad.c                              |  34 +-
 crypto/seqiv.c                                     |   2 +-
 drivers/acpi/acpica/Makefile                       |   2 +-
 drivers/acpi/acpica/hwvalid.c                      |   7 +-
 drivers/acpi/acpica/nsrepair.c                     |  12 +-
 drivers/acpi/battery.c                             |   2 +-
 drivers/acpi/video_detect.c                        |   2 +-
 drivers/block/rbd.c                                |  20 +-
 drivers/clk/clk.c                                  |  11 +
 drivers/crypto/amcc/crypto4xx_core.c               |  10 +-
 drivers/firmware/google/framebuffer-coreboot.c     |   4 +-
 drivers/gpio/gpio-vf610.c                          |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |   6 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |  52 ++
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   1 +
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   2 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   2 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   3 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   4 +
 drivers/gpu/drm/msm/msm_fence.c                    |   2 +-
 drivers/gpu/drm/mxsfb/Kconfig                      |   1 +
 drivers/gpu/drm/radeon/atombios_encoders.c         |   5 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   1 +
 drivers/gpu/drm/vc4/vc4_dpi.c                      |  66 +-
 drivers/gpu/host1x/hw/syncpt_hw.c                  |   3 -
 drivers/gpu/ipu-v3/ipu-common.c                    |   1 +
 drivers/hid/hid-asus.c                             |  38 +-
 drivers/hwmon/ltc2945.c                            |   2 +
 drivers/hwmon/mlxreg-fan.c                         |   6 +
 drivers/iio/accel/mma9551_core.c                   |  10 +-
 drivers/input/touchscreen/ads7846.c                |  13 +-
 drivers/irqchip/irq-alpine-msi.c                   |   1 +
 drivers/irqchip/irq-bcm7120-l2.c                   |   3 +-
 drivers/irqchip/irq-brcmstb-l2.c                   |   6 +-
 drivers/irqchip/irq-mvebu-gicp.c                   |   1 +
 drivers/md/dm-cache-target.c                       |   4 +
 drivers/md/dm-flakey.c                             |  30 +-
 drivers/md/dm-thin.c                               |   2 +
 drivers/md/dm.c                                    |   1 -
 drivers/media/i2c/ov7670.c                         |   2 +-
 drivers/media/i2c/ov772x.c                         |   3 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   3 +
 drivers/media/platform/omap3isp/isp.c              |   9 +
 drivers/media/rc/ene_ir.c                          |   3 +-
 drivers/media/usb/siano/smsusb.c                   |   1 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |  30 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  48 +-
 drivers/media/usb/uvc/uvc_entity.c                 |   2 +-
 drivers/media/usb/uvc/uvc_status.c                 |  40 +-
 drivers/media/usb/uvc/uvc_video.c                  |   4 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   5 +-
 drivers/mfd/pcf50633-adc.c                         |   7 +-
 drivers/misc/mei/bus-fixup.c                       |   8 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   2 +-
 drivers/mtd/ubi/build.c                            |   7 +
 drivers/mtd/ubi/vmt.c                              |  18 +-
 drivers/mtd/ubi/wl.c                               |  25 +-
 drivers/net/can/usb/esd_usb2.c                     |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   8 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   3 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  60 +-
 drivers/net/wireless/ath/ath9k/htc.h               |  32 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  10 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   4 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   5 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       | 121 ++--
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  67 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |  16 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  12 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |   2 +
 drivers/net/wireless/marvell/libertas/cmdresp.c    |   2 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   2 +-
 drivers/net/wireless/marvell/libertas/main.c       |   3 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |   6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   5 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  11 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |  91 ++-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.h |   4 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c            |   1 +
 drivers/net/wireless/wl3501_cs.c                   |   2 +-
 drivers/nfc/st-nci/se.c                            |   6 +
 drivers/nfc/st21nfca/se.c                          |   6 +
 drivers/pci/quirks.c                               |   1 +
 drivers/phy/rockchip/phy-rockchip-typec.c          |   3 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                |   4 +-
 drivers/pinctrl/pinctrl-at91.c                     |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  23 +-
 drivers/powercap/powercap_sys.c                    |  14 +-
 drivers/pwm/pwm-stm32-lp.c                         |   2 +-
 drivers/regulator/max77802-regulator.c             |  34 +-
 drivers/regulator/s5m8767.c                        |   6 +-
 drivers/rpmsg/qcom_glink_native.c                  |   1 +
 drivers/rtc/rtc-pm8xxx.c                           |  24 +-
 drivers/scsi/aic94xx/aic94xx_task.c                |   3 +
 drivers/scsi/ipr.c                                 |  41 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   9 +-
 drivers/scsi/ses.c                                 |  64 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |  20 +-
 drivers/thermal/intel_powerclamp.c                 |  20 +-
 drivers/thermal/intel_quark_dts_thermal.c          |  12 +-
 drivers/thermal/intel_soc_dts_iosf.c               |   2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  24 +-
 drivers/tty/tty_io.c                               |   8 +-
 drivers/tty/vt/vc_screen.c                         |   4 +-
 drivers/usb/host/xhci-mvebu.c                      |   2 +-
 drivers/usb/storage/ene_ub6250.c                   |   2 +-
 drivers/watchdog/at91sam9_wdt.c                    |   7 +-
 drivers/watchdog/pcwd_usb.c                        |   6 +-
 drivers/watchdog/watchdog_dev.c                    |   2 +-
 fs/cifs/smbdirect.c                                |   4 +-
 fs/ext4/xattr.c                                    |  35 +-
 fs/f2fs/data.c                                     |   4 +-
 fs/f2fs/inline.c                                   |  13 +-
 fs/gfs2/aops.c                                     |   3 +-
 fs/hfs/bnode.c                                     |   1 +
 fs/hfsplus/super.c                                 |   4 +-
 fs/jfs/jfs_dmap.c                                  |   3 +-
 fs/nfsd/nfs4layouts.c                              |   4 +-
 fs/ocfs2/move_extents.c                            |  34 +-
 fs/ubifs/budget.c                                  |   9 +-
 fs/ubifs/dir.c                                     |  13 +-
 fs/ubifs/file.c                                    |  12 +-
 fs/ubifs/tnc.c                                     |  24 +-
 fs/udf/file.c                                      |  26 +-
 fs/udf/inode.c                                     |  58 +-
 fs/udf/udf_sb.h                                    |   2 +
 include/drm/drm_connector.h                        |  36 +-
 include/drm/drm_mipi_dsi.h                         |   4 +
 include/linux/ima.h                                |   6 +-
 include/linux/kernel_stat.h                        |   2 +-
 include/linux/kprobes.h                            |   2 +
 include/uapi/linux/usb/video.h                     |  30 +
 include/uapi/linux/uvcvideo.h                      |   2 +-
 kernel/irq/irqdomain.c                             |  31 +-
 kernel/kprobes.c                                   |   6 +-
 kernel/rcu/tree_exp.h                              |   2 +
 kernel/time/hrtimer.c                              |   2 +
 kernel/time/posix-stubs.c                          |   2 +
 kernel/time/posix-timers.c                         |   2 +
 kernel/trace/ring_buffer.c                         |   7 +-
 lib/mpi/mpicoder.c                                 |   3 +-
 net/9p/trans_rdma.c                                |  15 +-
 net/9p/trans_xen.c                                 |  48 +-
 net/bluetooth/hci_sock.c                           |  11 +-
 net/bluetooth/l2cap_core.c                         |  24 -
 net/bluetooth/l2cap_sock.c                         |   8 +
 net/core/dev.c                                     |   4 +-
 net/ipv4/inet_connection_sock.c                    |   1 +
 net/ipv4/inet_hashtables.c                         |  12 +-
 net/ipv4/tcp_minisocks.c                           |   7 +-
 net/mac80211/sta_info.c                            |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |   5 +-
 net/nfc/netlink.c                                  |   4 +
 net/rds/message.c                                  |   2 +-
 net/sched/Kconfig                                  |  11 -
 net/sched/Makefile                                 |   1 -
 net/sched/cls_tcindex.c                            | 698 ---------------------
 net/wireless/sme.c                                 |  31 +-
 security/integrity/ima/ima_main.c                  |   7 +-
 security/security.c                                |   7 +-
 sound/pci/hda/patch_ca0132.c                       |   2 +-
 sound/pci/ice1712/aureon.c                         |   2 +-
 sound/soc/kirkwood/kirkwood-dma.c                  |   2 +-
 sound/soc/soc-compress.c                           |   2 +-
 tools/iio/iio_utils.c                              |  23 +-
 tools/lib/bpf/nlattr.c                             |   2 +-
 tools/perf/perf-completion.sh                      |  11 +-
 tools/perf/util/llvm-utils.c                       |  25 +-
 tools/testing/ktest/ktest.pl                       |  26 +-
 tools/testing/ktest/sample.conf                    |   5 +
 .../ftrace/test.d/ftrace/func_event_triggers.tc    |   2 +-
 tools/testing/selftests/net/fib_tests.sh           |   2 +
 232 files changed, 1671 insertions(+), 1666 deletions(-)


