Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82BD3EE178
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 14:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfKDNps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 08:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbfKDNps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 08:45:48 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2984720B7C;
        Mon,  4 Nov 2019 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572875148;
        bh=+cR4+pKLBo+3KbffLEFCwUeze/RvVvwXCm24OsIZ6D8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o5qj76gslfefsMovvc6NFDuFDjUfpvSQFCfKDX+u8kMk8M6NR6E2XdhmnObwCkrxx
         +fo9fTFESMiN5IZ9jFERteBN+T8aKeGSTr3xkixgUss8YV9TNja0LJH5o5qgLA8ZHl
         HLCrCrE/m/zfPNmLIF78lZVxgGk+IDbS/5MjqAfw=
Date:   Mon, 4 Nov 2019 14:45:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hanjun Guo <guohanjun@huawei.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 4.19.82-rc1] arm64: Add MIDR encoding for HiSilicon
 Taishan CPUs
Message-ID: <20191104134544.GA2133784@kroah.com>
References: <1572874116-10831-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572874116-10831-1-git-send-email-guohanjun@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 09:28:36PM +0800, Hanjun Guo wrote:
> From: Hanjun Guo <hanjun.guo@linaro.org>
> 
> [ Upstream commit efd00c722ca855745fcc35a7e6675b5a782a3fc8 ]
> 
> Adding the MIDR encodings for HiSilicon Taishan v110 CPUs,
> which is used in Kunpeng ARM64 server SoCs. TSV110 is the
> abbreviation of Taishan v110.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Reviewed-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Zhangshaokun <zhangshaokun@hisilicon.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
> ---
>  arch/arm64/include/asm/cputype.h | 4 ++++
>  1 file changed, 4 insertions(+)

Thanks for this, now queued up.

greg k-h
