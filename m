Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1782F1E80
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 20:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390634AbhAKTE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 14:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbhAKTE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 14:04:27 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84F0C061794
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 11:03:46 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id f17so33940ljg.12
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 11:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kPTtQzuom5Awb0GxiDKd05xSwBAc8AF72bAoBes2ggE=;
        b=H2kU5UYMYcLQgzHllGugRqyIESmcF7I3idrXTq24h4uCLEVVDpGBmLxGmD8+GhSnGF
         m3sQWed5AyIGadPjSXqHFAF5DYRLez2ICQqJFYKb2qGv5VvYWGCJMpJiiR9pFThDDPpR
         3/cFpiZY2VRv3AnOfbFvv16B9MBZPaZxXw1C0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kPTtQzuom5Awb0GxiDKd05xSwBAc8AF72bAoBes2ggE=;
        b=fVY0yecpNE94t/YvgR+X24heYV7IBK0hkK/vVNSODeXUVKf3oWCz9GYMApWIqJdHXQ
         HuzNgr0En2NV8LmABUHYcwwa5gE2HUemZm/PfTCOOzE46QJHDZekOfeGSsKT5BGMFa//
         GhIWlwmzOGJ4uKaCt1rqrgttCc8vSMWEN1SD6xdlpszqXMwOBY0Ik4SnvwdFd3Dp/ZcJ
         HdP0cA1MRvR3Ur0sHb4UBC5diRJT0V3oncRo383P1ZmHuGUwsdBpPMxSfAN8WUbDLj8F
         v518tGfTXUKZU7cOCI3PqX0IEkYBPhnT5w4dV4VwyvL5Y+Is0QU95RX8NuaEoxxwyDFL
         WywA==
X-Gm-Message-State: AOAM5332KBy2cq/Q20hdrQskG2p+a/3vYVhWfOW8QFWstCRvBsBOqU3y
        JlwQoW7KIM4n7zWQsrQC7EJxZVi1XqXXwg==
X-Google-Smtp-Source: ABdhPJxXUNfeY1YlKqv+9fW06CFFIFobLLdySEL9eIrQYoScQAccRqW21nHRP8Psy67Kdx9W4v6Vig==
X-Received: by 2002:a2e:86d0:: with SMTP id n16mr380125ljj.147.1610391824943;
        Mon, 11 Jan 2021 11:03:44 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id g190sm79871lfd.72.2021.01.11.11.03.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 11:03:43 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id y22so58533ljn.9
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 11:03:43 -0800 (PST)
X-Received: by 2002:a2e:8995:: with SMTP id c21mr368315lji.251.1610391823175;
 Mon, 11 Jan 2021 11:03:43 -0800 (PST)
MIME-Version: 1.0
References: <20210111130048.499958175@linuxfoundation.org> <20210111130053.764396270@linuxfoundation.org>
 <alpine.LSU.2.11.2101110947280.1731@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.2101110947280.1731@eggly.anvils>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 11 Jan 2021 11:03:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=whj+ixuJ7+_h42CRssvsuzHaMsYf-2LjYBaM4dRax7cyQ@mail.gmail.com>
Message-ID: <CAHk-=whj+ixuJ7+_h42CRssvsuzHaMsYf-2LjYBaM4dRax7cyQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 109/145] mm: make wait_on_page_writeback() wait for
 multiple pending writebacks
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+2fc0712f8f8b8b8fa0ef@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 9:55 AM Hugh Dickins <hughd@google.com> wrote:
>
> I think it's too early to push this one through to stable:
> Linus mentioned on Friday that Michael Larabel of Phoronix
> has observed a performance regression from this commit.

That turned out to be a red herring. Yes, Michael saw a performance
regression on some machines, but the change to go back to the old
model (where the repeat was basically at wakeup time rather than in
the waiter) didn't actually make any difference.

And the issue only showed on a couple of machines, and only with
certain configurations (ie apparently switching to the performance
governor made it go away).

So it seems to have been some modal behavior about random timing
(possibly just interaction with cpufreq) rather than a real
regression.

I think the real issue is simply that some loads are very sensitive to
the exact writeback timing patterns. And I think we're making things
worse by having some of the patterns be very non-deterministic indeed.

For example, long before we actually take the page lock and then wait
for (and set) the page writeback bit, look at how we first use the
Xarray tags to turn the "page dirty" tag into "page needs writeback"
tag, and then look up an array of such writeback pages: all without
any real locking at all (apart from the xas lock itself for the
tagging op).

Making things even less deterministic, the code that doesn't do
writeback - but just _wait_ for writeback - doesn't actually serialize
with the page lock at all. It _just_ does that
"wait_for_page_writeback()", which is ambiguous when there are
consecutive writebacks happening. That's actually the case that I
think Michael would have seen - because he obviously never saw the
(very very rare) BUG_ON.

The BUG_ON() in page writeback itself is serialized by the page lock
and so there aren't really many possibilities for that to get
contention or other odd behavior (the wakeup race being the one very
very unlikely notable one). In contrast, the "wait for writeback"
isn't serialized by anything else, so that one is literally "if was at
writeback at some point, wait for it to no longer be", and then the
aggressive wakeup was good for that case, while it caused problems for
the writeback case.

Anyway, the numbers are all ambiguous, the one-liner fix is not
horrible, and the take-away from all of this is likely mostly: it
would be good to have some more clarity about the whole writeback and
wait-for-writeback thing.

In many ways it would be really line to have a sequence count rather
than just a single bit. But obviously that does not work for 'struct
page'.

Anyway, don't hold up this "get rid of BUG_ON() in writeback" patch for this.

              Linus
