Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5421E9F133
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 19:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfH0RHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 13:07:32 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43273 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726871AbfH0RHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 13:07:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 63F1B222BD;
        Tue, 27 Aug 2019 13:07:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 27 Aug 2019 13:07:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Drzh9eg/hJkeHrETUUwKv66zDAo
        lB8IiR18+xL3GcC0=; b=EgSswFOO8krvevILHf9zhhLO1duMXABul8XecZhVGQd
        q8mWzRPXzFyN5ywfCwJy3POh3T75Pf/WHhb/EQerlSVDd0pgn6lzCmGnkeueqDAI
        lzUmagI9zU/78yhgBd91Vw19HdLhCVnVtvjbqHwQG5ypkOmbDrNTCmhfq4MRC+63
        6TMVy/qyR1qp7g5hrwvqLaON/V2ppfq2TuTHk+RT+MygET7LPY+Vk+uWaFxawE6Q
        2IKFZkHJCnlz064ejGCbWfakFNYzJ/xtTmbi5cUkDmUFmnS99g9muIwA5A9rBbrB
        tf7N17RIBprqeilhCNuOEoTL2ILnxVyrCis2e36fq7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Drzh9e
        g/hJkeHrETUUwKv66zDAolB8IiR18+xL3GcC0=; b=Hr88HRljO8/sZ9sBm6F0Gi
        pJ1TJLapyilf55VXMQ9nSTU2gyqI27R2XO+AGTztDI40v8+zolezJDIUjH8/DXq9
        IyuzVRMLKQGNEiFg+OM3xqB0pP/wKS3LNBNd91o6wTZC62D4bGnTT+5psfrzeZbk
        2UJbgtjA5RALdBj/3DPnzR6XxbwxsP2c2/UgJ7fX4EBRalAcQY/k5B4VJyfLKN4Q
        yGzPNFSC//H00zvX/qbh7s2qBWSIj/6yyQEKx6c6G+groQaedQk4VWxm06q36gv6
        rfwxEzGXG6PrWyIxHhlAYQsP0DsYO3LE6tfbq6hB0UT7lfiPjp8aBqEPe6zSpAiQ
        ==
X-ME-Sender: <xms:U2NlXWwkry91GVdtFquqnEBnd3UJm7Eb3cuRAoF2FwH12NTV4JqJNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehkedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehsphhinhhitg
    hsrdhnvghtnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:U2NlXe1wp1tVzCuEwuZ4us_w9dGE-KNitz1Z6zqzuM9QEYWnBGdrXw>
    <xmx:U2NlXcw74olYgvfVPmVdAprqkois3osglLQOJZ8PnUGXeBN5OqJA1A>
    <xmx:U2NlXTW_kS9XPs0yWJac2k1a38PTIEoa-9dlxHPhQLIqXdL0ahF4iw>
    <xmx:U2NlXccF-x8zwuAy8tQWqY_wFWt1hw1VqWsIS4hliMl2g4EI5JmBpg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B83A880068;
        Tue, 27 Aug 2019 13:07:30 -0400 (EDT)
Date:   Tue, 27 Aug 2019 19:07:29 +0200
From:   Greg KH <greg@kroah.com>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH net] ipv6: Default fib6_type to RTN_UNICAST when not set
Message-ID: <20190827170729.GD21369@kroah.com>
References: <8dad6e3cf2e6cb0086b0a6f75ccdb44822a15001.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dad6e3cf2e6cb0086b0a6f75ccdb44822a15001.camel@infinera.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 08:33:28AM +0000, Joakim Tjernlund wrote:
> I don't see the above patch in stable yet, is it still queued?
> https://www.spinics.net/lists/netdev/msg579581.html

Ask the network developers :)
