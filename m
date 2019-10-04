Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B31CB515
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 09:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbfJDHhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 03:37:24 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14002 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfJDHhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 03:37:24 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d96f6b70000>; Fri, 04 Oct 2019 00:37:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 04 Oct 2019 00:37:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 04 Oct 2019 00:37:23 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Oct
 2019 07:37:23 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Oct 2019
 07:37:21 +0000
Subject: Re: [PATCH 4.9 000/129] 4.9.195-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191003154318.081116689@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <c8f543ba-1a3a-48d6-26d9-636083360a03@nvidia.com>
Date:   Fri, 4 Oct 2019 08:37:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1570174647; bh=eH3+Byz+w0xIHTxH2Vy60BDBR3A5qyV/BkDWm2mgwOA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=cbSkuIJv1c0YRQXbki73RxI3sXW4ifaQ/Ji0BDXFrAMOzJEDWyK3IMh/7hgwKCKv6
         44F7Ywr5fFqkjeTwT0rHJatZ0jo5us0/HBnNCC/dPOFP2dmQKgJq7e9tK9/U9K4+Il
         5Wr0QyutoTxonrVdR1Fyu7pysslqu8WU5+puj1kbscV7nM5BrSrES9KX+6PDklLdE1
         BhARZV9HbKIJvvkJ5CCi9pWDEdSfZFsaJQdDy18LTiXVnWVZtqLhIU54H5eEnPzoKV
         G09gkcbbI6aW/zGpwXUI9McK6SeFW3DVTcn24QSZ8kJ8gT62KwvSM1ei3Fryck4nOy
         uggaSqlJPSiLQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/10/2019 16:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.195 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.195-rc1.gz
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

Linux version:	4.9.195-rc1-gc1fc11455620
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
