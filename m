Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C3C47FCB3
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 13:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbhL0Mnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 07:43:45 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41177 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233722AbhL0Mnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 07:43:45 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 84BB95C02D5;
        Mon, 27 Dec 2021 07:43:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Dec 2021 07:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=2ROSRJZXuATdJhCcuekJ7Amfp4Z
        tgQ53208KjF4wzZ4=; b=CfNrZA8Z1u28sb53lvtywE/tY4ntmJkA3hklkXe3a/4
        5RJeWoWxfbr8xZs/l4AeDoxL3ZDoIm63OmMSwMUTVMWSa7gzm216F6R3sENhefVr
        abAUN/lbJOL1Vt9prXiMp0fgnbrJKZtE/JyVaB1/+T7dMspNBxaADnIxu31Cg6+u
        VJ50psLPNmJ42ZXSK412R5l35IbcQVdGNUlPdRTnztuw1D2NNPs9PefLOJps4/vK
        I5F1On6uKdLojg6Rrbbz8Ge+7oI95jhjUxrh0BLEnkd8iR0Z2pba9IdqvjvICcLE
        7fY5HZUqra7eF/761WsdwkVw8FtbA3weMj0XcuR2Z9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2ROSRJ
        ZXuATdJhCcuekJ7Amfp4ZtgQ53208KjF4wzZ4=; b=emRGNylp20HrEcLvnbs8Mo
        lkWa5h4kgqElbuxsFvY2xAV6rYWBFt2hHgsG4FqV/SnoSp449MPly0mUz1PW7Klz
        Z1mFGSwf+YGJWobiYwEZvGgibtbjNk+nqlCROvys9M4LerMGY6pOYHYSWVpJ6FaJ
        gywFjaALabqwc6NFmLVt5lXpJ4zdnsubZ3pvXE+c6O9zMqUU5bvw+hryhdqBUZu0
        ryVc25d/nqFuJh1Ak7QpU+Ni5Xp7qyv07C9NEzl8QuqXr1DCcIrkblz+l3iJSRQ9
        FtyUQQ2M5Qh7pyNKB4s5gcoci6fNcsJXcw1vYEf4wg1uyvd0NeS3ornST6eHbtWA
        ==
X-ME-Sender: <xms:ALXJYUnCD3L7GzqIb-YRsZom-9mBImeNlv5UUD-pYKEPxKOE9KJ_XQ>
    <xme:ALXJYT1rhWovC6xJHMR4sjQ0r4P1_j7gLgLbmDrW0O8v6su6u-MIKD7alkYXKd2qh
    B61bBCMoZs8dA>
X-ME-Received: <xmr:ALXJYSrPw_LTvlgT009lomCuDODlhFh8GYft7g8fTYEoNuAwIIH-NTxI_KVjwuI96Gz8WMxHmte-SdpaWXFwh8NvJMnazRxz>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddujedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ALXJYQldGvWtYwcu3qMdLIQv4rs8r77jWKhKxMDXL_0-zN9oQyM1FQ>
    <xmx:ALXJYS13X9orHqgRGUSLt0NzPyiKrZz9B_KNWCbTtHJP-E1p0Si3Pw>
    <xmx:ALXJYXvIGiQiTp6DbDfdCh7MjlxNyakTi2RQuBYh0QiOPgsrlhA2Xg>
    <xmx:ALXJYVQ2_-gZZK5SzSdCHr4psXERx40RjWIzDP0YFuOyvvfFJV2rIw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Dec 2021 07:43:43 -0500 (EST)
Date:   Mon, 27 Dec 2021 13:43:40 +0100
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen/blkfront: fix bug in backported patch
Message-ID: <Ycm0/H0L0O69lS7u@kroah.com>
References: <20211223105308.17077-1-jgross@suse.com>
 <YcRWNWtraLXt9W8v@kroah.com>
 <9823fe0a-2db4-bc4b-2d7c-6363856322ff@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9823fe0a-2db4-bc4b-2d7c-6363856322ff@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 02:40:38PM +0100, Juergen Gross wrote:
> On 23.12.21 11:57, Greg KH wrote:
> > On Thu, Dec 23, 2021 at 11:53:08AM +0100, Juergen Gross wrote:
> > > The backport of commit 8f5a695d99000fc ("xen/blkfront: don't take local
> > > copy of a request from the ring page") to stable 4.4 kernel introduced
> > > a bug when adding the needed blkif_ring_get_request() function, as
> > > info->ring.req_prod_pvt was incremented twice now.
> > > 
> > > Fix that be deleting the now superfluous increments after calling that
> > > function.
> > > 
> > > Signed-off-by: Juergen Gross <jgross@suse.com>
> > > ---
> > >   drivers/block/xen-blkfront.c | 4 ----
> > >   1 file changed, 4 deletions(-)
> > 
> > So this is only needed in 4.4.y?  No other backports were incorrect?
> 
> Yes. 4.4 only.

Great, now queued up, thanks.

greg k-h
