Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449B24A6B8E
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 06:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiBBFpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 00:45:50 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53279 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231137AbiBBFpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 00:45:50 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A13F5C018C;
        Wed,  2 Feb 2022 00:37:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 02 Feb 2022 00:37:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=YBRLObE7oipno8N9HWdhc5q6vesbsr/OWaH1CA
        K/aQk=; b=kYgirHHwKXkRaJd44UTsTqARSODCa8xP8kayvLKbKkXuh70HSlZOhH
        0QzZkvc52VKCBZeH2VyNAa1IBpygH70XbBRKkeg+4GWSz0o/gpRU/34vUPZ48x56
        glG64uXfFdoyAUICldbLXd2xkCWv6cANWTiO1mkhiQFEoNNkoZmXpHlbAScxq8bN
        h+LqL5cOHDB25WalPkKUpuUHh2rutp7sijFgz8pX2xC4HORcLU0wVxOPtHbqeXTZ
        7cdaP929qodETW/qy5ytlZgeC7NSIuhfTw/4fkPHs84vk15GDdKw6HBY96eZBJBE
        sShqmqIj+vVLYKnSRGTjCuhGNosQQMJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YBRLObE7oipno8N9H
        Wdhc5q6vesbsr/OWaH1CAK/aQk=; b=IQPSlmwfP1gxWY8xeEZDy6XcnT19SU4qr
        ODJhL2mRy7b8/CjxhN5+/oJLEwyoKm18ej7vJ8doYXhLesynP2ctdrazdLZ+C85l
        Da3+go/4+J7CtxysB0X5jaZ6QpJPdgKXJjikLvG3dgQYnN56kptu4ncIGiPyM55c
        lVUrtepd9X2zEp+t+tk84pczsdZDlwUVX7ae7xPenHWfhFLzkAxMfo+FSAqDkaJx
        MhoS5yoU5ztIQSG7BecYWfoOziqH+YCbvCwbfbBhjxSysiGiDjd94xho/gOpvoZk
        ghVeYOYEw7MXqRqegduacVwdJvPflkvOinB0GzsBYtzYVenlGDX/A==
X-ME-Sender: <xms:qBj6YZCRoxqoZ_CTNbZi0-BIH0KdZYkeMRTbCmE7CtfUs55lLgJBQA>
    <xme:qBj6YXh2IqW4n4NX8kQCBP8_MIfrRFYbaHEF5ShRIJjwGfdR2YZKNEr6ZKr1t4p97
    zUGYGq4l2JHFg>
X-ME-Received: <xmr:qBj6YUmZHIQg4d477IRP2VXDo2EuH5ecj7AVgsu5LXfy_2SECYxvhVTFp356EXZ0aGnGVjbuqBAOQH-sIgAuZgeaw7waH5z9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgeeggdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:qBj6YTxGFNQP2N21oRUoK87AttmPf2SJGAdl44gaC3wF9rV2Pl2vPw>
    <xmx:qBj6YeSTT4e4H54KKsXjn29GmOvotPwe0vHBIfbGEA2VWWTiIvtakA>
    <xmx:qBj6YWZs16oSiWy_Y-oLI_clQuXYr4HmYPV8WDlTIqSuyq8-zgr0sQ>
    <xmx:qBj6YdF6WKtCA_HKbthmQE3_y2y2KLNzGN_agNrRs22k3WQNvnjYKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Feb 2022 00:37:43 -0500 (EST)
Date:   Wed, 2 Feb 2022 06:37:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     mptcp@lists.linux.dev, pabeni@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH mptcp-stable] mptcp: fix msk traversal in
 mptcp_nl_cmd_set_flags()
Message-ID: <YfoYo7wQGVpkM464@kroah.com>
References: <20220202004032.208848-1-mathew.j.martineau@linux.intel.com>
 <366acfc7-cab7-8f9a-e1cc-3d7f57fecbf8@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <366acfc7-cab7-8f9a-e1cc-3d7f57fecbf8@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 05:09:36PM -0800, Mat Martineau wrote:
> On Tue, 1 Feb 2022, Mat Martineau wrote:
> 
> > commit 8e9eacad7ec7a9cbf262649ebf1fa6e6f6cc7d82 upstream.
> > 
> > The upstream commit had to handle a lookup_by_id variable that is only
> > present in 5.17. This version of the patch removes that variable, so the
> > __lookup_addr() function only handles the lookup as it is implemented in
> > 5.15 and 5.16. It also removes one 'const' keyword to prevent a warning
> > due to differing const-ness in the 5.17 version of addresses_equal().
> > 
> > The MPTCP endpoint list is under RCU protection, guarded by the
> > pernet spinlock. mptcp_nl_cmd_set_flags() traverses the list
> > without acquiring the spin-lock nor under the RCU critical section.
> > 
> > This change addresses the issue performing the lookup and the endpoint
> > update under the pernet spinlock.
> > 
> > Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
> > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > ---
> > 
> > Paolo, can I add an ack or signoff tag from you?
> > 
> > The upstream commit (8e9eacad7ec7) was queued for the 5.16 and 5.15
> > stable trees, which brought along a few extra patches that didn't belong
> > in stable. I asked Greg to drop those patches from his queue, and this
> > particular commit required manual changes as described above (related to
> > the lookup_by_id variable that's new in 5.16).
> > 
> > This patch will not apply to the export branch. I confirmed that it
> > applies, builds, and runs on both the 5.16.5 and 5.15.19 branches. Self
> > tests succeed too.
> > 
> > When I send to the stable list, I'll also include these tags:
> > Cc: <stable@vger.kernel.org> # 5.15.x
> > Cc: <stable@vger.kernel.org> # 5.16.x
> 
> So... this wasn't supposed to go to stable@vger.kernel.org yet. git
> send-email picked up the cc lines that I had moved out of the commit
> message. Sorry about that.

There's nothing wrong with us seeing it as kernel development should be
done in public :)

thanks,

greg k-h
