Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A957F29E700
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 10:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbgJ2JNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 05:13:07 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4209 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2JNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 05:13:05 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9a87a40000>; Thu, 29 Oct 2020 02:13:08 -0700
Received: from [10.26.45.122] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 29 Oct
 2020 09:13:03 +0000
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>
References: <20201027135450.497324313@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <412e3347-96bc-a0c4-06d2-27735bc5a992@nvidia.com>
Date:   Thu, 29 Oct 2020 09:13:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603962788; bh=OY+v61YxfXX+KbtiV6hksobk5HcEPN5SpwUfCMUkOmc=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=oNrhZCKRTS+Yrf+om7N0g5R7kGQHJ9HlwAAaBxnTQgwmVmkILpbECheqFOCg98jeo
         VAgd8bmSoidfjj+FDXXGMgjOjpo97oDPlDR+yEGsFQ1ainebRIHVowGAlZ3zoA2TGF
         9fq0yI/BYCDiVuukDz01+haNzC2n++AZ3omX9M0tAM1W4TtbkMgT6WiwYfd6xas9/J
         lV1V12G8wOk26L0jYx6QAtkBAnC2k4h8UVKtwTK+X/yjMieD/g/CwPyJhmtwR4SvMF
         lVBeyWxDgkg/dwsU57En9GNGPUw3hkPebf9Lnu7EEnV5XZDMM9y/E4By18dja993V3
         VTrLQoT38njDw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/10/2020 13:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.2 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Oct 2020 13:52:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

One known/expected failure, but all other tests passing for Tegra ...

Test results for stable-v5.9:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    61 tests:	60 pass, 1 fail

Linux version:	5.9.2-rc1-ge0fc09529493
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

The above failure is fixed in the mainline by the following commit ...

commit 97148d0ae5303bcc18fcd1c9b968a9485292f32a
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Oct 13 10:42:47 2020 +0530

    cpufreq: Improve code around unlisted freq check


Let me know if we can pull into linux-5.9.y.

Cheers!
Jon

-- 
nvpublic
