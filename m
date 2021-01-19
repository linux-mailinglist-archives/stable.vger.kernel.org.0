Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116182FBEA8
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731617AbhASSNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 13:13:30 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47595 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392551AbhASSNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 13:13:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 665E55C007E;
        Tue, 19 Jan 2021 13:11:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 19 Jan 2021 13:11:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Ho1rsGuWCLEhA+XEBBYvZsB6aeO
        3Peg6MEz7QkmwvqE=; b=aDU8sr7dSo94Mug38aPw6zplZb5LMOx9ji0UWuJ9AzY
        YyT9ERUN0EBGZa0PO92ITbTsbUHTx1LYdQPxxiU81XYGwm7A2A+mJpGUDfRVG9tQ
        SXzzet3h4p1eThwe/tzsPbjnMFsXWEzGMpkEndWbZjMrVKMiJ1pWUdSlPtZ3YheF
        AkCu1CmxI6Y6XSXYRjKzl8oRu7ml5YkuVUNuqNbe5JPXcc+EJ4yTplMIJnFPPwPe
        SqKlAHWBkd8O4XWivgS4K47toPI4lds3UNUIHsKRB/Q3l+Ce53DuZmbTlV3SuXO3
        qSmTLKrIzIa1grs/LjDXCsvGazVhWc0EuIAr20CFaQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ho1rsG
        uWCLEhA+XEBBYvZsB6aeO3Peg6MEz7QkmwvqE=; b=hzWHHPStTLMcBLNnnSlBJR
        AtSN7+ul/Iorj99yAHS+PGknW2QrtGX+9OZPUTzW6GIyRBqxe2qx8+rlvrYk7cyF
        p+DMd6z5A/ZsodZFSGVbo1fTNLG6v2Tj4bMpSN4HYNyyaUxFlMna9jFn9bNU0NOk
        zQLKQYUtSD0+Vte7HavGub4tKnNvPLcQuUW75GFbpk9zn0f16IwiJxDvJy1CgGdp
        9kvxlE90tEkEwr0pM1wNEaV81EMF/ldluyFu9r5UdRepgsxqtBdqc9ZdkhRs3NuL
        L4Wq/tio/rqWddUfdz6zmSetlgLt9cbTRa3DvJYeASCR0CK32eOV0QqXdnaTM5hg
        ==
X-ME-Sender: <xms:3CAHYOuxmbdUNc-U4fBVKeyfk3QdlpyK2MOuYC1fbeqxraqvL3Mj8A>
    <xme:3CAHYDf_41hBuxLn6a3tRLhG-Xc7MHQ_PUQhQH_6w_Szuneidb52K-x3gcovIQNK9
    u0dZxskibgVPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3CAHYJxsc6CZUt9vA4bP0KfnazpHL6gEjbr37kVEa_7A5F-8CfDNyg>
    <xmx:3CAHYJPSbLF8G-QZXZpPqIPoe-r3RxlEzYodkvd06nBb0tSfnK6FbQ>
    <xmx:3CAHYO9-TSZPy_Tcq7CUO6Rf4xYJ8e-Aoo_B6GLS8OVAh1mY36jmiQ>
    <xmx:3iAHYALbKZiK7zII15FBiYi_BzciaCXbmRP-GT_ypBEGIOACd1dQUw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA8A6108005C;
        Tue, 19 Jan 2021 13:11:40 -0500 (EST)
Date:   Tue, 19 Jan 2021 19:11:38 +0100
From:   Greg KH <greg@kroah.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Hamish Martin <Hamish.Martin@alliedtelesis.co.nz>,
        "paul.kocialkowski@bootlin.com" <paul.kocialkowski@bootlin.com>,
        stable@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: Request to apply commit c4005a8f65ed to the -stable kernels
Message-ID: <YAcg2pklrTlaTinX@kroah.com>
References: <20200910212512.16670-1-hamish.martin@alliedtelesis.co.nz>
 <X+huemxT9XOeDi5E@aptenodytes>
 <20210109212608.GB1136657@rowland.harvard.edu>
 <83ed9f3929bd064b54bb9903cd489adde442e1c7.camel@alliedtelesis.co.nz>
 <20210119155145.GB173923@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119155145.GB173923@rowland.harvard.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 10:51:45AM -0500, Alan Stern wrote:
> Greg:
> 
> Hamish Martin has reported a problem caused by applying commit 
> b77d2a0a223b ("usb: ohci: Default to per-port over-current protection") 
> to the -stable kernel series without also applying commit c4005a8f65ed 
> ("usb: ohci: Make distrust_firmware param default to false").
> 
> Can we please queue up commit c4005a8f65ed for all the -stable kernel 
> branches which already merged versions of commit b77d2a0a223b?

Now queued up, thanks.

greg k-h
