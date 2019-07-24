Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7C472E56
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfGXMAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:00:25 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59391 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727756AbfGXMAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 08:00:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0BDB4220F4;
        Wed, 24 Jul 2019 08:00:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 24 Jul 2019 08:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=EnXava5H8zQINsSZV7SO3pp68F9
        OHtlyHIHUHUHZaiA=; b=Jy4+c209Y2/inxnGPtyKsZeqop5HcBRz4RQ692FY4bS
        QDC/cvU/jIKdiCOGI+ECqb4zomHSxatjNPd0frIgW7tHmAxqts7TC8/t0XbxMFjD
        taQONOrj0GdkzbR1SKF/FPlTKflicAVJWr1qHXbjqHn+Fx0g7aFTNg/xR36E4A9o
        boAtZLnoasl28nG0ljcBC8mvNuLgRUN2QRsGGAlCv7VNveC1tf4IujiWsTscQmLz
        v4T+O5xJvEdhwT1wox0xipeEqgN8lYVNaqH0r+0HkZOcBmavTO0O3oLGauWDMxzw
        OVbIcnQOPqKwSIlxOmog2zI41KaLFzh+ChTVBZyPmmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EnXava
        5H8zQINsSZV7SO3pp68F9OHtlyHIHUHUHZaiA=; b=iwSxNTae9BfHtBYIWy8g9d
        MI9TZFUkycZEogtCaLqYwx3hZLebUZ9l/t/LLLdczBqrj9Oe7ZkOliaEvLKSojpX
        lfAauoJB4u+emDSg1ExrC++zXSZwugiOsbfO+W44z25Q/zHedTs8niyJj7xWMckD
        EBUOno1Id/sxvxLgf9r7xNnecjHZHU0LGWEViW1UC7twkmaGATU+JtSLz1SJtgrp
        VjJgvELtHTTRcxeVfsJxDNgHQhfQhS9ueI7JeXrlKq+hMXc3Kq8MtRCrIzQpP1Eb
        S6jyfDowBwfwqjWxv76PnADyT21tbvceGv3XExrA0ztY0/1yOYbyiwOuKvMiCwAA
        ==
X-ME-Sender: <xms:V0g4XQxJRMaOgssklHOptGtoA8iukNDGA-I7vuQgBAr9Zi-lOFOsIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:V0g4Xde3gLXPw4GIbr5o1xGIZeg52rDrZvUGIz7HzUwwFG7as2efew>
    <xmx:V0g4XWmjGnZ166f2I03g0hQP4AQHGHT6OzheYD-PPBPvKzsMYOZSHw>
    <xmx:V0g4XUTsW_px4vNUtWk7iXMKOKjGrpdFYEKBxdpOnCQ32zYjDyHAzQ>
    <xmx:WEg4Xe8-vQKQQfOxmRpKCQgCG5pnZWSTiTrxTvRFi1ajPxHth1k4NA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 229E180064;
        Wed, 24 Jul 2019 08:00:23 -0400 (EDT)
Date:   Wed, 24 Jul 2019 14:00:21 +0200
From:   Greg KH <greg@kroah.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - Validate the the error value used to index
 error messages
Message-ID: <20190724120021.GB3244@kroah.com>
References: <20190723153059.3987-1-gary.hook@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723153059.3987-1-gary.hook@amd.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 03:31:08PM +0000, Hook, Gary wrote:
> Content
> 
> Backport to 4.9-stable for upstream commit id 52393d617af7b
> 
> The error code read from the queue status register is only 6 bits wide,
> but we need to verify its value is within range before indexing the error
> messages.
> 
> Fixes: 81422badb3907 ("crypto: ccp - Make syslog errors human-readable")

Thanks, now queued up.

greg k-h
