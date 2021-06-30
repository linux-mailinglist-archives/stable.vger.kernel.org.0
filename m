Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A973A3B82A2
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 15:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhF3NID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 09:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234790AbhF3NIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 09:08:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C4C61455;
        Wed, 30 Jun 2021 13:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625058333;
        bh=TMFdQw4PME/r/zLGH4gKHa8lKrUKP8Eihr/D1qlyhEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lNV8wa3g4UGArm5bcX0twmdq46kNiPV9/goMj+oXgeoBqIsrmQC2jtAVNAVAokqJp
         J/BLiPsdN7VxUev1nLH3kCILwAS+g8vlRfdx1ssE3Y4Y4kxIG567zZdjmHeiA+Ttso
         t3poUsRLNYX4yWvPwHDAaSJnJ0fGOmYAnuh5ki3qYs4dtBx9JmXPNpAdr+elLSUfy3
         JjYLpf9JR0JnD+lcs/NlAWVsttXBKq0nkQzpT53Rhx11qi7/fmsf86rtA1Ec30P28O
         fPhJqQzrHwLGmyW9xPabj2xqMqXw8RVMy8Pf6Ufa1t+WHDCzwJoBnm1ICBJxN/vA8L
         N/1v8DF6ICIPA==
Date:   Wed, 30 Jun 2021 09:05:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 000/101] 5.10.47-rc1 review
Message-ID: <YNxsHGa+X8SpYpOv@sashalap>
References: <20210628142607.32218-1-sashal@kernel.org>
 <d365efba-fb1a-bff1-f5c8-ee70cf53d821@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d365efba-fb1a-bff1-f5c8-ee70cf53d821@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 09:01:21AM +0800, Samuel Zou wrote:
>
>
>On 2021/6/28 22:24, Sasha Levin wrote:
>>
>>This is the start of the stable review cycle for the 5.10.47 release.
>>There are 101 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Wed 30 Jun 2021 02:25:36 PM UTC.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.46
>>or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>and the diffstat can be found below.
>>
>>Thanks,
>>Sasha
>>
>
>Tested on arm64 and x86 for 5.10.47-rc1,

Thanks for testing Samuel!

-- 
Thanks,
Sasha
