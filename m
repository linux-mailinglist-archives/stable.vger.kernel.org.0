Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF6A644351
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiLFMmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbiLFMmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:42:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082EC222AE;
        Tue,  6 Dec 2022 04:41:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 951D1616FB;
        Tue,  6 Dec 2022 12:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAC1C433C1;
        Tue,  6 Dec 2022 12:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670330515;
        bh=eT7GiH8dkMv1jsz/wY2uwTqf37FapMpo8rNsnmU3roU=;
        h=From:To:Cc:Subject:Date:From;
        b=QkNwLI+RhGJjWEzMvkx7aqpQmUYGbZyLihhJlTHtgKJD7r2kBINAE7n83K7IrgMMX
         qmAz+pU/3zPxXMTwa01q449A4/uLkwiVzfjGsgBh4UTmZnUYqa3i3lWCtDxBaIn+IL
         Y306YZ5HgkOia89XnmGZu2taoCDc0e4EdRny4iPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.14 00/83] 4.14.301-rc2 review
Date:   Tue,  6 Dec 2022 13:41:52 +0100
Message-Id: <20221206124046.347571765@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.301-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.301-rc2
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

This is the start of the stable review cycle for the 4.14.301 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.301-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.301-rc2

Ben Hutchings <ben@decadent.org.uk>
    Revert "x86/speculation: Change FILL_RETURN_BUFFER to work with objtool"

Peter Zijlstra <peterz@infradead.org>
    x86/nospec: Fix i386 RSB stuffing

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

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iommu/vt-d: Fix PCI device refcount leak in dmar_dev_scope_init()

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    pinctrl: single: Fix potential division by zero

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix bounds check for _sx controls

Ben Hutchings <ben@decadent.org.uk>
    efi: random: Properly limit the size of the random seed

James Morse <james.morse@arm.com>
    arm64: errata: Fix KVM Spectre-v2 mitigation selection for Cortex-A57/A72

James Morse <james.morse@arm.com>
    arm64: Fix panic() when Spectre-v2 causes Spectre-BHB to re-allocate KVM vectors

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Make sure MSR_SPEC_CTRL is updated properly upon resume from S3

ZhangPeng <zhangpeng362@huawei.com>
    nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()

Tiezhu Yang <yangtiezhu@loongson.cn>
    tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"

ChenXiaoSong <chenxiaosong2@huawei.com>
    btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()

Kan Liang <kan.liang@linux.intel.com>
    perf: Add sample_flags to indicate the PMU-filled sample data

Sam James <sam@gentoo.org>
    kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()

Phil Auld <pauld@redhat.com>
    hwmon: (coretemp) Check for null before removing sysfs attrs

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed

Willem de Bruijn <willemb@google.com>
    packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

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

Paul Gazzillo <paul@pgazz.com>
    iio: light: rpr0521: add missing Kconfig dependencies

Wei Yongjun <weiyongjun1@huawei.com>
    iio: health: afe4404: Fix oob read in afe4404_[read|write]_raw

Wei Yongjun <weiyongjun1@huawei.com>
    iio: health: afe4403: Fix oob read in afe4403_read_raw

Christian König <christian.koenig@amd.com>
    drm/amdgpu: always register an MMU notifier for userptr

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

Masahiro Yamada <yamada.masahiro@socionext.com>
    kconfig: display recursive dependency resolution hint just once

Chen Zhongjin <chenzhongjin@huawei.com>
    iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails

Alejandro Concepción Rodríguez <asconcepcion@acoro.eu>
    iio: light: apds9960: fix wrong register for gesture gain

Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
    arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency

Randy Dunlap <rdunlap@infradead.org>
    nios2: add FORCE for vmlinuz.gz

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

Liu Shixin <liushixin2@huawei.com>
    NFC: nci: fix memory leak in nci_rx_data_packet()

Chen Zhongjin <chenzhongjin@huawei.com>
    xfrm: Fix ignored return value in xfrm6_init()

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

Dominik Haller <d.haller@phytec.de>
    ARM: dts: am335x-pcm-953: Define fixed regulators in root node

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Fix send_acquire race with pfkey_register

Jason A. Donenfeld <Jason@zx2c4.com>
    MIPS: pic32: treat port as signed integer

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
 arch/s390/kernel/crash_dump.c                      |  2 +-
 arch/x86/include/asm/cpufeatures.h                 |  1 +
 arch/x86/include/asm/nospec-branch.h               | 26 ++++++--
 arch/x86/kernel/cpu/bugs.c                         | 21 ++++---
 arch/x86/kernel/cpu/tsx.c                          | 33 +++++-----
 arch/x86/kernel/process.c                          |  2 +-
 arch/x86/mm/ioremap.c                              |  8 ++-
 arch/x86/power/cpu.c                               | 23 ++++---
 drivers/bus/sunxi-rsb.c                            | 29 ++++++---
 drivers/firmware/efi/efi.c                         |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  8 +--
 drivers/hwmon/coretemp.c                           |  9 ++-
 drivers/hwmon/i5500_temp.c                         |  2 +-
 drivers/hwmon/ibmpex.c                             |  1 +
 drivers/iio/health/afe4403.c                       |  5 +-
 drivers/iio/health/afe4404.c                       | 12 ++--
 drivers/iio/industrialio-sw-trigger.c              |  6 +-
 drivers/iio/light/Kconfig                          |  2 +
 drivers/iio/light/apds9960.c                       | 12 ++--
 drivers/input/mouse/synaptics.c                    |  1 +
 drivers/iommu/dmar.c                               |  1 +
 drivers/mmc/host/sdhci.c                           | 71 ++++++++++++++++++----
 drivers/mmc/host/sdhci.h                           | 12 ++--
 drivers/net/can/cc770/cc770_isa.c                  | 10 +--
 drivers/net/can/sja1000/sja1000_isa.c              | 10 +--
 drivers/net/dsa/lan9303-core.c                     |  2 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  4 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |  1 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |  1 +
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  1 +
 drivers/net/ntb_netdev.c                           |  9 ++-
 drivers/net/phy/phy_device.c                       |  1 +
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/wireless/mac80211_hwsim.c              |  5 ++
 drivers/nfc/st-nci/se.c                            |  6 +-
 drivers/nvme/host/core.c                           |  6 ++
 drivers/of/property.c                              |  4 +-
 drivers/pinctrl/pinctrl-single.c                   |  2 +-
 drivers/platform/x86/acer-wmi.c                    |  9 +++
 drivers/platform/x86/asus-wmi.c                    |  2 +
 drivers/platform/x86/hp-wmi.c                      |  3 +
 drivers/s390/block/dasd_eckd.c                     |  6 +-
 drivers/spi/spi-stm32.c                            |  2 +-
 drivers/tty/serial/8250/8250_omap.c                |  7 ++-
 drivers/xen/platform-pci.c                         |  7 ++-
 fs/btrfs/qgroup.c                                  |  9 +--
 fs/nilfs2/dat.c                                    |  7 +++
 fs/nilfs2/sufile.c                                 |  8 +++
 include/linux/license.h                            |  2 +
 include/linux/perf_event.h                         |  2 +
 include/uapi/linux/audit.h                         |  2 +-
 ipc/sem.c                                          |  3 +-
 kernel/events/core.c                               | 17 ++++--
 kernel/sysctl.c                                    | 30 ++++-----
 mm/frame_vector.c                                  | 31 ++--------
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
 scripts/kconfig/symbol.c                           |  8 ++-
 sound/soc/soc-ops.c                                |  2 +-
 tools/vm/slabinfo-gnuplot.sh                       |  4 +-
 87 files changed, 482 insertions(+), 243 deletions(-)


