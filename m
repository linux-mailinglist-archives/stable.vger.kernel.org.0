Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459ED2AB4F8
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgKIKc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:32:58 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:32859 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbgKIKc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:32:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 6109110F6;
        Mon,  9 Nov 2020 05:32:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:32:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=V02bO/KA9g5Y7DSRh/qF0MwQ600
        EUer5VdvNDdCgXrw=; b=atXJ/j9O37KBj2v789A2nSQ1SjXPyKfDFV5+iKFWUNZ
        hwmFPmqLb9sAZlwMUMmS9/o4q5mvA8RUD49I2+8M5McVJ7E9tuAO4ogQogucXleF
        /+y0llsm/Pm+yDq0V1vft9sY0n0pnZYjZTUe3/o78hieYRm/ZJV/Rn+x0CwS7Ajr
        cxRo+fqkaHSsy3sxVklfFs9HLri5M4xYe0ZGcZ+GUB7wau74+MAkLxUX7OPUK40b
        id3ba4ZDudKO7sAyGkokuJt1oMk/9/Y75bt6KbgHa/AzdxVTqNnM/MVaqQVXAnjq
        iuvKeMReJDUITQVU0vQKz/e4+Mc+N4V6pfXKsj3/iaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=V02bO/
        KA9g5Y7DSRh/qF0MwQ600EUer5VdvNDdCgXrw=; b=lAdyfoiZZUbugbgTZrDGfU
        yX00BtvKKuEY0lMEsuuk5GvQq9tGks6sUxGQzEuTcGJ5mksY1aCxXKkawR+mg53I
        XgsbiMiu611H65r1u0hystGlGVdezeQALjw56HRjEtAdu+271aOjPE84SKVtxL4K
        d67eWXzIc5tfCo/En77QZfg8EJu8lGuViBIPYpvZyj163kmjtkHu8tjq63rQ/Er3
        GDKz6+1kEKoU/J8tfyzqQAQGBUNIO6JyVJLlpCwfZeBk55r1odGZe2xN0B0E1bg3
        y4tgDA0yivW2UA6AKO6R1+6lqRXiALmeLcMvt4DH5f0+Lka4uRwxVGYcmpJuni2w
        ==
X-ME-Sender: <xms:2BqpXwFUeBDPUbBddNyPR7YQefsMo8XmxTOise_H49eUOyUDvMokLA>
    <xme:2BqpX5XGlrWuuLHT2hn85whiLn6gmn2E7TY7WEu0IH9gxTEEm_lRQXOq9rhXF8j5O
    CqmxFdVKBmobA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2BqpX6LDWAaVfcoN0RLijW7mxKfrKjGcHZJ4zS_FoWh47vy4VF5How>
    <xmx:2BqpXyFEyo0Yspd2ec0oDDTfhO1dWCRMKmKL2uBkku8DqXR9jhuYPQ>
    <xmx:2BqpX2VsBMHhXaarZCLdsAVgXAJxHPDHxEznfr--o0T6jwEMkp3ytQ>
    <xmx:2RqpX5dSf1rfjQoH7UAmUDdjTjUbERQTheTDrgatXaQLACIa2ys59w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 773943280060;
        Mon,  9 Nov 2020 05:32:56 -0500 (EST)
Date:   Mon, 9 Nov 2020 11:33:55 +0100
From:   Greg KH <greg@kroah.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Andy Strohman <astroh@amazon.com>, stable@vger.kernel.org,
        dchinner@redhat.com
Subject: Re: [PATCH 5.4] xfs: flush for older, xfs specific ioctls
Message-ID: <20201109103355.GE1238638@kroah.com>
References: <20201105202850.20216-1-astroh@amazon.com>
 <20201106020705.GC7118@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106020705.GC7118@magnolia>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 06:07:05PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 05, 2020 at 08:28:50PM +0000, Andy Strohman wrote:
> > 837a6e7f5cdb ("fs: add generic UNRESVSP and ZERO_RANGE ioctl handlers") changed
> > ioctls XFS_IOC_UNRESVSP XFS_IOC_UNRESVSP64 and XFS_IOC_ZERO_RANGE to be generic
> > instead of xfs specific.
> > 
> > Because of this change, 36f11775da75 ("xfs: properly serialise fallocate against
> > AIO+DIO") needed adaptation, as 5.4 still uses the xfs specific ioctls.
> > 
> > Without this, xfstests xfs/242 and xfs/290 fail. Both of these tests test
> > XFS_IOC_ZERO_RANGE.
> > 
> > Fixes: 36f11775da75 ("xfs: properly serialise fallocate against AIO+DIO")
> >
> > Tested-by: Andy Strohman <astroh@amazon.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Yeah, looks good to me,
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Now queued up, thanks.

greg k-h
