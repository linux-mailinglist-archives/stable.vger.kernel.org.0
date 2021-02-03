Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24D730D9DF
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 13:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBCMij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 07:38:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56555 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhBCMii (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 07:38:38 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 149BB5C0234;
        Wed,  3 Feb 2021 07:37:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 03 Feb 2021 07:37:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=2w+xN5vmdVOc7H4T1+khVBxtC+C
        fGd9RIlIVm7qydsQ=; b=qH9D+Jj3CGre/ska8pG8g88D/DMtyz7VBNnAx1t4EU6
        /aM0H1YxFXMytoQxRxllESUqwE03NOlwtvlyCfRD1cck3qnTc2TLWTRS95ZYfC9s
        8YFmJkQrLr8StnkeCTMj9d5+FlAA+3jC/8+nKE1x/YKLxR9UJT0Rj0SLM4DIRhW8
        oxKY7bdJ7U7ZycZbvzrUXyWFTwuVzGqnZ6awQriOcPhX3ZNsR5qr0d+P4wEGGO9H
        qvQyI+hp8uyUzDCFOauzmEdBYZTDEsWRDS5ohT0QVT3hDbhNOHpqyyF0m86wMzWu
        q4VOnlS4r9X7whVn8i5JE460WogeiHCas6D0vJkC5+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2w+xN5
        vmdVOc7H4T1+khVBxtC+CfGd9RIlIVm7qydsQ=; b=afIUouhbKq+OP/iOmkXJ8M
        ZIleQxbogIiz+CeWDqe/pNEfBbU1k8TLv4WefNxcKF+gajSk+Rqhu6cqqOX8USxv
        uDpUB7oKa4R+ic+cLVXaUKrt/Ix9APeHFiJx41D0seuDslwcd4EgOdm70jJOT0gn
        TSFLVaSSXY42ZWrA5l3arWXx7RKqzmemryVmnWrrbpQpjbTiH1q4pcvGJwGynTaQ
        0jz00urOjNhBDJR/1qeW8khJf+6AeBEHyBz4A6DHZoEc4TdbrdgVNVJe0a/7hJbh
        ds9sVcZuD02+SBtSPfkwBLuQE2Tz1yayrLinHrLlD+iL85tVIJDQVfmxFTU6TB6Q
        ==
X-ME-Sender: <xms:C5kaYG9_w19K5IZJvOTRUSjS2xHvdzW3BRcUOhz_cQ3XWGyCMYs8Pw>
    <xme:C5kaYGsYBW9JvewQOU1BSXHJ19_0SgsgYl2D56Ta2tGSMRuY4a3g8gwO1NNjeVfMA
    RUolwbALEkvU-0-sA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgedvgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeffhfeu
    ffdunecukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vg
X-ME-Proxy: <xmx:C5kaYMDfHx1dbO7MUuHfP_kVM4uz9X0EAvNOsLOlIdVJ4aX3QkxV4A>
    <xmx:C5kaYOcwfBPUb5hjmXbZ-A-2gCTOwARKLS8iCG6Au1EZwk3kVGkrtg>
    <xmx:C5kaYLMgCINsEnzVUayOMFUeE_p33j83GfQpT4aLFxgLiJTkrauczQ>
    <xmx:DJkaYEoonRmoM1bolNQPjOmpgCyUok-6WgdpTvuSZpPQP8drbbemzA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30004240062;
        Wed,  3 Feb 2021 07:37:31 -0500 (EST)
Date:   Wed, 3 Feb 2021 04:37:29 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 103/142] Revert "block: end bio with BLK_STS_AGAIN in
 case of non-mq devs and REQ_NOWAIT"
Message-ID: <20210203123729.3pfsakawrkoh6qpu@alap3.anarazel.de>
References: <20200601174037.904070960@linuxfoundation.org>
 <20200601174048.647302799@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601174048.647302799@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2020-06-01 19:54:21 +0200, Greg Kroah-Hartman wrote:
> From: Jens Axboe <axboe@kernel.dk>
>
> [ Upstream commit b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e ]
>
> This reverts commit c58c1f83436b501d45d4050fd1296d71a9760bcb.
>
> io_uring does do the right thing for this case, and we're still returning
> -EAGAIN to userspace for the cases we don't support. Revert this change
> to avoid doing endless spins of resubmits.
>
> Cc: stable@vger.kernel.org # v5.6
> Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  block/blk-core.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>

This broke io_uring direct-io on ext4 over md.

fallocate -l $((1024*1024*1024)) /srv/part1
fallocate -l $((1024*1024*1024)) /srv/part2
losetup -f /srv/part1
losetup -f /srv/part2
losetup -a # assuming these were loop0/1
mdadm --create -n2 -l stripe  -N fast-striped /dev/md/fast-striped /dev/loop0 /dev/loop1
mkfs.ext4 /dev/md/fast-striped
mount /dev/md/fast-striped /mnt/t2
fio --directory=/mnt/t2 --ioengine io_uring --rw write --filesize 1MB --overwrite=1 --name=test --direct=1 --bs=4k

On v5.4.43-101-gbba91cdba612 this fails with
fio: io_u error on file /mnt/t2/test.0.0: Input/output error: write offset=0, buflen=4096
fio: pid=734, err=5/file:io_u.c:1834, func=io_u error, error=Input/output error

whereas previously it worked. libaio still works...

I haven't checked which major kernel version fixed this again, but I did
verify that it's still broken in 5.4.94 and that 5.10.9 works.

I would suspect it's

commit 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048
Author: Jens Axboe <axboe@kernel.dk>
Date:   2020-06-01 10:00:27 -0600

    io_uring: catch -EIO from buffered issue request failure

    -EIO bubbles up like -EAGAIN if we fail to allocate a request at the
    lower level. Play it safe and treat it like -EAGAIN in terms of sync
    retry, to avoid passing back an errant -EIO.

    Catch some of these early for block based file, as non-mq devices
    generally do not support NOWAIT. That saves us some overhead by
    not first trying, then retrying from async context. We can go straight
    to async punt instead.

    Signed-off-by: Jens Axboe <axboe@kernel.dk>


which isn't in stable/linux-5.4.y

Greetings,

Andres Freund
