Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2401FEC83
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 09:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgFRHdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 03:33:10 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60379 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgFRHdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 03:33:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 0C60B338;
        Thu, 18 Jun 2020 03:33:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 03:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=CozroQXucMG4cXeo326LXlzLyNO
        Ejg03PrxY2YrqNX4=; b=PZZJD4Q2uKR610eHUzqzptvDl9omYH1JNUKRxxzJsiV
        XWGxvM/7vs78ep/ZmdLSBa+K1Y+XVhbNZpG6Rz7d5SUhsAWtcQ6fsUzp9oCQ0JTA
        uP9ZkjWthrUyedTMg1zg3Pm4LnVu7X6ahFda6C1EHRb7fZ4xEb9tQihEqMWXsNZs
        biF5zy/tJDkRFHla0NnXdmOrVyDOrsICABxcY8I1JK1rm2s1rkcOHAxU6Weqj36Y
        EISGKx11acVUkuKhgZ48dT+73angC1bQoaovlhGMNavIisUisnmghDZf4QXuAySk
        5cktp0t8gzO63K2hZaxS5Jfy0GoRPeg0YQur8UiOwpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CozroQ
        XucMG4cXeo326LXlzLyNOEjg03PrxY2YrqNX4=; b=vbas+K1qMNXFNUAyV0DmvC
        yypF2a7O44C1+xO/8I1blSDIZEinlrLpIV36itjezxpqoqw+hCDUZgxo0OSXogGw
        HoGlq3k510qo7HpLDMZJEc2KtI+qRG7OKFY2hxhakoiFwuHD99QesEcmnP1RZ1HS
        4Z2US/njyy4M8KwFFl168bPlE6YkaKnkO2OYS2pvKXJ5qa3SbluzsP8gUlw6ivS6
        mxKHmzfIYV2jUXRA4TG8wiahowGwTu8XQSyeNe/YK6yf41sCXehZ2s2CoEH3D6yW
        X78LbqBfhgmenmyzsJYZ5hkK0kma8Re2sXJgggtJe9lRLXi313qoxEwCC1SkIYZg
        ==
X-ME-Sender: <xms:shjrXhsANp8I-Bbol4yhFwV6Cn-LywTFFsmjQe9oJn9PxtWbb5s_QQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejfedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepfeeuje
    eltdehkeeuveehheduleegleekteeigfffleelgfeftdeihfetjeefudetnecuffhomhgr
    ihhnpeifihhkihhpvgguihgrrdhorhhgpdgurghrihhnghhfihhrvggsrghllhdrnhgvth
    enucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:shjrXqdp8Bg7IHhpAmeWMqBH8x3ZijOnOu1PU7tCuJ3QF-rsIy3WUQ>
    <xmx:shjrXkxenczwuJNWVQMOyfgCwwklzdr_qXcE7ldJenfxTl8w4wmUnQ>
    <xmx:shjrXoParJwuKn_7pYkiUdXd8na2tqdVQghgRT8ZrDk3l23ksijo5w>
    <xmx:shjrXuF4IxtcqnNC-ZtI7CCG1Fn9yz9fabnBLi3NviqkAES6H-D-fA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AEDF73280059;
        Thu, 18 Jun 2020 03:33:05 -0400 (EDT)
Date:   Thu, 18 Jun 2020 09:32:58 +0200
From:   Greg KH <greg@kroah.com>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with
 blk_mq_queue_tag_busy_iter
Message-ID: <20200618073258.GA3856402@kroah.com>
References: <20200608093950.86293-1-gprocida@google.com>
 <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
 <CAGvU0H=Gd5CUMMW35wBFV=ZaE4u6aiu3VKPCiJNujGcwOvy3WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGvU0H=Gd5CUMMW35wBFV=ZaE4u6aiu3VKPCiJNujGcwOvy3WA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

:)

On Thu, Jun 18, 2020 at 08:27:55AM +0100, Giuliano Procida wrote:
> Hi Greg.
> 
> Is this patch (and the similar one for 4.9) queued?

f5bbbbe4d635 ("blk-mq: sync the update nr_hw_queues with
blk_mq_queue_tag_busy_iter") is in the following stable releases:
	4.4.224 4.9.219 4.14.176 4.19

Do you not see it there?

Or is there some other upstream commit you are referring to here?

thanks,

greg k-h
