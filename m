Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4323F304
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 21:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgHGTV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 15:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGTV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 15:21:58 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583F3C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 12:21:58 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id m15so1553699lfp.7
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 12:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LynYp/ZpJ14OAYJsMgQc6rG+L/NKMgH+nC37/Tn8Bm4=;
        b=PDf9UcXYjmlTI6m7JmuWWsZDrtoqlci4FCKfseclkM3rjAal3aRMQpXU/E+x9SVwnQ
         z1QMt+xFD73skmEvIRFBRaJr0JUq+I/A+KStfoSqQHDQrqGFrIIgnX8YIsEE1AuCTmbz
         acDSBR/w236eXQ2oEtEqjqEmfmBNlbAQ4zaIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LynYp/ZpJ14OAYJsMgQc6rG+L/NKMgH+nC37/Tn8Bm4=;
        b=lM+svUrGb1JWJPy2Cf4ziweY1Tuw/L0OI4lAKovb6vBr6AfBQB+Wmgu2xWw+9bS7U3
         LZLJBT2KUzo4vTvgoFT93+8ciB1t5AC56yslpbwvioB6foVKByENhuH2GJdd+vgk7yyA
         LEtt9Ff2iTiDArQh+B71ZVG+04chTSbKYJvcNVeLBTMX50IKgyKe5FWz96oYVHCM7jUY
         Y/7PmWyUxbxERwSZQfOP/iMF8Os3i4ykMsEFXHvIId5rfwOovipwGOWp1tbiCEFF0MUW
         dQvhh+0AwK2frJVu8YF50rgux3XP1ikZPsN2gG0uAA9AcCuk/b7cLBYfVW7+ht0h8LK8
         GvAQ==
X-Gm-Message-State: AOAM533PSCAVbd6e7oGxyodEwJYfLZV7yuZ05HkO3w1ApLPfTb6ifNeX
        I5eps4duRxVzWor5exEkM7UdoUHKZGhvUA==
X-Google-Smtp-Source: ABdhPJxFG0SK/SJntdwUNZbP0uNOsuczRETd3P9ycxPpw6CtGAjgU2p66jtI1KHhW0psEzRTvFcqXQ==
X-Received: by 2002:ac2:46d0:: with SMTP id p16mr7257128lfo.142.1596828115108;
        Fri, 07 Aug 2020 12:21:55 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id e19sm1510126lfc.7.2020.08.07.12.21.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 12:21:53 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id c15so1560145lfi.3
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 12:21:52 -0700 (PDT)
X-Received: by 2002:a19:c206:: with SMTP id l6mr6982421lfc.152.1596828112235;
 Fri, 07 Aug 2020 12:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj4p3wCZpD2QU-d_RPTAsGiAUWHMiiVUv6N3qxx4w9f7A@mail.gmail.com>
 <940D743C-4FDD-43B5-A129-840CFEBBD2F7@amacapital.net>
In-Reply-To: <940D743C-4FDD-43B5-A129-840CFEBBD2F7@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Aug 2020 12:21:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=whf+_rWROqPUMr=Do0n1ADhkEeEFL0tY+M60TJZtdrq2A@mail.gmail.com>
Message-ID: <CAHk-=whf+_rWROqPUMr=Do0n1ADhkEeEFL0tY+M60TJZtdrq2A@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Willy Tarreau <w@1wt.eu>, Marc Plumb <lkml.mplumb@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 7, 2020 at 12:08 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
> > On Aug 7, 2020, at 11:10 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >
> > I tried something very much like that in user space to just see how
> > many cycles it ended up being.
> >
> > I made a "just raw ChaCha20", and it was already much too slow for
> > what some of the networking people claim to want.
>
> Do you remember the numbers?

Sorry, no. I wrote a hacky thing in user space, and threw it away.

> Certainly a full ChaCha20 per random number is too much, but AFAICT the network folks want 16 or 32 bits at a time, which is 1/16 or 1/8 of a ChaCha20.

That's what I did (well, I did just the 32-bit one), basically
emulating percpu accesses for incrementing the offset (I didn't
actually *do* percpu accesses, I just did a single-threaded run and
used globals, but wrote it with wrappers so that it would look like it
might work).

> DJB claims 4 cycles per byte on Core 2

I took the reference C implementation as-is, and just compiled it with
O2, so my numbers may not be what some heavily optimized case does.

But it was way more than that, even when amortizing for "only need to
do it every 8 cases". I think the 4 cycles/byte might be some "zero
branch mispredicts" case when you've fully unrolled the thing, but
then you'll be taking I$ misses out of the wazoo, since by definition
this won't be in your L1 I$ at all (only called every 8 times).

Sure, it might look ok on microbenchmarks where it does stay hot the
cache all the time, but that's not realistic. I

               Linus
