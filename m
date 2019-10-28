Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03997E7B73
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 22:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbfJ1Vh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 17:37:26 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9894 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbfJ1Vh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 17:37:26 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5db75f9d0000>; Mon, 28 Oct 2019 14:37:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 28 Oct 2019 14:37:25 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 28 Oct 2019 14:37:25 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Oct
 2019 21:37:25 +0000
Received: from [10.26.11.236] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Oct
 2019 21:37:22 +0000
Subject: Re: [PATCH 4.9 00/49] 4.9.198-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191027203119.468466356@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0f80e357-ecf8-0c62-a1df-b0eaa584744c@nvidia.com>
Date:   Mon, 28 Oct 2019 21:37:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572298653; bh=UghTU9DUREBfQECTliq0cXm3PL5hvs33lhPbB1l5ga0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=WJAdPABieaJC1waYRDb6VAFvaOONiIjRH6/gpu83/MvhWTnQYDQlZIOevRPEQc3Gf
         r4fEAod0edpxAWtcw2zy3EBwejxq86V9euVW4g8wIa//Q7oqLhWnu4upel+ztv3jmB
         4jQQaeNujVyH069ZP94OEYywpZ0huIZkSsTUpjfXgXejugXe5IvsQSMhZY9XvV1T7E
         GYBKGeGeo1HeLVzOR1R4tcc7j37iqTi/5G5AoFpyivBVugano5YNxWqpJAWlU5YnKr
         lFEa4LUgvyIXrhC9FB0Z6ZKz6ep9LWgEPNj/M6rxtfmawpYVfkotburQKAP13+NLBl
         9YBbaZgIkG2bA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/10/2019 21:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.198 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.198-rc1.gz
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

Linux version:	4.9.198-rc1-g5599bed3f84d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
