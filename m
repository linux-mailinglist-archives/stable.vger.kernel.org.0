Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2CF4B366
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 09:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfFSHxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 03:53:06 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:30492 "EHLO smtp3-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfFSHxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 03:53:06 -0400
Received: from anisse-station (unknown [213.36.7.13])
        by smtp3-g21.free.fr (Postfix) with ESMTPS id 6C1DA13F8CD;
        Wed, 19 Jun 2019 09:52:57 +0200 (CEST)
Date:   Wed, 19 Jun 2019 09:52:56 +0200
From:   Anisse Astier <aastier@freebox.fr>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] arm64: ssbd: explicitly depend on <linux/prctl.h>
Message-ID: <20190619075256.GA27057@anisse-station>
References: <20190617132222.32182-1-aastier@freebox.fr>
 <20190618173036.5DC0D2084D@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618173036.5DC0D2084D@mail.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,
On Tue, Jun 18, 2019 at 05:30:35PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 9cdc0108baa8 arm64: ssbd: Add prctl interface for per-thread mitigation.
> 
> The bot has tested the following trees: v5.1.10, v4.19.51, v4.14.126, v4.9.181.
> 
> v5.1.10: Build OK!
> v4.19.51: Build OK!
> v4.14.126: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.9.181: Failed to apply! Possible dependencies:
>     Unable to calculate

I just looked at the 4.14 and 4.9 branches, and their backport of ssbd
already includes this patch, so that's OK.

Regards,

Anisse
