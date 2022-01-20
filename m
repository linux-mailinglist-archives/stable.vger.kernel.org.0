Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777714949F8
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 09:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240389AbiATIsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 03:48:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60956 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359390AbiATIsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 03:48:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94B58B81CED;
        Thu, 20 Jan 2022 08:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95C7C340E0;
        Thu, 20 Jan 2022 08:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642668482;
        bh=stMn4Vc3DEoJpml8FlKfg20Y9ZJ+ehl/Yb4XAFliuZg=;
        h=From:To:Cc:Subject:Date:From;
        b=BeCZ+6TXhUKcHLZrm3bYoTG5BgvU09y0fzrFWdPCL4BieqyLQhBhLFLYaPQye4Bwb
         0m0PPBsRb95PmH8egwgtkL4ngk0xC5MXwHDspjMmvG6MVdA1I6XShJzP/hvlI+jp/r
         pMSLTaba68X0gaz3C7gBz0N9LET5GjJCwYqLyG+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.16
Date:   Thu, 20 Jan 2022 09:47:52 +0100
Message-Id: <1642668473194108@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.16 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/kernel/perf_callchain.c                    |   17 ++++--
 arch/arm64/kernel/perf_callchain.c                  |   18 ++++--
 arch/csky/kernel/perf_callchain.c                   |    6 +-
 arch/nds32/kernel/perf_event_cpu.c                  |   17 ++++--
 arch/riscv/kernel/perf_callchain.c                  |    7 +-
 arch/s390/kvm/interrupt.c                           |    7 ++
 arch/s390/kvm/kvm-s390.c                            |    9 ++-
 arch/s390/kvm/kvm-s390.h                            |    1 
 arch/s390/kvm/sigp.c                                |   28 ++++++++++
 arch/x86/events/core.c                              |   17 ++++--
 arch/x86/events/intel/core.c                        |    9 ++-
 arch/x86/include/asm/kvm_host.h                     |    1 
 arch/x86/kvm/lapic.c                                |   18 ++----
 arch/x86/kvm/vmx/vmx.c                              |    1 
 arch/x86/kvm/x86.c                                  |   14 +++--
 drivers/base/devtmpfs.c                             |    7 ++
 drivers/firmware/qemu_fw_cfg.c                      |   20 +++----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   |    1 
 drivers/media/usb/uvc/uvc_video.c                   |    4 +
 drivers/mtd/chips/Kconfig                           |    2 
 drivers/mtd/maps/Kconfig                            |    2 
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c |    1 
 drivers/remoteproc/qcom_pil_info.c                  |    2 
 drivers/remoteproc/qcom_q6v5_pas.c                  |    1 
 drivers/video/fbdev/vga16fb.c                       |   24 +++++++++
 fs/9p/vfs_inode_dotl.c                              |   29 +++++++----
 fs/fs_context.c                                     |    2 
 fs/orangefs/orangefs-bufmap.c                       |    7 +-
 fs/super.c                                          |    4 -
 include/linux/fs_context.h                          |    2 
 include/linux/perf_event.h                          |   13 ++++-
 kernel/events/core.c                                |   13 +++--
 sound/pci/hda/hda_tegra.c                           |   43 +++++++++++++---
 sound/pci/hda/patch_realtek.c                       |   52 ++++++++++++++++++--
 tools/perf/ui/browsers/annotate.c                   |   23 +++++---
 36 files changed, 318 insertions(+), 106 deletions(-)

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

Dario Petrillo (1):
      perf annotate: Avoid TUI crash when navigating in the annotation of recursive functions

Eric Farman (1):
      KVM: s390: Clarify SIGP orders versus STOP/RESTART

Greg Kroah-Hartman (1):
      Linux 5.15.16

Jamie Hill-Daniel (1):
      vfs: fs_context: fix up param length parsing in legacy_parse_param

Javier Martinez Canillas (1):
      video: vga16fb: Only probe for EGA and VGA 16 color graphic cards

Johan Hovold (4):
      media: uvcvideo: fix division by zero at stream start
      firmware: qemu_fw_cfg: fix sysfs information leak
      firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries
      firmware: qemu_fw_cfg: fix kobject leak in probe error path

Kai-Heng Feng (1):
      ALSA: hda/realtek: Use ALC285_FIXUP_HP_GPIO_LED on another HP laptop

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Li RongQing (1):
      KVM: x86: don't print when fail to read/write pv eoi memory

Mario Limonciello (1):
      drm/amd/display: explicitly set is_dsc_supported to false before use

NeilBrown (1):
      devtmpfs regression fix: reconfigure on each mount

Sameer Pujar (1):
      ALSA: hda/tegra: Fix Tegra194 HDA reset failure

Sean Christopherson (3):
      perf: Protect perf_guest_cbs with RCU
      KVM: x86: Register perf callbacks after calling vendor's hardware_setup()
      KVM: x86: Register Processor Trace interrupt hook iff PT enabled in guest

Sibi Sankar (1):
      remoteproc: qcom: pas: Add missing power-domain "mxc" for CDSP

Stephen Boyd (1):
      remoteproc: qcom: pil_info: Don't memcpy_toio more than is provided

Takashi Iwai (1):
      ALSA: hda/realtek: Re-order quirk entries for Lenovo

Wei Wang (1):
      KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all

