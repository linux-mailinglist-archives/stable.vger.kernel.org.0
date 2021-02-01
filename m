Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF2A30A677
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 12:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhBAL0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 06:26:55 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:46399 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233113AbhBAL0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 06:26:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 360898F2;
        Mon,  1 Feb 2021 06:25:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 06:25:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=D7YANPid7JYJQwwJc85UTRBBU4t
        OCZsuAHPdarcBbY8=; b=HSVMNg9m+JmrrzXWmB5nODLfRiYH8lWoC88Q3RJqs1u
        K7kOBLagg0giIqOh/u20IofOp7LhcgBOT1dr6YNC/jrLK2HLxuyT1EXRj9Q0Ykn3
        pEUW2lNplwE7zkCinRRj/REOfYAiBILo2l8KkAp8TkfKR+QnrLiV23lbsQtmRRBC
        8ja+ND2/laTPJYrXq1zwLrW4dlf63yaDu2TaZ8/vbu1FRtYqnpKwqAsmDvXb33NJ
        XdjpqFPpzqt90hku3dITvAKK2fadC0iL/ldt35IEFmvJg8JxywYAoMHAwpsmdjvT
        Idmu7OJdT9cgSHRiKALo3gJMFNnX/XBkn7AywUd5nAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=D7YANP
        id7JYJQwwJc85UTRBBU4tOCZsuAHPdarcBbY8=; b=Rka0CXOsW7YeXcmeDk+ffw
        bM4iSorawwJ3vgCcjiKBhkrPhavtp0QdXKfxttIdM1Sg/H4tGk7aKLhOHO3r2L9P
        rfwY7zoljvw6KLUiAi+bV2RG/UnNzdPfnabneOfgnZSCMfjtb9F0pnStl8/8W8hs
        7C4v9Cz+s+MT7adGhK3pRPQdadu456kJlBdmhBu1GJeUOBvMoS3gXp50uyyLOyj3
        rsq5QTaBaN+ziJE/V9YiMoFLpnC/SriLA6f0Z36/MIU1h2u2A/hcKi9cBID/BFT+
        36foLzDlEoMK6HXE431fZ5SZPw9M9JFJOuFUkcLxA70Zag4XtwNOF5s9coJJMsXQ
        ==
X-ME-Sender: <xms:POUXYG0rSIxLGcmGyflC17cQTGpCT8iXjLnrXGStuu_TvnJubR_B3Q>
    <xme:POUXYJGHMGgwCooLaAWZ3CoWOHsOjfX2qH-c_NI1ih0HGgir3YhMc_IEwJMxidV4v
    yYSLAU54n3ohw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepuddtiedvje
    egudffgfdvhfdtjeeugffhhedvjeehgffgleduuefgfeekgedvlefhnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:POUXYO5WgqXiB-cS7JcJiqMA69qdzBskERFXzUbxYQ-6gvBahk_PzA>
    <xmx:POUXYH1D5F4yqIJy4c1-jhE6PzmlilMIaPcmTtYAbAy37P1aS4CWGw>
    <xmx:POUXYJHOUlUSpSLMddvUuxHtyy8YvTjy5gQmzSm77L-Nd_0Z4ncX6Q>
    <xmx:POUXYIy7LakZxeMuVxeAPqUlkGFJ0SviYgvyESn7w8o5R5MIqgR0SA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52BF3240065;
        Mon,  1 Feb 2021 06:25:48 -0500 (EST)
Date:   Mon, 1 Feb 2021 12:25:46 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/12] Futex back-port from v4.14
Message-ID: <YBflOrmhgIHFZaDk@kroah.com>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 10:01:31AM +0000, Lee Jones wrote:
> Ref: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/pending/futex_issues.txt
> 
> This set required 1 additional patch from v4.14 to avoid build errors.

Thanks for this, now queued up!

greg k-h
