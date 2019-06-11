Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DC23D6B8
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 21:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391522AbfFKTWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 15:22:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58629 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390837AbfFKTWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 15:22:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F14B921C57;
        Tue, 11 Jun 2019 15:22:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 11 Jun 2019 15:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=G921r/hQO3KTqID5UZ2qKBAZJU1
        UoAt83WxRTxqVPOY=; b=ppKJV5Wk/H2jWhc0VqosgoBRgqQUlHnFD9RWvt7zYFo
        5XLxV7dg7m1yzC2kHBdHOxUdxIZ0fu3cVwml6DLuP9iRoPDLI5INslfuQLLP8IYf
        jNFfjgmpzllNQLH2qcpDy3a7pIBdDpYOHlyq42tab/81tdTqhYM5XIuGdx08FHte
        Qchr7edY9++QYAncy3/o3eqqHy+gqy4s1O0EG5a2PqWDuP913lRnE5NBb+o6yYn6
        lzxg7b8+TUavybmUhDPKf+lC2rkjvYRmrVcO5HcjJJ1NOZTgU0azQJh1HIY83DRA
        00EIemmXq9UePBqu/ykjO6AltA0bVQhe1ySR3BiomEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=G921r/
        hQO3KTqID5UZ2qKBAZJU1UoAt83WxRTxqVPOY=; b=crrC+Pa73P/LR77UoxpMDF
        izuIkyvOfWNDFNQzayWQHyJ+QSn4lSpfI7nf9zMBms9CzW1TNnbZWMEhS9BidTlx
        W2qmWJUyvwX1TfWMP3cJTSkvNmG9fskzMcoDJ+LNNzdLMXczzOzg/RQN82y0effl
        e1LrgVjLXfFpPaFMR7t3aueLJsKB1+bYRNx9llX3NUg9Whgz7Qfr62AIHhGvj710
        M0p01WTQlkmSJhiTZAqP4b2qUfFZ4bQdXV/FLVBxwPFkFej+ham2PGJhIEfC7CY0
        y5wCJcew6UvaJf1+PUULlHJhIp5LF2vxi+ARiBG3lqM7GQwBGVFLE9bbacMkwkig
        ==
X-ME-Sender: <xms:i___XGFjX4sPGonBtGY_5txs1DsA9GNMcRksAOYgYL8C8FEE0_gzOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:i___XKaBl82rIuyhjreyStkyBgK-eufgLRiusGepQNdfJrEiO-9mGw>
    <xmx:i___XON7IRTBerdKEDA4gms0WV1_c-jTIPtXOIH6UKZG64-WTkXERA>
    <xmx:i___XDjyG13QyKwtrxdYqdn-o0IazVYSOnPFr1P_dRUp3_WHQdQJxw>
    <xmx:i___XP92cwUyp0hNZusMOe6PpXj_SCrhe8W1ki_0edwrisIdnMN3vA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19F7480062;
        Tue, 11 Jun 2019 15:22:50 -0400 (EDT)
Date:   Tue, 11 Jun 2019 21:22:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Jason Gerecke <killertofu@gmail.com>
Cc:     "# v3.17+" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Subject: Re: [PATCH 2/2] HID: wacom: Don't report anything prior to the tool
 entering range
Message-ID: <20190611192248.GB19775@kroah.com>
References: <CANRwn3Ru+7FGtsY=GaDa7pAJkuagdb6nFtvrFq1qhTWJR0rF9A@mail.gmail.com>
 <20190426163531.9782-1-jason.gerecke@wacom.com>
 <CANRwn3RBK41mRJKUPDDptoq_So6_7UxR0toaauZvjT5U=OaHWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRwn3RBK41mRJKUPDDptoq_So6_7UxR0toaauZvjT5U=OaHWw@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 12:02:47PM -0700, Jason Gerecke wrote:
> I haven't been keeping a close eye on this and just noticed that this
> patch set doesn't seem to have been merged into stable. There's also a
> second patch series (beginning with "[PATCH 1/3] HID: wacom: Send
> BTN_TOUCH in response to INTUOSP2_BT eraser contact") that hasn't seen
> any stable activity either.
> 
> Any idea what's up?

I don't see these in my queue at all.

What is the git commit id of these patches in Linus's tree?

thanks,

greg k-h
