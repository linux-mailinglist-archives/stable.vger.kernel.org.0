Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B223E25A705
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 09:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIBHss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 03:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgIBHss (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 03:48:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959DD2084C;
        Wed,  2 Sep 2020 07:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599032925;
        bh=eAV2HYB0T1mFZj7/sg56d8UyL/NUrt/A+z0tg/VBT+c=;
        h=From:To:Cc:Subject:Date:From;
        b=oYvrkpTgmrF4C1e+4jADPPmPC2mn6+4PFlLiZZAfAoDirsD+5Zg43fR+n9YBA037z
         5Rsbq2E6QpJhnzR+NXsSTolUZXAEl82MNvGC/m0hKCg0lAwHmm/8w99K2eQL7Ay514
         EYEz+fbq0UV6YdmTY9H6Qp+oGL3nQz6r4DDH35wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.8 000/253] 5.8.6-rc2 review
Date:   Wed,  2 Sep 2020 09:49:11 +0200
Message-Id: <20200902074837.329205434@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.6-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.6-rc2
X-KernelTest-Deadline: 2020-09-04T07:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.6 release.
There are 253 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 04 Sep 2020 07:47:48 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.6-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.6-rc2

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: Update documentation comment for MS2109 quirk

Dan Carpenter <dan.carpenter@oracle.com>
    dma-pool: Fix an uninitialized variable bug in atomic_pool_expand()

Roland Scheidegger <sroland@vmware.com>
    drm/vmwgfx/ldu: Use drm_mode_config_reset

Roland Scheidegger <sroland@vmware.com>
    drm/vmwgfx/sou: Use drm_mode_config_reset

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/vmwgfx/stdu: Use drm_mode_config_reset

Peilin Ye <yepeilin.cs@gmail.com>
    HID: hiddev: Fix slab-out-of-bounds write in hiddev_ioctl_usage()

Qian Cai <cai@lca.pw>
    mm/page_counter: fix various data races at memsw

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    fbmem: pull fbcon_update_vcs() out of fb_set_var()

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/atomic-helper: reset vblank on crtc reset

Jens Axboe <axboe@kernel.dk>
    io_uring: make offset == -1 consistent with preadv2/pwritev2

Jens Axboe <axboe@kernel.dk>
    io_uring: don't use poll handler if file can't be nonblocking read/written

Jens Axboe <axboe@kernel.dk>
    io_uring: don't recurse on tsk->sighand->siglock with signalfd

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Fix Fix source hard reset response for TDA 2.3.1.1 and TDA 2.3.1.2 failures

Hans de Goede <hdegoede@redhat.com>
    usb: typec: ucsi: Hold con->lock for the entire duration of ucsi_register_port()

Hans de Goede <hdegoede@redhat.com>
    usb: typec: ucsi: Rework ppm_lock handling

Hans de Goede <hdegoede@redhat.com>
    usb: typec: ucsi: Fix 2 unlocked ucsi_run_command calls

Hans de Goede <hdegoede@redhat.com>
    usb: typec: ucsi: Fix AB BA lock inversion

Bastien Nocera <hadess@hadess.net>
    USB: Fix device driver race

Bastien Nocera <hadess@hadess.net>
    USB: Also match device drivers using the ->match vfunc

Alan Stern <stern@rowland.harvard.edu>
    usb: storage: Add unusual_uas entry for Sony PSZ drives

Tom Rix <trix@redhat.com>
    USB: cdc-acm: rework notification_buffer resizing

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Handle ZLP for sg requests

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix handling ZLP

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't setup more than requested

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    USB: gadget: u_f: Unbreak offset calculation in VLAs

Brooke Basile <brookebasile@gmail.com>
    USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()

Brooke Basile <brookebasile@gmail.com>
    USB: gadget: u_f: add overflow checks to VLA macros

Tang Bin <tangbin@cmss.chinamobile.com>
    usb: host: ohci-exynos: Fix error handling in exynos_ohci_probe()

Cyril Roelandt <tipecaml@gmail.com>
    USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge

Alan Stern <stern@rowland.harvard.edu>
    USB: quirks: Ignore duplicate endpoint on Sound Devices MixPre-D

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: quirks: Add no-lpm quirk for another Raydium touchscreen

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: uas: Add quirk for PNY Pro Elite

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Fix bad gfp argument

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct the thermal alert temperature limit settings

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct Vega20 swctf limit setting

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct Vega12 swctf limit setting

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct Vega10 swctf limit setting

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/powerplay: Fix hardmins not being sent to SMU for RV

Jiansong Chen <Jiansong.Chen@amd.com>
    drm/amdgpu/gfx10: refine mgcg setting

Alexander Monakov <amonakov@ispras.ru>
    drm/amd/display: use correct scale for actual_brightness

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Fix buffer overflow in INFO ioctl

Daniel Vetter <daniel.vetter@intel.com>
    drm/modeset-lock: Take the modeset BKL for legacy drivers

Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
    drm/dp_mst: Don't return error code when crtc is null

Christian Gmeiner <christian.gmeiner@gmail.com>
    drm/etnaviv: fix external abort seen on GC600 rev 0x19

Mika Kuoppala <mika.kuoppala@linux.intel.com>
    drm/i915: Fix cmd parser desc matching with masks

Ashok Raj <ashok.raj@intel.com>
    x86/hotplug: Silence APIC only after all interrupts are migrated

Thomas Gleixner <tglx@linutronix.de>
    x86/irq: Unbreak interrupt affinity setting

qiuguorui1 <qiuguorui1@huawei.com>
    irqchip/stm32-exti: Avoid losing interrupts due to clearing pending bits by mistake

Thomas Gleixner <tglx@linutronix.de>
    genirq/matrix: Deal with the sillyness of for_each_cpu() on UP

M. Vefa Bicakci <m.v.b@runbox.com>
    usbip: Implement a match function to fix usbip

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Work around empty control messages without MSG_MORE

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    device property: Fix the secondary firmware node handling in set_primary_fwnode()

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/perf: Fix crashes with generic_compat_pmu & BHRB

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Disable VMAP stack which CONFIG_ADB_PMU

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Fix the handling of pending runtime resume requests

Frank van der Linden <fllinden@amazon.com>
    arm64: vdso32: make vdso32 install conditional

James Morse <james.morse@arm.com>
    KVM: arm64: Set HCR_EL2.PTW to prevent AT taking synchronous exception

Pavel Begunkov <asml.silence@gmail.com>
    io-wq: fix hang after cancelling pending hashed work

Ding Hui <dinghui@sangfor.com.cn>
    xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Do warm-reset when both CAS and XDEV_RESUME are set

Li Jun <jun.li@nxp.com>
    usb: host: xhci: fix ep context print mismatch in debugfs

JC Kuo <jckuo@nvidia.com>
    usb: host: xhci-tegra: fix tegra_xusb_get_phy()

JC Kuo <jckuo@nvidia.com>
    usb: host: xhci-tegra: otg usb2/usb3 port init

Vinod Koul <vkoul@kernel.org>
    usb: renesas-xhci: remove version check

Thomas Gleixner <tglx@linutronix.de>
    XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.

Jan Kara <jack@suse.cz>
    writeback: Fix sync livelock due to b_dirty_time processing

Jan Kara <jack@suse.cz>
    writeback: Avoid skipping inode writeback

Jan Kara <jack@suse.cz>
    writeback: Protect inode->i_io_list with inode->i_lock

Jens Axboe <axboe@kernel.dk>
    io_uring: clear req->result on IOPOLL re-issue

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    serial: 8250: change lock order in serial8250_do_startup()

Valmer Huhn <valmer.huhn@concurrent-rt.com>
    serial: 8250_exar: Fix number of ports for Commtech PCIe cards

Holger Assmann <h.assmann@pengutronix.de>
    serial: stm32: avoid kernel warning on absence of optional IRQ

Lukas Wunner <lukas@wunner.de>
    serial: pl011: Don't leak amba_ports entry on driver register error

Lukas Wunner <lukas@wunner.de>
    serial: pl011: Fix oops on -EPROBE_DEFER

Tamseel Shams <m.shams@samsung.com>
    serial: samsung: Removes the IRQ not found warning

George Kennedy <george.kennedy@oracle.com>
    vt_ioctl: change VT_RESIZEX ioctl to check for error return from vc_resize()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    vt: defer kfree() of vc_screenbuf in vc_do_resize()

Evgeny Novikov <novikov@ispras.ru>
    USB: lvtest: return proper error code in probe

George Kennedy <george.kennedy@oracle.com>
    fbcon: prevent user font height or width change from causing potential out-of-bounds access

Boris Burkov <boris@bur.io>
    btrfs: detect nocow for swap after snapshot delete

Filipe Manana <fdmanana@suse.com>
    btrfs: fix space cache memory leak after transaction abort

Josef Bacik <josef@toxicpanda.com>
    btrfs: check the right error variable in btrfs_del_dir_entries_in_log

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: reset compression level for lzo on remount

Ming Lei <ming.lei@redhat.com>
    blk-mq: order adding requests to hctx->dispatch and checking SCHED_RESTART

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Always sleep 60ms after I2C_HID_PWR_ON commands

Ming Lei <ming.lei@redhat.com>
    block: loop: set discard granularity and alignment for block device backed loop

Keith Busch <kbusch@kernel.org>
    block: fix get_max_io_size()

Tim Harvey <tharvey@gateworks.com>
    hwmon: (gsc-hwmon) Scale temperature to millidegrees

Marc Zyngier <maz@kernel.org>
    arm64: Allow booting of late CPUs affected by erratum 1418040

Marc Zyngier <maz@kernel.org>
    arm64: Move handling of erratum 1418040 into C code

Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
    bpf: selftests: global_funcs: Check err_str before strstr

Toke Høiland-Jørgensen <toke@redhat.com>
    libbpf: Fix map index used in error message

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix soft lockups due to missed interrupt accounting

brookxu <brookxu.cn@gmail.com>
    ext4: limit the length of per-inode prealloc list

Yonghong Song <yhs@fb.com>
    bpf: Avoid visit same object multiple times

Yonghong Song <yhs@fb.com>
    bpf: Fix a rcu_sched stall issue with bpf task/task_file iterator

Huang Rui <ray.huang@amd.com>
    drm/amdkfd: fix the wrong sdma instance query for renoir

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: fix NULL pointer access issue when unloading driver

Sumera Priyadarsini <sylphrenadin@gmail.com>
    net: gianfar: Add of_node_put() before goto statement

Alvin Šipraga <alsi@bang-olufsen.dk>
    macvlan: validate setting of multiple remote source MAC addresses

Saurav Kashyap <skashyap@marvell.com>
    Revert "scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix null pointer access during disconnect from subsystem

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Check if FW supports MQ before enabling

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix login timeout

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Indicate correct supported speeds for Mezz card

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Flush I/O on zone disable

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Flush all sessions on zone disable

Douglas Gilbert <dgilbert@interlog.com>
    scsi: scsi_debug: Fix scp is NULL errors

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Clean up completed request without interrupt notification

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: Improve interrupt handling for shared interrupts

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix possible infinite loop in ufshcd_hold

Mike Christie <michael.christie@oracle.com>
    scsi: fcoe: Fix I/O path allocation

David Ahern <dsahern@kernel.org>
    selftests: disable rp_filter for icmp_redirect.sh

Tom Yan <tom.ty89@gmail.com>
    ALSA: usb-audio: ignore broken processing/extension unit

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: wm8994: Avoid attempts to read unreadable registers

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: add cond_resched() in the slow_eval_known_fn() loop

Mike Pozulp <pozulp.kernel@gmail.com>
    ALSA: hda/realtek: Add model alc298-samsung-headphone

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_x25: Added needed_headroom and a skb->len check

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    dma-pool: Only allocate from CMA when in same memory zone

Christoph Hellwig <hch@lst.de>
    dma-pool: fix coherent pool allocations for IOMMU mappings

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: transport: j1939_xtp_rx_dat_one(): compare own packets to detect corruptions

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Correct various core_reloc 64-bit assumptions

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix btf_dump test cases on 32-bit arches

Andrii Nakryiko <andriin@fb.com>
    selftest/bpf: Fix compilation warnings in 32-bit mode

Andrii Nakryiko <andriin@fb.com>
    tools/bpftool: Fix compilation warnings in 32-bit mode

Toke Høiland-Jørgensen <toke@redhat.com>
    libbpf: Prevent overriding errno when logging errors

Florian Westphal <fw@strlen.de>
    netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency

Jianlin Lv <Jianlin.Lv@arm.com>
    selftests/bpf: Fix segmentation fault in test_progs

Anthony Koo <Anthony.Koo@amd.com>
    drm/amd/display: Switch to immediate mode for updating infopackets

Anthony Koo <Anthony.Koo@amd.com>
    drm/amd/display: Fix LFC multiplier changing erratically

Evan Quan <evan.quan@amd.com>
    drm/amd/powerplay: correct UVD/VCE PG state on custom pptable uploading

Evan Quan <evan.quan@amd.com>
    drm/amd/powerplay: correct Vega20 cached smu feature state

Alain Volmat <alain.volmat@st.com>
    spi: stm32: always perform registers configuration prior to transfer

Amelie Delaunay <amelie.delaunay@st.com>
    spi: stm32: fix stm32_spi_prepare_mbr in case of odd clk_rate

Amelie Delaunay <amelie.delaunay@st.com>
    spi: stm32: fix fifo threshold level in case of short transfer

Antonio Borneo <antonio.borneo@st.com>
    spi: stm32h7: fix race condition at end of transfer

Xianting Tian <xianting_tian@126.com>
    fs: prevent BUG_ON in submit_bh_wbc()

Jan Kara <jack@suse.cz>
    ext4: correctly restore system zone info when remount fails

Jan Kara <jack@suse.cz>
    ext4: handle error of ext4_setup_system_zone() on remount

Lukas Czerner <lczerner@redhat.com>
    ext4: handle option set by mount flags correctly

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: abort journal if free a async write error metadata buffer

zhangyi (F) <yi.zhang@huawei.com>
    ext4: abort the filesystem if failed to async write metadata buffer

Xin He <hexin.op@bytedance.com>
    drm/virtio: fix memory leak in virtio_gpu_cleanup_object()

Alex Zhuravlev <azhuravlev@whamcloud.com>
    ext4: skip non-loaded groups at cr=0/1 when scanning for good groups

Lukas Czerner <lczerner@redhat.com>
    ext4: handle read only external journal device

Jan Kara <jack@suse.cz>
    ext4: don't BUG on inconsistent journal feature

Lukas Czerner <lczerner@redhat.com>
    jbd2: make sure jh have b_transaction set in refile/unfile_buffer

Tobias Schramm <t.schramm@manjaro.org>
    spi: stm32: clear only asserted irq flags on interrupt

Michael Ellerman <mpe@ellerman.id.au>
    video: fbdev: controlfb: Fix build for COMPILE_TEST=y && PPC_PMAC=n

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: f_tcm: Fix some resource leaks in some error paths

Jason Wang <jasowang@redhat.com>
    vdpa: ifcvf: free config irq in ifcvf_free_irq()

Jason Wang <jasowang@redhat.com>
    vdpa: ifcvf: return err when fail to request config irq

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: in slave mode, clear NACK earlier

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: core: Don't fail PRP0001 enumeration when no ID table exist

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: always start/stop scheduler in timeout processing

Dan Carpenter <dan.carpenter@oracle.com>
    habanalabs: Fix memory corruption in debugfs

Hou Pu <houpu@bytedance.com>
    null_blk: fix passing of REQ_FUA flag in null_handle_rq

Martin Wilck <mwilck@suse.com>
    nvme: multipath: round-robin: fix single non-optimized path case

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    nvme-fc: Fix wrong return value in __nvme_fc_init_request()

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix a memory leak

Yufen Yu <yuyufen@huawei.com>
    blkcg: fix memleak for iolatency

Ming Lei <ming.lei@redhat.com>
    blk-mq: insert request not through ->queue_rq into sw/scheduler queue

Jason Baron <jbaron@akamai.com>
    hwmon: (nct7904) Correct divide by 0

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    bfq: fix blkio cgroup leakage v4

Matthew Wilcox (Oracle) <willy@infradead.org>
    block: Fix page_is_mergeable() for compound pages

Rob Clark <robdclark@chromium.org>
    drm/msm/adreno: fix updating ring fence

Ming Lei <ming.lei@redhat.com>
    block: virtio_blk: fix handling single range discard request

Ming Lei <ming.lei@redhat.com>
    block: respect queue limit of max discard segment

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix oops on mixed NFSv4/NFSv3 client access

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add capture support for Saffire 6 (USB 1.1)

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fix EPP setting via sysfs in active mode

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: Fix the wrong end with semicolon

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Add missing reset for ipq806x

Abhishek Sahu <absahu@codeaurora.org>
    PCI: qcom: Change duplicate PCI reset to phy reset

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Add missing ipq806x clocks in PCIe driver

Tonghao Zhang <xiangxia.m.yue@gmail.com>
    net: openvswitch: introduce common code for flushing flows

Kefeng Wang <wangkefeng.wang@huawei.com>
    arm64: Fix __cpu_logical_map undefined issue

Andrey Konovalov <andreyknvl@google.com>
    efi: provide empty efi_enter_virtual_mode implementation

Randy Dunlap <rdunlap@infradead.org>
    pinctrl: mediatek: fix build for tristate changes

Hanks Chen <hanks.chen@mediatek.com>
    pinctrl: mediatek: avoid virtual gpio trying to set reg

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    brcmfmac: Set timeout value when configuring power save

Manish Narani <manish.narani@xilinx.com>
    mmc: sdhci-of-arasan: fix timings allocation code

Changming Liu <charley.ashbringer@gmail.com>
    USB: sisusbvga: Fix a potential UB casued by left shifting a negative value

Sasha Levin <sashal@kernel.org>
    dmaengine: idxd: fix PCI_MSI build errors

Arnd Bergmann <arnd@arndb.de>
    powerpc/spufs: add CONFIG_COREDUMP dependency

David Brazdil <dbrazdil@google.com>
    KVM: arm64: Fix symbol dependency in __hyp_call_panic_nvhe

Qingqing Zhuo <qingqing.zhuo@amd.com>
    drm/amd/display: fix compilation error on allmodconfig

Lewis Huang <Lewis.Huang@amd.com>
    drm/amd/display: change global buffer to local buffer

Andrey Konovalov <andrey.konovalov@linaro.org>
    media: i2c: imx290: fix reset GPIO pin handling

Evgeny Novikov <novikov@ispras.ru>
    media: davinci: vpif_capture: fix potential double free

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: prevent filesystem stacking of hugetlbfs

Jason Baron <jbaron@akamai.com>
    EDAC/ie31200: Fallback if host bridge device is already initialized

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: i801: Add support for Intel Tiger Lake PCH-H

Javed Hasan <jhasan@marvell.com>
    scsi: fcoe: Memory leak fix in fcoe_sysfs_fcf_del()

Xiubo Li <xiubli@redhat.com>
    ceph: do not access the kiocb after aio requests

Xiubo Li <xiubli@redhat.com>
    ceph: fix potential mdsc use-after-free crash

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: report EEXIST on overlaps

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: iscsi: Do not put host in iscsi_set_flashnode_param()

Nikolay Borisov <nborisov@suse.com>
    btrfs: make btrfs_qgroup_check_reserved_leak take btrfs_inode

Qu Wenruo <wqu@suse.com>
    btrfs: file: reserve qgroup space after the hole punch range is locked

Chris Wilson <chris@chris-wilson.co.uk>
    locking/lockdep: Fix overflow in presentation of average lock-time

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: Fix reference count leak in nouveau_connector_detect

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: fix reference count leak in nv50_disp_atomic_commit

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau/drm/noveau: fix reference count leak in nouveau_fbcon_open

Li Guifu <bluce.liguifu@huawei.com>
    f2fs: fix use-after-free issue

Ikjoon Jang <ikjn@chromium.org>
    HID: quirks: add NOGET quirk for Logitech GROUP

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw_rt711: remove properties in card remove

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    cec-api: prevent leaking memory through hole in structure

Dmitry Osipenko <digetx@gmail.com>
    gpu: host1x: Put gather's BO on pinning error

Kaige Li <likaige@loongson.cn>
    ALSA: hda: Add support for Loongson 7A1000 controller

Peng Fan <fanpeng@loongson.cn>
    mips/vdso: Fix resource leaks in genvdso.c

Reto Schneider <code@reto-schneider.ch>
    rtlwifi: rtl8192cu: Prevent leaking urb

Yangbo Lu <yangbo.lu@nxp.com>
    ARM: dts: ls1021a: output PPS signal on FIPER2

Qiushi Wu <wu000273@umn.edu>
    PCI: Fix pci_create_slot() reference count leak

Aditya Pakki <pakki001@umn.edu>
    omapfb: fix multiple reference count leaks due to pm_runtime_get_sync

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: KVM: Limit Trap-and-Emulate to MIPS32R2 only

Chao Yu <chao@kernel.org>
    f2fs: fix error path in do_recover_data()

Dehe Gu <gudehe@huawei.com>
    f2fs: remove write attribute of main_blkaddr sysfs node

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    selftests/powerpc: Purge extra count_pmc() calls of ebb selftests

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix xcopy sess release leak

Dave Chinner <dchinner@redhat.com>
    xfs: Don't allow logging of XFS_ISTALE inodes

Dick Kennedy <dick.kennedy@broadcom.com>
    scsi: lpfc: Fix shost refcount mismatch when deleting vport

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: fix ref count leak when pm_runtime_get_sync fails

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: fix ref count leak when pm_runtime_get_sync fails

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/fence: fix ref count leak when pm_runtime_get_sync fails

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amdgpu/display: fix ref count leak when pm_runtime_get_sync fails

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amdgpu: fix ref count leak in amdgpu_display_crtc_set_config

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amd/display: fix ref count leak in amdgpu_drm_ioctl

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amdgpu: fix ref count leak in amdgpu_driver_open_kms

Aditya Pakki <pakki001@umn.edu>
    drm/radeon: fix multiple reference count leak

Qiushi Wu <wu000273@umn.edu>
    drm/amdkfd: Fix reference count leaks.

Gwendal Grignou <gwendal@chromium.org>
    platform/chrome: cros_ec_sensorhub: Fix EC timestamp overflow

Robin Murphy <robin.murphy@arm.com>
    iommu/iova: Don't BUG on invalid PFNs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Add Intel Tiger Lake PCH-H PCI IDs

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Fix crash on ARM during cmd completion

Evgeny Novikov <novikov@ispras.ru>
    staging: rts5208: fix memleaks on error handling paths in probe

Luis Chamberlain <mcgrof@kernel.org>
    blktrace: ensure our debugfs dir exists

Alexander Popov <alex.popov@linux.com>
    gcc-plugins/stackleak: Don't instrument itself

Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
    media: pci: ttpci: av7110: fix possible buffer overflow caused by bad DMA value in debiirq()

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/xive: Ignore kmemleak false positives

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Pull down PDM GPIOs during sleep

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Add Intel Emmitsburg PCH PCI IDs

Qiushi Wu <wu000273@umn.edu>
    ASoC: tegra: Fix reference count leaks.

Qiushi Wu <wu000273@umn.edu>
    ASoC: img-parallel-out: Fix a reference count leak

Qiushi Wu <wu000273@umn.edu>
    ASoC: img: Fix a reference count leak in img_i2s_in_set_fmt

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    EDAC/mc: Call edac_inc_ue_error() before panic

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: fix RAS memory leak in error case

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/hdmi: Use force connectivity quirk on another HP desktop

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Fix pin default on Intel NUC 8 Rugged

Randy Dunlap <rdunlap@infradead.org>
    ALSA: pci: delete repeated words in comments

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/hdmi: Add quirk to force connectivity

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: intel/skl/hda - fix probe regression on systems without i915

Hugh Dickins <hughd@google.com>
    khugepaged: khugepaged_test_exit() check mmget_still_valid()


-------------

Diffstat:

 Documentation/admin-guide/ext4.rst                 |   3 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/ls1021a.dtsi                     |   2 +-
 arch/arm64/Makefile                                |   3 +-
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi         |   2 +-
 arch/arm64/include/asm/kvm_arm.h                   |   3 +-
 arch/arm64/include/asm/smp.h                       |   7 +-
 arch/arm64/kernel/cpu_errata.c                     |   2 +
 arch/arm64/kernel/entry.S                          |  21 --
 arch/arm64/kernel/process.c                        |  34 ++++
 arch/arm64/kernel/setup.c                          |   8 +-
 arch/arm64/kernel/smp.c                            |   6 +-
 arch/arm64/kvm/hyp/switch.c                        |   2 +-
 arch/mips/Kconfig                                  |   1 +
 arch/mips/kvm/Kconfig                              |   3 +-
 arch/mips/vdso/genvdso.c                           |  10 +
 arch/powerpc/perf/core-book3s.c                    |  23 ++-
 arch/powerpc/platforms/Kconfig.cputype             |   2 +-
 arch/powerpc/platforms/cell/Kconfig                |   1 +
 arch/powerpc/sysdev/xive/native.c                  |   2 +
 arch/x86/kernel/apic/vector.c                      |  16 +-
 arch/x86/kernel/smpboot.c                          |  26 ++-
 block/bfq-cgroup.c                                 |   2 +-
 block/bfq-iosched.h                                |   1 -
 block/bfq-wf2q.c                                   |  12 +-
 block/bio.c                                        |  10 +-
 block/blk-cgroup.c                                 |   8 +-
 block/blk-merge.c                                  |  13 +-
 block/blk-mq-sched.c                               |   9 +
 block/blk-mq.c                                     |  12 +-
 crypto/af_alg.c                                    |  13 +-
 drivers/base/core.c                                |  12 +-
 drivers/base/power/main.c                          |  16 +-
 drivers/block/loop.c                               |  33 ++--
 drivers/block/null_blk_main.c                      |   2 +-
 drivers/block/virtio_blk.c                         |  31 ++-
 drivers/cpufreq/intel_pstate.c                     |  18 +-
 drivers/devfreq/devfreq.c                          |   4 +-
 drivers/dma/Kconfig                                |   1 +
 drivers/edac/edac_mc.c                             |   4 +-
 drivers/edac/ie31200_edac.c                        |  50 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c  |  31 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             | 220 +++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  21 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |  20 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  81 ++++----
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_color.c    |  10 +-
 .../amd/display/dc/dcn10/dcn10_stream_encoder.c    |  16 +-
 .../amd/display/dc/dcn10/dcn10_stream_encoder.h    |  14 ++
 drivers/gpu/drm/amd/display/modules/color/Makefile |   2 +-
 .../drm/amd/display/modules/color/color_gamma.c    | 115 ++++++-----
 .../drm/amd/display/modules/color/color_gamma.h    |  18 +-
 .../drm/amd/display/modules/color/color_table.c    |  48 +++++
 .../drm/amd/display/modules/color/color_table.h    |  47 +++++
 .../drm/amd/display/modules/freesync/freesync.c    |  36 +++-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c  |   9 +-
 .../gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c   |  22 ++-
 .../gpu/drm/amd/powerplay/hwmgr/vega12_thermal.c   |  21 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c |  44 ++---
 .../gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c   |  21 +-
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c   |   7 +-
 drivers/gpu/drm/arm/malidp_drv.c                   |   1 -
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     |   7 +-
 drivers/gpu/drm/drm_atomic_helper.c                |   7 +-
 drivers/gpu/drm/drm_atomic_state_helper.c          |   4 +
 drivers/gpu/drm/drm_color_mgmt.c                   |   2 +-
 drivers/gpu/drm/drm_crtc.c                         |   4 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   4 +-
 drivers/gpu/drm/drm_mode_object.c                  |   4 +-
 drivers/gpu/drm/drm_plane.c                        |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  11 +-
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |  11 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c             |  14 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |   2 -
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   4 +-
 drivers/gpu/drm/omapdrm/omap_crtc.c                |   8 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |   4 -
 drivers/gpu/drm/radeon/radeon_connectors.c         |  20 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |   6 +-
 drivers/gpu/drm/tegra/dc.c                         |   1 -
 drivers/gpu/drm/tidss/tidss_crtc.c                 |   3 +-
 drivers/gpu/drm/tidss/tidss_kms.c                  |   5 -
 drivers/gpu/drm/virtio/virtgpu_object.c            |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |   9 +-
 drivers/gpu/host1x/job.c                           |  13 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  22 ++-
 drivers/hid/usbhid/hiddev.c                        |   4 +
 drivers/hwmon/gsc-hwmon.c                          |   1 +
 drivers/hwmon/nct7904.c                            |   4 +-
 drivers/i2c/busses/i2c-i801.c                      |   4 +
 drivers/i2c/busses/i2c-rcar.c                      |   1 +
 drivers/i2c/i2c-core-base.c                        |   2 +-
 drivers/iommu/dma-iommu.c                          |   4 +-
 drivers/iommu/iova.c                               |   4 +-
 drivers/irqchip/irq-stm32-exti.c                   |  14 +-
 drivers/media/cec/core/cec-api.c                   |   8 +-
 drivers/media/i2c/imx290.c                         |   7 +-
 drivers/media/pci/ttpci/av7110.c                   |   5 +-
 drivers/media/platform/davinci/vpif_capture.c      |   2 -
 drivers/mfd/intel-lpss-pci.c                       |  19 ++
 drivers/misc/habanalabs/debugfs.c                  |   8 +-
 drivers/mmc/host/sdhci-of-arasan.c                 |  25 +--
 drivers/net/ethernet/freescale/gianfar.c           |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |   2 +-
 drivers/net/macvlan.c                              |  21 +-
 drivers/net/wan/hdlc.c                             |   1 +
 drivers/net/wan/hdlc_x25.c                         |  17 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   8 +
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   5 +-
 drivers/nvme/host/fc.c                             |   4 +-
 drivers/nvme/host/multipath.c                      |  15 +-
 drivers/nvme/target/configfs.c                     |   1 +
 drivers/pci/controller/dwc/pcie-qcom.c             |  58 +++++-
 drivers/pci/slot.c                                 |   6 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |  26 +++
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h   |   1 +
 drivers/pinctrl/mediatek/pinctrl-paris.c           |   7 +
 drivers/platform/chrome/cros_ec_sensorhub_ring.c   |   4 +-
 drivers/s390/cio/css.c                             |   5 +
 drivers/scsi/fcoe/fcoe_ctlr.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |  26 +--
 drivers/scsi/qla2xxx/qla_gs.c                      |  48 ++++-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   8 -
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +
 drivers/scsi/qla2xxx/qla_os.c                      |   5 +
 drivers/scsi/qla2xxx/qla_target.c                  |   2 +-
 drivers/scsi/scsi_debug.c                          |   2 +
 drivers/scsi/scsi_transport_iscsi.c                |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  14 +-
 drivers/spi/spi-stm32.c                            |  73 +++----
 drivers/staging/rts5208/rtsx.c                     |   1 +
 drivers/target/target_core_internal.h              |   1 +
 drivers/target/target_core_transport.c             |   7 +-
 drivers/target/target_core_user.c                  |   9 +-
 drivers/target/target_core_xcopy.c                 |  11 +-
 drivers/tty/serial/8250/8250_exar.c                |  24 ++-
 drivers/tty/serial/8250/8250_port.c                |   9 +-
 drivers/tty/serial/amba-pl011.c                    |  16 +-
 drivers/tty/serial/samsung_tty.c                   |   8 +-
 drivers/tty/serial/stm32-usart.c                   |   2 +-
 drivers/tty/vt/vt.c                                |   5 +-
 drivers/tty/vt/vt_ioctl.c                          |  12 +-
 drivers/usb/class/cdc-acm.c                        |  22 +--
 drivers/usb/core/driver.c                          |  40 +++-
 drivers/usb/core/generic.c                         |   5 +-
 drivers/usb/core/quirks.c                          |   7 +
 drivers/usb/dwc3/gadget.c                          | 107 ++++++++--
 drivers/usb/gadget/function/f_ncm.c                |  81 ++++++--
 drivers/usb/gadget/function/f_tcm.c                |   7 +-
 drivers/usb/gadget/u_f.h                           |  38 ++--
 drivers/usb/host/ohci-exynos.c                     |   5 +-
 drivers/usb/host/xhci-debugfs.c                    |   8 +-
 drivers/usb/host/xhci-hub.c                        |  19 +-
 drivers/usb/host/xhci-pci-renesas.c                |  19 +-
 drivers/usb/host/xhci-tegra.c                      |   4 +-
 drivers/usb/host/xhci.c                            |   3 +-
 drivers/usb/misc/lvstest.c                         |   2 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |   2 +-
 drivers/usb/misc/yurex.c                           |   2 +-
 drivers/usb/storage/unusual_devs.h                 |   2 +-
 drivers/usb/storage/unusual_uas.h                  |  14 ++
 drivers/usb/typec/tcpm/tcpm.c                      |  28 ++-
 drivers/usb/typec/ucsi/displayport.c               |   9 +-
 drivers/usb/typec/ucsi/ucsi.c                      | 103 +++++-----
 drivers/usb/usbip/stub_dev.c                       |   6 +
 drivers/vdpa/ifcvf/ifcvf_base.h                    |   2 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |   9 +-
 drivers/video/fbdev/controlfb.c                    |   2 +
 drivers/video/fbdev/core/fbcon.c                   |  25 ++-
 drivers/video/fbdev/core/fbmem.c                   |   8 +-
 drivers/video/fbdev/core/fbsysfs.c                 |   4 +-
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c       |   7 +-
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c         |   7 +-
 drivers/video/fbdev/omap2/omapfb/dss/dss.c         |   7 +-
 drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c       |   5 +-
 drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c       |   5 +-
 drivers/video/fbdev/omap2/omapfb/dss/venc.c        |   7 +-
 drivers/video/fbdev/ps3fb.c                        |   5 +-
 drivers/xen/events/events_base.c                   |  16 +-
 fs/btrfs/ctree.h                                   |   4 +-
 fs/btrfs/disk-io.c                                 |   1 +
 fs/btrfs/extent-tree.c                             |  17 +-
 fs/btrfs/file.c                                    |  10 +-
 fs/btrfs/free-space-cache.c                        |   2 +-
 fs/btrfs/inode.c                                   |  18 +-
 fs/btrfs/qgroup.c                                  |  14 +-
 fs/btrfs/qgroup.h                                  |   2 +-
 fs/btrfs/super.c                                   |   1 +
 fs/btrfs/tree-log.c                                |  10 +-
 fs/buffer.c                                        |   9 +
 fs/ceph/file.c                                     |   5 +-
 fs/ceph/mds_client.c                               |  14 +-
 fs/ext4/block_validity.c                           |   8 -
 fs/ext4/ext4.h                                     |   7 +-
 fs/ext4/ext4_jbd2.c                                |  25 +++
 fs/ext4/extents.c                                  |  10 +-
 fs/ext4/file.c                                     |   2 +-
 fs/ext4/indirect.c                                 |   2 +-
 fs/ext4/inode.c                                    |   6 +-
 fs/ext4/ioctl.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |  95 ++++++++-
 fs/ext4/mballoc.h                                  |   4 +
 fs/ext4/move_extent.c                              |   4 +-
 fs/ext4/super.c                                    | 195 ++++++++++++------
 fs/ext4/sysfs.c                                    |   2 +
 fs/f2fs/f2fs.h                                     |   4 +-
 fs/f2fs/inline.c                                   |  19 +-
 fs/f2fs/node.c                                     |   6 +-
 fs/f2fs/recovery.c                                 |  10 +-
 fs/f2fs/super.c                                    |   5 +-
 fs/f2fs/sysfs.c                                    |   9 +-
 fs/fs-writeback.c                                  |  83 ++++----
 fs/hugetlbfs/inode.c                               |   6 +
 fs/io-wq.c                                         |  21 +-
 fs/io_uring.c                                      |  40 +++-
 fs/jbd2/transaction.c                              |  26 +++
 fs/nfsd/nfs4state.c                                |   2 +
 fs/xfs/libxfs/xfs_trans_inode.c                    |   2 +
 fs/xfs/xfs_icache.c                                |   3 +-
 fs/xfs/xfs_inode.c                                 |  25 ++-
 include/drm/drm_modeset_lock.h                     |   9 +-
 include/linux/dma-direct.h                         |   3 -
 include/linux/dma-mapping.h                        |   5 +-
 include/linux/efi.h                                |   4 +
 include/linux/fb.h                                 |   2 -
 include/linux/fs.h                                 |   8 +-
 include/linux/netfilter_ipv6.h                     |  18 --
 include/trace/events/ext4.h                        |  17 +-
 include/trace/events/writeback.h                   |  13 +-
 kernel/Makefile                                    |   1 +
 kernel/bpf/bpf_iter.c                              |  15 +-
 kernel/bpf/task_iter.c                             |   3 +-
 kernel/dma/direct.c                                |  13 +-
 kernel/dma/pool.c                                  | 147 +++++++-------
 kernel/irq/matrix.c                                |   7 +
 kernel/locking/lockdep_proc.c                      |   2 +-
 kernel/trace/blktrace.c                            |  12 ++
 mm/khugepaged.c                                    |   5 +-
 mm/page_counter.c                                  |  13 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   8 +-
 net/can/j1939/transport.c                          |  15 +-
 net/ipv6/netfilter.c                               |   3 -
 net/netfilter/nf_tables_api.c                      |  16 +-
 net/openvswitch/datapath.c                         |  10 +-
 net/openvswitch/flow_table.c                       |  35 ++--
 net/openvswitch/flow_table.h                       |   3 +
 sound/pci/cs46xx/cs46xx_lib.c                      |   2 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |   2 +-
 sound/pci/hda/hda_codec.c                          |   2 +-
 sound/pci/hda/hda_generic.c                        |   2 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_hdmi.c                         |  17 +-
 sound/pci/hda/patch_realtek.c                      |  12 ++
 sound/pci/hda/patch_sigmatel.c                     |   2 +-
 sound/pci/ice1712/prodigy192.c                     |   2 +-
 sound/pci/oxygen/xonar_dg.c                        |   2 +-
 sound/soc/codecs/wm8958-dsp2.c                     |   4 +
 sound/soc/img/img-i2s-in.c                         |   4 +-
 sound/soc/img/img-parallel-out.c                   |   4 +-
 sound/soc/intel/boards/skl_hda_dsp_common.h        |   1 +
 sound/soc/intel/boards/skl_hda_dsp_generic.c       |  17 +-
 sound/soc/intel/boards/sof_sdw.c                   |   1 +
 sound/soc/intel/boards/sof_sdw_common.h            |   1 +
 sound/soc/intel/boards/sof_sdw_rt711.c             |  15 ++
 sound/soc/tegra/tegra30_ahub.c                     |   4 +-
 sound/soc/tegra/tegra30_i2s.c                      |   4 +-
 sound/usb/mixer.c                                  |   8 +-
 sound/usb/quirks-table.h                           |  34 +++-
 tools/bpf/bpftool/btf_dumper.c                     |   2 +-
 tools/bpf/bpftool/link.c                           |   4 +-
 tools/bpf/bpftool/main.h                           |  10 +-
 tools/bpf/bpftool/prog.c                           |  16 +-
 tools/lib/bpf/libbpf.c                             |  14 +-
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |   8 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |  27 ++-
 .../testing/selftests/bpf/prog_tests/core_extern.c |   4 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  20 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   6 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   2 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |   6 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c      |  19 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c      |   2 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   2 +-
 .../selftests/bpf/prog_tests/test_global_funcs.c   |   2 +-
 .../testing/selftests/bpf/progs/core_reloc_types.h |  69 ++++---
 tools/testing/selftests/bpf/test_btf.c             |   8 +-
 tools/testing/selftests/bpf/test_progs.h           |   5 +
 tools/testing/selftests/net/icmp_redirect.sh       |   2 +
 .../powerpc/pmu/ebb/back_to_back_ebbs_test.c       |   2 -
 .../selftests/powerpc/pmu/ebb/cycles_test.c        |   2 -
 .../powerpc/pmu/ebb/cycles_with_freeze_test.c      |   2 -
 .../powerpc/pmu/ebb/cycles_with_mmcr2_test.c       |   2 -
 tools/testing/selftests/powerpc/pmu/ebb/ebb.c      |   2 -
 .../powerpc/pmu/ebb/ebb_on_willing_child_test.c    |   2 -
 .../powerpc/pmu/ebb/lost_exception_test.c          |   1 -
 .../selftests/powerpc/pmu/ebb/multi_counter_test.c |   7 -
 .../powerpc/pmu/ebb/multi_ebb_procs_test.c         |   2 -
 .../selftests/powerpc/pmu/ebb/pmae_handling_test.c |   2 -
 .../powerpc/pmu/ebb/pmc56_overflow_test.c          |   2 -
 313 files changed, 2870 insertions(+), 1352 deletions(-)


