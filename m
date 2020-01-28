Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65AC114B0AA
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 09:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgA1IIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 03:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgA1IIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 03:08:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8491B2467B;
        Tue, 28 Jan 2020 08:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580198892;
        bh=IQrFgVNc1B4IPrCk+m5OMuVQaRx7YDEOKWXm/35raU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vYH7VZGGdsNcxxeXIwG/T0w6wSXO+zCOqd3sXgjHrITJtLPbzkvzU18Cgd5lUMCrB
         2ywUksWgU8qOAQf4Fr3Yxb8m8i+6LNiwY8h0vw3xMFW+iFf1azI39YeaKrYI5eRtq3
         EANie1McZ1qXHhIfInh60M9AkRMAENjUtnIJFTJ0=
Date:   Tue, 28 Jan 2020 09:08:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, will@kernel.org,
        stable@vger.kernel.org, sashal@kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH stable 4.9] arm64: kpti: Whitelist Cortex-A CPUs that
 don't implement the CSV3 field
Message-ID: <20200128080807.GJ2105706@kroah.com>
References: <20200124200820.18272-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124200820.18272-1-f.fainelli@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 12:08:20PM -0800, Florian Fainelli wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> commit 2a355ec25729053bb9a1a89b6c1d1cdd6c3b3fb1 upstream.
> 
> While the CSV3 field of the ID_AA64_PFR0 CPU ID register can be checked
> to see if a CPU is susceptible to Meltdown and therefore requires kpti
> to be enabled, existing CPUs do not implement this field.
> 
> We therefore whitelist all unaffected Cortex-A CPUs that do not implement
> the CSV3 field.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> [florian: adjust whilelist location and table to stable-4.9.y]
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for the backport, now applied.

greg k-h
