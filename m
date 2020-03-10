Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABA91808C2
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgCJUIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:08:21 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4941 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgCJUIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:08:21 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e67f3590008>; Tue, 10 Mar 2020 13:06:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Mar 2020 13:08:20 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Mar 2020 13:08:20 -0700
Received: from [10.26.11.187] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Mar
 2020 20:08:18 +0000
Subject: Re: [PATCH 4.19 00/86] 4.19.109-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200310124530.808338541@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <732b0f94-5233-b2a9-2574-34d60e636457@nvidia.com>
Date:   Tue, 10 Mar 2020 20:08:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1583870810; bh=A9D6nK+BVZGYWTRl6HAHA2N1QwkTtlZofC0eqSTIQOg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FFt0naR9o/MCodW0ULy2B0O3bVZLBIftZoWm0m5biV7m2PG6QCO75NuagXyjMoIBD
         Ko/06QUZrU+z9P3LFGjkjbktxpV36xacyI37b02ZCK9O3NcxpkLZJZMQ8cMYHeJBin
         rH6ui1YkmSi6AQclLKsY4WC2ELqELGielgx5t8Cvn7z1dilX3FYgCUMHxz15H+s2n+
         rC90npby2Wv17d7gvXfFsl5BCVqR/2pCKdjKgp4+1OfMrHVo/FhfGfwZhqoS2Wjeu5
         wuAqQs+Sgcq+a0kXlwdtoZOYEp0Llkkb7C3V+MMdp7iaxWgMNoqUBgRWLvfHSNKD71
         Vqo4fBTesU0dw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/03/2020 12:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.109 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Mar 2020 12:45:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.109-rc1.gz
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

Linux version:	4.19.109-rc1-g624c124960e8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
