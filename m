Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA6D108EEE
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 14:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbfKYNbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 08:31:42 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43477 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727682AbfKYNbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 08:31:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D22ED2278C;
        Mon, 25 Nov 2019 08:31:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 25 Nov 2019 08:31:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=qKi5FNT3OnBwe/nIrEyGbeeR9p2
        mFGXBjImjMtwWN6A=; b=rzlFTr6uKoqYzGUchlc7iGR+BS8DH6Y+Exrav1uJi4q
        /U3xA8bV06IQB8hoU8/tS3yvnIdvPa8QLY+FHVMn0b2EaK9DYUnJe0vs/vZ/uMzY
        bE3aUHKALzqF1cBtyC/woa7/V5Csc88iQTUdeKD3y1iQZhyZ88RX0jSm1qvTSnwv
        95dr4fb5JZBhQIzgks9Z3VC5nauzfLuN4q+LU/wPKaigCxQYsgajdB76GYS2FZrH
        y5dprn+r3JWWrvSd5qRCzk3KOjUdqBX7dd0xVmhlagacgMlY8bRbWY6LStMjCftB
        rlWxQmZ0Xd10ANTzZCf0BboN8jiFelg6GJf/aHOs2DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qKi5FN
        T3OnBwe/nIrEyGbeeR9p2mFGXBjImjMtwWN6A=; b=VkPMzBqC+FQDm5cjyisixy
        HH6Hh+wqh9OYyOV/di/NWUSdCO7W8qlW0rtYHtyfIsL0yogM9tK5lYyznxejeCMP
        KyYe+cR0w2kyw+Kw8V2hwHgyIMuoft9gm14ehcvZmXTt10fWR6h6EeqBV0uqT7SD
        D/5dtwoo1Hstz2wU7JCsskmTjdiwmwWKdp/glj6SBOZTIESw+6E3C7lon4Ycuct4
        mfJ7kruASvlzHYQoKSsdhPnekDUDu0f8KCjvSPuFjwThzABqGI7pDc9MyQjTZulx
        bPMv59c3iMInioXghwDOTnnOZRRibU6O2TK+cuCeuwk1qkNuzlPTj237gjeLpW2Q
        ==
X-ME-Sender: <xms:vNfbXaY0FxyFW143KmNnEDTc8YIZnHETzx7nYf2M6Vr2Li7wg8U4Mg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeiuddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:vNfbXQ5EDoIrD_nN8n2mrhB1L62ICj5NZXrTaIvmduoNaiZvoc1jlg>
    <xmx:vNfbXbtob2ArnHj8sgFXrqXFpJo0eqB3v-AM7qebc4gxA3m9vZs-0w>
    <xmx:vNfbXa6WrrEcip-QXbZ1x4QfE9qLzQmRxmLxU0gU-_jB-1_mygYx-w>
    <xmx:vNfbXReLS8gELrI52wokXjuVtKr7WxTB0zVIoA_OzbkqeIz5gq8Ehg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D671306005E;
        Mon, 25 Nov 2019 08:31:40 -0500 (EST)
Date:   Mon, 25 Nov 2019 14:31:38 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20191125133138.GA2625950@kroah.com>
References: <20191124.215449.619700122316097004.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191124.215449.619700122316097004.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 24, 2019 at 09:54:49PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and v5.3
> -stable, respectively.

All now queued up, thanks!

greg k-h
