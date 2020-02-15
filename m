Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1CB16006F
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 21:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgBOUWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Feb 2020 15:22:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgBOUWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Feb 2020 15:22:09 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E823207FF;
        Sat, 15 Feb 2020 20:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581798129;
        bh=X9z+M6RBVGLaLQJqU0GzAqWo15nR6ul72uM2PPlhBGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B7m1Jq1zmCHBsL8vIHnCnRCE6LozQRZlDhIuvEFRSdYisfngPrKpoyQ4xRUGAGnhB
         tOcInL79hqd71yHcLRs+v3TLGgP9+uTK23s0UqIftVa9xh31BBY9N1QBsW871cfngE
         aliHdlIHNN+34Cd7HUR3XzRp6U6YqWuwwxG6+nbs=
Date:   Sat, 15 Feb 2020 15:22:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        catalin.marinas@arm.com, mark.rutland@arm.com, maz@kernel.org,
        will@kernel.org, ard.biesheuvel@linaro.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [stable 4.19 PATCH 1/2] arm64: cpufeature: Set the FP/SIMD
 compat HWCAP bits properly
Message-ID: <20200215202208.GH1734@sasha-vm>
References: <20200214165734.1999618-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200214165734.1999618-1-suzuki.poulose@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 04:57:33PM +0000, Suzuki K Poulose wrote:
>commit 7ef1ab8792c50797c6c5c7c5150a02460 upstream
>
>We set the compat_elf_hwcap bits unconditionally on arm64 to
>include the VFP and NEON support. However, the FP/SIMD unit
>is optional on Arm v8 and thus could be missing. We already
>handle this properly in the kernel, but still advertise to
>the COMPAT applications that the VFP is available. Fix this
>to make sure we only advertise when we really have them.
>
>Cc: stable@vger.kernel.org # v4.19
>Cc: Will Deacon <will@kernel.org>
>Cc: Mark Rutland <mark.rutland@arm.com>
>Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
>Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Queued both up for 4.19, thank you.

-- 
Thanks,
Sasha
