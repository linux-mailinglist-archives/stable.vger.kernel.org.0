Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D961136668
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 06:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgAJFDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 00:03:24 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36919 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgAJFDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 00:03:22 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so478130lfc.4
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 21:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B/GI7mSLrO7+AWyztv1F/7+LjmBRdi9pxniW8srHraM=;
        b=WJnSkgb5IoN+QFM9zDo/+1LUciNYCKC1uNr4+jda+SHQ4Al4kAzM40Ki7rykrkdSQb
         LRo6BkP+xKhXKun/nrSizTl2SLNY7SO9HFhXKlKAOnq3AXpHt/oUN004/3so/HMeBcSV
         czfR5SnYRegkSqQWTz+TDMXgEHM9RAu7JIN+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B/GI7mSLrO7+AWyztv1F/7+LjmBRdi9pxniW8srHraM=;
        b=aC9Pi/GpgOGS2t24v+YMBnVDWjOBVn+PNWARRecfaIqSp43iOGk0JZAnTZlv/DZYu8
         Mzd4r98DlZmHIEX9fCQOkgWg3bQFJupNZdbT9m/pjH+36rfBWLbnkeo6YnGpFWXLMXr6
         czPFGUErnX39GgBF33laNefLcZD2j060zTLhxnL8pYHSXXCnjDDZuzW33NXtvL0eU6ev
         FQ/55aAU75Z8QlLNnwFQxW1d52yGPqN5Qf3ttA0uv2EaS9KRYJv9DpjpKDfLtVwS/rqK
         Ti6+dFr6YtaAkeYjj2CetAYD9jiudNI0QrFrgRwXQzQ21BXAbu/loiWGd/I9KPYSppCh
         8bzw==
X-Gm-Message-State: APjAAAXsUXMOOCV2G/PadPJDyKcvarJmmR7t6HGccYk1NuFzERGyC866
        vvqHloUxncDZd0EkEuntZBANv+DbNGc=
X-Google-Smtp-Source: APXvYqzpAnpyc7qjtL257s+nt8nUtJ3y/vP8je8bHjby7SvXHl4KLY0bjQfJZKoi5ciShpeuhW6EMA==
X-Received: by 2002:a19:491a:: with SMTP id w26mr914592lfa.98.1578632599915;
        Thu, 09 Jan 2020 21:03:19 -0800 (PST)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id u9sm341796lji.49.2020.01.09.21.03.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 21:03:18 -0800 (PST)
Received: by mail-lf1-f52.google.com with SMTP id r14so476532lfm.5
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 21:03:17 -0800 (PST)
X-Received: by 2002:a05:6512:1dd:: with SMTP id f29mr961529lfp.106.1578632597317;
 Thu, 09 Jan 2020 21:03:17 -0800 (PST)
MIME-Version: 1.0
References: <20200101005446.GH4203@ZenIV.linux.org.uk> <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com> <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com> <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk> <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200108213444.GF8904@ZenIV.linux.org.uk> <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
 <20200110041523.GK8904@ZenIV.linux.org.uk>
In-Reply-To: <20200110041523.GK8904@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Jan 2020 21:03:00 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiF6en6WD7JdYAUxHnzeTgs3P08ysDQPv4504hQ2qUcmA@mail.gmail.com>
Message-ID: <CAHk-=wiF6en6WD7JdYAUxHnzeTgs3P08ysDQPv4504hQ2qUcmA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over symlinks
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Aleksa Sarai <cyphar@cyphar.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Kent <raven@themaw.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 9, 2020 at 8:15 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Hmm. If that's the case, maybe they should be marked implicitly as
> > O_PATH when opened?
>
> I thought you wanted O_PATH as starting point to have mounts traversed?
> Confused...

No, I'm confused.  I meant "non-O_PATH", just got the rules reversed in my mind.

So cwd/root would always act as it non-O_PATH, and only using an
actual fd would look at the O_PATH flag, and if it was set would walk
the mountpoints.

> <grabs Bach> Right, he simply transcribes v7 iget().
>
> So I suspect that you are right - your variant of iget was pretty much
> one-to-one implementation of Bach's description of v7 iget.

Ok, that makes sense. My copy of Bach literally had the system call
list "marked off" when I implemented them back when.

I may still have that paperbook copy somewhere. I don't _think_ I'd
have thrown it out, it has sentimental value.

> > I think that in a perfect world, the O_PATH'ness of '42' would be the
> > deciding factor. Wouldn't those be the best and most consistent
> > semantics?
> >
> > And then 'cwd'/'root' always have the O_PATH behavior.
>
> See above - unless I'm misparsing you, you wanted mount traversals in the
> starting point if it's ...at() with O_PATH fd.

.. and see above, it was just my confusion about the sense of O_PATH.

> For cwd and root the situation is opposite - we do NOT traverse mounts
> for those.  And that's really too late to change.

Oh, absolutely.

[ snip some more about your automount digging. Looks about right, but
I'm not going to make a peep after getting O_PATH reversed ;) ]

            Linus
