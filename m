Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EFF15D592
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 11:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbgBNK07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 05:26:59 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2731 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbgBNK07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 05:26:59 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4675d50001>; Fri, 14 Feb 2020 02:26:29 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 14 Feb 2020 02:26:58 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 14 Feb 2020 02:26:58 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 14 Feb
 2020 10:26:56 +0000
Subject: Re: [PATCH 4.19 00/52] 4.19.104-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200213151810.331796857@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <04fa800f-6887-7a05-564c-af4c1fe8e59f@nvidia.com>
Date:   Fri, 14 Feb 2020 10:26:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1581675989; bh=q/AItcaBouSefZL2YcaotvDzK5GaVUKVVkne/o2igcI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=d5pw3//bRXqzagp2TI8J5S0/4aZgFIMqxxm6NrWDGo7m+Di2BmNGFSBiLMkFjGfdQ
         s47Pr+uMucuQgzjT6iMb6L+Utu5qufFUf8oFdvqc76JuB8r1s1CTr8hz82mkRqAt5j
         ZN/rJ+iGvh0zr1fgqhudSjpX++4vFon+tV8lQpgP/wVStPv1ig0TWtMm9/hY2NeaVZ
         fHTu+LsrfWQ655tcbz5wZxif6bBoJf978xBW4h1zkQVJn5s3hoENkSHIqmRo6oLgDM
         S0XMYEvMr+32durZRrpV6lAm12kjbEnuyN7y3HZU+rWUHe8qAxTaOT7/+AluVUNtm4
         cFSCwFEZeLqHA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/02/2020 15:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.104 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.104-rc1.gz
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

Linux version:	4.19.104-rc1-gf1f9ded7a002
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
