Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0E231070F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 09:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbhBEIvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 03:51:48 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:52763 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229766AbhBEIvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 03:51:47 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 74DFCB58;
        Fri,  5 Feb 2021 03:50:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 05 Feb 2021 03:50:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=W/Vo1QrH0NOEn7Es9MrjH1J2PeB
        UEVvXZoG3d+Hvw4w=; b=muoeQQYwSisIE368DriKnzxIdgjxY/aY+Ka3UloCMYs
        tGltfAeAgIFs0WMYjyxfry4AZszqit71sWphZoBbfPIHmB3H+p9Tx148ixdttYvs
        FYF7dMTI534/0Js3PUktZNFjggofS222jXz2RHcU9IQsFJ//FoAJW7Z8JzdjXTcL
        Us6DjZWiNV+bi/qFmGblIKYxDiCz3qbbI3N+EdCx3Rsu7f2cfYMuEQszR7oxw3dq
        UHhLWrMJiOCKJkNihZ5DSoq3+vgjAZcdQAQ0ginrxNFKbBm7jRXAfR9EU6gESyGd
        k3noqOjiyLYjXsjDqgYwa2gc/V3isWIUJPkJWIH6skg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=W/Vo1Q
        rH0NOEn7Es9MrjH1J2PeBUEVvXZoG3d+Hvw4w=; b=HClqd9HAETuZTi2d57gZ4x
        HpfpUxtsxqlCNWkdpo5kivTwh+qVXKItfT7ceWSbErAG9IEeHxWK2fV3I8uhArqx
        y6yOTtS6bK7WwT9G0PSv4SG+z9Vwaus2U0RM1VdfZaTwYYVsodPcbuXSwtD4WTku
        zEFGbUXMzkk0qGh8MkEP5Sx/bJxRPwicNAxpxwVREmlJWgMxM6HnwQtxCE2ddoRn
        iGW2ow28eiWokh9LezVQolFKINe/h/m4Zddecmz9QbSRqSAJHe2zfrrmgeiEpGQc
        NOQifwC6g0YM+doLjMsZw1gWZf2sY/glz9shsBF3APnQiojRzLgkeCODP0fB7Eig
        ==
X-ME-Sender: <xms:3QYdYFXIuPQ8_FWcUrieNKipyi1DVpotm2ioySDqaZk3grb9voq2Sg>
    <xme:3QYdYFnG--IhDuFYxgPDWSIre9WkMBFt3vMzUYaVzm1439J4Aoclm__I7melWEG_X
    uV8IqOpuVy9bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeehgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3QYdYBbC09hTkxEx5CNz61Oj-2ntDaph5SKjF9crm9at3NgaGw3BLg>
    <xmx:3QYdYIXTtNdPz9cXU9f5yWWH58nopI_sahFSWVkypV4EGYxCF0YrqA>
    <xmx:3QYdYPlR596ESG9XqN9OvIyLcCWuH6OA1FweiP3iNT83ENTiMNkywA>
    <xmx:3gYdYOvLUljVu3YbQQ5cBKdVWphc2kzSBTQ4qC4yYSdWrg-qz4xLwA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 58DE924005D;
        Fri,  5 Feb 2021 03:50:37 -0500 (EST)
Date:   Fri, 5 Feb 2021 09:50:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     stable@vger.kernel.org, Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 4.19] sysctl: handle overflow in proc_get_long
Message-ID: <YB0G2sFKyX0Nr6Xu@kroah.com>
References: <e63d4566-3100-5659-0cb6-53f799abf963@jv-coder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e63d4566-3100-5659-0cb6-53f799abf963@jv-coder.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 09:20:02AM +0100, Joerg Vehlow wrote:
> Hi,
> 
> this upstream patch 7f2923c4f73f21cfd714d12a2d48de8c21f11cfe, should also be
> applied to 4.19.
> The other patch of this series (sysctl: handle overflow for file-max) was
> already applied.
> 
> This was found by ltp test (sysctl02).

Now queued up, thanks.

greg k-h
