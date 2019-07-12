Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA50166BBC
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 13:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfGLLnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 07:43:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53403 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726254AbfGLLnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 07:43:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C8D882233F;
        Fri, 12 Jul 2019 07:43:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 12 Jul 2019 07:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Xs0R5qHM51WRMp1fQUhyB+u9I24
        /Cz0NCf8Jbhu59xU=; b=hpkuejQmhJU19NHI0/cVwJSeTwsxqZspVybkNGOZyDP
        hXWa0MzBYHfS92B9MhhgY+ddgB8p/bhac5PbaUI0eEQVZ4i8McZJJdr9YHsIciy3
        kzb2pQpfJrCP8hG6nWl812lZ2kNPUjTn7mMYVesGbMFItwsoqX4RVHDvL+9ApGIt
        48d6WqcSq6AmCHinLwY/Z2j1rNSuBfTPqEUMgQsKCwaO8pR57QTCQiBeT8Hxe+QX
        6Zx2sQshk4OIOvY2FdTZ2A9YgB71RRLCCIswwW4icafWX7ONhcQpGIMgakm31yEf
        sR3rLsuqI1KFscnV37LlCCvXUa5zPb4O1daV8VXiA8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Xs0R5q
        HM51WRMp1fQUhyB+u9I24/Cz0NCf8Jbhu59xU=; b=uOwVczio3hGuDf136lb3Gn
        tz/vvwl1iLkLdEdx/igEz1KzueVxwLOtJMBx+F0GVoT8vSOJOOnSESG+DEBScWYr
        1iFlp8zOy17hd3nkbBDLsjrdMhD+sWqnWlBn1CDKXzIA6VBd9cHdgvxyGT38CMbt
        v7zivcjJZ1RPe+BzHI2onflkeBwWkKvMx9irPU4s5cEK6bs5rhMa3ig68VIhr4ci
        /GAGUTLexflkvhuKXRxAscvwSpO+WpcRLfPaB7T4VDy7XdTRrC7cTl+AIYphb4og
        EkhIB3uphhjwchwdVjxXtGo/BiirTS/yPjqlaerhI7yFFkGKRQwkQsaRkMdgOrRQ
        ==
X-ME-Sender: <xms:WHIoXUpo5tMDytJR3HgznMDsBYELRLhvPkbhJ9FeIfJgTsvR8dIeSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedtgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:WHIoXRbOZEgefSmK7jt3q3wSTr1EW0YZESXvvNcQ1oilIYAJoB2Bog>
    <xmx:WHIoXRV4DVq0sqzmlS5sIDuxuXmO-DvPTymUwS5ORqnwgxolKeAeCw>
    <xmx:WHIoXcskd8GYfP2zkOo8ibCW9mpPum_UDT0SDzwXo19pKLrnDr5AQA>
    <xmx:WHIoXeqKdHw7AazWPu-7sc-so4oggruNsiMR5A8zS2vrimHJY7_nXA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CEAD080059;
        Fri, 12 Jul 2019 07:43:19 -0400 (EDT)
Date:   Fri, 12 Jul 2019 13:43:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     stable <stable@vger.kernel.org>, Sean Young <sean@mess.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: Remove superfluous check for __linux__
Message-ID: <20190712114317.GA5156@kroah.com>
References: <20181116160939.22085-1-sean@mess.org>
 <6ebc7284-7878-5c5a-de09-44bace1f172e@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ebc7284-7878-5c5a-de09-44bace1f172e@hauke-m.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 11:10:12AM +0200, Hauke Mehrtens wrote:
> Hi,
> 
> Please backport the following patch to Linux stable, OpenWrt now ships
> it backported to kernel 4.14 and 4.19, but it should also work with
> older kernel versions.
> 
> Upstream commit 1287533d3d95d5ad8b02773733044500b1be06bc

Now queued up, thanks.

greg k-h
