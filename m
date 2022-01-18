Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88166492A6A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346909AbiARQKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346488AbiARQJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:09:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1396EC061794;
        Tue, 18 Jan 2022 08:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9146612B5;
        Tue, 18 Jan 2022 16:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDEEC340E0;
        Tue, 18 Jan 2022 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522154;
        bh=nMKiYw9b/LaB4tBg1YfiWoR0kekCp4m/9b9h/VsDE4Y=;
        h=From:To:Cc:Subject:Date:From;
        b=MZSt4+I5S1TVpenOHuwo5lBZ/mcRMPXlTplfdu6BDmpfy5AMBOunYQP6KRR7KSETK
         NEP3lus3LXAn68Ew3FgRgnRM2a/4M5TiXY9GwOiBbF9rE5M9d0R+Hf4paZLrsBxVla
         JL48YHXaUs+3/RnIl+ACahwtw9n0VNkMpTiRQrQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 00/28] 5.15.16-rc1 review
Date:   Tue, 18 Jan 2022 17:05:46 +0100
Message-Id: <20220118160451.879092022@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.16-rc1
X-KernelTest-Deadline: 2022-01-20T16:04+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.16 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.16-rc1

Arnd Bergmann <arnd@arndb.de>
    mtd: fixup CFI on ixp4xx

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order quirk entries for Lenovo

Baole Fang <fbl718@163.com>
    ALSA: hda/realtek: Add quirk for Legion Y9000X 2020

Sameer Pujar <spujar@nvidia.com>
    ALSA: hda/tegra: Fix Tegra194 HDA reset failure

Bart Kroon <bart@tarmack.eu>
    ALSA: hda: ALC287: Add Lenovo IdeaPad Slim 9i 14ITL5 speaker quirk

Christian Lachner <gladiac@gmail.com>
    ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master after reboot from Windows

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Use ALC285_FIXUP_HP_GPIO_LED on another HP laptop

Arie Geiger <arsgeiger@gmail.com>
    ALSA: hda/realtek: Add speaker fixup for some Yoga 15ITL5 devices

Wei Wang <wei.w.wang@intel.com>
    KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all

Dario Petrillo <dario.pk1@gmail.com>
    perf annotate: Avoid TUI crash when navigating in the annotation of recursive functions

Johan Hovold <johan@kernel.org>
    firmware: qemu_fw_cfg: fix kobject leak in probe error path

Johan Hovold <johan@kernel.org>
    firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries

Johan Hovold <johan@kernel.org>
    firmware: qemu_fw_cfg: fix sysfs information leak

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Johan Hovold <johan@kernel.org>
    media: uvcvideo: fix division by zero at stream start

Javier Martinez Canillas <javierm@redhat.com>
    video: vga16fb: Only probe for EGA and VGA 16 color graphic cards

Christian Brauner <christian.brauner@ubuntu.com>
    9p: only copy valid iattrs in 9P2000.L setattr implementation

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom: pas: Add missing power-domain "mxc" for CDSP

Eric Farman <farman@linux.ibm.com>
    KVM: s390: Clarify SIGP orders versus STOP/RESTART

Li RongQing <lirongqing@baidu.com>
    KVM: x86: don't print when fail to read/write pv eoi memory

Sean Christopherson <seanjc@google.com>
    KVM: x86: Register Processor Trace interrupt hook iff PT enabled in guest

Sean Christopherson <seanjc@google.com>
    KVM: x86: Register perf callbacks after calling vendor's hardware_setup()

Sean Christopherson <seanjc@google.com>
    perf: Protect perf_guest_cbs with RCU

Jamie Hill-Daniel <jamie@hill-daniel.co.uk>
    vfs: fs_context: fix up param length parsing in legacy_parse_param

Stephen Boyd <swboyd@chromium.org>
    remoteproc: qcom: pil_info: Don't memcpy_toio more than is provided

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    orangefs: Fix the size of a memory allocation in orangefs_bufmap_alloc()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: explicitly set is_dsc_supported to false before use

NeilBrown <neilb@suse.de>
    devtmpfs regression fix: reconfigure on each mount


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/kernel/perf_callchain.c                   | 17 ++++---
 arch/arm64/kernel/perf_callchain.c                 | 18 +++++---
 arch/csky/kernel/perf_callchain.c                  |  6 ++-
 arch/nds32/kernel/perf_event_cpu.c                 | 17 ++++---
 arch/riscv/kernel/perf_callchain.c                 |  7 ++-
 arch/s390/kvm/interrupt.c                          |  7 +++
 arch/s390/kvm/kvm-s390.c                           |  9 +++-
 arch/s390/kvm/kvm-s390.h                           |  1 +
 arch/s390/kvm/sigp.c                               | 28 ++++++++++++
 arch/x86/events/core.c                             | 17 ++++---
 arch/x86/events/intel/core.c                       |  9 ++--
 arch/x86/include/asm/kvm_host.h                    |  1 +
 arch/x86/kvm/lapic.c                               | 18 +++-----
 arch/x86/kvm/vmx/vmx.c                             |  1 +
 arch/x86/kvm/x86.c                                 | 14 +++---
 drivers/base/devtmpfs.c                            |  7 +++
 drivers/firmware/qemu_fw_cfg.c                     | 20 ++++-----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  1 +
 drivers/media/usb/uvc/uvc_video.c                  |  4 ++
 drivers/mtd/chips/Kconfig                          |  2 +
 drivers/mtd/maps/Kconfig                           |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  1 +
 drivers/remoteproc/qcom_pil_info.c                 |  2 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |  1 +
 drivers/video/fbdev/vga16fb.c                      | 24 ++++++++++
 fs/9p/vfs_inode_dotl.c                             | 29 ++++++++----
 fs/fs_context.c                                    |  2 +-
 fs/orangefs/orangefs-bufmap.c                      |  7 ++-
 fs/super.c                                         |  4 +-
 include/linux/fs_context.h                         |  2 +
 include/linux/perf_event.h                         | 13 +++++-
 kernel/events/core.c                               | 13 ++++--
 sound/pci/hda/hda_tegra.c                          | 43 ++++++++++++++----
 sound/pci/hda/patch_realtek.c                      | 52 ++++++++++++++++++++--
 tools/perf/ui/browsers/annotate.c                  | 23 ++++++----
 36 files changed, 319 insertions(+), 107 deletions(-)


