Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7552AB886
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 13:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgKIMpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:45:30 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54785 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbgKIMp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 07:45:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B47825C015A;
        Mon,  9 Nov 2020 07:45:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 07:45:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=h
        kDRo8a5o2hMOvX9+kXkPcGQqyWomQsaKHQOwqRn4S0=; b=4kAISu5b48J8FsoL/
        LwOFK3Xbq4nduqoPPrv47tlgwEnw22gxyynqS8QtnXAEsI8l7PpjNJEX89M2wDI3
        o06kAc0XWvqvaWgVoUQzKBj7BL1yDuBh84spFr8fFvXIQsh2Y+u40uPcVa6Ybqid
        juNjOkF2+OX3P5T8HggijZZrb8mtEs3riRP3lH8NFB5FSBDFO9PIWk6S3ww00ub7
        9GFzxkEthRXaQbDmiw/4NKvEzOYES4qer5I0PxRmSHamD5XTmeaO8GYlNkZZzpua
        2kGFixWUM1wMGTAmzuZ/y2L9KzcVmyYQl2jsb3nbTG94CpJH18uG2wIoG3y55UTy
        JGG6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=hkDRo8a5o2hMOvX9+kXkPcGQqyWomQsaKHQOwqRn4
        S0=; b=f+R/8yDyy1riT43gZ8f44z7i4euL0uuNL/j7QaGpoVFEDvxCFj+2aBo1V
        lmg5Kwtrg/nogKSFtdKBS8kzSjD41PPUe4uhgnM3397MgKSaCHU1+9Dm28Bx7v3d
        yFRb1ryIVoDvouaEW9kNIQ09+cALCKmjxw1fLGFzLepuw4lgcqhp6wJqtyFdf/pc
        x+LgwbP95Cym4zDgATPC6UMlGLUs09uf5RPW7uThjIM5nbKK196KrU8+oi1PCz6w
        l8I3nl7EN6lNe8P0XLjwPrtf+TUUDhVf85vHRxQrav9z98F8ZmNoL5JmXjzv0FtP
        mmlk+mA9RWLZ+o8YWIeQSPGMF6ylg==
X-ME-Sender: <xms:5TmpX1__89qFOpU3ob9R5RCDYwDu_1ubHIHl2y2pnv3RTvmHxERsDQ>
    <xme:5TmpX5sx3YY7-AnqS0I26ZZrTXNWlKsVPZuVSLYDxRTT2Y_YpCdC4OG7NeE5CH2MT
    yVsNq14O53XLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:5TmpXzC5A0NasYegqjwxing0G9xiVXGDUKKo26GKSozWF7Cspafx-A>
    <xmx:5TmpX5dlGn4HgP9_z4jB09Tj5uc7EMYehyFse5_VB2yIY3b7ERBC8w>
    <xmx:5TmpX6Ov-j25yi3l6sPQdUWvDyDe5WHAqckPIC14PM741uJIGUVWOg>
    <xmx:5TmpX9bcfaTw15k0g6SweOGbUbXCBtXUDVADkLWtFEVR3A-gBXu6vw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D602328005E;
        Mon,  9 Nov 2020 07:45:25 -0500 (EST)
Date:   Mon, 9 Nov 2020 13:46:25 +0100
From:   Greg KH <greg@kroah.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: marvell: espressobin: add ethernet alias
Message-ID: <20201109124625.GB1834954@kroah.com>
References: <20201104114813.1199-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104114813.1199-1-pali@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 12:48:13PM +0100, Pali Rohár wrote:
> From: Tomasz Maciej Nowak <tmn505@gmail.com>
> 
> commit 5253cb8c00a6f4356760efb38bca0e0393aa06de upstream.
> 
> The maker of this board and its variants, stores MAC address in U-Boot
> environment. Add alias for bootloader to recognise, to which ethernet
> node inject the factory MAC address.
> 
> Signed-off-by: Tomasz Maciej Nowak <tmn505@gmail.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> [pali: Backported to 4.14]
> Signed-off-by: Pali Rohár <pali@kernel.org>
> 
> ---
> This patch is backport for 4.14 stable release. From original patch were
> removed aliases for uarts as they are not defined in 4.14 kernel version.
> 
> Stable releases 4.19 and 5.4 already contain backport of this patch.

Now queued up, thanks.

greg k-h
