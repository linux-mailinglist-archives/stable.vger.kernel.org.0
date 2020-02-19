Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F421642ED
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 12:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgBSLGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 06:06:05 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19227 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgBSLGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 06:06:05 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4d167c0001>; Wed, 19 Feb 2020 03:05:32 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 19 Feb 2020 03:06:04 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 19 Feb 2020 03:06:04 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Feb
 2020 11:06:02 +0000
Subject: Re: [PATCH 4.19 00/38] 4.19.105-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200218190418.536430858@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <21d5fe3f-9b2c-571c-a8a5-8d8966e18764@nvidia.com>
Date:   Wed, 19 Feb 2020 11:06:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218190418.536430858@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582110332; bh=veBQv0eIF+eTVEhBgYOt5fZwCdL4s1eqcxE9Ee6DHTo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Sj7O0l1s/veTxVWxuCvA4GQ+fnCweXcNX5rw5+uwd6DrlVMuy5GhPcY7XXGpIiJkI
         +dFKcvDVTkma9frrA2Y9ThDy4apcqFQQYZxUn/9+mK4Eu0mXLag9RbiZDR7eFRSBo9
         Rj1NTZxDB4vX7nB5En0wXfet05kPOeIu6sVaGbMX0TzWigdmGNrXMSaWskPlXiErd1
         Ykhbv9h2jOm3LbD09fbklkN3WEUewQXV6KmnJ5xnGiDHkxZOye3fZoyemDW6A1s0qv
         XVTJDvSHY+MEuGEbBkYznxDTEB2pEjuabTZ2BpeiNFuX4IT4syKcCmpF1LejCH/h+V
         iyAV4L8doKrzg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/02/2020 19:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.105 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.105-rc1-g85265e81d664
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
