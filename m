Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFA56B3FCD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCJM6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCJM5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:57:42 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A407D57E;
        Fri, 10 Mar 2023 04:57:41 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DF456320082A;
        Fri, 10 Mar 2023 07:57:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 10 Mar 2023 07:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1678453057; x=1678539457; bh=4h
        bZNGAH3VbTqYHe4cWGMIuHI9sJyZoDcjp+RPcyk/M=; b=aBRmzaxBq2hjxCES4c
        yAJkgqHVHuVcZXnuUCAxe6iV/ug2/2KOZXUl/X0Dr0cxGHIhqyrRylTIOIKss0WF
        TXSPYSosNQsJQsFK+QTgvjMnn1kogQghYpduGhOSJSiybQ+s86Ys7yU6rypMncjq
        SxNfFCxbSnEMp7wqKJ3LOkNKn8v//xd8Vc+VSpyE6SQuGL0bs3R5DEzFJ19Ei4OQ
        nWR+4efcxF0EnFYL9bK5tLYyIqnJMV+yC8Cg8eNVR/I31yQn6IC83CLsw76eagof
        D84wd9yMpkizEJSF4vd4Gk91OpQvZv1cfEuMMINVzZUkDblIhpjqgEuzvRJVqgdG
        A02A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1678453057; x=1678539457; bh=4hbZNGAH3VbTq
        YHe4cWGMIuHI9sJyZoDcjp+RPcyk/M=; b=F2oJ9DJPLUOtBGOkYzglEiaxsYNW3
        fPhQHX4BN42oUcESpz9iec+edGOwmfDkEYrOzLXBAS/2cVUUVNLrxy0rFTvlTbKo
        SNB/OXq7WHgK8o3tniEl/H9TFM/sP78QFnrGSoPEt/JI3CZGOHPiry94syXpJNtK
        8tMOCGm0vP4Ya0smbCdYi1G/yWyLDq+tXf1WKDNBOb8GlA0UtS0vlMj+XQhzRgTR
        nKGy1fxTQZ0R1uXvr677YxttAONx/hMPq+Ldfx80ZZY2eiuriPLNsn3Pr09rk1xz
        WOF9F2hqGthZKynk8/+IUbE6J7uXbYmP47Zr2lnytBU5AtPt9LLQxtG4w==
X-ME-Sender: <xms:QSkLZE3X5tC-lPUXdmHvuq-W-xFvl_xQih9wwhobj6UVCOuej68_ew>
    <xme:QSkLZPH1quDfzecAsYWGhw9Icl_QXh-NphCei0dhnaFYmZJE3HJyix4VTU-0viw8y
    6-NwN1VpqSrOg>
X-ME-Received: <xmr:QSkLZM6VTfF4PwudjPjE5-bAjaipqTePRFSLpuXkXRZL1yJMglg1V5LMZ4z4hmayKOMyyjOVSbVdUf5WAt5y1ff8gvbQpFKUyLjQRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddukedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:QSkLZN1Ia3XEHfYA-T3leHNGEyizo-tfco0g-YyWms51E6Nmcin9RA>
    <xmx:QSkLZHFYJHDg5IoVpv78vb7gHbb448rUSw-BgcTrwbTLHdgVfTcIwg>
    <xmx:QSkLZG_KAW57kJAHjjtakvDJn1wG6ibnATXkqe5d94gorzGBGfQ_sw>
    <xmx:QSkLZEe9YT5C22GILSpEi99odMnGKYnEeveGjOTM-W0B7Q3SWJPUhg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Mar 2023 07:57:36 -0500 (EST)
Date:   Fri, 10 Mar 2023 13:57:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Tejun Heo <tj@kernel.org>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 4.19] f2fs: fix cgroup writeback accounting with fs-layer
 encryption
Message-ID: <ZAspPgX+RazeDcgx@kroah.com>
References: <20230308061746.711142-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308061746.711142-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 10:17:46PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 844545c51a5b2a524b22a2fe9d0b353b827d24b4 upstream.
> 
> When writing a page from an encrypted file that is using
> filesystem-layer encryption (not inline encryption), f2fs encrypts the
> pagecache page into a bounce page, then writes the bounce page.
> 
> It also passes the bounce page to wbc_account_cgroup_owner().  That's
> incorrect, because the bounce page is a newly allocated temporary page
> that doesn't have the memory cgroup of the original pagecache page.
> This makes wbc_account_cgroup_owner() not account the I/O to the owner
> of the pagecache page as it should.
> 
> Fix this by always passing the pagecache page to
> wbc_account_cgroup_owner().
> 
> Fixes: 578c647879f7 ("f2fs: implement cgroup writeback support")
> Cc: stable@vger.kernel.org
> Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Chao Yu <chao@kernel.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/data.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
