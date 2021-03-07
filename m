Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C3633026F
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhCGPDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:03:32 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:40519 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230063AbhCGPDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 10:03:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 57F962408;
        Sun,  7 Mar 2021 10:03:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 10:03:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=lMpMG5VZVPZqrn7upzdH0uShBQN
        ra/BfJs8BBOkLjSA=; b=dwNrRd2PVc5wF4XvK0qSaB7/lFkTGI7t5k4YBRpYV8f
        B1NH8ielaHKFHj7jw1k+qqBSfKaqYnYX+d0/bklemMUKwH3Bx8kGgTh73kF0v2uJ
        tcIy7Vv8JaSJBWagiPOGbUZUw0ci17Kc63N5JLuTKBdwydBSg/SxpYhLEKEGUamW
        BEjhM+k3WpYyu+eoXcoIXLDgTgJI6053hlFhJBHg0s0jT9hV1wfSvc8UkLaTIq3q
        LiVtK7drleZJEoJmIWcTERj0yNR+OTgmvtp1TVWquiitT+pCFSWXRtDsImmfRQf3
        44iR4ucS+95RW2Tp3CwtHSO6ATMaFXrlJ1foKPAhz8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lMpMG5
        VZVPZqrn7upzdH0uShBQNra/BfJs8BBOkLjSA=; b=m78rVVxQQRRezjiBN45iX9
        Eps3l02slc9vXWDqnaGLQjRIKrS80NRHiKulQv++EO0Df60CwkV7/5mHuAV1H0Tw
        YOK9NjPU20MwKc0RVrd2Rr9O8BcCCJ/NiluleO4FAvpWZRC2GVmrXBk3O4OB9sHf
        EV+YgWn30SAKp3qgFTh7fyC3Fp3cXACSNfzwYHF9oiCC7cqGD/eP37a+fxQkLrr7
        jiAG19wDijw0JpzFasq/in/iUoShRNdNZfM/NX2NWBFqf47gVf9G1ve7UMLZY/HY
        lus970zAYd16ovQdvvvnd68U7RIipgUqpWc6YQmp0EXA7QbLrpbarui4FrwwxxJw
        ==
X-ME-Sender: <xms:K-tEYJgrtIiZiYUe0Rr05b8kszdsOK9bOtsT2-okOBb7ZVqPNXvbcg>
    <xme:K-tEYOA791ulNgeaSU39QFpi68RmzIMuZ1fX-yIvsJ7olQuzzS4M1STCcC6PJVUBR
    SBOvh5TM4pV3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:K-tEYJEW8LFTzbD0ukWw4CIdvgQZdXAyrDfFlC1nJ1EWZP9DbHXFXA>
    <xmx:K-tEYORND0jOsK9gXTlAUM6-hIx80tY9svdKFQzRKCqlYZBK7TQ8tQ>
    <xmx:K-tEYGzG8jC6sHr5QQSFhFkfCsIqEJwxgnwTRkglGFkulk6vCMgS5w>
    <xmx:K-tEYNqZrh0wYIzRVN1CowyCXt4pNCKajX6SOYTs3Kjv87VPCsc_CA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4BF31080057;
        Sun,  7 Mar 2021 10:03:06 -0500 (EST)
Date:   Sun, 7 Mar 2021 16:03:04 +0100
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     stable@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: please apply 660d2062190db131 to v5.4+
Message-ID: <YETrKGcENSBg5WT6@kroah.com>
References: <CAMj1kXFhAmy746r+2VqtLHSwtM4-hcKsqqQRRMsFJkrQ99Yf2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFhAmy746r+2VqtLHSwtM4-hcKsqqQRRMsFJkrQ99Yf2g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:48:26PM +0100, Ard Biesheuvel wrote:
> Please consider applying the following upstream patch to stable trees
> v5.4 and up
> 
> commit 660d2062190db131d2feaf19914e90f868fe285c
> Author: Ard Biesheuvel <ardb@kernel.org>
> Date:   Wed Jan 13 10:11:35 2021 +0100
> 
> crypto - shash: reduce minimum alignment of shash_desc structure
> 
> On architectures such as arm64, it reduces the worst case memory
> footprint of a SHASH_DESC_ON_STACK() allocation (which reserves space
> for two struct shash_desc instances) by ~350 bytes.

Now queued up, thanks.

greg k-h
