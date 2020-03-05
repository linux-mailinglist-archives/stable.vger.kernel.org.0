Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF55017AF37
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 20:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgCETyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 14:54:15 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33758 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgCETyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 14:54:15 -0500
Received: by mail-oi1-f193.google.com with SMTP id q81so122895oig.0;
        Thu, 05 Mar 2020 11:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZqWlHzyhCikKFonKGJ0xmTAmithkM6Eizd/S+WaA0WU=;
        b=ixCHyDItow1nSYhZ6w6LHPnqSFv2mlCCjNfKPn1J861HUMBgqH1tLJuonJWQSo/7ZR
         MgPkgYi9rYzeqjxhCTu5yjXwhSWH9umr6QxK52m5BltUuaR2D6D6VOFtYnY9BsOlF6CJ
         kwNr/BRIQL6zFwA6CcP7Qh+o5EflMWMRxK3UpsNba7U/GnBT3UO4mUNsPlcVYE+nfXb8
         ikXqFfz7504DcINa4WNOtqiWs4TCiD+mxtUzpfjyLfLrLtqVHIeEzJ9VQbbw1DGdKlRz
         HIqWZn6b+XacjUYvKPryHEDuUFzYJqkdL4/Tk4uODbXej19cR94tTqLb3E58TLr3x0l8
         hhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZqWlHzyhCikKFonKGJ0xmTAmithkM6Eizd/S+WaA0WU=;
        b=Q+VXem1Lp/NyJ/h4jHV2UyE06qF9we6q3BVNwp8w/gBJJS2FB9zNM8CYF69Diu9+TG
         21x2P4Dan1D6wh2ATskQDM74baG6GTqDakjCQV/IgJ0qkN5l8B7wLvL+Jwvvopg7uG8h
         gycQgCOVPkWR1xTnV7ptdeKGNYfNQPU3u4MIHkLggMI3qB3Cm51bXxRk6SHysR9AFtRt
         UwOaQaTZspCBrzCesX5E6gn94ZpEQ1RwgVhHJGFB9kimU9TxZQNdQrSgtTZiERX3UeN6
         Q6bAX+G212OLioZlcmczF91ijSi++AxfugAaVqdt2m5GdtkK7C5r0ZRqbQUGi0eJ0NAz
         qXqg==
X-Gm-Message-State: ANhLgQ3DSLQZ2HkwAj/wKelB6G8UtGI4A95HN7Sz3mdMvEFt58mIDfni
        DTd2KPPT0hesf4Z2YZWtO9RrH9bh9/VBF76Y7+g=
X-Google-Smtp-Source: ADFU+vsFgMEhG5cWn4vZxf3o8RE62gjhlPqvGlsp6zUxbicUiaEpyE4+4xPyUpLOwe8dbk+NW/AFjlioIwk110UMLlY=
X-Received: by 2002:aca:170c:: with SMTP id j12mr83643oii.50.1583438052868;
 Thu, 05 Mar 2020 11:54:12 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-542-sashal@kernel.org>
 <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
 <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com>
 <CAHk-=wgs8E4JYVJHaRV2hMn3dxUnM8i0Kn2mA1SjzJdsbB9tXw@mail.gmail.com>
 <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com>
 <20200218182041.GB24185@bombadil.infradead.org> <CAHk-=wi8Q8xtZt1iKcqSaV1demDnyixXT+GyDZi-Lk61K3+9rw@mail.gmail.com>
 <20200218223325.GA143300@gmail.com> <CAHk-=wgKHFB9-XggwOmBCJde3V35Mw9g+vGnt0JGjfGbSgtWhQ@mail.gmail.com>
 <CANaxB-xTTDcshttGnVMgDLm96CC8FYsQT4LpobvCWSQym2=8qA@mail.gmail.com> <CAHk-=wgpHbbOhYtxC1rrZ4xjm1GSfZk6_roKU4++3TQVFDMXiw@mail.gmail.com>
In-Reply-To: <CAHk-=wgpHbbOhYtxC1rrZ4xjm1GSfZk6_roKU4++3TQVFDMXiw@mail.gmail.com>
From:   Andrei Vagin <avagin@gmail.com>
Date:   Thu, 5 Mar 2020 11:54:01 -0800
Message-ID: <CANaxB-y6_OF4GMKUC=GssEY7Q-sH8y23F3wP2XT31=izSUvHSw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 5, 2020 at 10:41 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Mar 5, 2020 at 12:20 PM Andrei Vagin <avagin@gmail.com> wrote:
> >
> > After this change, one more criu test became flaky. This is due to one
> > of corner cases, so I am not sure that we need to fix something in the
> > kernel. I have fixed this issue in the test. I am not sure that this
> > will affect any real applications.
>
> It's an interesting test-case, but it's really not doing anything you
> should rely on.

I'm agree with this.

> But if CRIU itself depends on this behavior (rather than just a test),
> then I guess we need to.
>
> So is it just a test-case, or does CRIU itself depend on that "reads
> get full buffers"? As mentioned, that really _is_ fundamentally broken
> if there is any chance of signals..

No, it doesn't. I'm agree that we can wait  an report from a real app.

Thanks!
Andrei
