Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F8A48B4C4
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 19:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241215AbiAKSAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 13:00:49 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:42787 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240999AbiAKSAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 13:00:49 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F211A32020A8;
        Tue, 11 Jan 2022 13:00:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 11 Jan 2022 13:00:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=OP+CqLa1jG/Cdw/U9HJD2UyMq+9
        TQjmHIMCKtArWLvY=; b=pIbqXA72W3quuKhosNWR3EbqG8PfGq23AkkT5U2dROd
        PnGo1fEPSeh+URXJo2z7AxH4uHII4vH3hepo5SFYfK6O/MicHwc9Wiv+Qo7qxIhY
        NwS7OqgTBJfK0kmdXT1gIh3VnodfapvaHqSIqvsBk3OR7B7xJ+ZSpFzZjIf9YpQe
        Ac2J+9ms+UFaZ8Yae6ksPqC80PV/ZVnCFlJYDlZ3U9Jbi74ymvbbPhdloFbYKGNp
        fcEoFXObPqF6dbaeb5gY0icdZsGkXoKoTvSGPti73eJeVc/7wIJ0IH2l0s+/lb7Q
        KUlz+rFTc+vmV3yesqda4JReKRS9ZwS5MfzBn3xzGPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OP+CqL
        a1jG/Cdw/U9HJD2UyMq+9TQjmHIMCKtArWLvY=; b=KPT7uZA1D9M59RdPhdZLn/
        /IrsJfd4rW9Wnh3GjOHRUE7HrscTkohEVB4rJ5Ijc2K6xCp5nwAz3XYldvMNUdhb
        uittSKHfEW1mxMcMIXQa8XxU1rpttJaPlyz8JomL0i5hivZAQq9733p9SCauyMwx
        WjU0srhxbFgKXCCGOVCbXhGgx2o/fZNXMhRZdkYCc1cSdmceWVoEAoH+fOXy8iaZ
        vMwIb0iDguICynpO1B/R9iy9nZ+GMpBHPRsx9Q5dFWK+hrDXkCwaiTxqa8ogA/fZ
        6HErV06YJ2cm7kKoGLA8OpHOvZN3u6JRbRg+urjL0yufAbj++bgXJjiuyfGALhHA
        ==
X-ME-Sender: <xms:zsXdYUcN0NoIC8FECSxiSIzLUsRpYzwDZFFRrAWpuRt3v34QiLeVAQ>
    <xme:zsXdYWON7S3-BYJ2dC1Jx5tuAFSdvSzB67ZXlXFIexY4fNyC_E2rurhfnROrLHrgg
    ElJSFh-W2cvZA>
X-ME-Received: <xmr:zsXdYVh90CNgwKLG2_EkxxC7n79EOflfS7GC7CSzLkluPsh3a0SKaQIo1o7cQc5BHNO8ZfUbr8fzVXBWFBr3ybuf0O3uPv_z>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudehfedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:zsXdYZ_aZbJ7U3YZrFm-SYvXZt5ez7CLcTgIkfSfoX-2CTfqbpRUvQ>
    <xmx:zsXdYQu0oCBraayKIlUOKZhujRnFZAo53-H9n3QgbJgAlR3pcp2Z-A>
    <xmx:zsXdYQEnOUsJWtFp_94FtV0By56kDpMKIZcVJ3tuB4kqJ2QTUpKS9A>
    <xmx:z8XdYeBrebxgBvME5ZATuL6ac70gAJOQyywGKepyv-rdSCNOLsA1OA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Jan 2022 13:00:46 -0500 (EST)
Date:   Tue, 11 Jan 2022 19:00:38 +0100
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] select: Fix indefinitely sleeping task in
 poll_schedule_timeout()
Message-ID: <Yd3Fxn22YA1cLpme@kroah.com>
References: <20220110181923.5340-1-jack@suse.cz>
 <CAHk-=wj39rpqNZX99dJUpErT+yX9aZN-Z1Lyfx8tbUqFUFeEqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj39rpqNZX99dJUpErT+yX9aZN-Z1Lyfx8tbUqFUFeEqw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 09:12:08AM -0800, Linus Torvalds wrote:
> On Mon, Jan 10, 2022 at 10:19 AM Jan Kara <jack@suse.cz> wrote:
> >
> > A task can end up indefinitely sleeping in do_select() ->
> > poll_schedule_timeout() when the following race happens:
> > {...]
> 
> Ok, I decided to just take this as-is right now, and get it in early
> in the merge window, and see if anybody hollers.
> 
> I don't think the stable people will try to apply it until after the
> merge window closes anyway, but it's worth pointing out that this
> change (commit 68514dacf271: "select: Fix indefinitely sleeping task
> in poll_schedule_timeout()" in my tree now) is very much a change of
> behavior, and we may have to revert it if it causes any issues.
> 
> The most likely issue it would cause is that some program uses
> select() with an fd mask with extra garbage in it, and stale fd bits
> that pointed to closed file descriptors used to just be ignored. Now
> they'll cause select() to return immediately with those bits set.
> 
> And that might then cause a program to perhaps still work, but
> busy-spin on select(), wasting CPU time. Or it will walk the result
> bits, see them set, try to read/write to them, get EBADF, and clear
> them. Or not clear them and just be very unhappy indeed.
> 
> So while I think this version of the patch is still safer than the
> EBADF one - and I think better semantics that happen to match poll()
> too - I think this is a patch that could expose existing bad user
> space.
> 
> We'll see. I considered adding a WARN_ON_ONCE() just to make the
> change in behavior more visible, but ended up not really feeling it.
> 
> End result: I took this patch eagerly not because I was happy to do
> it, but simply because the earlier we test this, the earlier we'll
> know of any problems.  Let's hope there are none.

Thanks for the heads-up for the stable tree relevance, I'll watch out
for this one.

greg k-h
