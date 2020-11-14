Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE4A2B2D0D
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 13:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgKNMOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 07:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:32960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbgKNMOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Nov 2020 07:14:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91B0A221EB;
        Sat, 14 Nov 2020 12:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605356079;
        bh=eihgCNKHfFlAAJKfNIF//A+P9gIEARBEfdjzBmP4goo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z7Z3V2hqptPYArwrXWjYSQY752RgfTFR1uLnidqpjlQJaJz50gBOZipV6xrk3DOpK
         N3qEdGq2IXKDLNs1w9bYsTc+oz2RQkpVcEkJeZEg88tREvGIo4CNyRL/rvlE3qNAqg
         y1RQzZ74n9XRZh2CpWp2jbm4VXaX4CE0Lm/62KAc=
Date:   Sat, 14 Nov 2020 13:15:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: LLVM_IAS=1 ARCH=arm64 4.19 patch
Message-ID: <X6/KZamOEdcnxb8h@kroah.com>
References: <CAKwvOd=x+fVo1_mMJUGHYXpmGf8UM5yx+uWD-Ci=y=0oFX2ktg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=x+fVo1_mMJUGHYXpmGf8UM5yx+uWD-Ci=y=0oFX2ktg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 13, 2020 at 04:27:02PM -0800, Nick Desaulniers wrote:
> Dear Stable Kernel Maintainers,
> Please consider cherry picking
> 
> commit ed6ed11830a9 ("crypto: arm64/aes-modes - get rid of literal
> load of addend vector")
> 
> to linux-4.19.y. It first landed in v4.20-rc1 and cherry picks
> cleanly.  It will allow us to use LLVM_IAS=1 for ARCH=arm64 on
> linux-4.19.y for Android and CrOS.

Now queued up, thanks.

greg k-h
