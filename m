Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24AA3DC14A
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 00:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhG3WyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 18:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbhG3WyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 18:54:00 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5D5C061765
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:53:54 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id q2so14552633ljq.5
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yYbtWfX/VpaE9nHQJkZCw7fSJcFmIUlyV/5TayfE7hA=;
        b=Fqxp+6NowYbKv5rRJ/gXfT9fQE7WNRfQMz7ewsVfXqQCI/6qccNDGPRAZ8zIWLRWJw
         fn5tMHr8L2OzrRt1sMfOgIznX3bwi2JxoMG5PJWoRba5cMouN2loaRB8zJe9tVwaWunw
         MagpwR4oinoVQdlPXNhpjkx0/5EUNLis/kcmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yYbtWfX/VpaE9nHQJkZCw7fSJcFmIUlyV/5TayfE7hA=;
        b=U4BJX5kWpRGnGiNoQUW7/C8TVft8Uy2b/pBtwOg3ob+o5OKxok8ZyYEyx74Z/fB0SZ
         H/6gKcg+cxhvV3CXDkzfbE0N6ftwRQN/5XUQ0j8i9I0D9PgPidG61VGrISz5vSxW3oKk
         T7QdELFjnXttGD0Xy+u31sHV5ZftRPh0xD8ch8Jgd3KRs746Xj3YxxryUvkEp7uX06Q6
         pZ+px+CTiWXcf3tINjQkqsMp+Xie1bRP0yTJFXGr1iXJBIl4CoAYxcVEAfNr9WclCC6m
         xAtL+oXw5XuPoLs+vWFVMjvJyx3W/ooQyNhmqi0ivIqtGg0m2SrA2iXoKktH9bj+2ZNy
         UdHg==
X-Gm-Message-State: AOAM533MBMPxXu7RVulRHqicl/PVrQ9loZPRWdahTCYovW5m9dYa/KQm
        EEe3vaf274lieJYD0gc8E3uqFribuxVbVw88Ajo=
X-Google-Smtp-Source: ABdhPJyPVp3GT6pzW+x1OeCiMwTytWklpeTkUW9IhmZqTfxB6ADWMy7ByrLzC1Ps4s8JsYy3Y4DiNA==
X-Received: by 2002:a2e:9d0a:: with SMTP id t10mr3226217lji.282.1627685632289;
        Fri, 30 Jul 2021 15:53:52 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id 24sm255477lft.98.2021.07.30.15.53.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 15:53:51 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id g13so20817865lfj.12
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:53:50 -0700 (PDT)
X-Received: by 2002:ac2:44ad:: with SMTP id c13mr3528996lfm.377.1627685630269;
 Fri, 30 Jul 2021 15:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210729222635.2937453-1-sspatil@android.com> <20210729222635.2937453-2-sspatil@android.com>
 <CAHk-=wh-DWvsFykwAy6uwyv24nasJ39d7SHT+15x+xEXBtSm_Q@mail.gmail.com>
 <cee514d6-8551-8838-6d61-098d04e226ca@android.com> <CAHk-=wjStQurUzSAPVajL6Rj=CaPuSSgwaMO=0FJzFvSD66ACw@mail.gmail.com>
In-Reply-To: <CAHk-=wjStQurUzSAPVajL6Rj=CaPuSSgwaMO=0FJzFvSD66ACw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 30 Jul 2021 15:53:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjrfasYJUaZ-rJmYt9xa=DqmJ5-sVRG7cJ2X8nNcSXp9g@mail.gmail.com>
Message-ID: <CAHk-=wjrfasYJUaZ-rJmYt9xa=DqmJ5-sVRG7cJ2X8nNcSXp9g@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs: pipe: wakeup readers everytime new data written
 is to pipe
To:     Sandeep Patil <sspatil@android.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 12:23 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll mull it over a bit more, but whatever I'll do I'll do before rc4
> and mark it for stable.

Ok, I ended up committing the minimal possible change (and fixing up
the comment above it).

It's very much *not* the original behavior either, but that original
behavior was truly insane ("wake up for each hunk written"), and I'm
trying to at least keep the kernel code from doing actively stupid
things.

Since that old patch of mine worked for your test-case, then clearly
that realm-core library didn't rely on _that_ kind of insane internal
kernel implementation details exposed as semantics. So The minimal
patch basically says "each write() system call wil do at least one
wake-up, whether really necessary or not".

I also intentionally kept the read side untouched, in that there
apparently still isn't a case that would need the confused semantics
for read events.

End result: the commit message is a lot bigger than the patch, with
most of it being trying to explain the background.

I've pushed it out as commit 3a34b13a88ca ("pipe: make pipe writes
always wake up readers"). Holler if you notice anything odd remaining.

              Linus
