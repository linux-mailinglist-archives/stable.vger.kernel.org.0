Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4885A4949F0
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 09:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbiATIsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 03:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359369AbiATIr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 03:47:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668A2C061746;
        Thu, 20 Jan 2022 00:47:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04A286176E;
        Thu, 20 Jan 2022 08:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06ADC340E0;
        Thu, 20 Jan 2022 08:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642668474;
        bh=VwNhf2MnEa+/LP4Vta31mZxUC9i8vJQRY7B+uGiP4gU=;
        h=From:To:Cc:Subject:Date:From;
        b=rkNabyBkFt6ohGqiIo+rqKb59oetK1WLSDmzJBfAn8JSr3rqX3gv+1ntpHlh3wq+H
         dW2l2kySt2U+tqk0y82UUPmde4Xkuxn7AARjFA/5/PVgfCsJ2KL1+OnSBo4P65SHD9
         tXj38Nws7vPEXOoSE9zByYA3YbrJiR09g1lWpOdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.93
Date:   Thu, 20 Jan 2022 09:47:47 +0100
Message-Id: <164266846794214@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.93 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    4 -
 arch/arm/kernel/perf_callchain.c                    |   17 ++++--
 arch/arm64/kernel/perf_callchain.c                  |   18 ++++---
 arch/csky/kernel/perf_callchain.c                   |    6 +-
 arch/nds32/kernel/perf_event_cpu.c                  |   17 ++++--
 arch/powerpc/include/asm/hvcall.h                   |    2 
 arch/powerpc/platforms/pseries/setup.c              |    6 ++
 arch/riscv/kernel/perf_callchain.c                  |    7 +-
 arch/s390/kvm/interrupt.c                           |    7 ++
 arch/s390/kvm/kvm-s390.c                            |    9 ++-
 arch/s390/kvm/kvm-s390.h                            |    1 
 arch/s390/kvm/sigp.c                                |   28 ++++++++++
 arch/x86/events/core.c                              |   17 ++++--
 arch/x86/events/intel/core.c                        |    9 ++-
 arch/x86/include/asm/kvm_host.h                     |    1 
 arch/x86/kvm/vmx/vmx.c                              |    1 
 arch/x86/kvm/x86.c                                  |    7 +-
 drivers/base/devtmpfs.c                             |    7 ++
 drivers/firmware/qemu_fw_cfg.c                      |   20 +++----
 drivers/media/usb/uvc/uvc_video.c                   |    4 +
 drivers/mtd/chips/Kconfig                           |    2 
 drivers/mtd/maps/Kconfig                            |    2 
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c |    1 
 drivers/remoteproc/qcom_pil_info.c                  |    2 
 drivers/video/fbdev/vga16fb.c                       |   24 +++++++++
 fs/9p/vfs_inode_dotl.c                              |   29 +++++++----
 fs/fs_context.c                                     |    2 
 fs/orangefs/orangefs-bufmap.c                       |    7 +-
 fs/super.c                                          |    4 -
 include/linux/fs_context.h                          |    2 
 include/linux/perf_event.h                          |   13 ++++-
 kernel/events/core.c                                |   13 +++--
 sound/pci/hda/patch_realtek.c                       |   51 ++++++++++++++++++--
 33 files changed, 266 insertions(+), 74 deletions(-)

Arie Geiger (1):
      ALSA: hda/realtek: Add speaker fixup for some Yoga 15ITL5 devices

Arnd Bergmann (1):
      mtd: fixup CFI on ixp4xx

Baole Fang (1):
      ALSA: hda/realtek: Add quirk for Legion Y9000X 2020

Bart Kroon (1):
      ALSA: hda: ALC287: Add Lenovo IdeaPad Slim 9i 14ITL5 speaker quirk

Christian Brauner (1):
      9p: only copy valid iattrs in 9P2000.L setattr implementation

Christian Lachner (1):
      ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master after reboot from Windows

Christophe JAILLET (1):
      orangefs: Fix the size of a memory allocation in orangefs_bufmap_alloc()

Eric Farman (1):
      KVM: s390: Clarify SIGP orders versus STOP/RESTART

Greg Kroah-Hartman (1):
      Linux 5.10.93

Jamie Hill-Daniel (1):
      vfs: fs_context: fix up param length parsing in legacy_parse_param

Javier Martinez Canillas (1):
      video: vga16fb: Only probe for EGA and VGA 16 color graphic cards

Johan Hovold (4):
      media: uvcvideo: fix division by zero at stream start
      firmware: qemu_fw_cfg: fix sysfs information leak
      firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries
      firmware: qemu_fw_cfg: fix kobject leak in probe error path

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Nathan Chancellor (1):
      kbuild: Add $(KBUILD_HOSTLDFLAGS) to 'has_libelf' test

NeilBrown (1):
      devtmpfs regression fix: reconfigure on each mount

Nicholas Piggin (1):
      powerpc/pseries: Get entry and uaccess flush required bits from H_GET_CPU_CHARACTERISTICS

Sean Christopherson (2):
      perf: Protect perf_guest_cbs with RCU
      KVM: x86: Register Processor Trace interrupt hook iff PT enabled in guest

Stephen Boyd (1):
      remoteproc: qcom: pil_info: Don't memcpy_toio more than is provided

Takashi Iwai (1):
      ALSA: hda/realtek: Re-order quirk entries for Lenovo

Wei Wang (1):
      KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all

