Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE6EB3E44
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbfIPP7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 11:59:05 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36159 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbfIPP7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 11:59:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 83DD857D;
        Mon, 16 Sep 2019 11:59:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 16 Sep 2019 11:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=yH4xrkuPJkh9SWuzuMBZweMUHFy
        5n2Wx6tFW+z1UQH0=; b=Sx/JQv7Js9m2KFZBazLRy2ceKhUOm4L+3le3voVEyMU
        Byo9OFFQ/9FtxvJokvlkZJ2FDlyRiOIABsaIUExRL1WuY60kum2v0Dau4QkaGYLL
        01+oxgjPuUPCJUg5s+uhlFFlfXOdyg9dUVFLsz8swcGju8jllm03U9cqQDWAwxi5
        nUCSJBTvmztV0GNQydt/CKrL3VKTgnRO65ITSNrjy7rqaL+FnN46v5H7421Kgf+w
        gXKj6B72uXQuIzgz6Mdx7mtZV3fpJVBU+qhUqrh6zIEjxWVR2GmV0vhdJrb9xgL7
        zNofT32ezpWUrDltkyGCNROczLz8mWBGzAxssBzF+rQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yH4xrk
        uPJkh9SWuzuMBZweMUHFy5n2Wx6tFW+z1UQH0=; b=ZLemP9YoI9d+4VLErSBLXa
        jEz8fWbDP7POJkr8muRYax0g2x8MbCc26+qpM8fRIe5yys/JMu4d/FdPYWFpdbI/
        J1FaPfzgsOLQq24050jWRSlpZWgfw8FprXm3Lb+fGVrUJXpqBGQ3+FJqXABhzVWz
        HJh/CKNQaQZaw6bmHmjUcT9Wj1BUfTodbSC4BftSbqidQrcLroxg1x5LdrVjc88q
        +0dE2ln1h+NLktsi1R54PK5r6KtEMCxqx/GEg681bIbylBC/Ix07PRavGJeNPVYE
        qGkG2FH7iVbHwkrvZInnSG/iJnOj7KxDVIkrSdZO27cxaOn/2O/N4kEoyDlwk99Q
        ==
X-ME-Sender: <xms:R7F_XdRvrBlfNlgE1m9X8jCyCDROHjOw1M7N_5qY8K5ehAWiV49Q9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:R7F_XavUCmZteiKDXkExM6NUZq8FDTQ6eg11_apH6iHOlHRscda2gw>
    <xmx:R7F_XXblSIlixMz2ro6Z7KBvt9ZBgXOq8OH6gfpClEtjHtR6Qdf7bg>
    <xmx:R7F_Xc_An-Q-xi65Pxmr9E7UQ1-VAzxcYkXxlfaHqySbIk-0bGe_2g>
    <xmx:SLF_Xcl6On_rzH_VLJJDc7XvsW786Szcs8HsRd7ZD4fwTLdmJZoL-w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C4F6D60068;
        Mon, 16 Sep 2019 11:59:03 -0400 (EDT)
Date:   Mon, 16 Sep 2019 17:59:02 +0200
From:   Greg KH <greg@kroah.com>
To:     Andreas Smas <andreas@lonelycoder.com>
Cc:     stable@vger.kernel.org
Subject: Re: Please include e16c2983fba0 in 4.19.y and 5.2.y
Message-ID: <20190916155902.GA1755730@kroah.com>
References: <CAObFT-TGNVkmm5sgJ4AQfuo6qDtB6y7zAu7L6uyMx+veLjSZYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObFT-TGNVkmm5sgJ4AQfuo6qDtB6y7zAu7L6uyMx+veLjSZYg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 08:45:14AM -0700, Andreas Smas wrote:
> Hi
> 
> The commit
> 
>   e16c2983fba0: x86/purgatory: Change compiler flags from
> -mcmodel=kernel to -mcmodel=large to fix kexec relocation errors
> 
> fixes a regression introduced by:
> 
>   b059f801a937 x86/purgatory: Use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS
> 
> which has gone into 4.19.y and 5.2.y

Now queued up, thanks!

greg k-h
