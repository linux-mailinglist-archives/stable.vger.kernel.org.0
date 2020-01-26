Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78545149960
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 06:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgAZFzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 00:55:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55213 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725908AbgAZFzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 00:55:01 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id CBE3821B36;
        Sun, 26 Jan 2020 00:54:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 26 Jan 2020 00:54:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=cPpWLEadkT+BcihkEiCvYAYzJ+j
        wJtzLs6bpTFaC+B8=; b=W4COqQvPUSLotjgEe29Tl4Uq6GAQhLJ8E9TUxxiRZFh
        V6IvSpp4F23kbv/W818Q3W3++0MVZDLRyYoSDC1vAD07zCv3GXqBTVWunzsXhDEo
        2LFwQY8j3HUCcD+e47ibhP/EaeUHJz4wNuZFtuBIw5jOmC9JaKJTWXv3d1/WSXpU
        XC+QfBlenOEg9Y6Eb5ci/vYkhWP+4sDKgNyJKR25hxT0xA22TWeOpVpgbfilpsL1
        tNqr7SBx6wHy0dZRdOqpLiYrMmvYFIFpO1vFrObbXAjHMWLeM+sQLYGqqOb8tXqM
        KG8xyQQkP3WIBrIllW5AYls8lq+9y/CCZAzHJrS+HmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cPpWLE
        adkT+BcihkEiCvYAYzJ+jwJtzLs6bpTFaC+B8=; b=n3O9J+d2G/ajeC3UPHhiFH
        7uF4KQH/FlFBDui2NzB/KWgXo3vhB4/8PPVWiToksGRkGJ9Nzrt1hvM+Sl5B+Lbg
        gTSIdjec0y5bytc6V8S6Ieuuu/u4H7Ot43hvuwgkuYsqScdER/1m+lMNCPb1GwxD
        Wg0soTh0gsgC672q7kmLaFJX8EqP9AeaNoZZOvu4JA+BgWQSVhlzhXejR7rHkMFg
        xEbpZ5JX1wcDdPDInu0uusI8foLc3+3OwHML0Fd54BIjwPAycvcsrngKot5cUGl5
        ShvzpytP0aZhLnd+MIsrq5oPTuLJmBVJ0BzFeHe8UU8txudJHuyeVKiPr+NASiog
        ==
X-ME-Sender: <xms:syktXlSNl5WQg8-6jl_oPAACCAYYu63nD_N_TQN39epTsigdAdiVgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdekgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucfkphepie
    ejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:syktXsJ8Dlhg0AWiPKasLNVce0ssmIMmibWZo_G9Yd_elfrveYo1Gw>
    <xmx:syktXiLiG5pAKFnQqRL6GaD_IzOKdiM8dwvtNOYHFqqcpjXJxDU_zA>
    <xmx:syktXng9IjJJhXqy23qvFp3l0oA3bVfICEITctJeg-BcS6wTA6A4wA>
    <xmx:syktXkn1eXtkd444sdIfYPZe216QznZohEomT-nNXlP_oTa570XAOg>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id F37A3306738A;
        Sun, 26 Jan 2020 00:54:58 -0500 (EST)
Date:   Sat, 25 Jan 2020 21:54:57 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH 5.4 033/222] io_uring: only allow submit from owning task
Message-ID: <20200126055457.5w4f5jyhkic7cixu@alap3.anarazel.de>
References: <20200122092833.339495161@linuxfoundation.org>
 <20200122092835.852416399@linuxfoundation.org>
 <1b4a79c1-6cda-12a8-219b-0c1c146faeff@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b4a79c1-6cda-12a8-219b-0c1c146faeff@samba.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2020-01-24 11:38:02 +0100, Stefan Metzmacher wrote:
> Am 22.01.20 um 10:26 schrieb Greg Kroah-Hartman:
> > From: Jens Axboe <axboe@kernel.dk>
> >
> > commit 44d282796f81eb1debc1d7cb53245b4cb3214cb5 upstream.
> >
> > If the credentials or the mm doesn't match, don't allow the task to
> > submit anything on behalf of this ring. The task that owns the ring can
> > pass the file descriptor to another task, but we don't want to allow
> > that task to submit an SQE that then assumes the ring mm and creds if
> > it needs to go async.
> >
> > Cc: stable@vger.kernel.org
> > Suggested-by: Stefan Metzmacher <metze@samba.org>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> >
> > ---
> >  fs/io_uring.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -3716,6 +3716,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned
> >  			wake_up(&ctx->sqo_wait);
> >  		submitted = to_submit;
> >  	} else if (to_submit) {
> > +		if (current->mm != ctx->sqo_mm ||
> > +		    current_cred() != ctx->creds) {
> > +			ret = -EPERM;
> > +			goto out;
> > +		}
> > +
>
> I thought about this a bit more.
>
> I'm not sure if this is actually to restrictive,
> because it means applications like Samba won't
> be able to use io-uring at all.

Yea, I think it is too restrictive. In fact, it broke my WIP branch to
make postgres use io_uring.


Postgres uses a forked process model, with all sub-processes forked off
one parent process ("postmaster"), sharing MAP_ANONYMOUS|MAP_SHARED
memory (buffer pool, locks, and lots of other IPC). My WIP branch so far
has postmaster create a number of io_urings that then the different
processes can use (with locking if necessary).

In plenty of the cases it's fairly important for performance to not
require an additional context switch initiate IO, therefore we cannot
delegate submitting to an io_uring to separate process. But it's not
feasible to have one (or even two) urings for each process either: For
one, that's just about guaranteed to bring us over the default
RLIMIT_MEMLOCK limit, and requiring root only config changes is not an
option for many (nor user friendly).


Not sharing queues makes it basically impossible to rely on io_uring
ordering properties when operation interlock is needed. E.g. to
guarantee that the journal is flushed before some data buffer can be
written back, being able to make use of links and drains is great - but
there's one journal for all processes. To be able to guarantee anything,
all the interlocked writes need to go through one io_uring. I've not yet
implemented this, so I don't have numbers, but I expect pretty
significant savings.


Not being able to share urings also makes it harder to resolve
deadlocks:

As we call into both library and user defined code, we cannot guarantee
that a specific backend process will promptly (or at all, when waiting
for some locks) process cqes. There's also sections where we don't want
to constantly check for ready events, for performance reasons.  But
operations initiated by a process might be blocking other connections:

E.g. process #1 might have initiated transferring a number of blocks
into postgres' buffer pool via io_uring , and now is busy processing the
first block that completed. But now process #2 might need one of the
buffers that had IO queued, but didn't complete in time for #1 to see
the results.  The way I have it set up right now, #2 simply can process
pending cqes in the relevant queue. Which, in this example, would mark
the pg buffer pool entry as valid, allowing #2 to continue.

Now, completions can still be read by all processes, so I could continue
to do the above: But that'd require all potentially needed io_urings to
be set up in postmaster, before the first fork, and all processes to
keep all those FDs open (commonly several hundred). Not an attractive
option either, imo.

Obviously we could solve this by having a sqe result processing thread
running within each process - but that'd be a very significant new
overhead. And it'd require making some non-threadsafe code threadsafe,
which I do not relish tackling as a side-effect of io_uring adoption.


It also turns out to be nice from a performance / context-switch rate
angle to be able to process cqes for submissions by other
processes. Saves an expensive context switch, and often enough it really
doesn't matter which process processes the completion (especially for
readahead). And in other cases it's cheap to just schedule the
subsequent work from the cqe processor, e.g. initiating readahead of a
few more blocks into the pg buffer pool.  Similarly, there are a few
cases where it's useful for several processes to submit IO into a uring
primarily drained by one specific process, to offload the subsequent
action, if that's expensive


Now, I think there's a valid argument to be made that postgres should
just use threads, and not be hampered by any of this. But a) that's not
going to happen all that soon, it's a large change, b) it's far from
free from problems either, especially scalability on larger machines,
and robustness.


> As even if current_cred() and ctx->creds describe the same
> set of uid,gids the != won't ever match again and
> makes the whole ring unuseable.

Indeed.  It also seems weird that a sqpoll now basically has different
semantics, allowing the io_uring to be used by multiple processes - a
task with a different mm can still wake the sqpoll thread up, even.

Since the different processes attached still can still write to the
io_uring mmaped memory, they can still queue sqes, they just can't
initiate the processing. But the next time the creator of the uring
submits, they will still be - and thus it seems that the kernel needs to
handle this safely. So I really don't get what this actually achieves?
Am I missing something here?

Greetings,

Andres Freund
