Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E695744F856
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 15:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbhKNOHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 09:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236075AbhKNOGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 09:06:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCE9660F41;
        Sun, 14 Nov 2021 14:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636898641;
        bh=245MT4XVirZg+94461vHVsulF9jwtDm/r94gUncM7b8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FCIIk0JJKGGxpANARLoXy7XEZIrLYtOyaIdbnMJRifN0kdTM+kIoQNMgKZ7JMNLBV
         B14FR8Pc8L9p1CjdyEVsIV5r7tHUWM//9/ZHOqXuHu8jOp5/8JTS87WbCuE2qvH6Wl
         5g4c1E/H4SYWGiMyQQgxgdDFkvbBPD6YUj3DhZq71OsqV043fDq+BcB9pAnWhR84/z
         2PAC7ypIgy7zjBc4unOXwslNG2ASHVOomaNGwnrjyuP6aP1Wz9b2cXaU8eXgoyvvu3
         Ny1KbqGJAwevRPZyq7O46XuEpX1XXcyqujY1e5oqs/L1iWTnFVyY7lwyYnDuM2rj6n
         Qvcujz3CXHAuw==
Date:   Sun, 14 Nov 2021 09:04:00 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        maz@kernel.org, Dave.Martin@arm.com, tanxiaofei@huawei.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 41/47] arm64/sve: Add stub for
 sve_max_virtualisable_vl()
Message-ID: <YZEXUO2IN5pHFnPB@sashalap>
References: <20211108175031.1190422-1-sashal@kernel.org>
 <20211108175031.1190422-41-sashal@kernel.org>
 <YYp1rOZMQaVmwo4x@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YYp1rOZMQaVmwo4x@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 01:20:44PM +0000, Catalin Marinas wrote:
>On Mon, Nov 08, 2021 at 12:50:25PM -0500, Sasha Levin wrote:
>> From: Mark Brown <broonie@kernel.org>
>>
>> [ Upstream commit 49ed920408f85fb143020cf7d95612b6b12a84a2 ]
>>
>> Fixes build problems for configurations with KVM enabled but SVE disabled.
>>
>> Reported-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> Link: https://lore.kernel.org/r/20211022141635.2360415-2-broonie@kernel.org
>> Signed-off-by: Will Deacon <will@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/arm64/include/asm/fpsimd.h | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
>> index dd1ad3950ef5d..5bd799ea683b4 100644
>> --- a/arch/arm64/include/asm/fpsimd.h
>> +++ b/arch/arm64/include/asm/fpsimd.h
>> @@ -130,6 +130,11 @@ static inline void fpsimd_release_task(struct task_struct *task) { }
>>  static inline void sve_sync_to_fpsimd(struct task_struct *task) { }
>>  static inline void sve_sync_from_fpsimd_zeropad(struct task_struct *task) { }
>>
>> +static inline int sve_max_virtualisable_vl(void)
>> +{
>> +	return 0;
>> +}
>
>IIRC this fix was only needed for 5.16-rc1.

I'll drop it, thanks!

-- 
Thanks,
Sasha
