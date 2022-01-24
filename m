Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AADF49919A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348630AbiAXUM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:12:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50618 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379013AbiAXUKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:10:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EC2EB81215;
        Mon, 24 Jan 2022 20:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E45FC340E7;
        Mon, 24 Jan 2022 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055009;
        bh=72GQvJnnud8+8sqRFEbQYDu65wkMokSx7USxMu3MDRk=;
        h=From:To:Cc:Subject:Date:From;
        b=rhMbLZIRgyYT1Ecqh/vvuxAMFpE+424q4E/tV9b8tjz4M0fP5cQFJxRq5uO45sowP
         I5aQPDJMrnQ+VeODm+TIJQyMebxI40Cm8LQaqdIWl0lIA7bKI9QA58JuHZ/du0/Ua9
         dD65VFdMu9y3zsNvmt7SevGwqLUfs4u96dAabKqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: [PATCH 5.15 000/846] 5.15.17-rc1 review
Date:   Mon, 24 Jan 2022 19:31:57 +0100
Message-Id: <20220124184100.867127425@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.17-rc1
X-KernelTest-Deadline: 2022-01-26T18:41+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.17 release.
There are 846 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.17-rc1

Andrey Konovalov <andreyknvl@gmail.com>
    lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test

Moshe Tal <moshet@nvidia.com>
    bonding: Fix extraction of ports from the packet headers

Alistair Popple <apopple@nvidia.com>
    mm/hmm.c: allow VM_MIXEDMAP to work with hmm_range_fault

Miaoqian Lin <linmq006@gmail.com>
    lib82596: Fix IRQ check in sni_82596_probe

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    scripts/dtc: dtx_diff: remove broken example from help text

Maxim Mikityanskiy <maximmi@nvidia.com>
    sch_api: Don't skip qdisc attach on ingress

Sam Protsenko <semen.protsenko@linaro.org>
    dt-bindings: watchdog: Require samsung,syscon-phandle for Exynos7

Alexander Stein <alexander.stein@mailbox.org>
    dt-bindings: display: meson-vpu: Add missing amlogic,canvas property

Alexander Stein <alexander.stein@mailbox.org>
    dt-bindings: display: meson-dw-hdmi: add missing sound-name-prefix property

Tom Rix <trix@redhat.com>
    net: mscc: ocelot: fix using match before it is set

Claudiu Beznea <claudiu.beznea@microchip.com>
    net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices

Ard Biesheuvel <ardb@kernel.org>
    net: cpsw: avoid alignment faults by taking NET_IP_ALIGN into account

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: sfp: fix high power modules without diagnostic monitoring

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: ocelot: Fix the call to switchdev_bridge_port_offload

Tom Rix <trix@redhat.com>
    net: ethernet: mtk_eth_soc: fix error checking in mtk_mac_config()

Slark Xiao <slark_xiao@163.com>
    net: wwan: Fix MRU mismatch issue which may lead to data connection lost

Sergey Shtylyov <s.shtylyov@omp.ru>
    bcmgenet: add WOL IRQ check

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: don't let phylink re-enable TX PAUSE on the NPI port

Kevin Bracey <kevin@bracey.fi>
    net_sched: restore "mpu xxx" handling

Alex Elder <elder@linaro.org>
    net: ipa: fix atomic update in ipa_endpoint_replenish()

Jie Wang <wangjie125@huawei.com>
    net: bonding: fix bond_xmit_broadcast return value error bug

Miroslav Lichvar <mlichvar@redhat.com>
    net: fix sock_timestamping_bind_phc() to release device

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: msm8996: drop not documented adreno properties

Leon Romanovsky <leon@kernel.org>
    devlink: Remove misleading internal_flags from health reporter dump

Zechuan Chen <chenzechuan1@huawei.com>
    perf probe: Fix ppc64 'perf probe add events failed' case

Uwe Kleine-König <uwe@kleine-koenig.org>
    perf tools: Drop requirement for libstdc++.so for libopencsd check

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Fix at_xdmac_lld struct definition

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Fix lld view setting

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Fix concurrency over xfers_list

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Print debug message after realeasing the lock

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Start transfer for cyclic channels in issue_pending

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Don't start transactions at tx_submit level

Adrian Hunter <adrian.hunter@intel.com>
    perf script: Fix hex dump character output

Guillaume Nault <gnault@redhat.com>
    libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()

Guillaume Nault <gnault@redhat.com>
    gre: Don't accidentally set RTO_ONLINK in gre_fill_metadata_dst()

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Restore cur_num_vqs in case of failure in change_num_qps()

Guillaume Nault <gnault@redhat.com>
    xfrm: Don't accidentally set RTO_ONLINK in decode_session4()

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix Bz NMI behaviour

Eric Dumazet <edumazet@google.com>
    netns: add schedule point in ops_exit_list()

Eric Dumazet <edumazet@google.com>
    inet: frags: annotate races around fqdir->dead and fqdir->high_thresh

Eric W. Biederman <ebiederm@xmission.com>
    taskstats: Cleanup the use of task->exit_code

Michael S. Tsirkin <mst@redhat.com>
    virtio_ring: mark ring unused on error

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix wrong configuration of virtio_version_1_0

Laurence de Bruxelles <lfdebrux@gmail.com>
    rtc: pxa: fix null pointer dereference

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: vivaldi: fix handling devices not using numbered reports

Johannes Berg <johannes.berg@intel.com>
    um: gitignore: Add kernel/capflags.c

Yury Norov <yury.norov@gmail.com>
    bitops: protect find_first_{,zero}_bit properly

Robert Hancock <robert.hancock@calian.com>
    net: axienet: increase default TX ring size to 128

Robert Hancock <robert.hancock@calian.com>
    net: axienet: fix for TX busy handling

Robert Hancock <robert.hancock@calian.com>
    net: axienet: fix number of TX ring slots for available check

Robert Hancock <robert.hancock@calian.com>
    net: axienet: Fix TX ring slot available check

Robert Hancock <robert.hancock@calian.com>
    net: axienet: limit minimum TX ring size

Robert Hancock <robert.hancock@calian.com>
    net: axienet: add missing memory barriers

Robert Hancock <robert.hancock@calian.com>
    net: axienet: reset core on initialization prior to MDIO access

Robert Hancock <robert.hancock@calian.com>
    net: axienet: Wait for PhyRstCmplt after core reset

Robert Hancock <robert.hancock@calian.com>
    net: axienet: increase reset timeout

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Fix hung_task when removing SMC-R devices

Miaoqian Lin <linmq006@gmail.com>
    gpio: idt3243x: Fix IRQ check in idt_gpio_probe

Miaoqian Lin <linmq006@gmail.com>
    gpio: mpc8xxx: Fix IRQ check in mpc8xxx_probe

John Keeping <john@metanate.com>
    pinctrl/rockchip: fix gpio device creation

Robert Hancock <robert.hancock@calian.com>
    clk: si5341: Fix clock HW provider cleanup

Stephen Boyd <sboyd@kernel.org>
    clk: Emit a stern warning with writable debugfs enabled

Eric Dumazet <edumazet@google.com>
    af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: octeontx2 - uninitialized variable in kvf_limits_store()

Chao Yu <chao@kernel.org>
    f2fs: fix to check available space of CP area correctly in update_ckpt_flags()

Chao Yu <chao@kernel.org>
    f2fs: fix to reserve space for IO align feature

Hyeong-Jun Kim <hj514.kim@samsung.com>
    f2fs: compress: fix potential deadlock of compress file

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid panic in is_alive() if metadata is inconsistent

Fengnan Chang <changfengnan@vivo.com>
    f2fs: fix remove page failed in invalidate compress pages

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Remove unused compile options

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Remove explicit transparent hugepages support

Geert Uytterhoeven <geert@linux-m68k.org>
    riscv: dts: microchip: mpfs: Drop empty chosen node

Miaoqian Lin <linmq006@gmail.com>
    parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries

Tobias Waldekranz <tobias@waldekranz.com>
    net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module

Tobias Waldekranz <tobias@waldekranz.com>
    net/fsl: xgmac_mdio: Add workaround for erratum A-009885

Guillaume Nault <gnault@redhat.com>
    mlx5: Don't accidentally set RTO_ONLINK before mlx5e_route_lookup_ipv4_get()

Eric Dumazet <edumazet@google.com>
    ipv4: avoid quadratic behavior in netns dismantle

Eric Dumazet <edumazet@google.com>
    ipv4: update fib_info_cnt under spinlock protection

German Gomez <german.gomez@arm.com>
    perf evsel: Override attr->sample_period for non-libpfm4 events

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Mark PTR_TO_FUNC register initially with zero offset

Yafang Shao <laoar.shao@gmail.com>
    bpf: Fix mount source show for bpffs

Toke Høiland-Jørgensen <toke@redhat.com>
    xdp: check prog type before updating BPF link

Quentin Monnet <quentin@isovalent.com>
    bpftool: Fix indent in option lists in the documentation

Quentin Monnet <quentin@isovalent.com>
    bpftool: Remove inclusion of utilities.mak from Makefiles

Russell King <russell.king@oracle.com>
    arm64/bpf: Remove 128MB limit for BPF JIT programs

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: crtc: Copy assigned channel to the CRTC

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: Fix non-blocking commit getting stuck forever

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: crtc: Drop feed_txp from state

Ye Bin <yebin10@huawei.com>
    block: Fix fsync always failed if once failed

Jens Axboe <axboe@kernel.dk>
    block: fix async_depth sysfs interface for mq-deadline

Tobias Waldekranz <tobias@waldekranz.com>
    powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses

Anders Roxell <anders.roxell@linaro.org>
    powerpc/cell: Fix clang -Wimplicit-fallthrough warning

Moshe Shemesh <moshe@nvidia.com>
    Revert "net/mlx5: Add retry mechanism to the command entry index allocation"

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-mdma: fix STM32_MDMA_CTBR_TSEL_MASK

Chengguang Xu <cgxu519@mykernel.net>
    RDMA/rxe: Fix a typo in opcode name

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Modify the mapping attribute of doorbell to device

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix wq settings post wq disable

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    dmaengine: uniphier-xdmac: Fix type of address variables

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cma: Remove open coding of overflow checking for private_data_len

Miaoqian Lin <linmq006@gmail.com>
    scsi: ufs: ufs-mediatek: Fix error checking in ufs_mtk_init_va09_pwr_ctrl()

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Show SCMD_LAST in text form

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix not setting adv set duration

Markus Reichl <m.reichl@fivetechno.de>
    net: usb: Correct reset handling of smsc95xx

Mark Chen <mark-yw.chen@mediatek.com>
    Bluetooth: btusb: Return error code when getting patch status failed

Randy Dunlap <rdunlap@infradead.org>
    Documentation: fix firewire.rst ABI file path error

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    Documentation, arch: Remove leftovers from CIFS_WEAK_PW_HASH

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    Documentation, arch: Remove leftovers from raw device

Sakari Ailus <sakari.ailus@linux.intel.com>
    Documentation: ACPI: Fix data node reference documentation

Daniel Thompson <daniel.thompson@linaro.org>
    Documentation: dmaengine: Correctly describe dmatest with channel unset

Mike Leach <mike.leach@linaro.org>
    Documentation: coresight: Fix documentation issue

Randy Dunlap <rdunlap@infradead.org>
    media: correct MEDIA_TEST_SUPPORT help text

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Make sure the device is powered with CEC

Suresh Udipi <sudipi@jp.adit-jv.com>
    media: rcar-csi2: Optimize the selection PHTW register

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_tef_obj_read(): fix typo in error message

Ben Hutchings <ben@decadent.org.uk>
    firmware: Update Kconfig help text for Google firmware

Baruch Siach <baruch@tkos.co.il>
    of: base: Improve argument length mismatch error

Christian König <christian.koenig@amd.com>
    drm/radeon: fix error handling in radeon_driver_open_kms

Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
    Revert "drm/amdgpu: Don't inherit GEM object VMAs in child process"

Aaron Ma <aaron.ma@canonical.com>
    ath11k: qmi: avoid error messages when dma allocation fails

Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
    tracing/osnoise: Properly unhook events if start_per_cpu_kthreads() fails

Theodore Ts'o <tytso@mit.edu>
    ext4: don't use the orphan list when migrating an inode

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix an use-after-free issue about data=journal writeback mode

Ye Bin <yebin10@huawei.com>
    ext4: fix null-ptr-deref in '__ext4_journal_ensure_credits'

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ext4: destroy ext4_fc_dentry_cachep kmemcache on module removal

Xin Yin <yinxin.x@bytedance.com>
    ext4: fast commit may miss tracking unwritten range during ftruncate

Xin Yin <yinxin.x@bytedance.com>
    ext4: use ext4_ext_remove_space() for fast commit replay delete range

Ye Bin <yebin10@huawei.com>
    ext4: Fix BUG_ON in ext4_bread when write quota data

Luís Henriques <lhenriques@suse.de>
    ext4: set csum seed in tmp inode while migrating to extents

Xin Yin <yinxin.x@bytedance.com>
    ext4: fix fast commit may miss tracking range for FALLOC_FL_ZERO_RANGE

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    ext4: initialize err_blk before calling __ext4_get_inode_loc

Chunguang Xu <brookxu@tencent.com>
    ext4: fix a possible ABBA deadlock due to busy PA

Jan Kara <jack@suse.cz>
    ext4: make sure quota gets properly shutdown on error

Jan Kara <jack@suse.cz>
    ext4: make sure to reset inode lockdep class when quota enabling fails

Filipe Manana <fdmanana@suse.com>
    btrfs: respect the max size in the header when activating swap file

Josef Bacik <josef@toxicpanda.com>
    btrfs: check the root node for uptodate before returning it

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock between quota enable and other quota operations

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: fix dflt policy check when there is no policy configured

Ghalem Boudour <ghalem.boudour@6wind.com>
    xfrm: fix policy lookup for ipv6 gre packets

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Set PCI_STATUS_CAP_LIST for PCIe device

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Correctly set PCIe capabilities

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Fix definitions of reserved bits

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Properly mark reserved PCIe bits in PCI config space

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Make expansion ROM Base Address register read-only

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Fix infinite loop in IRQ handler upon power fault

Hans de Goede <hdegoede@redhat.com>
    PCI: pciehp: Use down_read/write_nested(reset_lock) to fix lockdep errors

Rob Herring <robh@kernel.org>
    PCI: xgene: Fix IB window setup

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display/ehl: Update voltage swing table

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't do resets on APUs which don't support it

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix lpfc_force_rscn ndlp kref imbalance

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/radix: Fix huge vmap false positive

John David Anglin <dave.anglin@bell.net>
    parisc: Fix lpa and lpa_user defines

Brian Norris <briannorris@chromium.org>
    drm/bridge: analogix_dp: Make PSR-exit block less

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/kms/nv04: use vzalloc for nv04_display

Yizhuo Zhai <yzhai003@ucr.edu>
    drm/amd/display: Fix the uninitialized variable in enable_stream_features()

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: limit submit sizes

Dmitry Osipenko <digetx@gmail.com>
    drm/tegra: submit: Add missing pm_runtime_mark_last_busy()

Sakari Ailus <sakari.ailus@linux.intel.com>
    device property: Fix fwnode_graph_devcon_match() fwnode leak

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/mm: fix 2KB pgtable release race

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Increase the scan timeout guard to 30 seconds

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    remoteproc: imx_rproc: Fix a resource leak in the remove function

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have syscall trace events use trace_event_buffer_lock_reserve()

Xiangyang Zhang <xyz.sun.ok@gmail.com>
    tracing/kprobes: 'nmissed' not showed correctly for kretprobe

Andrey Ryabinin <arbn@yandex-team.com>
    sched/cpuacct: Fix user/system in shown cpuacct.usage*

Andrey Ryabinin <arbn@yandex-team.com>
    cputime, cpuacct: Include guest time in user time in cpuacct.stat

Lukas Wunner <lukas@wunner.de>
    serial: Fix incorrect rs485 polarity on uart open

Xie Yongji <xieyongji@bytedance.com>
    fuse: Pass correct lend value to filemap_write_and_wait_range()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    HID: magicmouse: Fix an error handling path in magicmouse_probe()

Xiao Ni <xni@redhat.com>
    md: Move alloc/free acct bioset in to personality

Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
    xen/gntdev: fix unmap notification order

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    spi: uniphier: Fix a bug that doesn't point to private data correctly

Dmitry Osipenko <digetx@gmail.com>
    mfd: tps65910: Set PWR_OFF bit during driver probe

Patrick Williams <patrick@stwcx.xyz>
    tpm: fix NPE on probe for missing device

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    tpm: fix potential NULL pointer access in tpm_del_char_device

Petr Cvachoucek <cvachoucek@gmail.com>
    ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers

Meng Li <Meng.Li@windriver.com>
    crypto: caam - replace this_cpu_ptr with raw_cpu_ptr

Marek Vasut <marex@denx.de>
    crypto: stm32/crc32 - Fix kernel BUG triggered in probe()

Heiner Kallweit <hkallweit1@gmail.com>
    crypto: omap-aes - Fix broken pm_runtime_and_get() usage

Zhu Lingshan <lingshan.zhu@intel.com>
    ifcvf/vDPA: fix misuse virtio-net device config size for blk dev

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    rpmsg: core: Clean up resources on announce_create failure.

Andrew Lunn <andrew@lunn.ch>
    udp6: Use Segment Routing Header for dest address if present

Andrew Lunn <andrew@lunn.ch>
    icmp: ICMPV6: Examine invoking packet for Segment Route Headers.

Andrew Lunn <andrew@lunn.ch>
    seg6: export get_srh() for ICMP handling

Conor Dooley <conor.dooley@microchip.com>
    mailbox: change mailbox-mpfs compatible string

Miaoqian Lin <linmq006@gmail.com>
    phy: mediatek: Fix missing check in mtk_mipi_tx_probe

Ohad Sharabi <osharabi@habana.ai>
    habanalabs: skip read fw errors if dynamic descriptor invalid

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: mediatek: mt8183: fix device_node leak

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: mediatek: mt8173: fix device_node leak

Chunfeng Yun <chunfeng.yun@mediatek.com>
    phy: phy-mtk-tphy: add support efuse setting

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: mediatek: mt8192-mt6359: fix device_node leak

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Fixes around reply request queues

Christoph Hellwig <hch@lst.de>
    scsi: sr: Don't use GFP_DMA

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    MIPS: Octeon: Fix build errors using clang

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Add a test of sigreturning to the kernel

Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
    i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v4: Disable redistributors' view of the VPE table at boot time

Ye Guojin <ye.guojin@zte.com.cn>
    MIPS: OCTEON: add put_device() after of_find_device_by_node()

Jan Kara <jack@suse.cz>
    udf: Fix error handling in udf_new_inode()

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: Fix inaccurate CPU state info in vmcore generated with panic

Hari Bathini <hbathini@linux.ibm.com>
    powerpc: handle kdump appropriately with crash_kexec_post_notifiers option

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    selftests/powerpc/spectre_v2: Return skip code when miss_percent is high

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/40x: Map 32Mbytes of memory at startup

Nathan Chancellor <nathan@kernel.org>
    MIPS: Loongson64: Use three arguments for slti

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Set upper limit of processed events

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Trigger SLI4 firmware dump before doing driver cleanup

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix leaked lpfc_dmabuf mbox allocations with NPIV

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Fix a kernel crash during shutdown

Stephan Gerhold <stephan@gerhold.net>
    interconnect: qcom: rpm: Prevent integer overflow in rate

Christoph Hellwig <hch@lst.de>
    dm: fix alloc_dax error handling in alloc_dev

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    nvmem: core: set size for sysfs bin file

Christophe Leroy <christophe.leroy@csgroup.eu>
    w1: Misuse of get_user()/put_user() reported by sparse

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/powermac: Add missing lockdep_register_key()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: gxbb: Fix the SDM_EN bit for MPLL0 on GXBB

Joakim Tjernlund <joakim.tjernlund@infinera.com>
    i2c: mpc: Correct I2C reset procedure

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING

Heiner Kallweit <hkallweit1@gmail.com>
    i2c: i801: Don't silently correct invalid transfer size

Ye Guojin <ye.guojin@zte.com.cn>
    ASoC: imx-hdmi: add put_device() after of_find_device_by_node()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/watchdog: Fix missed watchdog reset due to memory ordering race

Julia Lawall <Julia.Lawall@lip6.fr>
    powerpc/btext: add missing of_node_put

Julia Lawall <Julia.Lawall@lip6.fr>
    powerpc/cell: add missing of_node_put

Julia Lawall <Julia.Lawall@lip6.fr>
    powerpc/powernv: add missing of_node_put

Julia Lawall <Julia.Lawall@lip6.fr>
    powerpc/6xx: add missing of_node_put

Ingo Molnar <mingo@kernel.org>
    x86/kbuild: Enable CONFIG_KALLSYMS_ALL=y in the defconfigs

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: add more quirks to describe RX path capabilities

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: rename RX modes

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: flexcan: allow to change quirks at runtime

Mauro Carvalho Chehab <mchehab@kernel.org>
    scripts: sphinx-pre-install: Fix ctex support on Debian

John David Anglin <dave.anglin@bell.net>
    parisc: Avoid calling faulthandler_disabled() twice

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Unblock setting vid 0 for VF in case PF isn't eswitch manager

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Update log_max_qp value to FW max capability

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not throw away excess input to crng_fast_load

Lukas Wunner <lukas@wunner.de>
    serial: core: Keep mctrl register state and cached copy in sync

Lukas Wunner <lukas@wunner.de>
    serial: pl011: Drop CR register reset on set_termios

Lukas Wunner <lukas@wunner.de>
    serial: pl010: Drop CR register reset on set_termios

Konrad Dybcio <konrad.dybcio@somainline.org>
    regulator: qcom_smd: Align probe function with rpmh-regulator

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: gemini: allow any RGMII interface mode

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phy: marvell: configure RGMII delays for 88E1118

Danielle Ratson <danieller@nvidia.com>
    mlxsw: pci: Avoid flow control for EMAD packets

Jiri Olsa <jolsa@redhat.com>
    bpf/selftests: Fix namespace mount setup in tc_redirect

Joe Thornber <ejt@redhat.com>
    dm space map common: add bounds check to sm_ll_lookup_bitmap()

Joe Thornber <ejt@redhat.com>
    dm btree: add a defensive bounds check to insert_at()

Ping-Ke Shih <pkshih@realtek.com>
    mac80211: allow non-standard VHT MCS-10/11

Florian Fainelli <f.fainelli@gmail.com>
    net: mdio: Demote probed message to debug print

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove BUG_ON(!eie) in find_parent_nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove BUG_ON() in find_parent_nodes()

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: CPPC: Check present CPUs for determining _CPC is valid

Thomas Weißschuh <linux@weissschuh.net>
    ACPI: battery: Add the ThinkPad "Not Charging" quirk

Marina Nikolic <Marina.Nikolic@amd.com>
    amdgpu/pm: Make sysfs pm attributes as read-only for VFs

Zongmin Zhou <zhouzongmin@kylinos.cn>
    drm/amdgpu: fixup bad vram size on gmc v8

Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
    drm/amdgpu: Don't inherit GEM object VMAs in child process

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    mmc: mtk-sd: Use readl_poll_timeout instead of open-coded polling

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    ACPICA: Hardware: Do not flush CPU cache when entering S4 and S5

Sudeep Holla <sudeep.holla@arm.com>
    ACPICA: Fix wrong interpretation of PCC address

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Executer: Fix the REFCLASS_REFOF case in acpi_ex_opcode_1A_0T_1R()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Utilities: Avoid deleting the same object twice in a row

Mark Langsdorf <mlangsdo@redhat.com>
    ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions

Kyeong Yoo <kyeong.yoo@alliedtelesis.co.nz>
    jffs2: GC deadlock reading a page that is used in jffs2_write_begin()

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: consider completed fence seqno in hang check

Antony Antony <antony.antony@secunet.com>
    xfrm: rate limit SA mapping change message to user space

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: vhci: Set HCI_QUIRK_VALID_LE_STATES

Tedd Ho-Jeong An <tedd.an@intel.com>
    Bluetooth: btintel: Add missing quirks and msft ext for legacy bootloader

Ben Greear <greearb@candelatech.com>
    ath11k: Fix napi related hang

Randy Dunlap <rdunlap@infradead.org>
    um: registers: Rename function names to avoid conflicts and build problems

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    block: check minor range in device_add_disk()

Hector Martin <marcan@marcan.st>
    mmc: sdhci-pci-gli: GL9755: Support for CD/WP inversion on OF platforms

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pcie: make sure prph_info is set when treating wakeup IRQ

Avraham Stern <avraham.stern@intel.com>
    iwlwifi: mvm: fix AUX ROC removal

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Fix calculation of frame length

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: remove module loading failure message

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix leaks/bad data after failed firmware load

Changcheng Deng <deng.changcheng@zte.com.cn>
    PM: AVS: qcom-cpr: Use div64_ul instead of do_div

Po-Hao Huang <phhuang@realtek.com>
    rtw88: 8822c: update rx settings to prevent potential hw deadlock

Zekun Shen <bruceshenzk@gmail.com>
    ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()

Felix Fietkau <nbd@nbd.name>
    mt76: mt7615: improve wmm index allocation

Xing Song <xing.song@mediatek.com>
    mt76: do not pass the received frame with decryption error

Peter Chiu <chui-hao.chiu@mediatek.com>
    mt76: mt7615: fix possible deadlock while mt7615_register_ext_phy()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    usb: hub: Add delay for SuperSpeed hub resume to let links transit to U0

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Fix initialization of min and max frequency QoS requests

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Add safety net to supplier device release

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - fix memory leak in hpre_curve25519_src_init()

Peter Gonda <pgonda@google.com>
    crypto: ccp - Move SEV_INIT retry for corrupted data

Thierry Reding <treding@nvidia.com>
    arm64: tegra: Adjust length of CCPLEX cluster MMIO region

Biwen Li <biwen.li@nxp.com>
    arm64: dts: ls1028a-qds: move rtc node to the correct i2c bus

Paul Moore <paul@paul-moore.com>
    audit: ensure userspace is penalized the same as the kernel when under pressure

Jingwen Chen <Jingwen.Chen2@amd.com>
    drm/amd/amdgpu: fix gmc bo pin count leak in SRIOV

Jingwen Chen <Jingwen.Chen2@amd.com>
    drm/amd/amdgpu: fix psp tmr bo pin count leak in SRIOV

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Fixup storing of OCR for MMC_QUIRK_NONSTD_SDIO

Biju Das <biju.das.jz@bp.renesas.com>
    mmc: tmio: reinit card irqs in reset routine

Zhou Qingyang <zhou1615@umn.edu>
    media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()

Mikhail Rudenko <mike.rudenko@gmail.com>
    media: rockchip: rkisp1: use device name for debugfs subdir name

Sean Young <sean@mess.org>
    media: igorplugusb: receiver overflow should be reported

Alistair Francis <alistair@alistair23.me>
    HID: i2c-hid-of: Expose the touchscreen-inverted properties

Alistair Francis <alistair@alistair23.me>
    HID: quirks: Allow inverting the absolute X/Y values

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: Fix error handling in svm_range_add

Paolo Abeni <pabeni@redhat.com>
    bpf: Do not WARN in bpf_warn_invalid_xdp_action()

David Gow <davidgow@google.com>
    kunit: Don't crash if no parameters are generated

Suresh Kumar <surkumar@redhat.com>
    net: bonding: debug: avoid printing debug logs when bond is not notifying peers

Borislav Petkov <bp@suse.de>
    x86/mce: Mark mce_read_aux() noinstr

Borislav Petkov <bp@suse.de>
    x86/mce: Mark mce_end() noinstr

Borislav Petkov <bp@suse.de>
    x86/mce: Mark mce_panic() noinstr

Borislav Petkov <bp@suse.de>
    x86/mce: Allow instrumentation during task work queueing

Alex Elder <elder@linaro.org>
    ARM: dts: qcom: sdx55: fix IPA interconnect definitions

Baochen Qiang <quic_bqiang@quicinc.com>
    ath11k: Avoid false DEADLOCK warning reported by lockdep

Heiko Carstens <hca@linux.ibm.com>
    selftests/ftrace: make kprobe profile testcase description unique

Iwona Winiarska <iwona.winiarska@intel.com>
    gpio: aspeed-sgpio: Convert aspeed_sgpio.lock to raw_spinlock

Iwona Winiarska <iwona.winiarska@intel.com>
    gpio: aspeed: Convert aspeed_gpio.lock to raw_spinlock

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phy: prefer 1000baseT over 1000baseKX

Antoine Tenart <atenart@kernel.org>
    net-sysfs: update the queue counts in the unregistration path

Sebastian Gottschall <s.gottschall@dd-wrt.com>
    ath10k: Fix tx hanging

Wen Gong <quic_wgong@quicinc.com>
    ath11k: avoid deadlock by change ieee80211_queue_work for regd_update_work

Wander Lairson Costa <wander@redhat.com>
    rcutorture: Avoid soft lockup during cpu stall

Shaul Triebitz <shaul.triebitz@intel.com>
    iwlwifi: mvm: avoid clearing a just saved session protection id

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: synchronize with FW after multicast commands

Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
    arm64: dts: renesas: Fix thermal bindings

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Runtime PM activate both ends of the device link

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: m920x: don't use stack on USB reads

Tsuchiya Yuto <kitakar@gmail.com>
    media: atomisp: fix "variable dereferenced before check 'asd'"

Zhou Qingyang <zhou1615@umn.edu>
    media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: rcar-vin: Update format alignment constraints

James Hilliard <james.hilliard1@gmail.com>
    media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: rcar-du: Fix CRTC timings when CMM is used

Joerg Roedel <jroedel@suse.de>
    x86/mm: Flush global TLB when switching to trampoline page-table

Xiongwei Song <sxwjean@gmail.com>
    floppy: Add max size check for user space request

Neal Liu <neal_liu@aspeedtech.com>
    usb: uhci: add aspeed ast2600 uhci support

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: j721e-main: Fix 'dtbs_check' in serdes_ln_ctrl node

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: j7200-main: Fix 'dtbs_check' serdes_ln_ctrl node

Hans de Goede <hdegoede@redhat.com>
    ACPI / x86: Add not-present quirk for the PCI0.SDHB.BRC1 device on the GPD win

Hans de Goede <hdegoede@redhat.com>
    ACPI / x86: Allow specifying acpi_device_override_status() quirks by path

Hans de Goede <hdegoede@redhat.com>
    ACPI: Change acpi_device_always_present() into acpi_device_override_status()

Hans de Goede <hdegoede@redhat.com>
    ACPI / x86: Drop PWM2 device on Lenovo Yoga Book from always present table

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Introduce a new placement for MOB page tables

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Release ttm memory if probe fails

Adam Ward <Adam.Ward.opensource@diasemi.com>
    regulator: da9121: Prevent current limit change when enabled

Mansur Alisha Shaik <mansur@codeaurora.org>
    media: venus: avoid calling core_clk_setrate() concurrently during concurrent video sessions

Sriram R <quic_srirrama@quicinc.com>
    ath11k: Avoid NULL ptr access during mgmt tx cleanup

Zekun Shen <bruceshenzk@gmail.com>
    rsi: Fix out-of-bounds read in rsi_read_pkt()

Zekun Shen <bruceshenzk@gmail.com>
    rsi: Fix use-after-free in rsi_rx_done_handler()

Zekun Shen <bruceshenzk@gmail.com>
    mwifiex: Fix skb_over_panic in mwifiex_usb_recv()

Stephan Müller <smueller@chronox.de>
    crypto: jitter - consider 32 LSB for APT

Chengfeng Ye <cyeaa@connect.ust.hk>
    HSI: core: Fix return freed object in hsi_new_client

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use

Fugang Duan <fugang.duan@nxp.com>
    tty: serial: imx: disable UCR4_OREN in .stop_rx() instead of .shutdown()

Jiri Slaby <jirislaby@kernel.org>
    mxser: keep only !tty test in ISR

Martyn Welch <martyn.welch@collabora.com>
    drm/bridge: megachips: Ensure both bridges are probed before registration

Martin Leung <Martin.Leung@amd.com>
    drm/amd/display: add else to avoid double destroy clk_mgr

Danielle Ratson <danieller@nvidia.com>
    mlxsw: pci: Add shutdown method in PCI driver

Jan Kiszka <jan.kiszka@siemens.com>
    soc: ti: pruss: fix referenced node in error message

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: set vblank_disable_immediate for DC

Yang Li <yang.lee@linux.alibaba.com>
    drm/amd/display: check top_pipe_to_program pointer

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    ARM: imx: rename DEBUG_IMX21_IMX27_UART to DEBUG_IMX27_UART

Marek Vasut <marex@denx.de>
    soc: imx: gpcv2: Synchronously suspend MIX domains

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: sm8350: Shorten camera-thermal-bottom name

Dinh Nguyen <dinguyen@kernel.org>
    EDAC/synopsys: Use the quirk for version instead of ddr version

Yang Li <yang.lee@linux.alibaba.com>
    ethernet: renesas: Use div64_ul instead of do_div

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Accommodate DWARF/compiler bug with duplicated structs

Zheyu Ma <zheyuma97@gmail.com>
    media: b2c2: Add missing check in flexcop_pci_isr:

José Expósito <jose.exposito89@gmail.com>
    HID: apple: Do not reset quirks when the Fn key is not found

José Expósito <jose.exposito89@gmail.com>
    HID: magicmouse: Report battery level over USB

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for the Lenovo Yoga Book X91F/L

Brian Chen <brianchen118@gmail.com>
    psi: Fix PSI_MEM_FULL state when tasks are in memstall and doing reclaim

Pavankumar Kondeti <quic_pkondeti@quicinc.com>
    usb: gadget: f_fs: Use stream_open() for endpoint files

Haimin Zhang <tcs.kernel@gmail.com>
    USB: ehci_brcm_hub_control: Improve port index sanitizing

Amjad Ouled-Ameur <aouledameur@baylibre.com>
    usb: dwc3: meson-g12a: fix shared reset control use

Baochen Qiang <bqiang@codeaurora.org>
    ath11k: Fix crash caused by uninitialized TX ring

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: atomisp: handle errors at sh_css_create_isp_params()

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: allow netlink usage in unprivileged containers

Wan Jiabing <wanjiabing@vivo.com>
    ARM: shmobile: rcar-gen2: Add missing of_node_put()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: atomisp: check before deference asd variable

Hans de Goede <hdegoede@redhat.com>
    media: atomisp-ov2680: Fix ov2680_set_fmt() clobbering the exposure

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: atomisp: set per-device's default mode

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: atomisp: fix try_fmt logic

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR

Neil Armstrong <narmstrong@baylibre.com>
    drm/bridge: dw-hdmi: handle ELD when DRM_BRIDGE_ATTACH_NO_CONNECTOR

Zekun Shen <bruceshenzk@gmail.com>
    ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Fix bpf_object leak in skb_ctx selftest

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Destroy XDP link correctly

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Fix memory leaks in btf_type_c_dump() helper

Qiang Yu <yuq825@gmail.com>
    drm/lima: fix warning when CONFIG_DEBUG_SG=y & CONFIG_DMA_API_DEBUG=y

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Validate that .BTF and .BTF.ext sections contain data

Alexander Aring <aahringo@redhat.com>
    fs: dlm: filter user dlm messages for kernel locks

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: Fix removing adv when processing cmd complete

Brian Norris <briannorris@chromium.org>
    drm/panel: Delete panel on mipi_dsi_attach() failure

Wei Yongjun <weiyongjun1@huawei.com>
    Bluetooth: Fix memory leak of hci device

Wei Yongjun <weiyongjun1@huawei.com>
    Bluetooth: Fix debugfs entry leak in hci_register_dev()

Merlijn Wajer <merlijn@wizzup.org>
    leds: lp55xx: initialise output direction from dts

Sicelo A. Mhlongo <absicsz@gmail.com>
    ARM: dts: omap3-n900: Fix lp5523 for multi color

jason-jh.lin <jason-jh.lin@mediatek.com>
    mailbox: fix gce_num of mt8192 driver data

Paul Cercueil <paul@crapouillou.net>
    MIPS: compressed: Fix build with ZSTD compression

Paul Cercueil <paul@crapouillou.net>
    MIPS: boot/compressed/: add __ashldi3 to target for ZSTD compression

Stephen Boyd <swboyd@chromium.org>
    of/fdt: Don't worry about non-memory region overlap for no-map

Baruch Siach <baruch@tkos.co.il>
    of: base: Fix phandle argument length mismatch error message

Conor Dooley <conor.dooley@microchip.com>
    clk: bm1880: remove kfrees on static allocations

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: refine the check of available clock divider

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: imx-card: improve the sound quality for low rate

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: imx-card: Fix mclk calculation issue for akcodec

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: imx-card: Need special setting for ak4497 on i.MX8MQ

Taniya Das <tdas@codeaurora.org>
    clk: qcom: gcc-sc7280: Mark gcc_cfg_noc_lpass_clk always enabled

Kamal Heib <kamalheib1@gmail.com>
    RDMA/cxgb4: Set queue pair state when being queried

Christian A. Ehrhardt <lk@c--e.de>
    ALSA: hda/cs8409: Fix Jack detection after resume

Christian A. Ehrhardt <lk@c--e.de>
    ALSA: hda/cs8409: Increase delay during jack detection

Alyssa Ross <hi@alyssa.is>
    ASoC: fsl_mqs: fix MODULE_ALIAS

Ammar Faizi <ammarfaizi2@gmail.com>
    powerpc/xive: Add missing null check after calling kmalloc

Randy Dunlap <rdunlap@infradead.org>
    mips: bcm63xx: add support for clk_set_parent()

Randy Dunlap <rdunlap@infradead.org>
    mips: lantiq: add support for clk_set_parent()

Sameer Pujar <spujar@nvidia.com>
    arm64: tegra: Remove non existent Tegra194 reset

Trevor Wu <trevor.wu@mediatek.com>
    ASoC: mediatek: mt8195: correct pcmif BE dai control flow

Wei Yongjun <weiyongjun1@huawei.com>
    misc: lattice-ecp3-config: Fix task hung when firmware load failed

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: samsung: idma: Check of ioremap return value

Swapnil Jakhade <sjakhade@cadence.com>
    phy: cadence: Sierra: Fix to get correct parent for mux clocks

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Use EMIT_WARN_ENTRY for SRR debug warnings

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Mask NIP before checking against SRR0

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: mediatek: Check for error clk pointer

Ryuta NAKANISHI <nakanishi.ryuta@socionext.com>
    phy: uniphier-usb3ss: fix unintended writing zeros to PHY register

Alan Stern <stern@rowland.harvard.edu>
    scsi: block: pm: Always set request queue runtime active in blk_post_runtime_resume()

Pingfan Liu <kernelfans@gmail.com>
    efi: apply memblock cap after memblock_add()

Zhen Lei <thunder.leizhen@huawei.com>
    of: fdt: Aggregate the processing of "linux,usable-memory-range"

Trevor Wu <trevor.wu@mediatek.com>
    ASoC: mediatek: mt8195: correct default value

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iommu/iova: Fix race between FQ timeout and teardown

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Test dmaengine_submit() result before moving on

Maxim Levitsky <mlevitsk@redhat.com>
    iommu/amd: Remove useless irq affinity notifier

Maxim Levitsky <mlevitsk@redhat.com>
    iommu/amd: X2apic mode: mask/unmask interrupts on suspend/resume

Maxim Levitsky <mlevitsk@redhat.com>
    iommu/amd: X2apic mode: setup the INTX registers on mask/unmask

Maxim Levitsky <mlevitsk@redhat.com>
    iommu/amd: X2apic mode: re-enable after resume

Maxim Levitsky <mlevitsk@redhat.com>
    iommu/amd: Restore GA log/tail pointer on host resume

Arnd Bergmann <arnd@arndb.de>
    dmaengine: pxa/mmp: stop referencing config->slave_id

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    mips: fix Kconfig reference to PHYS_ADDR_T_64BIT

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    mips: add SYS_HAS_CPU_MIPS64_R5 config for MIPS Release 5 support

Dillon Min <dillon.minfei@gmail.com>
    clk: stm32: Fix ltdc's clock turn off by clk_disable_unused() after system enter shell

Frank Rowand <frank.rowand@sony.com>
    of: unittest: 64 bit dma address test requires arch support

Jim Quinlan <jim2101024@gmail.com>
    of: unittest: fix warning on PowerPC frame size warning

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: rt5663: Handle device_property_read_u32_array error codes

Avihai Horon <avihaih@nvidia.com>
    RDMA/cma: Let cma_resolve_ib_dev() continue search even after empty entry

Avihai Horon <avihaih@nvidia.com>
    RDMA/core: Let ib_find_gid() continue search even after empty entry

Rob Clark <robdclark@chromium.org>
    iommu/arm-smmu-qcom: Fix TTBR0 read

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/powermac: Add additional missing lockdep_register_key()

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Fix pci_irq_vector()/pci_irq_get_affinity()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/qedr: Fix reporting max_{send/recv}_wr attrs

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Fix race conditions related to driver data

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix scsi_device_max_queue_depth()

Hector Martin <marcan@marcan.st>
    iommu/io-pgtable-arm: Fix table descriptor paddr formatting

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Extend mutex lock scope in iommu_probe_device()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    uio: uio_dmem_genirq: Catch the Exception

Stafford Horne <shorne@gmail.com>
    openrisc: Add clone3 ABI wrapper

Todd Kjos <tkjos@google.com>
    binder: avoid potential data leakage when copying txn

Todd Kjos <tkjos@google.com>
    binder: fix handling of error during copy

Kees Cook <keescook@chromium.org>
    char/mwave: Adjust io port register size

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    misc: at25: Make driver OF independent again

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Drop superfluous '0' in Presonus Studio 1810c's ID

Bixuan Cui <cuibixuan@linux.alibaba.com>
    ALSA: oss: fix compile error when OSS_DEBUG is enabled

Waiman Long <longman@redhat.com>
    clocksource: Avoid accidental unstable marking of clocksources

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Fix shift-out-of-bounds in KASAN init

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/modules: Don't WARN on first module allocation attempt

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix PMU callbacks to clear pending PMI before resetting an overflown PMC

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    dt-bindings: thermal: Fix definition of cooling-maps contribution property

Thomas Gleixner <tglx@linutronix.de>
    ALSA: hda: Make proper use of timecounter

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs-clt: Fix the initial value of min_latency

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    ASoC: codecs: wcd938x: add SND_SOC_WCD938_SDW to codec list instead

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    ASoC: uniphier: drop selecting non-existing SND_SOC_UNIPHIER_AIO_DMA

Peiwei Hu <jlu.hpw@foxmail.com>
    powerpc/prom_init: Fix improper check of prom_getprop()

Adam Ford <aford173@gmail.com>
    clk: imx8mn: Fix imx8mn_clko1_sels

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: rzg2l: propagate return value of_genpd_add_provider_simple()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: rzg2l: Check return value of pm_genpd_init()

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/hns: Validate the pkey index

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    RDMA/bnxt_re: Scan the whole bitmap when checking if "disabling RCFW with pending cmd-bit"

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix potential deadlock at codec unbinding

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add missing rwsem around snd_ctl_remove() calls

Takashi Iwai <tiwai@suse.de>
    ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls

Takashi Iwai <tiwai@suse.de>
    ALSA: jack: Add missing rwsem around snd_ctl_remove() calls

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: fix jack detection on HP Spectre x360 convertible

Jan Kara <jack@suse.cz>
    ext4: avoid trim error on fs with small groups

Pavel Skripkin <paskripkin@gmail.com>
    net: mcs7830: handle usb read errors properly

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: use firmware provided max timeout for messages

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: move coredump functions into dedicated file

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: Refactor coredump functions

Nathan Chancellor <nathan@kernel.org>
    iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_ftm_rtt_smoothing()

Paul Blakey <paulb@nvidia.com>
    net: openvswitch: Fix ct_state nat flags for conns arriving from tc

Paul Blakey <paulb@nvidia.com>
    net: openvswitch: Fix matching zone id for invalid conns arriving from tc

Paul Blakey <paulb@nvidia.com>
    net/sched: flow_dissector: Fix matching on zone id for invalid conns

Dominik Brodowski <linux@dominikbrodowski.net>
    pcmcia: fix setting of kthread task states

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    can: rcar_canfd: rcar_canfd_channel_probe(): make sure we free CAN network device

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    can: xilinx_can: xcan_probe(): check for error irq

Marc Kleine-Budde <mkl@pengutronix.de>
    can: softing: softing_startstop(): fix set but not used variable warning

Christophe Jaillet <christophe.jaillet@wanadoo.fr>
    tpm_tis: Fix an error handling path in 'tpm_tis_core_init()'

Chen Jun <chenjun102@huawei.com>
    tpm: add request_locality before write TPM_INT_ENABLE

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: add missing newline to printed strings

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix incorrect balancing with down LAG ports

Fabio Estevam <festevam@denx.de>
    regmap: Call regmap_debugfs_exit() prior to _init()

Dan Carpenter <dan.carpenter@oracle.com>
    netrom: fix api breakage in nr_setsockopt()

Dan Carpenter <dan.carpenter@oracle.com>
    ax25: uninitialized variable in ax25_setsockopt()

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Increment ptp refcount before use

Miaoqian Lin <linmq006@gmail.com>
    spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe

Geliang Tang <geliang.tang@suse.com>
    mptcp: fix a DSS option writing error

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: fix opt size when sending DSS + MP_FAIL

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix per socket endpoint accounting

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: L2CAP: uninitialized variables in l2cap_sock_setsockopt()

Zizhuang Deng <sunsetdzz@gmail.com>
    lib/mpi: Add the return value check of kcalloc()

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Set command entry semaphore up once got index free

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Sync VXLAN udp ports during uplink representor profile change

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix access to sf_dev_table on allocation failure

Paul Blakey <paulb@nvidia.com>
    net/mlx5e: Fix matching on modified inner ip_ecn bits

Aya Levin <ayal@nvidia.com>
    Revert "net/mlx5e: Block offload of outer header csum for GRE tunnel"

Aya Levin <ayal@nvidia.com>
    Revert "net/mlx5e: Block offload of outer header csum for UDP tunnels"

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Don't block routes with nexthop objects in SW

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Fix wrong usage of fib_info_nh when routes with nexthop objects are used

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix page DMA map/unmap attributes

Huang Rui <ray.huang@amd.com>
    x86, sched: Fix undefined reference to init_freq_invariance_cppc() build error

Valentin Caron <valentin.caron@foss.st.com>
    serial: stm32: move tx dma terminate DMA to shutdown

Alyssa Ross <hi@alyssa.is>
    serial: liteuart: fix MODULE_ALIAS

Miaoqian Lin <linmq006@gmail.com>
    drivers/firmware: Add missing platform_device_put() in sysfb_create_simplefb

Michal Suchanek <msuchanek@suse.de>
    debugfs: lockdown: Allow reading debugfs files that are not world readable

José Expósito <jose.exposito89@gmail.com>
    HID: hid-uclogic-params: Invalid parameter check in uclogic_params_frame_init_v1_buttonpad

José Expósito <jose.exposito89@gmail.com>
    HID: hid-uclogic-params: Invalid parameter check in uclogic_params_huion_init

José Expósito <jose.exposito89@gmail.com>
    HID: hid-uclogic-params: Invalid parameter check in uclogic_params_get_str_desc

José Expósito <jose.exposito89@gmail.com>
    HID: hid-uclogic-params: Invalid parameter check in uclogic_params_init

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: gadget: u_audio: Subdevice 0 for capture ctls

John Keeping <john@metanate.com>
    usb: dwc2: gadget: initialize max_speed from params

Dinh Nguyen <dinguyen@kernel.org>
    usb: dwc2: do not gate off the hardware if it does not support clock gating

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc3: qcom: Fix NULL vs IS_ERR checking in dwc3_qcom_probe

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Reset conn->lgr when link group registration fails

Miaoqian Lin <linmq006@gmail.com>
    Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check in qca_serdev_probe

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    Bluetooth: hci_bcm: Check for error irq

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    fsl/fman: Check for null pointer after calling devm_ioremap

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    staging: greybus: audio: Check null pointer

Dan Carpenter <dan.carpenter@oracle.com>
    rocker: fix a sleeping in atomic bug

Eric Dumazet <edumazet@google.com>
    ppp: ensure minimum packet size in ppp_write()

Miroslav Lichvar <mlichvar@redhat.com>
    net: fix SOF_TIMESTAMPING_BIND_PHC to work with multiple sockets

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: do not update layer 4 checksum when mangling fragments

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().

Kris Van Hees <kris.van.hees@oracle.com>
    bpf: Fix verifier support for validation of async callbacks

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Don't promote bogus looking registers after null check.

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Fix double bpf_prog_put on error case in map_link

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Fix return codes from tcp_bpf_recvmsg_parser()

Xin Xiong <xiongx18@fudan.edu.cn>
    netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix incorrect function pointer check for MRP ring roles

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: fix return values and refactor MDIO ops

Raed Salem <raeds@nvidia.com>
    net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    power: reset: mt6397: Check for null res pointer

Zhou Qingyang <zhou1615@umn.edu>
    pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in nonstatic_find_mem_region()

Zhou Qingyang <zhou1615@umn.edu>
    pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in __nonstatic_find_io_region()

Hans de Goede <hdegoede@redhat.com>
    ACPI: scan: Create platform device for BCM4752 and LNV4752 ACPI nodes

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    serial: 8250_bcm7271: Propagate error codes from brcmuart_probe()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: remove double poll on poll update

Zhang Zixun <zhang133010@icloud.com>
    x86/mce/inject: Avoid out-of-bounds write when setting flags

Arseny Demidov <arsdemal@gmail.com>
    hwmon: (mr75203) fix wrong power-up delay value

Marijn Suijten <marijn.suijten@somainline.org>
    regulator: qcom-labibb: OCP interrupts are not a failure while disabled

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: octeontx2 - prevent underflow in get_cores_bmap()

Nathan Chancellor <nathan@kernel.org>
    x86/boot/compressed: Move CLANG_FLAGS to beginning of KBUILD_CFLAGS

Panicker Harish <quic_pharish@quicinc.com>
    Bluetooth: hci_qca: Stop IBS timer during BT OFF

Clément Léger <clement.leger@bootlin.com>
    software node: fix wrong node passed to find nargs_prop

Marijn Suijten <marijn.suijten@somainline.org>
    backlight: qcom-wled: Respect enabled-strings in set_brightness

Marijn Suijten <marijn.suijten@somainline.org>
    backlight: qcom-wled: Use cpu_to_le16 macro to perform conversion

Marijn Suijten <marijn.suijten@somainline.org>
    backlight: qcom-wled: Override default length with qcom,enabled-strings

Marijn Suijten <marijn.suijten@somainline.org>
    backlight: qcom-wled: Fix off-by-one maximum with default num_strings

Marijn Suijten <marijn.suijten@somainline.org>
    backlight: qcom-wled: Pass number of elements to read to read_u32_array

Marijn Suijten <marijn.suijten@somainline.org>
    backlight: qcom-wled: Validate enabled string indices in DT

Paul Chaignon <paul@isovalent.com>
    bpftool: Enable line buffering for stdout

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix using wrong mode

Johannes Berg <johannes.berg@intel.com>
    um: virtio_uml: Fix time-travel external time propagation

Johannes Berg <johannes.berg@intel.com>
    lib/logic_iomem: Fix operation on 32-bit

Johannes Berg <johannes.berg@intel.com>
    lib/logic_iomem: Fix 32-bit build

Johannes Berg <johannes.berg@intel.com>
    um: virt-pci: Fix 32-bit compile

Johannes Berg <johannes.berg@intel.com>
    um: rename set_signals() to um_set_signals()

Johannes Berg <johannes.berg@intel.com>
    um: fix ndelay/udelay defines

Bernard Zhao <bernard@vivo.com>
    selinux: fix potential memleak in selinux_add_opt()

Christoph Hellwig <hch@lst.de>
    block: fix error unwinding in device_add_disk

Sergey Shtylyov <s.shtylyov@omp.ru>
    mmc: meson-mx-sdio: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    mmc: meson-mx-sdhc: add IRQ check

Avraham Stern <avraham.stern@intel.com>
    iwlwifi: mvm: set protected flag only for NDP ranging

Avraham Stern <avraham.stern@intel.com>
    iwlwifi: mvm: perform 6GHz passive scan after suspend

Nathan Errera <nathan.errera@intel.com>
    iwlwifi: mvm: test roc running status bits before removing the sta

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix 32-bit build in FTM

Kai-Heng Feng <kai.heng.feng@canonical.com>
    rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: add quirk to disable pci caps on HP 250 G7 Notebook PC

Dan Carpenter <dan.carpenter@oracle.com>
    wilc1000: fix double free error in probe()

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: drop offload_flags overwritten

Marek Behún <kabel@kernel.org>
    ARM: dts: armada-38x: Add generic compatible to UART nodes

Robert Marko <robert.marko@sartura.hr>
    arm64: dts: marvell: cn9130: enable CP0 GPIO controllers

Robert Marko <robert.marko@sartura.hr>
    arm64: dts: marvell: cn9130: add GPIO and SPI aliases

Wei Yongjun <weiyongjun1@huawei.com>
    usb: ftdi-elan: fix memory leak on device disconnect

Andre Przywara <andre.przywara@arm.com>
    ARM: 9159/1: decompressor: Avoid UNPREDICTABLE NOP encoding

Antony Antony <antony.antony@secunet.com>
    xfrm: state and policy should fail if XFRMA_IF_ID 0

Antony Antony <antony.antony@secunet.com>
    xfrm: interface with if_id 0 should return error

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: hantro: Fix probe func error path

Robin Murphy <robin.murphy@arm.com>
    drm/tegra: vic: Fix DMA API misuse

Thierry Reding <treding@nvidia.com>
    drm/tegra: gr2d: Explicitly control module reset

Arnd Bergmann <arnd@arndb.de>
    gpu: host1x: select CONFIG_DMA_SHARED_BUFFER

Stephen Boyd <swboyd@chromium.org>
    drm/bridge: ti-sn65dsi86: Set max register for regmap

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: fix safe status debugfs file

Baruch Siach <baruch@tkos.co.il>
    arm64: dts: qcom: ipq6018: Fix gpio-ranges property

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    arm64: dts: qcom: c630: Fix soundcard setup

Kurt Kanzenbach <kurt@linutronix.de>
    net: dsa: hellcreek: Add missing PTP via UDP rules

Kurt Kanzenbach <kurt@linutronix.de>
    net: dsa: hellcreek: Allow PTP P2P measurements on blocked ports

Kurt Kanzenbach <kurt@linutronix.de>
    net: dsa: hellcreek: Add STP forwarding rule

Kurt Kanzenbach <kurt@linutronix.de>
    net: dsa: hellcreek: Fix insertion of static FDB entries

Zhou Qingyang <zhou1615@umn.edu>
    ath11k: Fix a NULL pointer dereference in ath11k_mac_op_hw_scan()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda/imx-vdoa: Handle dma_set_coherent_mask error codes

Wang Hai <wanghai38@huawei.com>
    media: msi001: fix possible null-ptr-deref in msi001_probe()

Anton Vasilyev <vasilyev@ispras.ru>
    media: dw2102: Fix use after free

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Fix CPU hotplug unregistration

Christian Lamparter <chunkeey@gmail.com>
    ARM: dts: gemini: NAS4220-B: fis-index-block with 128 KiB sectors

Hector Martin <marcan@marcan.st>
    spi: Fix incorrect cs_setup delay handling

Rameshkumar Sundaram <quic_ramess@quicinc.com>
    ath11k: Fix deleting uninitialized kernel timer during fragment cache flush

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - fix incorrect return value of hisi_qm_resume()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: stm32 - Revert broken pm_runtime_resume_and_get changes

Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
    crypto: stm32/cryp - fix bugs and crash in tests

Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
    crypto: stm32/cryp - fix lrw chaining mode

Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
    crypto: stm32/cryp - fix double pm exit

Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
    crypto: stm32/cryp - check early input data

Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
    crypto: stm32/cryp - fix xts and race condition in crypto_engine requests

Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
    crypto: stm32/cryp - fix CTR counter carry

Jakub Kicinski <kuba@kernel.org>
    selftests: harness: avoid false negatives if test has no ASSERTs

Anders Roxell <anders.roxell@linaro.org>
    selftests: clone3: clone3: add case CLONE3_ARGS_NO_TEST

Kees Cook <keescook@chromium.org>
    x86/uaccess: Move variable into switch case statement

Eric Dumazet <edumazet@google.com>
    xfrm: fix a small bug in xfrm_sa_len()

Brian Norris <briannorris@chromium.org>
    mwifiex: Fix possible ABBA deadlock

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: fix initialization in the bonded DSI case

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix max channels retrieval

Frederic Weisbecker <frederic@kernel.org>
    rcu/exp: Mark current CPU as exp-QS in IPI loop second pass

Jackie Liu <liuyun01@kylinos.cn>
    drm/msm/dp: displayPort driver need algorithm rational

Rob Clark <robdclark@chromium.org>
    drm/msm/gpu: Don't allow zero fence_id

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix out of bounds access on DNC31 stream encoder regs

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Fix bug in debugfs crc_win_update entry

Mark Chen <mark-yw.chen@mediatek.com>
    Bluetooth: btusb: Handle download_firmware failure cases

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Use hci_dev_test_and_{set,clear}_flag

Joseph Hwang <josephsih@chromium.org>
    Bluetooth: refactor set_exp_feature with a feature table

Fabio Estevam <festevam@denx.de>
    ath10k: Fix the MTU size on QCA9377 SDIO

Li Hua <hucool.lihua@huawei.com>
    sched/rt: Try to restart rt period timer when rt runtime exceeded

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    wireless: iwlwifi: Fix a double free in iwl_txq_dyn_alloc_dma

Robert Schlabbach <robert_s@gmx.net>
    media: si2157: Fix "warm" tuner state detection

Zhou Qingyang <zhou1615@umn.edu>
    media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()

Zhou Qingyang <zhou1615@umn.edu>
    media: dib8000: Fix a memleak in dib8000_init()

Alexander Lobakin <alexandr.lobakin@intel.com>
    samples: bpf: Fix 'unknown warning group' build warning on Clang

Alexander Lobakin <alexandr.lobakin@intel.com>
    samples: bpf: Fix xdp_sample_user.o linking with Clang

Andrii Nakryiko <andrii@kernel.org>
    samples/bpf: Clean up samples/bpf build failes

Quentin Monnet <quentin@isovalent.com>
    samples/bpf: Install libbpf headers when building

Reiji Watanabe <reijiw@google.com>
    arm64: mte: DC {GVA,GZVA} shouldn't be used when DCZID_EL0.DZP == 1

Reiji Watanabe <reijiw@google.com>
    arm64: clear_page() shouldn't use DC ZVA when DCZID_EL0.DZP == 1

Kajol Jain <kjain@linux.ibm.com>
    bpf: Remove config check to enable bpf support for branch records

Hou Tao <houtao1@huawei.com>
    bpf: Disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)

Alexei Starovoitov <ast@kernel.org>
    bpf: Adjust BTF log size limit.

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/fair: Fix per-CPU kthread and wakee stacking for asym CPU capacity

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/fair: Fix detection of per-CPU kthreads waking a task

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Fix the test_task_vma selftest to support output shorter than 1 kB

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: btmtksdio: fix resume failure

Yang Yingliang <yangyingliang@huawei.com>
    staging: rtl8192e: rtllib_module: fix error handle case in alloc_rtllib()

Yang Yingliang <yangyingliang@huawei.com>
    staging: rtl8192e: return error code from rtllib_softmac_init()

Tasos Sahanidis <tasos@tasossah.com>
    floppy: Fix hang in watchdog when disk is ejected

Michael Walle <michael@walle.cc>
    mtd: core: provide unique name for nvmem device

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: amba-pl011: do not request memory region twice

Lizhi Hou <lizhi.hou@xilinx.com>
    tty: serial: uartlite: allow 64 bit address

Nishanth Menon <nm@ti.com>
    arm64: dts: ti: k3-j7200: Correct the d-cache-sets info

Nishanth Menon <nm@ti.com>
    arm64: dts: ti: k3-j721e: Fix the L2 cache sets

Nishanth Menon <nm@ti.com>
    arm64: dts: ti: k3-j7200: Fix the L2 cache sets

Nishanth Menon <nm@ti.com>
    arm64: dts: ti: k3-am642: Fix the L2 cache sets

Gaurav Jain <gaurav.jain@nxp.com>
    crypto: caam - save caam memory to support crypto engine retry mechanism.

Alexei Starovoitov <ast@kernel.org>
    libbpf: Clean gen_loader's attach kind.

Zhou Qingyang <zhou1615@umn.edu>
    drm/radeon/radeon_kms: Fix a NULL pointer dereference in radeon_driver_open_kms()

Zhou Qingyang <zhou1615@umn.edu>
    drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()

Paul Gerber <Paul.Gerber@tq-group.com>
    thermal/drivers/imx8mm: Enable ADC when enabling monitor

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Rework flushing of EC work while suspended to idle

William Kucharski <william.kucharski@oracle.com>
    cgroup: Trace event cgroup id fields should be u64

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Fail to initialize on broken configs

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Remove the deprecated lower mem limit

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8916: fix MMC controller aliases

Mark Rutland <mark.rutland@arm.com>
    powerpc: Avoid discarding flags in system_call_exception()

Florian Westphal <fw@strlen.de>
    netfilter: bridge: add support for pppoe filtering

Jesper Dangaard Brouer <brouer@redhat.com>
    igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS

Oleksij Rempel <linux@rempel-privat.de>
    thermal/drivers/imx: Implement runtime PM support

Bhupesh Sharma <bhupesh.sharma@linaro.org>
    net: stmmac: Add platform level debug register dump feature

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: venus: core: Fix a resource leak in the error handling path of 'venus_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: venus: core: Fix a potential NULL pointer dereference in an error handling path

Mansur Alisha Shaik <mansur@codeaurora.org>
    media: venus: correct low power frequency calculation for encoder

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: fix CODA960 JPEG encoder buffer overflow

Chen-Yu Tsai <wenst@chromium.org>
    media: hantro: Hook up RK3399 JPEG encoder output

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: mtk-vcodec: call v4l2_m2m_ctx_release first when file is released

Yang Yingliang <yangyingliang@huawei.com>
    media: si470x-i2c: fix possible memory leak in si470x_i2c_probe()

Fabio Estevam <festevam@denx.de>
    media: imx-pxp: Initialize the spinlock prior to using it

Suresh Udipi <sudipi@jp.adit-jv.com>
    media: rcar-csi2: Correct the selection of hsfreqrange

Hans de Goede <hdegoede@redhat.com>
    media: i2c: ov8865: Fix lockdep error

Daniel Scally <djrscally@gmail.com>
    media: i2c: Re-order runtime pm initialisation

Eugen Hristev <eugen.hristev@microchip.com>
    media: i2c: imx274: fix s_frame_interval runtime resume not requested

Alan Maguire <alan.maguire@oracle.com>
    libbpf: Silence uninitialized warning/error in btf_dump_dump_type_data

Jan Kara <jack@suse.cz>
    bfq: Do not let waker requests skip proper accounting

Claudiu Beznea <claudiu.beznea@microchip.com>
    mfd: atmel-flexcom: Use .resume_noirq

Claudiu Beznea <claudiu.beznea@microchip.com>
    mfd: atmel-flexcom: Remove #ifdef CONFIG_PM_SLEEP

Tudor Ambarus <tudor.ambarus@microchip.com>
    tty: serial: atmel: Call dma_async_issue_pending()

Tudor Ambarus <tudor.ambarus@microchip.com>
    tty: serial: atmel: Check return code of dmaengine_submit()

Peng Fan <peng.fan@nxp.com>
    arm64: dts: ti: k3-j721e: correct cache-sets info

Anilkumar Kolli <akolli@codeaurora.org>
    ath11k: Use host CE parameters for CE interrupts configuration

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix undetected PFVF timeout in ACK loop

Marco Chiappero <marco.chiappero@intel.com>
    crypto: qat - make pfvf send message direction agnostic

Marco Chiappero <marco.chiappero@intel.com>
    crypto: qat - remove unnecessary collision prevention step in PFVF

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix using invalidated memory in bpf_linker

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix glob_syms memory leak in bpf_linker

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix potential misaligned memory access in btf_ext__new()

Dillon Min <dillon.minfei@gmail.com>
    ARM: dts: stm32: fix dtbs_check warning on ili9341 dts binding on stm32f429 disco

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    cpufreq: qcom-hw: Fix probable nested interrupt handling

Lukasz Luba <lukasz.luba@arm.com>
    cpufreq: qcom-cpufreq-hw: Update offline CPUs per-cpu thermal pressure

George G. Davis <davis.george@siemens.com>
    mtd: hyperbus: rpc-if: fix bug in rpcif_hb_remove

Prasad Malisetty <pmaliset@codeaurora.org>
    arm64: dts: qcom: sc7280: Fix incorrect clock name

Chengfeng Ye <cyeaa@connect.ust.hk>
    crypto: qce - fix uaf on qce_skcipher_register_one

Chengfeng Ye <cyeaa@connect.ust.hk>
    crypto: qce - fix uaf on qce_ahash_register_one

Chengfeng Ye <cyeaa@connect.ust.hk>
    crypto: qce - fix uaf on qce_aead_register_one

Tudor Ambarus <tudor.ambarus@microchip.com>
    crypto: atmel-aes - Reestablish the correct tfm context at dequeue

Wang Hai <wanghai38@huawei.com>
    media: dmxdev: fix UAF when dvb_register_device() fails

Biju Das <biju.das.jz@bp.renesas.com>
    arm64: dts: renesas: cat875: Add rx/tx delays

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vboxvideo: fix a NULL vs IS_ERR() check

Lyude Paul <lyude@redhat.com>
    drm/dp: Don't read back backlight mode in drm_edp_backlight_enable()

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix build with CONFIG_IPV6 disabled

Jens Wiklander <jens.wiklander@linaro.org>
    tee: fix put order in teedev_close_context()

oujiefeng <oujiefeng@huawei.com>
    spi: hisi-kunpeng: Fix the debugfs directory name incorrect

Karthikeyan Kathirvel <kathirve@codeaurora.org>
    ath11k: reset RSN/WPA present state for open BSS

Karthikeyan Kathirvel <kathirve@codeaurora.org>
    ath11k: clear the keys properly via DISABLE_KEY

Sven Eckelmann <sven@narfation.org>
    ath11k: Fix ETSI regd with weather radar overlap

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: stop proccessing malicious adv data

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    memory: renesas-rpc-if: Return error in case devm_ioremap_resource() fails

Alexander Aring <aahringo@redhat.com>
    fs: dlm: don't call kernel_getpeername() in error_report()

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxbb-wetek: fix missing GPIO binding

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxbb-wetek: fix HDMI in early boot

Alexander Stein <alexander.stein@mailbox.org>
    arm64: dts: amlogic: Fix SPI NOR flash node name for ODROID N2/N2+

Alexander Stein <alexander.stein@mailbox.org>
    arm64: dts: amlogic: meson-g12: Fix GPU operating point table node name

Jammy Huang <jammy_huang@aspeedtech.com>
    media: aspeed: Update signal status immediately to ensure sane hw state

Dongliang Mu <mudongliangabcd@gmail.com>
    media: em28xx: fix memory leak in em28xx_init_dev

Jammy Huang <jammy_huang@aspeedtech.com>
    media: aspeed: fix mode-detect always time out at 2nd run

Dan Carpenter <dan.carpenter@oracle.com>
    media: atomisp: fix uninitialized bug in gmin_get_pmic_id_and_addr()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: atomisp: fix enum formats logic

Tsuchiya Yuto <kitakar@gmail.com>
    media: atomisp: add NULL check for asd obtained from atomisp_video_pipe

Tsuchiya Yuto <kitakar@gmail.com>
    media: atomisp: fix ifdefs in sh_css.c

Tsuchiya Yuto <kitakar@gmail.com>
    media: atomisp: fix inverted error check for ia_css_mipi_is_source_port_valid()

Tsuchiya Yuto <kitakar@gmail.com>
    media: atomisp: do not use err var when checking port validity for ISP2400

Tsuchiya Yuto <kitakar@gmail.com>
    media: atomisp: fix inverted logic in buffers_needed()

Tsuchiya Yuto <kitakar@gmail.com>
    media: atomisp: fix punit_ddr_dvfs_enable() argument for mrfld_power up case

Tsuchiya Yuto <kitakar@gmail.com>
    media: atomisp: add missing media_device_cleanup() in atomisp_unregister_entities()

Dillon Min <dillon.minfei@gmail.com>
    media: videobuf2: Fix the size printk format

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mtd: hyperbus: rpc-if: Check return value of rpcif_sw_init()

Quentin Monnet <quentin@isovalent.com>
    bpftool: Fix memory leak in prog_dump()

Rameshkumar Sundaram <ramess@codeaurora.org>
    ath11k: Send PPDU_STATS_CFG with proper pdev mask to firmware

Benjamin Li <benl@squareup.com>
    wcn36xx: fix RX BD rate mapping for 5GHz legacy rates

Benjamin Li <benl@squareup.com>
    wcn36xx: populate band before determining rate on RX

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Put DXE block into reset before freeing memory

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Release DMA channel descriptor allocations

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Fix DMA channel enable/disable cycle

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Free up resources used by inner map definition

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Enable the scrambler on reconnection

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND

Benjamin Li <benl@squareup.com>
    wcn36xx: ensure pairing of init_scan/finish_scan and start_scan/end_scan

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: crtc: Make sure the HDMI controller is powered when disabling

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Rework the pre_crtc_configure error handling

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Make sure the controller is powered up during bind

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Make sure the controller is powered in detect

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Move the HSM clock enable to runtime_pm

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Set a default HSM rate

Maxime Ripard <maxime@cerno.tech>
    clk: bcm-2835: Remove rounding up the dividers

Maxime Ripard <maxime@cerno.tech>
    clk: bcm-2835: Pick the closest clock rate

Wang Hai <wanghai38@huawei.com>
    Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails

Soenke Huster <soenke.huster@eknoes.de>
    Bluetooth: virtio_bt: fix memory leak in virtbt_rx_handle()

Brian Norris <briannorris@chromium.org>
    drm/rockchip: dsi: Reconfigure hardware on resume()

Brian Norris <briannorris@chromium.org>
    drm/rockchip: dsi: Disable PLL clock on bind error

Brian Norris <briannorris@chromium.org>
    drm/rockchip: dsi: Hold pm-runtime across bind/unbind

Brian Norris <briannorris@chromium.org>
    drm/rockchip: dsi: Fix unbalanced clock on probe error

Brian Norris <briannorris@chromium.org>
    drm/panel: innolux-p079zca: Delete panel on attach() failure

Brian Norris <briannorris@chromium.org>
    drm/panel: kingdisplay-kd097d04: Delete panel on attach() failure

Wang Hai <wanghai38@huawei.com>
    drm: fix null-ptr-deref in drm_dev_init_release()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/bridge: display-connector: fix an uninitialized pointer in probe()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not initializing sk_peer_pid

xinhui pan <xinhui.pan@amd.com>
    drm/ttm: Put BO in its memory manager's lru list

Gang Li <ligang.bdlg@bytedance.com>
    shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode

Wen Gong <quic_wgong@quicinc.com>
    ath11k: add string type to search board data in board-2.bin for WCN6855

Baoquan He <bhe@redhat.com>
    mm/page_alloc.c: do not warn allocation failure on zone DMA if no managed pages

Baoquan He <bhe@redhat.com>
    dma/pool: create dma atomic pool only if dma zone has managed pages

Baoquan He <bhe@redhat.com>
    mm_zone: add function to check if managed dma zone exists

Yifeng Li <tomli@tomli.me>
    PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    dma_fence_array: Fix PENDING_ERROR leak in dma_fence_array_signaled()

Peng Hao <flyingpenghao@gmail.com>
    virtio/virtio_mem: handle a possible NULL as a memcpy parameter

Dmitry Osipenko <digetx@gmail.com>
    drm/tegra: Add back arm_iommu_detach_device()

Dmitry Osipenko <digetx@gmail.com>
    gpu: host1x: Add back arm_iommu_detach_device()

Yunfei Wang <yf.wang@mediatek.com>
    iommu/io-pgtable-arm-v7s: Add error handle for page table allocation failure

Hari Prasath <Hari.PrasathGE@microchip.com>
    ARM: dts: at91: update alternate function of signal PD20

D Scott Phillips <scott@os.amperecomputing.com>
    arm64: errata: Fix exec handling in erratum 1418040 workaround

Dan Williams <dan.j.williams@intel.com>
    cxl/pmem: Fix reference counting for delayed work

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: core: Fix race while handling SYS_ERR at power up

Bhaumik Bhatt <quic_bbhatt@quicinc.com>
    bus: mhi: core: Fix reading wake_capable channel configuration

Loic Poulain <loic.poulain@linaro.org>
    bus: mhi: pci_generic: Graceful shutdown on freeze

Christophe Leroy <christophe.leroy@csgroup.eu>
    lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-adc081c: Partial revert of removal of ACPI IDs

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: hbm: fix client dma reply status

Johan Hovold <johan@kernel.org>
    can: softing_cs: softingcs_probe(): fix memleak on registration failure

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-pin: fix interrupt en/disable handling

Johan Hovold <johan@kernel.org>
    media: stk1160: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: pvrusb2: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: redrat3: fix control-message timeouts

Michael Kuron <michael.kuron@gmail.com>
    media: dib0700: fix undefined behavior in tuner shutdown

Johan Hovold <johan@kernel.org>
    media: s2255: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: cpia2: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: em28xx: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: mceusb: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: flexcop-usb: fix control-message timeouts

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ioctl.c: readbuffers depends on V4L2_CAP_READWRITE

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ov8865: Disable only enabled regulators on error path

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: fix a deadlock situation

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add reserved room in ipc request/response

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: limits exceeding the maximum allowable outstanding requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: move credit charge deduction under processing request

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add support for smb2 max credit parameter

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix guest connection failure with nautilus

Dan Carpenter <dan.carpenter@oracle.com>
    ksmbd: uninitialized variable in create_socket()

Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
    net: phy: marvell: add Marvell specific PHY loopback

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: take rtc_lock while reading from CMOS

Willy Tarreau <w@1wt.eu>
    tools/nolibc: fix incorrect truncation of exit code

Willy Tarreau <w@1wt.eu>
    tools/nolibc: i386: fix initial stack alignment

Jakub Kicinski <kuba@kernel.org>
    crypto: x86/aesni - don't require alignment of data

Ammar Faizi <ammar.faizi@students.amikom.ac.id>
    tools/nolibc: x86-64: Fix startup code bug

Lucas De Marchi <lucas.demarchi@intel.com>
    x86/gpu: Reserve stolen memory for first integrated Intel GPU

Jisheng Zhang <jszhang@kernel.org>
    riscv: mm: fix wrong phys_ram_base value for RV64

Nick Kossifidis <mick@ics.forth.gr>
    riscv: use hart id instead of cpu id on machine_kexec

Nick Kossifidis <mick@ics.forth.gr>
    riscv: Don't use va_pa_offset on kdump

Nick Kossifidis <mick@ics.forth.gr>
    riscv: try to allocate crashkern region from 32bit addressible memory

Sean Christopherson <seanjc@google.com>
    RISC-V: Use common riscv_cpuid_to_hartid_mask() for both SMP=y and SMP=n

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    riscv: Get rid of MAXPHYSMEM configs

Paul Cercueil <paul@crapouillou.net>
    mtd: rawnand: ingenic: JZ4740 needs 'oob_first' read page function

Paul Cercueil <paul@crapouillou.net>
    mtd: rawnand: Export nand_read_page_hwecc_oob_first()

Paul Cercueil <paul@crapouillou.net>
    mtd: rawnand: davinci: Rewrite function description

Paul Cercueil <paul@crapouillou.net>
    mtd: rawnand: davinci: Avoid duplicated page read

Paul Cercueil <paul@crapouillou.net>
    mtd: rawnand: davinci: Don't calculate ECC when reading page

Andreas Oetken <ennoerlangen@gmail.com>
    mtd: Fixed breaking list in __mtd_del_partition.

Stefan Riedmueller <s.riedmueller@phytec.de>
    mtd: rawnand: gpmi: Remove explicit default gpmi clock setting for i.MX6

Christian Eggers <ceggers@arri.de>
    mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: avoid EINVAL by SBI_NEED_FSCK when pinning a file

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check in is_alive()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on inode type during garbage collection

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix SSID quirk lookup for subvendor=0

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Avoid using stale array indicies to read contact count

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Ignore the confidence flag when a touch is removed

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Reset expected and received contact counts at the same time

Jann Horn <jannh@google.com>
    HID: uhid: Fix worker destroying device without any protection

Karl Kurbjun <kkurbjun@gmail.com>
    HID: Ignore battery for Elan touchscreen on HP Envy X360 15t-dr100

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: VMX: switch blocked_vcpu_on_cpu_lock to raw spinlock

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU


-------------

Diffstat:

 Documentation/admin-guide/cifs/usage.rst           |   7 +-
 Documentation/admin-guide/devices.txt              |   8 +-
 Documentation/admin-guide/hw-vuln/spectre.rst      |   2 +-
 .../bindings/display/amlogic,meson-dw-hdmi.yaml    |   5 +
 .../bindings/display/amlogic,meson-vpu.yaml        |   6 +
 .../devicetree/bindings/input/hid-over-i2c.txt     |   2 +
 .../devicetree/bindings/thermal/thermal-zones.yaml |   9 +-
 .../devicetree/bindings/watchdog/samsung-wdt.yaml  |   5 +-
 Documentation/driver-api/dmaengine/dmatest.rst     |   7 +-
 Documentation/driver-api/firewire.rst              |   4 +-
 .../acpi/dsd/data-node-references.rst              |  10 +-
 Documentation/trace/coresight/coresight-config.rst |  16 +-
 Makefile                                           |   4 +-
 arch/arm/Kconfig.debug                             |  14 +-
 arch/arm/boot/compressed/efi-header.S              |  22 +-
 arch/arm/boot/compressed/head.S                    |   3 +-
 arch/arm/boot/dts/armada-38x.dtsi                  |   4 +-
 arch/arm/boot/dts/gemini-nas4220b.dts              |   2 +-
 arch/arm/boot/dts/omap3-n900.dts                   |  50 +-
 arch/arm/boot/dts/qcom-sdx55.dtsi                  |   6 +-
 arch/arm/boot/dts/sama7g5-pinfunc.h                |   2 +-
 arch/arm/boot/dts/stm32f429-disco.dts              |   2 +-
 arch/arm/configs/cm_x300_defconfig                 |   1 -
 arch/arm/configs/ezx_defconfig                     |   1 -
 arch/arm/configs/imote2_defconfig                  |   1 -
 arch/arm/configs/nhk8815_defconfig                 |   1 -
 arch/arm/configs/pxa_defconfig                     |   1 -
 arch/arm/configs/spear13xx_defconfig               |   1 -
 arch/arm/configs/spear3xx_defconfig                |   1 -
 arch/arm/configs/spear6xx_defconfig                |   1 -
 arch/arm/include/debug/imx-uart.h                  |  18 +-
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c |   5 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   2 +-
 .../boot/dts/amlogic/meson-g12b-odroid-n2.dtsi     |   2 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi  |   3 +
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts  |  14 +-
 arch/arm64/boot/dts/marvell/cn9130.dtsi            |  15 +
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           |   2 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   5 +-
 arch/arm64/boot/dts/qcom/ipq6018.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   4 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   3 -
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   2 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |  27 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
 arch/arm64/boot/dts/renesas/cat875.dtsi            |   1 +
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi          |   6 +-
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi          |   6 +-
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi          |   6 +-
 arch/arm64/boot/dts/renesas/r8a77951.dtsi          |   6 +-
 arch/arm64/boot/dts/renesas/r8a77960.dtsi          |   6 +-
 arch/arm64/boot/dts/renesas/r8a77961.dtsi          |   6 +-
 arch/arm64/boot/dts/renesas/r8a77965.dtsi          |   6 +-
 arch/arm64/boot/dts/renesas/r8a77980.dtsi          |   4 +-
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi          |  10 +-
 arch/arm64/boot/dts/ti/k3-am642.dtsi               |   2 +-
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi          |   2 +-
 arch/arm64/boot/dts/ti/k3-j7200.dtsi               |   6 +-
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |   2 +-
 arch/arm64/boot/dts/ti/k3-j721e.dtsi               |   6 +-
 arch/arm64/include/asm/extable.h                   |   9 -
 arch/arm64/include/asm/memory.h                    |   5 +-
 arch/arm64/include/asm/mte-kasan.h                 |   8 +-
 arch/arm64/kernel/process.c                        |  39 +-
 arch/arm64/kernel/traps.c                          |   2 +-
 arch/arm64/lib/clear_page.S                        |  10 +
 arch/arm64/lib/mte.S                               |   8 +-
 arch/arm64/mm/ptdump.c                             |   2 -
 arch/arm64/net/bpf_jit_comp.c                      |   7 +-
 arch/mips/Kconfig                                  |   6 +-
 arch/mips/bcm63xx/clk.c                            |   6 +
 arch/mips/boot/compressed/Makefile                 |   2 +-
 arch/mips/boot/compressed/clz_ctz.c                |   2 +
 arch/mips/cavium-octeon/octeon-platform.c          |   2 +
 arch/mips/cavium-octeon/octeon-usb.c               |   1 +
 arch/mips/configs/fuloong2e_defconfig              |   1 -
 arch/mips/configs/malta_qemu_32r6_defconfig        |   1 -
 arch/mips/configs/maltaaprp_defconfig              |   1 -
 arch/mips/configs/maltasmvp_defconfig              |   1 -
 arch/mips/configs/maltasmvp_eva_defconfig          |   1 -
 arch/mips/configs/maltaup_defconfig                |   1 -
 .../asm/mach-loongson64/kernel-entry-init.h        |   4 +-
 arch/mips/include/asm/octeon/cvmx-bootinfo.h       |   4 +-
 arch/mips/lantiq/clk.c                             |   6 +
 arch/openrisc/include/asm/syscalls.h               |   2 +
 arch/openrisc/kernel/entry.S                       |   5 +
 arch/parisc/include/asm/special_insns.h            |  44 +-
 arch/parisc/kernel/traps.c                         |   2 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi      |   2 +
 arch/powerpc/configs/ppc6xx_defconfig              |   1 -
 arch/powerpc/configs/pseries_defconfig             |   1 -
 arch/powerpc/include/asm/hw_irq.h                  |  40 +
 arch/powerpc/kernel/btext.c                        |   4 +-
 arch/powerpc/kernel/fadump.c                       |   8 +
 arch/powerpc/kernel/head_40x.S                     |   9 +-
 arch/powerpc/kernel/interrupt.c                    |   2 +-
 arch/powerpc/kernel/interrupt_64.S                 |  10 +-
 arch/powerpc/kernel/module.c                       |  11 +-
 arch/powerpc/kernel/prom_init.c                    |   2 +-
 arch/powerpc/kernel/smp.c                          |  42 +
 arch/powerpc/kernel/watchdog.c                     |  41 +-
 arch/powerpc/kvm/book3s_hv.c                       |   8 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |   2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   4 +-
 arch/powerpc/mm/kasan/book3s_32.c                  |   3 +-
 arch/powerpc/mm/pgtable_64.c                       |  14 +-
 arch/powerpc/perf/core-book3s.c                    |  58 +-
 arch/powerpc/platforms/cell/iommu.c                |   1 +
 arch/powerpc/platforms/cell/pervasive.c            |   1 +
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |   1 +
 arch/powerpc/platforms/powermac/low_i2c.c          |   3 +
 arch/powerpc/platforms/powernv/opal-lpc.c          |   1 +
 arch/powerpc/sysdev/xive/spapr.c                   |   3 +
 arch/riscv/Kconfig                                 |  23 +-
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi  |   3 -
 arch/riscv/configs/nommu_k210_defconfig            |   2 -
 arch/riscv/configs/nommu_k210_sdcard_defconfig     |   2 -
 arch/riscv/configs/nommu_virt_defconfig            |   1 -
 arch/riscv/include/asm/smp.h                       |  10 +-
 arch/riscv/kernel/kexec_relocate.S                 |  20 +-
 arch/riscv/kernel/machine_kexec.c                  |   3 +-
 arch/riscv/kernel/setup.c                          |  10 +
 arch/riscv/kernel/smp.c                            |  10 -
 arch/riscv/mm/init.c                               |  19 +-
 arch/s390/mm/pgalloc.c                             |   4 +-
 arch/sh/configs/titan_defconfig                    |   1 -
 arch/um/.gitignore                                 |   1 +
 arch/um/drivers/virt-pci.c                         |   8 +-
 arch/um/drivers/virtio_uml.c                       |   4 +
 arch/um/include/asm/delay.h                        |   4 +-
 arch/um/include/asm/irqflags.h                     |   4 +-
 arch/um/include/shared/longjmp.h                   |   2 +-
 arch/um/include/shared/os.h                        |   4 +-
 arch/um/include/shared/registers.h                 |   4 +-
 arch/um/kernel/ksyms.c                             |   2 +-
 arch/um/os-Linux/registers.c                       |   4 +-
 arch/um/os-Linux/sigio.c                           |   6 +-
 arch/um/os-Linux/signal.c                          |   8 +-
 arch/um/os-Linux/start_up.c                        |   2 +-
 arch/x86/boot/compressed/Makefile                  |   7 +-
 arch/x86/configs/i386_defconfig                    |   1 +
 arch/x86/configs/x86_64_defconfig                  |   1 +
 arch/x86/crypto/aesni-intel_glue.c                 |   4 +-
 arch/x86/include/asm/realmode.h                    |   1 +
 arch/x86/include/asm/topology.h                    |   2 +-
 arch/x86/include/asm/uaccess.h                     |   5 +-
 arch/x86/kernel/cpu/mce/core.c                     |  42 +-
 arch/x86/kernel/cpu/mce/inject.c                   |   2 +-
 arch/x86/kernel/early-quirks.c                     |  10 +-
 arch/x86/kernel/reboot.c                           |  12 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   6 +-
 arch/x86/kvm/vmx/posted_intr.c                     |  16 +-
 arch/x86/realmode/init.c                           |  26 +
 arch/x86/um/syscalls_64.c                          |   3 +-
 block/bfq-iosched.c                                |  44 +-
 block/blk-flush.c                                  |   4 +-
 block/blk-pm.c                                     |  22 +-
 block/genhd.c                                      |  15 +-
 block/mq-deadline.c                                |   4 +-
 crypto/jitterentropy.c                             |   3 +-
 drivers/acpi/acpica/exfield.c                      |   7 +-
 drivers/acpi/acpica/exoparg1.c                     |   3 +-
 drivers/acpi/acpica/hwesleep.c                     |   4 +-
 drivers/acpi/acpica/hwsleep.c                      |   4 +-
 drivers/acpi/acpica/hwxfsleep.c                    |   2 -
 drivers/acpi/acpica/utdelete.c                     |   1 +
 drivers/acpi/battery.c                             |  22 +
 drivers/acpi/bus.c                                 |   4 +-
 drivers/acpi/cppc_acpi.c                           |   2 +-
 drivers/acpi/ec.c                                  |  57 +-
 drivers/acpi/internal.h                            |   2 +
 drivers/acpi/scan.c                                |  13 +-
 drivers/acpi/x86/utils.c                           | 116 ++-
 drivers/android/binder.c                           |  98 ++-
 drivers/base/core.c                                |   3 +-
 drivers/base/power/runtime.c                       |  41 +-
 drivers/base/property.c                            |   4 +-
 drivers/base/regmap/regmap.c                       |   1 +
 drivers/base/swnode.c                              |   2 +-
 drivers/block/floppy.c                             |   6 +-
 drivers/bluetooth/btintel.c                        |  26 +-
 drivers/bluetooth/btmtksdio.c                      |   2 +
 drivers/bluetooth/btusb.c                          |   5 +
 drivers/bluetooth/hci_bcm.c                        |   7 +-
 drivers/bluetooth/hci_qca.c                        |   9 +-
 drivers/bluetooth/hci_vhci.c                       |   2 +
 drivers/bluetooth/virtio_bt.c                      |   3 +
 drivers/bus/mhi/core/init.c                        |   1 +
 drivers/bus/mhi/core/pm.c                          |  35 +-
 drivers/bus/mhi/pci_generic.c                      |   2 +-
 drivers/char/mwave/3780i.h                         |   2 +-
 drivers/char/random.c                              |  19 +-
 drivers/char/tpm/tpm-chip.c                        |  18 +-
 drivers/char/tpm/tpm_tis_core.c                    |  14 +-
 drivers/clk/bcm/clk-bcm2835.c                      |  13 +-
 drivers/clk/clk-bm1880.c                           |  20 +-
 drivers/clk/clk-si5341.c                           |   2 +-
 drivers/clk/clk-stm32f4.c                          |   4 -
 drivers/clk/clk.c                                  |  18 +
 drivers/clk/imx/clk-imx8mn.c                       |   6 +-
 drivers/clk/meson/gxbb.c                           |  44 +-
 drivers/clk/qcom/gcc-sc7280.c                      |   2 +-
 drivers/clk/renesas/rzg2l-cpg.c                    |  17 +-
 drivers/cpufreq/cpufreq.c                          |   4 +-
 drivers/cpufreq/qcom-cpufreq-hw.c                  |   7 +-
 drivers/crypto/atmel-aes.c                         |   6 +-
 drivers/crypto/caam/caamalg.c                      |   6 +
 drivers/crypto/caam/caamalg_qi2.c                  |   2 +-
 drivers/crypto/caam/caamhash.c                     |   3 +
 drivers/crypto/caam/caampkc.c                      |   3 +
 drivers/crypto/ccp/sev-dev.c                       |  30 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   2 +-
 drivers/crypto/hisilicon/qm.c                      |   2 +-
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |   9 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |   3 +-
 drivers/crypto/omap-aes.c                          |   2 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  45 +-
 drivers/crypto/qce/aead.c                          |   2 +-
 drivers/crypto/qce/sha.c                           |   2 +-
 drivers/crypto/qce/skcipher.c                      |   2 +-
 drivers/crypto/stm32/stm32-crc32.c                 |   4 +-
 drivers/crypto/stm32/stm32-cryp.c                  | 938 ++++++++-------------
 drivers/crypto/stm32/stm32-hash.c                  |   6 +-
 drivers/cxl/pmem.c                                 |  17 +-
 drivers/dma-buf/dma-fence-array.c                  |   6 +-
 drivers/dma/at_xdmac.c                             |  57 +-
 drivers/dma/idxd/device.c                          |  12 +-
 drivers/dma/mmp_pdma.c                             |   6 -
 drivers/dma/pxa_dma.c                              |   7 -
 drivers/dma/stm32-mdma.c                           |   2 +-
 drivers/dma/uniphier-xdmac.c                       |   5 +-
 drivers/edac/synopsys_edac.c                       |   3 +-
 drivers/firmware/efi/efi-init.c                    |   5 +
 drivers/firmware/google/Kconfig                    |   6 +-
 drivers/firmware/sysfb_simplefb.c                  |   8 +-
 drivers/gpio/gpio-aspeed-sgpio.c                   |  32 +-
 drivers/gpio/gpio-aspeed.c                         |  52 +-
 drivers/gpio/gpio-idt3243x.c                       |   4 +-
 drivers/gpio/gpio-mpc8xxx.c                        |   4 +-
 drivers/gpio/gpiolib-acpi.c                        |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   4 +
 drivers/gpu/drm/amd/amdgpu/cik.c                   |   4 +
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |   4 +
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |  13 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   4 +
 drivers/gpu/drm/amd/amdgpu/vi.c                    |   4 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               | 138 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   5 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   2 +
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |   3 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   6 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c  |  14 +-
 drivers/gpu/drm/bridge/display-connector.c         |   2 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |  40 +-
 .../gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c    |  10 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-audio.h    |   4 +-
 .../gpu/drm/bridge/synopsys/dw-hdmi-i2s-audio.c    |   9 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |  12 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   1 +
 drivers/gpu/drm/drm_dp_helper.c                    |  40 +-
 drivers/gpu/drm/drm_drv.c                          |   9 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   6 +
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |   1 +
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |   4 +-
 drivers/gpu/drm/i915/display/intel_ddi_buf_trans.c |  10 +-
 drivers/gpu/drm/lima/lima_device.c                 |   1 +
 drivers/gpu/drm/msm/Kconfig                        |   1 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   4 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |  10 +-
 drivers/gpu/drm/msm/dsi/dsi.h                      |   1 -
 drivers/gpu/drm/msm/dsi/dsi_manager.c              |  17 -
 drivers/gpu/drm/msm/msm_gem_submit.c               |   2 +-
 drivers/gpu/drm/nouveau/dispnv04/disp.c            |   4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c     |  37 +-
 .../gpu/drm/panel/panel-feiyang-fy07024di26a30d.c  |   8 +-
 drivers/gpu/drm/panel/panel-innolux-p079zca.c      |  10 +-
 drivers/gpu/drm/panel/panel-jdi-lt070me05000.c     |   8 +-
 drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c |   8 +-
 drivers/gpu/drm/panel/panel-novatek-nt36672a.c     |   8 +-
 .../gpu/drm/panel/panel-panasonic-vvx10f034n00.c   |   8 +-
 drivers/gpu/drm/panel/panel-ronbo-rb070d30.c       |   8 +-
 .../drm/panel/panel-samsung-s6e88a0-ams452ef01.c   |   1 +
 drivers/gpu/drm/panel/panel-samsung-sofef00.c      |   1 +
 drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c    |   8 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |  42 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |  20 +-
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |  82 +-
 drivers/gpu/drm/tegra/drm.c                        |  15 +
 drivers/gpu/drm/tegra/gr2d.c                       |  33 +-
 drivers/gpu/drm/tegra/submit.c                     |   4 +-
 drivers/gpu/drm/tegra/vic.c                        |   7 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   2 +
 drivers/gpu/drm/vboxvideo/vbox_main.c              |   4 +-
 drivers/gpu/drm/vc4/vc4_crtc.c                     |  31 +-
 drivers/gpu/drm/vc4/vc4_drv.h                      |  29 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     | 136 ++-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |  26 +-
 drivers/gpu/drm/vc4/vc4_kms.c                      |   3 +-
 drivers/gpu/drm/vc4/vc4_txp.c                      |   4 +-
 drivers/gpu/drm/vmwgfx/Makefile                    |   3 +-
 drivers/gpu/drm/vmwgfx/ttm_memory.c                |  99 +--
 drivers/gpu/drm/vmwgfx/ttm_memory.h                |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c                |   7 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |  48 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  20 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c                |  12 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_system_manager.c     |  90 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_thp.c                | 184 ----
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c         |  58 +-
 drivers/gpu/host1x/Kconfig                         |   1 +
 drivers/gpu/host1x/dev.c                           |  15 +
 drivers/hid/hid-apple.c                            |   2 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-input.c                            |   8 +
 drivers/hid/hid-magicmouse.c                       |  95 ++-
 drivers/hid/hid-uclogic-params.c                   |  31 +-
 drivers/hid/hid-vivaldi.c                          |  34 +-
 drivers/hid/i2c-hid/i2c-hid-acpi.c                 |   2 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   4 +-
 drivers/hid/i2c-hid/i2c-hid-of-goodix.c            |   2 +-
 drivers/hid/i2c-hid/i2c-hid-of.c                   |  10 +-
 drivers/hid/i2c-hid/i2c-hid.h                      |   2 +-
 drivers/hid/uhid.c                                 |  29 +-
 drivers/hid/wacom_wac.c                            |  39 +-
 drivers/hsi/hsi_core.c                             |   1 +
 drivers/hwmon/mr75203.c                            |   2 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |   8 +-
 drivers/i2c/busses/i2c-i801.c                      |  15 +-
 drivers/i2c/busses/i2c-mpc.c                       |  23 +-
 drivers/iio/adc/ti-adc081c.c                       |  22 +-
 drivers/iio/industrialio-trigger.c                 |  36 +-
 drivers/infiniband/core/cma.c                      |  18 +-
 drivers/infiniband/core/device.c                   |   3 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   6 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   1 -
 drivers/infiniband/hw/cxgb4/qp.c                   |   1 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |   5 +-
 drivers/infiniband/hw/qedr/verbs.c                 |   2 +
 drivers/infiniband/sw/rxe/rxe_opcode.c             |   2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   2 +-
 drivers/interconnect/qcom/icc-rpm.c                |   1 +
 drivers/iommu/amd/amd_iommu_types.h                |   2 -
 drivers/iommu/amd/init.c                           | 107 +--
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   2 +-
 drivers/iommu/io-pgtable-arm-v7s.c                 |   6 +-
 drivers/iommu/io-pgtable-arm.c                     |   9 +-
 drivers/iommu/iommu.c                              |   3 +-
 drivers/iommu/iova.c                               |   3 +-
 drivers/irqchip/irq-gic-v3.c                       |  16 +
 drivers/leds/leds-lp55xx-common.c                  |   4 +-
 drivers/mailbox/mailbox-mpfs.c                     |   2 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   2 +-
 drivers/md/dm.c                                    |   4 +-
 drivers/md/md.c                                    |  27 +-
 drivers/md/md.h                                    |   2 +
 drivers/md/persistent-data/dm-btree.c              |   8 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   5 +
 drivers/md/raid0.c                                 |  38 +-
 drivers/md/raid5.c                                 |  41 +-
 drivers/media/Kconfig                              |   8 +-
 drivers/media/cec/core/cec-adap.c                  |  38 +-
 drivers/media/cec/core/cec-api.c                   |   6 +
 drivers/media/cec/core/cec-core.c                  |   3 +
 drivers/media/cec/core/cec-pin.c                   |  31 +-
 drivers/media/common/saa7146/saa7146_fops.c        |   2 +-
 .../media/common/videobuf2/videobuf2-dma-contig.c  |   8 +-
 drivers/media/dvb-core/dmxdev.c                    |  18 +-
 drivers/media/dvb-frontends/dib8000.c              |   4 +-
 drivers/media/i2c/imx274.c                         |   5 +
 drivers/media/i2c/ov8865.c                         |  16 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |   3 +
 drivers/media/pci/saa7146/hexium_gemini.c          |   7 +-
 drivers/media/pci/saa7146/hexium_orion.c           |   8 +-
 drivers/media/pci/saa7146/mxb.c                    |   8 +-
 drivers/media/platform/aspeed-video.c              |  14 +-
 drivers/media/platform/coda/coda-common.c          |   8 +-
 drivers/media/platform/coda/coda-jpeg.c            |  21 +-
 drivers/media/platform/coda/imx-vdoa.c             |   6 +-
 drivers/media/platform/imx-pxp.c                   |   4 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |   2 +-
 drivers/media/platform/qcom/venus/core.c           |  11 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |  32 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |  18 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |  15 +-
 .../media/platform/rockchip/rkisp1/rkisp1-dev.c    |   2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   3 +-
 drivers/media/rc/igorplugusb.c                     |   4 +-
 drivers/media/rc/mceusb.c                          |   8 +-
 drivers/media/rc/redrat3.c                         |  22 +-
 drivers/media/tuners/msi001.c                      |   7 +
 drivers/media/tuners/si2157.c                      |   2 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |  10 +-
 drivers/media/usb/b2c2/flexcop-usb.h               |  12 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |   4 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   2 -
 drivers/media/usb/dvb-usb/dw2102.c                 | 338 +++++---
 drivers/media/usb/dvb-usb/m920x.c                  |  12 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  18 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   8 +-
 drivers/media/usb/s2255/s2255drv.c                 |   4 +-
 drivers/media/usb/stk1160/stk1160-core.c           |   4 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   4 +-
 drivers/memory/renesas-rpc-if.c                    |   2 +-
 drivers/mfd/atmel-flexcom.c                        |  11 +-
 drivers/mfd/tps65910.c                             |  22 +-
 drivers/misc/eeprom/at25.c                         |  13 +-
 drivers/misc/habanalabs/common/firmware_if.c       |  17 +-
 drivers/misc/habanalabs/common/habanalabs.h        |   2 +
 drivers/misc/lattice-ecp3-config.c                 |  12 +-
 drivers/misc/lkdtm/Makefile                        |   2 +-
 drivers/misc/mei/hbm.c                             |  20 +-
 drivers/mmc/core/sdio.c                            |   4 +-
 drivers/mmc/host/meson-mx-sdhc-mmc.c               |   5 +
 drivers/mmc/host/meson-mx-sdio.c                   |   5 +
 drivers/mmc/host/mtk-sd.c                          |  64 +-
 drivers/mmc/host/sdhci-pci-gli.c                   |  11 +
 drivers/mmc/host/tmio_mmc_core.c                   |  15 +-
 drivers/mtd/hyperbus/rpc-if.c                      |   8 +-
 drivers/mtd/mtdcore.c                              |   4 +-
 drivers/mtd/mtdpart.c                              |   2 +-
 drivers/mtd/nand/raw/davinci_nand.c                |  73 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |  37 +-
 drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c    |   5 +
 drivers/mtd/nand/raw/nand_base.c                   |  67 ++
 drivers/net/bonding/bond_main.c                    |  40 +-
 drivers/net/can/flexcan.c                          | 150 ++--
 drivers/net/can/rcar/rcar_canfd.c                  |   5 +-
 drivers/net/can/softing/softing_cs.c               |   2 +-
 drivers/net/can/softing/softing_fw.c               |  11 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   6 +-
 drivers/net/can/xilinx_can.c                       |   7 +-
 drivers/net/dsa/hirschmann/hellcreek.c             |  87 +-
 drivers/net/ethernet/broadcom/bnxt/Makefile        |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c | 372 ++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h |  51 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 355 +-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h  |  43 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h     |   3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  10 +-
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c  |   3 +-
 drivers/net/ethernet/cortina/gemini.c              |   9 +-
 drivers/net/ethernet/freescale/fman/mac.c          |  21 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |  28 +-
 drivers/net/ethernet/i825xx/sni_82596.c            |   3 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   4 +-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |   2 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  55 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  36 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   5 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 120 ++-
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   8 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |   5 +-
 drivers/net/ethernet/mellanox/mlxsw/cmd.h          |  12 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |   7 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  31 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |  15 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |   6 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   6 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |   3 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |   7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +
 drivers/net/ethernet/ti/cpsw.c                     |   6 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   6 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 135 +--
 drivers/net/ipa/ipa_endpoint.c                     |   7 +-
 drivers/net/phy/marvell.c                          |  62 +-
 drivers/net/phy/mdio_bus.c                         |   2 +-
 drivers/net/phy/micrel.c                           |  36 +-
 drivers/net/phy/phy-core.c                         |   2 +-
 drivers/net/phy/sfp.c                              |  25 +-
 drivers/net/ppp/ppp_generic.c                      |   7 +-
 drivers/net/usb/mcs7830.c                          |  12 +-
 drivers/net/usb/smsc95xx.c                         |   3 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   4 +
 drivers/net/wireless/ath/ath10k/core.c             |  19 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   3 +
 drivers/net/wireless/ath/ath10k/hw.h               |   3 +
 drivers/net/wireless/ath/ath10k/txrx.c             |   2 -
 drivers/net/wireless/ath/ath11k/ahb.c              |  28 +-
 drivers/net/wireless/ath/ath11k/core.c             |  27 +-
 drivers/net/wireless/ath/ath11k/core.h             |  15 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   3 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   2 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  22 +
 drivers/net/wireless/ath/ath11k/hal.h              |   2 +
 drivers/net/wireless/ath/ath11k/hw.c               |   2 -
 drivers/net/wireless/ath/ath11k/mac.c              |  52 +-
 drivers/net/wireless/ath/ath11k/pci.c              |  22 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   2 +-
 drivers/net/wireless/ath/ath11k/reg.c              | 103 +--
 drivers/net/wireless/ath/ath11k/wmi.c              |   5 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   7 +
 drivers/net/wireless/ath/ath9k/htc.h               |   2 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  13 +
 drivers/net/wireless/ath/ath9k/wmi.c               |   4 +
 drivers/net/wireless/ath/wcn36xx/dxe.c             |  49 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  34 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |  10 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |  41 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  17 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  17 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  27 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  23 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  36 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   7 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |   1 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |   8 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   4 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   8 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   6 -
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   1 -
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   2 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |   2 +
 drivers/net/wireless/realtek/rtw88/main.c          |   2 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |  61 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   2 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |   4 +
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   9 +-
 drivers/net/wireless/rsi/rsi_usb.h                 |   2 +
 drivers/net/wwan/mhi_wwan_mbim.c                   |   4 +-
 drivers/nvmem/core.c                               |   2 +
 drivers/of/base.c                                  |  11 +-
 drivers/of/fdt.c                                   |  25 +-
 drivers/of/unittest.c                              |  21 +-
 drivers/parisc/pdc_stable.c                        |   4 +-
 drivers/pci/controller/pci-aardvark.c              |   4 +-
 drivers/pci/controller/pci-mvebu.c                 |   8 +
 drivers/pci/controller/pci-xgene.c                 |   2 +-
 drivers/pci/hotplug/pciehp.h                       |   3 +
 drivers/pci/hotplug/pciehp_core.c                  |   2 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |  28 +-
 drivers/pci/msi.c                                  |  26 +-
 drivers/pci/pci-bridge-emul.c                      |  70 +-
 drivers/pci/quirks.c                               |   3 +
 drivers/pcmcia/cs.c                                |   8 +-
 drivers/pcmcia/rsrc_nonstatic.c                    |   6 +
 drivers/perf/arm-cmn.c                             |   5 +-
 drivers/phy/cadence/phy-cadence-sierra.c           |  31 +-
 drivers/phy/mediatek/phy-mtk-mipi-dsi.c            |   2 +
 drivers/phy/mediatek/phy-mtk-tphy.c                | 162 ++++
 drivers/phy/socionext/phy-uniphier-usb3ss.c        |  10 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   2 +-
 drivers/power/reset/mt6323-poweroff.c              |   3 +
 drivers/ptp/ptp_vclock.c                           |  10 +-
 drivers/regulator/da9121-regulator.c               |   5 +
 drivers/regulator/qcom-labibb-regulator.c          |   2 +-
 drivers/regulator/qcom_smd-regulator.c             | 100 ++-
 drivers/remoteproc/imx_rproc.c                     |   1 +
 drivers/rpmsg/rpmsg_core.c                         |  20 +-
 drivers/rtc/rtc-cmos.c                             |   3 +
 drivers/rtc/rtc-pxa.c                              |   4 +
 drivers/scsi/lpfc/lpfc.h                           |   2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  62 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  11 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   8 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   8 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   6 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   6 -
 drivers/scsi/mpi3mr/mpi3mr.h                       |   3 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   4 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |   4 +-
 drivers/scsi/scsi.c                                |   4 +-
 drivers/scsi/scsi_debugfs.c                        |   1 +
 drivers/scsi/scsi_pm.c                             |   2 +-
 drivers/scsi/sr.c                                  |   2 +-
 drivers/scsi/sr_vendor.c                           |   4 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c                 |   1 -
 drivers/scsi/ufs/ufs-mediatek.c                    |   2 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |   2 -
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 -
 drivers/scsi/ufs/ufshcd.c                          |  22 +-
 drivers/soc/imx/gpcv2.c                            |   2 +-
 drivers/soc/mediatek/mtk-scpsys.c                  |  15 +-
 drivers/soc/qcom/cpr.c                             |   2 +-
 drivers/soc/ti/pruss.c                             |   2 +-
 drivers/spi/spi-hisi-kunpeng.c                     |  15 +-
 drivers/spi/spi-meson-spifc.c                      |   1 +
 drivers/spi/spi-uniphier.c                         |  11 +-
 drivers/spi/spi.c                                  |  13 +-
 drivers/staging/greybus/audio_topology.c           |  15 +
 drivers/staging/media/atomisp/i2c/ov2680.h         |  24 -
 drivers/staging/media/atomisp/pci/atomisp_cmd.c    |  82 +-
 drivers/staging/media/atomisp/pci/atomisp_fops.c   |  11 +
 .../media/atomisp/pci/atomisp_gmin_platform.c      |   2 +-
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c  | 188 ++++-
 drivers/staging/media/atomisp/pci/atomisp_subdev.c |  15 +-
 drivers/staging/media/atomisp/pci/atomisp_subdev.h |   3 +
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c   |  13 +-
 drivers/staging/media/atomisp/pci/atomisp_v4l2.h   |   3 +-
 drivers/staging/media/atomisp/pci/sh_css.c         |  27 +-
 drivers/staging/media/atomisp/pci/sh_css_mipi.c    |  41 +-
 drivers/staging/media/atomisp/pci/sh_css_params.c  |   8 +-
 drivers/staging/media/hantro/hantro_drv.c          |   3 +-
 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c  |   2 +-
 drivers/staging/media/hantro/hantro_hw.h           |   3 +-
 .../media/hantro/rockchip_vpu2_hw_jpeg_enc.c       |  17 +
 drivers/staging/media/hantro/rockchip_vpu_hw.c     |   5 +-
 drivers/staging/rtl8192e/rtllib.h                  |   2 +-
 drivers/staging/rtl8192e/rtllib_module.c           |  16 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |   6 +-
 drivers/tee/tee_core.c                             |   4 +-
 drivers/thermal/imx8mm_thermal.c                   |   3 +
 drivers/thermal/imx_thermal.c                      | 145 ++--
 drivers/thunderbolt/acpi.c                         |  13 +
 drivers/tty/mxser.c                                |   5 +-
 drivers/tty/serial/8250/8250_bcm7271.c             |  11 +-
 drivers/tty/serial/amba-pl010.c                    |   3 -
 drivers/tty/serial/amba-pl011.c                    |  29 +-
 drivers/tty/serial/atmel_serial.c                  |  14 +
 drivers/tty/serial/imx.c                           |   7 +-
 drivers/tty/serial/liteuart.c                      |   2 +-
 drivers/tty/serial/serial_core.c                   |   7 +-
 drivers/tty/serial/stm32-usart.c                   |   6 +-
 drivers/tty/serial/uartlite.c                      |   2 +-
 drivers/uio/uio_dmem_genirq.c                      |   6 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/dwc2/gadget.c                          |  13 +-
 drivers/usb/dwc2/hcd.c                             |   7 +-
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |  17 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |   7 +-
 drivers/usb/gadget/function/f_fs.c                 |   4 +-
 drivers/usb/gadget/function/u_audio.c              |   4 +-
 drivers/usb/host/ehci-brcm.c                       |   6 +-
 drivers/usb/host/uhci-platform.c                   |   3 +-
 drivers/usb/misc/ftdi-elan.c                       |   1 +
 drivers/vdpa/ifcvf/ifcvf_base.c                    |  41 +-
 drivers/vdpa/ifcvf/ifcvf_base.h                    |   9 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |  24 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   6 +-
 drivers/video/backlight/qcom-wled.c                | 122 +--
 drivers/virtio/virtio_mem.c                        |   2 +-
 drivers/virtio/virtio_ring.c                       |   4 +-
 drivers/w1/slaves/w1_ds28e04.c                     |  26 +-
 drivers/xen/gntdev.c                               |   6 +-
 fs/btrfs/backref.c                                 |  21 +-
 fs/btrfs/ctree.c                                   |  19 +-
 fs/btrfs/inode.c                                   |  11 +
 fs/btrfs/qgroup.c                                  |  19 +
 fs/debugfs/file.c                                  |   2 +-
 fs/dlm/lock.c                                      |   9 +
 fs/dlm/lowcomms.c                                  |  44 +-
 fs/ext4/ext4.h                                     |   1 +
 fs/ext4/ext4_jbd2.c                                |   2 +
 fs/ext4/extents.c                                  |   2 -
 fs/ext4/fast_commit.c                              |  18 +-
 fs/ext4/inode.c                                    |  51 +-
 fs/ext4/ioctl.c                                    |   2 -
 fs/ext4/mballoc.c                                  |  48 +-
 fs/ext4/migrate.c                                  |  23 +-
 fs/ext4/super.c                                    |  27 +-
 fs/f2fs/checkpoint.c                               |   4 +-
 fs/f2fs/compress.c                                 |  50 +-
 fs/f2fs/data.c                                     |   7 +-
 fs/f2fs/f2fs.h                                     |  11 +
 fs/f2fs/file.c                                     |  10 +-
 fs/f2fs/gc.c                                       |   8 +-
 fs/f2fs/inode.c                                    |   5 +
 fs/f2fs/segment.h                                  |   3 +-
 fs/f2fs/super.c                                    |  44 +
 fs/f2fs/sysfs.c                                    |   4 +-
 fs/fuse/file.c                                     |   2 +-
 fs/io_uring.c                                      |   1 +
 fs/jffs2/file.c                                    |  40 +-
 fs/ksmbd/connection.c                              |   1 +
 fs/ksmbd/connection.h                              |   4 +-
 fs/ksmbd/ksmbd_netlink.h                           |  12 +-
 fs/ksmbd/smb2misc.c                                |  18 +-
 fs/ksmbd/smb2ops.c                                 |  16 +-
 fs/ksmbd/smb2pdu.c                                 |  87 +-
 fs/ksmbd/smb2pdu.h                                 |   1 +
 fs/ksmbd/smb_common.h                              |   1 +
 fs/ksmbd/transport_ipc.c                           |   2 +
 fs/ksmbd/transport_tcp.c                           |   3 +-
 fs/ubifs/super.c                                   |   1 -
 fs/udf/ialloc.c                                    |   2 +
 include/acpi/acpi_bus.h                            |   5 +-
 include/acpi/actypes.h                             |  10 +-
 include/asm-generic/bitops/find.h                  |   5 +
 include/linux/blk-pm.h                             |   2 +-
 include/linux/bpf_verifier.h                       |   7 +
 include/linux/hid.h                                |   2 +
 include/linux/iio/trigger.h                        |   2 +
 include/linux/ipv6.h                               |   2 +
 include/linux/mmzone.h                             |   9 +
 include/linux/mtd/rawnand.h                        |   2 +
 include/linux/of_fdt.h                             |   2 +
 include/linux/pm_runtime.h                         |   3 +
 include/linux/psi_types.h                          |  13 +-
 include/linux/ptp_clock_kernel.h                   |  12 +-
 include/linux/skbuff.h                             |   7 +-
 include/linux/stmmac.h                             |   1 +
 include/media/cec.h                                |  11 +-
 include/net/inet_frag.h                            |  11 +-
 include/net/ipv6_frag.h                            |   3 +-
 include/net/pkt_sched.h                            |   5 +-
 include/net/sch_generic.h                          |   5 +
 include/net/seg6.h                                 |  21 +
 include/net/xfrm.h                                 |   7 +-
 include/sound/hda_codec.h                          |   8 +-
 include/trace/events/cgroup.h                      |  12 +-
 include/uapi/linux/xfrm.h                          |   1 +
 kernel/audit.c                                     |  18 +-
 kernel/bpf/btf.c                                   |   3 +-
 kernel/bpf/inode.c                                 |  14 +-
 kernel/bpf/verifier.c                              |  28 +-
 kernel/dma/pool.c                                  |   4 +-
 kernel/rcu/rcutorture.c                            |   5 +
 kernel/rcu/tree_exp.h                              |   1 +
 kernel/sched/cpuacct.c                             |  79 +-
 kernel/sched/cputime.c                             |   4 +-
 kernel/sched/fair.c                                |   4 +-
 kernel/sched/psi.c                                 |  45 +-
 kernel/sched/rt.c                                  |  23 +-
 kernel/sched/stats.h                               |   5 +-
 kernel/time/clocksource.c                          |  50 +-
 kernel/trace/bpf_trace.c                           |   6 +-
 kernel/trace/trace_kprobe.c                        |   5 +-
 kernel/trace/trace_osnoise.c                       |  20 +-
 kernel/trace/trace_syscalls.c                      |   6 +-
 kernel/tsacct.c                                    |   7 +-
 lib/kunit/test.c                                   |  18 +-
 lib/logic_iomem.c                                  |  19 +-
 lib/mpi/mpi-mod.c                                  |   2 +
 lib/test_hmm.c                                     |  24 +
 lib/test_meminit.c                                 |   1 +
 mm/hmm.c                                           |   5 +-
 mm/page_alloc.c                                    |  19 +-
 mm/shmem.c                                         |  37 +-
 net/ax25/af_ax25.c                                 |  10 +-
 net/batman-adv/netlink.c                           |  30 +-
 net/bluetooth/cmtp/core.c                          |   4 +-
 net/bluetooth/hci_core.c                           |   1 +
 net/bluetooth/hci_event.c                          |  14 +-
 net/bluetooth/hci_request.c                        |   2 +-
 net/bluetooth/hci_sysfs.c                          |   2 +
 net/bluetooth/l2cap_sock.c                         |  45 +-
 net/bluetooth/mgmt.c                               | 248 +++---
 net/bridge/br_netfilter_hooks.c                    |   7 +-
 net/core/dev.c                                     |   6 +
 net/core/devlink.c                                 |   2 -
 net/core/filter.c                                  |   8 +-
 net/core/flow_dissector.c                          |   3 +-
 net/core/net-sysfs.c                               |   3 +
 net/core/net_namespace.c                           |   4 +-
 net/core/sock.c                                    |   2 +
 net/core/sock_map.c                                |  21 +-
 net/dsa/switch.c                                   |   4 +-
 net/ipv4/fib_semantics.c                           |  47 +-
 net/ipv4/inet_fragment.c                           |   8 +-
 net/ipv4/ip_fragment.c                             |   3 +-
 net/ipv4/ip_gre.c                                  |   5 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   5 +-
 net/ipv4/tcp_bpf.c                                 |  27 +
 net/ipv6/icmp.c                                    |   6 +-
 net/ipv6/ip6_gre.c                                 |   5 +-
 net/ipv6/seg6.c                                    |  59 ++
 net/ipv6/seg6_local.c                              |  33 +-
 net/ipv6/udp.c                                     |   3 +-
 net/mac80211/rx.c                                  |   2 +-
 net/mptcp/options.c                                |  10 +-
 net/mptcp/pm_netlink.c                             |  18 +-
 net/netfilter/nft_payload.c                        |   3 +
 net/netfilter/nft_set_pipapo.c                     |   8 +
 net/netrom/af_netrom.c                             |  12 +-
 net/nfc/llcp_sock.c                                |   5 +
 net/openvswitch/flow.c                             |  20 +-
 net/sched/act_ct.c                                 |   7 +
 net/sched/cls_api.c                                |   3 +
 net/sched/cls_flower.c                             |   3 +-
 net/sched/sch_api.c                                |   2 +-
 net/sched/sch_generic.c                            |   1 +
 net/smc/af_smc.c                                   |   8 +-
 net/smc/smc_core.c                                 |  29 +-
 net/smc/smc_core.h                                 |   2 +-
 net/socket.c                                       |   9 +-
 net/unix/garbage.c                                 |  14 +-
 net/unix/scm.c                                     |   6 +-
 net/xfrm/xfrm_compat.c                             |   6 +-
 net/xfrm/xfrm_interface.c                          |  14 +-
 net/xfrm/xfrm_output.c                             |  30 +-
 net/xfrm/xfrm_policy.c                             |  24 +-
 net/xfrm/xfrm_state.c                              |  23 +-
 net/xfrm/xfrm_user.c                               |  41 +-
 samples/bpf/Makefile                               |  56 +-
 samples/bpf/Makefile.target                        |  11 -
 samples/bpf/hbm_kern.h                             |   2 -
 samples/bpf/lwt_len_hist_kern.c                    |   7 -
 samples/bpf/xdp_sample_user.h                      |   2 +
 scripts/dtc/dtx_diff                               |   8 +-
 scripts/sphinx-pre-install                         |   3 +
 security/selinux/hooks.c                           |  12 +-
 sound/core/jack.c                                  |   3 +
 sound/core/misc.c                                  |   2 +-
 sound/core/oss/pcm_oss.c                           |   2 +-
 sound/core/pcm.c                                   |   6 +-
 sound/core/seq/seq_queue.c                         |  14 +-
 sound/hda/hdac_stream.c                            |  14 +-
 sound/pci/hda/hda_bind.c                           |   5 +
 sound/pci/hda/hda_codec.c                          |  45 +-
 sound/pci/hda/hda_controller.c                     |   1 -
 sound/pci/hda/hda_local.h                          |   1 +
 sound/pci/hda/patch_cs8409-tables.c                |   3 +
 sound/pci/hda/patch_cs8409.c                       |   9 +-
 sound/pci/hda/patch_cs8409.h                       |   1 +
 sound/soc/codecs/Kconfig                           |   3 +-
 sound/soc/codecs/rt5663.c                          |  12 +-
 sound/soc/fsl/fsl_asrc.c                           |  69 +-
 sound/soc/fsl/fsl_mqs.c                            |   2 +-
 sound/soc/fsl/imx-card.c                           |  32 +-
 sound/soc/fsl/imx-hdmi.c                           |   2 +
 sound/soc/intel/boards/sof_sdw.c                   |   2 +-
 sound/soc/intel/catpt/dsp.c                        |  14 +-
 sound/soc/intel/skylake/skl-pcm.c                  |   1 -
 sound/soc/mediatek/mt8173/mt8173-max98090.c        |   3 +
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |   2 +
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c   |   2 +
 sound/soc/mediatek/mt8173/mt8173-rt5650.c          |   2 +
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |   6 +-
 .../mt8183/mt8183-mt6358-ts3a227-max98357.c        |   7 +-
 .../mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c  |   6 +-
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c         |   2 +-
 sound/soc/mediatek/mt8195/mt8195-dai-pcm.c         |  73 +-
 sound/soc/mediatek/mt8195/mt8195-reg.h             |   1 +
 sound/soc/samsung/idma.c                           |   2 +
 sound/soc/uniphier/Kconfig                         |   2 -
 sound/usb/format.c                                 |   2 +-
 sound/usb/mixer_quirks.c                           |   2 +-
 sound/usb/quirks.c                                 |   2 +-
 tools/bpf/bpftool/Documentation/Makefile           |   1 -
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   6 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   8 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |   6 +-
 tools/bpf/bpftool/Makefile                         |   1 -
 tools/bpf/bpftool/main.c                           |   2 +
 tools/bpf/bpftool/prog.c                           |  15 +-
 tools/include/nolibc/nolibc.h                      |  33 +-
 tools/lib/bpf/btf.c                                |  55 +-
 tools/lib/bpf/btf.h                                |   2 +-
 tools/lib/bpf/btf_dump.c                           |   2 +-
 tools/lib/bpf/gen_loader.c                         |   4 +-
 tools/lib/bpf/libbpf.c                             |   9 +-
 tools/lib/bpf/linker.c                             |   6 +-
 tools/perf/Makefile.config                         |   5 +-
 tools/perf/util/debug.c                            |   2 +-
 tools/perf/util/evsel.c                            |  25 +-
 tools/perf/util/probe-event.c                      |   3 +
 tools/testing/selftests/bpf/btf_helpers.c          |   9 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   5 +-
 .../selftests/bpf/prog_tests/migrate_reuseport.c   |   4 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   2 +
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   7 +
 tools/testing/selftests/clone3/clone3.c            |   6 +
 .../selftests/ftrace/test.d/kprobe/profile.tc      |   2 +-
 tools/testing/selftests/kselftest_harness.h        |   2 +-
 .../selftests/powerpc/security/spectre_v2.c        |   2 +-
 tools/testing/selftests/powerpc/signal/.gitignore  |   1 +
 tools/testing/selftests/powerpc/signal/Makefile    |   1 +
 .../selftests/powerpc/signal/sigreturn_kernel.c    | 132 +++
 tools/testing/selftests/vm/hmm-tests.c             |  42 +
 896 files changed, 9019 insertions(+), 5115 deletions(-)


