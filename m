Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0D344AEA3
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 14:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhKINXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 08:23:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhKINXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 08:23:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E9C961130;
        Tue,  9 Nov 2021 13:20:47 +0000 (UTC)
Date:   Tue, 9 Nov 2021 13:20:44 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        maz@kernel.org, Dave.Martin@arm.com, tanxiaofei@huawei.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 41/47] arm64/sve: Add stub for
 sve_max_virtualisable_vl()
Message-ID: <YYp1rOZMQaVmwo4x@arm.com>
References: <20211108175031.1190422-1-sashal@kernel.org>
 <20211108175031.1190422-41-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108175031.1190422-41-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 08, 2021 at 12:50:25PM -0500, Sasha Levin wrote:
> From: Mark Brown <broonie@kernel.org>
> 
> [ Upstream commit 49ed920408f85fb143020cf7d95612b6b12a84a2 ]
> 
> Fixes build problems for configurations with KVM enabled but SVE disabled.
> 
> Reported-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Link: https://lore.kernel.org/r/20211022141635.2360415-2-broonie@kernel.org
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index dd1ad3950ef5d..5bd799ea683b4 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -130,6 +130,11 @@ static inline void fpsimd_release_task(struct task_struct *task) { }
>  static inline void sve_sync_to_fpsimd(struct task_struct *task) { }
>  static inline void sve_sync_from_fpsimd_zeropad(struct task_struct *task) { }
>  
> +static inline int sve_max_virtualisable_vl(void)
> +{
> +	return 0;
> +}

IIRC this fix was only needed for 5.16-rc1.

-- 
Catalin
