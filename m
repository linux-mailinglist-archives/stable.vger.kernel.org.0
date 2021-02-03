Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DD630E823
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 01:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhBDAAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 19:00:30 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53405 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233218AbhBDAA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 19:00:29 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 8CABC5C0163;
        Wed,  3 Feb 2021 18:59:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 03 Feb 2021 18:59:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=bp38dKPy+uAig2WIItwmu/XUscE
        4vOR+ChYYgwuzX9g=; b=aVsGuwRaya9IHJXI9bR7TMZ9bLnBRXux1+9QPkuC5Ru
        qAlEX9Npstg74TBeF/bxlx7WCVuhISsG8T23lvAt93CJ/VYTO91sa1dTr82PUc9y
        kttTd+Rg5dhXOUnEG0BlXKbHbxwUqoiNWSU3HoKqnmYenXXIYwJWpFL2WAyQWdBg
        j5rSNr4tRzZSXi+/S7cXKR7FQtGSFRqkkAQVm2lOgtO4pyae13IU8mEaEzDVmz5Y
        lljRhEKWJGNQTmDInjmw/xahjZQqwDAEMN1aV6iuBHL/9LvEN3TCSpwbWQhpzi2R
        S021rR8J2axmWxAIn3p8jo8FGhYH+FN3HdS3SP0snKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bp38dK
        Py+uAig2WIItwmu/XUscE4vOR+ChYYgwuzX9g=; b=WeOsiHVD2bYdw/BO3HOSjN
        u2+VP606Lgf/Zmny9CtMUW5yc3qDDkHSg8RfKny3R6rDR4JYb+JqD5UxRNBBnvdQ
        igpiR7gk6iHTjDGyx/VC0Za8GrJPfhfSrgViAWmHg30ALifLgRo7ItXHnXBAptyb
        g+FSnJIEavVsVGuNM+VPN/YTBrp8zw80R8AXqoyFCZ/DexMHNZZyhAuAfnI7712x
        Sa+naPLerPUzG0RMtNLObN20QhKoKuufRwkiG6gGT/PNPAODF1zBBZtC61lvKFEy
        CpmAspYbQ4PnW7F2P7gL5YpHDIg9CrZNde2Sc79Q+JoWpblqQqEKWwibYbPQjITQ
        ==
X-ME-Sender: <xms:7jgbYEZP8u21reSSe5z7dBjwUA1TYAiUhhQqKxdQQyf7q2wmYqtrLA>
    <xme:7jgbYPbA4hPkv0of6XNotdOeXtsqNFV2RD82PIPFaoqjUt9n16P4wbCBToISYTjAM
    P_ibCIhu3ogQwPUAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeefgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeffhfeu
    ffdunecukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vg
X-ME-Proxy: <xmx:7jgbYO-EEV9Gf6J6cm-9yvaUGGmUGRP8X5WWZKcvRibrk_4JEtxKTg>
    <xmx:7jgbYOq_G0tvXaLSBzAcMNJAZqDr_JszD-hOrr3xq4uP8qaUeloRGQ>
    <xmx:7jgbYPq2OP1N6QYATY0OMZwFsPj7d4g2DogW1uXrx38fIHxgOufkjQ>
    <xmx:7jgbYAkRp6JWjaPFmNoO47m_0snmF-F4hPWHu0FoVY_Fqf18I9uscw>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id EFBD41080063;
        Wed,  3 Feb 2021 18:59:41 -0500 (EST)
Date:   Wed, 3 Feb 2021 15:59:41 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 103/142] Revert "block: end bio with BLK_STS_AGAIN in
 case of non-mq devs and REQ_NOWAIT"
Message-ID: <20210203235941.2ibyrc5z3desyd2q@alap3.anarazel.de>
References: <20200601174037.904070960@linuxfoundation.org>
 <20200601174048.647302799@linuxfoundation.org>
 <20210203123729.3pfsakawrkoh6qpu@alap3.anarazel.de>
 <YBqfDdVaPurYzZM2@kroah.com>
 <20210203212826.6esa5orgnworwel6@alap3.anarazel.de>
 <YBsedX0/kLwMsgTy@kroah.com>
 <14351e91-5a5f-d742-b087-dc9ec733bbfd@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14351e91-5a5f-d742-b087-dc9ec733bbfd@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2021-02-03 15:58:33 -0700, Jens Axboe wrote:
> On 2/3/21 3:06 PM, Greg Kroah-Hartman wrote:
> > On Wed, Feb 03, 2021 at 01:28:26PM -0800, Andres Freund wrote:
> >> On 2021-02-03 14:03:09 +0100, Greg Kroah-Hartman wrote:
> >>>> On v5.4.43-101-gbba91cdba612 this fails with
> >>>> fio: io_u error on file /mnt/t2/test.0.0: Input/output error: write offset=0, buflen=4096
> >>>> fio: pid=734, err=5/file:io_u.c:1834, func=io_u error, error=Input/output error
> >>>>
> >>>> whereas previously it worked. libaio still works...
> >>>>
> >>>> I haven't checked which major kernel version fixed this again, but I did
> >>>> verify that it's still broken in 5.4.94 and that 5.10.9 works.
> >>>>
> >>>> I would suspect it's
> >>>>
> >>>> commit 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048
> >>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>> Date:   2020-06-01 10:00:27 -0600
> >>>>
> >>>>     io_uring: catch -EIO from buffered issue request failure
> >>>>
> >>>>     -EIO bubbles up like -EAGAIN if we fail to allocate a request at the
> >>>>     lower level. Play it safe and treat it like -EAGAIN in terms of sync
> >>>>     retry, to avoid passing back an errant -EIO.
> >>>>
> >>>>     Catch some of these early for block based file, as non-mq devices
> >>>>     generally do not support NOWAIT. That saves us some overhead by
> >>>>     not first trying, then retrying from async context. We can go straight
> >>>>     to async punt instead.
> >>>>
> >>>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>
> >>>>
> >>>> which isn't in stable/linux-5.4.y
> >>>
> >>> Can you test that if the above commit is added, all works well again?
> >>
> >> It doesn't apply cleanly, I'll try to resolve the conflict. However, I
> >> assume that the revert was for a concrete reason - but I can't quite
> >> figure out what b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e was concretely
> >> solving, and whether reverting the revert in 5.4 would re-introduce a
> >> different problem.
> >>
> >> commit b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e (tag: block-5.7-2020-05-29, linux-block/block-5.7)
> >> Author: Jens Axboe <axboe@kernel.dk>
> >> Date:   2020-05-28 13:19:29 -0600
> >>
> >>     Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT"
> >>
> >>     This reverts commit c58c1f83436b501d45d4050fd1296d71a9760bcb.
> >>
> >>     io_uring does do the right thing for this case, and we're still returning
> >>     -EAGAIN to userspace for the cases we don't support. Revert this change
> >>     to avoid doing endless spins of resubmits.
> >>
> >>     Cc: stable@vger.kernel.org # v5.6
> >>     Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> >>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>
> >> I suspect it just wasn't aimed at 5.4, and that's that, but I'm not
> >> sure. In which case presumably reverting
> >> bba91cdba612fbce4f8575c5d94d2b146fb83ea3 would be the right fix, not
> >> backporting 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048 et al.

Having looked a bit more through the history, I suspect that the reason
5.6 doesn't need c58c1f83436b501d45d4050fd1296d71a9760bcb - which I have
confirmed - is that ext4 was converted to the iomap infrastructure in
5.5, but not in 5.4.

I've confirmed that the repro I shared upthread triggers in
378f32bab3714f04c4e0c3aee4129f6703805550^ but not in
378f32bab3714f04c4e0c3aee4129f6703805550.


> > Ok, can you send a revert patch for this?
> > 
> > But it would be good to get Jens to weigh in on this...
> 
> I'll take a look at this.

Thanks.

Greetings,

Andres Freund
