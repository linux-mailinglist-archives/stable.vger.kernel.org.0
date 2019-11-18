Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A41100037
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 09:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfKRIQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 03:16:56 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39059 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726371AbfKRIQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 03:16:55 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id ADD7443A;
        Mon, 18 Nov 2019 03:16:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Nov 2019 03:16:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=+LLLwPZSMhpdl8Q5Vi48h2RtYpA
        oUIfBjK2WLJHQry0=; b=secSb2CKvFV39XDJ0/v/cvXShoDObh2nyTAGpQ9Xtvz
        75EAotGNLOiNmWyTapnnJ8PfixjdBV9BeTyiEveiElk6ndklAIiPEhVNks9XP8OT
        aoUmlfvaq2Zw4HxbILGxK7xdvl1htQ0J9/vaSds9SzZ42QnLQnkCQQl333P+PrCx
        53vmuM4eTAvVzTjBDpYR04ueChrIMCan+tdfZM7pJeboJTDodcndnSxVZEiR+0Au
        nb0QlxPhchtojXms9YnNl7Y4zDaua54r7Uri8zV/Nu8Vllx9ql584VIiPW7N5sug
        wk6wMcSmlrLs4FgNyMf5HSc/ZHd864B2xBOlPM+vv2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+LLLwP
        ZSMhpdl8Q5Vi48h2RtYpAoUIfBjK2WLJHQry0=; b=pGg1bYNUYWtKnSs9neBAom
        gGxBE7XymFyffF1Wx0rqliap5zomDjXgfiNg7/r9TRvsyjR5MfxbGVtcEqq0NjBX
        pcz3VF3r78iQGWJkMGjGWljyJgtJWB53+Zam0J2IXLSn+D/rAVL+1frQ6Mt6/KAV
        2mJ0Lx8bcN8e6WQhX/Ue10Yc+LvWFCVvMwSXoWqQlPYZ0vG3MrOrQVbGtYgERJ2V
        k2LY8Qd83gVRaKD7PTAX6yCZFEoAH0pRgj2cBiqMFvP2qr3rRcxRxOn2hJA0JqIK
        IbCvatAxwyCiKg/BPvOoX6RkEllNwwLdn0on4PmR90uE64PFNwhGwflMPENaY6pA
        ==
X-ME-Sender: <xms:dlPSXWvj2XNbWSNnLCpcJOU2AS_PgN8kshhR2T-R_MFYC1VQDJObcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:dlPSXQo-PLeF5O5o4P5Dt6DZZSiv9gZovhQD7zrZIzF2iqMNktOinA>
    <xmx:dlPSXVLuBSF0OoPgVOrC8fk_oa9pKnZujjQXMKSOm1UmZXhSUbvllg>
    <xmx:dlPSXQtkWtGfx6x8j4QybPWKXZi9uEQJSRfCb7ta5zS5frNgoJ6a4w>
    <xmx:dlPSXTs56XUse28HCmQ8f9c8A1C9wXeMwXBmUYBuFN_5vx-hvN_Pmg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A21E980060;
        Mon, 18 Nov 2019 03:16:53 -0500 (EST)
Date:   Mon, 18 Nov 2019 09:16:28 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20191118081628.GA139840@kroah.com>
References: <20191118.000801.490087222208784064.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118.000801.490087222208784064.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 12:08:01AM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and
> v5.3 -stable, respectively.
> 
> Thank you.


All now queued up, thanks!

greg k-h
