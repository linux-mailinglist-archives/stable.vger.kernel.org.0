Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA173F8826
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242564AbhHZMzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 08:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:32900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242545AbhHZMzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 08:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F85E60184;
        Thu, 26 Aug 2021 12:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629982462;
        bh=k3yUZFwCFyZOzlCE6LhVinBYxVjpn929Tmh+UOgbFsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YuNFuy5VTSi2HYzeApUAxmj3W1tmFp4RKM06bnUi29ODD/mHw5W5d1BUb2GbITFEP
         LBq3533EDX/I+f6CPChlrj5e2zLUpD/jdP+K9PAcPna1qqE7Pzm7mRePAXCP0F/l3Z
         P+C3Y0j6+cJjHKQX3zYb4XubUpX4P+McblWJPPVVWjL6jRCyzu6jIL7sjUSz8N7rzn
         LHnjNaKDgje806ui4Z3q7BVx1EfFRhtCmwOadKFKrjKF2szhRimdLkLFSYGYvNOIQ/
         i/fzjyTFsZNFkyfomDyQluzR3nyEYaE2tdpBNmn9GQVyaJQ627ZUFLtE3ix+zYPTsf
         Idw4cslm/O3Sg==
Date:   Thu, 26 Aug 2021 08:54:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.61-rc1 review
Message-ID: <YSeO/Z+dgqiYb7j9@sashalap>
References: <20210824165908.709932-1-sashal@kernel.org>
 <b42d193e-2916-6280-b9ba-b6582887f521@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b42d193e-2916-6280-b9ba-b6582887f521@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 26, 2021 at 09:00:20AM +0800, Samuel Zou wrote:
>
>
>On 2021/8/25 0:57, Sasha Levin wrote:
>>
>>This is the start of the stable review cycle for the 5.10.61 release.
>>There are 98 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Thu 26 Aug 2021 04:58:25 PM UTC.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.60
>>or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>and the diffstat can be found below.
>>
>>Thanks,
>>Sasha
>>
>
>Tested on arm64 and x86 for 5.10.61-rc1,
>
>Kernel repo:
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>Branch: linux-5.10.y
>Version: 5.10.61-rc1
>Commit: bd3eb40a9de703ab9ab65f9c583e40d185d6aaad
>Compiler: gcc version 7.3.0 (GCC)
>
>arm64:
>--------------------------------------------------------------------
>Testcase Result Summary:
>total: 8907
>passed: 8907
>failed: 0
>timeout: 0
>--------------------------------------------------------------------
>
>x86:
>--------------------------------------------------------------------
>Testcase Result Summary:
>total: 8907
>passed: 8907
>failed: 0
>timeout: 0
>--------------------------------------------------------------------
>
>Tested-by: Hulk Robot <hulkrobot@huawei.com>

Thanks for testing, Samuel!

-- 
Thanks,
Sasha
