Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DF515CB18
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 20:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgBMTXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 14:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbgBMTXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 14:23:23 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73567217F4;
        Thu, 13 Feb 2020 19:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581621802;
        bh=Kl8nKLFeK6/115Ox3GEgOnGJrYudXum8DIGHQZF9RIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t2Hjpu6qPKVsWADaJqe72Uvn5SrgTQg0a7Qvy3rmOYjQLH92njzpPa6JqvJgmYoZz
         /j62vupd+nhqhSZxBukF6XJJJ7OY//9Ab/RzxBcJqEZb5aZZoxx/v1iv9wGZRhFxw6
         B3MuOCdwzH/h9kuTRQpr868q+1DKVzHhE6Ichjo8=
Date:   Thu, 13 Feb 2020 11:23:22 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, nico@linaro.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <Miles.Chen@mediatek.com>
Subject: Re: please cherry pick 75fea300d73a to 4.14.y
Message-ID: <20200213192322.GA3778561@kroah.com>
References: <CAKwvOdnYPvov5ULB_BHodeLde4V1Zg+UF0X=V=i1yH77XvhXZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnYPvov5ULB_BHodeLde4V1Zg+UF0X=V=i1yH77XvhXZg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 11:19:16AM -0800, Nick Desaulniers wrote:
> Hi Greg, Sasha,
> Would you please cherry pick
> commit 75fea300d73a ("ARM: 8723/2: always assume the "unified" syntax
> for assembly code")
> which first landed in v4.16-rc1 into 4.14.y?
> 
> In my experience, it cherry-picks cleanly.  It fixes a stream of
> warnings we see when building 32b ARM kernels with Clang, like:
> 
> /tmp/signal-1ac549.s: Assembler messages:
> /tmp/signal-1ac549.s:76: conditional infixes are deprecated in unified syntax
> 
> We'll make immediate use of it in Android; if anyone objects to
> landing in stable let us know and we can carry it out of tree.

Seems sane, I'll queue it up after this latest round of stable kernels
are released in a few days.

thanks,

greg k-h
