Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F7941D710
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 12:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349469AbhI3KFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 06:05:09 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:48805 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238316AbhI3KFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 06:05:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0C24C320091A;
        Thu, 30 Sep 2021 06:03:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 30 Sep 2021 06:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=6P7Wm/nZSTHI0Qc/xSxwkbHz795
        Nw0k2yGYKP++MtDY=; b=HbKzMXDEE1zXrIu0lm8DdS/q80Cc3SfGZ/8hgr0rvSE
        Bu9OERcnILPff43o8TFk776X16UzKv5lLXy0HsVrdQKSIyeh/htrsoX6aSw2craU
        iNk4ynbGuhKBXp7qWEqV02lyHML45rtsd/GkvzHRXXBFc1+Y3XNAGhH0bwkuXgV3
        0dX2xlJb87bsCxF8RzrsAqHZ9+8GOtd1FfB9n7LBEAex92niqPvR0NkFrDAa++Y3
        J9tQOpdzxrm8MNzHygtCp17kYClBMuKHZchKT30OnW2U2z/uS7AVxohHUx7+rwbG
        w6jCZH+xI7mjcdZmLi/HH6ChPgDNUjlNBvwyQpdrBHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6P7Wm/
        nZSTHI0Qc/xSxwkbHz795Nw0k2yGYKP++MtDY=; b=GHMJ9CSKlE0MIFwybvZwU3
        N3Uv0sFoEyoz75hlDg/3uFiwlAKNRDJ24PX4opzDVI962CXifIL1nrt2+J3OgY5V
        EQTNlniL+1jRtsaXV2p1IcQAoZE9TEvqceiNC4YrqJGNooT8672Jll7yvXDvmA5A
        X99IsR7aAwNZYYyk/zgv5rn7q0w4F1iaPH1ciAd6KDMjtxirQVODu9XWn/uPv+cH
        Riy6C24alCRJMn3JLGPS8O8ShJcQMGyiq5cgTeeIVmIolVHenxRtJbfAzp3E2MOj
        GhsbKzNiBoBGY42C2YaDch6n22rW6gjQGitHS/1/z619nBsx1cNr7iiQ7j1s6oTQ
        ==
X-ME-Sender: <xms:bYtVYfMOwnPT8mboOOTbr52XeFGI7nQehqrqn6_-SzRRpNlGto65ew>
    <xme:bYtVYZ_LCG17d4JV9jq1GY4AxKpIPaHzVrNdMrx_DosekD_0-KpXjvT-oKZp-3Jhv
    S4H5xG-hKvTrg>
X-ME-Received: <xmr:bYtVYeTko-M_Nc8MxOF-jy1z9EVyABhX35hq-MnSN2mOKD1Y0vF1P2VULAMBay0M8jjTNDf18fKHJxW_bUeqDKlVEKksgIdP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekgedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhefgje
    eitdfffefhvdegleeigeejgeeiffekieffjeeflefhieegtefhudejueenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:bYtVYTu5gCt0T5kaq0g6u8lsVhpbbPm_CuuEXb-UbmIVWEwPMA2igw>
    <xmx:bYtVYXek4VTHDWKmt4CaLEn8rbwgETaysflGveqRA7iJFBIHABo-_Q>
    <xmx:bYtVYf2McC7PRUBsMZM_H1y6el0ET0JacIOPR6aLdrRgr7aVSlBrIQ>
    <xmx:bYtVYYopOoHe-cySPQHArXsuDLeVrQQss8NToJbJvwWOo6f4jOQyFg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Sep 2021 06:03:24 -0400 (EDT)
Date:   Thu, 30 Sep 2021 12:03:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdns3: fix race condition before setting doorbell
Message-ID: <YVWLamYUlXMmjdqq@kroah.com>
References: <20210930094217.23316-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930094217.23316-1-pawell@gli-login.cadence.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 11:42:17AM +0200, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> commit b69ec50b3e55c4b2a85c8bc46763eaf33060584 upstream
> 
> For DEV_VER_V3 version there exist race condition between clearing
> ep_sts.EP_STS_TRBERR and setting ep_cmd.EP_CMD_DRDY bit.
> Setting EP_CMD_DRDY will be ignored by controller when
> EP_STS_TRBERR is set. So, between these two instructions we have
> a small time gap in which the EP_STS_TRBERR can be set. In such case
> the transfer will not start after setting doorbell.
> 
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> cc: <stable@vger.kernel.org> # 5.4.x
> Tested-by: Aswath Govindraju <a-govindraju@ti.com>
> Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/gadget.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

What kernel(s) are you wanting this applied to?

thanks,

greg k-h
