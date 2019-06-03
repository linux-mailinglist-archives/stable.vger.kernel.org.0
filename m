Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E13832A1F
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 09:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFCHzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 03:55:00 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33827 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbfFCHzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 03:55:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D4A3621BBE;
        Mon,  3 Jun 2019 03:54:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 03 Jun 2019 03:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=O/GTTn6uITCuul6gLVjhdsyGhir
        aokxjzWB6VqBqvoA=; b=YmMfHSlh3OGAbOUn7jkPI6Oc0BLjmgb+fIa1h6CzAUi
        tW/valjo96mDR3AEJIVl0znfhcCC5u3MfYNHHnty58mvUO198BcR29mDG7LPxrex
        2Ru/3bDZ/V0I/+bQyTODopVqndP9QTqjw7axAJiIF0Bv9Vb5QV9CBIt4gXbtYWx4
        oQiARi6Icw4MwfOaKsWCaetVoCcFPR8Nx5DCufvN4ZrY/cL1ho3Su0rtZN9YSi+f
        qYDiJWnkMh/7mOTlVPyHD7WZpdmWwAYk0qBu2TWkwkzCjLGRtug7MmKVhjlWczC8
        kMKHphTG+JPfhqEg3tc/TI/JUdLrydwInNf5oxak8Yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=O/GTTn
        6uITCuul6gLVjhdsyGhiraokxjzWB6VqBqvoA=; b=PaYFTZL8SOV2rIDMHICT2c
        ckcytup378mjyMGMNBarcORlI54FB50fKLjfAsX6ttXJJqfFuB95rABr2EdzXw2P
        6d+pAu3cWXaNfvX44fXLer6vkmN6a5q1NQNLCQ+32AgUTwdFZGbkFiDsYr4ydHEt
        rM6kbYz143TCH7t7Q8JEXyab8G0zt0579r8uBybJZJ1yKGJy3j8sCyS6FHl01nVA
        cpXA9vwADGBBD4RoDleckXg4iUMhrxLMZs/pWCGdlXp0Ea1ewTdF56B7WBBSUvXX
        4uilpIp3B6FkLpiymtVMfzbp1jAlF5LtCaXiDGzyvkh9ktfvOQ0ffFli/5cvfGPw
        ==
X-ME-Sender: <xms:UdL0XBU6s21Y9W7RjFYnlPrtcuKZq-ZyqJKgMgGqRYq9SQ9U9NFUlw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefiedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:UdL0XHXhJrBadJAg-6dvK9oweaM82BkbVFACGg7daLekmN4qRC1kzg>
    <xmx:UdL0XLdr_BhW0k3S8AuFV9omd5wrTN619OMR6EuooCnoWhw_Wwnarg>
    <xmx:UdL0XO4tCHRWtzdOuRj3l37r00hRelH4FpAfI_ikK3JbckFB-GH4Yw>
    <xmx:UtL0XGu0wvkbWTMYSmSs8qIX6Vm-TVR2_2XmpTIG1sFxsxfruMB3nw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 54E84380089;
        Mon,  3 Jun 2019 03:54:57 -0400 (EDT)
Date:   Mon, 3 Jun 2019 09:54:55 +0200
From:   Greg KH <greg@kroah.com>
To:     Daniel Axtens <dja@axtens.net>
Cc:     linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH BACKPORTv2 4.19, 5.0, 5.1] crypto: vmx - ghash: do nosimd
 fallback manually
Message-ID: <20190603075455.GB7814@kroah.com>
References: <20190603020848.9598-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603020848.9598-1-dja@axtens.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 12:08:48PM +1000, Daniel Axtens wrote:
> commit 357d065a44cdd77ed5ff35155a989f2a763e96ef upstream.
> [backported: the VMX driver did not use crypto_simd_usable() until
>  after 5.1]
> 
> VMX ghash was using a fallback that did not support interleaving simd
> and nosimd operations, leading to failures in the extended test suite.
> 
> If I understood correctly, Eric's suggestion was to use the same
> data format that the generic code uses, allowing us to call into it
> with the same contexts. I wasn't able to get that to work - I think
> there's a very different key structure and data layout being used.
> 
> So instead steal the arm64 approach and perform the fallback
> operations directly if required.
> 
> Fixes: cc333cd68dfa ("crypto: vmx - Adding GHASH routines for VMX module")
> Cc: stable@vger.kernel.org # v4.1+
> Reported-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Tested-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> ---
> 
> v2: do stable backport form correctly.

Thanks for all of these, now queued up.

greg k-h
