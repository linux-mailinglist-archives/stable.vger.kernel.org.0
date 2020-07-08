Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2F22182AF
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 10:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGHIk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 04:40:26 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2261 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgGHIk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 04:40:26 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0586430000>; Wed, 08 Jul 2020 01:39:32 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 08 Jul 2020 01:40:25 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 08 Jul 2020 01:40:25 -0700
Received: from [10.26.73.185] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 8 Jul
 2020 08:40:23 +0000
Subject: Re: [PATCH 4.9 00/24] 4.9.230-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200707145748.952502272@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4da44dc4-6d04-d22b-e4c9-6c41d1fbefbc@nvidia.com>
Date:   Wed, 8 Jul 2020 09:40:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594197572; bh=y9F5OWWVwWRydP6EKcg6IF8ykaMLJKbSW//5QWBUJ78=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ckMr3G9p4fTCuqbYq6dg3gtCncbp8xOvt0end2SHjn+QW/SLPxpMN5KEM1+Y2HYmH
         EnIahMO8N+XPM0cAFFyl9Hy4l30OdJU7Ni+xsasFyNsch5DXwZQ91bLVBD+xcRyC1N
         bgC5Nc0pJVvn+DsL6acW17BBTo62NeT4Zm95dKruJfV+FPRCLkqny4poQBDhwzJ0Ck
         fsR4NQBP808VR75H6vx/7uTa8lB6vKFg5FENbrllxkS4E3nRKwJE0VNUMI9+T10QLf
         M1++R8Gi4pXfT3J/B4HESk9gZhSEyLaEiWFdZkgLVy2uEgGoYhFheZ19utyrpoiB05
         27BUPuatQ+YVw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/07/2020 16:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.230 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.230-rc1.gz
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
    30 tests:	30 pass, 0 fail

Linux version:	4.9.230-rc1-ge3bed594af79
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
