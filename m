Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEC034291
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfFDJDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:03:38 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41904 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbfFDJDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 05:03:38 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so16679675ioc.8
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 02:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PGGbXV/5A7MCMNVCx5qOpkwilQaGa0nkbfgyDMXjqhk=;
        b=u3a2Cz2deBiyon8ARzeWUiwDJ9HkztDWuFu6cdS5tU6NwVdg4bWKIwjVZ7z2BvVjiu
         IKrt1CkESgsy6hToEeLtJcBDls0L6IVfPLwKJ3SSztzFpQH9gUcZ60tE5qa9s+Ffm/mI
         u9QckFWE4Z7VN0lqMo+5++bui54SrU0ZB4oP90fMxhDeKhh41I4ifioyiwTOQyxQyIHZ
         IcLI0UbtUQXUbhUss8HMP8mqC08Y4YeundfgIxpVfREExq6X4lW1sm0XFc9BNITiHN0h
         zaNwhBsOzUSOKYlVK22ZGycwq3pt85Hsmn6vCpy8p6DxwGlcz3oTGKU9KjJzM0U40B+8
         caIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PGGbXV/5A7MCMNVCx5qOpkwilQaGa0nkbfgyDMXjqhk=;
        b=hM9uuwxQwtMCc+MYkwqkpBMYMtvAddXOpRHiK6L6I+O5FYznZVhkg/8wVyTL1mgG+0
         ZvjuwwJroT2aYqTHOvneZMn1M1ghjTlhLxaURzuKWGs4zug1DQJDyBNcZDRTMb5e44At
         AWpZDv7ikaZV/bDyC+f0VLqaZ+HCPqtdIYlh9kmUvmWyyBTJmgX1EtQCoc+G1nYAyFBd
         n5dit/lzNW04rrvf1879NLy0XvKiTqAp6XWX27nMyZCp+6NG+xg6J4V6Eg38j7Qh1h4W
         NMx3sizdEkAHCZkCY0anYW10MlcHccPYWPKkL9L7ypplzoE5ye4W9d929cMQpG00eCmU
         sUmw==
X-Gm-Message-State: APjAAAVBpdaRVqaMFsYbZZorwkkt+IqPfqX2c+tn3ubX8wp4Wdr5tcHD
        bm+JrmGFpsXOjVfdG1LWZbyWcVWfnbKutcrn4yqfOg==
X-Google-Smtp-Source: APXvYqz90r6SramMd4jarOogQEIP9u/taErB/EvHUpIyOr9E+Tv7josT73LOSzfzEg4eXnXUSCphNpD9gv5gvKsCLKM=
X-Received: by 2002:a5d:968e:: with SMTP id m14mr18981733ion.49.1559639017539;
 Tue, 04 Jun 2019 02:03:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190603223851.GA162395@google.com> <CAKv+Gu8VioGy1h8n0zKAqj+m_PBZdRU+BmJDH7=D7=iEiKRpgw@mail.gmail.com>
 <20190604074624.GA6840@kroah.com> <CABXOdTeLtgjzL_V5rgsLnwZLaiK+MnL1BfOr8XeGXW8+Ws9zQQ@mail.gmail.com>
In-Reply-To: <CABXOdTeLtgjzL_V5rgsLnwZLaiK+MnL1BfOr8XeGXW8+Ws9zQQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 4 Jun 2019 11:03:25 +0200
Message-ID: <CAKv+Gu-L-XGV8VkqDYzMZQeqQV2gePd7=texrneU0Ds8KJ9H+A@mail.gmail.com>
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
To:     Guenter Roeck <groeck@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zubin Mithra <zsm@chromium.org>,
        stable <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Jun 2019 at 10:52, Guenter Roeck <groeck@google.com> wrote:
>
> On Tue, Jun 4, 2019 at 12:46 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jun 04, 2019 at 09:38:27AM +0200, Ard Biesheuvel wrote:
> > > On Tue, 4 Jun 2019 at 00:38, Zubin Mithra <zsm@chromium.org> wrote:
> > > >
> > > > Hello,
> > > >
> > > > CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> > > > * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
> > > >
> > > > Could the patch be applied in order to v4.19.y?
> > > >
> > > > Tests run:
> > > > * Chrome OS tryjob
> > > >
> > >
> > > Unless I am missing something, it seems to me that there is some
> > > inflation going on when it comes to CVE number assignments.
> > >
> > > The code in question only affects systems that are explicitly booted
> > > with efi=old_map, and the memory allocation occurs so early during the
> > > boot sequence that even if we fail and handle it gracefully, it is
> > > highly unlikely that we can get to a point where the system is usable
> > > at all.
> > >
> > > Does Chrome OS boot in EFI mode? Does it use efi=old_map? Is the
> > > kernel built with 5 level paging enabled? Did you run it on 5 level
> > > paging hardware?
> > >
> > > Or is this just a tick the box exercise?
> > >
> > > Also, I am annoyed (does it show? :-))  that nobody mentioned the CVE
> > > at any point when the patch was under review (not even privately)
> >
> > CVEs are almost always asked for _after_ the patch is merged, as the
> > average fix-to-CVE request timeframe is -100 days.
> >
> > Also, for the kernel, CVEs almost mean nothing, so if this really isn't
> > an issue, I'll not backport this.
> >
> > And I really doubt that any chromeos device has 5 level page tables just
> > yet :)
> >
>
> FWIW, Chrome OS kernels are not only used in Chromebooks nowadays.
> They are also used in VM images in systems with hundreds of GB of
> memory. At least some of those may well boot in EFI mode.

Yes, but why would you boot those with efi=old_map, which is an option
that is only there for compatibility with old and non-standard EFI
implementations.

> Plus, as
> also mentioned, we do not (and will not) double-guess CVEs. If anyone
> has an issue with CVE creation, I would suggest to discuss with the
> respective bodies, not with us.
>

Fair enough.

> Zubin, as mentioned before, please hold back on -stable backport
> requests for CVE fixes. Please apply CVE fixes to our branches
> directly instead, per the above guidance ("for the kernel, CVEs almost
> mean nothing"). I'll revise our policy accordingly. Again, sorry for
> the trouble.
>

No trouble at all, and apologies for the grumpy tone.

In this particular case, the CVE is highly dubious (imo), since not
every bug is a vulnerability, and this bug is very difficult to hit
even on systems which make use of efi=old_map. While that also reduces
the risk of regressions, pulling this bug into a stable release
requires justification, and sadly, given the apparent policy issues
with assigning CVE numbers, the fact that the patch addresses a CVE is
not sufficient.
