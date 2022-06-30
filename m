Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD29561C00
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiF3Nv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbiF3NvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:51:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63223C481;
        Thu, 30 Jun 2022 06:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D154B82AD8;
        Thu, 30 Jun 2022 13:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68569C34115;
        Thu, 30 Jun 2022 13:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596944;
        bh=Xe8OVnCSLEdzv+JQZO8tNj/J+L0YRnx/DVfd09/biPc=;
        h=From:To:Cc:Subject:Date:From;
        b=bX3/zXz4z1sHtkwzsltXeMaMazi+hO7EeFUYlF91dKOhhbyYm/rxTdnaGMHi/wAJW
         NCvDk+UYAyTkQ0kkXt2e5EAKN9HOZEHxoL55tcQTI1Ygqfhxv0gpwM4NLm4Ylyuq9W
         IeotHVIaPtPI5lnadhuom69MOEerXZifq+gpdYcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/29] 4.9.321-rc1 review
Date:   Thu, 30 Jun 2022 15:46:00 +0200
Message-Id: <20220630133231.200642128@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.321-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.321-rc1
X-KernelTest-Deadline: 2022-07-02T13:32+00:00
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

This is the start of the stable review cycle for the 4.9.321 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.321-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.321-rc1

Liu Shixin <liushixin2@huawei.com>
    swiotlb: skip swiotlb_bounce when orig_addr is zero

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]

Hsin-Yi Wang <hsinyi@chromium.org>
    fdt: Update CRC check for rng-seed

Masahiro Yamada <masahiroy@kernel.org>
    xen: unexport __init-annotated xen_xlate_map_ballooned_pages()

Christoph Hellwig <hch@lst.de>
    drm: remove drm_fb_helper_modinit

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/pseries: wire up rng during setup_arch()

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix section mismatch check for exported init/exit sections

Miaoqian Lin <linmq006@gmail.com>
    ARM: cns3xxx: Fix refcount leak in cns3xxx_init

Miaoqian Lin <linmq006@gmail.com>
    ARM: Fix refcount leak in axxia_boot_secondary

Miaoqian Lin <linmq006@gmail.com>
    ARM: exynos: Fix refcount leak in exynos_map_pmu

Lucas Stach <l.stach@pengutronix.de>
    ARM: dts: imx6qdl: correct PU regulator ramp delay

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc: Enable execve syscall exit tracepoint

Liang He <windhl@126.com>
    xtensa: Fix refcount leak bug in time.c

Liang He <windhl@126.com>
    xtensa: xtfpga: Fix refcount leak bug in setup

Vincent Whitchurch <vincent.whitchurch@axis.com>
    iio: trigger: sysfs: fix use-after-free on remove

Haibo Chen <haibo.chen@nxp.com>
    iio: accel: mma8452: ignore the return value of reset operation

Dmitry Rokosov <DDRokosov@sberdevices.ru>
    iio:accel:bma180: rearrange iio trigger get and register

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: check request status before setting device address

Baruch Siach <baruch@tkos.co.il>
    iio: adc: vf610: fix conversion mode sysfs node name

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igb: Make DMA faster when CPU is active on the PCIe link

huhai <huhai@kylinos.cn>
    MIPS: Remove repetitive increase irq_err_count

Julien Grall <jgrall@amazon.com>
    x86/xen: Remove undefined behavior in setup_features()

Jay Vosburgh <jay.vosburgh@canonical.com>
    bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Carlo Lobrano <c.lobrano@gmail.com>
    USB: serial: option: add Telit LE910Cx 0x1250 composition

Jason A. Donenfeld <Jason@zx2c4.com>
    random: quiet urandom warning ratelimit suppression message

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: commit metadata in postsuspend after worker stops

Edward Wu <edwardwu@realtek.com>
    ata: libata: add qc->flags in ata_qc_complete_template tracepoint

Jason A. Donenfeld <Jason@zx2c4.com>
    random: schedule mix_interrupt_randomness() less often

Jiri Slaby <jslaby@suse.cz>
    vt: drop old FONT ioctls


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio-vf610 |   2 +-
 Makefile                                      |   4 +-
 arch/arm/boot/dts/imx6qdl.dtsi                |   2 +-
 arch/arm/mach-axxia/platsmp.c                 |   1 +
 arch/arm/mach-cns3xxx/core.c                  |   2 +
 arch/arm/mach-exynos/exynos.c                 |   1 +
 arch/mips/vr41xx/common/icu.c                 |   2 -
 arch/powerpc/kernel/process.c                 |   2 +-
 arch/powerpc/platforms/pseries/pseries.h      |   2 +
 arch/powerpc/platforms/pseries/rng.c          |  11 +-
 arch/powerpc/platforms/pseries/setup.c        |   1 +
 arch/x86/include/asm/kexec.h                  |   7 ++
 arch/xtensa/kernel/time.c                     |   1 +
 arch/xtensa/platforms/xtfpga/setup.c          |   1 +
 drivers/char/random.c                         |   4 +-
 drivers/gpio/gpio-vr41xx.c                    |   2 -
 drivers/gpu/drm/drm_crtc_helper_internal.h    |  10 --
 drivers/gpu/drm/drm_fb_helper.c               |  21 ----
 drivers/gpu/drm/drm_kms_helper_common.c       |  25 +++--
 drivers/iio/accel/bma180.c                    |   3 +-
 drivers/iio/accel/mma8452.c                   |  10 +-
 drivers/iio/trigger/iio-trig-sysfs.c          |   1 +
 drivers/md/dm-era-target.c                    |   8 +-
 drivers/net/bonding/bond_main.c               |   4 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  12 +--
 drivers/of/fdt.c                              |   8 +-
 drivers/tty/vt/vt.c                           |  34 +-----
 drivers/tty/vt/vt_ioctl.c                     | 149 --------------------------
 drivers/usb/chipidea/udc.c                    |   3 +
 drivers/usb/serial/option.c                   |   1 +
 drivers/xen/features.c                        |   2 +-
 drivers/xen/xlate_mmu.c                       |   1 -
 include/linux/kd.h                            |   7 --
 include/linux/kexec.h                         |  26 ++++-
 include/linux/ratelimit.h                     |  12 ++-
 include/trace/events/libata.h                 |   1 +
 kernel/kexec_file.c                           |  18 ----
 lib/swiotlb.c                                 |   3 +-
 scripts/mod/modpost.c                         |   2 +-
 39 files changed, 111 insertions(+), 295 deletions(-)


