Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7974C33AE41
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 10:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229467AbhCOJN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 05:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhCOJNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 05:13:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D41D561481;
        Mon, 15 Mar 2021 09:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615799581;
        bh=fU8RWNiN7cmRxiXXu15mvu75Fbd+m3AuvFVMtYGdLtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EZ7b9z+xLOzAPnrOdFBQMzMSb2r5SoTAhFZZJ14pbtM4cnJB82/G0n3+uAbPwLvpq
         f2YyAlGKoGSuB1dPHsk9iwwLDSfyk8k36iYEIvmvCO4r3hFOWrfDUdx0HOT4uIQ8yi
         JmVUpkR3vmFuxhjxA8MGPpPZZz5PG9GspvUNqEow=
Date:   Mon, 15 Mar 2021 10:12:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, candle.sun@unisoc.com,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <miles.chen@mediatek.com>, Stephen Hines <srhines@google.com>,
        Luis Lozano <llozano@google.com>,
        Sandeep Patil <sspatil@google.com>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
Message-ID: <YE8k/2WTPFGwMpHk@kroah.com>
References: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
 <YEs+iaQzEQYNgXcw@kroah.com>
 <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
 <YEw6i39k6hqZJS8+@sashalap>
 <YE8kIbyWKSojC1SV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE8kIbyWKSojC1SV@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 10:08:49AM +0100, Greg KH wrote:
> On Fri, Mar 12, 2021 at 11:07:39PM -0500, Sasha Levin wrote:
> > On Fri, Mar 12, 2021 at 09:28:56AM -0800, Nick Desaulniers wrote:
> > > My mistake, meant to lop those last two commits off of 4.19.y, they
> > > were the ones I referred to earlier working their way through the ARM
> > > maintainers tree.  Regenerated the series' (rather than edit the patch
> > > files) additionally with --base=auto. Re-attached.
> > 
> > Queued up, thanks!
> 
> This series seems to cause build breakages in a lot of places, so I'm
> going to drop the whole set of them now:
> 	https://lore.kernel.org/r/be846d89-ab5a-f02a-c05e-1cd40acc5baa@roeck-us.net
> and:
> 	https://lore.kernel.org/r/066efc42-0788-8668-2ff5-d431e77068b5@roeck-us.net
> 
> Nick, if you want these merged, can you fix up the errors and resend?
> 
> Perhaps you might want to run these through the tuxbuild tool before
> sending?  You should have access to it...

Oops, wait, they are fine for 5.10.y, just 4.19 and 5.4 are broken, will
go drop those patches only.

thanks,

greg k-h
