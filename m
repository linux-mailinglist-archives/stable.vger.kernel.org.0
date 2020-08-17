Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA1A24637B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 11:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgHQJii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 05:38:38 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42217 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbgHQJi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 05:38:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id F32585C00CF;
        Mon, 17 Aug 2020 05:38:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 05:38:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=LiIHfgawxDubrvzbyxnazM7rmVS
        f4u57mf4ehJJKBYY=; b=AklC+r5esVI+oUhflklwFi6UJUQOnumD+IM5h2ukYaz
        Tt6w+KzrNOMtsUJmjVhXUuqQm2qEgAndbEW3liNFUtulE9n6ZlDZbRsJjVdg1lOg
        YFcFiAXug6Ceo4Nrh6tZHE9BqfuYsBjY2Fad289VP/xZqLAhytWqX6cGUkT2+dj/
        ecy16OT4+2A7KJpBI/eEHNG2dDwF8Vb3WSO8NvwFUZ8tE4/tJdx0mc7+0Opbzazp
        ldc/A053pnhjMzqW0Ncq63v8HPX4q2LdLX3Wh2ULNvjdvVLI3heMlGZS7+L+zU/m
        JUBAKMQiaTuDlMHTZ4fuQLOqhLr7rbo3IIcCkftRmjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=LiIHfg
        awxDubrvzbyxnazM7rmVSf4u57mf4ehJJKBYY=; b=rw051dgJYbr9Mr4id1HgZp
        wbIkc+MDT67B7rcmXVOKBXApWobbIRSHQVBYESY6fsWMsJrEd1x18lz3t7Szwwcc
        XxNlRoW1XuHRwJGHa+HSdHDaERp6OKbSLyW8cw/GCickTwoGbLFyYoewmv10Ta9a
        KpUytl/6mKkRBGxjkNiGQ/yVFJ0MiutYoHAxoW57slAVbmR5TM1WfCXTlCmTqzW1
        CVBfgJFp+xMdiQeTfVjRGC0XJh39y1cgqbJ2xx5JEIe3EwkNBsADqhPfCBFiBO7Q
        cJ6LnXctEF2cr/ompSqZAVJXEOFgYzhcNmQRitt8ZuxyHZbWK8d/5nrFtcQiQhbQ
        ==
X-ME-Sender: <xms:EVA6X6fKJQdrShWUiTHkNh62xHWqjJoui6AWZ4_722Kolq_d3Usn3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EVA6X0NvE-tNVe1V58fDlTPrGvVyHmPL543x5uS8kLSbNeKyYmhObg>
    <xmx:EVA6X7jpYDCaYHocDphi-ENFJBIlbsz7buBazO_K7o_wq6Q1F1K3wg>
    <xmx:EVA6X38_wvUZrKvDsQyirQ-2V6MmjXCDa9hUMMyAnARuWZjtJDdU2A>
    <xmx:EVA6X05DMPStkvK5WKepzfO79C4daZRud_7fQnu-14B7p5n1FIBEsg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5081B3280060;
        Mon, 17 Aug 2020 05:38:25 -0400 (EDT)
Date:   Mon, 17 Aug 2020 11:37:42 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200817093742.GA2344083@kroah.com>
References: <20200814.183607.739398019556222061.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814.183607.739398019556222061.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 14, 2020 at 06:36:07PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.7
> and v5.8 -stable, respectively.

All now queued up, thanks!

greg k-h
