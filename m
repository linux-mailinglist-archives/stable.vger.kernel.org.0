Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43C810610
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 10:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfEAIZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 04:25:43 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18330 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfEAIZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 04:25:43 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cc9580d0000>; Wed, 01 May 2019 01:25:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 01 May 2019 01:25:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 01 May 2019 01:25:42 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 1 May
 2019 08:25:40 +0000
Subject: Re: [PATCH 4.19 000/100] 4.19.38-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190430113608.616903219@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <3bf496d6-c020-e3c3-57f8-7c6cfc43ebd8@nvidia.com>
Date:   Wed, 1 May 2019 09:25:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1556699149; bh=6UYzkIxMbirwEuoHpm7CBOd/uAAWo0u+XBz4h/IGNkw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=UuO0KyqI7P+68wQ7ncUuBUY5OfS7Zpe6+eASehrrrt4lT3fTUBXlke7Pr5q2vkisF
         0bvcLUfuP1+LRjoYOzwJwaXcjGLUtJSJkc/1gY1Y40twQYV73KLPifHNdQMV/SSRB7
         PTasDsaWMNFAwJUTU/GqSDKQULyrNOGCqJTncmbx2rZxhYkrPKxqrIQaG9NUqaxDLU
         ZlfJiGLSTIP2CxoOKzAp9Z9j6a9D/HkanEbAUOqpSUeresN157Rk1cTyuPo6WCOjdG
         1iepqEMI+ltGeWt8kzcqGNsruVHst/6e0yhDB1kmjREuFUvfZwpYJOv7sjdwHTkJBR
         NcyJQTE1AS8gg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/04/2019 12:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.38 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:34:55 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.38-rc1.gz
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

Linux version:	4.19.38-rc1-gf0b5b3d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana, tegra210,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
