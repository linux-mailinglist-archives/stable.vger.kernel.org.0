Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C41460EEB
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 07:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhK2GuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 01:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244306AbhK2Gr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 01:47:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392DDC06175B
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 22:43:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BAE9B80D6D
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 06:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5BDC004E1;
        Mon, 29 Nov 2021 06:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638168203;
        bh=SsuKZJ83T3/Zr7xtPiqrkHd95tvU47yLZzw6U2QYHjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wc2qFLeWbh9AlV79FJRMM0toyQKZ6HqZIiMX0247BYh9o7ufoz2dqHt8cIq0KWAEt
         3oGfqcyOgl3ywfmoJpdiN9g/BBGjYdh8/2ycV3j0zqoBuxmnSxzG2y8EyFcbEgEjgu
         O/Q8/uKBgEbZH5mm5iZh7pCnpl2VmXk+t0mXGjDw=
Date:   Mon, 29 Nov 2021 07:43:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kyle Huey <me@kylehuey.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Robert O'Callahan <robert@ocallahan.org>,
        Kees Cook <keescook@chromium.org>,
        Kyle Huey <khuey@kylehuey.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for
 forced signals" failed to apply to 5.15-stable tree
Message-ID: <YaR2iFc/pkM8e6l/@kroah.com>
References: <163758427225348@kroah.com>
 <CAP045ApHdVjC59KE7+morWY_5j4px3O0Fm6F6-cuJ+p6Q9PCPA@mail.gmail.com>
 <87y25ef82b.fsf@email.froward.int.ebiederm.org>
 <CAP045ApWgeLtpGXjEt8DvH1uGJ-2vEo1zq-0EzFcR6F+HNoj7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP045ApWgeLtpGXjEt8DvH1uGJ-2vEo1zq-0EzFcR6F+HNoj7Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 10:23:38PM -0800, Kyle Huey wrote:
> On Tue, Nov 23, 2021 at 9:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> > Kyle Huey <me@kylehuey.com> writes:
> >
> >
> > > Since this is taken care of now, AFAICT, I do have one additional
> > > question. I reported the regression to LKML a day or so before 5.15.3
> > > was cut. What should I have noticed to see that the regressing
> > > changeset was going to 5.15 and where should I have said "hey please
> > > don't ship this on 5.15 yet"?
> > >
> > > I'd like to know what to do next time :)
> > >
> > When patches are added to the stable tree they are posted
> > for review.
> >
> > I was Cc'd on a couple of them because of this discussion.  The list
> > appear to be "<stable-commits@vger.kernel.org>".  Feedback is requested
> > to go to "<stable@vger.kernel.org>".  So I believe this conversation is
> > enough to remove the unnecessary patches before they make it to a stable
> > release.
> >
> > The boiler plate looks like:
> > > Cc: <stable-commits@vger.kernel.org>
> > > Date: Tue, 23 Nov 2021 19:11:53 +0100 (10 hours, 58 minutes, 56 seconds ago)
> > >
> > >
> > > This is a note to let you know that I've just added the patch titled
> > >
> > >     exit/syscall_user_dispatch: Send ordinary signals on failure
> > >
> > > to the 5.15-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > >
> > > The filename of the patch is:
> > >      exit-syscall_user_dispatch-send-ordinary-signals-on-failure.patch
> > > and it can be found in the queue-5.15 subdirectory.
> > >
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> >
> >
> > I hope that helps.
> >
> > Eric
> 
> So if I understand this correctly the best (or maybe even only) way to
> stop a regressing changeset from making it into a stable release is to
> separately search/watch the stable mailing list for the changeset in
> question?

That is the best way, yes.

But note that I also cc: lkml with all stable patches for when they are
in a -rc release to give developers time to object if needed as well, so
you can search there too.

thanks,

greg k-h
