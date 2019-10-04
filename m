Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E50CB518
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 09:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbfJDHhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 03:37:45 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9876 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfJDHhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 03:37:45 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d96f6d10000>; Fri, 04 Oct 2019 00:37:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 04 Oct 2019 00:37:44 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 04 Oct 2019 00:37:44 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Oct
 2019 07:37:44 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Oct 2019
 07:37:41 +0000
Subject: Re: [PATCH 4.14 000/185] 4.14.147-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191003154437.541662648@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9192e10e-d247-1e0f-d13f-0d3cfe362f00@nvidia.com>
Date:   Fri, 4 Oct 2019 08:37:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1570174673; bh=eXz/3iRGaxsbbDLKmWNFltgRXqkWIUn30V/VRyeNc1I=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=HoVwqJn6v+uGLPHiHXSg+e5RkzVpZAwnU1pXSdYhC2Q4T4y4FKs2e+v7Bsfs+59y/
         g2wiiWfd7mKLsVWHTHFnnhwDR4h1ieFMAG1RWQ2ouVdYfHlL6HWjmKFP3/7J8YXDdx
         f4CAmKvWJt0lD++eqYkjp3qy2fYDk9tJKhk+DmBkTMLA1kcxkI1vhn6kssRHh5XjAi
         sYyxtnztAascy35/FSH2YP+CrO1sm3bXBVweXrEPdFjM+MJYHfDvrd6OPH8Gb5ygBz
         7PNZIJvYG9x3/dXFurcGYNACLbse4znPrrv/6YqiyR5poclv0+AdHZKL632FiMWbZ+
         Qx27RjR+nr0iQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/10/2019 16:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.147 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.147-rc1.gz
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

Linux version:	4.14.147-rc1-gb99061374089
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a0

Cheers
Jon

-- 
nvpublic
