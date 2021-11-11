Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAB944CE7B
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 01:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhKKAsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 19:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbhKKAsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 19:48:31 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941E9C061766;
        Wed, 10 Nov 2021 16:45:42 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id n12so483767lfe.1;
        Wed, 10 Nov 2021 16:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SLa5LAv3g0vZmAbNhbQqIkrokBVJdiQBADDaDRRU2eg=;
        b=IpuqKniykyjL/AAmIHakbJ1bvgdwv6bsHpBpgvkqVYImKTFXXrGnc+ecBkONCHABmX
         1oX1fgNf+iK/T4AVlIo4brjR1fkf168+5sr9e3AUFtpcAlCU+d0SQ1N10dvHhI9yumbo
         CE48o6Yx5pOU/FNhqEYGSwYaQEPZBjYmAlT8pHt4L1eiPmgsFVRg4PltXSnx9Nfmk/sg
         xE5jposLqmwzU2rxRQyaDUQzq/VQY0TIuvqqwPUvxzDxE3KqAvhlShMJ2QCm7HFqUTZ7
         zgYoH+F2mbsmtO5mvc1S1LknM7QMUGA6KCBS/25eoEnmkJ63KEhlIkTKYha66ei1Oouo
         UCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SLa5LAv3g0vZmAbNhbQqIkrokBVJdiQBADDaDRRU2eg=;
        b=yL6toXd+8twBEpHIaNqynNnkNiS3dGpnZ9rTf7fPM1BDml/MgkyJWYHlwdeb7RjIHc
         qQdDT9CygP6vRkdsSOMCNPWBqqbdxEwLOzAdlI6aYphB97eJwmaK7AhJp7HUc06AQqnp
         BB0LHp/cURS++s52SRctrJT5Je83SABkRSmhmPmmWOHjZA7Dw2lpRuNYsQ3AGxe3Jjre
         TbJIbxGwSPrnK6//EaaI+eMFlWoScLvWhvjo9tv5x0QcSkXywyfZ1DWtKAVp4ZvmGWzB
         Irwh/yheiQQ6znRiWh08jGqcZ2mErR3BF7jm01/SOMuBE1BYJNkAURgAsPa++Xyp4BJn
         tohg==
X-Gm-Message-State: AOAM5330ew9lpDmbVvpn8I37k9DVrI0Y+wb0Ec9YhTMzrPhC4JVTK77P
        MbSObbt58dMM8v/oi8GsamY=
X-Google-Smtp-Source: ABdhPJxYpwyMSNl97ZXiwygBjXJAsSsluv+06/2OYXIzMXmoxWEzCRTKCC49FNzGbbWioJQuoN+0Jw==
X-Received: by 2002:a05:6512:39c7:: with SMTP id k7mr3117189lfu.571.1636591540969;
        Wed, 10 Nov 2021 16:45:40 -0800 (PST)
Received: from lahvuun (93-76-191-141.kha.volia.net. [93.76.191.141])
        by smtp.gmail.com with ESMTPSA id k16sm132665lfm.168.2021.11.10.16.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 16:45:40 -0800 (PST)
Date:   Thu, 11 Nov 2021 02:45:39 +0200
From:   Ilya Trukhanov <lahvuun@gmail.com>
To:     Javier Martinez Canillas <javierm@redhat.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        tzimmermann@suse.de, ardb@kernel.org, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [REGRESSION]: drivers/firmware: move x86 Generic System
 Framebuffers support
Message-ID: <20211111004539.vd7nl3duciq72hkf@lahvuun>
References: <20211110200253.rfudkt3edbd3nsyj@lahvuun>
 <627b6cd1-3446-5e55-ea38-5283a186af39@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <627b6cd1-3446-5e55-ea38-5283a186af39@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 12:07:19AM +0100, Javier Martinez Canillas wrote:
> [ adding dri-devel mailing list as Cc ]
> 
> Hello Ilya,
> 
> On 11/10/21 21:02, Ilya Trukhanov wrote:
> > Suspend-to-RAM with elogind under Wayland stopped working in 5.15.
> > 
> > This occurs with 5.15, 5.15.1 and latest master at
> > 89d714ab6043bca7356b5c823f5335f5dce1f930. 5.14 and earlier releases work
> > fine.
> > 
> > git bisect gives d391c58271072d0b0fad93c82018d495b2633448.
> >
> 
> That's strange because this patch is just moving code around, there shouldn't
> be any functional changes...
> 
> > To reproduce:
> > - Use elogind and Linux 5.15.1 with CONFIG_SYSFB_SIMPLEFB=n.
> > - Start a Wayland session. I tested sway and weston, neither worked.
> > - In a terminal emulator (I used alacritty) execute `loginctl suspend`.
> > 
> > Normally after the last step the system would suspend, but it no longer
> > does so after I upgraded to Linux 5.15. After running `loginctl suspend`
> > in dmesg I get the following:
> > [  103.098782] elogind-daemon[2357]: Suspending system...
> > [  103.098794] PM: suspend entry (deep)
> > [  103.124621] Filesystems sync: 0.025 seconds
> > 
> > But nothing happens afterwards.
> > 
> > Suspend works as expected if I do any of the following:
> > - Revert d391c58271072d0b0fad93c82018d495b2633448.
> > - Build with CONFIG_SYSFB_SIMPLEFB=y.
> 
> Can you please share the kernel boot log for any of these cases too ?

revert dmesg: https://pastebin.com/BpnMvV2u
CONFIG_SYSFB_SIMPLEFB=y dmesg: https://pastebin.com/qSUdQygt

> 
> > - Suspend from tty, even if a Wayland session is running in parallel.
> > - Suspend from under an X11 session.
> > - Suspend with `echo mem > /sys/power/state`.
> > 
> > If I attach strace to the elogind-daemon process after running
> > `loginctl suspend` then the system immediately suspends. However, if
> > I attach strace *prior* to running `loginctl suspend` then no suspend,
> > and the process gets stuck on a write syscall to `/sys/power/state`.
> > 
> > I "traced" a little bit with printk (sorry, I don't know of a better
> > way) and the call chain is as follows:
> > state_store -> pm_suspend -> enter_state -> suspend_prepare
> > -> pm_prepare_console -> vt_move_to_console -> vt_waitactive
> > -> __vt_event_wait
> > 
> > __vt_event_wait just waits until wait_event_interruptible completes, but
> > it never does (not until I attach to elogind-daemon with strace, at
> > least). I did not follow the chain further.
> > 
> > - Linux version 5.15.1 (lahvuun@lahvuun) (gcc (Gentoo 11.2.0 p1) 11.2.0,
> >   GNU ld (Gentoo 2.37_p1 p0) 2.37) #51 SMP PREEMPT Tue Nov 9 23:39:25
> >   EET 2021
> > - Gentoo Linux 2.8
> > - x86_64 AuthenticAMD
> > - dmesg: https://pastebin.com/duj33bY8
> > - .config: https://pastebin.com/7Hew1g0T
> > 
> 
> Looking at your .config and dmesg output, my guess is that is related to the
> fact that you have both CONFIG_FB_EFI=y and CONFIG_DRM_AMDGPU=y.
> 
> The code that adds the "efi-framebuffer" platform device used to be in the
> arch/x86/kernel/sysfb.c file but now is in drivers/firmware/sysfb.c, and it
> could affect the order in which the device <--> driver matching happens.
> 
> From your kernel boot log:
> 
> ...
> [    0.375796] [drm] amdgpu kernel modesetting enabled.
> [    0.375819] amdgpu: CRAT table disabled by module option
> [    0.375823] amdgpu: Virtual CRAT table created for CPU
> [    0.375831] amdgpu: Topology: Add CPU node
> [    0.375865] amdgpu 0000:0a:00.0: vgaarb: deactivate vga console
> [    0.375911] [drm] initializing kernel modesetting (VEGA10 0x1002:0x687F 0x1DA2:0xE376 0xC3).
> ...
> [    0.868997] fbcon: amdgpu (fb0) is primary device
> [    1.004397] Console: switching to colour frame buffer device 240x67
> [    1.017815] amdgpu 0000:0a:00.0: [drm] fb0: amdgpu frame buffer device
> ...
> [    1.133997] efifb: probing for efifb
> [    1.134716] efifb: framebuffer at 0xe0000000, using 8100k, total 8100k
> [    1.135438] efifb: mode is 1920x1080x32, linelength=7680, pages=1
> [    1.136180] efifb: scrolling: redraw
> [    1.136891] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    1.137638] fb1: EFI VGA frame buffer device
> 
> Usually the efifb is to have early framebuffer output before the native DRM
> driver probes, but in your case is the opposite. This wouldn't happen if the
> amdpug driver was built as a module.
> 
> Probably before the mentioned commit, the efifb driver was probed earlier and
> then the amdgpu driver would had removed the conflicting efifb framebuffer
> before registering its DRM device. But that doesn't happen here and the efifb
> framebuffer is still around since is registered after the one for the amdgpu.
> 
> Which would explain why also works with CONFIG_SYSFB_SIMPLEFB=y for you, since
> in that case a "simple-framebuffer" platform device is added instead of an
> "efi-framebuffer". But since neither CONFIG_FB_SIMPLE nor CONFIG_DRM_SIMPLEDRM
> are enabled in your kernel config, no device driver will match that device.
> 
> This is just a guess though. Would be good if you could test following cases:
> 
> 1) CONFIG_FB_EFI not set

/proc/fb:
0 amdgpu

dmesg: https://pastebin.com/c1BcWLEh

Suspend-to-RAM works.

> 2) CONFIG_FB_EFI=y and CONFIG_DRM_AMDGPU=m

/proc/fb before `modprobe amdgpu`:
0 EFI VGA

after:
0 amdgpu

dmesg: https://pastebin.com/vSsTw2Km

Suspend-to-RAM works.

> 3) CONFIG_SYSFB_SIMPLEFB=y and CONFIG_FB_SIMPLE=y

/proc/fb:
0 amdgpu
1 simple

dmesg: https://pastebin.com/ZSXnpLqQ

Suspend-to-RAM fails.

> 
> And for each check /proc/fb, the kernel boot log, and if Suspend-to-RAM works.
> 
> If the explanation above is correct, then I would expect (1) and (2) to work and
> (3) to also fail.
> 
> Best regards,
> -- 
> Javier Martinez Canillas
> Linux Engineering
> Red Hat
> 
