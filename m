Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1068D2FC2C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 15:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfE3NWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 09:22:21 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1446 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfE3NWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 09:22:21 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cefd90c0000>; Thu, 30 May 2019 06:22:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 30 May 2019 06:22:20 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 30 May 2019 06:22:20 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 30 May
 2019 13:22:17 +0000
Subject: Re: [PATCH 4.19 000/276] 4.19.47-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190530030523.133519668@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <29651ae8-d4a3-9fe4-fc03-2b2dce270e83@nvidia.com>
Date:   Thu, 30 May 2019 14:22:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1559222540; bh=s5Lo+abx3qK93VxXWpaqCdyfarU1tk/Yx1B3b6kHXNA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ebBGfQqcbaghZQP5gn+eV+EOtYBLJWXvYLL48FMHb+3OOYdW4+auiIXA13PDDcutW
         w7G+vLtlgegFLNz5pXuDUfF3mISeXNszqagycuhFepvQNSXl0LKwbUiVxmdaNlOF3w
         fNUPkDNlDO9oflyVc5naqOX8Im/L/l+jtH1eeYhyFmq89HmxKS2xrq4T4nuhBjsx6W
         IQsSFRJtmGVofK7Ai/1IGaPNdrxZtysQJ/j+xf99hZAdWIuTRrBI+2NZ7fyhtnZ4Dm
         2BNEhn2nPofXnkK8Q37JIyfRnGdm2in2azqx9+iOI8PyEukyyCpIy+PVLmGm6vevzH
         Jly2i8ULJ4Hyg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/05/2019 04:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.47 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:08 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.47-rc1-gce4f69c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
