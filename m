Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0451F11AC6C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 14:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfLKNuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 08:50:37 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:56733 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727851AbfLKNug (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 08:50:36 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0B733B3A;
        Wed, 11 Dec 2019 08:50:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 11 Dec 2019 08:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=rWLtRqeFbvNV5oTNjf4B8+fKTqU
        R124KCB7bd0p5ttE=; b=Amze7L2b0Jo4z56/hk/TJ5ojY4XfzJq7IuwzZ8r9md0
        hIR1kKOQnowcSRsqHPSGgRX/6vhmHAq8eb7q5uhwxH044LqDfNe9jNUw0Z69x98W
        ZCe883WpcE7tVn0ddeBqZTfpOlT8xWq+q/NqhKQAqeQd8OQ4gcRWpYHzSufzT8jK
        8ZfxWyolxj5EOZ9IpsZi6J1XFPnKeRQKaghSF9E8teM7vBC7fwctmsiBMpDJk8eN
        V3p4AkVX8iyiLaF1Wv79JoBL8QVvTzOqQ1gSsB5avaQKypjIH3oIGEUAAYQkISqh
        MV2FTC9jHbTZZN4UwUQRIpNP+paos3qyPkuwCwfW/PA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rWLtRq
        eFbvNV5oTNjf4B8+fKTqUR124KCB7bd0p5ttE=; b=sLzOu3ue4oPcsCdENOHiEV
        u5ChKnauxXOJ0AQuOxn8D05FJanVLyE4KnzDrnjXNtNvguBYC5a1sPq1pIveVKO2
        eBYu/6OGqqfFKhHhEHq3q2Tx8TPgoNdYIRqG5csNGjKvJnBzGginDP0gu+GxJIaY
        JDnT8JhOnukZH6vQstBYjR6LVwXfGlgcSoc9owGEJ5qyEW51cahgcA9LDKfm+pgU
        q/EObFhLVtollZ2kDnBDhEn9EpM+Zneho3UcT0EOxQcshB1ibnlKDryZQmc5EiTE
        B/xZ1SjT7u19ABW7NBg2DWdjuRekHfyESIM8jrHVWQGVJckjb5UAJ5biht/jiO6g
        ==
X-ME-Sender: <xms:K_TwXehJi9h_-BcHXfagW8tYtXGonF38KjnZEAVjfWKqll6ygYzkYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelhedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepgh
    hrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:K_TwXbBxh9aaEvcdu2r5gIZ37Kj7--2zChkfFizpNA25c6mAnBCkgA>
    <xmx:K_TwXYtLw5ZRwTzsAhmEPck2dHWhU1kGxbJbtEXRupkHDGA2mk4n-A>
    <xmx:K_TwXVfUawZgcZjbXeN8_G4_sm4AZ28lnXMgS8l7DomDKvPFQO3U6g>
    <xmx:K_TwXQ8J1NlCPdZY24KmABJbVhd5bONT2xUhAIkltENhvh40Uwz2qw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 353E23060134;
        Wed, 11 Dec 2019 08:50:35 -0500 (EST)
Date:   Wed, 11 Dec 2019 14:50:32 +0100
From:   Greg KH <greg@kroah.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: stable RC build breakages (4.14.y, 4.19.y)
Message-ID: <20191211135032.GD523125@kroah.com>
References: <20191210225743.GA4443@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210225743.GA4443@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 02:57:43PM -0800, Guenter Roeck wrote:
> v4.14.y:
> 
> arm64:defconfig:
> 
> arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts:5:10: fatal error:
> 	dt-bindings/input/gpio-keys.h: No such file or directory
> 
> i386:allyesconfig:
> 
> drivers/crypto/geode-aes.c:174:2: error:
> 	implicit declaration of function 'crypto_sync_skcipher_clear_flags
> 
> and several similar errors.
> 
> 
> ---
> v4.19.y:
> 
> arm64:defconfig:
> 
> arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:82.1-7 Label or path codec not found
> arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:86.1-14 Label or path codec_analog not found
> arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:91.1-5 Label or path dai not found
> arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:297.1-7 Label or path sound not found
> 
> i386:allyesconfig:
> 
> Same as v4.14.y.

Thanks for the info, I think I should now have this all fixed and will
push out new trees to the linux-stable-rc repo.

thanks,

greg k-h
