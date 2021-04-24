Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2353336A1AF
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 16:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhDXOvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 10:51:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50851 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231814AbhDXOvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Apr 2021 10:51:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5283E5C00D9;
        Sat, 24 Apr 2021 10:50:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 24 Apr 2021 10:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=qP7nOuBgYMMCggPA9hPMYTlEj6T
        brjnsTUUSRS18HYA=; b=S29yr/1yYebL9wWlBn80pbC0ooAYpoAMGuFjdRYRi2i
        O6fVdssl4uxtvYBvIUm5fewwa4alD6S8NpynY7nBDfRk/nuLj0BLqAgZJNCp8zXK
        YfZUXSWZDaajqNx8dzgD23NeanS4sVHCQRIAchtKJjpswnFarSe5TIjTIiAi0X7A
        YqbTDNh0b1fjEGxPqAHn5ao1R0KcUBvTzE8w5/yT/Us7GCkXbraWQ3pH98fk2oOE
        cFV7n9Fkg9gN8CcGVw8+Y4ksuxgewuJXpj4qplt+eygo+6QokMYQ5VuRyRvqb4m6
        LO78VJcvszsmNpHJvecRWxfbOUoqlMGCTY7uh5rbCIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qP7nOu
        BgYMMCggPA9hPMYTlEj6TbrjnsTUUSRS18HYA=; b=osTephzniCDyNyZM3XxXl6
        xnxs9AM07WG+dtmVz4XRTQpwxATpB0xugg7AWMBLJNyQUxxdSgTipwmr13xoWNDG
        4BfnHE28/qosrG5A2ZjwX0RoM9wsGcvxt+6Tj8HGAhOOp1PN2vQBw/gUIxGAPlg/
        5TyvZtE5ixcm66elK/vDmAEJMVERmU1AiHs5YkLtzCbt7G6OIcZQyDP9b/Yp5hYt
        SnLXQf7m3Ygn+XrUYeirkR7CJs+fvzedfdaMg1t+mPH0FWhWfuQEpWoQxGawN1y2
        tUu3X1i09CPOBEhuRwFSdAm8WiD1POOkBG8Q/EOI+6bxy50GqOMotU6DNAbi/ggQ
        ==
X-ME-Sender: <xms:QzCEYIOe9IzdG4u0aSDAqRG_HhMrER3wmoXO9qzezCw_Ij1-2P02bg>
    <xme:QzCEYO9LS82y10naAXwArH1U6JcLACrizHW0oECryVX6fZvPUSoJRKOLtj86w-r5p
    57JMws_veJmww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeffkefhge
    fgvdejvdelteegheeiffdtieeiudeitdeklefhfefhjeefudegudevgeenucffohhmrghi
    nheplhgruhhntghhphgrugdrnhgvthenucfkphepkeefrdekiedrjeegrdeigeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhr
    ohgrhhdrtghomh
X-ME-Proxy: <xmx:QzCEYPRm_EiW04jk5iB1BF2clNv2HCV9kQIrsCaBeEbdsmupgSK1DQ>
    <xmx:QzCEYAt6yp2b4oCCIWTAovqBNCGzWoZIkuMdnEWuFXOyMUT1ndCgnA>
    <xmx:QzCEYAedQ2Hv6CSLNnLB1NK-9m3RejsNyXL1NLJ30wEY9OuHow3nrw>
    <xmx:RDCEYBqkDFAq9c4L2XGozNLyfunCL9VW6KHrBIjYrpardiHbtc54NA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F08B24005D;
        Sat, 24 Apr 2021 10:50:43 -0400 (EDT)
Date:   Sat, 24 Apr 2021 16:50:41 +0200
From:   Greg KH <greg@kroah.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Dan Streetman <ddstreet@canonical.com>
Subject: Re: [PATCH stable v5.4+] s390/ptrace: return -ENOSYS when invalid
 syscall is supplied
Message-ID: <YIQwQSUDnZJVb0ei@kroah.com>
References: <20210421165853.148822-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421165853.148822-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 06:58:53PM +0200, Krzysztof Kozlowski wrote:
> From: Sven Schnelle <svens@linux.ibm.com>
> 
> commit cd29fa798001075a554b978df3a64e6656c25794 upstream.
> 
> The current code returns the syscall number which an invalid
> syscall number is supplied and tracing is enabled. This makes
> the strace testsuite fail.
> 
> Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Dan Streetman <ddstreet@canonical.com>
> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1895132
> [krzysztof: adjusted the backport around missing ifdef CONFIG_SECCOMP,
>  add Link and Fixes; apparently this should go with the referenced commit]
> Fixes: 00332c16b160 ("s390/ptrace: pass invalid syscall numbers to tracing")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Thanks for this, now queued up.

greg k-h
