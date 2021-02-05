Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D377310714
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 09:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhBEIwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 03:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhBEIwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 03:52:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE9F264F45;
        Fri,  5 Feb 2021 08:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612515082;
        bh=REP4ns2h9fgZWjq6VH8JOnwJ80CMeUx8n2/x49rjoVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P/YyfDAf5qbV4DZGGr8hA4DoVKozUdSUMHaxrhUi1OYCFFloc+0K0AkmjC5SNt9ua
         H7VR71l7nG3STStDI8i+vu18Of6fjRElwqDWT3Ie7fXBcn0BvBg3FJJLLeFFpuHSQ4
         JI7nGTgKB4B7X9KS5HJ0Fo4blj/SGeGKAoIMarno=
Date:   Fri, 5 Feb 2021 09:51:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: Apply 28187dc8ebd938d574edfc6d9e0f9c51c21ff3f4 to linux-5.10.y
Message-ID: <YB0HB+tcBT30QdLM@kroah.com>
References: <20210205041351.GA2494386@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205041351.GA2494386@localhost>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 09:13:51PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please apply commit 28187dc8ebd9 ("ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN
> depends on !LD_IS_LLD") to linux-5.10.y, as it fixes a series of errors
> that are seen with ARCH=arm LLVM=1 all{mod,yes}config. CONFIG_LD_IS_LLD
> was introduced in 5.8 so it currently does not need to go back farther
> than 5.10.

Now applied, thanks.

greg k-h
