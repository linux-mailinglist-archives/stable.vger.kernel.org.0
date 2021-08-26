Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A9A3F87F2
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhHZMuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 08:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232506AbhHZMuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 08:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EFAC610A3;
        Thu, 26 Aug 2021 12:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629982204;
        bh=duUwwLdPmidws8eA3shUOFabKdtjh/SJ19ht0aA0WxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qp2w/PNxQQrQa4qp7xduCqs0toKo0D49HTVOLyOvVIePOT5f83mJbd0hyWNy9eycX
         sFblDIV2DSarnNAgzSNR8LUfhED/X/LgJ8WjhKYgaXgsjUlX0y0BtXToUkTBJmMYM3
         YMvEoazw6gVj9q3c/5/fuCrM/BlUYSmvzU5grbdiwAPLbFocD7no/wGiih4FXcx4V4
         Kr7UX0GIfNiq/S//FYlz+2fSK1fYDbbXrXehYXWYz7436cQubIUVe0YoJujrB1ejQL
         aCsMxiPah7HwscHm3bx1Pexy3EUDzx+S7mIS9FXV/LhyI5e0B1q3g/J3VQKNEHLEhi
         8f2tr5Bo1AsVw==
Date:   Thu, 26 Aug 2021 08:50:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 000/127] 5.13.13-rc1 review
Message-ID: <YSeN+zpJgn9Nlql7@sashalap>
References: <20210824165607.709387-1-sashal@kernel.org>
 <20210825202431.GA432917@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210825202431.GA432917@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 25, 2021 at 01:24:31PM -0700, Guenter Roeck wrote:
>On Tue, Aug 24, 2021 at 12:54:00PM -0400, Sasha Levin wrote:
>>
>> This is the start of the stable review cycle for the 5.13.13 release.
>> There are 127 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu 26 Aug 2021 04:55:18 PM UTC.
>> Anything received after that time might be too late.
>>
>
>Build results:
>	total: 154 pass: 154 fail: 0
>Qemu test results:
>	total: 479 pass: 479 fail: 0
>
>Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing, Guenter!

-- 
Thanks,
Sasha
