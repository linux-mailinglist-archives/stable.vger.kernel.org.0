Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB4F643137
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiLETMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiLETMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:12:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C61ADF4D;
        Mon,  5 Dec 2022 11:12:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A0BD61311;
        Mon,  5 Dec 2022 19:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD03C433C1;
        Mon,  5 Dec 2022 19:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267533;
        bh=0D3+8goR9JU4xEkgTSnHSatjxq2oTCINVE2PAiUrDhY=;
        h=From:To:Cc:Subject:Date:From;
        b=cGGE5HdQO063zcF6gJSmz0XdkiU0h8daTSylLFAAjKGt76A8vgTKQeGdzGFVXTI8G
         7f/HQdsqqDSdKzjMfZCMSjtqLveVg0jKe4KZhb1SvVePqgalF1hda8gncIXqLhbmqj
         vtGZNRtDSYp+nXMWwBM6djilUsz3Hwib4JMrjYAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.9 00/62] 4.9.335-rc1 review
Date:   Mon,  5 Dec 2022 20:08:57 +0100
Message-Id: <20221205190758.073114639@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.335-rc1
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

This is the start of the stable review cycle for the 4.9.335 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.335-rc1

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

Ulrich Hecht <uli+cip@fpond.eu>
    Revert "fbdev: fb_pm2fb: Avoid potential divide by zero error"

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/udp: Fix memory leak in ipv6_renew_options().

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iommu/vt-d: Fix PCI device refcount leak in dmar_dev_scope_init()

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    pinctrl: single: Fix potential division by zero

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix bounds check for _sx controls

James Morse <james.morse@arm.com>
    arm64: errata: Fix KVM Spectre-v2 mitigation selection for Cortex-A57/A72

James Morse <james.morse@arm.com>
    arm64: Fix panic() when Spectre-v2 causes Spectre-BHB to re-allocate KVM vectors

ZhangPeng <zhangpeng362@huawei.com>
    nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()

Tiezhu Yang <yangtiezhu@loongson.cn>
    tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"

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

YueHaibing <yuehaibing@huawei.com>
    net: hsr: Fix potential use-after-free

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

Gaosheng Cui <cuigaosheng1@huawei.com>
    hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (i5500_temp) fix missing pci_disable_device()

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

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()

ruanjinjie <ruanjinjie@huawei.com>
    xen/platform-pci: add missing free_irq() in error path

Lukas Wunner <lukas@wunner.de>
    serial: 8250: 8250_omap: Avoid RS485 RTS glitch on ->set_termios()

Chen Zhongjin <chenzhongjin@huawei.com>
    nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty

Randy Dunlap <rdunlap@infradead.org>
    nios2: add FORCE for vmlinuz.gz

Masahiro Yamada <yamada.masahiro@socionext.com>
    kconfig: display recursive dependency resolution hint just once

Chen Zhongjin <chenzhongjin@huawei.com>
    iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails

Alejandro Concepción Rodríguez <asconcepcion@acoro.eu>
    iio: light: apds9960: fix wrong register for gesture gain

Heiko Carstens <hca@linux.ibm.com>
    s390/crashdump: fix TOD programmable field size

Yu Liao <liaoyu15@huawei.com>
    net: thunderx: Fix the ACPI memory leak

Martin Faltesek <mfaltesek@google.com>
    nfc: st-nci: fix memory leaks in EVT_TRANSACTION

Martin Faltesek <mfaltesek@google.com>
    nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION

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

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Fix send_acquire race with pfkey_register

Jason A. Donenfeld <Jason@zx2c4.com>
    MIPS: pic32: treat port as signed integer

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    wifi: mac80211: Fix ack frame idr leak when mesh has no route

Gaosheng Cui <cuigaosheng1@huawei.com>
    audit: fix undefined behavior in bit shift for AUDIT_BIT

Jonas Jelonek <jelonek.jonas@gmail.com>
    wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |  9 +++
 arch/arm/mach-mxs/mach-mxs.c                       |  4 +-
 arch/arm64/kernel/cpu_errata.c                     | 25 +++++---
 arch/mips/include/asm/fw/fw.h                      |  2 +-
 arch/mips/pic32/pic32mzda/early_console.c          | 13 ++--
 arch/mips/pic32/pic32mzda/init.c                   |  2 +-
 arch/nios2/boot/Makefile                           |  2 +-
 arch/s390/kernel/crash_dump.c                      |  2 +-
 arch/x86/include/asm/cpufeatures.h                 |  1 +
 arch/x86/kernel/cpu/tsx.c                          | 33 +++++-----
 arch/x86/mm/ioremap.c                              |  8 ++-
 arch/x86/power/cpu.c                               | 23 ++++---
 drivers/bus/sunxi-rsb.c                            | 29 ++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  8 +--
 drivers/hwmon/coretemp.c                           |  9 ++-
 drivers/hwmon/i5500_temp.c                         |  2 +-
 drivers/hwmon/ibmpex.c                             |  1 +
 drivers/iio/health/afe4403.c                       |  5 +-
 drivers/iio/health/afe4404.c                       | 12 ++--
 drivers/iio/industrialio-sw-trigger.c              |  6 +-
 drivers/iio/light/apds9960.c                       | 12 ++--
 drivers/iommu/dmar.c                               |  1 +
 drivers/mmc/host/sdhci.c                           | 71 ++++++++++++++++++----
 drivers/mmc/host/sdhci.h                           | 12 ++--
 drivers/net/can/cc770/cc770_isa.c                  | 10 +--
 drivers/net/can/sja1000/sja1000_isa.c              | 10 +--
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
 drivers/pinctrl/pinctrl-single.c                   |  2 +-
 drivers/platform/x86/asus-wmi.c                    |  2 +
 drivers/tty/serial/8250/8250_omap.c                |  7 ++-
 drivers/video/fbdev/pm2fb.c                        |  5 --
 drivers/xen/platform-pci.c                         |  7 ++-
 fs/btrfs/qgroup.c                                  |  9 +--
 fs/nilfs2/dat.c                                    |  7 +++
 fs/nilfs2/sufile.c                                 |  8 +++
 include/uapi/linux/audit.h                         |  2 +-
 net/9p/trans_fd.c                                  |  6 +-
 net/bluetooth/l2cap_core.c                         | 13 ++++
 net/hsr/hsr_forward.c                              |  5 +-
 net/ipv4/Kconfig                                   | 10 +++
 net/ipv4/inet_hashtables.c                         | 10 +--
 net/ipv6/ipv6_sockglue.c                           |  7 +++
 net/ipv6/xfrm6_policy.c                            |  6 +-
 net/key/af_key.c                                   | 32 +++++++---
 net/mac80211/mesh_pathtbl.c                        |  2 +-
 net/nfc/nci/core.c                                 |  2 +-
 net/nfc/nci/data.c                                 |  4 +-
 net/packet/af_packet.c                             |  6 +-
 scripts/kconfig/symbol.c                           |  8 ++-
 sound/soc/soc-ops.c                                |  2 +-
 tools/vm/slabinfo-gnuplot.sh                       |  4 +-
 63 files changed, 358 insertions(+), 164 deletions(-)


