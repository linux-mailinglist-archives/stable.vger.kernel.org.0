Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6883C14A60B
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 15:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgA0O2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 09:28:21 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:52103 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728866AbgA0O2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 09:28:21 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 271704D6;
        Mon, 27 Jan 2020 09:28:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 27 Jan 2020 09:28:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=4FaZ0yFxteeeNRftK7mgNkM/Igb
        FpTvUNX476Mi1q+8=; b=QnnQpYi7CZ3+zFYUpTCa3ipSKcbenD+mJ5crV5BcqyE
        b1gA1TnZsCWpJz7z11IeWQc/UFNBxb7uucTYtTjWlQtHyMmLeew70TMLg7/J4zC/
        Irl1xJ0zD+RQDjJB/i0jeRIP0mMdCZeVjVNbMPhCfBT/yNZJgBGXplbde5X+vB9u
        vA7divG5Cqk/GaPjs5hL7cRaTDK6cgktyORYT7VR9sqel31WeTJRyzf3pl+teBvz
        JmUAu1qRkMsKev/pFLy97SFL+djG5Hu005++ErOjEjHllMG3lCq1kLWDKawOr/Dy
        NgiM9t4OaC24DhT5eK6TV1SqRxNj1vKzzt2/hZHS+SQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4FaZ0y
        FxteeeNRftK7mgNkM/IgbFpTvUNX476Mi1q+8=; b=LE3Lzlz/MEvASZ6P2zkgn3
        T3OUQImBNz/sPu3voHR9dUIQWdNrKQF6KkMlEeBCRrT4uSCBxBi0Ax2LiDkq3KBF
        r6olSk8+XaYT+dbZjrgGwI6NzqUKdaL/KOZ7YL9iDGmSL153euktuN01xlJ2vDO6
        mnXkQjeHekA8rKgLM+o8GjH/Z3Ci2qxqXDWu8JDBVvZSrDPOqGWV7pHooWTcL/E2
        Bqz70+w8n41M44hwYWt3tFV2d7V1xpn6OsU166NzaSB71padDud0uEMbPPkjEyWn
        Zr6/5PUs7nFg9gwA38yW4fU/rM8JI8vnAVYI7becsuz81V6BYrjJdLlHiTw2NCQg
        ==
X-ME-Sender: <xms:g_MuXoXCVyR7rP7R7_8wFSmR0sUb-88NjvkKRrlXl8KIJkeaeyjvkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfedvgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:g_MuXoSH7MiF0EMZ9gwLV9SiDRCsbYEkJGsZU9nT8Q4gkjdW6g_fBw>
    <xmx:g_MuXkY_1uQXSXBX9Wqbfq4tkYEHI22AooNQwn8emGNo_U-q2Loiiw>
    <xmx:g_MuXldkVDnm9Dx6AqVB2rWooLRvwIKMHC_jtAwGtsoC0w8e4rol1Q>
    <xmx:g_MuXpnAI5SvA2CeDp-fYYcONrZspWWRPX72kcKYLcE19VXgncOC-g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 565163280066;
        Mon, 27 Jan 2020 09:28:19 -0500 (EST)
Date:   Mon, 27 Jan 2020 15:27:44 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200127142744.GA582307@kroah.com>
References: <20200127.121617.552910234324463565.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127.121617.552910234324463565.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 27, 2020 at 12:16:17PM +0100, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19
> and v5.4 -stable, respectively.

All now queued up, thanks!

greg k-h
