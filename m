Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3712AB206
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 08:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgKIH5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 02:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729777AbgKIH5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 02:57:50 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38549C0613D3
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 23:57:50 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id q206so9313744oif.13
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 23:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EJ8au5qEsvDYGRai/vfwR5ZIYl3fIEb+K9mU6NcUu/g=;
        b=cAfV79JNsCeThQBNB+HquvdcoQ3jTfMpdBpAGz1YeBKMScni/bgZmm2pvVilsS6C0w
         vzprdeTA+bbMfkc9zL15Qjo2uFuDkJaPz4jC13Yd5we3p0OgRooGtyn324M2RTzfHhzz
         44L347OZiPeCLjw5qcCsjjIIU0qoxbHbIPfLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EJ8au5qEsvDYGRai/vfwR5ZIYl3fIEb+K9mU6NcUu/g=;
        b=sXQOr66jF9+olhIfQ3/K6cTno+F7tgloX87ZPfgAqvs89ub+h3CeYPGEhKiqyT4W34
         0Q9LtBaNXiufcOasTpxMf/8C9k97ilfjlSwjLr/Jjt1MOCvsqbg4gT/fXKK+bumTm3zt
         e/lsAWUOvatpHwrU7vqitbHIWBDNMEYzxGR9s/PjvegcFyWcvfr1ta2IqKvUbVohRcdS
         GFgqnL4vbRi+/GRidwR5POxgRbVOLcfzIVCdpG6xAXzibXG/1qYQH9L/QqujmF+96G2+
         S8NRew5HlZhKORNUL/tvE8tuOayvGRFrSC0UKeDlUsX8rJgMRkJutfXmhEFhKPug5+lG
         DypA==
X-Gm-Message-State: AOAM533aZIaWtvAai7auh3TDazb3xGAExnDHhZK3vIAQg+sDPIWDYehY
        sv/4zByW4dZqLJms6hZGaVKO9ELPbZt/ei4lGnetag==
X-Google-Smtp-Source: ABdhPJzSvy/wevatHfvfxESzPvB0UzkflXhrdLU324Cea8UzBWsQ7uVkVU0C9RaXLwhuJV4gigXp3P8lswAfWKRyJJs=
X-Received: by 2002:aca:b141:: with SMTP id a62mr7819946oif.101.1604908669610;
 Sun, 08 Nov 2020 23:57:49 -0800 (PST)
MIME-Version: 1.0
References: <20201107092857.3110264-1-daniel.vetter@ffwll.ch>
 <CAHk-=wjoTrpJcC+VKNwsOF+NFd+LANm_pydcFoaV9PscO0Ogaw@mail.gmail.com>
 <CAKMK7uFzGDe9vV8zef5kU6mS5W-0tTDw2KdUmMgbFJ=WT-F-RA@mail.gmail.com>
 <20201108161335.GB11931@kroah.com> <20201108183640.GA65130@kroah.com>
In-Reply-To: <20201108183640.GA65130@kroah.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon, 9 Nov 2020 08:57:38 +0100
Message-ID: <CAKMK7uHCSxAjcRR8oQRS5uL4i2-iLv38jiN8=7pntoNgQBu+bg@mail.gmail.com>
Subject: Re: [PATCH] vt: Disable KD_FONT_OP_COPY
To:     Greg KH <greg@kroah.com>, stable <stable@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Security Officers <security@kernel.org>,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 8, 2020 at 7:35 PM Greg KH <greg@kroah.com> wrote:
> On Sun, Nov 08, 2020 at 05:13:35PM +0100, Greg KH wrote:
> > On Sun, Nov 08, 2020 at 04:41:35PM +0100, Daniel Vetter wrote:
> > > On Sat, Nov 7, 2020 at 7:41 PM Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > On Sat, Nov 7, 2020 at 1:29 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > > >
> > > > > It's buggy:
> > > >
> > > > Ack. Who is taking this? Should I do it directly, or expect this
> > > > through Greg's tty/char tree, or what?
> > >
> > > I've sent out v2 with more archive links, typo in commit message fixed
> > > and ack from Peilin added. I'll leave merging up to you guys. Note
> > > that cc: stable still needs to be added, I left that out to avoid an
> > > accidental leak.
> >
> > Great, I'll grab this now and add it to my tty tree and send it to Linus
> > later today.
> >
> > Unless I should be holding off somehow on this?  I didn't see anyone
> > wanting to embargo this, or did I miss it?
>
> Given that Minh didn't ask for any embargo, and it's good to get this
> fixed as soon as possible, I've queued this up and will send it to Linus
> in a few minutes.
>
> Thanks all for the quick response,

cc: stable didn't get added I think.

Stable teams, please backport commit 3c4e0dff2095 ("vt: Disable
KD_FONT_OP_COPY") to all supported kernels.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
