Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2362D0B4B
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfJIJdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:33:03 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50085 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730537AbfJIJdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 05:33:03 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4A211220FF;
        Wed,  9 Oct 2019 05:33:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 09 Oct 2019 05:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=+WhHrTIkTVQk7pS8KarXF2aI0kL
        2KM0I6mSclqMbzhA=; b=WYY4Cy+GAWLmc1y1O4h3T4RaBg/KpTwJYVi+lwCugP1
        7lsyv+oiZwbjKnkP2PQn3YiJ1ws0uRNFe6bqJMJBLd/HZSQgOjJ4LS96flb5OL5f
        b6P8L9cWZdTz8MNIpayN2Beh8LknBH58cyuQxt562W2Jw5DEnJfkx3BBAimnMDwK
        kL8gzS43cC1/6GreHShPs1IGtwaLP3GR96tCP+G2oQOwiAuGLEniqBaSIALnNxZY
        A7skuChgSGQseqYZ/DiZj3jSTLogEFTCXG/QiUFBEy42DUzZgkE5KLdf+gDbKPWO
        Kco9tAbrBWmiIRGJc5S2rY3x7RI36/nVN+d2qKIrU0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+WhHrT
        IkTVQk7pS8KarXF2aI0kL2KM0I6mSclqMbzhA=; b=tzYdCvF+m1tksFtEFDNHaN
        z/DUMFZTCUHSjU6lz/sl/0FwGpapzxVuQ9ldyU5rx4RW53AL7LT50lFbzpANQA4k
        y93cnnvgtyAsKa8vwoipmUZW5CSdiOuY3GR3C9FmEW9/DsATceQxed0srGF38kcu
        fhNtu9dza5OuZQ2YyujZ5ToD0q039OomgNbubrvZlQM8QWi8h/NUtPMDFyQAaepc
        D8rZMLpXdys7MQmzBfZQsT8QvniKMh0JjTeDAg2KiCkkqx21qO8MxIrzkUyOVi74
        YeTuYsoDe9ttoRv1J7XddXwPzFJf/XK97Y/XQPpSI5C6yHMb7RGJHVppXQXfio8g
        ==
X-ME-Sender: <xms:TamdXdrvPGJ_F938k0B0TDRlIuYwvPMJfz8loYV3eD8jseHYyDD3Sw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedtgddugeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:TamdXYvx1hWAJWV05J4Hk6nIwwMwVn0iWGJEK-HPzOUXiRU738ixgQ>
    <xmx:TamdXTQXGKR3XZm0FpkB9Q9KEBbpaVKUENMIYZph5bU5XlIOWgAw2w>
    <xmx:TamdXUoY7R_IXYhZzSDT6NGG4acf1cRndaKSade-UnFdifWmB2Vsew>
    <xmx:TqmdXXO-wHf5ekxVPrZJNENN_CNOHFzqcIhuawjvs6vcrjaWspT9eA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94E40D6005B;
        Wed,  9 Oct 2019 05:33:01 -0400 (EDT)
Date:   Wed, 9 Oct 2019 11:33:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH for-stable-4.19] arm64: Use firmware to detect CPUs that
 are not affected by Spectre-v2
Message-ID: <20191009093300.GC3901624@kroah.com>
References: <20191009091023.19336-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009091023.19336-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 11:10:23AM +0200, Ard Biesheuvel wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> [ Upstream commit 517953c2c47f9c00a002f588ac856a5bc70cede3 ]
> 
> The SMCCC ARCH_WORKAROUND_1 service can indicate that although the
> firmware knows about the Spectre-v2 mitigation, this particular
> CPU is not vulnerable, and it is thus not necessary to call
> the firmware on this CPU.
> 
> Let's use this information to our benefit.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/kernel/cpu_errata.c | 32 ++++++++++++++------
>  1 file changed, 23 insertions(+), 9 deletions(-)

Now queued up, thanks.

greg k-h
