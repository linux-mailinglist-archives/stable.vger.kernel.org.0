Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7916613ACE5
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 16:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgANPCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 10:02:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3238 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgANPCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 10:02:25 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1dd7ec0000>; Tue, 14 Jan 2020 07:02:04 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 14 Jan 2020 07:02:24 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 14 Jan 2020 07:02:24 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Jan
 2020 15:02:21 +0000
Subject: Re: [PATCH 4.14 00/39] 4.14.165-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200114094336.210038037@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <2be94042-e492-3a03-0312-fd4e2d099177@nvidia.com>
Date:   Tue, 14 Jan 2020 15:02:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579014124; bh=tv0LkxUgCLcfignFEHXetEcGBeGTxEmwTlojs3NUxOo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=GVSn9dxml0xsUQ9G0fijA7IC3EeHPnwF/qRnGShLshFVn6Dp7rNfQ/vNGhUhm/QYO
         Cv4qrQhpE2rIaNkuApEloYYxc5Tl1LRCmieGGeE2RAZxAll8OgZrw7N+gU6DWUeS0W
         DNN0lIq2ZqibwFyunMGvSTwKN2zYzJL6OAwmtA7m5xy487xV32BmOaaiaX8rTSP76a
         3ygLNt8lo7j+mGiIpmLqdH+3Alve1gh7LpmohZ2cCagwBrO8RFLBjGsGVmNaUK+BC0
         pX2Euvy1YsPi7bsoFYd7HPr48pu/aBXbNYtfTDLfZqifvWAuxN/kiNWdPApr8bbQy5
         S2MrWhjK3Y7sw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/01/2020 10:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.165 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.165-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.165-rc1-ge7b83c76590b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
