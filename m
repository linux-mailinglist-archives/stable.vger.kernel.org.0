Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874C36B46AD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjCJOpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbjCJOpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:45:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A25E10D300;
        Fri, 10 Mar 2023 06:45:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E303B6195B;
        Fri, 10 Mar 2023 14:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4D5C4339E;
        Fri, 10 Mar 2023 14:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459499;
        bh=LIgRfdl8+V0ixMh0hNaQXf2isN7RJL6gbZZ1vnWUCaE=;
        h=From:To:Cc:Subject:Date:From;
        b=iCL/Oln+Wv/nmCrG7yU151xrL15GMbNs1BShzNX1tTQ9NYX4pUATLqA7tzU3xQrfJ
         PMaPkyN5D+B/HKZa46gQHCw2q6/2r5PJRLt60bUUdvZYCavrsOYB2hrnwAw/LZYg0J
         N+PUsvdhPc03bJzHJZ6rSqVSsCIRWLa1Cm1FspNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 000/529] 5.10.173-rc1 review
Date:   Fri, 10 Mar 2023 14:32:23 +0100
Message-Id: <20230310133804.978589368@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.173-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.173-rc1
X-KernelTest-Deadline: 2023-03-12T13:38+00:00
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

This is the start of the stable review cycle for the 5.10.173 release.
There are 529 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.173-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.173-rc1

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: add missing discipline function

Yang Yingliang <yangyingliang@huawei.com>
    usb: gadget: uvc: fix missing mutex_unlock() if kstrtou8() fails

Miaoqian Lin <linmq006@gmail.com>
    malidp: Fix NULL vs IS_ERR() checking

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Remove usage of dma_get_required_mask() API

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: re-do lost mpt3sas DMA mask fix

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Don't change DMA mask while reallocating pools

Salvatore Bonaccorso <carnil@debian.org>
    Revert "scsi: mpt3sas: Fix return value check of dma_get_required_mask()"

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix race condition with usb_kill_urb

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Provide sync and async uvc_ctrl_status_event

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    drm/virtio: Fix error code in virtio_gpu_object_shmem_init()

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix listen() regression in 5.10.163

Nguyen Dinh Phi <phind.uet@gmail.com>
    Bluetooth: hci_sock: purge socket queues in the destruct() callback

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Fix down message handling after a packet reception error

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Fix down/up message handling after sink disconnect

Linus Torvalds <torvalds@linux-foundation.org>
    x86/resctl: fix scheduler confusion with 'current'

Valentin Schneider <valentin.schneider@arm.com>
    x86/resctrl: Apply READ_ONCE/WRITE_ONCE to task_struct.{rmid,closid}

Jakub Kicinski <kuba@kernel.org>
    net: tls: avoid hanging tasks on the tx_lock

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Drain the RX FIFO after an IO timeout

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Remove wasted space in response_buf

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    phy: rockchip-typec: Fix unsigned comparison with less than zero

Mengyuan Lou <mengyuanlou@net-swift.com>
    PCI: Add ACS quirk for Wangxun NICs

Huacai Chen <chenhuacai@loongson.cn>
    PCI: loongson: Add more devices that need MRRS quirk

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kernel/fail_function: fix memory leak with using debugfs_lookup()

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Take other bus devices into account when distributing resources

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Align extra resources for hotplug bridges properly

Daniel Scally <dan.scally@ideasonboard.com>
    usb: gadget: uvc: Make bSourceID read/write

Daniel Scally <dan.scally@ideasonboard.com>
    usb: uvc: Enumerate valid values for color matching

Kees Cook <keescook@chromium.org>
    USB: ene_usb6250: Allocate enough memory for full object

Kees Cook <keescook@chromium.org>
    usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math

Huacai Chen <chenhuacai@loongson.cn>
    PCI: loongson: Prevent LS7A MRRS increases

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()

Yulong Zhang <yulong.zhang@metoak.net>
    tools/iio/iio_utils:fix memory leak

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus-fixup:upon error print return values of send and receive

Isaac True <isaac.true@canonical.com>
    serial: sc16is7xx: setup GPIO controller later in probe

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

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Update RMT size calculation

Liang He <windhl@126.com>
    mfd: arizona: Use pm_runtime_resume_and_get() to prevent refcnt leak

Souradeep Chowdhury <quic_schowdhu@quicinc.com>
    bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support

Darrell Kavanagh <darrell.kavanagh@gmail.com>
    firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3

Jia-Ju Bai <baijiaju1990@gmail.com>
    tracing: Add NULL checks for buffer in ring_buffer_free_read_page()

Randy Dunlap <rdunlap@infradead.org>
    thermal: intel: BXT_PMIC: select REGMAP instead of depending on it

Dan Carpenter <error27@gmail.com>
    thermal: intel: quark_dts: fix error pointer dereference

Arnd Bergmann <arnd@arndb.de>
    ASoC: zl38060 add gpiolib dependency

Mark Brown <broonie@kernel.org>
    ASoC: zl38060: Remove spurious gpiolib select

Nuno Sá <nuno.sa@analog.com>
    ASoC: adau7118: don't disable regulators on device unbind

Zhong Jinghua <zhongjinghua@huawei.com>
    loop: loop_set_status_from_info() check before assignment

Arnd Bergmann <arnd@arndb.de>
    scsi: ipr: Work around fortify-string warning

Samuel Holland <samuel@sholland.org>
    rtc: sun6i: Always export the internal oscillator

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

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: fix table blob use-after-free

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
    ubi: fastmap: Fix missed fm_anchor PEB in wear-leveling after disabling fastmap

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

Miaoqian Lin <linmq006@gmail.com>
    objtool: Fix memory leak in create_static_call_sections()

Liu Shixin via Jfs-discussion <jfs-discussion@lists.sourceforge.net>
    fs/jfs: fix shift exponent db_agl2size negative

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Retire tcindex classifier

Dmitry Goncharov <dgoncharov@users.sf.net>
    kbuild: Port silent mode detection to future gnu make.

Jonas Karlman <jonas@kwiboo.se>
    pinctrl: rockchip: fix reading pull type on rk3568

Jonas Karlman <jonas@kwiboo.se>
    pinctrl: rockchip: fix mux route data for rk3568

Arnd Bergmann <arnd@arndb.de>
    wifi: ath9k: use proper statements in conditionals

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: fix Gen2 PCIe QMP PHY

Jani Nikula <jani.nikula@intel.com>
    drm/edid: fix AVI infoframe aspect ratio handling

Mark Hawrylak <mark.hawrylak@gmail.com>
    drm/radeon: Fix eDP for single-display iMac11,2

Mavroudis Chatzilaridis <mavchatz@protonmail.com>
    drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv

Steve Sistare <steven.sistare@oracle.com>
    vfio/type1: prevent underflow of locked_vm via exec()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    PCI: Avoid FLR for AMD FCH AHCI adapters

Lukas Wunner <lukas@wunner.de>
    PCI: hotplug: Allow marking devices as disconnected during bind/unbind

Lukas Wunner <lukas@wunner.de>
    PCI/PM: Observe reset delay irrespective of bridge_d3

Andy Chiu <andy.chiu@sifive.com>
    riscv: jump_label: Fixup unaligned arch_static_branch function

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

Mukesh Ojha <quic_mojha@quicinc.com>
    ring-buffer: Handle race between rb_move_tail and rb_check_pages

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

John Ogness <john.ogness@linutronix.de>
    docs: gdbmacros: print newest record

Chen-Yu Tsai <wenst@chromium.org>
    remoteproc/mtk_scp: Move clk ops outside send_lock

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu3-cio2: Fix PM runtime usage_count in driver unbind

Elvira Khabirova <lineprinter0@gmail.com>
    mips: fix syscall_get_nr

Dan Williams <dan.j.williams@intel.com>
    dax/kmem: Fix leak of memory-hotplug resources

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix FEN fault handling

Ilya Dryomov <idryomov@gmail.com>
    rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid HC1

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid XU

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos5250

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid XU3 family

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos4

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos4210

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

Pingfan Liu <piliu@redhat.com>
    dm: add cond_resched() to dm_wq_work()

Louis Rannou <lrannou@baylibre.com>
    mtd: spi-nor: Fix shift-out-of-bounds in spi_nor_set_erase_type

Jun Nie <jun.nie@linaro.org>
    ext4: refuse to create ea block when umounted

Jun Nie <jun.nie@linaro.org>
    ext4: optimize ea_inode block expansion

Zhihao Cheng <chengzhihao1@huawei.com>
    jbd2: fix data missing when reusing bh which is ready to be checkpointed

Łukasz Stelmach <l.stelmach@samsung.com>
    ALSA: hda/realtek: Add quirk for HP EliteDesk 800 G6 Tower PC

Dmitry Fomin <fomindmitriyfoma@mail.ru>
    ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: allow some retries for poll triggering spuriously

David Lamparter <equinox@diac24.net>
    io_uring: remove MSG_NOSIGNAL from recvmsg

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: disallow multi-source reg buffers

Jens Axboe <axboe@kernel.dk>
    io_uring: add a conditional reschedule to the IOPOLL cancelation loop

Jens Axboe <axboe@kernel.dk>
    io_uring: mark task TASK_RUNNING before handling resume/task work

Jens Axboe <axboe@kernel.dk>
    io_uring: handle TIF_NOTIFY_RESUME when checking for task_work

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Drop bogus fwspec-mapping error handling

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix disassociation race

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix association race

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Align ima_file_mmap() parameters with mmap_file LSM hook

Jens Axboe <axboe@kernel.dk>
    brd: return 0/-error from brd_insert_page()

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
    KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI

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

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix inode->i_blocks for non-512 byte sector size device

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: redefine DIR_DELETED as the bad cluster number

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix unexpected EOF while reading dir

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix reporting fs error when reading dir beyond EOF

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: hfsplus: fix UAF issue in hfsplus_put_super

Liu Shixin <liushixin2@huawei.com>
    hfs: fix missing hfs_bnode_get() in __hfs_bnode_create

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct HDMI phy compatible in Exynos4

Volker Lendecke <vl@samba.org>
    cifs: Fix uninitialized memory read in smb3_qfs_tcon()

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix current_kprobe never cleared after kprobes reenter

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler

Ilya Leoshkevich <iii@linux.ibm.com>
    s390: discard .interp section

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/extmem: return correct segment type in __segment_load()

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

Bastien Nocera <hadess@hadess.net>
    HID: logitech-hidpp: Don't restart communication if not necessary

Claudiu Beznea <claudiu.beznea@microchip.com>
    pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Robin Murphy <robin.murphy@arm.com>
    hwmon: (coretemp) Simplify platform device handling

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Improve gfs2_make_fs_rw error handling

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

Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
    drm: amd: display: Fix memory leakage

Liwei Song <liwei.song@windriver.com>
    drm/radeon: free iio for atombios when driver shutdown

Carlo Caione <ccaione@baylibre.com>
    drm/tiny: ili9486: Do not assume 8-bit only SPI controllers

Jingyuan Liang <jingyliang@chromium.org>
    HID: Add Mapping for System Microphone Mute

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: dsi: Fix excessive stack usage

Roman Li <roman.li@amd.com>
    drm/amd/display: Fix potential null-deref in dm_resume

Moises Cardona <moisesmcardona@gmail.com>
    Bluetooth: btusb: Add VID:PID 13d3:3529 for Realtek RTL8821CE

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    PM: EM: fix memory leak with using debugfs_lookup()

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

Kees Cook <keescook@chromium.org>
    crypto: hisilicon: Wipe entire pool on error

Feng Tang <feng.tang@intel.com>
    clocksource: Suspend the watchdog temporarily when high read latency detected

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

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath11k: debugfs: fix to work with multiple PCI devices

Zqiang <qiang1.zhang@intel.com>
    rcu-tasks: Make rude RCU-Tasks work well with CPU hotplug

Paul E. McKenney <paulmck@kernel.org>
    rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()

Paul E. McKenney <paulmck@kernel.org>
    rcu: Make RCU_LOCKDEP_WARN() avoid early lockdep checks

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect()

Li Nan <linan122@huawei.com>
    blk-iocost: fix divide by 0 error in calc_lcoefs()

Markuss Broks <markuss.broks@gmail.com>
    ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy

Jan Kara <jack@suse.cz>
    udf: Define EFSCORRUPTED error code

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Avoid infinite loop on intent for missing channel

Tasos Sahanidis <tasos@tasossah.com>
    media: saa7134: Use video_unregister_device for radio_dev

Duoming Zhou <duoming@zju.edu.cn>
    media: usb: siano: Fix use after free bugs caused by do_submit_urb

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: i2c: ov7670: 0 instead of -EINVAL was returned

Duoming Zhou <duoming@zju.edu.cn>
    media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()

Jai Luthra <j-luthra@ti.com>
    media: i2c: imx219: Fix binning for RAW8 capture

Adam Ford <aford173@gmail.com>
    media: i2c: imx219: Split common registers from mode tables

Sameer Puri <purisame@spuri.io>
    media: i2c: imx219: remove redundant writes

Yuan Can <yuancan@huawei.com>
    media: i2c: ov772x: Fix memleak in ov772x_probe()

Shang XiaoJing <shangxiaojing@huawei.com>
    media: ov5675: Fix memleak in ov5675_init_controls()

Shang XiaoJing <shangxiaojing@huawei.com>
    media: ov2740: Fix memleak in ov2740_init_controls()

Shang XiaoJing <shangxiaojing@huawei.com>
    media: max9286: Fix memleak in max9286_v4l2_register()

Bastian Germann <bage@linutronix.de>
    builddeb: clean generated package content

Nathan Chancellor <nathan@kernel.org>
    powerpc: Remove linker flag from KBUILD_AFLAGS

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: platform: ti: Add missing check for devm_regulator_get

Gaosheng Cui <cuigaosheng1@huawei.com>
    media: ti: cal: fix possible memory leak in cal_ctx_create()

Sibi Sankar <quic_sibis@quicinc.com>
    remoteproc: qcom_q6v5_mss: Use a carveout to authenticate modem headers

Jeff LaBundy <jeff@labundy.com>
    Input: iqs269a - do not poll during ATI

Jeff LaBundy <jeff@labundy.com>
    Input: iqs269a - do not poll during suspend or resume

Al Viro <viro@zeniv.linux.org.uk>
    alpha/boot/tools/objstrip: fix the check for ELF header

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Don't clear mr struct on destroy MR

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

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/perf/hv-24x7: add missing RTAS retry status handling

Chen-Yu Tsai <wenst@chromium.org>
    clk: Honor CLK_OPS_PARENT_ENABLE in clk_core_is_enabled()

Frederic Barrat <fbarrat@linux.ibm.com>
    powerpc/powernv/ioda: Skip unallocated resources when mapping to PE

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gpucc-sdm845: fix clk_dis_wait being programmed for CX GDSC

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gpucc-sc7180: fix clk_dis_wait being programmed for CX GDSC

Luca Ellero <l.ellero@asem.it>
    Input: ads7846 - don't check penirq immediately for 7845

Luca Ellero <l.ellero@asem.it>
    Input: ads7846 - always set last command to PWRDOWN

Oleksij Rempel <linux@rempel-privat.de>
    Input: ads7846 - convert to one message

Oleksij Rempel <linux@rempel-privat.de>
    Input: ads7846 - convert to full duplex

Luca Ellero <l.ellero@asem.it>
    Input: ads7846 - don't report pressure for ads7845

Peng Fan <peng.fan@nxp.com>
    clk: imx: avoid memory leak

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: cpg-mssr: Remove superfluous check in resume code

Alexey Khoroshilov <khoroshilov@ispras.ru>
    clk: renesas: cpg-mssr: Fix use after free if cpg_mssr_common_init() failed

Masahiro Yamada <masahiroy@kernel.org>
    linux/kconfig.h: replace IF_ENABLED() with PTR_IF() in <linux/kernel.h>

Jeff LaBundy <jeff@labundy.com>
    Input: iqs269a - configure device with a single block write

Jeff LaBundy <jeff@labundy.com>
    Input: iqs269a - increase interrupt handler return delay

Jeff LaBundy <jeff@labundy.com>
    Input: iqs269a - drop unused device node references

Samuel Holland <samuel@sholland.org>
    mtd: rawnand: sunxi: Fix the size of the last OOB region

Heiko Stuebner <heiko.stuebner@vrull.eu>
    RISC-V: fix funct4 definition for c.jalr in parse_asm.h

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gcc-qcs404: fix names of the DSI clocks used as parents

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gcc-qcs404: disable gpll[04]_out_aux parents

Qiheng Lin <linqiheng@huawei.com>
    mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()

Arnd Bergmann <arnd@arndb.de>
    objtool: add UACCESS exceptions for __tsan_volatile_read/write

Arnd Bergmann <arnd@arndb.de>
    printf: fix errname.c list

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix bash specific "==" operator

Randy Dunlap <rdunlap@infradead.org>
    sparc: allow PM configs for sparc32 COMPILE_TEST

Yicong Yang <yangyicong@hisilicon.com>
    perf tools: Fix auto-complete on aarch64

Miaoqian Lin <linmq006@gmail.com>
    leds: led-core: Fix refcount leak in of_led_get()

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

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: bigben: use spinlock to safely schedule workers

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: bigben_worker() remove unneeded check on report_field

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: bigben: use spinlock to protect concurrent accesses

Lucas Tanure <lucas.tanure@collabora.com>
    ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: synquacer: Fix timeout handling in synquacer_spi_transfer_one()

NeilBrown <neilb@suse.de>
    NFS: fix disabling of swap

Benjamin Coddington <bcodding@redhat.com>
    nfs4trace: fix state manager flag printing

NeilBrown <neilb@suse.de>
    NFSv4: keep state manager thread active if swap is enabled

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up handling of outstanding layoutcommit in nfs_update_inode()

Mike Snitzer <snitzer@kernel.org>
    dm: remove flush_scheduled_work() during local_exit()

Steffen Aschbacher <steffen.aschbacher@stihl.de>
    ASoC: tlv320adcx140: fix 'ti,gpio-config' DT property init

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (mlxreg-fan) Return zero speed for broken fan

William Zhang <william.zhang@broadcom.com>
    spi: bcm63xx-hsspi: Fix multi-bit mode setting

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-hsspi: fix pm_runtime

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    scsi: aic94xx: Add missing check for dma_map_single()

Tomas Henzl <thenzl@redhat.com>
    scsi: mpt3sas: Fix a memory leak

Arnd Bergmann <arnd@arndb.de>
    drm/amdgpu: fix enum odm_combine_mode mismatch

Jonathan Cormier <jcormier@criticallink.com>
    hwmon: (ltc2945) Handle error case in ltc2945_value_store

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: dt-bindings: meson: fix gx-card codec node regex

Nathan Chancellor <nathan@kernel.org>
    ASoC: mchp-spdifrx: Fix uninitialized use of mr in mchp_spdifrx_hw_params()

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: disable all interrupts in mchp_spdifrx_dai_remove()

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: fix controls that works with completion mechanism

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: fix return value in case completion times out

Gu Shengxian <gushengxian@yulong.com>
    ASoC: atmel: fix spelling mistakes

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: fix controls which rely on rsr register

Arnd Bergmann <arnd@arndb.de>
    spi: dw_bt1: fix MUX_MMIO dependencies

Haibo Chen <haibo.chen@nxp.com>
    gpio: vf610: connect GPIO label to dev name

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/mediatek: Clean dangling pointer on bind error path

ruanjinjie <ruanjinjie@huawei.com>
    drm/mediatek: mtk_drm_crtc: Add checks for devm_kcalloc

Rob Clark <robdclark@chromium.org>
    drm/mediatek: Drop unbalanced obj unref

Miles Chen <miles.chen@mediatek.com>
    drm/mediatek: Use NULL instead of 0 for NULL pointer

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: dsi: Reduce the time of dsi from LP11 to sending cmd

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Don't skip assigning syncpoints to channels

Guodong Liu <Guodong.Liu@mediatek.com>
    pinctrl: mediatek: Initialize variable *buf to zero

Guodong Liu <Guodong.Liu@mediatek.com>
    pinctrl: mediatek: Initialize variable pullen and pullup to zero

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: bcm2835: Remove of_node_put() in bcm2835_of_gpio_ranges_fallback()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/mdp5: Add check for kzalloc

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dpu: Add check for pstates

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dpu: Add check for cstate

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: use strscpy instead of strncpy

Daniel Mentz <danielmentz@google.com>
    drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: pass a pointer to the of node

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix clock calculation

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix programming of video modes

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix polarity programming

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix HPD reenablement

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix sleep mode setup

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Disallow unallocated resources to be returned

Alexey V. Vissarionov <gremlin@altlinux.org>
    ALSA: hda/ca0132: minor fix for allocation size

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/adreno: Fix null ptr access in adreno_gpu_cleanup()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: initialize is_dsp_mode flag

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Correct interlaced timings again

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Fix colour order for xRGB1555 on HVS5

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Set AXI panic modes

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups

Jianqun Xu <jay.xu@rock-chips.com>
    pinctrl: rockchip: do coding style for mux route struct

Jianqun Xu <jay.xu@rock-chips.com>
    pinctrl: rockchip: add support for rk3568

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain

Adam Skladowski <a39.skl@gmail.com>
    pinctrl: qcom: pinctrl-msm8976: Correct function names for wcss pins

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/hdmi: Add missing check for alloc_ordered_workqueue

Liang He <windhl@126.com>
    gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()

Randolph Sapp <rs@ti.com>
    drm: tidss: Fix pixel format definition

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dpi: Fix format mapping for RGB565

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dpi: Add option for inverting pixel clock and output enable

Yuan Can <yuancan@huawei.com>
    drm/vkms: Fix null-ptr-deref in vkms_release()

Yuan Can <yuancan@huawei.com>
    drm/bridge: megachips: Fix error handling in i2c_register_driver()

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC

Geert Uytterhoeven <geert@linux-m68k.org>
    drm/fourcc: Add missing big-endian XRGB1555 and RGB565 formats

Shang XiaoJing <shangxiaojing@huawei.com>
    drm: Fix potential null-ptr-deref due to drmm_mode_config_init()

Jiri Pirko <jiri@nvidia.com>
    sefltests: netdevsim: wait for devlink instance after netns removal

Roxana Nicolescu <roxana.nicolescu@canonical.com>
    selftest: fib_tests: Always cleanup before exit

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: fix MoCA LED control

Shigeru Yoshida <syoshida@redhat.com>
    l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/net: Interpret UDP_GRO cmsg data as an int value

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts

Andrii Nakryiko <andrii@kernel.org>
    bpf: Fix global subprog context argument resolution logic

Frank Jungclaus <frank.jungclaus@esd.eu>
    can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Yongqin Liu <yongqin.liu@linaro.org>
    thermal/drivers/hisi: Drop second sensor hi3660

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: crypto4xx - Call dma_unmap_page when done

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Fix out-of-srctree build

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

Qi Zheng <zhengqi.arch@bytedance.com>
    OPP: fix error checking in opp_migrate_dentry()

Pietro Borrello <borrello@diag.uniroma1.it>
    tap: tap_open(): correctly initialize socket uid

Pietro Borrello <borrello@diag.uniroma1.it>
    tun: tun_chr_open(): correctly initialize socket uid

Pietro Borrello <borrello@diag.uniroma1.it>
    net: add sock_init_data_uid()

Vasily Gorbik <gor@linux.ibm.com>
    s390/vmem: fix empty page tables cleanup under KASAN

Miaoqian Lin <linmq006@gmail.com>
    irqchip/ti-sci: Fix refcount leak in ti_sci_intr_irq_domain_probe

Miaoqian Lin <linmq006@gmail.com>
    irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe

Miaoqian Lin <linmq006@gmail.com>
    irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains

Miaoqian Lin <linmq006@gmail.com>
    irqchip: Fix refcount leak in platform_irqchip_probe

Jack Morgenstein <jackm@nvidia.com>
    net/mlx5: Enhance debug print in page allocation failure

Tonghao Zhang <tong@infragraf.org>
    bpftool: profile online CPUs instead of possible

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - Flush the SEV-ES TMR memory before giving it to firmware

Peter Gonda <pgonda@google.com>
    crypto: ccp - Refactor out sev_fw_alloc()

Hans de Goede <hdegoede@redhat.com>
    leds: led-class: Add missing put_device() to led_put()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: xts - Handle EBUSY correctly

Wang Qing <wangqing@vivo.com>
    net: ethernet: ti: add missing of_node_put before return

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: am65-cpsw: handle deferred probe with dev_err_probe()

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: am65-cpsw: fix tx csum offload for multi mac mode

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Adjust late loading result reporting message

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Check CPU capabilities after late microcode update correctly

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Add a parameter to microcode_check() to store CPU capabilities

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Print previous version of microcode after reload

Borislav Petkov <bp@suse.de>
    x86/microcode: Default-disable late loading

Borislav Petkov <bp@suse.de>
    x86/microcode: Rip out the OLD_INTERFACE

Peter Zijlstra <peterz@infradead.org>
    x86: Mark stop_this_cpu() __noreturn

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    x86/microcode: Replace deprecated CPU-hotplug functions.

Borislav Petkov <bp@suse.de>
    x86/cpu: Init AP exception handling from cpu_init_secondary()

Yang Yingliang <yangyingliang@huawei.com>
    powercap: fix possible name leak in powercap_register_zone()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: seqiv - Handle EBUSY correctly

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: essiv - Handle EBUSY correctly

Koba Ko <koba.taiwan@gmail.com>
    crypto: ccp - Failure on re-initialization due to duplicate sysfs filename

Armin Wolf <W_Armin@gmx.de>
    ACPI: battery: Fix missing NUL-termination with large strings

Shivani Baranwal <quic_shivbara@quicinc.com>
    wifi: cfg80211: Fix extended KCK key length check in nl80211_set_rekey_data()

Miaoqian Lin <linmq006@gmail.com>
    wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup

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

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix memory leaks with RTL8723BU, RTL8192EU

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: Sort out msm8976 vs msm8956 data

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: Add compat string for the qcom,msm8960

Konrad Dybcio <konrad.dybcio@somainline.org>
    thermal/drivers/qcom/tsens_v1: Enable sensor 3 on MSM8976

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: Drop msm8976-specific defines

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: nsrepair: handle cases without a return value correctly

David Rientjes <rientjes@google.com>
    crypto: ccp - Avoid page allocation failure warning for SEV_GET_ID2

John Allen <john.allen@amd.com>
    crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel memory leak

Sean Christopherson <seanjc@google.com>
    crypto: ccp: Use the stack and common buffer for status commands

Sean Christopherson <seanjc@google.com>
    crypto: ccp: Use the stack for small SEV command buffers

Herbert Xu <herbert@gondor.apana.org.au>
    lib/mpi: Fix buffer overrun when SG is too long

Frederic Weisbecker <frederic@kernel.org>
    rcu-tasks: Fix synchronize_rcu_tasks() VS zap_pid_ns_processes()

Frederic Weisbecker <frederic@kernel.org>
    rcu-tasks: Remove preemption disablement around srcu_read_[un]lock() calls

Frederic Weisbecker <frederic@kernel.org>
    rcu-tasks: Improve comments explaining tasks_rcu_exit_srcu purpose

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

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: ipw2200: fix memory leak in ipw_wdev_init()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix btf__align_of() by taking into account field offsets

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

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtlwifi: rtl8723be: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtlwifi: rtl8188ee: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtlwifi: rtl8821ae: don't call kfree_skb() under spin_lock_irqsave()

Yuan Can <yuancan@huawei.com>
    wifi: rsi: Fix memory leak in rsi_coex_attach()

Martin K. Petersen <martin.petersen@oracle.com>
    block: bio-integrity: Copy flags when bio_integrity_payload is cloned

silviazhao <silviazhao-oc@zhaoxin.com>
    x86/perf/zhaoxin: Add stepping check for ZXC

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
    blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: avoid sleep in blk_mq_alloc_request_hctx

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx7s: correct iomuxc gpr mux controller cells

Samuel Holland <samuel@sholland.org>
    ARM: dts: sun8i: nanopi-duo2: Fix regulator GPIO reference

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: beacon-renesom: Fix gpio expander reference

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxbb-kii-pro: fix led node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl-s905d-phicomm-n1: fix led node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx-libretech-pc: fix update button name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: add missing unit address to rng node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl-s905d-sml5442tw: drop invalid clock-names property

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

Vaishnav Achath <vaishnav.a@ti.com>
    arm64: dts: ti: k3-j7200: Fix wakeup pinmux range

Arnd Bergmann <arnd@arndb.de>
    ARM: s3c: fix s3c64xx_set_timer_source prototype

Yang Yingliang <yangyingliang@huawei.com>
    ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: remove CPU opps below 1GHz for G12A boards

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: correct PCIe QMP PHY output clock names

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: fix Gen3 PCIe node

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: correct Gen2 PCIe ranges

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: fix Gen3 PCIe QMP PHY

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: ipq8074: fix PCIe PHY serdes size

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: Fix IPQ8074 PCIe PHY nodes

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: correct USB3 QMP PHY-s clock output names

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix Ethernet MAC address unit name

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7180: correct SPMI bus address cells

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-db845c: fix audio codec interrupt pin name

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183: Fix systimer 13 MHz clock description

Qiheng Lin <linqiheng@huawei.com>
    ARM: zynq: Fix refcount leak in zynq_early_slcr_init

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qcs404: use symbol names for PCIe resets

Chen Hui <judy.chenhui@huawei.com>
    ARM: OMAP2+: Fix memory leak in realtime_counter_init()

Anders Roxell <anders.roxell@linaro.org>
    powerpc/mm: Rearrange if-else block to avoid clang warning

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: asus: use spinlock to safely schedule workers

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: asus: use spinlock to protect concurrent accesses

Luke D. Jones <luke@ljones.dev>
    HID: asus: Remove check for same LED brightness on set


-------------

Diffstat:

 Documentation/ABI/testing/configfs-usb-gadget-uvc  |   2 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |  13 +-
 Documentation/admin-guide/hw-vuln/spectre.rst      |  21 +-
 Documentation/admin-guide/kdump/gdbmacros.txt      |   2 +-
 Documentation/dev-tools/gdb-kernel-debugging.rst   |   4 +
 .../bindings/sound/amlogic,gx-sound-card.yaml      |   2 +-
 Documentation/virt/kvm/api.rst                     |  18 +-
 Documentation/virt/kvm/devices/vm.rst              |   4 +
 Makefile                                           |  15 +-
 arch/alpha/boot/tools/objstrip.c                   |   2 +-
 arch/alpha/kernel/traps.c                          |  30 +-
 arch/arm/boot/dts/exynos3250-rinato.dts            |   2 +-
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi         |   2 +-
 arch/arm/boot/dts/exynos4.dtsi                     |   2 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |   1 -
 arch/arm/boot/dts/exynos5250.dtsi                  |   2 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |   1 -
 arch/arm/boot/dts/exynos5420.dtsi                  |   2 +-
 arch/arm/boot/dts/exynos5422-odroidhc1.dts         |  10 +-
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |  10 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   2 +-
 arch/arm/boot/dts/spear320-hmi.dts                 |   2 +-
 arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts         |   2 +-
 arch/arm/mach-imx/mmdc.c                           |  24 +-
 arch/arm/mach-omap1/timer.c                        |   2 +-
 arch/arm/mach-omap2/timer.c                        |   1 +
 arch/arm/mach-s3c/s3c64xx.c                        |   3 +-
 arch/arm/mach-zynq/slcr.c                          |   1 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi        |  20 -
 .../boot/dts/amlogic/meson-gx-libretech-pc.dtsi    |   2 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   6 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts |   2 +-
 .../dts/amlogic/meson-gxl-s905d-phicomm-n1.dts     |   2 +-
 .../boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts |   1 -
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   2 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |   1 +
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |  12 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |  93 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |  12 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   2 +-
 .../boot/dts/renesas/beacon-renesom-baseboard.dtsi |  24 +-
 .../boot/dts/ti/k3-j7200-common-proc-board.dts     |   2 +-
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi    |  29 +-
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
 arch/powerpc/mm/book3s64/radix_tlb.c               |  11 +-
 arch/powerpc/perf/hv-24x7.c                        |  42 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   3 +-
 arch/powerpc/platforms/pseries/lpar.c              |  20 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |  20 +-
 arch/riscv/include/asm/jump_label.h                |   2 +
 arch/riscv/include/asm/parse_asm.h                 |   2 +-
 arch/riscv/kernel/time.c                           |   3 +
 arch/s390/kernel/kprobes.c                         |   4 +-
 arch/s390/kernel/vmlinux.lds.S                     |   1 +
 arch/s390/kvm/kvm-s390.c                           |  17 +
 arch/s390/mm/extmem.c                              |  12 +-
 arch/s390/mm/vmem.c                                |   6 +-
 arch/sparc/Kconfig                                 |   2 +-
 arch/um/drivers/vector_kern.c                      |   1 +
 arch/x86/Kconfig                                   |  15 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |   6 +-
 arch/x86/events/zhaoxin/core.c                     |   8 +-
 arch/x86/include/asm/microcode.h                   |   4 +-
 arch/x86/include/asm/microcode_amd.h               |   4 +-
 arch/x86/include/asm/msr-index.h                   |   4 +
 arch/x86/include/asm/processor.h                   |   6 +-
 arch/x86/include/asm/reboot.h                      |   2 +
 arch/x86/include/asm/resctrl.h                     |  19 +-
 arch/x86/include/asm/virtext.h                     |  16 +-
 arch/x86/kernel/cpu/bugs.c                         |  35 +-
 arch/x86/kernel/cpu/common.c                       |  75 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  53 +-
 arch/x86/kernel/cpu/microcode/core.c               | 148 +---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  14 +-
 arch/x86/kernel/crash.c                            |  17 +-
 arch/x86/kernel/kprobes/opt.c                      |   6 +-
 arch/x86/kernel/process.c                          |   2 +-
 arch/x86/kernel/process_32.c                       |   2 +-
 arch/x86/kernel/process_64.c                       |   2 +-
 arch/x86/kernel/reboot.c                           |  88 +-
 arch/x86/kernel/smp.c                              |   6 +-
 arch/x86/kernel/smpboot.c                          |   3 +-
 arch/x86/kernel/sysfb_efi.c                        |   8 +
 arch/x86/kernel/traps.c                            |   4 +-
 arch/x86/kvm/lapic.c                               |  10 +-
 arch/x86/um/vdso/um_vdso.c                         |  12 +-
 block/bio-integrity.c                              |   1 +
 block/blk-iocost.c                                 |  11 +-
 block/blk-mq-sched.c                               |   7 +-
 block/blk-mq.c                                     |   3 +-
 crypto/essiv.c                                     |   7 +-
 crypto/rsa-pkcs1pad.c                              |  34 +-
 crypto/seqiv.c                                     |   2 +-
 crypto/xts.c                                       |   8 +-
 drivers/acpi/acpica/Makefile                       |   2 +-
 drivers/acpi/acpica/hwvalid.c                      |   7 +-
 drivers/acpi/acpica/nsrepair.c                     |  12 +-
 drivers/acpi/battery.c                             |   2 +-
 drivers/acpi/video_detect.c                        |   2 +-
 drivers/block/brd.c                                |  26 +-
 drivers/block/loop.c                               |   8 +-
 drivers/block/rbd.c                                |  20 +-
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/char/ipmi/ipmi_ssif.c                      |  46 +-
 drivers/clk/clk.c                                  |  11 +
 drivers/clk/imx/clk.c                              |   3 +-
 drivers/clk/qcom/gcc-qcs404.c                      |  24 +-
 drivers/clk/qcom/gpucc-sc7180.c                    |   7 +-
 drivers/clk/qcom/gpucc-sdm845.c                    |   7 +-
 drivers/clk/renesas/renesas-cpg-mssr.c             |   8 +-
 drivers/crypto/amcc/crypto4xx_core.c               |  10 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |  21 +-
 drivers/crypto/ccp/sev-dev.c                       | 185 ++--
 drivers/crypto/ccp/sev-dev.h                       |   1 -
 drivers/crypto/hisilicon/sgl.c                     |   3 +-
 drivers/dax/bus.c                                  |   2 +-
 drivers/dax/kmem.c                                 |   4 +-
 drivers/firmware/google/framebuffer-coreboot.c     |   4 +-
 drivers/gpio/gpio-vf610.c                          |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   1 +
 .../amd/display/dc/dml/dcn20/display_mode_vba_20.c |   8 +-
 .../display/dc/dml/dcn20/display_mode_vba_20v2.c   |  10 +-
 .../amd/display/dc/dml/dcn21/display_mode_vba_21.c |  12 +-
 drivers/gpu/drm/arm/malidp_planes.c                |   2 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |  65 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |   6 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   5 +-
 drivers/gpu/drm/drm_edid.c                         |  21 +-
 drivers/gpu/drm/drm_fourcc.c                       |   4 +
 drivers/gpu/drm/drm_mipi_dsi.c                     |  52 ++
 drivers/gpu/drm/drm_mode_config.c                  |   8 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/i915/display/intel_quirks.c        |   2 +
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |   2 +
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   1 +
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   4 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   2 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   4 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   7 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c             |   5 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |   5 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   3 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   4 +
 drivers/gpu/drm/msm/msm_fence.c                    |   2 +-
 drivers/gpu/drm/mxsfb/Kconfig                      |   1 +
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |  26 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   5 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   1 +
 drivers/gpu/drm/tidss/tidss_dispc.c                |   4 +-
 drivers/gpu/drm/tiny/ili9486.c                     |  13 +-
 drivers/gpu/drm/vc4/vc4_dpi.c                      |  66 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   5 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |  11 +
 drivers/gpu/drm/vc4/vc4_plane.c                    |   2 +
 drivers/gpu/drm/vc4/vc4_regs.h                     |   6 +
 drivers/gpu/drm/virtio/virtgpu_object.c            |   3 +-
 drivers/gpu/drm/vkms/vkms_drv.c                    |   3 +-
 drivers/gpu/host1x/hw/syncpt_hw.c                  |   3 -
 drivers/gpu/ipu-v3/ipu-common.c                    |   1 +
 drivers/hid/hid-asus.c                             |  38 +-
 drivers/hid/hid-bigbenff.c                         |  75 +-
 drivers/hid/hid-debug.c                            |   1 +
 drivers/hid/hid-input.c                            |   8 +
 drivers/hid/hid-logitech-hidpp.c                   |  32 +-
 drivers/hwmon/coretemp.c                           | 128 ++-
 drivers/hwmon/ltc2945.c                            |   2 +
 drivers/hwmon/mlxreg-fan.c                         |   6 +
 drivers/iio/accel/mma9551_core.c                   |  10 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  59 +-
 drivers/input/misc/iqs269a.c                       | 327 +++----
 drivers/input/touchscreen/ads7846.c                | 473 +++++-----
 drivers/irqchip/irq-alpine-msi.c                   |   1 +
 drivers/irqchip/irq-bcm7120-l2.c                   |   3 +-
 drivers/irqchip/irq-brcmstb-l2.c                   |   6 +-
 drivers/irqchip/irq-mvebu-gicp.c                   |   1 +
 drivers/irqchip/irq-ti-sci-intr.c                  |   1 +
 drivers/irqchip/irqchip.c                          |   8 +-
 drivers/leds/led-class.c                           |   6 +-
 drivers/md/dm-cache-target.c                       |   4 +
 drivers/md/dm-flakey.c                             |  30 +-
 drivers/md/dm-thin.c                               |   2 +
 drivers/md/dm.c                                    |   2 +-
 drivers/media/i2c/imx219.c                         | 257 +++---
 drivers/media/i2c/max9286.c                        |   1 +
 drivers/media/i2c/ov2740.c                         |   4 +-
 drivers/media/i2c/ov5675.c                         |   4 +-
 drivers/media/i2c/ov7670.c                         |   2 +-
 drivers/media/i2c/ov772x.c                         |   3 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   3 +
 drivers/media/pci/saa7134/saa7134-core.c           |   2 +-
 drivers/media/platform/omap3isp/isp.c              |   9 +
 drivers/media/platform/ti-vpe/cal.c                |   4 +-
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
 drivers/mtd/spi-nor/core.c                         |   9 +
 drivers/mtd/spi-nor/core.h                         |   1 +
 drivers/mtd/spi-nor/sfdp.c                         |   4 +-
 drivers/mtd/ubi/build.c                            |   7 +
 drivers/mtd/ubi/fastmap-wl.c                       |  12 +-
 drivers/mtd/ubi/vmt.c                              |  18 +-
 drivers/mtd/ubi/wl.c                               |  25 +-
 drivers/net/can/usb/esd_usb2.c                     |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   8 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  11 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  17 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/geneve.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   3 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  79 +-
 drivers/net/tap.c                                  |   2 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/wireless/ath/ath11k/core.h             |   1 -
 drivers/net/wireless/ath/ath11k/debugfs.c          |  48 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   1 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  62 +-
 drivers/net/wireless/ath/ath9k/htc.h               |  32 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   2 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  10 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   4 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   5 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  11 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |  16 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  12 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   4 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |   2 +
 drivers/net/wireless/marvell/libertas/cmdresp.c    |   2 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   2 +-
 drivers/net/wireless/marvell/libertas/main.c       |   3 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |   6 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  13 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |   3 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   5 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  19 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |  91 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.h |   4 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c            |   1 +
 drivers/net/wireless/wl3501_cs.c                   |   2 +-
 drivers/nfc/st-nci/se.c                            |   6 +
 drivers/nfc/st21nfca/se.c                          |   6 +
 drivers/opp/debugfs.c                              |   2 +-
 drivers/pci/controller/pci-loongson.c              |  71 +-
 drivers/pci/pci.c                                  |  12 +-
 drivers/pci/pci.h                                  |  43 +-
 drivers/pci/quirks.c                               |  23 +
 drivers/pci/setup-bus.c                            | 179 ++--
 drivers/phy/rockchip/phy-rockchip-typec.c          |   3 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |   2 -
 drivers/pinctrl/mediatek/pinctrl-paris.c           |   4 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                |   4 +-
 drivers/pinctrl/pinctrl-at91.c                     |   2 +-
 drivers/pinctrl/pinctrl-ingenic.c                  |   3 +
 drivers/pinctrl/pinctrl-rockchip.c                 | 952 ++++++++-------------
 drivers/pinctrl/qcom/pinctrl-msm8976.c             |   8 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   1 +
 drivers/powercap/powercap_sys.c                    |  14 +-
 drivers/pwm/pwm-sifive.c                           |  16 +-
 drivers/pwm/pwm-stm32-lp.c                         |   2 +-
 drivers/regulator/max77802-regulator.c             |  34 +-
 drivers/regulator/s5m8767.c                        |   6 +-
 drivers/remoteproc/mtk_scp_ipi.c                   |  11 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |  59 +-
 drivers/rpmsg/qcom_glink_native.c                  |   1 +
 drivers/rtc/rtc-pm8xxx.c                           |  24 +-
 drivers/rtc/rtc-sun6i.c                            |  16 +-
 drivers/s390/block/dasd.c                          |   4 +-
 drivers/s390/block/dasd_diag.c                     |   8 +-
 drivers/s390/block/dasd_eckd.c                     |  82 +-
 drivers/s390/block/dasd_fba.c                      |   8 +-
 drivers/s390/block/dasd_int.h                      |   2 +-
 drivers/scsi/aic94xx/aic94xx_task.c                |   3 +
 drivers/scsi/ipr.c                                 |  41 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  23 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  19 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   9 +-
 drivers/scsi/ses.c                                 |  64 +-
 drivers/soundwire/cadence_master.c                 |  43 +-
 drivers/soundwire/cadence_master.h                 |  13 +-
 drivers/spi/Kconfig                                |   1 -
 drivers/spi/spi-bcm63xx-hsspi.c                    |  19 +-
 drivers/spi/spi-synquacer.c                        |   7 +-
 drivers/staging/emxx_udc/emxx_udc.c                |   7 +-
 drivers/thermal/hisi_thermal.c                     |   4 -
 drivers/thermal/intel/Kconfig                      |   3 +-
 drivers/thermal/intel/intel_powerclamp.c           |  20 +-
 drivers/thermal/intel/intel_quark_dts_thermal.c    |  12 +-
 drivers/thermal/intel/intel_soc_dts_iosf.c         |   2 +-
 drivers/thermal/qcom/tsens-v1.c                    |  63 +-
 drivers/thermal/qcom/tsens.c                       |   6 +
 drivers/thermal/qcom/tsens.h                       |   2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  24 +-
 drivers/tty/serial/sc16is7xx.c                     |  51 +-
 drivers/tty/tty_io.c                               |   8 +-
 drivers/tty/vt/vc_screen.c                         |   4 +-
 drivers/usb/gadget/function/uvc_configfs.c         |  59 +-
 drivers/usb/host/xhci-mvebu.c                      |   2 +-
 drivers/usb/storage/ene_ub6250.c                   |   2 +-
 drivers/vdpa/mlx5/core/mr.c                        |   1 -
 drivers/vfio/vfio_iommu_type1.c                    |  41 +-
 drivers/watchdog/at91sam9_wdt.c                    |   7 +-
 drivers/watchdog/pcwd_usb.c                        |   6 +-
 drivers/watchdog/watchdog_dev.c                    |   2 +-
 fs/cifs/smb2ops.c                                  |  13 +-
 fs/cifs/smbdirect.c                                |   4 +-
 fs/coda/upcall.c                                   |   2 +-
 fs/exfat/dir.c                                     |   7 +-
 fs/exfat/exfat_fs.h                                |   2 +-
 fs/exfat/file.c                                    |   3 +-
 fs/exfat/inode.c                                   |   6 +-
 fs/exfat/namei.c                                   |   2 +-
 fs/exfat/super.c                                   |   3 +-
 fs/ext4/xattr.c                                    |  35 +-
 fs/f2fs/data.c                                     |   6 +-
 fs/f2fs/inline.c                                   |  28 +-
 fs/f2fs/super.c                                    |  11 +-
 fs/f2fs/verity.c                                   |  12 +-
 fs/gfs2/aops.c                                     |   3 +-
 fs/gfs2/super.c                                    |   8 +-
 fs/hfs/bnode.c                                     |   1 +
 fs/hfsplus/super.c                                 |   4 +-
 fs/jbd2/transaction.c                              |  50 +-
 fs/jfs/jfs_dmap.c                                  |   3 +-
 fs/nfs/file.c                                      |  15 +-
 fs/nfs/inode.c                                     |   6 +-
 fs/nfs/nfs4_fs.h                                   |   1 +
 fs/nfs/nfs4proc.c                                  |  22 +
 fs/nfs/nfs4state.c                                 |  40 +-
 fs/nfs/nfs4trace.h                                 |  42 +-
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
 fs/udf/inode.c                                     |  74 +-
 fs/udf/super.c                                     |   1 +
 fs/udf/udf_i.h                                     |   3 +-
 fs/udf/udf_sb.h                                    |   2 +
 include/drm/drm_mipi_dsi.h                         |   4 +
 include/linux/bootconfig.h                         |   2 +-
 include/linux/ima.h                                |   6 +-
 include/linux/kernel.h                             |   2 +
 include/linux/kernel_stat.h                        |   2 +-
 include/linux/kprobes.h                            |   2 +
 include/linux/nfs_xdr.h                            |   2 +
 include/linux/pci.h                                |   1 +
 include/linux/pci_ids.h                            |   2 +
 include/linux/rcupdate.h                           |  11 +-
 include/linux/uaccess.h                            |   4 +
 include/net/sctp/structs.h                         |   1 +
 include/net/sock.h                                 |   7 +-
 include/sound/soc-dapm.h                           |   1 +
 include/uapi/linux/usb/video.h                     |  30 +
 include/uapi/linux/uvcvideo.h                      |   2 +-
 io_uring/io_uring.c                                |  41 +-
 kernel/bpf/btf.c                                   |  13 +-
 kernel/fail_function.c                             |   5 +-
 kernel/irq/irqdomain.c                             |  31 +-
 kernel/kprobes.c                                   |   6 +-
 kernel/pid_namespace.c                             |  17 +
 kernel/power/energy_model.c                        |   5 +-
 kernel/rcu/tasks.h                                 |  64 +-
 kernel/rcu/tree_exp.h                              |   2 +
 kernel/resource.c                                  |  14 -
 kernel/sched/deadline.c                            |   5 +-
 kernel/sched/rt.c                                  |  10 +-
 kernel/time/clocksource.c                          |  45 +-
 kernel/time/hrtimer.c                              |   2 +
 kernel/time/posix-stubs.c                          |   2 +
 kernel/time/posix-timers.c                         |   2 +
 kernel/trace/ring_buffer.c                         |  49 +-
 lib/errname.c                                      |  22 +-
 lib/mpi/mpicoder.c                                 |   3 +-
 mm/huge_memory.c                                   |   3 +
 mm/memcontrol.c                                    |   4 +
 net/9p/trans_rdma.c                                |  15 +-
 net/9p/trans_xen.c                                 |  48 +-
 net/bluetooth/hci_sock.c                           |  11 +-
 net/bluetooth/l2cap_core.c                         |  24 -
 net/bluetooth/l2cap_sock.c                         |   8 +
 net/bridge/netfilter/ebtables.c                    |   2 +-
 net/core/dev.c                                     |   4 +-
 net/core/sock.c                                    |  15 +-
 net/ipv4/inet_connection_sock.c                    |   1 +
 net/ipv4/inet_hashtables.c                         |  12 +-
 net/ipv4/netfilter/ip_tables.c                     |   3 +-
 net/ipv4/tcp_minisocks.c                           |   7 +-
 net/ipv6/netfilter/ip6_tables.c                    |   3 +-
 net/ipv6/route.c                                   |  11 +-
 net/l2tp/l2tp_ppp.c                                | 125 +--
 net/mac80211/sta_info.c                            |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |   5 +-
 net/nfc/netlink.c                                  |   4 +
 net/rds/message.c                                  |   2 +-
 net/sched/Kconfig                                  |  11 -
 net/sched/Makefile                                 |   1 -
 net/sched/act_sample.c                             |  11 +-
 net/sched/cls_tcindex.c                            | 756 ----------------
 net/sctp/stream_sched_prio.c                       |  52 +-
 net/sunrpc/clnt.c                                  |   4 +
 net/tls/tls_sw.c                                   |  26 +-
 net/wireless/nl80211.c                             |   2 +-
 net/wireless/sme.c                                 |  31 +-
 scripts/package/mkdebian                           |   2 +-
 security/integrity/ima/ima_main.c                  |   7 +-
 security/security.c                                |   7 +-
 sound/pci/hda/patch_ca0132.c                       |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/ice1712/aureon.c                         |   2 +-
 sound/soc/atmel/mchp-spdifrx.c                     | 344 +++++---
 sound/soc/atmel/mchp-spdiftx.c                     |   2 +-
 sound/soc/atmel/tse850-pcm5142.c                   |   2 +-
 sound/soc/codecs/Kconfig                           |   2 +-
 sound/soc/codecs/adau7118.c                        |  19 +-
 sound/soc/codecs/tlv320adcx140.c                   |   2 +-
 sound/soc/fsl/fsl_sai.c                            |   1 +
 sound/soc/kirkwood/kirkwood-dma.c                  |   2 +-
 sound/soc/soc-compress.c                           |   2 +-
 tools/bpf/bpftool/prog.c                           |  38 +-
 tools/iio/iio_utils.c                              |  23 +-
 tools/lib/bpf/btf.c                                |  13 +
 tools/lib/bpf/nlattr.c                             |   2 +-
 tools/objtool/check.c                              |   5 +
 tools/perf/perf-completion.sh                      |  11 +-
 tools/perf/util/llvm-utils.c                       |  25 +-
 tools/testing/ktest/ktest.pl                       |  26 +-
 tools/testing/ktest/sample.conf                    |   5 +
 tools/testing/selftests/bpf/Makefile               |   2 -
 .../selftests/drivers/net/netdevsim/devlink.sh     |  18 +
 .../ftrace/test.d/ftrace/func_event_triggers.tc    |   2 +-
 tools/testing/selftests/net/fib_tests.sh           |   2 +
 tools/testing/selftests/net/udpgso_bench_rx.c      |   6 +-
 virt/kvm/coalesced_mmio.c                          |   8 +-
 470 files changed, 4823 insertions(+), 4538 deletions(-)


