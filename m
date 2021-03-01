Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92819327F18
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbhCANMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235427AbhCANMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 08:12:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D035064DF2;
        Mon,  1 Mar 2021 13:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614604289;
        bh=H6Z35dAcXsoeG9gQvnedSzVQ+OyK5V92zq1QHoi5gBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JHUFawdi83atEuXtHbLE2TdoD3SFtOGJmTzRjG9RtiNCIYhKEYgWM9cdC+myTH7D/
         m3YdvcDAjvrGvq2i21iMGS9dDU6x0jjqNxgq3eu30kMy9fczUoz4/wGD9wtK+luQpq
         Et9pMD03w3zx+mit7+rSzVBcYn3fXAP+PvT6ucYs=
Date:   Mon, 1 Mar 2021 14:11:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH v2] arm64: Extend workaround for erratum 1024718 to all
 versions of Cortex-A55
Message-ID: <YDzn/uWxuxt094qz@kroah.com>
References: <20210301125459.3046861-1-suzuki.poulose@arm.com>
 <20210301125815.3047065-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301125815.3047065-1-suzuki.poulose@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 12:58:15PM +0000, Suzuki K Poulose wrote:
> commit c0b15c25d25171db4b70cc0b7dbc1130ee94017d upstream
> 
> The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
> we apply the work around for r0p0 - r1p0. Unfortunately this
> won't be fixed for the future revisions for the CPU. Thus
> extend the work around for all versions of A55, to cover
> for r2p0 and any future revisions.
> 
> Cc: stable@vger.kernel.org # v5.4-
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Link: https://lore.kernel.org/r/20210203230057.3961239-1-suzuki.poulose@arm.com
> [will: Update Kconfig help text]
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes in v2:
>  - Match the Kconfig text to the original commit
>    "versions" => "revisions"
> 
>  arch/arm64/Kconfig             | 2 +-
>  arch/arm64/kernel/cpufeature.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied to 5.4.y and 4.19.y, if it needs to go anywhere older, please
provide working backports.

thanks,

greg k-h
