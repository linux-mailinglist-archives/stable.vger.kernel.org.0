Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB15739F989
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhFHOvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:51:15 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:34351 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233538AbhFHOvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:51:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 037901B6E;
        Tue,  8 Jun 2021 10:49:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Jun 2021 10:49:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=6zu8Yy0uwISQNd3KeZQAasi1XJA
        nn4MoA7LK+JIJ4+Q=; b=WBmHxpXSNYvlRNPCeToHIGjUE+I8xCY1Bm6uN7pDuNb
        Xq5z2jOElQgo04/Lmqr2v53s6NgcEpC7Frj/7A50B9VfybYOAkG8DPXhldHBstIY
        D9LmmZmbFrVaL5nhZ1mPjdW5AawBN1W6vjjxWVKwyMHHVgYKWsN4NqPSO6KdnF9G
        ArfgS9cc838kUPplGioyiOxyVrv+sX+rk+9H7EpHieYYhUgZU01WEs5UPmmQ59xL
        QpN5fyV2jnnWGKo/Oymn2JTabm5YAfmllJH1wLEfNnqyF6os0CgzQnPC28Ybr8FH
        YC791QJQnB4hSAtcBJA36TcphDfSMye4I/B07970NLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6zu8Yy
        0uwISQNd3KeZQAasi1XJAnn4MoA7LK+JIJ4+Q=; b=CSxmnUHdcLcmTIxufNdUHM
        yjALEa8wpDN2G46MKIfSB/OSFXJNdua6CB04jKq2C8MLjWTgi/sx5ydy4argWdYp
        F2BZhhnF2Uej8NR2rY2Pty8q7E8MvQAVIMn8S7ytRJKWAGYkeD0yaPcm1A3a8ZEa
        uaBnU6xeOwbLjrGRQficnU/iBNOcPgs3LgHLyZfQOWS+dM012SrAzlT8A0/P6bGH
        AwLkd6Mf5G8AkhKLt36rIU6ZletcoHRFxGFUq+oiN+SOiOh4GcZe9t7sMMGm6WMG
        xqltGAP+NQgOtnCN5XiTErCwD3D3HRE5Orcaop3IhySax8YTqrZHHoxXP2idA0iw
        ==
X-ME-Sender: <xms:cYO_YKJe58B2ZiA_1AhhzoGioF41rGoY_zHaGF69qMDpMHcsry0y4A>
    <xme:cYO_YCLz1gKqi-AHKJ5wz8d_QTv9x-tKhjkP4kx8hB6afV3crbyD5ato4SgAtTD1A
    XHQkvCswEfQuA>
X-ME-Received: <xmr:cYO_YKtpruokpq-sJ7_c-Pobh9ua197eWm8vvE2oi5EhB79eSkEXFv7R7WthJk6DXOqfiVPBSxqGuhzEJiQlxOKv89bHM_ux>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:cYO_YPYLupfj_1kSOqNbHy1gCFKuFL0aTl26mhGU1hqeg7YSWQ5FCg>
    <xmx:cYO_YBbgAVgmrKFK6yQboFwujL28NqyxvqG89L8vgDaRAiivxR5cUQ>
    <xmx:cYO_YLDJTlGy7pETaPo4K6qRWKBqbpCKkfOpV3epj0UOG6OB2aTlww>
    <xmx:cYO_YGOwURb59Lwpm5P1mbTaK8SiS6wVqReXC6lQ135I0XkplZ2uIg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:49:20 -0400 (EDT)
Date:   Tue, 8 Jun 2021 16:48:54 +0200
From:   Greg KH <greg@kroah.com>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH v2 4.14 00/16] CVE fixes and selftests cleanup
Message-ID: <YL+DVkqdVjKWfbA8@kroah.com>
References: <20210531182556.25277-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531182556.25277-1-fllinden@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 06:25:39PM +0000, Frank van der Linden wrote:
> Now that these are being included in 4.19, I am resending this
> 4.14 series. It was originally sent here:
> 
> https://lore.kernel.org/bpf/20210501043014.33300-5-fllinden@amazon.com/T/
> 
> v2:
>   * The backport repairs in that original series were already included in
>     4.14, so they are no longer needed.
> 
>   * Add additional commit for CVE-2021-31829.
> 
>   * Added cherry-picks for CVE-2021-33200.

All now qeueud up, thanks.

greg k-h
