Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FD9341A1D
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 11:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhCSKdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 06:33:13 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48359 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhCSKcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 06:32:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id D203C1603;
        Fri, 19 Mar 2021 06:32:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 19 Mar 2021 06:32:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=8gucYTvp7x2/B0oG/OUcBwA0zrC
        1U7rEi/7Qrp41oeY=; b=XI+LIQOWbegppsUuzzr+iDfwx3cNGzDL6d+TNam4HIf
        Z1LpxoaMslhDSyWA750IR1dwPR/pffzkPYBy+OzzUoYE9NXCUzf52zd4WWU9CPq3
        b6frx6eFHaTkqoarSDBf8efAGV2tP9IquIgQUYMpoX8iSa6dt+7L/M+Eb6v53jxd
        rybtfyYDLyWx8vBSRLdPQW0b3EDrCHPIXYQXcd7ioOXvFiT2QurTOzW2YZoK5BZS
        ySUCEWxC5qQLxeESISGTT3SBfzNbyNcBU3WJAiB5Mt1RxDL+dJsBkgwjsC10QIh5
        MVcT9zKICqS0KN1kHjpAsTTE+OD89mYMvwy6dij++oQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8gucYT
        vp7x2/B0oG/OUcBwA0zrC1U7rEi/7Qrp41oeY=; b=eSIEfZLxaJAL47VK48o1TZ
        vnXI3CDz2TTK5pUgUYFGb2ZlS/3GoF8DqdLGW9AMBAdv/y29l4TpBrao+nGC+fD6
        5IV2HsyIUo4KJcwmnqgdeONMgINVo8IvVEbMToI3rKglCtSY8lYOQhyB6WYT66FP
        RGJ+ZPGBIODH5ChbhOxOb3t6OM3RlisTfPp1hPrv0+ldiu6QszxFe2Td7OyL5LJ0
        dgnPcBAgIcxVg9NZ6YguW+8fZxhgeNhnw6x6VUuMJM1SGOKVeKOaXFw38fK2EFdE
        S0wyJxj4EcVvOdbIsEbb2veC6FHxiZcSPYEF73PDEW1KkP1uJKTZq1KbwXeZseng
        ==
X-ME-Sender: <xms:0X1UYOsEajTgaZKzGjbLmQNwAJhu8Iq74lHawdhK2u7mtmaSxdGjHQ>
    <xme:0X1UYDdWKSwMAUwsZymjsMPDoo3VDxayk0vqG9pipr9fzbxijBG7JvTkgnd3u9gY5
    LvxKz3foJNrgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefkedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0X1UYJx3IxUnuV4if88CXuGER17ZgnEImjPiQbOt5EtWSTBAd1pqUQ>
    <xmx:0X1UYJOBQ65ruzU1oDKzOZXlZ96h5OSNL9BLWWQpyonfCaEFMUobMw>
    <xmx:0X1UYO8B8AJcGIvbxGvXBqBhR0evaUiXLth9pPMZjX1qvmRa4u1rng>
    <xmx:0n1UYFmu8q2X0CHNI_y9a7LtSnrZI_t246Hjd9UVz-iVxqqwOU3XWQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E75B924005E;
        Fri, 19 Mar 2021 06:32:48 -0400 (EDT)
Date:   Fri, 19 Mar 2021 11:32:47 +0100
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ardb@google.com>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org, tmb@tmb.nu,
        sashal@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH for-stable-5.4] crypto: x86/aes-ni-xts - use direct calls
 to and 4-way stride
Message-ID: <YFR9z5xqrsq0gZAS@kroah.com>
References: <20210318174151.2164335-1-ardb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318174151.2164335-1-ardb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 05:41:51PM +0000, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Upstream commit 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
> 
> The XTS asm helper arrangement is a bit odd: the 8-way stride helper
> consists of back-to-back calls to the 4-way core transforms, which
> are called indirectly, based on a boolean that indicates whether we
> are performing encryption or decryption.
> 
> Given how costly indirect calls are on x86, let's switch to direct
> calls, and given how the 8-way stride doesn't really add anything
> substantial, use a 4-way stride instead, and make the asm core
> routine deal with any multiple of 4 blocks. Since 512 byte sectors
> or 4 KB blocks are the typical quantities XTS operates on, increase
> the stride exported to the glue helper to 512 bytes as well.
> 
> As a result, the number of indirect calls is reduced from 3 per 64 bytes
> of in/output to 1 per 512 bytes of in/output, which produces a 65% speedup
> when operating on 1 KB blocks (measured on a Intel(R) Core(TM) i7-8650U CPU)
> 
> Fixes: 9697fa39efd3f ("x86/retpoline/crypto: Convert crypto assembler indirect jumps")
> Tested-by: Eric Biggers <ebiggers@google.com> # x86_64
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> [ardb: rebase onto stable/linux-5.4.y]
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> 
> Please apply on top of backports of
> 
> 9c1e8836edbb crypto: x86 - Regularize glue function prototypes
> 032d049ea0f4 crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg

Now queued up, thanks.

greg k-h
