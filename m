Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D05E3D70A
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 21:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390609AbfFKTlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 15:41:52 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35268 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387856AbfFKTlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 15:41:52 -0400
Received: by mail-ot1-f68.google.com with SMTP id j19so13102403otq.2
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 12:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GulUsqBf8T027861ToGt8N8Fkx90aYJ3H5Xyw39pJCk=;
        b=BLs92YLhBG37uFU+cv1zbVt054d9bpwDQzV1xZdsuQvcZDtafmxwl3DJq0QAi99ly3
         fTguFr0mXqAua8mxzGmXTgGYpHcfHxqRKkJpiGKRnDImCIFJ1PVOtToClVzTp0NXuMhg
         TzGHhfcrfHwSFtwxEU3vqrb6CJ3kaZAF1OmBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GulUsqBf8T027861ToGt8N8Fkx90aYJ3H5Xyw39pJCk=;
        b=keEv7kV1f57QevcKdKS1mCL0xJHxwuUyIpFzVG3zUK+nClPWeKIz1MeHAh0Z7SnZNo
         AVjlpsqsOptl+4Wa5sxQ407v16JbLzovpXRy+V8TeQsbn55pPLiVCdodXZFbn52Klmvw
         ldAdHDpim7nchvk5JjHhGIa+QPnJxKGR8C7Q0eg6jy59fAOYJC4/dmZctaAt3a8HTezf
         GslRNW6NgKw2NjtsY4cv8kRAkM05GkGR+QHMT6GV3nzlgm06kJbg9S0B87OXcR+bJ0LM
         JZ833zRcSsVBeeP5O14llrkocX1+Diom85y7vi+0nLaMh0VK+J2iFCwZSPyM1A0y5FEz
         Qnzg==
X-Gm-Message-State: APjAAAVj2D9PK9FbAprJA7N6QegaDqRTxYYl6kGGBty/pu5PfXllmXWb
        Ij7kIURHe6FjXBPZsV6VudATLIQk+YtXkwBdMe/7Hw==
X-Google-Smtp-Source: APXvYqylT3xp9u/Ufj7vpvMygQsyUsKKPYr6kWcupwMqFgM4VF/sbqAy0s68jrFuWrsPCzr+0e0GPUHeTTSPqdpHLwk=
X-Received: by 2002:a9d:7451:: with SMTP id p17mr4483924otk.204.1560282111688;
 Tue, 11 Jun 2019 12:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <87k1dsjkdo.fsf@turtle.gmx.de> <20190611153656.GA5084@kroah.com>
 <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com> <87ef40j6mx.fsf@turtle.gmx.de>
In-Reply-To: <87ef40j6mx.fsf@turtle.gmx.de>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 11 Jun 2019 21:41:40 +0200
Message-ID: <CAKMK7uGTmb8SiTW+6mjovJwmrZYqhJY84ZyD5ozM_ynTBoOjGg@mail.gmail.com>
Subject: Re: Linux 5.1.9 build failure with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
To:     Sven Joachim <svenjoac@gmx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 8:53 PM Sven Joachim <svenjoac@gmx.de> wrote:
>
> On 2019-06-11 19:33 +0200, Daniel Vetter wrote:
>
> > On Tue, Jun 11, 2019 at 5:37 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >> On Tue, Jun 11, 2019 at 03:56:35PM +0200, Sven Joachim wrote:
> >> > Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouveau
> >> > legacy contexts. (v3)") has caused a build failure for me when I
> >> > actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n):
> >> >
> >> > ,----
> >> > | Kernel: arch/x86/boot/bzImage is ready  (#1)
> >> > |   Building modules, stage 2.
> >> > |   MODPOST 290 modules
> >> > | ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
> >> > | scripts/Makefile.modpost:91: recipe for target '__modpost' failed
> >> > `----
> >
> > Calling drm_legacy_mmap is definitely not a great idea.
>
> Certainly not, but it was done by Dave in commit 2036eaa7403 ("nouveau:
> bring back legacy mmap handler") for compatibility with old
> xf86-video-nouveau versions (older than 1.0.4) that call DRIOpenDRMMaster.
>
> If that is really necessary, it probably has been broken in Linus' tree
> by commit bed2dd8421 where the test has been moved to ttm_bo_mmap() and
> returns -EINVAL on failure.

Looking at the commit it's actually 1.0.1, which was release in 2012.
I'd say lets keep current upstream as-is, and hope no one cares
anymore ...
-Daniel

> > I think either
> > we need a custom patch to remove that out on older kernels, or maybe
> > even #ifdef if you want to be super paranoid about breaking stuff ...
> >
> >> > Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
> >> > Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
> >> > drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does not
> >> > apply in 5.1.9.
> >> >
> >> > Most likely 4.19.50 and 4.14.125 are also affected, I haven't tested
> >> > them yet.
> >>
> >> They probably are.
> >>
> >> Should I just revert this patch in the stable tree, or add some other
> >> patch (like the one pointed out here, which seems an odd patch for
> >> stable...)
> >
> > ... or backport the above patch, that should be save to do too. Not
> > sure what stable folks prefer?
> > -Daniel
>
> Cheers,
>        Sven



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
