Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F47DF87
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfD2Jfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 05:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbfD2Jfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 05:35:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBFD7206BF;
        Mon, 29 Apr 2019 09:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556530538;
        bh=9zmqZhZtBjxT4icX2WenqebYIL6qIOcO57BkOtLSLsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HlUl8xcR/d5OZICUezwyPyi+e+2iGA8gWTNV/ssEMJQfBJqfOwNyD/99VILDnDv7l
         t0CtY236NrS8LJFNf3wBs8DwIT0M+rl3yP76u6jFRUvYyhYvRxYOLwhcKpUNNXXqkF
         R0OpjMNyA9p6ZSeZ2L10uzxEMZJNmqsqlaajPq88=
Date:   Mon, 29 Apr 2019 11:35:35 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "RDMA/ucontext: Fix regression with disassociate" has been
 added to the 5.0-stable tree
Message-ID: <20190429093535.GA317@kroah.com>
References: <15565291094471@kroah.com>
 <20190429092621.GU6705@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429092621.GU6705@mtr-leonro.mtl.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 09:26:24AM +0000, Leon Romanovsky wrote:
> On Mon, Apr 29, 2019 at 11:11:49AM +0200, gregkh@linuxfoundation.org wrote:
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     RDMA/ucontext: Fix regression with disassociate
> >
> > to the 5.0-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      rdma-ucontext-fix-regression-with-disassociate.patch
> > and it can be found in the queue-5.0 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> Greg,
> 
> Please be aware that this patch has compilation issues on s390 platform.
> https://patchwork.kernel.org/patch/10920895/#22610993

Is there a fix for this in Linus's tree anywhere that I can pull in?

thanks,

greg k-h
