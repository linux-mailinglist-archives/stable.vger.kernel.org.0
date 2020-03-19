Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B598718BFA9
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 19:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCSSwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 14:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSSwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 14:52:21 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 132C92070A;
        Thu, 19 Mar 2020 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584643941;
        bh=m+shdL7C7EaM3QtPm8TsyLH2ZhlRHrypClgBpyQGT48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HHGlocEeaJaJXF2JjGzFzJqrg1ksv0lrzQ0/Vu+MFhg3roqKb9vpUmJn3+LshqLnA
         TBGeYPYjvNWZDnktdr9genFx9zC6PfegcStAynai0o154Sx8gMVJqvYvciCUL6lxYu
         +7wpTB9QVeieoB+2vnsLbmKArqykYvBvc6plJ1WM=
Date:   Thu, 19 Mar 2020 18:52:16 +0000
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64: compat: Fix syscall number of compat_clock_getres
Message-ID: <20200319185216.GD27141@willie-the-truck>
References: <20200319141138.19343-1-vincenzo.frascino@arm.com>
 <20200319181203.GB29214@mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319181203.GB29214@mbp>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 06:12:03PM +0000, Catalin Marinas wrote:
> On Thu, Mar 19, 2020 at 02:11:38PM +0000, Vincenzo Frascino wrote:
> > The syscall number of compat_clock_getres was erroneously set to 247
> > instead of 264. This causes the vDSO fallback of clock_getres to land
> > on the wrong syscall.
> > 
> > Address the issue fixing the syscall number of compat_clock_getres.
> > 
> > Fixes: 53c489e1dfeb6 ("arm64: compat: Add missing syscall numbers")
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> 
> Will left ARM about 8 months ago IIRC ;).

Haha, well I certainly tried to!

> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> I think Will could take this as a fix.

For sure, I'm queuing it now.

Will
