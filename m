Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72063644353
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbiLFMm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbiLFMmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:42:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151D72A24F;
        Tue,  6 Dec 2022 04:42:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97C95B81A10;
        Tue,  6 Dec 2022 12:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F519C43470;
        Tue,  6 Dec 2022 12:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670330529;
        bh=F2vVy8mTCADDaxIIY4IoycYKLLwSfhhJP8tJWgNauEM=;
        h=From:To:Cc:Subject:Date:From;
        b=Mjk62KieEWQqq0rpbfg2KhRwN/FWqmSWT/lFvu51wtg3DEQvAiHtk2fZSfgAi3KMS
         Nkq7JP1q1ql0g+NwQIzq4GgNSC+nuMb8XP8G9tO6xVtjxbIvKyJLQWpJ3HIXVZqZLK
         jIJuivzmpgjjxf6Le3PyYUtCa2fyeUKH5cd/aHl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 000/157] 5.4.226-rc2 review
Date:   Tue,  6 Dec 2022 13:42:06 +0100
Message-Id: <20221206124054.310184563@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.226-rc2
X-KernelTest-Deadline: 2022-12-08T12:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.226 release.
There are 157 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.226-rc2

Jann Horn <jannh@google.com>
    ipc/sem: Fix dangling sem_array access in semtimedop race

Linus Torvalds <torvalds@linux-foundation.org>
    v4l2: don't fall back to follow_pfn() if pin_user_pages_fast() fails

Linus Torvalds <torvalds@linux-foundation.org>
    proc: proc_skip_spaces() shouldn't think it is working on C strings

Linus Torvalds <torvalds@linux-foundation.org>
    proc: avoid integer type confusion in get_proc_long

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix voltage switch delay

Masahiro Yamada <yamada.masahiro@socionext.com>
    mmc: sdhci: use FIELD_GET for preset value bit masks

Jan Dabros <jsd@semihalf.com>
    char: tpm: Protect tpm_pm_suspend with locks

Conor Dooley <conor.dooley@microchip.com>
    Revert "clocksource/drivers/riscv: Events are stopped during CPU suspend"

Michael Kelley <mikelley@microsoft.com>
    x86/ioremap: Fix page aligned size calculation in __ioremap_caller()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/pm: Add enumeration check before spec MSRs save/restore setup

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/tsx: Add a feature bit for TSX control MSR support

Keith Busch <kbusch@kernel.org>
    nvme: ensure subsystem reset is single threaded

Keith Busch <kbusch@kernel.org>
    nvme: restrict management ioctls to admin

Soheil Hassas Yeganeh <soheil@google.com>
    epoll: check for events when removing a timed out thread from the wait queue

Roman Penyaev <rpenyaev@suse.de>
    epoll: call final ep_events_available() check under the lock

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/ring-buffer: Have polling block on watermark

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix route deletion when nexthop info is not specified

David Ahern <dsahern@kernel.org>
    ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference

Nikolay Aleksandrov <razor@blackwall.org>
    selftests: net: fix nexthop warning cleanup double ip typo

Nikolay Aleksandrov <razor@blackwall.org>
    selftests: net: add delete nexthop route warning test

Lee Jones <lee@kernel.org>
    Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled

Helge Deller <deller@gmx.de>
    parisc: Increase FRAME_WARN to 2048 bytes on parisc

Guenter Roeck <linux@roeck-us.net>
    xtensa: increase size of gcc stack frame check

Helge Deller <deller@gmx.de>
    parisc: Increase size of gcc stack frame check

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iommu/vt-d: Fix PCI device refcount leak in dmar_dev_scope_init()

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    pinctrl: single: Fix potential division by zero

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix bounds check for _sx controls

Nathan Chancellor <nathan@kernel.org>
    mm: Fix '.data.once' orphan section warning

James Morse <james.morse@arm.com>
    arm64: errata: Fix KVM Spectre-v2 mitigation selection for Cortex-A57/A72

James Morse <james.morse@arm.com>
    arm64: Fix panic() when Spectre-v2 causes Spectre-BHB to re-allocate KVM vectors

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Free buffers when a used dynamic event is removed

Wenchao Chen <wenchao.chen@unisoc.com>
    mmc: sdhci-sprd: Fix no reset data and command after voltage switch

Sebastian Falbesoner <sebastian.falbesoner@gmail.com>
    mmc: sdhci-esdhc-imx: correct CQHCI exit halt state check

Christian Löhle <CLoehle@hyperstone.com>
    mmc: core: Fix ambiguous TRIM and DISCARD arg

Ye Bin <yebin10@huawei.com>
    mmc: mmc_test: Fix removal of debugfs file

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Save and restore pins in "direct IRQ" mode

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Make sure MSR_SPEC_CTRL is updated properly upon resume from S3

ZhangPeng <zhangpeng362@huawei.com>
    nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()

Tiezhu Yang <yangtiezhu@loongson.cn>
    tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"

Steven Rostedt (Google) <rostedt@goodmis.org>
    error-injection: Add prompt for function error injection

YueHaibing <yuehaibing@huawei.com>
    net/mlx5: DR, Fix uninitialized var warning

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()

Phil Auld <pauld@redhat.com>
    hwmon: (coretemp) Check for null before removing sysfs attrs

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed

Zhengchao Shao <shaozhengchao@huawei.com>
    sctp: fix memory leak in sctp_stream_outq_migrate()

Willem de Bruijn <willemb@google.com>
    packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

Shigeru Yoshida <syoshida@redhat.com>
    net: tun: Fix use-after-free in tun_detach()

David Howells <dhowells@redhat.com>
    afs: Fix fileserver probe RTT handling

YueHaibing <yuehaibing@huawei.com>
    net: hsr: Fix potential use-after-free

Jerry Ray <jerry.ray@microchip.com>
    dsa: lan9303: Correct stat name

Yuri Karpov <YKarpov@ispras.ru>
    net: ethernet: nixge: fix NULL dereference

Wang Hai <wanghai38@huawei.com>
    net/9p: Fix a potential socket leak in p9_socket_open

Yuan Can <yuancan@huawei.com>
    net: net_netdev: Fix error handling in ntb_netdev_init_module()

Yang Yingliang <yangyingliang@huawei.com>
    net: phy: fix null-ptr-deref while probe() failed

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix buffer overflow in elem comparison

Duoming Zhou <duoming@zju.edu.cn>
    qlcnic: fix sleep-in-atomic-context bugs caused by msleep

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: cc770: cc770_isa_probe(): add missing free_cc770dev()

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Fix use-after-free when reverting termination table

YueHaibing <yuehaibing@huawei.com>
    net/mlx5: Fix uninitialized variable bug in outlen_write()

Yang Yingliang <yangyingliang@huawei.com>
    of: property: decrement node refcount in of_fwnode_get_reference_args()

Gaosheng Cui <cuigaosheng1@huawei.com>
    hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (i5500_temp) fix missing pci_disable_device()

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    scripts/faddr2line: Fix regression in name resolution on ppc64le

Paul Gazzillo <paul@pgazz.com>
    iio: light: rpr0521: add missing Kconfig dependencies

Wei Yongjun <weiyongjun1@huawei.com>
    iio: health: afe4404: Fix oob read in afe4404_[read|write]_raw

Wei Yongjun <weiyongjun1@huawei.com>
    iio: health: afe4403: Fix oob read in afe4403_read_raw

ChenXiaoSong <chenxiaosong2@huawei.com>
    btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Partially revert "drm/amdgpu: update drm_display_info correctly when the edid is read"

Claudio Suarez <cssk@net-c.es>
    drm/amdgpu: update drm_display_info correctly when the edid is read

Sam James <sam@gentoo.org>
    kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible

Nikolay Borisov <nborisov@suse.com>
    btrfs: move QUOTA_ENABLED check to rescan_should_stop from btrfs_qgroup_rescan_worker

Frieder Schrempf <frieder.schrempf@kontron.de>
    spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying inodes to userspace

Miklos Szeredi <mszeredi@redhat.com>
    fuse: lock inode unconditionally in fuse_fallocate()

Andrzej Hajda <andrzej.hajda@intel.com>
    drm/i915: fix TLB invalidation for Gen12 video and compute engines

Christian König <christian.koenig@amd.com>
    drm/amdgpu: always register an MMU notifier for userptr

Lyude Paul <lyude@redhat.com>
    drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN

Zhen Lei <thunder.leizhen@huawei.com>
    btrfs: sysfs: normalize the error handling branch in btrfs_init_sysfs()

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying subvol info to userspace

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying fspath to userspace

Josef Bacik <josef@toxicpanda.com>
    btrfs: free btrfs_path before copying root refs to userspace

Alessandro Astone <ales.astone@gmail.com>
    binder: Gracefully handle BINDER_TYPE_FDA objects with num_fds=0

Alessandro Astone <ales.astone@gmail.com>
    binder: Address corner cases in deferred copy and fixup

Arnd Bergmann <arnd@arndb.de>
    binder: fix pointer cast warning

Todd Kjos <tkjos@google.com>
    binder: defer copies of pre-patched txn data

Todd Kjos <tkjos@google.com>
    binder: read pre-translated fds from sender buffer

Todd Kjos <tkjos@google.com>
    binder: avoid potential data leakage when copying txn

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: flush the journal on suspend

Enrico Sau <enrico.sau@gmail.com>
    net: usb: qmi_wwan: add Telit 0x103a composition

Gleb Mazovetskiy <glex.spb@gmail.com>
    tcp: configurable source port perturb table size

Kai-Heng Feng <kai.heng.feng@canonical.com>
    platform/x86: hp-wmi: Ignore Smart Experience App event

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Enable SW_TABLET_MODE on Switch V 10 (SW5-017)

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()

ruanjinjie <ruanjinjie@huawei.com>
    xen/platform-pci: add missing free_irq() in error path

Lukas Wunner <lukas@wunner.de>
    serial: 8250: 8250_omap: Avoid RS485 RTS glitch on ->set_termios()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcht_es8316: Add quirk for the Nanote UMPC-01

Aman Dhoot <amandhoot12@gmail.com>
    Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode

Mukesh Ojha <quic_mojha@quicinc.com>
    gcov: clang: fix the buffer overflow issue

Chen Zhongjin <chenzhongjin@huawei.com>
    nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty

Brian Norris <briannorris@chromium.org>
    firmware: coreboot: Register bus in module init

Patrick Rudolph <patrick.rudolph@9elements.com>
    firmware: google: Release devices before unregistering the bus

Xiubo Li <xiubli@redhat.com>
    ceph: avoid putting the realm twice when decoding snaps fails

Xiubo Li <xiubli@redhat.com>
    ceph: do not update snapshot context when there is no new snapshot

Mitja Spes <mitja@lxnav.com>
    iio: pressure: ms5611: fixed value compensation bug

Lars-Peter Clausen <lars@metafoo.de>
    iio: ms5611: Simplify IO callback parameters

Randy Dunlap <rdunlap@infradead.org>
    nios2: add FORCE for vmlinuz.gz

Alexandre Belloni <alexandre.belloni@bootlin.com>
    init/Kconfig: fix CC_HAS_ASM_GOTO_TIED_OUTPUT test with dash

Chen Zhongjin <chenzhongjin@huawei.com>
    iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails

Alejandro Concepción Rodríguez <asconcepcion@acoro.eu>
    iio: light: apds9960: fix wrong register for gesture gain

Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
    arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc3: exynos: Fix remove() function

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lib/vdso: use "grep -E" instead of "egrep"

Heiko Carstens <hca@linux.ibm.com>
    s390/crashdump: fix TOD programmable field size

Yu Liao <liaoyu15@huawei.com>
    net: thunderx: Fix the ACPI memory leak

Martin Faltesek <mfaltesek@google.com>
    nfc: st-nci: fix memory leaks in EVT_TRANSACTION

Martin Faltesek <mfaltesek@google.com>
    nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix no record found for raw_track_access

Kuniyuki Iwashima <kuniyu@amazon.com>
    dccp/tcp: Reset saddr on failure after inet6?_hash_connect().

Yang Yingliang <yangyingliang@huawei.com>
    bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()

Andreas Kemnade <andreas@kemnade.info>
    regulator: twl6030: re-add TWL6032_SUBCLASS

Liu Shixin <liushixin2@huawei.com>
    NFC: nci: fix memory leak in nci_rx_data_packet()

Chen Zhongjin <chenzhongjin@huawei.com>
    xfrm: Fix ignored return value in xfrm6_init()

YueHaibing <yuehaibing@huawei.com>
    tipc: check skb_linearize() return value in tipc_disc_rcv()

Xin Long <lucien.xin@gmail.com>
    tipc: add an extra conn_get in tipc_conn_alloc

Xin Long <lucien.xin@gmail.com>
    tipc: set con sock in tipc_conn_alloc

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix FW tracer timestamp calculation

Yang Yingliang <yangyingliang@huawei.com>
    Drivers: hv: vmbus: fix possible memory leak in vmbus_device_register()

Yang Yingliang <yangyingliang@huawei.com>
    Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()

Jaco Coetzee <jaco.coetzee@corigine.com>
    nfp: add port from netdev validation for EEPROM access

Yang Yingliang <yangyingliang@huawei.com>
    net: pch_gbe: fix pci device refcount leak while module exiting

Zhang Changzhong <zhangchangzhong@huawei.com>
    net/qla3xxx: fix potential memleak in ql3xxx_send()

Peter Kosyh <pkosyh@yandex.ru>
    net/mlx4: Check retval of mlx4_bitmap_init

Zheng Yongjun <zhengyongjun3@huawei.com>
    ARM: mxs: fix memory leak in mxs_machine_init()

Zhengchao Shao <shaozhengchao@huawei.com>
    9p/fd: fix issue of list_del corruption in p9_fd_cancel()

Wang Hai <wanghai38@huawei.com>
    net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()

Lin Ma <linma@zju.edu.cn>
    nfc/nci: fix race with opening and closing

Leon Romanovsky <leonro@nvidia.com>
    net: liquidio: simplify if expression

Michael Grzeschik <m.grzeschik@pengutronix.de>
    ARM: dts: at91: sam9g20ek: enable udc vbus gpio pinctrl

Yang Yingliang <yangyingliang@huawei.com>
    tee: optee: fix possible memory leak in optee_register_device()

Samuel Holland <samuel@sholland.org>
    bus: sunxi-rsb: Support atomic transfers

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix UAF in destroy_regulator()

Zeng Heng <zengheng4@huawei.com>
    regulator: core: fix kobject release warning and memory leak in regulator_register()

Detlev Casanova <detlev.casanova@collabora.com>
    ASoC: sgtl5000: Reset the CHIP_CLK_CTRL reg on remove

Dominik Haller <d.haller@phytec.de>
    ARM: dts: am335x-pcm-953: Define fixed regulators in root node

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Fix send_acquire race with pfkey_register

Jason A. Donenfeld <Jason@zx2c4.com>
    MIPS: pic32: treat port as signed integer

Nathan Chancellor <nathan@kernel.org>
    RISC-V: vdso: Do not add missing symbols to version section in linker script

Kuniyuki Iwashima <kuniyu@amazon.com>
    arm64/syscall: Include asm/ptrace.h in syscall_wrapper header.

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix null pointer dereference in bfq_bio_bfqg()

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Acer Switch V 10 (SW5-017)

Sean Nyekjaer <sean@geanix.com>
    spi: stm32: fix stm32_spi_prepare_mbr() that halves spi clk for every run

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    wifi: mac80211: Fix ack frame idr leak when mesh has no route

Gaosheng Cui <cuigaosheng1@huawei.com>
    audit: fix undefined behavior in bit shift for AUDIT_BIT

Jonas Jelonek <jelonek.jonas@gmail.com>
    wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support

taozhang <taozhang@bestechnic.com>
    wifi: mac80211: fix memory free error when registering wiphy fail


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am335x-pcm-953.dtsi              |  28 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   9 +
 arch/arm/mach-mxs/mach-mxs.c                       |   4 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |   2 +-
 arch/arm64/include/asm/syscall_wrapper.h           |   2 +-
 arch/arm64/kernel/cpu_errata.c                     |  24 +-
 arch/mips/include/asm/fw/fw.h                      |   2 +-
 arch/mips/pic32/pic32mzda/early_console.c          |  13 +-
 arch/mips/pic32/pic32mzda/init.c                   |   2 +-
 arch/nios2/boot/Makefile                           |   2 +-
 arch/riscv/kernel/vdso/Makefile                    |   3 +
 arch/riscv/kernel/vdso/vdso.lds.S                  |   2 +
 arch/s390/kernel/crash_dump.c                      |   2 +-
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/nospec-branch.h               |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |  21 +-
 arch/x86/kernel/cpu/tsx.c                          |  33 +-
 arch/x86/kernel/process.c                          |   2 +-
 arch/x86/mm/ioremap.c                              |   8 +-
 arch/x86/power/cpu.c                               |  23 +-
 block/bfq-cgroup.c                                 |   4 +
 drivers/android/binder.c                           | 437 ++++++++++++++++++---
 drivers/bus/sunxi-rsb.c                            |  29 +-
 drivers/char/tpm/tpm-interface.c                   |   5 +-
 drivers/clocksource/timer-riscv.c                  |   2 +-
 drivers/firmware/google/coreboot_table.c           |  44 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +-
 .../drm/amd/display/dc/dce120/dce120_resource.c    |   3 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/i915/gt/intel_gt.c                 |   4 +
 drivers/hv/channel_mgmt.c                          |   6 +-
 drivers/hv/vmbus_drv.c                             |   1 +
 drivers/hwmon/coretemp.c                           |   9 +-
 drivers/hwmon/i5500_temp.c                         |   2 +-
 drivers/hwmon/ibmpex.c                             |   1 +
 drivers/iio/health/afe4403.c                       |   5 +-
 drivers/iio/health/afe4404.c                       |  12 +-
 drivers/iio/industrialio-sw-trigger.c              |   6 +-
 drivers/iio/light/Kconfig                          |   2 +
 drivers/iio/light/apds9960.c                       |  12 +-
 drivers/iio/pressure/ms5611.h                      |  18 +-
 drivers/iio/pressure/ms5611_core.c                 |  56 +--
 drivers/iio/pressure/ms5611_i2c.c                  |  11 +-
 drivers/iio/pressure/ms5611_spi.c                  |  17 +-
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/iommu/dmar.c                               |   1 +
 drivers/md/dm-integrity.c                          |   7 +-
 drivers/mmc/core/core.c                            |   9 +-
 drivers/mmc/core/mmc_test.c                        |   3 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 +-
 drivers/mmc/host/sdhci-sprd.c                      |   4 +-
 drivers/mmc/host/sdhci.c                           |  71 +++-
 drivers/mmc/host/sdhci.h                           |  12 +-
 drivers/net/can/cc770/cc770_isa.c                  |  10 +-
 drivers/net/can/sja1000/sja1000_isa.c              |  10 +-
 drivers/net/dsa/lan9303-core.c                     |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |  12 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |   4 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   2 +
 .../mellanox/mlx5/core/steering/dr_table.c         |   5 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   3 +
 drivers/net/ethernet/ni/nixge.c                    |  29 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   6 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |   1 +
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   1 +
 drivers/net/ntb_netdev.c                           |   9 +-
 drivers/net/phy/phy_device.c                       |   1 +
 drivers/net/tun.c                                  |   4 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/mac80211_hwsim.c              |   5 +
 drivers/nfc/st-nci/se.c                            |   6 +-
 drivers/nvme/host/core.c                           |   6 +
 drivers/nvme/host/nvme.h                           |  16 +-
 drivers/of/property.c                              |   4 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |  27 +-
 drivers/pinctrl/pinctrl-single.c                   |   2 +-
 drivers/platform/x86/acer-wmi.c                    |   9 +
 drivers/platform/x86/asus-wmi.c                    |   2 +
 drivers/platform/x86/hp-wmi.c                      |   3 +
 drivers/regulator/core.c                           |   8 +-
 drivers/regulator/twl6030-regulator.c              |   2 +
 drivers/s390/block/dasd_eckd.c                     |   6 +-
 drivers/spi/spi-imx.c                              |   3 +-
 drivers/spi/spi-stm32.c                            |   2 +-
 drivers/tee/optee/device.c                         |   2 +-
 drivers/tty/serial/8250/8250_omap.c                |   7 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |  11 +-
 drivers/xen/platform-pci.c                         |   7 +-
 fs/afs/fs_probe.c                                  |   4 +-
 fs/btrfs/ioctl.c                                   |  23 +-
 fs/btrfs/qgroup.c                                  |  22 +-
 fs/btrfs/sysfs.c                                   |   7 +-
 fs/ceph/snap.c                                     |  31 +-
 fs/eventpoll.c                                     |  68 ++--
 fs/fuse/file.c                                     |  20 +-
 fs/nilfs2/dat.c                                    |   7 +
 fs/nilfs2/sufile.c                                 |   8 +
 include/linux/license.h                            |   2 +
 include/linux/mmc/mmc.h                            |   2 +-
 include/linux/mmdebug.h                            |   2 +-
 include/linux/ring_buffer.h                        |   2 +-
 include/net/sctp/stream_sched.h                    |   2 +
 include/uapi/linux/audit.h                         |   2 +-
 init/Kconfig                                       |   2 +-
 ipc/sem.c                                          |   3 +-
 kernel/gcov/clang.c                                |   2 +
 kernel/sysctl.c                                    |  30 +-
 kernel/trace/ring_buffer.c                         |  54 ++-
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace_dynevent.c                      |   2 +
 kernel/trace/trace_events.c                        |  11 +-
 lib/Kconfig.debug                                  |  14 +-
 lib/vdso/Makefile                                  |   2 +-
 mm/frame_vector.c                                  |  31 +-
 net/9p/trans_fd.c                                  |   6 +-
 net/bluetooth/l2cap_core.c                         |  13 +
 net/dccp/ipv4.c                                    |   2 +
 net/dccp/ipv6.c                                    |   2 +
 net/hsr/hsr_forward.c                              |   5 +-
 net/ipv4/Kconfig                                   |  10 +
 net/ipv4/fib_semantics.c                           |  10 +-
 net/ipv4/inet_hashtables.c                         |  10 +-
 net/ipv4/tcp_ipv4.c                                |   2 +
 net/ipv6/tcp_ipv6.c                                |   2 +
 net/ipv6/xfrm6_policy.c                            |   6 +-
 net/key/af_key.c                                   |  32 +-
 net/mac80211/main.c                                |   8 +-
 net/mac80211/mesh_pathtbl.c                        |   2 +-
 net/nfc/nci/core.c                                 |   2 +-
 net/nfc/nci/data.c                                 |   4 +-
 net/packet/af_packet.c                             |   6 +-
 net/sctp/stream.c                                  |  25 +-
 net/sctp/stream_sched.c                            |   5 +
 net/sctp/stream_sched_prio.c                       |  19 +
 net/sctp/stream_sched_rr.c                         |   5 +
 net/tipc/discover.c                                |   5 +-
 net/tipc/topsrv.c                                  |  20 +-
 net/wireless/scan.c                                |   3 +-
 scripts/faddr2line                                 |   7 +-
 sound/soc/codecs/sgtl5000.c                        |   1 +
 sound/soc/intel/boards/bytcht_es8316.c             |   7 +
 sound/soc/soc-ops.c                                |   2 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  30 ++
 tools/vm/slabinfo-gnuplot.sh                       |   4 +-
 152 files changed, 1325 insertions(+), 536 deletions(-)


