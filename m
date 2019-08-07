Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA2984C1A
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 14:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfHGMxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 08:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfHGMxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 08:53:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D089521BE3;
        Wed,  7 Aug 2019 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565182385;
        bh=y3/TCMmGeuWLU9RU7+PuunFVGK076zHVaDl8Kp8eU4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BWYuS3xxI0XQ7Mh+QBZE+7maNJirRkRjYcytJKFM6PAp2dmdwvtj2sShcwGeZ56fI
         NDFknUvl726uYDtEtIwftP1Zbjz/0y4qWoAMy4aQR2mSvOknpFRLpiczg9l7yt1Fuz
         XennZYxgQNNv+n3xdzwOCFyULKp+h5O3cVKdPf8w=
Date:   Wed, 7 Aug 2019 08:53:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     will@kernel.org, gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] [Backport for 4.4.y stable] arm64 CTR_EL0 cpufeature
 fixes
Message-ID: <20190807125303.GT17747@sasha-vm>
References: <20190805171308.19249-1-will@kernel.org>
 <20190806212904.GL17747@sasha-vm>
 <20190807094919.qzkf2jj6m4qrecsl@willie-the-truck>
 <e5628f61-5839-675b-6826-ca37d00ce24a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e5628f61-5839-675b-6826-ca37d00ce24a@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 07, 2019 at 11:59:41AM +0100, Suzuki K Poulose wrote:
>Hi Will,
>
>On 07/08/2019 10:49, Will Deacon wrote:
>>Hi Sasha, [+Suzuki]
>>
>>On Tue, Aug 06, 2019 at 05:29:04PM -0400, Sasha Levin wrote:
>>>On Mon, Aug 05, 2019 at 06:13:06PM +0100, Will Deacon wrote:
>>>>These two patches are backports for 4.4.y stable kernels after one of
>>>>them failed to apply:
>>>>
>>>>  https://lkml.kernel.org/r/156498316752100@kroah.com
>>>
>>>I took these 2, but note that they have two fixes that are not in 4.4:
>>>
>>>314d53d297980 arm64: Handle mismatched cache type
>>>4c4a39dd5fe2d arm64: Fix mismatched cache line size detection
>>>
>>>Will you send a backport for them?
>>
>>4.4 doesn't handle mismatches for the cache type or the line sizes, and
>>instead taints the kernel with a big splat at boot. If we wanted to
>>backport this, we'd need to pick up more than just the above patches, since
>>we don't have the means to emulate user cache maintenance operations either.
>>
>>Given that the vast majority of systems don't suffer from this problem,
>>I'd be inclined not to try shoe-horning all of this into 4.4, where I think
>>it's more likely introduce other issues.
>>
>>Suzuki, what do you think?
>
>I agree. It involves a lot of new code, with non-trivial backports.

Okay, makes sense. Thanks for looking into it.

--
Thanks,
Sasha
