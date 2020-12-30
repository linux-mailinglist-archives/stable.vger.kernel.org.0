Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2772E7A72
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgL3Pjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:39:35 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41611 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726322AbgL3Pjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 10:39:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 182AD5C00CA;
        Wed, 30 Dec 2020 10:38:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 30 Dec 2020 10:38:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=cG8A5aw0GzhlzuEw6LT6Kmimhjb
        Kw9XNpRQM9ZRMv+s=; b=x46jNR35IfKODwseBgBTGaaQ0ZTeZ7o+VcLU3HDy7G5
        8Bb20ZgWp3ZjNoP0D+gPYFL+41sZy5U5POu1NDPKfL5hJ95r2HXf+cRKJL3ZCFFz
        VjPvo9xAvD2RhTMjPp+GuzYGP3jRDgnBljq3WFvRKka5ZTTFkM303Ib0haLRzl85
        OYKfgKBhaFJJmXG2uyIbzqPh+dOb0APOO9Vspm3eFh7gC7Xz91o93E88N2WCcIh8
        S30auMpgYHsv9uxznXiRsOs9Z4troYB9n6TlU3XThxoKSGoUk1iU3E+3Ts+p3+OJ
        ZdBexkYsmN1Ta3liVCsCKyfReIpD2HnCpmU9qJX88aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cG8A5a
        w0GzhlzuEw6LT6KmimhjbKw9XNpRQM9ZRMv+s=; b=e3jbIqa+wn5BwjET1fDn3k
        mV2t6aJvNrBjXJeIF4gFrFgw0MhdPB4mQqSquhnzoW6aEGGBJKRIpHumhj2no1pX
        YiGG1oC9D0tmGQj4kz4bQ/qbCkrukOHPIyuMf+wosy+5oMaZphS5E+SI9iqKDbpX
        CcH/zy8Tei4+hxhU4NdMQa5PGjELmMNurg06LIBnBDxzgF0lfNZLEN9RusmfOVTN
        Q192XCK9CtaXxOqAKDrMXeGK9Z2OvbQ0vWkgao3oOM1+0gwdjlc7K50lSrQlf/Na
        7koqkpvq6YctFaD/DwTWsVS2KUmCTSXcbyGBot0J/J0nUuHgfyGIgYR5x+TdQ/Ig
        ==
X-ME-Sender: <xms:9J7sXyViZS5FJFZICNXwgu_9dU0xdFHFZXbcPR6HCaIOQxcFV6bIOA>
    <xme:9J7sX-kjaq_59cukCwI5T_Z4cX4x8Sv3NsWaeZV5ETkNtSXjgOY4DZGyOI6s9S4Vh
    kOAHA1x0UCyew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddvfedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9J7sX2b4oCyGnEV8REqV8kj1rwHlbD1X-dYlOi-R2ZNN11wQMalQKQ>
    <xmx:9J7sX5XToFYShImxZ7e3ze3VX127zhcblw2RtRLzXrYWTadbWEt8Hw>
    <xmx:9J7sX8m4MeAOUjpIXLwNaU7pb2QecbyvtLqCM-_-sFipWJk42stOAQ>
    <xmx:9Z7sXzt8EiRcvdW-ivsxQx1lzOi_73wDku3fpULPMyG5-O5AkrrC1Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 611E324005A;
        Wed, 30 Dec 2020 10:38:28 -0500 (EST)
Date:   Wed, 30 Dec 2020 16:39:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 5.4] fscrypt: remove kernel-internal constants from UAPI
 header
Message-ID: <X+yfS8JuMyKPXAWg@kroah.com>
References: <20201228184747.56259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228184747.56259-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 10:47:47AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 3ceb6543e9cf6ed87cc1fbc6f23ca2db903564cd upstream.
> [Please apply to 5.4-stable.]

Now applied, thanks.

greg k-h
