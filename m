Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BC65640BF
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 16:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiGBOiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 10:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGBOiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 10:38:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28E5E0BB;
        Sat,  2 Jul 2022 07:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78D06B827B9;
        Sat,  2 Jul 2022 14:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB7DC34114;
        Sat,  2 Jul 2022 14:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656772691;
        bh=io+WDVwFAugmxMyFVmWR0Z04oyJr/bQYHG78hMn98Co=;
        h=From:To:Cc:Subject:Date:From;
        b=HYrfxk8BRf5yK/vzJ0quXKDDFawvRHLRfkw8PCZ/MZ7OcN8oEt1RmnMFU97WHGzha
         jmdP5I+ju9WxaVh3uMnFNTDrUYOaS6PyYtPe/SX4uGvVNx+WKmD3nItLA1zCmrEpZP
         lpe5TI1B/jwRP6DTFWYy4SykLvu/r81LDRG2TpI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.321
Date:   Sat,  2 Jul 2022 16:38:06 +0200
Message-Id: <16567726872125@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
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

I'm announcing the release of the 4.9.321 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio-vf610 |    2 
 Makefile                                      |    2 
 arch/arm/boot/dts/imx6qdl.dtsi                |    2 
 arch/arm/mach-axxia/platsmp.c                 |    1 
 arch/arm/mach-cns3xxx/core.c                  |    2 
 arch/arm/mach-exynos/exynos.c                 |    1 
 arch/mips/vr41xx/common/icu.c                 |    2 
 arch/powerpc/kernel/process.c                 |    2 
 arch/powerpc/platforms/pseries/pseries.h      |    2 
 arch/powerpc/platforms/pseries/rng.c          |   11 -
 arch/powerpc/platforms/pseries/setup.c        |    1 
 arch/x86/include/asm/kexec.h                  |    7 +
 arch/xtensa/kernel/time.c                     |    1 
 arch/xtensa/platforms/xtfpga/setup.c          |    1 
 drivers/char/random.c                         |    4 
 drivers/gpio/gpio-vr41xx.c                    |    2 
 drivers/gpu/drm/drm_crtc_helper_internal.h    |   10 -
 drivers/gpu/drm/drm_fb_helper.c               |   21 ---
 drivers/gpu/drm/drm_kms_helper_common.c       |   25 ++--
 drivers/iio/accel/bma180.c                    |    3 
 drivers/iio/accel/mma8452.c                   |   10 +
 drivers/iio/trigger/iio-trig-sysfs.c          |    1 
 drivers/md/dm-era-target.c                    |    8 +
 drivers/net/bonding/bond_main.c               |    4 
 drivers/net/ethernet/intel/igb/igb_main.c     |   12 --
 drivers/of/fdt.c                              |    8 +
 drivers/tty/vt/vt.c                           |   34 -----
 drivers/tty/vt/vt_ioctl.c                     |  149 --------------------------
 drivers/usb/chipidea/udc.c                    |    3 
 drivers/usb/serial/option.c                   |    1 
 drivers/xen/features.c                        |    2 
 drivers/xen/xlate_mmu.c                       |    1 
 include/linux/kd.h                            |    7 -
 include/linux/kexec.h                         |   26 +++-
 include/linux/ratelimit.h                     |   12 +-
 include/trace/events/libata.h                 |    1 
 kernel/kexec_file.c                           |   18 ---
 lib/swiotlb.c                                 |    3 
 scripts/mod/modpost.c                         |    2 
 39 files changed, 110 insertions(+), 294 deletions(-)

Baruch Siach (1):
      iio: adc: vf610: fix conversion mode sysfs node name

Carlo Lobrano (1):
      USB: serial: option: add Telit LE910Cx 0x1250 composition

Christoph Hellwig (1):
      drm: remove drm_fb_helper_modinit

Dmitry Rokosov (1):
      iio:accel:bma180: rearrange iio trigger get and register

Edward Wu (1):
      ata: libata: add qc->flags in ata_qc_complete_template tracepoint

Greg Kroah-Hartman (1):
      Linux 4.9.321

Haibo Chen (1):
      iio: accel: mma8452: ignore the return value of reset operation

Hsin-Yi Wang (1):
      fdt: Update CRC check for rng-seed

Jason A. Donenfeld (3):
      random: schedule mix_interrupt_randomness() less often
      random: quiet urandom warning ratelimit suppression message
      powerpc/pseries: wire up rng during setup_arch()

Jay Vosburgh (1):
      bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Jiri Slaby (1):
      vt: drop old FONT ioctls

Julien Grall (1):
      x86/xen: Remove undefined behavior in setup_features()

Kai-Heng Feng (1):
      igb: Make DMA faster when CPU is active on the PCIe link

Liang He (2):
      xtensa: xtfpga: Fix refcount leak bug in setup
      xtensa: Fix refcount leak bug in time.c

Liu Shixin (1):
      swiotlb: skip swiotlb_bounce when orig_addr is zero

Lucas Stach (1):
      ARM: dts: imx6qdl: correct PU regulator ramp delay

Masahiro Yamada (2):
      modpost: fix section mismatch check for exported init/exit sections
      xen: unexport __init-annotated xen_xlate_map_ballooned_pages()

Miaoqian Lin (3):
      ARM: exynos: Fix refcount leak in exynos_map_pmu
      ARM: Fix refcount leak in axxia_boot_secondary
      ARM: cns3xxx: Fix refcount leak in cns3xxx_init

Naveen N. Rao (2):
      powerpc: Enable execve syscall exit tracepoint
      kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]

Nikos Tsironis (1):
      dm era: commit metadata in postsuspend after worker stops

Vincent Whitchurch (1):
      iio: trigger: sysfs: fix use-after-free on remove

Xu Yang (1):
      usb: chipidea: udc: check request status before setting device address

huhai (1):
      MIPS: Remove repetitive increase irq_err_count

