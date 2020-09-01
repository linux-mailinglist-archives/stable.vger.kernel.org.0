Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D822599B1
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgIAQms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbgIAP14 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:27:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B573B214D8;
        Tue,  1 Sep 2020 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974073;
        bh=1LnbpdLigCPqmJDL6CwLPzW5LzCZoJlpMlI9X3QD23Y=;
        h=From:To:Cc:Subject:Date:From;
        b=Y0MgdK93N5tZ01Z779z+o/WkXGflH755/dJDaxMDR6L8Yry4VUvP87UwO5hM8gql6
         qKEApZUVLR0t9vspqqsN/aogSzy1sIc3ErTyQBox4lTCTvFzSegvXJR2uCo/Yieic7
         W7ETeyB9uNl/3HNHV/TG4SRcyprBhVFq3BH93VQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/214] 5.4.62-rc1 review
Date:   Tue,  1 Sep 2020 17:08:00 +0200
Message-Id: <20200901150952.963606936@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.62-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.62-rc1
X-KernelTest-Deadline: 2020-09-03T15:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.62 release.
There are 214 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.62-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.62-rc1

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: Update documentation comment for MS2109 quirk

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix build on ppc64le architecture

Peilin Ye <yepeilin.cs@gmail.com>
    HID: hiddev: Fix slab-out-of-bounds write in hiddev_ioctl_usage()

Denis Efremov <efremov@linux.com>
    kbuild: fix broken builds because of GZIP,BZIP2,LZOP variables

Denis Efremov <efremov@linux.com>
    kbuild: add variables for compression tools

Masahiro Yamada <yamada.masahiro@socionext.com>
    kheaders: explain why include/config/autoconf.h is excluded from md5sum

Masahiro Yamada <yamada.masahiro@socionext.com>
    kheaders: remove the last bashism to allow sh to run it

Masahiro Yamada <yamada.masahiro@socionext.com>
    kheaders: optimize header copy for in-tree builds

Masahiro Yamada <yamada.masahiro@socionext.com>
    kheaders: optimize md5sum calculation for in-tree builds

Masahiro Yamada <yamada.masahiro@socionext.com>
    kheaders: remove unneeded 'cat' command piped to 'head' / 'tail'

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    fbmem: pull fbcon_update_vcs() out of fb_set_var()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Handle ZLP for sg requests

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix handling ZLP

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't setup more than requested

Mika Kuoppala <mika.kuoppala@linux.intel.com>
    drm/i915: Fix cmd parser desc matching with masks

Alan Stern <stern@rowland.harvard.edu>
    usb: storage: Add unusual_uas entry for Sony PSZ drives

Tom Rix <trix@redhat.com>
    USB: cdc-acm: rework notification_buffer resizing

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Fix buffer overflow in INFO ioctl

Ashok Raj <ashok.raj@intel.com>
    x86/hotplug: Silence APIC only after all interrupts are migrated

qiuguorui1 <qiuguorui1@huawei.com>
    irqchip/stm32-exti: Avoid losing interrupts due to clearing pending bits by mistake

Thomas Gleixner <tglx@linutronix.de>
    genirq/matrix: Deal with the sillyness of for_each_cpu() on UP

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Work around empty control messages without MSG_MORE

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    device property: Fix the secondary firmware node handling in set_primary_fwnode()

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/perf: Fix crashes with generic_compat_pmu & BHRB

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Fix the handling of pending runtime resume requests

Frank van der Linden <fllinden@amazon.com>
    arm64: vdso32: make vdso32 install conditional

Ding Hui <dinghui@sangfor.com.cn>
    xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Do warm-reset when both CAS and XDEV_RESUME are set

Li Jun <jun.li@nxp.com>
    usb: host: xhci: fix ep context print mismatch in debugfs

Thomas Gleixner <tglx@linutronix.de>
    XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.

Jan Kara <jack@suse.cz>
    writeback: Fix sync livelock due to b_dirty_time processing

Jan Kara <jack@suse.cz>
    writeback: Avoid skipping inode writeback

Jan Kara <jack@suse.cz>
    writeback: Protect inode->i_io_list with inode->i_lock

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

Marc Zyngier <maz@kernel.org>
    arm64: Allow booting of late CPUs affected by erratum 1418040

Marc Zyngier <maz@kernel.org>
    arm64: Move handling of erratum 1418040 into C code

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix soft lockups due to missed interrupt accounting

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

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: wm8994: Avoid attempts to read unreadable registers

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: add cond_resched() in the slow_eval_known_fn() loop

Mike Pozulp <pozulp.kernel@gmail.com>
    ALSA: hda/realtek: Add model alc298-samsung-headphone

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: transport: j1939_xtp_rx_dat_one(): compare own packets to detect corruptions

Florian Westphal <fw@strlen.de>
    netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency

Jean-Philippe Brucker <jean-philippe@linaro.org>
    libbpf: Handle GCC built-in types for Arm NEON

Anthony Koo <Anthony.Koo@amd.com>
    drm/amd/display: Switch to immediate mode for updating infopackets

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

Lukas Czerner <lczerner@redhat.com>
    ext4: handle read only external journal device

Jan Kara <jack@suse.cz>
    ext4: don't BUG on inconsistent journal feature

Lukas Czerner <lczerner@redhat.com>
    jbd2: make sure jh have b_transaction set in refile/unfile_buffer

Tobias Schramm <t.schramm@manjaro.org>
    spi: stm32: clear only asserted irq flags on interrupt

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: f_tcm: Fix some resource leaks in some error paths

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: in slave mode, clear NACK earlier

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: core: Don't fail PRP0001 enumeration when no ID table exist

Hou Pu <houpu@bytedance.com>
    null_blk: fix passing of REQ_FUA flag in null_handle_rq

Martin Wilck <mwilck@suse.com>
    nvme: multipath: round-robin: fix single non-optimized path case

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    nvme-fc: Fix wrong return value in __nvme_fc_init_request()

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

Sean Young <sean@mess.org>
    media: gpio-ir-tx: improve precision of transmitted signal due to scheduling

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add capture support for Saffire 6 (USB 1.1)

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fix EPP setting via sysfs in active mode

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Add missing reset for ipq806x

Abhishek Sahu <absahu@codeaurora.org>
    PCI: qcom: Change duplicate PCI reset to phy reset

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Add missing ipq806x clocks in PCIe driver

Tony Luck <tony.luck@intel.com>
    EDAC/{i7core,sb,pnd2,skx}: Fix error event severity

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    EDAC: skx_common: get rid of unused type var

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    EDAC: sb_edac: get rid of unused vars

Sasha Levin <sashal@kernel.org>
    mm/vunmap: add cond_resched() in vunmap_pmd_range

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix dmesg warning from setting abm level

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Add additional config guards for DCN

Mikita Lipski <mikita.lipski@amd.com>
    drm/amd/display: Trigger modesets on MST DSC connectors

Paul Cercueil <paul@crapouillou.net>
    drm/ingenic: Fix incorrect assumption about plane->index

Paul Cercueil <paul@crapouillou.net>
    gpu/drm: ingenic: Use the plane's src_[x,y] to configure DMA length

Mike Kravetz <mike.kravetz@oracle.com>
    cma: don't quit at first error when activating reserved areas

Yunfeng Ye <yeyunfeng@huawei.com>
    mm/cma.c: switch to bitmap_zalloc() for cma bitmap allocation

Peter Zijlstra <peterz@infradead.org>
    mm: fix kthread_use_mm() vs TLB invalidate

David Hildenbrand <david@redhat.com>
    mm/shuffle: don't move pages between zones and don't read garbage memmaps

Filipe Manana <fdmanana@suse.com>
    btrfs: only commit delayed items at fsync if we are logging a directory

Filipe Manana <fdmanana@suse.com>
    btrfs: only commit the delayed inode when doing a full fsync

Filipe Manana <fdmanana@suse.com>
    btrfs: factor out inode items copy loop from btrfs_log_inode()

Sasha Levin <sashal@kernel.org>
    s390/numa: set node distance to LOCAL_DISTANCE

Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
    drm/xen-front: Fix misused IS_ERR_OR_NULL checks

Ding Xiang <dingxiang@cmss.chinamobile.com>
    drm/xen: fix passing zero to 'PTR_ERR' warning

Marc Zyngier <maz@kernel.org>
    PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent

Yangtao Li <tiny.windzz@gmail.com>
    PM / devfreq: rk3399_dmc: Disable devfreq-event device when fails

Yangtao Li <tiny.windzz@gmail.com>
    PM / devfreq: rk3399_dmc: Add missing of_node_put()

Sasha Levin <sashal@kernel.org>
    usb: cdns3: gadget: always zeroed TRB buffer when enable endpoint

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix a deadlock when enabling uclamp static key

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Protect uclamp fast path code with static key

Zhi Chen <zhichen@codeaurora.org>
    Revert "ath10k: fix DMA related firmware crashes on multiple devices"

Kefeng Wang <wangkefeng.wang@huawei.com>
    arm64: Fix __cpu_logical_map undefined issue

Andrey Konovalov <andreyknvl@google.com>
    efi: provide empty efi_enter_virtual_mode implementation

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    brcmfmac: Set timeout value when configuring power save

Changming Liu <charley.ashbringer@gmail.com>
    USB: sisusbvga: Fix a potential UB casued by left shifting a negative value

Arnd Bergmann <arnd@arndb.de>
    powerpc/spufs: add CONFIG_COREDUMP dependency

David Brazdil <dbrazdil@google.com>
    KVM: arm64: Fix symbol dependency in __hyp_call_panic_nvhe

Evgeny Novikov <novikov@ispras.ru>
    media: davinci: vpif_capture: fix potential double free

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: prevent filesystem stacking of hugetlbfs

Jason Baron <jbaron@akamai.com>
    EDAC/ie31200: Fallback if host bridge device is already initialized

Javed Hasan <jhasan@marvell.com>
    scsi: fcoe: Memory leak fix in fcoe_sysfs_fcf_del()

Xiubo Li <xiubli@redhat.com>
    ceph: do not access the kiocb after aio requests

Xiubo Li <xiubli@redhat.com>
    ceph: fix potential mdsc use-after-free crash

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

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    cec-api: prevent leaking memory through hole in structure

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

Chao Yu <chao@kernel.org>
    f2fs: fix error path in do_recover_data()

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    selftests/powerpc: Purge extra count_pmc() calls of ebb selftests

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix xcopy sess release leak

Dave Chinner <dchinner@redhat.com>
    xfs: Don't allow logging of XFS_ISTALE inodes

Dick Kennedy <dick.kennedy@broadcom.com>
    scsi: lpfc: Fix shost refcount mismatch when deleting vport

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

Robin Murphy <robin.murphy@arm.com>
    iommu/iova: Don't BUG on invalid PFNs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Add Intel Tiger Lake PCH-H PCI IDs

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Fix crash on ARM during cmd completion

Luis Chamberlain <mcgrof@kernel.org>
    blktrace: ensure our debugfs dir exists

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

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/hdmi: Use force connectivity quirk on another HP desktop

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Fix pin default on Intel NUC 8 Rugged

Randy Dunlap <rdunlap@infradead.org>
    ALSA: pci: delete repeated words in comments

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/hdmi: Add quirk to force connectivity

Mahesh Bandewar <maheshb@google.com>
    ipvlan: fix device features

Alaa Hleihel <alaa@mellanox.com>
    net/sched: act_ct: Fix skb double-free in tcf_ct_handle_fragments() error flow

Shay Agroskin <shayagr@amazon.com>
    net: ena: Make missed_tx stat incremental

Cong Wang <xiyou.wangcong@gmail.com>
    tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

Peilin Ye <yepeilin.cs@gmail.com>
    net/smc: Prevent kernel-infoleak in __smc_diag_dump()

David Laight <David.Laight@ACULAB.COM>
    net: sctp: Fix negotiation of the number of data streams.

Necip Fazil Yildiran <necip@google.com>
    net: qrtr: fix usage of idr in port assignment to socket

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: nexthop: don't allow empty NHA_GROUP

Miaohe Lin <linmiaohe@huawei.com>
    net: Fix potential wrong skb->protocol in skb_vlan_untag()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY

Max Filippov <jcmvbkbc@gmail.com>
    binfmt_flat: revert "binfmt_flat: don't offset the data start"

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Don't init FSCR_DSCR in __init_FSCR()


-------------

Diffstat:

 Makefile                                           |  15 +-
 arch/arm/boot/deflate_xip_data.sh                  |   2 +-
 arch/arm/boot/dts/ls1021a.dtsi                     |   2 +-
 arch/arm64/Makefile                                |   3 +-
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi         |   2 +-
 arch/arm64/include/asm/smp.h                       |   7 +-
 arch/arm64/kernel/cpu_errata.c                     |   2 +
 arch/arm64/kernel/process.c                        |  34 +++
 arch/arm64/kernel/setup.c                          |   8 +-
 arch/arm64/kernel/smp.c                            |   6 +-
 arch/arm64/kvm/hyp/switch.c                        |   2 +-
 arch/ia64/Makefile                                 |   2 +-
 arch/m68k/Makefile                                 |   8 +-
 arch/mips/vdso/genvdso.c                           |  10 +
 arch/parisc/Makefile                               |   2 +-
 arch/powerpc/kernel/cpu_setup_power.S              |   2 +-
 arch/powerpc/perf/core-book3s.c                    |  23 +-
 arch/powerpc/platforms/cell/Kconfig                |   1 +
 arch/powerpc/sysdev/xive/native.c                  |   2 +
 arch/s390/include/asm/numa.h                       |   1 -
 arch/s390/include/asm/topology.h                   |   2 -
 arch/s390/numa/numa.c                              |   6 -
 arch/x86/kernel/smpboot.c                          |  26 +-
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
 drivers/block/loop.c                               |  33 ++-
 drivers/block/null_blk_main.c                      |   2 +-
 drivers/block/virtio_blk.c                         |  31 ++-
 drivers/cpufreq/intel_pstate.c                     |  18 +-
 drivers/devfreq/rk3399_dmc.c                       |  51 ++--
 drivers/edac/i7core_edac.c                         |   4 +-
 drivers/edac/ie31200_edac.c                        |  50 +++-
 drivers/edac/pnd2_edac.c                           |   2 +-
 drivers/edac/sb_edac.c                             |  25 +-
 drivers/edac/skx_common.c                          |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |  20 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  58 ++++
 .../amd/display/dc/dcn10/dcn10_stream_encoder.c    |  16 +-
 .../amd/display/dc/dcn10/dcn10_stream_encoder.h    |  14 +
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c  |   9 +-
 .../gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c   |  22 +-
 .../gpu/drm/amd/powerplay/hwmgr/vega12_thermal.c   |  21 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c |  44 ++-
 .../gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c   |  21 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c             |  14 +-
 drivers/gpu/drm/ingenic/ingenic-drm.c              |   6 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  20 +-
 drivers/gpu/drm/xen/xen_drm_front.c                |   2 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c            |   8 +-
 drivers/gpu/drm/xen/xen_drm_front_kms.c            |   2 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  22 +-
 drivers/hid/usbhid/hiddev.c                        |   4 +
 drivers/hwmon/nct7904.c                            |   4 +-
 drivers/i2c/busses/i2c-rcar.c                      |   1 +
 drivers/i2c/i2c-core-base.c                        |   2 +-
 drivers/iommu/iova.c                               |   4 +-
 drivers/irqchip/irq-stm32-exti.c                   |  14 +-
 drivers/media/cec/cec-api.c                        |   8 +-
 drivers/media/pci/ttpci/av7110.c                   |   5 +-
 drivers/media/platform/davinci/vpif_capture.c      |   2 -
 drivers/media/rc/gpio-ir-tx.c                      |   7 +-
 drivers/mfd/intel-lpss-pci.c                       |  19 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   5 +-
 drivers/net/ethernet/freescale/gianfar.c           |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |   2 +-
 drivers/net/ipvlan/ipvlan_main.c                   |  27 +-
 drivers/net/macvlan.c                              |  21 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   8 +
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   5 +-
 drivers/nvme/host/fc.c                             |   4 +-
 drivers/nvme/host/multipath.c                      |  15 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |  58 +++-
 drivers/pci/slot.c                                 |   6 +-
 drivers/s390/cio/css.c                             |   5 +
 drivers/scsi/fcoe/fcoe_ctlr.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |  26 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  18 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   8 -
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +
 drivers/scsi/qla2xxx/qla_os.c                      |   5 +
 drivers/scsi/qla2xxx/qla_target.c                  |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  14 +-
 drivers/spi/spi-stm32.c                            |  73 ++---
 drivers/target/target_core_internal.h              |   1 +
 drivers/target/target_core_transport.c             |   7 +-
 drivers/target/target_core_user.c                  |   9 +-
 drivers/target/target_core_xcopy.c                 |  11 +-
 drivers/tty/serial/8250/8250_exar.c                |  24 +-
 drivers/tty/serial/8250/8250_port.c                |   9 +-
 drivers/tty/serial/amba-pl011.c                    |  16 +-
 drivers/tty/serial/samsung.c                       |   8 +-
 drivers/tty/serial/stm32-usart.c                   |   2 +-
 drivers/tty/vt/vt.c                                |   5 +-
 drivers/tty/vt/vt_ioctl.c                          |  12 +-
 drivers/usb/cdns3/gadget.c                         |   4 +-
 drivers/usb/class/cdc-acm.c                        |  22 +-
 drivers/usb/core/quirks.c                          |   7 +
 drivers/usb/dwc3/gadget.c                          | 104 +++++--
 drivers/usb/gadget/function/f_ncm.c                |  81 +++++-
 drivers/usb/gadget/function/f_tcm.c                |   7 +-
 drivers/usb/gadget/u_f.h                           |  38 ++-
 drivers/usb/host/ohci-exynos.c                     |   5 +-
 drivers/usb/host/xhci-debugfs.c                    |   8 +-
 drivers/usb/host/xhci-hub.c                        |  19 +-
 drivers/usb/host/xhci.c                            |   3 +-
 drivers/usb/misc/lvstest.c                         |   2 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |   2 +-
 drivers/usb/misc/yurex.c                           |   2 +-
 drivers/usb/storage/unusual_devs.h                 |   2 +-
 drivers/usb/storage/unusual_uas.h                  |  14 +
 drivers/video/fbdev/core/fbcon.c                   |  25 +-
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
 fs/binfmt_flat.c                                   |  20 +-
 fs/btrfs/ctree.h                                   |   4 +-
 fs/btrfs/disk-io.c                                 |   1 +
 fs/btrfs/extent-tree.c                             |  17 +-
 fs/btrfs/file.c                                    |  10 +-
 fs/btrfs/free-space-cache.c                        |   2 +-
 fs/btrfs/inode.c                                   |  18 +-
 fs/btrfs/qgroup.c                                  |  14 +-
 fs/btrfs/qgroup.h                                  |   2 +-
 fs/btrfs/super.c                                   |   1 +
 fs/btrfs/tree-log.c                                | 305 +++++++++++----------
 fs/buffer.c                                        |   9 +
 fs/ceph/file.c                                     |   5 +-
 fs/ceph/mds_client.c                               |  14 +-
 fs/ext4/block_validity.c                           |   8 -
 fs/ext4/super.c                                    | 175 ++++++++----
 fs/f2fs/f2fs.h                                     |   4 +-
 fs/f2fs/inline.c                                   |  19 +-
 fs/f2fs/node.c                                     |   6 +-
 fs/f2fs/recovery.c                                 |  10 +-
 fs/f2fs/super.c                                    |   5 +-
 fs/fs-writeback.c                                  |  83 +++---
 fs/hugetlbfs/inode.c                               |   6 +
 fs/jbd2/transaction.c                              |  26 ++
 fs/xfs/libxfs/xfs_trans_inode.c                    |   2 +
 fs/xfs/xfs_icache.c                                |   3 +-
 fs/xfs/xfs_inode.c                                 |  25 +-
 include/linux/efi.h                                |   4 +
 include/linux/fb.h                                 |   2 -
 include/linux/fs.h                                 |   8 +-
 include/linux/netfilter_ipv6.h                     |  18 --
 include/trace/events/writeback.h                   |  13 +-
 kernel/Makefile                                    |   2 +-
 kernel/gen_kheaders.sh                             |  66 +++--
 kernel/irq/matrix.c                                |   7 +
 kernel/locking/lockdep_proc.c                      |   2 +-
 kernel/sched/core.c                                |  81 +++++-
 kernel/sched/cpufreq_schedutil.c                   |   2 +-
 kernel/sched/sched.h                               |  47 +++-
 kernel/trace/blktrace.c                            |  12 +
 mm/cma.c                                           |  29 +-
 mm/mmu_context.c                                   |   7 +-
 mm/shuffle.c                                       |  18 +-
 mm/vmalloc.c                                       |   2 +
 net/bridge/netfilter/nf_conntrack_bridge.c         |   8 +-
 net/can/j1939/transport.c                          |  15 +-
 net/core/skbuff.c                                  |   4 +-
 net/ipv4/nexthop.c                                 |   5 +-
 net/ipv6/ip6_tunnel.c                              |  10 +-
 net/ipv6/netfilter.c                               |   3 -
 net/qrtr/qrtr.c                                    |  20 +-
 net/sched/act_ct.c                                 |   2 +-
 net/sctp/stream.c                                  |   6 +-
 net/smc/smc_diag.c                                 |  16 +-
 net/tipc/netlink_compat.c                          |  12 +-
 scripts/Makefile.lib                               |  12 +-
 scripts/Makefile.package                           |   8 +-
 scripts/package/buildtar                           |   6 +-
 scripts/xz_wrap.sh                                 |   2 +-
 sound/pci/cs46xx/cs46xx_lib.c                      |   2 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |   2 +-
 sound/pci/hda/hda_codec.c                          |   2 +-
 sound/pci/hda/hda_generic.c                        |   2 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_hdmi.c                         |  17 +-
 sound/pci/hda/patch_realtek.c                      |  12 +
 sound/pci/hda/patch_sigmatel.c                     |   2 +-
 sound/pci/ice1712/prodigy192.c                     |   2 +-
 sound/pci/oxygen/xonar_dg.c                        |   2 +-
 sound/soc/codecs/wm8958-dsp2.c                     |   4 +
 sound/soc/img/img-i2s-in.c                         |   4 +-
 sound/soc/img/img-parallel-out.c                   |   4 +-
 sound/soc/tegra/tegra30_ahub.c                     |   4 +-
 sound/soc/tegra/tegra30_i2s.c                      |   4 +-
 sound/usb/quirks-table.h                           |  34 ++-
 tools/lib/bpf/btf_dump.c                           |  35 ++-
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
 231 files changed, 2150 insertions(+), 1015 deletions(-)


