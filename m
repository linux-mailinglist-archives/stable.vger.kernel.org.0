Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C304E33F124
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 14:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCQN0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 09:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhCQN0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 09:26:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C00AC64F3E;
        Wed, 17 Mar 2021 13:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615987580;
        bh=ME7BhSXOHtq+KFItvuBDzw/06TwjX48RmA8IGS+Pmpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jQINgZJ0O5A0+z8IJCaceV6Yz1QwDwecLPFJa626PfMR1VAwnp6oVXBWUZEHbms2+
         8MwYjpTb9vm13ALnLiptlUm8toW2EhTT9ZLo+3in4SFycxYjUDIsIe38uu9+CSFxQ+
         A/fBXL/xwifzcaasY2ivAHXYBm5pg0fWEK3Mbnbyk/7OXyUg0GN9oRhZhVzYKAgNef
         dyRSLHJlpq4PFkp2mp99kBUCZCaZOpJ/sYJmBdpXdkuXOObNpQiK9pGtyLPj9ul+1J
         D6PZBpSV82I+P8PkSlQlGmFXDwCcOrJ6l1opENBBhE5VSGZUoMHEVsNfLhjrPPaxUY
         2ua3uPCVAg3AA==
Date:   Wed, 17 Mar 2021 13:26:15 +0000
From:   Will Deacon <will@kernel.org>
To:     Vladimir Murzin <vladimir.murzin@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, maz@kernel.org, dbrazdil@google.com
Subject: Re: [PATCH v2][for-stable-v5.11] arm64: Unconditionally set virtual
 cpu id registers
Message-ID: <20210317132614.GB5225@willie-the-truck>
References: <20210316134319.89472-1-vladimir.murzin@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316134319.89472-1-vladimir.murzin@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 01:43:19PM +0000, Vladimir Murzin wrote:
> Commit 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
> reorganized el2 setup in such way that virtual cpu id registers set
> only in nVHE, yet they used (and need) to be set irrespective VHE
> support.
> 
> Fixes: 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
> Changelog
> 
>   v1 -> v2
>      - Drop the reference to 32bit guests from commit message (per Marc)
> 
> There is no upstream fix since issue went away due to code there has
> been reworked in 5.12: nVHE comes first, so virtual cpu id register
> are always set.
> 
> Maintainers, please, Ack.
> 
>  arch/arm64/include/asm/el2_setup.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

It's a bit weird to have a patch in stable that isn't upstream, but I don't
see a better option here.

Will
