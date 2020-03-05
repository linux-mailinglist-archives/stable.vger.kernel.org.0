Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB0A017AE53
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 19:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCESlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 13:41:13 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43337 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgCESlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 13:41:12 -0500
Received: by mail-lj1-f193.google.com with SMTP id e3so7229381lja.10
        for <stable@vger.kernel.org>; Thu, 05 Mar 2020 10:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GyFYtqx37jEduc84+d5pwBxcfH/mxsB1MriBNxAX86U=;
        b=RHIX8oyd/XhxPGVZ1D8Gc7950WIw8PdXBWEEFQBGahK8v+TiZSToq8FzyieSsSUgZL
         LyrLSR6LXPvkeaUzuRnALL+vrw927bPnQhlbOm7VzIawQuLGpIw9vXotbZKKexGzj51P
         wyQEn8I3s2PxzDqma64uA7+QmDlRvDZZy4RaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GyFYtqx37jEduc84+d5pwBxcfH/mxsB1MriBNxAX86U=;
        b=lVZofZo7QxnBhFhpnBblwpmtp94aISJ4MivkbEnuLo6bzYVPjPJZ4ly4MJve1Mok1s
         RvYUexvSlM4DASde8IUhsQhPkU2rNuUku1A6a3RuKglwzkycd0tkBbnAZH85/2z3EFq7
         dJnGFSmKYfI/eHkwzyTQxj5CjHUAbEmwA8lRvtu/SkIATo4rEtc+aZSY15CJA6TrCO3K
         z9Mlbbnc9H85kcE5nSUGhfJ4cTWIHQ41L9mPeJjbnAF7lDLrjNfEWdMAmFjPJNYKd7uc
         meiH8y0cwyvkPB4fJYdMUpNCtxbDku4hReqrKuJ3VZGDR+laX+V8KUzBEjPDjDSsv+FO
         ZIlw==
X-Gm-Message-State: ANhLgQ3tKovMWHOGOciEP+YQYTOZxhOuq0joi2Qb5zsMblusfSFzEDnz
        X7wss8IAHgjCiwPwQzMFbBND1OhnXvPCqA==
X-Google-Smtp-Source: ADFU+vvi3T/c4cq2GdaCQ6G1cdzpqNuEKlwYd/rnm4IRoP7tC++tgH/GtWPPTQy25ozIj3fZYXJIUg==
X-Received: by 2002:a05:651c:2c8:: with SMTP id f8mr5716014ljo.30.1583433669302;
        Thu, 05 Mar 2020 10:41:09 -0800 (PST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id t13sm4931336lfc.68.2020.03.05.10.41.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 10:41:08 -0800 (PST)
Received: by mail-lj1-f170.google.com with SMTP id u26so7237080ljd.8
        for <stable@vger.kernel.org>; Thu, 05 Mar 2020 10:41:07 -0800 (PST)
X-Received: by 2002:a05:651c:502:: with SMTP id o2mr6169123ljp.150.1583433667474;
 Thu, 05 Mar 2020 10:41:07 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-542-sashal@kernel.org>
 <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
 <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com>
 <CAHk-=wgs8E4JYVJHaRV2hMn3dxUnM8i0Kn2mA1SjzJdsbB9tXw@mail.gmail.com>
 <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com>
 <20200218182041.GB24185@bombadil.infradead.org> <CAHk-=wi8Q8xtZt1iKcqSaV1demDnyixXT+GyDZi-Lk61K3+9rw@mail.gmail.com>
 <20200218223325.GA143300@gmail.com> <CAHk-=wgKHFB9-XggwOmBCJde3V35Mw9g+vGnt0JGjfGbSgtWhQ@mail.gmail.com>
 <CANaxB-xTTDcshttGnVMgDLm96CC8FYsQT4LpobvCWSQym2=8qA@mail.gmail.com>
In-Reply-To: <CANaxB-xTTDcshttGnVMgDLm96CC8FYsQT4LpobvCWSQym2=8qA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 5 Mar 2020 12:40:51 -0600
X-Gmail-Original-Message-ID: <CAHk-=wgpHbbOhYtxC1rrZ4xjm1GSfZk6_roKU4++3TQVFDMXiw@mail.gmail.com>
Message-ID: <CAHk-=wgpHbbOhYtxC1rrZ4xjm1GSfZk6_roKU4++3TQVFDMXiw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
To:     Andrei Vagin <avagin@gmail.com>
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

On Thu, Mar 5, 2020 at 12:20 PM Andrei Vagin <avagin@gmail.com> wrote:
>
> After this change, one more criu test became flaky. This is due to one
> of corner cases, so I am not sure that we need to fix something in the
> kernel. I have fixed this issue in the test. I am not sure that this
> will affect any real applications.

It's an interesting test-case, but it's really not doing anything you
should rely on.

The code basically expects a pipe write() to be "atomic" for something
bigger than PIPE_BUF. We've never really guaranteed that (and POSIX
doesn't), but we had this special case where readers would continue to
read as long as there was an active writer, which kind of approximated
that for some cases (and your test-case in particular).

A reader that wants to read everything should do multiple read() calls
until it gets an EOF (or gets the expected buffer size). A regular
read() on a pipe can simply always return a partial buffer (it will
always do so in the case of signals, but what you're seeing is that it
will also now do it if the kernel buffers emptied even when there was
a writer that was ready to fill them again).

And I suspect it wasn't actually the commit you point to that changes
the behavior, I think it's actually the "pipe: remove
'waiting_writers' merging logic" that changed behavior for your test

But because it's then timing-dependent on whether the reader gets all
the data or not, it might bisect to any commit after that point.
Particularly since some of the other commits change timing too..

We could re-introduce the "continue reading while there are active
writers" logic, but if this is the only test that triggers that, I'd
prefer to wait until some real user notices...

But if CRIU itself depends on this behavior (rather than just a test),
then I guess we need to.

So is it just a test-case, or does CRIU itself depend on that "reads
get full buffers"? As mentioned, that really _is_ fundamentally broken
if there is any chance of signals..

                Linus
