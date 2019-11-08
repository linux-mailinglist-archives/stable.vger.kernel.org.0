Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E92A9F4CC8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfKHNLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:11:08 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43235 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726879AbfKHNLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 08:11:08 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7A99622050;
        Fri,  8 Nov 2019 08:11:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 08 Nov 2019 08:11:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=gTeAWroFHiqoh9++dG7qIFwWNiL
        SKEWrzTLipsjE0GY=; b=UojkhTrpk31m8ZOc+krPItwhotHAzoQxwv6B+fuxvBY
        uO6Ad+z2lo/69+sjlbY8Z7YYraMbaKCy9tRHIeMlGZhQUXX/TBvFv6vmDghRC76f
        YVpRrjbr6MVB/EhJr+PJ/j0SS+GiNgS2PRPECkXMMXVmHTXHFMmTr0kdS7PJlwtE
        xKTYB5jrjl4sepK5tTkAJHbS2A5ukS3eXVFUgaHWSYdI3/fsjs4AoRhwyD8RVXTW
        SEr6rRRreHT+YN8K0USTvhJYIdEAn/5gGnABmATkNWjVxyrQ8hK7zqoBn3F249qN
        9G0w6ARyw17qke7Jmlgrc4oR2n15Vzj6YDI30NbndHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gTeAWr
        oFHiqoh9++dG7qIFwWNiLSKEWrzTLipsjE0GY=; b=ynwvyAFRgmNfblH4ciRkSV
        hoqBPZwJCaMsuNFOLnxOwAaBBsAU8aUe5i+VqodpymejjcFUGL+QsjsfsFcAiO1T
        FqHknzxhpApZct93gfPjnuKoWZOoO4JlSV/24bOAqa0gLH3zMR5rTsK+LXSWUdSE
        aSfvFS6gqArG7dBfrSJoHEc7lepjJdINYXkeJMJtmkKR9RumuiR5ZIL8PDOj93RU
        J29UUtAv+xLwEB6Io2jCWCv8tQ1HQ9TKlSTzVzJM5uzzeUtovw8QrjD29C+6xaYz
        MmIUF0XS4WOuCT0vX+zpk+IhuWGnuc8YUVpp2Shb7SxP0vhQXZC6qWgGq0Y6ijOQ
        ==
X-ME-Sender: <xms:a2nFXYSSiMJ7LQue39tT7Om5Sf4BYkTbr-JSX5iblSkFbZOQd8V2Ug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvuddggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:a2nFXeNUPFoFv2aCoJFOdATGy6i-BdjJ3E-n6ZlkeP8pzLl57Vz24g>
    <xmx:a2nFXWSGJZ_L5SqaerLri2UYhee3DRA0SCsNQ9k8ajj5zoJk7hz66A>
    <xmx:a2nFXcjfXXwCNDbJ-jRwDYp9Ab9Iq1SzHs7C9Ki5XBDpaazvJEHIMg>
    <xmx:a2nFXYlqhQ5YTRGNek4gUGwZOnFGajjaA_m9YPi7dCA_9Ya4Z5oX7A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8A403060062;
        Fri,  8 Nov 2019 08:11:06 -0500 (EST)
Date:   Fri, 8 Nov 2019 14:11:05 +0100
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     stable@vger.kernel.org, linus.walleij@linaro.org,
        rmk+kernel@armlinux.org.uk, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH for-stable-4.4 08/50] arm/arm64: KVM: Advertise SMCCC v1.1
Message-ID: <20191108131105.GA759061@kroah.com>
References: <20191108123554.29004-1-ardb@kernel.org>
 <20191108123554.29004-9-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108123554.29004-9-ardb@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 01:35:12PM +0100, Ard Biesheuvel wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> From: Marc Zyngier <marc.zyngier@arm.com>

Lots of Mar[c/k]'s :)

I'll fix this up...

