Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28C63BE7F4
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhGGMbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231485AbhGGMbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56DA661C82;
        Wed,  7 Jul 2021 12:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625660944;
        bh=AVX+rEUnrv1MDS1STDcpXkpONelEfZVX6KwPNWxJNzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L6dsKZ35lQa1NCzipruXF3dcgZtDJZW9l8bAWBUGTvPRia7Mwi3CpgnMHWf5V9gKK
         6mTJ+OrJm6KSdR6xrj9lH6lNPFPSQq5a++kwIXBYRHt8y+1u0GmsSgxTI/PeoKwg5J
         Azr3/1yfBmepexH/p6o+UtsSiFRdL/QK4XZWEzaYo8OlOczbeI+2/w/6eudpNRMh2d
         kW58U/HNpHqX9vqKcUfOLLvywvX1bSp1S4I2vq7bN2aobHuWPsXlWZZQrHKtDHShor
         ZUrb+i2C+qhNMXcvz9kGAJG+tMVen+MBDvFABDBINlYwP6zpO9giMPMG8BA+j79jkT
         ssgNJQhZLP+Pw==
Date:   Wed, 7 Jul 2021 08:29:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 0/7] 5.10.48-rc1 review
Message-ID: <YOWeD1UsnhN8a1jw@sashalap>
References: <20210705105957.1513284-1-sashal@kernel.org>
 <bcd71d67-82ae-7406-c88a-790e01b50268@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bcd71d67-82ae-7406-c88a-790e01b50268@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 06, 2021 at 10:01:43AM +0800, Samuel Zou wrote:
>
>
>On 2021/7/5 18:59, Sasha Levin wrote:
>>
>>This is the start of the stable review cycle for the 5.10.48 release.
>>There are 7 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Wed 07 Jul 2021 10:59:49 AM UTC.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.47
>>or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>and the diffstat can be found below.
>>
>>Thanks,
>>Sasha
>>
>
>Tested on arm64 and x86 for 5.10.48-rc1,
>
>Kernel repo:
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>Branch: linux-5.10.y
>Version: 5.10.48-rc1
>Commit: dd50b7327ff62c603651aef64089569dd293b34d
>Compiler: gcc version 7.3.0 (GCC)
>
>arm64:
>--------------------------------------------------------------------
>Testcase Result Summary:
>total: 8906
>passed: 8906
>failed: 0
>timeout: 0
>--------------------------------------------------------------------
>
>x86:
>--------------------------------------------------------------------
>Testcase Result Summary:
>total: 8906
>passed: 8906
>failed: 0
>timeout: 0
>--------------------------------------------------------------------
>
>Tested-by: Hulk Robot <hulkrobot@huawei.com>

Thanks for testing Samuel!

-- 
Thanks,
Sasha
