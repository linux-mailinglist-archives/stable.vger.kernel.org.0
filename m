Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E072174E4
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfEHJT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:19:29 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:43633 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726589AbfEHJT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 05:19:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 63B634A3;
        Wed,  8 May 2019 05:19:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 08 May 2019 05:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Qx5s+3gMk23EZhvj8bdaljTEiFo
        MwLGd3Y7gAN+zmYA=; b=Jf905llrUndvCGe7u6vbkIzRIWRHn9DVBqaGx6I+zwI
        mq6OCGsQg9PFDDC5NJI1Bv/QjFHDQ6Ah0hUMNAKVram3DcbVVybABxkHxLAYS4VY
        vP+7nzyHuUiZojYC5pwNNLVPEM/nmpky7D+SW0DdPO3seIhE9Fv0NQfTUSxiZYX4
        7uerxXz1fz8wHf3HG+n2ro50s0PPFOczYBzrLSM206xnOrEAgwES0LPspiE72j92
        3Marm/mXznypKW3I3wd5QiPooW54Ei38RJmdymZR0OTbEhCRBqqzVasLPnL3//3y
        23GtgdaO8qMEsO0/QOzsexlGNr+x/IFEYk9nAd4vSog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Qx5s+3
        gMk23EZhvj8bdaljTEiFoMwLGd3Y7gAN+zmYA=; b=Z2Fg2iDEYzwRFzX/PBxUeN
        Z4o8I0CUEuqz11R0tgEPQUpWx3GpqLO2bhAd0fL6ISqakYxbk6JZNvuaVNnSJbU4
        s6OCyCgS65QciXAe6a5eKYjUGiDmy+4TrzT3kLsst2jvq4fVm8SU5hVJ7dR+wnhF
        P0mnhilzFxtRZ7AiwoWvPb9EhNUTptudWRj4wLJsK2XMbJ/HhJonlvTZ5T4W4O1C
        YGSBHtHGlzL7NDVPD33ZUmB4dNrvcA30RGeKEXgiYDlB/Cr8f7bKeL9DHgdrJdPI
        ZrwX7QUg/mG9LL1rNkBxcZNlP8PnEQLnoHMnfE7weJQ8xqaz0bbRvUm9qJJDAayA
        ==
X-ME-Sender: <xms:HJ_SXHbIJalTLVNiMlSwzKwVkNRZbkNAFotINCGTqOR6WGgu9T0ahw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeefgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekgedrvdeguddrudeliedrleeinecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:HJ_SXLnsNkAH2ULinovsbrThGi9TnrRBoprr4O6QQBjwvXu1MiAM-g>
    <xmx:HJ_SXK3-VDkhb4sNz_G-7ts0w03BALwyAG9Epez1-7ZmZ5-my9w7LA>
    <xmx:HJ_SXD0uPxbplsNtnkROFmQBlD1Mv1Ot_jC9UG4vFeFdgwbuPEnimg>
    <xmx:HZ_SXPQvzUpYCLYtw4OEpi8LGzWGmOJrwl_N7e4H24PmNc2UDh3tZQ>
Received: from localhost (unknown [84.241.196.96])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83B641037C;
        Wed,  8 May 2019 05:19:23 -0400 (EDT)
Date:   Wed, 8 May 2019 11:19:21 +0200
From:   Greg KH <greg@kroah.com>
To:     Yihao Wu <wuyihao@linux.alibaba.com>
Cc:     linux-nfs@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, stable@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        caspar@linux.alibaba.com
Subject: Re: [PATCH 1/2] NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails
 to wake a waiter
Message-ID: <20190508091921.GA1968@kroah.com>
References: <d0b6fc01-0a73-e4f7-b393-3ecc9aacffb0@linux.alibaba.com>
 <2a1cebca-1efb-1686-475b-a581e50e61b4@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a1cebca-1efb-1686-475b-a581e50e61b4@linux.alibaba.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 05:13:25PM +0800, Yihao Wu wrote:
> Commit b7dbcc0e433f ""NFSv4.1: Fix a race where CB_NOTIFY_LOCK fails
> to wake a waiter" found this bug. However it didn't fix it. This can
> be fixed by adding memory barrier pair.
> 
> Specifically, if any CB_NOTIFY_LOCK should be handled between unlocking
> the wait queue and freezable_schedule_timeout, only two cases are
> possible. So CB_NOTIFY_LOCK will not be dropped unexpectly.
> 
> 1. The callback thread marks the NFS client as waked. Then NFS client
> noticed that itself is waked, so it don't goes to sleep. And it cleans
> its wake mark.
> 
> 2. The NFS client noticed that itself is not waked yet, so it goes to
> sleep. No modification will ever happen to the wake mark in between.
> 
> Fixes: a1d617d ("nfs: allow blocking locks to be awoken by lock callbacks")
> Signed-off-by: Yihao Wu <wuyihao@linux.alibaba.com>
> ---
>  fs/nfs/nfs4proc.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
