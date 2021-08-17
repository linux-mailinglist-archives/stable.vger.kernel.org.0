Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612B83EEE4D
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 16:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237687AbhHQOPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 10:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbhHQOPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 10:15:31 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01164C061764
        for <stable@vger.kernel.org>; Tue, 17 Aug 2021 07:14:58 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u3so38988203ejz.1
        for <stable@vger.kernel.org>; Tue, 17 Aug 2021 07:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tNC3OTM1HYvYufyk6UHijvEWIKPMMQ9V2DfWBuwee+E=;
        b=MOTpkEto+leiNqXGt6iCzcuziCYwC06lDAA5LMGh2fWtOMxXBA/uwj/YkOIcpqWTyP
         D5w9DKMfxp64yL4lU8DgZsZ5u1Yb9fR5TFJuM13eUJZKzCwiQeUx31C9stEP8JfKxeBo
         gHVHGoQbR3uBGasEbgeesQcXEXz5jDZ3JNzlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tNC3OTM1HYvYufyk6UHijvEWIKPMMQ9V2DfWBuwee+E=;
        b=tJ+qkSygMqyY4dGrmIu6RTkCA+GQ3omAPJHXpwerRPG2Ge/HjdoTSXt9THCEVV6sII
         Gv7BY3xycpbvrWg8IABf/FAg+AZheg9Cp0ROxTMgknDm+udPhutxxWVgje0SzuL7zB+E
         Skjba/CYSmq+uxbm5nvglDbWvXqXG/gVedLWVqW+d9t02RltlAxANdSF89WNRAIkYbsH
         3nhgjuxlLAZi+C6zcYnAlcVCUN3NGHnYG7EuMwIYyvn4mfXBciRu31nE7X5R/OE5E317
         YzOfWcXJt+AMJOlFXrOP4wjpcvEsj5C1wKXuu+C57u/KN5lGQYyoIiC8OLe/KFYfWUx4
         jhtg==
X-Gm-Message-State: AOAM530KOkNHy/iwPRzJP68cOcTTm8V9qDvPQTh8GGI1fl4zNEGJLyVH
        8QiF/2mBvUY68ZpbFuv1OwVdYA==
X-Google-Smtp-Source: ABdhPJzrM7VLQIwz1aogjBGJ17pA+hux2j+EOEgRjgcNbC9xvPKkokTjEIRDRjIaQJdDZGLo/lh7iA==
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr4213632ejb.139.1629209696572;
        Tue, 17 Aug 2021 07:14:56 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v9sm857952ejk.82.2021.08.17.07.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 07:14:55 -0700 (PDT)
Date:   Tue, 17 Aug 2021 16:14:53 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, tzimmermann@suse.de,
        stable@vger.kernel.org, daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        robdclark@gmail.com, sean@poorly.run, tomi.valkeinen@ti.com,
        vegard.nossum@oracle.com, dhaval.giani@oracle.com,
        dan.carpenter@oracle.com, dvyukov@google.com,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 5.4.y 0/2] 5.4.y missing upstream commits 7beb691f and
 51f644b4, causing: WARNING in vkms_vblank_simulate
Message-ID: <YRvEXSEQYDPsQGlJ@phenom.ffwll.local>
References: <1621630400-22972-1-git-send-email-george.kennedy@oracle.com>
 <YLTP5/8h4BsqnTL9@kroah.com>
 <cc388554-7f83-c967-0fb7-14b71c0032a1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc388554-7f83-c967-0fb7-14b71c0032a1@oracle.com>
X-Operating-System: Linux phenom 5.10.0-7-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 17, 2021 at 09:37:00AM -0400, George Kennedy wrote:
> Hello Thomas,
> 
> I sent this backport request to stable@vger.kernel.org a while ago including
> the maintainers, but mistakenly did not CC you. Sorry about that.
> 
> Can you please review this backport request for 5.4.y? Greg is waiting to
> hear from the maintainers before accepting the backport request.
> 
> Thank you,
> George
> 
> On 5/31/2021 8:00 AM, Greg KH wrote:
> > On Fri, May 21, 2021 at 03:53:18PM -0500, George Kennedy wrote:
> > > During Syzkaller reproducer testing on 5.4.y (5.4.121-rc1) the following warning occurred:
> > > 
> > > WARNING in vkms_vblank_simulate
> > > https://syzkaller.appspot.com//bug?id=0ba17d70d062b2595e1f061231474800f076c7cb
> > > 
> > > These 2 upstream commits are needed to fix the warning:
> > > 7beb691f drm: Initialize struct drm_crtc_state.no_vblank from device settings
> > > 51f644b4 drm/atomic-helper: reset vblank on crtc reset

We've done these two (and a bunch more iirc) because we were firmly fed up
with drivers getting these details wrong. But the entire vblank handling
area is also extremely fickle, so backporting these to fix vkms (which is
purely for developers for testing) at the risk of maybe breaking some real
driver, feels a bit silly.

Ofc syzkaller doesn't tests these. Note that the big drivers should all
get this right, it's the fringe arm drivers that no one tests fully which
get all these details wrong.

So unless someone hollers that this fixes a bug on their hw I'd let these
be.

Upgrade to 5.10 LTS if you care about this stuff, it's been out for over
half a year by now :-)

Cheers, Daniel

> > > 
> > > 51f644b4 has conflicts (which were resolved).
> > > 
> > > [  101.335429] ------------[ cut here ]------------
> > > [  101.336576] WARNING: CPU: 1 PID: 0 at drivers/gpu/drm/vkms/vkms_crtc.c:91 vkms_get_vblank_timestamp+0x10a/0x140
> > > [  101.338952] Modules linked in:
> > > [  101.339701] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.4.121-rc1-syzk #1
> > > [  101.344331] RIP: 0010:vkms_get_vblank_timestamp+0x10a/0x140
> > > [  101.345660] Code: 03 80 3c 02 00 75 4f 4d 2b b5 80 10 00 00 4d 89 34 24 e8 d9 4e a7 fc b8 01 00 00 00 5b 41 5c 41 5d 41 5e 5d c3 e8 c6 4e a7 fc <0f> 0b eb e4 e8 3d a0 e6 fc e9 27 ff ff ff e8 33 a0 e6 fc eb 91 4c
> > > [  101.351293] RAX: ffff888107a65d00 RBX: 000000179647991a RCX: ffffffff84cde2af
> > > [  101.352976] RDX: 0000000000000100 RSI: ffffffff84cde2fa RDI: 0000000000000006
> > > [  101.354662] RBP: ffff88810b289ba8 R08: ffff888107a65d00 R09: ffffed1021651398
> > > [  101.356361] R10: ffffed1021651398 R11: 0000000000000003 R12: ffff88810b289cb0
> > > [  101.358037] R13: ffff88810a89c000 R14: 000000179647991a R15: 0000000000004e20
> > > [  101.359718] FS:  0000000000000000(0000) GS:ffff88810b280000(0000) knlGS:0000000000000000
> > > [  101.361627] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  101.362992] CR2: 00007f82b0154000 CR3: 0000000109460000 CR4: 00000000000006e0
> > > [  101.364684] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > [  101.366369] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > [  101.368043] Call Trace:
> > > [  101.368652]  <IRQ>
> > > [  101.369159]  ? vkms_crtc_atomic_flush+0x2d0/0x2d0
> > > [  101.370296]  drm_get_last_vbltimestamp+0x106/0x1b0
> > > [  101.371446]  ? drm_crtc_set_max_vblank_count+0x1a0/0x1a0
> > > [  101.372715]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> > > [  101.374001]  drm_update_vblank_count+0x17a/0x800
> > > [  101.375107]  ? store_vblank+0x1d0/0x1d0
> > > [  101.376038]  ? __kasan_check_write+0x14/0x20
> > > [  101.377071]  drm_vblank_disable_and_save+0x13a/0x3d0
> > > [  101.378265]  ? vblank_disable_fn+0x101/0x180
> > > [  101.379296]  vblank_disable_fn+0x14b/0x180
> > > [  101.380282]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
> > > [  101.381508]  call_timer_fn+0x50/0x310
> > > [  101.382393]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
> > > [  101.383621]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
> > > [  101.384849]  run_timer_softirq+0x76f/0x13e0
> > > [  101.385857]  ? del_timer_sync+0xb0/0xb0
> > > [  101.386792]  ? irq_work_interrupt+0xf/0x20
> > > [  101.387776]  ? irq_work_interrupt+0xa/0x20
> > > [  101.388761]  __do_softirq+0x18d/0x623
> > > [  101.389647]  irq_exit+0x1fc/0x220
> > > [  101.390454]  smp_apic_timer_interrupt+0xf0/0x380
> > > [  101.391565]  apic_timer_interrupt+0xf/0x20
> > > [  101.392547]  </IRQ>
> > > [  101.393073] RIP: 0010:native_safe_halt+0x12/0x20
> > > [  101.394178] Code: 96 fe ff ff 48 89 df e8 ac c1 fc f3 eb 92 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 e9 07 00 00 00 0f 00 2d 10 ee 50 00 fb f4 <5d> c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 e9 07 00 00
> > > [  101.398541] RSP: 0018:ffff888107aafd48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> > > [  101.400326] RAX: ffffffff8db7b830 RBX: ffff888107a65d00 RCX: ffffffff8db7c532
> > > [  101.402004] RDX: 1ffff11020f4cba0 RSI: 0000000000000008 RDI: ffff888107a65d00
> > > [  101.403680] RBP: ffff888107aafd48 R08: ffffed1020f4cba1 R09: ffffed1020f4cba1
> > > [  101.405361] R10: ffffed1020f4cba0 R11: ffff888107a65d07 R12: 0000000000000001
> > > [  101.407041] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
> > > [  101.408729]  ? __cpuidle_text_start+0x8/0x8
> > > [  101.409735]  ? default_idle_call+0x32/0x70
> > > [  101.410722]  default_idle+0x24/0x2c0
> > > [  101.411589]  arch_cpu_idle+0x15/0x20
> > > [  101.412459]  default_idle_call+0x5f/0x70
> > > [  101.413405]  do_idle+0x30f/0x3d0
> > > [  101.414185]  ? arch_cpu_idle_exit+0x40/0x40
> > > [  101.415188]  ? complete+0x67/0x80
> > > [  101.415992]  cpu_startup_entry+0x1d/0x20
> > > [  101.416937]  start_secondary+0x2ec/0x3d0
> > > [  101.417879]  ? set_cpu_sibling_map+0x2620/0x2620
> > > [  101.418986]  secondary_startup_64+0xb6/0xc0
> > > [  101.420001] ---[ end trace 6143b67a4d795a3a ]---
> > > 
> > > Daniel Vetter (1):
> > >    drm/atomic-helper: reset vblank on crtc reset
> > > 
> > > Thomas Zimmermann (1):
> > >    drm: Initialize struct drm_crtc_state.no_vblank from device settings
> > > 
> > >   drivers/gpu/drm/arm/display/komeda/komeda_crtc.c |  7 ++---
> > >   drivers/gpu/drm/arm/malidp_drv.c                 |  1 -
> > >   drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c   |  7 ++---
> > >   drivers/gpu/drm/drm_atomic_helper.c              | 10 ++++++-
> > >   drivers/gpu/drm/drm_atomic_state_helper.c        |  4 +++
> > >   drivers/gpu/drm/drm_vblank.c                     | 28 +++++++++++++++++++
> > >   drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c        |  2 --
> > >   drivers/gpu/drm/omapdrm/omap_crtc.c              |  8 +++---
> > >   drivers/gpu/drm/omapdrm/omap_drv.c               |  4 ---
> > >   drivers/gpu/drm/rcar-du/rcar_du_crtc.c           |  6 +----
> > >   drivers/gpu/drm/tegra/dc.c                       |  1 -
> > >   include/drm/drm_crtc.h                           | 34 +++++++++++++++++++-----
> > >   include/drm/drm_simple_kms_helper.h              |  7 +++--
> > >   include/drm/drm_vblank.h                         |  1 +
> > >   14 files changed, 84 insertions(+), 36 deletions(-)
> > > 
> > > -- 
> > > 1.8.3.1
> > > 
> > I need the drm developers/maintainers to ack these changes before I can
> > take them into the stable tree...  {hint}
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
