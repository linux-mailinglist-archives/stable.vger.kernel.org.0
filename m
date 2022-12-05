Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5675C643219
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiLETYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbiLETYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:24:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9C22B63F;
        Mon,  5 Dec 2022 11:19:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEB9A61309;
        Mon,  5 Dec 2022 19:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E05C433C1;
        Mon,  5 Dec 2022 19:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267962;
        bh=K7632touSShg40TOOwS6DiOFQGkfKN9gwGuexrAVAuo=;
        h=From:To:Cc:Subject:Date:From;
        b=uQ3ON/SNVMdrJ0Cz0QhhVKMyIRDULOPb7925ecapttPjkFqJTuz3R41KG7hxIQFi6
         QuVe6Y0+CRzjkD6/HOo4Gup3TziKnyNzlrWgrUrLQBfZ+tY/I8yXUC+icbybQDl/Vk
         cdOIdCsnW8Fc5/Tx1pWCHHgQmtLyNf9cuJikAl/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.19 000/105] 4.19.268-rc1 review
Date:   Mon,  5 Dec 2022 20:08:32 +0100
Message-Id: <20221205190803.124472741@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.268-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.268-rc1
X-KernelTest-Deadline: 2022-12-07T19:08+00:00
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

This is the start of the stable review cycle for the 4.19.268 release.
There are 105 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.268-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.268-rc1

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix voltage switch delay

Masahiro Yamada <yamada.masahiro@socionext.com>
    mmc: sdhci: use FIELD_GET for preset value bit masks

Michael Kelley <mikelley@microsoft.com>
    x86/ioremap: Fix page aligned size calculation in __ioremap_caller()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/pm: Add enumeration check before spec MSRs save/restore setup

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/tsx: Add a feature bit for TSX control MSR support

Keith Busch <kbusch@kernel.org>
    nvme: restrict management ioctls to admin

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/udp: Fix memory leak in ipv6_renew_options().

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

ChenXiaoSong <chenxiaosong2@huawei.com>
    btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()

Phil Auld <pauld@redhat.com>
    hwmon: (coretemp) Check for null before removing sysfs attrs

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed

Willem de Bruijn <willemb@google.com>
    packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

Shigeru Yoshida <syoshida@redhat.com>
    net: tun: Fix use-after-free in tun_detach()

YueHaibing <yuehaibing@huawei.com>
    net: hsr: Fix potential use-after-free

Jerry Ray <jerry.ray@microchip.com>
    dsa: lan9303: Correct stat name

Wang Hai <wanghai38@huawei.com>
    net/9p: Fix a potential socket leak in p9_socket_open

Yuan Can <yuancan@huawei.com>
    net: net_netdev: Fix error handling in ntb_netdev_init_module()

Yang Yingliang <yangyingliang@huawei.com>
    net: phy: fix null-ptr-deref while probe() failed

Duoming Zhou <duoming@zju.edu.cn>
    qlcnic: fix sleep-in-atomic-context bugs caused by msleep

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: cc770: cc770_isa_probe(): add missing free_cc770dev()

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()

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

Sam James <sam@gentoo.org>
    kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible

Frieder Schrempf <frieder.schrempf@kontron.de>
    spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying inodes to userspace

Christian König <christian.koenig@amd.com>
    drm/amdgpu: always register an MMU notifier for userptr

Lyude Paul <lyude@redhat.com>
    drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying subvol info to userspace

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying fspath to userspace

Josef Bacik <josef@toxicpanda.com>
    btrfs: free btrfs_path before copying root refs to userspace

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

Aman Dhoot <amandhoot12@gmail.com>
    Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode

Chen Zhongjin <chenzhongjin@huawei.com>
    nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty

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

Chen Zhongjin <chenzhongjin@huawei.com>
    iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails

Alejandro Concepción Rodríguez <asconcepcion@acoro.eu>
    iio: light: apds9960: fix wrong register for gesture gain

Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
    arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency

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

Michael Grzeschik <m.grzeschik@pengutronix.de>
    ARM: dts: at91: sam9g20ek: enable udc vbus gpio pinctrl

Samuel Holland <samuel@sholland.org>
    bus: sunxi-rsb: Support atomic transfers

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


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/am335x-pcm-953.dtsi              | 28 ++++-----
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |  9 +++
 arch/arm/mach-mxs/mach-mxs.c                       |  4 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |  2 +-
 arch/arm64/kernel/cpu_errata.c                     | 24 ++++++--
 arch/mips/include/asm/fw/fw.h                      |  2 +-
 arch/mips/pic32/pic32mzda/early_console.c          | 13 ++--
 arch/mips/pic32/pic32mzda/init.c                   |  2 +-
 arch/nios2/boot/Makefile                           |  2 +-
 arch/riscv/kernel/vdso/Makefile                    |  3 +
 arch/riscv/kernel/vdso/vdso.lds.S                  |  2 +
 arch/s390/kernel/crash_dump.c                      |  2 +-
 arch/x86/include/asm/cpufeatures.h                 |  1 +
 arch/x86/include/asm/nospec-branch.h               |  2 +-
 arch/x86/kernel/cpu/bugs.c                         | 21 ++++---
 arch/x86/kernel/cpu/tsx.c                          | 33 +++++-----
 arch/x86/kernel/process.c                          |  2 +-
 arch/x86/mm/ioremap.c                              |  8 ++-
 arch/x86/power/cpu.c                               | 23 ++++---
 drivers/bus/sunxi-rsb.c                            | 29 ++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  8 +--
 .../drm/amd/display/dc/dce120/dce120_resource.c    |  3 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  6 ++
 drivers/hv/channel_mgmt.c                          |  6 +-
 drivers/hv/vmbus_drv.c                             |  1 +
 drivers/hwmon/coretemp.c                           |  9 ++-
 drivers/hwmon/i5500_temp.c                         |  2 +-
 drivers/hwmon/ibmpex.c                             |  1 +
 drivers/iio/health/afe4403.c                       |  5 +-
 drivers/iio/health/afe4404.c                       | 12 ++--
 drivers/iio/industrialio-sw-trigger.c              |  6 +-
 drivers/iio/light/Kconfig                          |  2 +
 drivers/iio/light/apds9960.c                       | 12 ++--
 drivers/iio/pressure/ms5611.h                      | 18 +++---
 drivers/iio/pressure/ms5611_core.c                 | 56 +++++++++--------
 drivers/iio/pressure/ms5611_i2c.c                  | 11 ++--
 drivers/iio/pressure/ms5611_spi.c                  | 17 +++---
 drivers/input/mouse/synaptics.c                    |  1 +
 drivers/iommu/dmar.c                               |  1 +
 drivers/md/dm-integrity.c                          |  7 +--
 drivers/mmc/host/sdhci.c                           | 71 ++++++++++++++++++----
 drivers/mmc/host/sdhci.h                           | 12 ++--
 drivers/net/can/cc770/cc770_isa.c                  | 10 +--
 drivers/net/can/sja1000/sja1000_isa.c              | 10 +--
 drivers/net/dsa/lan9303-core.c                     |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  | 12 ++--
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  4 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  2 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |  6 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |  1 +
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  1 +
 drivers/net/ntb_netdev.c                           |  9 ++-
 drivers/net/phy/phy_device.c                       |  1 +
 drivers/net/tun.c                                  |  4 +-
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/wireless/mac80211_hwsim.c              |  5 ++
 drivers/nfc/st-nci/se.c                            |  6 +-
 drivers/nvme/host/core.c                           |  6 ++
 drivers/of/property.c                              |  4 +-
 drivers/pinctrl/intel/pinctrl-intel.c              | 27 +++++++-
 drivers/pinctrl/pinctrl-single.c                   |  2 +-
 drivers/platform/x86/acer-wmi.c                    |  9 +++
 drivers/platform/x86/asus-wmi.c                    |  2 +
 drivers/platform/x86/hp-wmi.c                      |  3 +
 drivers/s390/block/dasd_eckd.c                     |  6 +-
 drivers/spi/spi-imx.c                              |  3 +-
 drivers/spi/spi-stm32.c                            |  2 +-
 drivers/tty/serial/8250/8250_omap.c                |  7 ++-
 drivers/xen/platform-pci.c                         |  7 ++-
 fs/btrfs/ioctl.c                                   | 23 ++++---
 fs/btrfs/qgroup.c                                  |  9 +--
 fs/ceph/snap.c                                     | 31 +++++++---
 fs/nilfs2/dat.c                                    |  7 +++
 fs/nilfs2/sufile.c                                 |  8 +++
 include/linux/license.h                            |  2 +
 include/linux/mmdebug.h                            |  2 +-
 include/uapi/linux/audit.h                         |  2 +-
 lib/Kconfig.debug                                  | 14 ++++-
 net/9p/trans_fd.c                                  |  6 +-
 net/bluetooth/l2cap_core.c                         | 13 ++++
 net/dccp/ipv4.c                                    |  2 +
 net/dccp/ipv6.c                                    |  2 +
 net/hsr/hsr_forward.c                              |  5 +-
 net/ipv4/Kconfig                                   | 10 +++
 net/ipv4/inet_hashtables.c                         | 10 +--
 net/ipv4/tcp_ipv4.c                                |  2 +
 net/ipv6/ipv6_sockglue.c                           |  7 +++
 net/ipv6/tcp_ipv6.c                                |  2 +
 net/ipv6/xfrm6_policy.c                            |  6 +-
 net/key/af_key.c                                   | 32 +++++++---
 net/mac80211/mesh_pathtbl.c                        |  2 +-
 net/nfc/nci/core.c                                 |  2 +-
 net/nfc/nci/data.c                                 |  4 +-
 net/packet/af_packet.c                             |  6 +-
 net/tipc/discover.c                                |  5 +-
 net/tipc/topsrv.c                                  | 20 +++---
 scripts/faddr2line                                 |  7 ++-
 sound/soc/codecs/sgtl5000.c                        |  1 +
 sound/soc/soc-ops.c                                |  2 +-
 tools/vm/slabinfo-gnuplot.sh                       |  4 +-
 104 files changed, 596 insertions(+), 298 deletions(-)


