Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1243519BB
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbhDAR4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 13:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235314AbhDARw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 13:52:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 780AF613C4;
        Thu,  1 Apr 2021 17:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617297419;
        bh=swYfLc02czOOQji1C1NYFySSeQ1rafHjYeJ2v1xmMzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t7x1UjjAPmJuN+LcPYfDtyt7O7nobi9PsnI85xbQ8zTD25iZYeH6rmO8ilz/0+PH9
         emFuExPWd7eX4lvc6VwovysJvKurVR4lfJlXz57vRskSbVlep4YKO/BeXs/jj7YLrh
         6amNFPOjapzTThltgM+Fkth20o34huc+OAzZuUnUEM6+vKADD/CesfQqy5WAAicej6
         9XFnjnUHytJYeq8P+jecXBEKIyVg/A9mjgyLvaP8CsjJymumwxPQzdduKMh48C6PkJ
         geMs033K/K0Ljx76gLBWX4NVwQVUiByK3OAmrzak4Yf0t6MJDKWR5vRS9MCraxXT1w
         N+7UzCR6lQZsg==
Date:   Thu, 1 Apr 2021 18:16:55 +0100
From:   Will Deacon <will@kernel.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm: fix inline asm in load_unaligned_zeropad()
Message-ID: <20210401171655.GD9447@willie-the-truck>
References: <20210401165543.3957816-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401165543.3957816-1-pcc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 01, 2021 at 09:55:43AM -0700, Peter Collingbourne wrote:
> The inline asm's addr operand is marked as input-only, however in
> the case where an exception is taken it may be modified by the BIC
> instruction on the exception path. Fix the problem by using a temporary
> register as the destination register for the BIC instruction.
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: stable@vger.kernel.org
> Link: https://linux-review.googlesource.com/id/I0f9ad1682821f874fb9b47e1279721943b2e5325
> ---
>  arch/arm/include/asm/word-at-a-time.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Please can you put this into Russell's patch system?

Thanks,

Will
