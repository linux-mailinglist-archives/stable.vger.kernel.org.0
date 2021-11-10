Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1592844BE97
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 11:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhKJKba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 05:31:30 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39313 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229831AbhKJKba (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 05:31:30 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 500A5580970;
        Wed, 10 Nov 2021 05:28:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 10 Nov 2021 05:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=RjXB1Z85PlXf53Ln6BgXRbUxPKk
        x8/JNbrw4pi4atds=; b=bB8PU7WRov9+CfrAurLHmcbMo1JXLXiarjdpCpLM5Kh
        PbP9vNO47e5spjj9EwNki8Px1RYo5FwIZS0ByPR25NCiqGis7LOydharvzoR+8GA
        pCf3PkV0V9w3PPgO6AGjE4cOi85y4OlektegmHqnWh1te2HyxINAQtTvC4PqnnyC
        Ja7oyp6nW6fijG186l84JY89Hr6px4GF6wb5Vrl3N8UqOZT+zen9yDL1jKAkNcLF
        bs+zfche4iIf1v60mxdygIr6fYkYMyhxK9WiNVanDIPussXzRR6CYZABwNHy9eHH
        av+s+NuQxNNSSaJ/QXKbZAq7s7CJ6Kxdj1CnH08ebbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RjXB1Z
        85PlXf53Ln6BgXRbUxPKkx8/JNbrw4pi4atds=; b=g5q7zqs1PYp33WEWLcghR2
        G/y2CpFXqf+IiTUlgr/B+PtIAL1RiMdpVNKmFu2AkTIkA+kISRa6DcjR2R+4zEmW
        fhUYIfu9L1hu5C87aAuZ4ndFIC1WBsSKnKjnM3TXPNMjIMVzLx2WP8w6lXZ+gmaO
        80kxRzVRRPWyr9cdp1icaEd7z52MqCth5GdcHYi7Y4ts/dwoAYARechwWM6VO8x3
        Nce/g3a/rnQVjLfrDf9S5LFbiIurqKpKKQXBH4/NNDgv+lITIab1m/JjcOo/c9m7
        Kt1+TgLAjdEH9rahiTOeLb+6Lf4mJu24C+qL+NMrqkWvJkRbkB4uRFfjopMvNagg
        ==
X-ME-Sender: <xms:1p6LYRI8SnEAZ2JKlrgjFJGumA2MQDzTdLwjO6lIoK_sdLR-lEEmPQ>
    <xme:1p6LYdLbITNflHeMeOLyfMGV5aUrmHu2kT87PopX1_EBoEH75NJ_NNQj5yVWP8w7L
    caokqoKmm7K9Q>
X-ME-Received: <xmr:1p6LYZuc4elX0z4ks6NL8sTebR_D1qQpsJqYjAeGzqxcpImm4T80CyjGBsWaNk9XFGIfmk5I3_xjNGBHXOnVhcUXf-0oaU47>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudejgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1p6LYSZcilUuC8ymF6Sm7kc3ZZV1PKVMP76HRkhAzMv85fkBVWAy5A>
    <xmx:1p6LYYYk_903uvP7KjnneWQ-hMzDjqAMWO_1cZNqMUbSjJWJ6bLGMw>
    <xmx:1p6LYWCN4SDLVpTRt3miOk_71iRnPEllSO9Z9NDzhZRLY7Peo4hDbA>
    <xmx:1p6LYUSp1n3i3Lj8OY3FC5Rx27Z0Fetaf8BR9S15jHJOXfjMVqL9WA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 10 Nov 2021 05:28:37 -0500 (EST)
Date:   Wed, 10 Nov 2021 11:28:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andreas Kemnade <andreas@kemnade.info>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Johan Hovold <johan@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.9 1/2] net: hso: register netdev later to avoid a race
 condition
Message-ID: <YYue00HWr1hW/8cE@kroah.com>
References: <20211109093959.173885-1-lee.jones@linaro.org>
 <YYuCE9EoMu+4zsiF@kroah.com>
 <YYuXq3wOdmWc+8lo@google.com>
 <YYuYyROE7FKrQgIF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYuYyROE7FKrQgIF@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 10:02:49AM +0000, Lee Jones wrote:
> On Wed, 10 Nov 2021, Lee Jones wrote:
> 
> > On Wed, 10 Nov 2021, Greg KH wrote:
> > 
> > > On Tue, Nov 09, 2021 at 09:39:58AM +0000, Lee Jones wrote:
> > > > From: Andreas Kemnade <andreas@kemnade.info>
> > > > 
> > > > [ Upstream commit 4c761daf8bb9a2cbda9facf53ea85d9061f4281e ]
> > > 
> > > You already sent this for inclusion:
> > > 	https://lore.kernel.org/r/YYU1KqvnZLyPbFcb@google.com
> > > 
> > > Why send it again?
> > 
> > The real question is; why didn't I sent patch 2 at the same time!
> 
> Also, why didn't it go away when I rebased prior to sending this?

Because it is still in the queue and has not been in a released 4.4.y or
4.9.y kernel yet.

thanks,

greg k-h
