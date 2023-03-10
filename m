Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6066B44E2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCJO3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbjCJO3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:29:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614CA1184F0;
        Fri, 10 Mar 2023 06:27:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA672B822BB;
        Fri, 10 Mar 2023 14:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9515BC433D2;
        Fri, 10 Mar 2023 14:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458430;
        bh=jQZhl2D1iod5Kz+PItGY8Ah68ZCeHZ5KnRjehY2jKSs=;
        h=From:To:Cc:Subject:Date:From;
        b=PajBdqIG0Z+VHAzoiKwzv+8XkH0gETlaeey/GL5iT9PXKM5A73Wk8J5AW/lviADQX
         LI3R4whMumMIQgsI7prDko/7ZRhlkZxv3fNVmE7I0wUMbeWoCtYteBQEQk4o4LSITY
         lMKD5I3btV8fgwCXQOB3B5e+6wnsFQdXE4BoYCqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 000/357] 5.4.235-rc1 review
Date:   Fri, 10 Mar 2023 14:34:49 +0100
Message-Id: <20230310133733.973883071@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.235-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.235-rc1
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

This is the start of the stable review cycle for the 5.4.235 release.
There are 357 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.235-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.235-rc1

Maxime Ripard <maxime@cerno.tech>
    dt-bindings: rtc: sun6i-a31-rtc: Loosen the requirements on the clocks

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: add missing discipline function

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix race condition with usb_kill_urb

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Provide sync and async uvc_ctrl_status_event

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix listen() regression in 5.4.229.

Nguyen Dinh Phi <phind.uet@gmail.com>
    Bluetooth: hci_sock: purge socket queues in the destruct() callback

Linus Torvalds <torvalds@linux-foundation.org>
    x86/resctl: fix scheduler confusion with 'current'

Valentin Schneider <valentin.schneider@arm.com>
    x86/resctrl: Apply READ_ONCE/WRITE_ONCE to task_struct.{rmid,closid}

Jakub Kicinski <kuba@kernel.org>
    net: tls: avoid hanging tasks on the tx_lock

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    phy: rockchip-typec: Fix unsigned comparison with less than zero

Mengyuan Lou <mengyuanlou@net-swift.com>
    PCI: Add ACS quirk for Wangxun NICs

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kernel/fail_function: fix memory leak with using debugfs_lookup()

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

Yuan Can <yuancan@huawei.com>
    staging: emxx_udc: Add checks for dma_alloc_coherent()

Kees Cook <keescook@chromium.org>
    media: uvcvideo: Silence memcpy() run-time false positive warnings

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Quirk for autosuspend in Logitech B910 and C910

Guenter Roeck <linux@roeck-us.net>
    media: uvcvideo: Handle errors from calls to usb_string

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Handle cameras with invalid descriptors

Liang He <windhl@126.com>
    mfd: arizona: Use pm_runtime_resume_and_get() to prevent refcnt leak

Darrell Kavanagh <darrell.kavanagh@gmail.com>
    firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3

Jia-Ju Bai <baijiaju1990@gmail.com>
    tracing: Add NULL checks for buffer in ring_buffer_free_read_page()

Randy Dunlap <rdunlap@infradead.org>
    thermal: intel: BXT_PMIC: select REGMAP instead of depending on it

Dan Carpenter <error27@gmail.com>
    thermal: intel: quark_dts: fix error pointer dereference

Arnd Bergmann <arnd@arndb.de>
    scsi: ipr: Work around fortify-string warning

Samuel Holland <samuel@sholland.org>
    rtc: sun6i: Always export the internal oscillator

Jernej Skrabec <jernej.skrabec@siol.net>
    rtc: sun6i: Make external 32k oscillator optional

George Kennedy <george.kennedy@oracle.com>
    vc_screen: modify vcs_size() handling in vcs_read()

Eric Dumazet <edumazet@google.com>
    tcp: tcp_check_req() can be called from process context

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: spear320-hmi: correct STMPE GPIO compatible

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_sample: fix action bind logic

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: fix memory leak of se_io context in nfc_genl_se_io

Maor Dickman <maord@nvidia.com>
    net/mlx5: Geneve, Fix handling of Geneve object id as error code

Zhengchao Shao <shaozhengchao@huawei.com>
    9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()

Juergen Gross <jgross@suse.com>
    9p/xen: fix connection sequence

Juergen Gross <jgross@suse.com>
    9p/xen: fix version parsing

Eric Dumazet <edumazet@google.com>
    net: fix __dev_kfree_skb_any() vs drop monitor

Xin Long <lucien.xin@gmail.com>
    sctp: add a refcnt in sctp_stream_priorities to avoid a nested loop

Lu Wei <luwei32@huawei.com>
    ipv6: Add lwtunnel encap size of all siblings in nexthop calculation

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
    ubifs: Fix memory leak in alloc_wbufs()

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

Li Hua <hucool.lihua@huawei.com>
    ubifs: Fix build errors as symbol undefined

George Kennedy <george.kennedy@oracle.com>
    ubi: ensure that VID header offset + VID header size <= alloc, size

Xiang Yang <xiangyang3@huawei.com>
    um: vector: Fix memory leak in vector_config

Alexander Potapenko <glider@google.com>
    fs: f2fs: initialize fsdata in pagecache_write()

Eric Biggers <ebiggers@google.com>
    f2fs: use memcpy_{to,from}_page() where possible

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    pwm: stm32-lp: fix the check on arr and cmp registers update

Emil Renner Berthing <emil.renner.berthing@canonical.com>
    pwm: sifive: Always let the first pwm_apply_state succeed

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Reduce time the controller lock is held

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

Mavroudis Chatzilaridis <mavchatz@protonmail.com>
    drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    PCI: Avoid FLR for AMD FCH AHCI adapters

Lukas Wunner <lukas@wunner.de>
    PCI: hotplug: Allow marking devices as disconnected during bind/unbind

Lukas Wunner <lukas@wunner.de>
    PCI/PM: Observe reset delay irrespective of bridge_d3

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

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix DMA-API call trace on NVMe LS requests

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix link failure in NPIV environment

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Add RUN_TIMEOUT option with default unlimited

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Fix missing "end_monitor" when machine check fails

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Give back console on Ctrt^C on monitor

Yin Fengwei <fengwei.yin@intel.com>
    mm/thp: check and bail out if page in deferred queue already

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: deprecate charge moving

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

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: powerclamp: Fix cur_state for multi package system

Alexander Wetzel <alexander@wetzel-home.de>
    wifi: cfg80211: Fix use after free for wext

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Use a longer retry limit of 48

Jun Nie <jun.nie@linaro.org>
    ext4: refuse to create ea block when umounted

Jun Nie <jun.nie@linaro.org>
    ext4: optimize ea_inode block expansion

Łukasz Stelmach <l.stelmach@samsung.com>
    ALSA: hda/realtek: Add quirk for HP EliteDesk 800 G6 Tower PC

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

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: disable migration mode when dirty tracking is disabled

Sean Christopherson <seanjc@google.com>
    KVM: Destroy target device if coalesced MMIO unregistration fails

Jan Kara <jack@suse.cz>
    udf: Fix file corruption when appending just after end of preallocated extent

Jan Kara <jack@suse.cz>
    udf: Detect system inodes linked into directory hierarchy

Jan Kara <jack@suse.cz>
    udf: Preserve link count of system files

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
    f2fs: fix cgroup writeback accounting with fs-layer encryption

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

Corey Minyard <cminyard@mvista.com>
    ipmi_ssif: Rename idle state and check

Johan Hovold <johan+linaro@kernel.org>
    rtc: pm8xxx: fix set-alarm race

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    firmware: coreboot: framebuffer: Ignore reserved pixel color bits

Jun ASAKA <JunASAKA@zzy040330.moe>
    wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

Jeff Layton <jlayton@kernel.org>
    nfsd: zero out pointers after putting nfsd_files on COPY setup error

Mike Snitzer <snitzer@kernel.org>
    dm cache: add cond_resched() to various workqueue loops

Mike Snitzer <snitzer@kernel.org>
    dm thin: add cond_resched() to various workqueue loops

Darrell Kavanagh <darrell.kavanagh@gmail.com>
    drm: panel-orientation-quirks: Add quirk for Lenovo IdeaPad Duet 3 10IGL5

Claudiu Beznea <claudiu.beznea@microchip.com>
    pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Robin Murphy <robin.murphy@arm.com>
    hwmon: (coretemp) Simplify platform device handling

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

Jingyuan Liang <jingyliang@chromium.org>
    HID: Add Mapping for System Microphone Mute

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: dsi: Fix excessive stack usage

Roman Li <roman.li@amd.com>
    drm/amd/display: Fix potential null-deref in dm_resume

Kees Cook <keescook@chromium.org>
    uaccess: Add minimum bounds check on kernel buffer size

Kees Cook <keescook@chromium.org>
    coda: Avoid partial allocation of sig_inputArgs

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer: Fix debug print

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Fix Lenovo Ideapad Z570 DMI match

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: dma: free rx_head in mt76_dma_rx_cleanup

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Check syscall_trace_enter() return code

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Add a check for oversized packets

Mark Rutland <mark.rutland@arm.com>
    ACPI: Don't build ACPICA with '-Os'

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: add missing checks for PF vsi type

Pietro Borrello <borrello@diag.uniroma1.it>
    inet: fix fast path in __inet_hash_connect()

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: mt7601u: fix an integer underflow

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

Li Nan <linan122@huawei.com>
    blk-iocost: fix divide by 0 error in calc_lcoefs()

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

Shang XiaoJing <shangxiaojing@huawei.com>
    media: ov5675: Fix memleak in ov5675_init_controls()

Nathan Chancellor <nathan@kernel.org>
    powerpc: Remove linker flag from KBUILD_AFLAGS

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: platform: ti: Add missing check for devm_regulator_get

Sibi Sankar <quic_sibis@quicinc.com>
    remoteproc: qcom_q6v5_mss: Use a carveout to authenticate modem headers

Randy Dunlap <rdunlap@infradead.org>
    MIPS: vpe-mt: drop physical_memsize

Randy Dunlap <rdunlap@infradead.org>
    MIPS: SMP-CPS: fix build error when HOTPLUG_CPU not set

Ganesh Goudar <ganeshgr@linux.ibm.com>
    powerpc/eeh: Set channel state after notifying the drivers

Daniel Axtens <dja@axtens.net>
    powerpc/eeh: Small refactor of eeh_handle_normal_event()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: ensure 4KB alignment for rtas_data_buf

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: make all exports GPL

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/lparcfg: add missing RTAS retry status handling

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/lpar: add missing RTAS retry status handling

Chen-Yu Tsai <wenst@chromium.org>
    clk: Honor CLK_OPS_PARENT_ENABLE in clk_core_is_enabled()

Frederic Barrat <fbarrat@linux.ibm.com>
    powerpc/powernv/ioda: Skip unallocated resources when mapping to PE

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gpucc-sdm845: fix clk_dis_wait being programmed for CX GDSC

Luca Ellero <l.ellero@asem.it>
    Input: ads7846 - don't check penirq immediately for 7845

Luca Ellero <l.ellero@asem.it>
    Input: ads7846 - don't report pressure for ads7845

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: cpg-mssr: Remove superfluous check in resume code

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    clk: renesas: cpg-mssr: Use enum clk_reg_layout instead of a boolean flag

Alexey Khoroshilov <khoroshilov@ispras.ru>
    clk: renesas: cpg-mssr: Fix use after free if cpg_mssr_common_init() failed

Samuel Holland <samuel@sholland.org>
    mtd: rawnand: sunxi: Fix the size of the last OOB region

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gcc-qcs404: fix names of the DSI clocks used as parents

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gcc-qcs404: disable gpll[04]_out_aux parents

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

Pietro Borrello <borrello@diag.uniroma1.it>
    hid: bigben_probe(): validate report count

Hans de Goede <hdegoede@redhat.com>
    HID: asus: Fix mute and touchpad-toggle keys on Medion Akoya E1239T

Hans de Goede <hdegoede@redhat.com>
    HID: asus: Add support for multi-touch touchpad on Medion Akoya E1239T

Hans de Goede <hdegoede@redhat.com>
    HID: asus: Add report_size to struct asus_touchpad_info

Hans de Goede <hdegoede@redhat.com>
    HID: asus: Only set EV_REP if we are adding a mapping

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: bigben: use spinlock to safely schedule workers

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: bigben_worker() remove unneeded check on report_field

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: bigben: use spinlock to protect concurrent accesses

Lucas Tanure <lucas.tanure@collabora.com>
    ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: dapm: declare missing structure prototypes

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: synquacer: Fix timeout handling in synquacer_spi_transfer_one()

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

Miles Chen <miles.chen@mediatek.com>
    drm/mediatek: Use NULL instead of 0 for NULL pointer

Wambui Karuga <wambui.karugax@gmail.com>
    drm/mediatek: remove cast to pointers passed to kfree

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Don't skip assigning syncpoints to channels

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/mdp5: Add check for kzalloc

Thomas Zimmermann <tzimmermann@suse.de>
    drm: Initialize struct drm_crtc_state.no_vblank from device settings

Boris Brezillon <boris.brezillon@collabora.com>
    drm/bridge: Introduce drm_bridge_get_next_bridge()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/bridge: Rename bridge helpers targeting a bridge chain

Boris Brezillon <boris.brezillon@collabora.com>
    drm/exynos: Don't reset bridge->next

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dpu: Add check for pstates

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dpu: Add check for cstate

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: use strscpy instead of strncpy

Daniel Mentz <danielmentz@google.com>
    drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Alexey V. Vissarionov <gremlin@altlinux.org>
    ALSA: hda/ca0132: minor fix for allocation size

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: initialize is_dsp_mode flag

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/hdmi: Add missing check for alloc_ordered_workqueue

Liang He <windhl@126.com>
    gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dpi: Fix format mapping for RGB565

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dpi: Add option for inverting pixel clock and output enable

Yuan Can <yuancan@huawei.com>
    drm/bridge: megachips: Fix error handling in i2c_register_driver()

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC

Geert Uytterhoeven <geert@linux-m68k.org>
    drm/fourcc: Add missing big-endian XRGB1555 and RGB565 formats

Roxana Nicolescu <roxana.nicolescu@canonical.com>
    selftest: fib_tests: Always cleanup before exit

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/net: Interpret UDP_GRO cmsg data as an int value

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts

Frank Jungclaus <frank.jungclaus@esd.eu>
    can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Yongqin Liu <yongqin.liu@linaro.org>
    thermal/drivers/hisi: Drop second sensor hi3660

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

Kees Cook <keescook@chromium.org>
    treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()

Kees Cook <keescook@chromium.org>
    usb: gadget: udc: Avoid tasklet passing a global

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

Qi Zheng <zhengqi.arch@bytedance.com>
    OPP: fix error checking in opp_migrate_dentry()

Pietro Borrello <borrello@diag.uniroma1.it>
    tap: tap_open(): correctly initialize socket uid

Pietro Borrello <borrello@diag.uniroma1.it>
    tun: tun_chr_open(): correctly initialize socket uid

Pietro Borrello <borrello@diag.uniroma1.it>
    net: add sock_init_data_uid()

Geliang Tang <geliangtang@gmail.com>
    mptcp: add sk_stop_timer_sync helper

Miaoqian Lin <linmq006@gmail.com>
    irqchip/ti-sci: Fix refcount leak in ti_sci_intr_irq_domain_probe

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

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: essiv - Handle EBUSY correctly

Chen Wandun <chenwandun@huawei.com>
    crypto: essiv - remove redundant null pointer check before kfree

Koba Ko <koba.taiwan@gmail.com>
    crypto: ccp - Failure on re-initialization due to duplicate sysfs filename

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

Eric Biggers <ebiggers@google.com>
    crypto: x86/ghash - fix unaligned access in ghash_setkey()

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

Zhang Changzhong <zhangchangzhong@huawei.com>
    wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    wilc1000: let wilc_mac_xmit() return NETDEV_TX_OK

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

Yang Yingliang <yangyingliang@huawei.com>
    wifi: iwlegacy: common: don't call dev_kfree_skb() under spin_lock_irqsave()

Markus Elfring <elfring@users.sourceforge.net>
    net/wireless: Delete unnecessary checks before the macro call “dev_kfree_skb”

Yuan Can <yuancan@huawei.com>
    wifi: rsi: Fix memory leak in rsi_coex_attach()

Martin K. Petersen <martin.petersen@oracle.com>
    block: bio-integrity: Copy flags when bio_integrity_payload is cloned

Pietro Borrello <borrello@diag.uniroma1.it>
    sched/rt: pick_next_rt_entity(): check list_entry

Dietmar Eggemann <dietmar.eggemann@arm.com>
    sched/deadline,rt: Remove unused parameter from pick_next_[rt|dl]_entity()

Qiheng Lin <linqiheng@huawei.com>
    s390/dasd: Fix potential memleak in dasd_eckd_init()

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Prepare for additional path event handling

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: correct stale comment of .get_budget

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: wait on correct sbitmap_queue in blk_mq_mark_tag_wait

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx

Salman Qazi <sqazi@google.com>
    block: Limit number of items taken from the I/O scheduler in one go

Douglas Anderson <dianders@chromium.org>
    Revert "scsi: core: run queue if SCSI device queue isn't ready and queue is idle"

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx7s: correct iomuxc gpr mux controller cells

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl-s905d-phicomm-n1: fix led node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: add missing unit address to rng node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: fix SCPI clock dvfs node name

Angus Chen <angus.chen@jaguarmicro.com>
    ARM: imx: Call ida_simple_remove() for ida_simple_get

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato

Yang Yingliang <yangyingliang@huawei.com>
    ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: remove CPU opps below 1GHz for G12A boards

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix Ethernet MAC address unit name

Qiheng Lin <linqiheng@huawei.com>
    ARM: zynq: Fix refcount leak in zynq_early_slcr_init

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qcs404: use symbol names for PCIe resets

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

 Documentation/admin-guide/cgroup-v1/memory.rst     |  13 +-
 Documentation/admin-guide/hw-vuln/spectre.rst      |  21 +-
 Documentation/dev-tools/gdb-kernel-debugging.rst   |   4 +
 .../bindings/rtc/allwinner,sun6i-a31-rtc.yaml      |   1 -
 Documentation/virt/kvm/api.txt                     |  18 +-
 Documentation/virt/kvm/devices/vm.txt              |   4 +
 Makefile                                           |  15 +-
 arch/alpha/kernel/traps.c                          |  30 +-
 arch/arm/boot/dts/exynos3250-rinato.dts            |   2 +-
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi         |   2 +-
 arch/arm/boot/dts/exynos4.dtsi                     |   2 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |   1 -
 arch/arm/boot/dts/exynos5420.dtsi                  |   2 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   2 +-
 arch/arm/boot/dts/spear320-hmi.dts                 |   2 +-
 arch/arm/mach-imx/mmdc.c                           |  24 +-
 arch/arm/mach-omap1/timer.c                        |   2 +-
 arch/arm/mach-omap2/timer.c                        |   1 +
 arch/arm/mach-zynq/slcr.c                          |   1 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi        |  20 -
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   6 +-
 .../dts/amlogic/meson-gxl-s905d-phicomm-n1.dts     |   2 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   2 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |   1 +
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |  12 +-
 arch/m68k/68000/entry.S                            |   2 +
 arch/m68k/Kconfig.devices                          |   1 +
 arch/m68k/coldfire/entry.S                         |   2 +
 arch/m68k/kernel/entry.S                           |   3 +
 arch/mips/include/asm/syscall.h                    |   2 +-
 arch/mips/include/asm/vpe.h                        |   1 -
 arch/mips/kernel/smp-cps.c                         |   8 +-
 arch/mips/kernel/vpe-mt.c                          |   7 +-
 arch/mips/lantiq/prom.c                            |   6 -
 arch/powerpc/Makefile                              |   2 +-
 arch/powerpc/kernel/eeh_driver.c                   |  71 +-
 arch/powerpc/kernel/rtas.c                         |  24 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   3 +-
 arch/powerpc/platforms/pseries/lpar.c              |  20 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |  20 +-
 arch/riscv/kernel/time.c                           |   3 +
 arch/s390/kernel/kprobes.c                         |   4 +-
 arch/s390/kernel/vmlinux.lds.S                     |   1 +
 arch/s390/kvm/kvm-s390.c                           |  16 +
 arch/sparc/Kconfig                                 |   2 +-
 arch/um/drivers/vector_kern.c                      |   1 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |   6 +-
 arch/x86/include/asm/microcode.h                   |   4 +-
 arch/x86/include/asm/microcode_amd.h               |   4 +-
 arch/x86/include/asm/msr-index.h                   |   4 +
 arch/x86/include/asm/reboot.h                      |   2 +
 arch/x86/include/asm/resctrl_sched.h               |  19 +-
 arch/x86/include/asm/virtext.h                     |  16 +-
 arch/x86/kernel/cpu/bugs.c                         |  35 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  53 +-
 arch/x86/kernel/cpu/microcode/core.c               |   6 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  14 +-
 arch/x86/kernel/crash.c                            |  17 +-
 arch/x86/kernel/kprobes/opt.c                      |   6 +-
 arch/x86/kernel/process_32.c                       |   2 +-
 arch/x86/kernel/process_64.c                       |   2 +-
 arch/x86/kernel/reboot.c                           |  88 ++-
 arch/x86/kernel/smp.c                              |   6 +-
 arch/x86/kernel/sysfb_efi.c                        |   8 +
 arch/x86/um/vdso/um_vdso.c                         |  12 +-
 block/bio-integrity.c                              |   1 +
 block/blk-iocost.c                                 |  11 +-
 block/blk-mq-sched.c                               |  71 +-
 block/blk-mq.c                                     |   6 +-
 crypto/essiv.c                                     |  10 +-
 crypto/rsa-pkcs1pad.c                              |  34 +-
 crypto/seqiv.c                                     |   2 +-
 drivers/acpi/acpica/Makefile                       |   2 +-
 drivers/acpi/acpica/hwvalid.c                      |   7 +-
 drivers/acpi/acpica/nsrepair.c                     |  12 +-
 drivers/acpi/battery.c                             |   2 +-
 drivers/acpi/video_detect.c                        |   2 +-
 drivers/block/rbd.c                                |  20 +-
 drivers/char/ipmi/ipmi_ssif.c                      |  46 +-
 drivers/clk/clk.c                                  |  11 +
 drivers/clk/qcom/gcc-qcs404.c                      |  24 +-
 drivers/clk/qcom/gpucc-sdm845.c                    |   7 +-
 drivers/clk/renesas/r7s9210-cpg-mssr.c             |   2 +-
 drivers/clk/renesas/renesas-cpg-mssr.c             |  29 +-
 drivers/clk/renesas/renesas-cpg-mssr.h             |  12 +-
 drivers/crypto/amcc/crypto4xx_core.c               |  10 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |  21 +-
 drivers/firmware/google/framebuffer-coreboot.c     |   4 +-
 drivers/gpio/gpio-vf610.c                          |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |   6 +-
 drivers/gpu/drm/drm_atomic_helper.c                |  29 +-
 drivers/gpu/drm/drm_bridge.c                       | 125 ++--
 drivers/gpu/drm/drm_encoder.c                      |   2 +-
 drivers/gpu/drm/drm_fourcc.c                       |   4 +
 drivers/gpu/drm/drm_mipi_dsi.c                     |  52 ++
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/drm_probe_helper.c                 |   2 +-
 drivers/gpu/drm/drm_vblank.c                       |  28 +
 drivers/gpu/drm/exynos/exynos_dp.c                 |   1 -
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |   8 +-
 drivers/gpu/drm/i915/display/intel_quirks.c        |   2 +
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   1 +
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   8 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |   8 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   7 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |   5 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   3 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   4 +
 drivers/gpu/drm/msm/msm_fence.c                    |   2 +-
 drivers/gpu/drm/mxsfb/Kconfig                      |   1 +
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |  26 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |   4 +-
 drivers/gpu/drm/omapdrm/omap_encoder.c             |   3 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   5 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   1 +
 drivers/gpu/drm/vc4/vc4_dpi.c                      |  66 +-
 drivers/gpu/drm/vc4/vc4_dsi.c                      |   8 +-
 drivers/gpu/host1x/hw/syncpt_hw.c                  |   3 -
 drivers/gpu/ipu-v3/ipu-common.c                    |   1 +
 drivers/hid/hid-asus.c                             | 136 +++-
 drivers/hid/hid-bigbenff.c                         |  75 ++-
 drivers/hid/hid-debug.c                            |   1 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-input.c                            |   8 +
 drivers/hwmon/coretemp.c                           | 128 ++--
 drivers/hwmon/ltc2945.c                            |   2 +
 drivers/hwmon/mlxreg-fan.c                         |   6 +
 drivers/iio/accel/mma9551_core.c                   |  10 +-
 drivers/input/keyboard/omap-keypad.c               |   2 +-
 drivers/input/serio/hil_mlc.c                      |   2 +-
 drivers/input/touchscreen/ads7846.c                |  13 +-
 drivers/irqchip/irq-alpine-msi.c                   |   1 +
 drivers/irqchip/irq-bcm7120-l2.c                   |   3 +-
 drivers/irqchip/irq-brcmstb-l2.c                   |   6 +-
 drivers/irqchip/irq-mvebu-gicp.c                   |   1 +
 drivers/irqchip/irq-ti-sci-intr.c                  |   1 +
 drivers/md/dm-cache-target.c                       |   4 +
 drivers/md/dm-flakey.c                             |  30 +-
 drivers/md/dm-thin.c                               |   2 +
 drivers/md/dm.c                                    |   1 -
 drivers/media/i2c/ov5675.c                         |   4 +-
 drivers/media/i2c/ov7670.c                         |   2 +-
 drivers/media/i2c/ov772x.c                         |   3 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   3 +
 drivers/media/platform/omap3isp/isp.c              |   9 +
 drivers/media/rc/ene_ir.c                          |   3 +-
 drivers/media/usb/siano/smsusb.c                   |   1 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |  30 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  66 +-
 drivers/media/usb/uvc/uvc_entity.c                 |   2 +-
 drivers/media/usb/uvc/uvc_status.c                 |  40 +-
 drivers/media/usb/uvc/uvc_video.c                  |  15 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   6 +-
 drivers/mfd/arizona-core.c                         |   2 +-
 drivers/mfd/pcf50633-adc.c                         |   7 +-
 drivers/misc/mei/bus-fixup.c                       |   8 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   2 +-
 drivers/mtd/ubi/build.c                            |   7 +
 drivers/mtd/ubi/vmt.c                              |  18 +-
 drivers/mtd/ubi/wl.c                               |  25 +-
 drivers/net/can/usb/esd_usb2.c                     |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   8 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  17 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/geneve.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   3 +-
 drivers/net/tap.c                                  |   2 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/wan/farsync.c                          |   4 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   4 +-
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
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |  24 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  12 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   8 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |   2 +
 drivers/net/wireless/marvell/libertas/cmdresp.c    |   2 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   2 +-
 drivers/net/wireless/marvell/libertas/main.c       |   3 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |   6 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  13 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |   5 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |   3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   5 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  11 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |  91 ++-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.h |   4 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c            |   1 +
 drivers/net/wireless/st/cw1200/scan.c              |   3 +-
 drivers/net/wireless/wl3501_cs.c                   |   2 +-
 drivers/nfc/st-nci/se.c                            |   6 +
 drivers/nfc/st21nfca/se.c                          |   6 +
 drivers/opp/debugfs.c                              |   2 +-
 drivers/pci/pci.c                                  |   2 +-
 drivers/pci/pci.h                                  |  43 +-
 drivers/pci/quirks.c                               |  23 +
 drivers/phy/rockchip/phy-rockchip-typec.c          |   3 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                |   4 +-
 drivers/pinctrl/pinctrl-at91.c                     |   2 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   1 +
 drivers/powercap/powercap_sys.c                    |  14 +-
 drivers/pwm/pwm-sifive.c                           |  16 +-
 drivers/pwm/pwm-stm32-lp.c                         |   2 +-
 drivers/regulator/max77802-regulator.c             |  34 +-
 drivers/regulator/s5m8767.c                        |   6 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |  59 +-
 drivers/rpmsg/qcom_glink_native.c                  |   1 +
 drivers/rtc/rtc-pm8xxx.c                           |  24 +-
 drivers/rtc/rtc-sun6i.c                            |  32 +-
 drivers/s390/block/dasd.c                          |   4 +-
 drivers/s390/block/dasd_diag.c                     |   8 +-
 drivers/s390/block/dasd_eckd.c                     |  82 ++-
 drivers/s390/block/dasd_fba.c                      |   8 +-
 drivers/s390/block/dasd_int.h                      |   2 +-
 drivers/s390/crypto/ap_bus.c                       |   2 +-
 drivers/scsi/aic94xx/aic94xx_task.c                |   3 +
 drivers/scsi/ipr.c                                 |  41 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  19 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   9 +-
 drivers/scsi/scsi_lib.c                            |   7 +-
 drivers/scsi/ses.c                                 |  64 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |  20 +-
 drivers/spi/spi-synquacer.c                        |   7 +-
 drivers/staging/emxx_udc/emxx_udc.c                |   7 +-
 drivers/staging/most/dim2/dim2.c                   |   2 +-
 drivers/staging/octeon/ethernet-tx.c               |   2 +-
 drivers/staging/wilc1000/wilc_netdev.c             |   7 +-
 drivers/thermal/hisi_thermal.c                     |   4 -
 drivers/thermal/intel/Kconfig                      |   3 +-
 drivers/thermal/intel/intel_powerclamp.c           |  20 +-
 drivers/thermal/intel/intel_quark_dts_thermal.c    |  12 +-
 drivers/thermal/intel/intel_soc_dts_iosf.c         |   2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  24 +-
 drivers/tty/tty_io.c                               |   8 +-
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/tty/vt/vc_screen.c                         |   4 +-
 drivers/usb/gadget/udc/snps_udc_core.c             |   6 +-
 drivers/usb/host/fhci-sched.c                      |   2 +-
 drivers/usb/host/xhci-mvebu.c                      |   2 +-
 drivers/usb/storage/ene_ub6250.c                   |   2 +-
 drivers/watchdog/at91sam9_wdt.c                    |   7 +-
 drivers/watchdog/pcwd_usb.c                        |   6 +-
 drivers/watchdog/watchdog_dev.c                    |   2 +-
 fs/cifs/smbdirect.c                                |   4 +-
 fs/coda/upcall.c                                   |   2 +-
 fs/ext4/xattr.c                                    |  35 +-
 fs/f2fs/data.c                                     |   6 +-
 fs/f2fs/inline.c                                   |  28 +-
 fs/f2fs/super.c                                    |  11 +-
 fs/f2fs/verity.c                                   |  12 +-
 fs/gfs2/aops.c                                     |   3 +-
 fs/hfs/bnode.c                                     |   1 +
 fs/hfsplus/super.c                                 |   4 +-
 fs/jfs/jfs_dmap.c                                  |   3 +-
 fs/nfsd/nfs4layouts.c                              |   4 +-
 fs/nfsd/nfs4proc.c                                 |   2 +
 fs/ocfs2/move_extents.c                            |  34 +-
 fs/ubifs/budget.c                                  |   9 +-
 fs/ubifs/dir.c                                     |   9 +-
 fs/ubifs/file.c                                    |  12 +-
 fs/ubifs/super.c                                   |  17 +-
 fs/ubifs/tnc.c                                     |  24 +-
 fs/ubifs/ubifs.h                                   |   5 +
 fs/udf/file.c                                      |  26 +-
 fs/udf/inode.c                                     |  74 +--
 fs/udf/super.c                                     |   1 +
 fs/udf/udf_i.h                                     |   3 +-
 fs/udf/udf_sb.h                                    |   2 +
 include/drm/drm_bridge.h                           |  77 ++-
 include/drm/drm_crtc.h                             |  34 +-
 include/drm/drm_mipi_dsi.h                         |   4 +
 include/drm/drm_simple_kms_helper.h                |   7 +-
 include/drm/drm_vblank.h                           |   1 +
 include/linux/ima.h                                |   6 +-
 include/linux/interrupt.h                          |  15 +-
 include/linux/kernel_stat.h                        |   2 +-
 include/linux/kprobes.h                            |   2 +
 include/linux/pci_ids.h                            |   2 +
 include/linux/uaccess.h                            |   4 +
 include/net/sctp/structs.h                         |   1 +
 include/net/sock.h                                 |   9 +-
 include/sound/soc-dapm.h                           |   3 +
 include/uapi/linux/usb/video.h                     |  30 +
 include/uapi/linux/uvcvideo.h                      |   2 +-
 kernel/backtracetest.c                             |   2 +-
 kernel/debug/debug_core.c                          |   2 +-
 kernel/fail_function.c                             |   5 +-
 kernel/irq/irqdomain.c                             |  31 +-
 kernel/irq/resend.c                                |   2 +-
 kernel/kprobes.c                                   |   6 +-
 kernel/rcu/tree_exp.h                              |   2 +
 kernel/sched/deadline.c                            |   5 +-
 kernel/sched/rt.c                                  |  10 +-
 kernel/time/hrtimer.c                              |   2 +
 kernel/time/posix-stubs.c                          |   2 +
 kernel/time/posix-timers.c                         |   2 +
 kernel/trace/ring_buffer.c                         |   7 +-
 lib/mpi/mpicoder.c                                 |   3 +-
 mm/huge_memory.c                                   |   3 +
 mm/memcontrol.c                                    |   4 +
 net/9p/trans_rdma.c                                |  15 +-
 net/9p/trans_xen.c                                 |  48 +-
 net/atm/pppoatm.c                                  |   2 +-
 net/bluetooth/hci_sock.c                           |  11 +-
 net/bluetooth/l2cap_core.c                         |  24 -
 net/bluetooth/l2cap_sock.c                         |   8 +
 net/core/dev.c                                     |   4 +-
 net/core/sock.c                                    |  22 +-
 net/ipv4/inet_connection_sock.c                    |   1 +
 net/ipv4/inet_hashtables.c                         |  12 +-
 net/ipv4/tcp_minisocks.c                           |   7 +-
 net/ipv6/route.c                                   |  11 +-
 net/iucv/iucv.c                                    |   2 +-
 net/mac80211/sta_info.c                            |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |   5 +-
 net/nfc/netlink.c                                  |   4 +
 net/rds/message.c                                  |   2 +-
 net/sched/Kconfig                                  |  11 -
 net/sched/Makefile                                 |   1 -
 net/sched/act_sample.c                             |  11 +-
 net/sched/cls_tcindex.c                            | 730 ---------------------
 net/sctp/stream_sched_prio.c                       |  52 +-
 net/tls/tls_sw.c                                   |  26 +-
 net/wireless/sme.c                                 |  31 +-
 security/integrity/ima/ima_main.c                  |   7 +-
 security/security.c                                |   7 +-
 sound/drivers/pcsp/pcsp_lib.c                      |   2 +-
 sound/pci/hda/patch_ca0132.c                       |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/ice1712/aureon.c                         |   2 +-
 sound/soc/fsl/fsl_sai.c                            |   1 +
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
 tools/testing/selftests/net/udpgso_bench_rx.c      |   6 +-
 virt/kvm/coalesced_mmio.c                          |   8 +-
 356 files changed, 2777 insertions(+), 2417 deletions(-)


