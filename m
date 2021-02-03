Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9016630DACB
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhBCNPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:15:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhBCNPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 08:15:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5BBC64F9A;
        Wed,  3 Feb 2021 13:15:05 +0000 (UTC)
Date:   Wed, 3 Feb 2021 13:15:03 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     gregkh@linuxfoundation.org
Cc:     vincenzo.frascino@arm.com, mark.rutland@arm.com,
        stable@vger.kernel.org, will@kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: Fix kernel address detection of
 __is_lm_address()" failed to apply to 5.4-stable tree
Message-ID: <20210203131501.GB10424@gaia>
References: <1612104058247187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612104058247187@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sun, Jan 31, 2021 at 03:40:58PM +0100, Greg Kroah-Hartman wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 519ea6f1c82fcdc9842908155ae379de47818778 Mon Sep 17 00:00:00 2001
> From: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Date: Tue, 26 Jan 2021 13:40:56 +0000
> Subject: [PATCH] arm64: Fix kernel address detection of __is_lm_address()
> 
> Currently, the __is_lm_address() check just masks out the top 12 bits
> of the address, but if they are 0, it still yields a true result.
> This has as a side effect that virt_addr_valid() returns true even for
> invalid virtual addresses (e.g. 0x0).
> 
> Fix the detection checking that it's actually a kernel address starting
> at PAGE_OFFSET.
> 
> Fixes: 68dd8ef32162 ("arm64: memory: Fix virt_addr_valid() using __is_lm_address()")
> Cc: <stable@vger.kernel.org> # 5.4.x
> Cc: Will Deacon <will@kernel.org>
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Link: https://lore.kernel.org/r/20210126134056.45747-1-vincenzo.frascino@arm.com
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

I sent you the 5.4 and 5.10 backports of this patch. There is another
fix in this area which I'll send to Linus tonight. It should apply
cleanly on 5.4 and 5.10.

Thanks.

-- 
Catalin
