Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086A81B3A33
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 10:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDVIeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 04:34:50 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:55939 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbgDVIet (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 04:34:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 395A34B9;
        Wed, 22 Apr 2020 04:34:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 22 Apr 2020 04:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=GTzuxwscqxNkj3MH9QM7iWDxwu9
        iCTHXmbcIwpx3NJM=; b=J4mzU3qFoun8/L4/lX0VdR2xWXwjVhrT2yKuRseB42w
        gH+noP7t27+5oKmCl80vVWLip+1BG63cAHTKAcf1jFW73uRxGaubrabt1iHRUgIV
        5PWvJX+Smn7PhFz4ISIXjZrAYTL5WLjqnWJsXOeWwBZh6NIJCj+KIMi8DUd9yfXb
        UOj0aA5Re2NJF2gNGq0YAzBDs9+P3mZAMEbYaTCyQGOKl7YwtUNcEfXyhUouUfLN
        u4bmW2f6lhRJdtyTWLQKZ45FNnlgENNsGMa9WFCFAni47EgpqdD8T+pUp0Rfo09d
        ijjEdBDjZgT7bzvkl2n37Oy+diFBEnn4ZV93QjPw7GQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GTzuxw
        scqxNkj3MH9QM7iWDxwu9iCTHXmbcIwpx3NJM=; b=ADJyHPmxMB0Pag/Gk5aeE2
        d4HFkONh/1Dc/U1BWvCsViUXFkWmWiTZFhnlqZdp/lRvDg7qbi7PLC2SxWUgCzaw
        JsN4Pn1AZdmUji0Z4BxAHD2LpI4Re3Jy4weLvzkOwT9+YZYS/hXn7SeP42T2VbMT
        EU1GQtwmL6c+Tm1eCrvEEZV0H7phM9ukL5v2sENLRsqJBMAUB/MYDmRV0zvc1Hyj
        ReuhbSz416mqstfH5/gXW+Cn4WYsKlAUgDX+paJIGzC36Lh8iiOvHOJ4rPmWmTlF
        Y9Gqu8gddBx8zePvPp6+olbRuCxhDRVejiG0PHbHTKMgsjwYuMidtBxBXEh3t5fg
        ==
X-ME-Sender: <xms:qAGgXvDvXe0xKsgAr3qmG2o92yxcDedKGTqBWz5glIXearlNRf4Yzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeejgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qAGgXkiyzXpg5BOmmG7BF3vSABH_I9-WdBpTmEXphNJR7zGMJZDqyA>
    <xmx:qAGgXm25jlYK4u_GBr-rw_NGm7tImr4VzAdpDSbY19HjQ4qLsiRHPg>
    <xmx:qAGgXvwXlC7KnZCY0LnyL61-1iMPsyAMqC7zWGxMeyMrLXn68xcGQw>
    <xmx:qAGgXhVpw5PI1uC4e9M1XFpgOwn7hR1qHRrmWUyXuKJS6KhjN4WeNA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 39D093065C9D;
        Wed, 22 Apr 2020 04:34:48 -0400 (EDT)
Date:   Wed, 22 Apr 2020 10:34:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fwd: Re: [PATCH AUTOSEL 5.6 082/129] compiler.h: fix error in
 BUILD_BUG_ON() reporting
Message-ID: <20200422083446.GA3039100@kroah.com>
References: <9b7c57b0-4441-12a1-420d-684a84e97ba0@oracle.com>
 <05565e26-e472-67e5-34e9-c466457a0db3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05565e26-e472-67e5-34e9-c466457a0db3@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 10:21:23AM +0200, Vegard Nossum wrote:
> 
> Hi,
> 
> There is no point in taking this patch on any stable kernel as it's just
> improving a build error diagnostic message.

build error messages are nice to have be correct, don't you think?

Seems like a valid fix for me.

thanks,

greg k-h
