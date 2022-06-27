Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7962055C405
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbiF0LiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbiF0Lhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9FE262E;
        Mon, 27 Jun 2022 04:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BD2DB80E6F;
        Mon, 27 Jun 2022 11:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6303CC3411D;
        Mon, 27 Jun 2022 11:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329567;
        bh=cRDC2JqjIX5hQemLUYF3NFmmoPTwQs+joG5Aha251ms=;
        h=From:To:Cc:Subject:Date:From;
        b=NWTMMfMtXmj7DVkN+feSJ+kZu5kpAHm+VTXWzOEx1lsdV0fKtHSFSMbUTvL0bRVgb
         EaJrDXKHAdAShhSAic7W10lZ4G/V9Y0oY7uEEIBj2iHPMVwIKHFOGtp0qrnShKwq06
         BWctdzpin9qn/eHzjwyNLPrpp/1EBPDbZPr2rh8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/135] 5.15.51-rc1 review
Date:   Mon, 27 Jun 2022 13:20:07 +0200
Message-Id: <20220627111938.151743692@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.51-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.51-rc1
X-KernelTest-Deadline: 2022-06-29T11:19+00:00
Content-Type: text/plain; charset=UTF-8
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

This is the start of the stable review cycle for the 5.15.51 release.
There are 135 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.51-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.51-rc1

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/pseries: wire up rng during setup_arch()

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: link vmlinux only once for CONFIG_TRIM_UNUSED_KSYMS (2nd attempt)

Dexuan Cui <decui@microsoft.com>
    dma-direct: use the correct size for dma_set_encrypted()

Adrian Hunter <adrian.hunter@intel.com>
    perf build-id: Fix caching files with a wrong build ID

Jason A. Donenfeld <Jason@zx2c4.com>
    random: update comment from copy_to_user() -> copy_to_iter()

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm2711-rpi-400: Fix GPIO line names

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

Aswath Govindraju <a-govindraju@ti.com>
    arm64: dts: ti: k3-am64-main: Remove support for HS400 speed mode

Lucas Stach <l.stach@pengutronix.de>
    ARM: dts: imx6qdl: correct PU regulator ramp delay

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx7: Move hsic_phy power domain to HSIC PHY node

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: Always clear mask bits to disable interrupts at dp_ctrl_reset_irq_ctrl()

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/powernv: wire up rng during setup_arch

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc: Enable execve syscall exit tracepoint

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/microwatt: wire up rng during setup_arch()

Helge Deller <deller@gmx.de>
    parisc: Enable ARCH_HAS_STRICT_MODULE_RWX

Helge Deller <deller@gmx.de>
    parisc/stifb: Fix fb_is_primary_device() only available with CONFIG_FB_STI

Liang He <windhl@126.com>
    xtensa: Fix refcount leak bug in time.c

Liang He <windhl@126.com>
    xtensa: xtfpga: Fix refcount leak bug in setup

Jialin Zhang <zhangjialin11@huawei.com>
    iio: adc: ti-ads131e08: add missing fwnode_handle_put() in ads131e08_alloc_channels()

Miaoqian Lin <linmq006@gmail.com>
    iio: adc: adi-axi-adc: Fix refcount leak in adi_axi_adc_attach_client

Jialin Zhang <zhangjialin11@huawei.com>
    iio: adc: rzg2l_adc: add missing fwnode_handle_put() in rzg2l_adc_parse_properties()

Hans de Goede <hdegoede@redhat.com>
    iio: adc: axp288: Override TS pin bias current for some models

Yannick Brosseau <yannick.brosseau@gmail.com>
    iio: adc: stm32: Fix IRQs on STM32F4 by removing custom spurious IRQs message

Yannick Brosseau <yannick.brosseau@gmail.com>
    iio: adc: stm32: Fix ADCs iteration in irq handler

Linus Walleij <linus.walleij@linaro.org>
    iio: afe: rescale: Fix boolean logic bug

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
    iio:accel:kxcjk-1013: rearrange iio trigger get and register

Dmitry Rokosov <DDRokosov@sberdevices.ru>
    iio:chemical:ccs811: rearrange iio trigger get and register

Dmitry Rokosov <DDRokosov@sberdevices.ru>
    iio:humidity:hts221: rearrange iio trigger get and register

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: attach inline_data after setting compression

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix deadlock with fsync+fiemap+transaction commit

Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
    btrfs: don't set lock_owner when locking extent buffer for reading

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: usb: ehci: Increase the number of PHYs

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: usb: ohci: Increase the number of PHYs

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

Linus Walleij <linus.walleij@linaro.org>
    iio: magnetometer: yas530: Fix memchr_inv() misuse

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

Jakub Kicinski <kuba@kernel.org>
    sock: redo the psock vs ULP protection check

Jakub Kicinski <kuba@kernel.org>
    Revert "net/tls: fix tls_sk_proto_close executed repeatedly"

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    virtio_net: fix xdp_rxq_info bug after suspend/resume

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igb: Make DMA faster when CPU is active on the PCIe link

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    regmap-irq: Fix offset/index mismatch in read_sub_irq_data()

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

Jason Andryuk <jandryuk@gmail.com>
    xen-blkfront: Handle NULL gendisk

Jie2x Zhou <jie2x.zhou@intel.com>
    selftests: netfilter: correct PKTGEN_SCRIPT_PATHS in nft_concat_range.sh

Gerd Hoffmann <kraxel@redhat.com>
    udmabuf: add back sanity check

Ziyang Xuan <william.xuanziyang@huawei.com>
    net/tls: fix tls_sk_proto_close executed repeatedly

Eric Dumazet <edumazet@google.com>
    erspan: do not assume transport header is always set

Leo Yan <leo.yan@linaro.org>
    perf arm-spe: Don't set data source if it's not a memory operation

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: force link training for display resolution change

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: do not initialize phy until plugin interrupt received

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: dp_link_parse_sink_count() return immediately if aux read failed

Bjorn Andersson <bjorn.andersson@linaro.org>
    drm/msm/dp: Drop now unused hpd_high member

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: check core_initialized before disable interrupts at dp_display_unbind()

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/mdp4: Fix refcount leak in mdp4_modeset_init_intf

Peilin Ye <peilin.ye@bytedance.com>
    net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms

Ivan Vecera <ivecera@redhat.com>
    ethtool: Fix get module eeprom fallback

Jay Vosburgh <jay.vosburgh@canonical.com>
    bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Lorenzo Bianconi <lorenzo@kernel.org>
    igb: fix a use-after-free issue in igb_clean_tx_ring

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix use-after-free Read in tipc_named_reinit

Eric Dumazet <edumazet@google.com>
    net: fix data-race in dev_isalive()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: Write lock dev_base_lock without disabling bottom halves.

Quentin Perret <qperret@google.com>
    KVM: arm64: Prevent kmemleak from accessing pKVM memory

Claudiu Manoil <claudiu.manoil@nxp.com>
    phy: aquantia: Fix AN when higher speeds than 1G are not advertised

Saurabh Sengar <ssengar@linux.microsoft.com>
    scsi: storvsc: Correct reporting of Hyper-V I/O size limits

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, x86: Fix tail call count offset calculation on bpf2bpf call

Samuel Holland <samuel@sholland.org>
    drm/sun4i: Fix crash during suspend after component bind failure

Jon Maxwell <jmaxwell37@gmail.com>
    bpf: Fix request_sock leak in sk lookup helpers

Jonathan Marek <jonathan@marek.ca>
    drm/msm: use for_each_sgtable_sg to iterate over scatterlist

Ciara Loftus <ciara.loftus@intel.com>
    xsk: Fix generic transmit when completion queue reservation fails

Sergey Gorenko <sergeygo@nvidia.com>
    scsi: iscsi: Exclude zero from the endpoint ID range

Rob Clark <robdclark@chromium.org>
    drm/msm: Switch ordering of runpm put vs devfreq_idle

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: scsi_debug: Fix zone transition to full condition

Florian Westphal <fw@strlen.de>
    netfilter: use get_random_u32 instead of prandom

Maximilian Luz <luzmaximilian@gmail.com>
    drm/msm: Fix double pm_runtime_disable() call

Rob Clark <robdclark@chromium.org>
    drm/msm: Ensure mmap offset is initialized

Macpaul Lin <macpaul.lin@mediatek.com>
    USB: serial: option: add Quectel RM500K module support

Yonglin Tan <yonglin.tan@outlook.com>
    USB: serial: option: add Quectel EM05-G modem

Carlo Lobrano <c.lobrano@gmail.com>
    USB: serial: option: add Telit LE910Cx 0x1250 composition

Johan Hovold <johan@kernel.org>
    USB: serial: pl2303: add support for more HXN (G) types

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Implement w/a 22010492432 for adl-s

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/kprobes: Check whether get_kretprobe() returns NULL in kretprobe_dispatcher()

Mikulas Patocka <mpatocka@redhat.com>
    dm mirror log: clear log bits up to BITS_PER_LONG boundary

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: commit metadata in postsuspend after worker stops

Edward Wu <edwardwu@realtek.com>
    ata: libata: add qc->flags in ata_qc_complete_template tracepoint

Sascha Hauer <s.hauer@pengutronix.de>
    mtd: rawnand: gpmi: Fix setting busy timeout setting

Joerg Roedel <jroedel@suse.de>
    MAINTAINERS: Add new IOMMU development mailing list

Demi Marie Obenour <demi@invisiblethingslab.com>
    xen/gntdev: Avoid blocking in unmap_grant_pages()

Mengqi Zhang <mengqi.zhang@mediatek.com>
    mmc: mediatek: wait dma stop bit reset to 0

Chevron Li <chevron.li@bayhubtech.com>
    mmc: sdhci-pci-o2micro: Fix card detect by dealing with debouncing

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvfc: Allocate/free queue resource only during probe/remove

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvfc: Store vhost pointer during subcrq allocation

David Sterba <dsterba@suse.com>
    btrfs: add error messages to all unrecognized mount options

Qu Wenruo <wqu@suse.com>
    btrfs: prevent remounting to v1 space cache for subpage mount

Filipe Manana <fdmanana@suse.com>
    btrfs: fix hang during unmount when block group reclaim task is running

Dominique Martinet <asmadeus@codewreck.org>
    9p: fix fid refcount leak in v9fs_vfs_get_link

Dominique Martinet <asmadeus@codewreck.org>
    9p: fix fid refcount leak in v9fs_vfs_atomic_open_dotl

Tyler Hicks <tyhicks@linux.microsoft.com>
    9p: Fix refcounting during full path walks for fid lookups

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


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio-vf610      |   2 +-
 .../devicetree/bindings/usb/generic-ehci.yaml      |   3 +-
 .../devicetree/bindings/usb/generic-ohci.yaml      |   3 +-
 MAINTAINERS                                        |  11 ++
 Makefile                                           |   6 +-
 arch/arm/boot/dts/bcm2711-rpi-400.dts              |   6 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   2 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   2 +-
 arch/arm/mach-axxia/platsmp.c                      |   1 +
 arch/arm/mach-cns3xxx/core.c                       |   2 +
 arch/arm/mach-exynos/exynos.c                      |   1 +
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi           |   2 -
 arch/arm64/kvm/arm.c                               |   6 +-
 arch/mips/vr41xx/common/icu.c                      |   2 -
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/include/asm/fb.h                       |   2 +-
 arch/powerpc/kernel/process.c                      |   2 +-
 arch/powerpc/kernel/rtas.c                         |  11 +-
 arch/powerpc/platforms/microwatt/microwatt.h       |   7 +
 arch/powerpc/platforms/microwatt/rng.c             |  10 +-
 arch/powerpc/platforms/microwatt/setup.c           |   8 ++
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
 drivers/base/regmap/regmap-irq.c                   |   8 +-
 drivers/block/xen-blkfront.c                       |  19 ++-
 drivers/char/random.c                              |   6 +-
 drivers/dma-buf/udmabuf.c                          |   5 +-
 drivers/gpio/gpio-vr41xx.c                         |   2 -
 drivers/gpio/gpio-winbond.c                        |   7 +-
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c      |   4 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   3 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |   2 +
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   | 118 ++++++++--------
 drivers/gpu/drm/msm/dp/dp_ctrl.h                   |  10 +-
 drivers/gpu/drm/msm/dp/dp_display.c                | 127 +++++++++--------
 drivers/gpu/drm/msm/dp/dp_hpd.c                    |   2 -
 drivers/gpu/drm/msm/dp/dp_hpd.h                    |   2 -
 drivers/gpu/drm/msm/dp/dp_link.c                   |  19 ++-
 drivers/gpu/drm/msm/msm_drv.c                      |   2 +-
 drivers/gpu/drm/msm/msm_drv.h                      |   1 +
 drivers/gpu/drm/msm/msm_gem_prime.c                |  15 ++
 drivers/gpu/drm/msm/msm_gpu.c                      |   3 +-
 drivers/gpu/drm/msm/msm_iommu.c                    |   2 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |   4 +-
 drivers/iio/accel/bma180.c                         |   3 +-
 drivers/iio/accel/kxcjk-1013.c                     |   4 +-
 drivers/iio/accel/mma8452.c                        |  22 +--
 drivers/iio/accel/mxc4005.c                        |   4 +-
 drivers/iio/adc/adi-axi-adc.c                      |   3 +
 drivers/iio/adc/axp288_adc.c                       |   8 ++
 drivers/iio/adc/rzg2l_adc.c                        |   8 +-
 drivers/iio/adc/stm32-adc-core.c                   |   9 +-
 drivers/iio/adc/stm32-adc.c                        |  10 --
 drivers/iio/adc/ti-ads131e08.c                     |  10 +-
 drivers/iio/afe/iio-rescale.c                      |   2 +-
 drivers/iio/chemical/ccs811.c                      |   4 +-
 drivers/iio/gyro/mpu3050-core.c                    |   1 +
 drivers/iio/humidity/hts221_buffer.c               |   5 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |   2 +-
 drivers/iio/magnetometer/yamaha-yas530.c           |   2 +-
 drivers/iio/trigger/iio-trig-sysfs.c               |   1 +
 drivers/md/dm-era-target.c                         |   8 +-
 drivers/md/dm-log.c                                |   2 +-
 drivers/memory/samsung/exynos5422-dmc.c            |  29 ++--
 drivers/mmc/host/mtk-sd.c                          |  20 +--
 drivers/mmc/host/sdhci-pci-o2micro.c               |   2 +
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   2 +-
 drivers/net/bonding/bond_main.c                    |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  39 ++++-
 drivers/net/ethernet/intel/igb/igb_main.c          |  19 +--
 drivers/net/phy/aquantia_main.c                    |  15 +-
 drivers/net/virtio_net.c                           |  25 +---
 drivers/nvme/host/core.c                           |  28 ++++
 drivers/nvme/host/pci.c                            |   4 -
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  82 ++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h                     |   2 +-
 drivers/scsi/scsi_debug.c                          |  22 ++-
 drivers/scsi/scsi_transport_iscsi.c                |   7 +-
 drivers/scsi/storvsc_drv.c                         |  27 +++-
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                |   1 +
 drivers/usb/chipidea/udc.c                         |   3 +
 drivers/usb/gadget/legacy/raw_gadget.c             |  63 ++++++---
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci-pci.c                        |   6 +-
 drivers/usb/host/xhci.c                            |  15 +-
 drivers/usb/host/xhci.h                            |   2 +
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/serial/pl2303.c                        |  29 ++--
 drivers/usb/typec/tcpm/Kconfig                     |   1 -
 drivers/video/console/sticore.c                    |   2 +
 drivers/xen/features.c                             |   2 +-
 drivers/xen/gntdev-common.h                        |   7 +
 drivers/xen/gntdev.c                               | 157 ++++++++++++++-------
 fs/9p/fid.c                                        |  22 ++-
 fs/9p/vfs_inode.c                                  |   8 +-
 fs/9p/vfs_inode_dotl.c                             |   3 +
 fs/afs/inode.c                                     |   3 +-
 fs/btrfs/disk-io.c                                 |  13 +-
 fs/btrfs/file.c                                    |  67 +++++++--
 fs/btrfs/locking.c                                 |   3 -
 fs/btrfs/super.c                                   |  47 +++++-
 fs/f2fs/namei.c                                    |  17 ++-
 include/linux/ratelimit_types.h                    |  12 +-
 include/net/inet_sock.h                            |   5 +
 include/trace/events/libata.h                      |   1 +
 kernel/dma/direct.c                                |   5 +-
 kernel/trace/trace_kprobe.c                        |  11 +-
 net/core/dev.c                                     |  40 +++---
 net/core/filter.c                                  |  34 ++++-
 net/core/link_watch.c                              |   4 +-
 net/core/net-sysfs.c                               |   1 +
 net/core/rtnetlink.c                               |   8 +-
 net/core/skmsg.c                                   |   5 +
 net/ethtool/eeprom.c                               |   2 +-
 net/hsr/hsr_device.c                               |   6 +-
 net/ipv4/ip_gre.c                                  |  15 +-
 net/ipv4/tcp_bpf.c                                 |   3 -
 net/ipv6/ip6_gre.c                                 |  15 +-
 net/netfilter/nft_meta.c                           |  13 +-
 net/netfilter/nft_numgen.c                         |  12 +-
 net/openvswitch/flow.c                             |   2 +-
 net/sched/sch_netem.c                              |   4 +-
 net/tipc/core.c                                    |   3 +-
 net/tls/tls_main.c                                 |   2 +
 net/xdp/xsk.c                                      |  16 ++-
 scripts/mod/modpost.c                              |   2 +-
 sound/pci/hda/hda_auto_parser.c                    |   7 +-
 sound/pci/hda/hda_local.h                          |   1 +
 sound/pci/hda/patch_conexant.c                     |   4 +-
 sound/pci/hda/patch_realtek.c                      |  36 ++++-
 sound/pci/hda/patch_via.c                          |   4 +-
 tools/perf/util/arm-spe.c                          |  22 ++-
 tools/perf/util/build-id.c                         |  28 ++++
 .../selftests/netfilter/nft_concat_range.sh        |   2 +-
 143 files changed, 1209 insertions(+), 580 deletions(-)


