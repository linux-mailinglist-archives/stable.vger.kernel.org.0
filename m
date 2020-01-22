Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597D1145852
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAVO6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:58:38 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3493 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVO6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:58:38 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2862f10001>; Wed, 22 Jan 2020 06:57:53 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 22 Jan 2020 06:58:37 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 22 Jan 2020 06:58:37 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 22 Jan
 2020 14:58:35 +0000
Subject: Re: [PATCH 5.4 000/222] 5.4.14-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200122092833.339495161@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <012c6d63-a4cb-ead4-1a7e-d5727426200d@nvidia.com>
Date:   Wed, 22 Jan 2020 14:58:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579705073; bh=OQ8LXrf2HTEljq3vStYXQ33Dbpof3iyuQCCEY8Thc/Q=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=lTtsfYkDS+AZqJEakMl+fDkNp3K3BjUJ3+bM1UHh9tuJN9Z21bEjyg7XOvziNBBVm
         bFOdtmDvooeyE4n7wTYgTmB2tROOTeu9+W3mlYW1NjxjVFyWaGIWnFQ4Nm4fPuqKoj
         9mohKzZrCypI4/JJ1MmK+5z4W4omrUGY21hjPZspxgTCizzSRxMT51h1WtswQ3oqtU
         2U50B/aFiNtqtYMUCIsMMhP+5/K6J6Bc4ZR0YpvglqkyrLY8UFLxLwZ3rsAc8/XGSc
         N2kHDIPyP4LY999UBOLKksP3mUl0D1quHbK+cbb96IB8xQyeJZNW/65XzhpNSEbdbA
         gbuISJkln50jA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/01/2020 09:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.14 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.4.14-rc1-g8045d34c9af0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
