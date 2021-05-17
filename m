Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2439A382B36
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbhEQLiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236689AbhEQLiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 07:38:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1A2C6105A;
        Mon, 17 May 2021 11:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621251406;
        bh=jBBC2lYE+Ko5wTWydi62ipgYkpdt1uB8K+AzeNp9n9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cV9JMd9XlXoXqwYMd5M3uFAJ9J2mNh/wRTl7pfGZYX/2KxrBXmx99wfbVsTkA5uTz
         p++uO9YVmlk8P8Tq25PmaObuEEOBsQ50M6fiBiwV3AHk/1pAucYvBK/xSeiYCdGNKE
         L6krwByXaTS4grmMb7vOtjaPrt7qQPQSbRX3dUKc=
Date:   Mon, 17 May 2021 13:36:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH stable 5.10 v2 0/4] ARM FDT relocation backports
Message-ID: <YKJVTD4Cwe+7WoO+@kroah.com>
References: <20210510132111.1690943-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510132111.1690943-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 06:21:07AM -0700, Florian Fainelli wrote:
> Hi Greg, Sasha,
> 
> These patches were not marked with a Fixes: tag but they do fix booting
> ARM 32-bit platforms that have specific FDT placement and would cause
> boot failures like these:

All now queued up, thanks!

greg k-h
