Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B599312A6D
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 11:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfECJ1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 05:27:33 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3728 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfECJ1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 05:27:33 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ccc098a0000>; Fri, 03 May 2019 02:27:39 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 03 May 2019 02:27:32 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 03 May 2019 02:27:32 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 3 May
 2019 09:27:28 +0000
Subject: Re: [PATCH 4.9 00/32] 4.9.173-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190502143314.649935114@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a61b7072-560f-7581-26b1-eaaecfd17985@nvidia.com>
Date:   Fri, 3 May 2019 10:27:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1556875659; bh=TsN/3to71HNyMCRGIkE+1XmtpLYxmN5boqfPsLHtPHE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FupPJUjskC30CUYXuJFDBY5teUhTHyW7m8nj24ilqCwTmUiROpxCKxKiH79awQcd8
         3MWUaTAHKfWwm2Cb3SWdkpnuJ4rITDFjoFRN5xC/c7CoqzPP8C3C5UbKF4dFpbI48g
         dcJr43nWVxfUKpr18eVU8cUmwgQ1jB2JKRtqwoOsbkOMZaizUrG+mHNoEwdc16EZhh
         Tv2LfvjjangztoGNDBEja01dzUFFwI8QuribPkayM8KkE/a0nOYKISKl3dZtBtJHMh
         Ff1vq/Ceb/2i32DK3Kg8N2qESblzqaXeYNgQbBtLmH0JVQk8cKgeba/F2coBkYukwS
         epWb7kkgpKi5w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/05/2019 16:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.173 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:02 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.173-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.173-rc1-gd35bcd0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04


Cheers
Jon

-- 
nvpublic
