Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF3884A3B
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 12:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfHGK7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 06:59:43 -0400
Received: from foss.arm.com ([217.140.110.172]:46646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfHGK7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 06:59:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB4DD28;
        Wed,  7 Aug 2019 03:59:42 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CF883F575;
        Wed,  7 Aug 2019 03:59:42 -0700 (PDT)
Subject: Re: [PATCH 0/2] [Backport for 4.4.y stable] arm64 CTR_EL0 cpufeature
 fixes
To:     will@kernel.org, sashal@kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
References: <20190805171308.19249-1-will@kernel.org>
 <20190806212904.GL17747@sasha-vm>
 <20190807094919.qzkf2jj6m4qrecsl@willie-the-truck>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <e5628f61-5839-675b-6826-ca37d00ce24a@arm.com>
Date:   Wed, 7 Aug 2019 11:59:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807094919.qzkf2jj6m4qrecsl@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Will,

On 07/08/2019 10:49, Will Deacon wrote:
> Hi Sasha, [+Suzuki]
> 
> On Tue, Aug 06, 2019 at 05:29:04PM -0400, Sasha Levin wrote:
>> On Mon, Aug 05, 2019 at 06:13:06PM +0100, Will Deacon wrote:
>>> These two patches are backports for 4.4.y stable kernels after one of
>>> them failed to apply:
>>>
>>>   https://lkml.kernel.org/r/156498316752100@kroah.com
>>
>> I took these 2, but note that they have two fixes that are not in 4.4:
>>
>> 314d53d297980 arm64: Handle mismatched cache type
>> 4c4a39dd5fe2d arm64: Fix mismatched cache line size detection
>>
>> Will you send a backport for them?
> 
> 4.4 doesn't handle mismatches for the cache type or the line sizes, and
> instead taints the kernel with a big splat at boot. If we wanted to
> backport this, we'd need to pick up more than just the above patches, since
> we don't have the means to emulate user cache maintenance operations either.
> 
> Given that the vast majority of systems don't suffer from this problem,
> I'd be inclined not to try shoe-horning all of this into 4.4, where I think
> it's more likely introduce other issues.
> 
> Suzuki, what do you think?

I agree. It involves a lot of new code, with non-trivial backports.

Cheers
Suzuki
