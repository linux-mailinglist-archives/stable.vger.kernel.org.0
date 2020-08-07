Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE3A23EE04
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgHGNTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 09:19:22 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:49939 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgHGNTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 09:19:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A2620A3E;
        Fri,  7 Aug 2020 09:19:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 07 Aug 2020 09:19:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=apoCX5R/ZIpjsdSSyhz0o8QP4c5
        x4wNufAN7KYbRhWY=; b=eVkQNX8KFJ21ojT7RTqVOfiZRPiTiUFgaXM11kxoItK
        TbYhH3Nec2NpuPV0MVyRYnVbMsDYqbvgIJeBbhVgj53smmcu0ZlVkczt6XAGY3HW
        CZw5S4ndP1yfYVevt2IJxRLxX+kvuqf/rrboEYfi87ppwrNx1u98jqn/21C6TkM/
        79qb4ha5GCysCXyzZ6MgfMlqGTcTmCkwTSSjA4mIjAOfR+x6SV4igKED+kPIojO9
        uGcjiQUUZwWpFPH+4sgnBwCT2CySVD6YdatrialonLbZ9TPxsV+L+DpKoK91MQCC
        JgHfBjaCAKfs2TDPq4yd4OOlr2/V34qMmZsmD/11jNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=apoCX5
        R/ZIpjsdSSyhz0o8QP4c5x4wNufAN7KYbRhWY=; b=Ogb7bPAkTS1p0x1vqf2uLz
        CfkyAzpx4YAoaWL9A8hFSSAji3PDfbnwIdS+ZWB+FErEzA4bnKDzmu0S9uXuyq7k
        ldEGlID5AKV1Y9iwg7oYQAYKJkenKowPfWqfvOTFmbUCaSLP4ALX7YHaQ96cNmP1
        +FaZJ4cY+2avXfk5OQDYXOFqHjpBVn/c+tjTgsBfzJeZ3lR0NGg/udwfTTCtatpf
        rk1GutGX/P61nTJcjV2/QW18XWbUBJTprigHhoJrk2KvY4wrEMv20wBFIb8ActuK
        yg3Pw+M/WKuodpfUXG+AF89OFUbAquYvJPTu96qVCki82UFQZsnHTovPbeXlNyCw
        ==
X-ME-Sender: <xms:2FQtX_5MRy-uCLhZJmkFMt7DckpbfGlYabvtZcqNCFq6DQTH5d6izQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedvgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2FQtX04YprYBgDeAhKnj8N06xZS69Ozdato9OY-cW3k80lKDUNGflw>
    <xmx:2FQtX2fF1gF4BV57uA0zMHL5daZfnEh53RQJggLSmqWd7cq5lk-3hw>
    <xmx:2FQtXwIDpE-_NsN1HykzaxJJQA76a01tlXJgD7sUfpQHOtuGe6Nvlg>
    <xmx:2VQtX4UZCdAP2tm8FwPHvMJTbgWGRNELwq0ZYFrv7OgsLYRsPZRbUA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2430130600A6;
        Fri,  7 Aug 2020 09:19:20 -0400 (EDT)
Date:   Fri, 7 Aug 2020 15:19:33 +0200
From:   Greg KH <greg@kroah.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: 5.4 stable inclusion request
Message-ID: <20200807131933.GD664450@kroah.com>
References: <9740b863-25f0-7adc-7bdc-f95bf8c664f5@kernel.dk>
 <69e11137-dd04-5c95-e73c-6c826196d46d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69e11137-dd04-5c95-e73c-6c826196d46d@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 01:10:25PM -0600, Jens Axboe wrote:
> On 8/5/20 12:34 PM, Jens Axboe wrote:
> > Hi,
> > 
> > Below is a io_uring patch that I'd like to get into 5.4. There's no
> > equiv 5.5 commit, because the resulting changes were a lot more invasive
> > there to avoid re-reading important sqe fields. But the reporter has
> > also tested this one and verifies it fixes his issue. Can we get this
> > queued up for 5.4?
> 
> And on top of that, this one as well which is also only applicable to
> 5.4. Thanks!

Also queued up, thanks!

greg k-h
