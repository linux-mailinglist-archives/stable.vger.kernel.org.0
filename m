Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCA455D4C3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiF0L3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbiF0L3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:29:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E327BE;
        Mon, 27 Jun 2022 04:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC952B8111E;
        Mon, 27 Jun 2022 11:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E02C3411D;
        Mon, 27 Jun 2022 11:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329287;
        bh=3edfOCAddFNfHjsc+hya8HxcP6qv1B8Tey7vkRpU2rI=;
        h=From:To:Cc:Subject:Date:From;
        b=J6ecwYLckve8RfrHcZ5WdS6sfDsOFm3lHXl2wR/CS01oIixF36El1DuJ9tY+TBfCo
         G0U8x7QSPiq2tedDm7+WVAv02hZ2W4l2kxbvbo+m8KCsfGejHbE0DZIXXbYJseXZ08
         9JXPtUDM6MzxOTb8MkNZPtpFxX/ch5X9sc5hnuCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/60] 5.4.202-rc1 review
Date:   Mon, 27 Jun 2022 13:21:11 +0200
Message-Id: <20220627111927.641837068@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.202-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.202-rc1
X-KernelTest-Deadline: 2022-06-29T11:19+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.202 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.202-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.202-rc1

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/pseries: wire up rng during setup_arch()

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: link vmlinux only once for CONFIG_TRIM_UNUSED_KSYMS (2nd attempt)

Jason A. Donenfeld <Jason@zx2c4.com>
    random: update comment from copy_to_user() -> copy_to_iter()

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix section mismatch check for exported init/exit sections

Miaoqian Lin <linmq006@gmail.com>
    ARM: cns3xxx: Fix refcount leak in cns3xxx_init

Miaoqian Lin <linmq006@gmail.com>
    ARM: Fix refcount leak in axxia_boot_secondary

Miaoqian Lin <linmq006@gmail.com>
    soc: bcm: brcmstb: pm: pm-arm: Fix refcount leak in brcmstb_pm_probe

Miaoqian Lin <linmq006@gmail.com>
    ARM: exynos: Fix refcount leak in exynos_map_pmu

Lucas Stach <l.stach@pengutronix.de>
    ARM: dts: imx6qdl: correct PU regulator ramp delay

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/powernv: wire up rng during setup_arch

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc: Enable execve syscall exit tracepoint

Helge Deller <deller@gmx.de>
    parisc: Enable ARCH_HAS_STRICT_MODULE_RWX

Liang He <windhl@126.com>
    xtensa: Fix refcount leak bug in time.c

Liang He <windhl@126.com>
    xtensa: xtfpga: Fix refcount leak bug in setup

Hans de Goede <hdegoede@redhat.com>
    iio: adc: axp288: Override TS pin bias current for some models

Olivier Moysan <olivier.moysan@foss.st.com>
    iio: adc: stm32: fix maximum clock rate for stm32mp15x

Vincent Whitchurch <vincent.whitchurch@axis.com>
    iio: trigger: sysfs: fix use-after-free on remove

Zheyu Ma <zheyuma97@gmail.com>
    iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()

Haibo Chen <haibo.chen@nxp.com>
    iio: accel: mma8452: ignore the return value of reset operation

Dmitry Rokosov <DDRokosov@sberdevices.ru>
    iio:accel:mxc4005: rearrange iio trigger get and register

Dmitry Rokosov <DDRokosov@sberdevices.ru>
    iio:accel:bma180: rearrange iio trigger get and register

Dmitry Rokosov <DDRokosov@sberdevices.ru>
    iio:chemical:ccs811: rearrange iio trigger get and register

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: check request status before setting device address

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: turn off port power in shutdown

Baruch Siach <baruch@tkos.co.il>
    iio: adc: vf610: fix conversion mode sysfs node name

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpumf: Handle events cycles and instructions identical

Dan Carpenter <dan.carpenter@oracle.com>
    gpio: winbond: Fix error code in winbond_gpio_get()

Jakub Kicinski <kuba@kernel.org>
    Revert "net/tls: fix tls_sk_proto_close executed repeatedly"

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    virtio_net: fix xdp_rxq_info bug after suspend/resume

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igb: Make DMA faster when CPU is active on the PCIe link

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    regmap-irq: Fix a bug in regmap_irq_enable() for type_in_mask chips

Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
    ice: ethtool: advertise 1000M speeds properly

David Howells <dhowells@redhat.com>
    afs: Fix dynamic root getattr

huhai <huhai@kylinos.cn>
    MIPS: Remove repetitive increase irq_err_count

Julien Grall <jgrall@amazon.com>
    x86/xen: Remove undefined behavior in setup_features()

Gerd Hoffmann <kraxel@redhat.com>
    udmabuf: add back sanity check

Ziyang Xuan <william.xuanziyang@huawei.com>
    net/tls: fix tls_sk_proto_close executed repeatedly

Eric Dumazet <edumazet@google.com>
    erspan: do not assume transport header is always set

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/mdp4: Fix refcount leak in mdp4_modeset_init_intf

Peilin Ye <peilin.ye@bytedance.com>
    net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms

Jay Vosburgh <jay.vosburgh@canonical.com>
    bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Claudiu Manoil <claudiu.manoil@nxp.com>
    phy: aquantia: Fix AN when higher speeds than 1G are not advertised

Jon Maxwell <jmaxwell37@gmail.com>
    bpf: Fix request_sock leak in sk lookup helpers

Macpaul Lin <macpaul.lin@mediatek.com>
    USB: serial: option: add Quectel RM500K module support

Yonglin Tan <yonglin.tan@outlook.com>
    USB: serial: option: add Quectel EM05-G modem

Carlo Lobrano <c.lobrano@gmail.com>
    USB: serial: option: add Telit LE910Cx 0x1250 composition

Jason A. Donenfeld <Jason@zx2c4.com>
    random: quiet urandom warning ratelimit suppression message

Mikulas Patocka <mpatocka@redhat.com>
    dm mirror log: clear log bits up to BITS_PER_LONG boundary

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: commit metadata in postsuspend after worker stops

Edward Wu <edwardwu@realtek.com>
    ata: libata: add qc->flags in ata_qc_complete_template tracepoint

Sascha Hauer <s.hauer@pengutronix.de>
    mtd: rawnand: gpmi: Fix setting busy timeout setting

Chevron Li <chevron.li@bayhubtech.com>
    mmc: sdhci-pci-o2micro: Fix card detect by dealing with debouncing

Rosemarie O'Riorden <roriorden@redhat.com>
    net: openvswitch: fix parsing of nw_proto for IPv6 fragments

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo PD70PNT

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - ALC897 headset MIC no sound

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Fix missing beep setup

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via: Fix missing beep setup

Jason A. Donenfeld <Jason@zx2c4.com>
    random: schedule mix_interrupt_randomness() less often

Jiri Slaby <jslaby@suse.cz>
    vt: drop old FONT ioctls


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio-vf610 |   2 +-
 Makefile                                      |   6 +-
 arch/arm/boot/dts/imx6qdl.dtsi                |   2 +-
 arch/arm/mach-axxia/platsmp.c                 |   1 +
 arch/arm/mach-cns3xxx/core.c                  |   2 +
 arch/arm/mach-exynos/exynos.c                 |   1 +
 arch/mips/vr41xx/common/icu.c                 |   2 -
 arch/parisc/Kconfig                           |   1 +
 arch/powerpc/kernel/process.c                 |   2 +-
 arch/powerpc/kernel/rtas.c                    |  11 +-
 arch/powerpc/platforms/powernv/powernv.h      |   2 +
 arch/powerpc/platforms/powernv/rng.c          |  52 ++++++---
 arch/powerpc/platforms/powernv/setup.c        |   2 +
 arch/powerpc/platforms/pseries/pseries.h      |   2 +
 arch/powerpc/platforms/pseries/rng.c          |  11 +-
 arch/powerpc/platforms/pseries/setup.c        |   2 +
 arch/s390/kernel/perf_cpum_cf.c               |  22 +++-
 arch/xtensa/kernel/time.c                     |   1 +
 arch/xtensa/platforms/xtfpga/setup.c          |   1 +
 drivers/base/regmap/regmap-irq.c              |   5 +-
 drivers/char/random.c                         |   6 +-
 drivers/dma-buf/udmabuf.c                     |   5 +-
 drivers/gpio/gpio-vr41xx.c                    |   2 -
 drivers/gpio/gpio-winbond.c                   |   7 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c      |   2 +
 drivers/iio/accel/bma180.c                    |   3 +-
 drivers/iio/accel/mma8452.c                   |  10 +-
 drivers/iio/accel/mxc4005.c                   |   4 +-
 drivers/iio/adc/axp288_adc.c                  |   8 ++
 drivers/iio/adc/stm32-adc-core.c              |   2 +-
 drivers/iio/chemical/ccs811.c                 |   4 +-
 drivers/iio/gyro/mpu3050-core.c               |   1 +
 drivers/iio/trigger/iio-trig-sysfs.c          |   1 +
 drivers/md/dm-era-target.c                    |   8 +-
 drivers/md/dm-log.c                           |   2 +-
 drivers/mmc/host/sdhci-pci-o2micro.c          |   2 +
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c    |   2 +-
 drivers/net/bonding/bond_main.c               |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  39 ++++++-
 drivers/net/ethernet/intel/igb/igb_main.c     |  12 +--
 drivers/net/phy/aquantia_main.c               |  15 ++-
 drivers/net/virtio_net.c                      |  25 ++---
 drivers/soc/bcm/brcmstb/pm/pm-arm.c           |   1 +
 drivers/tty/vt/vt.c                           |  39 +------
 drivers/tty/vt/vt_ioctl.c                     | 147 --------------------------
 drivers/usb/chipidea/udc.c                    |   3 +
 drivers/usb/host/xhci-hub.c                   |   2 +-
 drivers/usb/host/xhci.c                       |  15 ++-
 drivers/usb/host/xhci.h                       |   2 +
 drivers/usb/serial/option.c                   |   6 ++
 drivers/xen/features.c                        |   2 +-
 fs/afs/inode.c                                |   3 +-
 include/linux/kd.h                            |   8 --
 include/linux/ratelimit.h                     |  12 ++-
 include/trace/events/libata.h                 |   1 +
 net/core/filter.c                             |  34 ++++--
 net/ipv4/ip_gre.c                             |  15 ++-
 net/ipv6/ip6_gre.c                            |  15 ++-
 net/openvswitch/flow.c                        |   2 +-
 net/sched/sch_netem.c                         |   4 +-
 scripts/mod/modpost.c                         |   2 +-
 sound/pci/hda/patch_conexant.c                |   4 +-
 sound/pci/hda/patch_realtek.c                 |  10 ++
 sound/pci/hda/patch_via.c                     |   4 +-
 64 files changed, 315 insertions(+), 310 deletions(-)


