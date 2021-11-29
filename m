Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83495460EBE
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 07:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240968AbhK2G30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 01:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbhK2G1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 01:27:10 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A58C061574
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 22:23:52 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id r25so1879430edq.7
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 22:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CjEF5Nhzo1rj0ChcchyR6egEY+0yABtWX08Drqq5nEI=;
        b=ZnkqJRYLHp2fFYELcjoZTydP7tzIKuT6KdRAg6QxAliHPjrQYWFaxxsmbek2iZJVXP
         jMC8PKyTDtIFJ7UJm++YBXaKfRPdJURFnUndpcs20P205lIPrMxWlnMYMlVAC2LkYsNB
         YMcRGPxrVl0bMhswwkGbeZ62aF8mAdw7VgXJRaxZKRIJjH7H2nA27f1J12wjulJydf+8
         oyhe7EXJh+jzLTplLmvypyFveLkpTYzWedVqdXWYGCKeGnZSXthjgFJK7ovpCGB4dTo/
         TeIY45srNRo35/7zaUK9k4NF+elO5wk/CIFILfsJ9Uv0bIyBam6z/eGla2bBXSISDkE3
         YzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CjEF5Nhzo1rj0ChcchyR6egEY+0yABtWX08Drqq5nEI=;
        b=KiJMBasgVmTzRc3Sf1Q6BXrKwrqeCngRqefYK58PFUZY8vNMiJHRT+BkKw//7u2bRx
         0/x9IbD/G4ujfNQBpVHg/KBLW4kv2IF/LYSRK5IQZlBYiiGqkqNkhodr1RdAkp0wnnL2
         Y/4eA+eIAP9rIY+ymMlypd5F+5qT5+TgLSUj9R5SlothlyTf9AyZRI/+DKXbpIAevX98
         Asal7ZrPLctepKqDIoFtLKV9xsXs/aeRK4R63eqDLozduePYGBTCXQ6FHIiHbaFPk+N/
         HrbRYsiFnwQjNNU0Me15+Qw95a2v5hsaJXFNLSQpn7bLfGA6k6T2p+yKHee2AiYl+Hwr
         mEiw==
X-Gm-Message-State: AOAM5328rfOTLxHQlH7SPmbwzZsvA5sjiSBjrnyGi3/T8toQpeitcTdC
        upsHUS/KUPQQd5Zm4iZHS9khFb23AKCSsYKEtVdofcNv0hA=
X-Google-Smtp-Source: ABdhPJw+i/mZzT2R/aqyOoEQtyFsjfx0zLYnLvUgxH+5u5dqIcYO6yGtGJTzrS+qy4blCvCyX46I7Fif3Qa1HAaahGk=
X-Received: by 2002:a17:907:94c6:: with SMTP id dn6mr57989607ejc.490.1638167031112;
 Sun, 28 Nov 2021 22:23:51 -0800 (PST)
MIME-Version: 1.0
References: <163758427225348@kroah.com> <CAP045ApHdVjC59KE7+morWY_5j4px3O0Fm6F6-cuJ+p6Q9PCPA@mail.gmail.com>
 <87y25ef82b.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87y25ef82b.fsf@email.froward.int.ebiederm.org>
From:   Kyle Huey <me@kylehuey.com>
Date:   Sun, 28 Nov 2021 22:23:38 -0800
Message-ID: <CAP045ApWgeLtpGXjEt8DvH1uGJ-2vEo1zq-0EzFcR6F+HNoj7Q@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for
 forced signals" failed to apply to 5.15-stable tree
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     gregkh@linuxfoundation.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        Kees Cook <keescook@chromium.org>,
        Kyle Huey <khuey@kylehuey.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 9:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Kyle Huey <me@kylehuey.com> writes:
>
>
> > Since this is taken care of now, AFAICT, I do have one additional
> > question. I reported the regression to LKML a day or so before 5.15.3
> > was cut. What should I have noticed to see that the regressing
> > changeset was going to 5.15 and where should I have said "hey please
> > don't ship this on 5.15 yet"?
> >
> > I'd like to know what to do next time :)
> >
> When patches are added to the stable tree they are posted
> for review.
>
> I was Cc'd on a couple of them because of this discussion.  The list
> appear to be "<stable-commits@vger.kernel.org>".  Feedback is requested
> to go to "<stable@vger.kernel.org>".  So I believe this conversation is
> enough to remove the unnecessary patches before they make it to a stable
> release.
>
> The boiler plate looks like:
> > Cc: <stable-commits@vger.kernel.org>
> > Date: Tue, 23 Nov 2021 19:11:53 +0100 (10 hours, 58 minutes, 56 seconds ago)
> >
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     exit/syscall_user_dispatch: Send ordinary signals on failure
> >
> > to the 5.15-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      exit-syscall_user_dispatch-send-ordinary-signals-on-failure.patch
> > and it can be found in the queue-5.15 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
>
>
> I hope that helps.
>
> Eric

So if I understand this correctly the best (or maybe even only) way to
stop a regressing changeset from making it into a stable release is to
separately search/watch the stable mailing list for the changeset in
question?

- Kyle
