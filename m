Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A23F76CBB2
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 11:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfGRJTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 05:19:46 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6107 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfGRJTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 05:19:46 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3039af0001>; Thu, 18 Jul 2019 02:19:43 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 18 Jul 2019 02:19:45 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 18 Jul 2019 02:19:45 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 18 Jul
 2019 09:19:43 +0000
Subject: Re: [PATCH 4.4 00/40] 4.4.186-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190718030039.676518610@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <056947a6-ad2d-1b91-4e58-f01368edd12e@nvidia.com>
Date:   Thu, 18 Jul 2019 10:19:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563441583; bh=8vQnuAkXDb9yFtGqMzdBRi60XMQ5F1XsxU4P5JiO29Q=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=EwzDdDuEww6SiN9t61CaDnhkRXAVRWmgu60iMFVBMi4BDHMVf2DjjaRhMth7bn8+G
         qVBIQT79+zdSEiJddkADRJCc6zTLUgDXS1PJXd8l/WDZjknra4npAgOsIP2SckThLy
         vNOy3BUQawr5+ukzVnkOy+7vO6b3hYyL4rdf6dCx7AJI4EGqsTCyZy2sTlCccb2/na
         njO+8QgzbbNQ1pHhaJBvrBhipLDV83puiXpFHuRcz25K/WjwLfDvH7Boqyysbsf2Lj
         R0b0IFHjOwvFtiZbfWNm1GCk+rm5aUJ4JQa9dTDpd0s7oWSF808SyRZMqFnHiqQ3g/
         pQByH4COWex7A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/07/2019 04:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.186 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.186-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.186-rc1-gf046b75a1ffd
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
