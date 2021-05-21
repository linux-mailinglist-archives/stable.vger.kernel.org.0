Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6C38BD77
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 06:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbhEUEhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 00:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232873AbhEUEhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 00:37:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4484D613C4;
        Fri, 21 May 2021 04:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621571783;
        bh=Z7uNG1HK0lJJT+DGWcQ7x0X2hs4P50aBRqtRAz88beQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IiSZqAt/En5x/B/FyPoO4c0jGWWn3i+zYcxet7EU5gPQk9nB0NgrK7H0beGId0oJ/
         gaFVWoOebnQQOZicigpuvQTVX1J++BuLkfjr9u4bAVwdFMAsS7axMugcNVC4ZVvNQj
         br8k6vyC8AKHF1vLFhi2FiD46+pHgCB0OqpV5G/I=
Date:   Fri, 21 May 2021 06:36:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 4.19 425/425] scripts: switch explicitly to Python 3
Message-ID: <YKc4wSgWcnGh3Bbq@kroah.com>
References: <20210520092131.308959589@linuxfoundation.org>
 <20210520092145.369052506@linuxfoundation.org>
 <20210520203625.GA6187@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520203625.GA6187@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 10:36:26PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > 
> > commit 51839e29cb5954470ea4db7236ef8c3d77a6e0bb upstream.
> > 
> > Some distributions are about to switch to Python 3 support only.
> > This means that /usr/bin/python, which is Python 2, is not available
> > anymore. Hence, switch scripts to use Python 3 explicitly.
> 
> I'd say this is unsuitable for -stable.
> 
> Old distributions may not have python3 installed, and we should not
> change this dependency in the middle of the series.

What distro that was released in 2017 (the year 4.14.0 was released) did
not have python3 on it?

> Python is not listed in Documentation/Changes . Perhaps it should be?

It's not required to build/boot, just these helper scripts.

thanks,

greg k-h
