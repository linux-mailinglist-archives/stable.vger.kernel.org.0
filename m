Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819C44D032
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 16:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfFTOSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 10:18:02 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60213 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbfFTOSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 10:18:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 714A1221F7;
        Thu, 20 Jun 2019 10:18:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 20 Jun 2019 10:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=z06XPg/xfwXAxdWFt9phkUVC/7R
        yNP0EDhLrNB0Qld0=; b=l9SX9BozOW+6AQqhWzX2/qkYqNunDEtAQV7W8drERiD
        pkP1O4d5l7Psbi35stsj4MZLeMmomSGnpdNw8qMjhRmyIbYeOhqaFN+VyYI6i32u
        AtHYf9NGSa+UsCltpVPJa75Ufa2R64zFigG2c+QHBLWPzRxrJl8ACsd4e1/Xng8O
        /3jNoJNf8CelFZWbcjQhJumSGzsFMzM5tRkomP4Y+Z57mmJdBPnrk98pDqp4hY5K
        LoC0nHPE/xuWfWl6S2vGtwc1DbtcASYRwnRQ0caglgqeROMcLLLmdZhQ7ZtwNYvo
        8KFXUgPCz+zdSRSZQlaqxg3SEf4yVY1QQIQQULvBBpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=z06XPg
        /xfwXAxdWFt9phkUVC/7RyNP0EDhLrNB0Qld0=; b=gcwYcmMCFIuNgX+qiUwCvb
        2FVbSz47rS43Ab24t4ICiD1rVOJyALGcwJ7hrST8JuJDVHPJczJ3J3EHa9h/hF1F
        yHOM7YLDpdkxdilL2h66fbX1DeJHiusxTtb034mW3XTkQ/4dCgIW0v6LUZ79Thnd
        9kNnAO3EWNPQeoyQR1lWrZ1/7J6GpfbhIYe2X1w02sU88rppWii97CTWXK42m9Zx
        gC1AuVuDc03dTHCebhM3CkcePbpe74wiaNwJLVotWQGwC28uQbYoEpaR7C2Ti+at
        xwNqsb21woPp39tyr2ABqcHKXtxF39JqfB8LZRkZoZz4/vuSggfOFpISU2+Z387w
        ==
X-ME-Sender: <xms:mJULXVwZuCCv4beWXNN4bdtWMLNFaatRVnyYfSmxY2MqgfkrfaNNAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtdeggdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:mZULXROHAq81GIbaEslVxLJ7-uAffJGvzcq4a4Tv-S-rG9wyH8TaKw>
    <xmx:mZULXbIEr__A43A8kx9QufsLCNEir2exuK3hz0maTOG_NvfV0rc5nA>
    <xmx:mZULXfdLIa7V5f1StnAy8pNDqY6qW2fZH2_Fn68vPqYTQj8q8dpoBA>
    <xmx:mZULXS_WHfyESPlC3l0z2HyTaOwAjO3BEF1Q9Ny1-lkiXqlIi_oRFw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9542A80060;
        Thu, 20 Jun 2019 10:18:00 -0400 (EDT)
Date:   Thu, 20 Jun 2019 16:17:59 +0200
From:   Greg KH <greg@kroah.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-5.0+ v2 1/3] nvme-tcp: rename function to have
 nvme_tcp prefix
Message-ID: <20190620141759.GC9832@kroah.com>
References: <20190617173352.1902-1-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617173352.1902-1-sagi@grimberg.me>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 10:33:50AM -0700, Sagi Grimberg wrote:
> Upstream commit: efb973b19b88 ("nvme-tcp: rename function to have
> nvme_tcp prefix")
> 
> usually nvme_ prefix is for core functions.
> While we're cleaning up, remove redundant empty lines
> 
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Minwoo Im <minwoo.im@samsung.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvme/host/tcp.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

All 3 now queued up, thanks.

greg k-h
