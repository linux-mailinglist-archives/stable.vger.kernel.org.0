Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A703355DB0A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiF0LZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiF0LY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:24:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C96DE8;
        Mon, 27 Jun 2022 04:24:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 568B6B81123;
        Mon, 27 Jun 2022 11:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCA2C3411D;
        Mon, 27 Jun 2022 11:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329092;
        bh=2alUtqTaXDZZV3w+413QtIP+vslDyRgtrnoWLTZ4Tq4=;
        h=From:To:Cc:Subject:Date:From;
        b=meSIJvv3brgiqPw2hDQNd+5s5uxyEuwNIzdyEfvd71Rni6tsvyyme6o2I9G4dgkmR
         IYLN5sTwA4cwW7ShXtdMrqqaOsBByoTs8yVghqPZZSlv0Wqb9oIrLWD/nTjWkxCISp
         6Y28+ft00D+gWyHfaLlpGcbX4JD415pDR0RPyyJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/102] 5.10.127-rc1 review
Date:   Mon, 27 Jun 2022 13:20:11 +0200
Message-Id: <20220627111933.455024953@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.127-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.127-rc1
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

This is the start of the stable review cycle for the 5.10.127 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.127-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.127-rc1

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
    memory: samsung: exynos5422-dmc: Fix refcount leak in of_get_dram_timings

Miaoqian Lin <linmq006@gmail.com>
    ARM: Fix refcount leak in axxia_boot_secondary

Miaoqian Lin <linmq006@gmail.com>
    soc: bcm: brcmstb: pm: pm-arm: Fix refcount leak in brcmstb_pm_probe

Miaoqian Lin <linmq006@gmail.com>
    ARM: exynos: Fix refcount leak in exynos_map_pmu

Lucas Stach <l.stach@pengutronix.de>
    ARM: dts: imx6qdl: correct PU regulator ramp delay

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx7: Move hsic_phy power domain to HSIC PHY node

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/powernv: wire up rng during setup_arch

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc: Enable execve syscall exit tracepoint

Helge Deller <deller@gmx.de>
    parisc: Enable ARCH_HAS_STRICT_MODULE_RWX

Helge Deller <deller@gmx.de>
    parisc/stifb: Fix fb_is_primary_device() only available with CONFIG_FB_STI

Liang He <windhl@126.com>
    xtensa: Fix refcount leak bug in time.c

Liang He <windhl@126.com>
    xtensa: xtfpga: Fix refcount leak bug in setup

Miaoqian Lin <linmq006@gmail.com>
    iio: adc: adi-axi-adc: Fix refcount leak in adi_axi_adc_attach_client

Hans de Goede <hdegoede@redhat.com>
    iio: adc: axp288: Override TS pin bias current for some models

Yannick Brosseau <yannick.brosseau@gmail.com>
    iio: adc: stm32: Fix IRQs on STM32F4 by removing custom spurious IRQs message

Yannick Brosseau <yannick.brosseau@gmail.com>
    iio: adc: stm32: Fix ADCs iteration in irq handler

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: Fix broken icm42600 (chip id 0 value)

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

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: attach inline_data after setting compression

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: check request status before setting device address

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: Fix double-free bug in raw_gadget driver

Alan Stern <stern@rowland.harvard.edu>
    usb: gadget: Fix non-unique driver names in raw-gadget driver

Utkarsh Patel <utkarsh.h.patel@intel.com>
    xhci-pci: Allow host runtime PM as default for Intel Meteor Lake xHCI

Tanveer Alam <tanveer1.alam@intel.com>
    xhci-pci: Allow host runtime PM as default for Intel Raptor Lake xHCI

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: turn off port power in shutdown

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: typec: wcove: Drop wrong dependency to INTEL_SOC_PMIC

Baruch Siach <baruch@tkos.co.il>
    iio: adc: vf610: fix conversion mode sysfs node name

Haibo Chen <haibo.chen@nxp.com>
    iio: mma8452: fix probe fail when device tree compatible is used.

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpumf: Handle events cycles and instructions identical

Dan Carpenter <dan.carpenter@oracle.com>
    gpio: winbond: Fix error code in winbond_gpio_get()

Christoph Hellwig <hch@lst.de>
    nvme: move the Samsung X5 quirk entry to the core quirks

Enzo Matsumiya <ematsumiya@suse.de>
    nvme-pci: add NO APST quirk for Kioxia device

Keith Busch <kbusch@kernel.org>
    nvme-pci: allocate nvme_command within driver pdu

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme: don't check nvme_req flags for new req

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme: mark nvme_setup_passsthru() inline

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme: split nvme_alloc_request()

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme: centralize setting the timeout in nvme_alloc_request

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

Jie2x Zhou <jie2x.zhou@intel.com>
    selftests: netfilter: correct PKTGEN_SCRIPT_PATHS in nft_concat_range.sh

Gerd Hoffmann <kraxel@redhat.com>
    udmabuf: add back sanity check

Ziyang Xuan <william.xuanziyang@huawei.com>
    net/tls: fix tls_sk_proto_close executed repeatedly

Eric Dumazet <edumazet@google.com>
    erspan: do not assume transport header is always set

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: fix connect/disconnect handled at irq_hpd

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: promote irq_hpd handle to handle link training correctly

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: deinitialize mainlink if link training failed

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: fixes wrong connection state caused by failure of link train

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: check core_initialized before disable interrupts at dp_display_unbind()

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/mdp4: Fix refcount leak in mdp4_modeset_init_intf

Peilin Ye <peilin.ye@bytedance.com>
    net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms

Jay Vosburgh <jay.vosburgh@canonical.com>
    bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Lorenzo Bianconi <lorenzo@kernel.org>
    igb: fix a use-after-free issue in igb_clean_tx_ring

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix use-after-free Read in tipc_named_reinit

Xin Long <lucien.xin@gmail.com>
    tipc: simplify the finalize work queue

Claudiu Manoil <claudiu.manoil@nxp.com>
    phy: aquantia: Fix AN when higher speeds than 1G are not advertised

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, x86: Fix tail call count offset calculation on bpf2bpf call

Samuel Holland <samuel@sholland.org>
    drm/sun4i: Fix crash during suspend after component bind failure

Jon Maxwell <jmaxwell37@gmail.com>
    bpf: Fix request_sock leak in sk lookup helpers

Jonathan Marek <jonathan@marek.ca>
    drm/msm: use for_each_sgtable_sg to iterate over scatterlist

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: scsi_debug: Fix zone transition to full condition

Florian Westphal <fw@strlen.de>
    netfilter: use get_random_u32 instead of prandom

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: add nft_parse_register_store() and use it

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: add nft_parse_register_load() and use it

Maximilian Luz <luzmaximilian@gmail.com>
    drm/msm: Fix double pm_runtime_disable() call

Macpaul Lin <macpaul.lin@mediatek.com>
    USB: serial: option: add Quectel RM500K module support

Yonglin Tan <yonglin.tan@outlook.com>
    USB: serial: option: add Quectel EM05-G modem

Carlo Lobrano <c.lobrano@gmail.com>
    USB: serial: option: add Telit LE910Cx 0x1250 composition

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

David Sterba <dsterba@suse.com>
    btrfs: add error messages to all unrecognized mount options

Rosemarie O'Riorden <roriorden@redhat.com>
    net: openvswitch: fix parsing of nw_proto for IPv6 fragments

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo NS50PU

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo PD70PNT

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Apply fixup for Lenovo Yoga Duet 7 properly

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - ALC897 headset MIC no sound

Soham Sen <contact@sohamsen.me>
    ALSA: hda/realtek: Add mute LED quirk for HP Omen laptop

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Fix missing beep setup

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via: Fix missing beep setup

Jason A. Donenfeld <Jason@zx2c4.com>
    random: quiet urandom warning ratelimit suppression message

Jason A. Donenfeld <Jason@zx2c4.com>
    random: schedule mix_interrupt_randomness() less often

Jiri Slaby <jirislaby@kernel.org>
    vt: drop old FONT ioctls


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio-vf610      |   2 +-
 Makefile                                           |   6 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   2 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   2 +-
 arch/arm/mach-axxia/platsmp.c                      |   1 +
 arch/arm/mach-cns3xxx/core.c                       |   2 +
 arch/arm/mach-exynos/exynos.c                      |   1 +
 arch/mips/vr41xx/common/icu.c                      |   2 -
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/include/asm/fb.h                       |   2 +-
 arch/powerpc/kernel/process.c                      |   2 +-
 arch/powerpc/kernel/rtas.c                         |  11 +-
 arch/powerpc/platforms/powernv/powernv.h           |   2 +
 arch/powerpc/platforms/powernv/rng.c               |  52 ++++---
 arch/powerpc/platforms/powernv/setup.c             |   2 +
 arch/powerpc/platforms/pseries/pseries.h           |   2 +
 arch/powerpc/platforms/pseries/rng.c               |  11 +-
 arch/powerpc/platforms/pseries/setup.c             |   2 +
 arch/s390/kernel/perf_cpum_cf.c                    |  22 ++-
 arch/x86/net/bpf_jit_comp.c                        |   3 +-
 arch/xtensa/kernel/time.c                          |   1 +
 arch/xtensa/platforms/xtfpga/setup.c               |   1 +
 drivers/base/regmap/regmap-irq.c                   |   5 +-
 drivers/char/random.c                              |   6 +-
 drivers/dma-buf/udmabuf.c                          |   5 +-
 drivers/gpio/gpio-vr41xx.c                         |   2 -
 drivers/gpio/gpio-winbond.c                        |   7 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   3 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |   2 +
 drivers/gpu/drm/msm/dp/dp_catalog.c                |   2 +-
 drivers/gpu/drm/msm/dp/dp_catalog.h                |   2 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |  40 +++++-
 drivers/gpu/drm/msm/dp/dp_display.c                | 149 +++++++++++++-------
 drivers/gpu/drm/msm/dp/dp_panel.c                  |   5 +
 drivers/gpu/drm/msm/msm_iommu.c                    |   2 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |   4 +-
 drivers/iio/accel/bma180.c                         |   3 +-
 drivers/iio/accel/mma8452.c                        |  22 +--
 drivers/iio/accel/mxc4005.c                        |   4 +-
 drivers/iio/adc/adi-axi-adc.c                      |   3 +
 drivers/iio/adc/axp288_adc.c                       |   8 ++
 drivers/iio/adc/stm32-adc-core.c                   |   9 +-
 drivers/iio/adc/stm32-adc.c                        |  10 --
 drivers/iio/chemical/ccs811.c                      |   4 +-
 drivers/iio/gyro/mpu3050-core.c                    |   1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |   2 +-
 drivers/iio/trigger/iio-trig-sysfs.c               |   1 +
 drivers/md/dm-era-target.c                         |   8 +-
 drivers/md/dm-log.c                                |   2 +-
 drivers/memory/samsung/exynos5422-dmc.c            |  29 ++--
 drivers/mmc/host/sdhci-pci-o2micro.c               |   2 +
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   2 +-
 drivers/net/bonding/bond_main.c                    |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  39 +++++-
 drivers/net/ethernet/intel/igb/igb_main.c          |  19 +--
 drivers/net/phy/aquantia_main.c                    |  15 +-
 drivers/net/virtio_net.c                           |  25 +---
 drivers/nvme/host/core.c                           | 102 ++++++++++----
 drivers/nvme/host/lightnvm.c                       |   8 +-
 drivers/nvme/host/nvme.h                           |   2 +
 drivers/nvme/host/pci.c                            |  21 ++-
 drivers/nvme/target/passthru.c                     |   2 +-
 drivers/scsi/scsi_debug.c                          |  22 ++-
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                |   1 +
 drivers/tty/vt/vt.c                                |  39 +-----
 drivers/tty/vt/vt_ioctl.c                          | 151 ---------------------
 drivers/usb/chipidea/udc.c                         |   3 +
 drivers/usb/gadget/legacy/raw_gadget.c             |  63 ++++++---
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci-pci.c                        |   6 +-
 drivers/usb/host/xhci.c                            |  15 +-
 drivers/usb/host/xhci.h                            |   2 +
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/typec/tcpm/Kconfig                     |   1 -
 drivers/video/console/sticore.c                    |   2 +
 drivers/xen/features.c                             |   2 +-
 fs/afs/inode.c                                     |   3 +-
 fs/btrfs/super.c                                   |  39 +++++-
 fs/f2fs/namei.c                                    |  17 ++-
 include/linux/kd.h                                 |   8 --
 include/linux/ratelimit_types.h                    |  12 +-
 include/net/netfilter/nf_tables.h                  |  10 +-
 include/net/netfilter/nf_tables_core.h             |  12 +-
 include/net/netfilter/nft_fib.h                    |   2 +-
 include/net/netfilter/nft_meta.h                   |   4 +-
 include/trace/events/libata.h                      |   1 +
 net/bridge/netfilter/nft_meta_bridge.c             |   5 +-
 net/core/filter.c                                  |  34 ++++-
 net/ipv4/ip_gre.c                                  |  15 +-
 net/ipv4/netfilter/nft_dup_ipv4.c                  |  18 +--
 net/ipv6/ip6_gre.c                                 |  15 +-
 net/ipv6/netfilter/nft_dup_ipv6.c                  |  18 +--
 net/netfilter/nf_tables_api.c                      |  52 ++++++-
 net/netfilter/nft_bitwise.c                        |  23 ++--
 net/netfilter/nft_byteorder.c                      |  14 +-
 net/netfilter/nft_cmp.c                            |   8 +-
 net/netfilter/nft_ct.c                             |  12 +-
 net/netfilter/nft_dup_netdev.c                     |   6 +-
 net/netfilter/nft_dynset.c                         |  12 +-
 net/netfilter/nft_exthdr.c                         |  14 +-
 net/netfilter/nft_fib.c                            |   5 +-
 net/netfilter/nft_fwd_netdev.c                     |  18 +--
 net/netfilter/nft_hash.c                           |  25 ++--
 net/netfilter/nft_immediate.c                      |   6 +-
 net/netfilter/nft_lookup.c                         |  14 +-
 net/netfilter/nft_masq.c                           |  18 +--
 net/netfilter/nft_meta.c                           |  21 +--
 net/netfilter/nft_nat.c                            |  35 ++---
 net/netfilter/nft_numgen.c                         |  27 ++--
 net/netfilter/nft_objref.c                         |   6 +-
 net/netfilter/nft_osf.c                            |   8 +-
 net/netfilter/nft_payload.c                        |  10 +-
 net/netfilter/nft_queue.c                          |  12 +-
 net/netfilter/nft_range.c                          |   6 +-
 net/netfilter/nft_redir.c                          |  18 +--
 net/netfilter/nft_rt.c                             |   7 +-
 net/netfilter/nft_socket.c                         |   7 +-
 net/netfilter/nft_tproxy.c                         |  14 +-
 net/netfilter/nft_tunnel.c                         |   8 +-
 net/netfilter/nft_xfrm.c                           |   7 +-
 net/openvswitch/flow.c                             |   2 +-
 net/sched/sch_netem.c                              |   4 +-
 net/tipc/core.c                                    |   7 +-
 net/tipc/core.h                                    |   8 +-
 net/tipc/discover.c                                |   4 +-
 net/tipc/link.c                                    |   5 +
 net/tipc/link.h                                    |   1 +
 net/tipc/net.c                                     |  15 +-
 scripts/mod/modpost.c                              |   2 +-
 sound/pci/hda/hda_auto_parser.c                    |   7 +-
 sound/pci/hda/hda_local.h                          |   1 +
 sound/pci/hda/patch_conexant.c                     |   4 +-
 sound/pci/hda/patch_realtek.c                      |  36 ++++-
 sound/pci/hda/patch_via.c                          |   4 +-
 .../selftests/netfilter/nft_concat_range.sh        |   2 +-
 136 files changed, 1000 insertions(+), 757 deletions(-)


