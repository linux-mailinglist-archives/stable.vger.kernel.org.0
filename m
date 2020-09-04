Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C09B25D464
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 11:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgIDJON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 05:14:13 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55333 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726575AbgIDJOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 05:14:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id DEB085C01A3;
        Fri,  4 Sep 2020 05:14:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Sep 2020 05:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=gbXn9TwNivjaaiRRU0Xa8QBdwMI
        pluysQHYCCRKxVoc=; b=HNZZA/UPSZLvanX7BAeA0oq3PMB/W/1KUURzZRSBh8P
        AuonLAXcbUkb4zs7VYSsC6KCfcdAFBMU1awsE74M+/ELGa52hlgq/4nNBKBm5gsM
        bFb80acEsTqZ06uVAPRgjKF8x8zrdVprS86xISUcp0PZAURaolHAplYwMvAgcUUI
        VdCGJFaj4taB1uKEXxuz0s7Et40jDJmbs+H7cMNSBzmrycPcQrnUII9up32tktYz
        z8sHx8uw3SYbcf0ADKkjEn5V+R2BvvvagSPnYV4jY3xlRKbcIBnidI2m8tAbfx9M
        NJRJxcbI2UjGg35586DJt2e+DRngqwtmrT6MuWQV6dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gbXn9T
        wNivjaaiRRU0Xa8QBdwMIpluysQHYCCRKxVoc=; b=fbrwsJbpRhZkFtVJvg5GYc
        CsMY6IMyUSoJSrhhQ3/Bmo4U/mWmcAG/ZT+p7lwH2Ymm5HiXXX4XEVVDGqpzIiFO
        VWghddEEKvDriOYDPbp4ho0mU4qyvWWWn3iJL1TH8F8egcFgn5t5niGZK+GNhWIm
        taxcZvhrdufOQH9WDm3FQGJWDogmyhTvEp8rqJb+3gfI5xFp5PCbwkmAWdshMTeW
        c0yMaWgXeqmqNZbYrD6XSPH+GLMjLbppF6hJl5hCZSRccxMnF1BhYPmv+dtU7tOY
        MWtMAwjT1WVWbzzD2oBKNEAT1OCFrBSXudxnZ3WzutdpnQrFdKLBwmeteP28SEqg
        ==
X-ME-Sender: <xms:YQVSX-Jzm98-ZP1xrN7xZyxNcRneOQpwtaRqqo0rTWrlyZkGb_ZFmw>
    <xme:YQVSX2J_m_eTmP8dHhd_aprMTxUSW0-WFSD43-i63tZtMzgbGdO3xTZvmhJvruiXl
    _a5KV0dSo-adQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegfedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:YQVSX-ugX4OLOCueCGKGHTntghgBUa8jWzhVZHOSyg6Byqoir9do4A>
    <xmx:YQVSXzYS0kGMOZ1V3EzpOuiL0xXgxSbgINjwdtoXQFh63_o6I9mWjA>
    <xmx:YQVSX1YJ2pyEWQFVUmwABjhpOmHb3s2vrBSuHOzlcXz-84cMB1Xzlg>
    <xmx:YQVSX318Fzakr_SCjoJ_feRHvpTlmwByVahiGnTbnF5ydgvgK3q5mw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8261F3060057;
        Fri,  4 Sep 2020 05:14:09 -0400 (EDT)
Date:   Fri, 4 Sep 2020 11:14:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Walter Lozano <walter.lozano@collabora.com>
Cc:     stable@vger.kernel.org
Subject: Re: Stable inclusion request 5.4: GPU hangs fixes for etnaviv
Message-ID: <20200904091431.GB2536101@kroah.com>
References: <232e3634-f82a-4db3-3427-701240b77ecf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <232e3634-f82a-4db3-3427-701240b77ecf@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 12:43:45PM -0300, Walter Lozano wrote:
> Could you please cherry-pick these ones to Linux 5.4
> 
> Commit: f232d9ec029ce3e2543b05213e2979e01e503408
> Author: Lucas Stach <l.stach@xxxxxxxxxxxxxxxxx>
> Date: Wed, 26 Feb 2020 16:27:08 +0100
> 
> Commit: d7c5782acd354bdb5ed0fa10e1e397eaed558390
> Author: Andrey Grodzovsky <andrey.grodzovsky@xxxxxxxxxxxxxxxxx>
> Date: Tue, 29 Oct 2019 11:03:05 -0400
> 
> These patches fixes GPU hangs using etnaviv driver.

Now queued up, thanks.

greg k-h
