Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299E02AB4E5
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgKIKaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgKIKaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:30:30 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E153DC0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 02:30:29 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id m17so9701249oie.4
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 02:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHkqdCzwlfhdjaBe/619nrv5mifEdmS6V4ZJeykSazA=;
        b=UB+3y/sK6kaeOSMqQBgtNuxT6mbld9BCyz4b6sRNgHQc1ts+BMRHzocnMtC1cgKZJH
         cMCYX0yAyGopM193uc2obVq9ISxm9Kzk/uhbF9P7/ie8pV3TJPEoM7wyP8UBl0bWMfJr
         6XTRmkbN+zVX7nlHDq9+4NCh4Nq/N/MwrT08o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHkqdCzwlfhdjaBe/619nrv5mifEdmS6V4ZJeykSazA=;
        b=Y9bnFYuQox2jSLxO/18m48deRbDTR2Xoj7XWNkhVlKW3xaUDc3YHbUQu4XvJ3vT4Tb
         2h9FSBZ7/4fx7FEDhIV9A2zFnGEwhS1FrrNDiyPI5eV0b95gd1zom36M1M2whmSEP0wl
         k4K+/rcCHZzCkKmSA0eFUByarQsOKBx+0b2iWbB+KOC2QxIj/KFeZMxUuJROBLb+xdMm
         Xgamo+jh5KYpOinXBUJBlm1AGRA5pyxlsGrAIHBWATDB7I1mQSAfG1erCC2IWkGwy2Pz
         64jtHxfxibYzs+XXRA72RqN6QCOeZbaIjApgImc2fjsbv5rRNQasCw4YfqgFSlUcBwN+
         3NvA==
X-Gm-Message-State: AOAM533D5obixGd/tRIusltEHUF6mpuGDG0sCYFuZ51ElI+3+X+sjzRr
        6LS9/mJyPnfYjie9X1PR2wOHgdoYotULmasRrqcdBhTK4jk+IQ==
X-Google-Smtp-Source: ABdhPJzRiGNjOEOcnAn3vIRaC6eqG4Tlc8qRr3aC2F2T+SLvuR9T6e+1fJEGJnnthRTuyfQIiK4Gm+UixIMoFz1VNMU=
X-Received: by 2002:aca:b141:: with SMTP id a62mr8047695oif.101.1604917829340;
 Mon, 09 Nov 2020 02:30:29 -0800 (PST)
MIME-Version: 1.0
References: <20201107092857.3110264-1-daniel.vetter@ffwll.ch>
 <CAHk-=wjoTrpJcC+VKNwsOF+NFd+LANm_pydcFoaV9PscO0Ogaw@mail.gmail.com>
 <CAKMK7uFzGDe9vV8zef5kU6mS5W-0tTDw2KdUmMgbFJ=WT-F-RA@mail.gmail.com>
 <20201108161335.GB11931@kroah.com> <20201108183640.GA65130@kroah.com>
 <CAKMK7uHCSxAjcRR8oQRS5uL4i2-iLv38jiN8=7pntoNgQBu+bg@mail.gmail.com> <20201109095715.GA836082@kroah.com>
In-Reply-To: <20201109095715.GA836082@kroah.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon, 9 Nov 2020 11:30:18 +0100
Message-ID: <CAKMK7uEbioBvRggrprEvLB9MkQVoSburdneoEAHo7JmM4va9Hw@mail.gmail.com>
Subject: Re: [PATCH] vt: Disable KD_FONT_OP_COPY
To:     Greg KH <greg@kroah.com>
Cc:     stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Security Officers <security@kernel.org>,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 9, 2020 at 10:56 AM Greg KH <greg@kroah.com> wrote:
>
> On Mon, Nov 09, 2020 at 08:57:38AM +0100, Daniel Vetter wrote:
> > On Sun, Nov 8, 2020 at 7:35 PM Greg KH <greg@kroah.com> wrote:
> > > On Sun, Nov 08, 2020 at 05:13:35PM +0100, Greg KH wrote:
> > > > On Sun, Nov 08, 2020 at 04:41:35PM +0100, Daniel Vetter wrote:
> > > > > On Sat, Nov 7, 2020 at 7:41 PM Linus Torvalds
> > > > > <torvalds@linux-foundation.org> wrote:
> > > > > >
> > > > > > On Sat, Nov 7, 2020 at 1:29 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > > > > >
> > > > > > > It's buggy:
> > > > > >
> > > > > > Ack. Who is taking this? Should I do it directly, or expect this
> > > > > > through Greg's tty/char tree, or what?
> > > > >
> > > > > I've sent out v2 with more archive links, typo in commit message fixed
> > > > > and ack from Peilin added. I'll leave merging up to you guys. Note
> > > > > that cc: stable still needs to be added, I left that out to avoid an
> > > > > accidental leak.
> > > >
> > > > Great, I'll grab this now and add it to my tty tree and send it to Linus
> > > > later today.
> > > >
> > > > Unless I should be holding off somehow on this?  I didn't see anyone
> > > > wanting to embargo this, or did I miss it?
> > >
> > > Given that Minh didn't ask for any embargo, and it's good to get this
> > > fixed as soon as possible, I've queued this up and will send it to Linus
> > > in a few minutes.
> > >
> > > Thanks all for the quick response,
> >
> > cc: stable didn't get added I think.
> >
> > Stable teams, please backport commit 3c4e0dff2095 ("vt: Disable
> > KD_FONT_OP_COPY") to all supported kernels.
>
> I was going to do that given that I am the same person :)

I thought there's some lts that aren't maintained by you? And distro
teams who randomly still misalign with lts somehow ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
