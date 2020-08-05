Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C03723D187
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgHEUCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHEQjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:39:40 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9059CC008689
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 09:39:39 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id 185so38213627ljj.7
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 09:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0zVZoAJleV8CNiiAXe/D7u75xP/RUF3FAzG59wLhYYQ=;
        b=EmG0TRtgM35UxzdU5qpsjvfMfFCNu2ktBs1L4qK25LD0vVz5X++gIch5TpxjZIFGLA
         FONDWlHzc4Vu1S1/6UyavVOfZiUN8VKq+L1vfIuNURR15mfH0NF7IefEfsn3niecsB7Q
         ZVvfoS0Gu2SspEs2b8rYCXqagVABulslM86hY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0zVZoAJleV8CNiiAXe/D7u75xP/RUF3FAzG59wLhYYQ=;
        b=UMdQrfeqMA0wcys706DGCXETT1jD+NWhKtwXqCNtRdJW+EVrgO/NYiBIgbis775Jxc
         O6183/y/lW6tiI6ILBL5wnNyiYPaxslP7SMD6oOnc3bGA/H7lnocjYtfRbw7Mke3EY+n
         W8BdCZ0sZy6Jvn2JTkTPrRjVuL4GJS5osyLMJUkjftRzbUUXNSmMo7NVCxQaExONVI8I
         cho/Oi0DecqFpU8xFKmL0aOXyNRa3O7vf/gPvg/LHI9/fExv+Jl0knv27tqgaoAEEhkv
         WDpoMTsxNeMCNkiuSGjyMi+3SoPp5gzEzv6noqQNGmh7hGfNr2VSRWDds4OgTdBc57Qr
         Gzgw==
X-Gm-Message-State: AOAM531+DviccdSzxEH2u5n9rgx4yb7dH3FU6GFkNGhzyqsYQ4Z1NNje
        OdsVaiqt7cgklelSeaCAX+YevFYq6D4=
X-Google-Smtp-Source: ABdhPJx+f6/Gu478O/Nso+SIwRfLGcEN14mqnHWWGu4MIrjuqpvcXx+CW5TExx1iDX8KAcr6I41BFg==
X-Received: by 2002:a2e:7d0b:: with SMTP id y11mr1902832ljc.134.1596645576582;
        Wed, 05 Aug 2020 09:39:36 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id c4sm1104164ljk.70.2020.08.05.09.39.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 09:39:35 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id 185so38213409ljj.7
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 09:39:34 -0700 (PDT)
X-Received: by 2002:a2e:9a11:: with SMTP id o17mr1798783lji.314.1596645574541;
 Wed, 05 Aug 2020 09:39:34 -0700 (PDT)
MIME-Version: 1.0
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu> <66f06ea1-3221-5661-e0de-6eef45ac3664@gmail.com>
In-Reply-To: <66f06ea1-3221-5661-e0de-6eef45ac3664@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 5 Aug 2020 09:39:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgcBW-VkiF+gQETt7UpZcEZtHNwbbKcN9jxKUQRUQersw@mail.gmail.com>
Message-ID: <CAHk-=wgcBW-VkiF+gQETt7UpZcEZtHNwbbKcN9jxKUQRUQersw@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     Willy Tarreau <w@1wt.eu>, "Theodore Ts'o" <tytso@mit.edu>,
        Netdev <netdev@vger.kernel.org>,
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

On Wed, Aug 5, 2020 at 8:44 AM Marc Plumb <lkml.mplumb@gmail.com> wrote:
>
> I thought net_rand_state was assumed to be insecure and that anyone
> could determine the internal state. Isn't this Working as Designed?

I was working as designed - because it wasn't really designed to be
"real crypto" - but sadly it's also the only thing that is fast enough
for a lot of networking.

So it may be _designed_ to be "not real crypto" and to have a
discoverable internal state. But once again, reality interferes, and
it turns out that people really want something very very fast that is
also not deterministic enough to be discoverable at least remotely.

The stuff that is actually designed and intended to be a complete
black box is sadly also much too slow. By about an order of magnitude.

           Linus
