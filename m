Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DCF4968BC
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 01:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiAVA3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 19:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiAVA3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 19:29:44 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D50C06173B;
        Fri, 21 Jan 2022 16:29:43 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v6so2529601wra.8;
        Fri, 21 Jan 2022 16:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHqrfd9sy/yN49JyRRsO4/8Iw6OMhpCdQTfoy31cjlc=;
        b=JnVSoPOLUHimvz2pK2xDoNjRURHgcIUSyDfPb/ICe0DUlTovejvBMawmEcmmPt+CZT
         Sl6AAJd+W55ST45racBlS7cE3E6EDR+WGAUuoKQ5W91LvLGXrLbU0v4VJxzOkeo7g+L6
         Bsl3noAq0mwiyIhi90eJe3o1nYyWAcKBrov5k8eFJ9RCfOIZKjlX3sx2vhPvo7a/vQP+
         M0lt5/gdG4QL6ClJR/IXeI485hteIsPJpvMid3EZ/KDyRfFssRG/RcThHcKhNNmekW45
         0/fn8moc6F1uhoriGC0NvVc5ctwyRc1lZWOZo9Hz/lRuPUVI50at+kS8bThAY5Qw0WCq
         wabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHqrfd9sy/yN49JyRRsO4/8Iw6OMhpCdQTfoy31cjlc=;
        b=dQkC4nHD0ncxi8GkNL5Cg81+ug4v4zhLnww8c7OGuRXmqSxUJ6MsevU20xOGHwyeR7
         BYSfBCRnTS31zNDSzq5WNzHQQ1503B6hHlpVMB1zEJXOJyjgDTQSJeWtm3TtvP0meXwt
         0EfWUtXk+bfSuTDL+QfSNAYBPJv4FJYOn8chlh9SGj1hTEEOrHGKV7HJM+FxzW43EuzA
         KJzL6P8QNXKoVMzbSlEbxy0USdPj82687tnMZkypChzTQ8pvSpBwkPfDQ3grW53oP6xP
         lX4Pw2c1fgIarXtHft08zT9YyaoUXp41jRYVM6HoJQR+M+JohIu+i5YxFoven14hsD5b
         0tdg==
X-Gm-Message-State: AOAM532vmPy61dagCo8yYn7J86HXVhhuVYzW1GgZ7UV+IrIRjTmnInho
        Nmq4RDOJXvBsxMaoKD/mVeIwgyESV3kTawAIhGCwb02J1xA=
X-Google-Smtp-Source: ABdhPJwz2IFvpQu2c5xxORdI4s+Brf5ES6SuNTKLRl4w/iv1UAU4flLCsPIjfaqPtM2HGrOagqIom/Jq3RSnp/lt1Rg=
X-Received: by 2002:a5d:45cf:: with SMTP id b15mr2083069wrs.140.1642811381270;
 Fri, 21 Jan 2022 16:29:41 -0800 (PST)
MIME-Version: 1.0
References: <20220118160451.879092022@linuxfoundation.org>
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
From:   Allen <allen.lkml@gmail.com>
Date:   Fri, 21 Jan 2022 16:29:30 -0800
Message-ID: <CAOMdWSJXT-jUFpGt5BGTyNLyYmEhFmbCoyYxgLDTnSDC3ZvpzQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/28] 5.15.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux@roeck-us.net,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 5.15.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Build and boot tested. No dmesg regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks,
- Allen


> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.15.16-rc1
>
> Arnd Bergmann <arnd@arndb.de>
>     mtd: fixup CFI on ixp4xx
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Re-order quirk entries for Lenovo
>
> Baole Fang <fbl718@163.com>
>     ALSA: hda/realtek: Add quirk for Legion Y9000X 2020
>
> Sameer Pujar <spujar@nvidia.com>
>     ALSA: hda/tegra: Fix Tegra194 HDA reset failure
>
> Bart Kroon <bart@tarmack.eu>
>     ALSA: hda: ALC287: Add Lenovo IdeaPad Slim 9i 14ITL5 speaker quirk
>
> Christian Lachner <gladiac@gmail.com>
>     ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master after reboot from Windows
>
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     ALSA: hda/realtek: Use ALC285_FIXUP_HP_GPIO_LED on another HP laptop
>
> Arie Geiger <arsgeiger@gmail.com>
>     ALSA: hda/realtek: Add speaker fixup for some Yoga 15ITL5 devices
>
> Wei Wang <wei.w.wang@intel.com>
>     KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
>
> Dario Petrillo <dario.pk1@gmail.com>
>     perf annotate: Avoid TUI crash when navigating in the annotation of recursive functions
>
> Johan Hovold <johan@kernel.org>
>     firmware: qemu_fw_cfg: fix kobject leak in probe error path
>
> Johan Hovold <johan@kernel.org>
>     firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries
>
> Johan Hovold <johan@kernel.org>
>     firmware: qemu_fw_cfg: fix sysfs information leak
>
> Larry Finger <Larry.Finger@lwfinger.net>
>     rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled
>
> Johan Hovold <johan@kernel.org>
>     media: uvcvideo: fix division by zero at stream start
>
> Javier Martinez Canillas <javierm@redhat.com>
>     video: vga16fb: Only probe for EGA and VGA 16 color graphic cards
>
> Christian Brauner <christian.brauner@ubuntu.com>
>     9p: only copy valid iattrs in 9P2000.L setattr implementation
>
> Sibi Sankar <sibis@codeaurora.org>
>     remoteproc: qcom: pas: Add missing power-domain "mxc" for CDSP
>
> Eric Farman <farman@linux.ibm.com>
>     KVM: s390: Clarify SIGP orders versus STOP/RESTART
>
> Li RongQing <lirongqing@baidu.com>
>     KVM: x86: don't print when fail to read/write pv eoi memory
>
> Sean Christopherson <seanjc@google.com>
>     KVM: x86: Register Processor Trace interrupt hook iff PT enabled in guest
>
> Sean Christopherson <seanjc@google.com>
>     KVM: x86: Register perf callbacks after calling vendor's hardware_setup()
>
> Sean Christopherson <seanjc@google.com>
>     perf: Protect perf_guest_cbs with RCU
>
> Jamie Hill-Daniel <jamie@hill-daniel.co.uk>
>     vfs: fs_context: fix up param length parsing in legacy_parse_param
>
> Stephen Boyd <swboyd@chromium.org>
>     remoteproc: qcom: pil_info: Don't memcpy_toio more than is provided
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     orangefs: Fix the size of a memory allocation in orangefs_bufmap_alloc()
>
> Mario Limonciello <mario.limonciello@amd.com>
>     drm/amd/display: explicitly set is_dsc_supported to false before use
>
> NeilBrown <neilb@suse.de>
>     devtmpfs regression fix: reconfigure on each mount
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |  4 +-
>  arch/arm/kernel/perf_callchain.c                   | 17 ++++---
>  arch/arm64/kernel/perf_callchain.c                 | 18 +++++---
>  arch/csky/kernel/perf_callchain.c                  |  6 ++-
>  arch/nds32/kernel/perf_event_cpu.c                 | 17 ++++---
>  arch/riscv/kernel/perf_callchain.c                 |  7 ++-
>  arch/s390/kvm/interrupt.c                          |  7 +++
>  arch/s390/kvm/kvm-s390.c                           |  9 +++-
>  arch/s390/kvm/kvm-s390.h                           |  1 +
>  arch/s390/kvm/sigp.c                               | 28 ++++++++++++
>  arch/x86/events/core.c                             | 17 ++++---
>  arch/x86/events/intel/core.c                       |  9 ++--
>  arch/x86/include/asm/kvm_host.h                    |  1 +
>  arch/x86/kvm/lapic.c                               | 18 +++-----
>  arch/x86/kvm/vmx/vmx.c                             |  1 +
>  arch/x86/kvm/x86.c                                 | 14 +++---
>  drivers/base/devtmpfs.c                            |  7 +++
>  drivers/firmware/qemu_fw_cfg.c                     | 20 ++++-----
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  1 +
>  drivers/media/usb/uvc/uvc_video.c                  |  4 ++
>  drivers/mtd/chips/Kconfig                          |  2 +
>  drivers/mtd/maps/Kconfig                           |  2 +-
>  .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  1 +
>  drivers/remoteproc/qcom_pil_info.c                 |  2 +-
>  drivers/remoteproc/qcom_q6v5_pas.c                 |  1 +
>  drivers/video/fbdev/vga16fb.c                      | 24 ++++++++++
>  fs/9p/vfs_inode_dotl.c                             | 29 ++++++++----
>  fs/fs_context.c                                    |  2 +-
>  fs/orangefs/orangefs-bufmap.c                      |  7 ++-
>  fs/super.c                                         |  4 +-
>  include/linux/fs_context.h                         |  2 +
>  include/linux/perf_event.h                         | 13 +++++-
>  kernel/events/core.c                               | 13 ++++--
>  sound/pci/hda/hda_tegra.c                          | 43 ++++++++++++++----
>  sound/pci/hda/patch_realtek.c                      | 52 ++++++++++++++++++++--
>  tools/perf/ui/browsers/annotate.c                  | 23 ++++++----
>  36 files changed, 319 insertions(+), 107 deletions(-)
>
>


-- 
       - Allen
