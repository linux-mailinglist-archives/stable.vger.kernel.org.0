Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEEC4171DF
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbhIXMac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:30:32 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:43681 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245038AbhIXMa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 08:30:26 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7727258118A;
        Fri, 24 Sep 2021 08:28:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 24 Sep 2021 08:28:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=kfZ/ACAH6cRzMT8LidzMyYhdBT7
        TID1gNYRnUhNQHQA=; b=PUxZ6j4w/cKCP4EXvgR2ycrHsXK3n/N/So51LW38SXb
        /LCd8Aw9592t/zibJXpnXLoGR2SDtxzew6oLLD6wkWjPuIue0DIq84Ba2oRWY275
        4NV7RNtEveAVjFd7o5R6/gzchM3cNWtyeSCtlYHW1CN5TgEPk8CDAR5bwBeBNfJ2
        RbdjG8ZBasQYl7XauPP2BKZl2IZJPpWaO2sl+KQzgPZiE0n0F/SEdJylUcivXcCx
        /eJiOP46f1JjwID/u+TSMApiJyIfTtdOXkrawqEkewWNoOmF6+HHTabSd4r2eiyM
        syfodrRtTwAY5CM+r8MeNbsMUdvIfDh1qxsoguGHBXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kfZ/AC
        AH6cRzMT8LidzMyYhdBT7TID1gNYRnUhNQHQA=; b=aYhaH9DhRaRLXs0UmzRIT9
        CNXvXC2Fg1ooqZZU5CjKNML8UMc0HjpmhnAO+amq7w8A6AK03qD/oUHqq6IWFQ2v
        m/MFFD1DJImitxnAF2V+KUYOzkUC4aBv2sNCtYMMxP5D5tkCh2fMn7wMftRDRBxl
        zsZnREMTsjixl1/a2Ly1QGb7tNmmLmdj0UDOmEzgwh6fE4rAqSJGJE2crdP5/Lol
        BjXrmNsqd/JNZuPtgkKOApmxoEo2fAKk5cD1EuhIfOG07P6L0gmRhzlPr23SzXtG
        mi8PeE/ELjj+SweJd30Apm9hU0ce0J9w1aPyCdYXvXMCwKw5TBtHOVyopvKmn9Yg
        ==
X-ME-Sender: <xms:g8RNYdO1Pf_lT8xYZpOcWLwhgvgIPZvKj4vVIKCXHO4dqee3Z50mog>
    <xme:g8RNYf8YHP_SuWOG2FEfV-VdUEgoS3ZcpKgB7dWqrUn9fSEauA1S4lHeWJi75RDvy
    tIeVtKspZLgYw>
X-ME-Received: <xmr:g8RNYcQW4AHLFyslFGjQrd3hPuI_kJXz3oxWgZOiZMlmd0CPzCBst7Z5mcEDuOc-zP-n1agDVnHfQiOTGb59KxeWmXcTdZhc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudejuddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:g8RNYZs1cVrlqDXBKzkzzkwRdg4ztSenSUK6nTgvTtptj_bcj0Qfrg>
    <xmx:g8RNYVfZhEmok3FnhBal20rr-GGgCFlMIOJdfzBxd-sHPItzJmfQwQ>
    <xmx:g8RNYV1Q7_fi1LkZgSmYPKw30BXyOjEfNEoqgTDs2HOgtKjrshbD-A>
    <xmx:g8RNYQ2ELEDMXAdh5zuWPdr59xSR_NUpdUrMAALFB8kk2DIf2lHuDA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Sep 2021 08:28:50 -0400 (EDT)
Date:   Fri, 24 Sep 2021 14:28:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        stable-commits@vger.kernel.org,
        Mike Marciniszyn <infinipath@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: Patch "IB/qib: Fix null pointer subtraction compiler warning"
 has been added to the 5.14-stable tree
Message-ID: <YU3EgPnHcCnBYLOx@kroah.com>
References: <20210924114420.106491-1-sashal@kernel.org>
 <20210924114933.GV964074@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924114933.GV964074@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 08:49:33AM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 24, 2021 at 07:44:20AM -0400, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     IB/qib: Fix null pointer subtraction compiler warning
> > 
> > to the 5.14-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      ib-qib-fix-null-pointer-subtraction-compiler-warning.patch
> > and it can be found in the queue-5.14 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> Please don't take this one, it causes compilation failures on some
> clang versions. I have another fix queued up that will sort it out
> for all compiler versions.

Ok, now dropped, thanks.

greg k-h
