Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29CCC1347C3
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 17:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgAHQXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 11:23:43 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9578 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgAHQXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 11:23:43 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1601dd0000>; Wed, 08 Jan 2020 08:22:53 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 08 Jan 2020 08:23:42 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 08 Jan 2020 08:23:42 -0800
Received: from [10.26.11.166] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 8 Jan
 2020 16:23:39 +0000
Subject: Re: [PATCH 4.19 000/115] 4.19.94-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200107205240.283674026@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <95416c7c-a9ce-39c7-33a7-e0f36dcbefaf@nvidia.com>
Date:   Wed, 8 Jan 2020 16:23:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578500573; bh=Xt7WMOsOvxvB39Q8L2+kTyioTOIq+Bj/6YbzKAzFUYI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=igH5hTcaWH3lq73ghyBHWH8fp0q0Z3rbeM3fYgC0pC5H9mcdQN8rTaXIbrHbq4wCo
         z8Y0G7NIyh1V4dqjv323fcew1VlsT0IUNZi6ewKHDS2I8E2Xoos32uElNLrigISA+v
         k5+RejzDNVey4TbBL7ltDnLokXyUKw4pW9+5BjZuaUWBIgE2J4Br4hwiTWilWte6Wv
         19QHS/NTzRDILKzl5rzEW9oqoSHCaEFsGrTpt8feQG7ViRoyyB5fnU2QSuw3VP1qXn
         KpS7BWwJLhiE6Vqbrjc4vZGWWTqlkzHrMdcQxN7H+6uaCses3klKONXc+80lG3ZSZg
         cP28iywqQVNXw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/01/2020 20:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.94 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------


All tests for Tegra are passing ...

Test results for stable-v4.19:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.94-rc2-g9dcb411d44b4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
