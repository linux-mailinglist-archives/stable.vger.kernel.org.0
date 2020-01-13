Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3DA713952F
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 16:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAMPtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 10:49:07 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14902 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgAMPtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 10:49:07 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1c915e0001>; Mon, 13 Jan 2020 07:48:46 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 13 Jan 2020 07:49:06 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 13 Jan 2020 07:49:06 -0800
Received: from [10.26.11.97] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 13 Jan
 2020 15:49:03 +0000
Subject: Re: [PATCH 5.4 000/165] 5.4.11-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200111094921.347491861@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ace61a61-9241-5734-aeea-86de9e9e608a@nvidia.com>
Date:   Mon, 13 Jan 2020 15:49:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578930526; bh=si2NM5sTArPrKtvvSzoF0ob++Q0lYByp7aSFZDFvr5Y=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=kUpnWNzdnRNF3urAb8ERueqcc9KAltGfKqvvmuu1FsQk5OoVUwMsfAHJ4Pr0OhP9N
         fcu5YGGfmhla08veM6K/tlWY5ODgZHdRS1myKzEIwuaBcC7VL5ILWSdJjQ8XQyUmeJ
         iuhkIeroZUokhL1zJ3UY1Gqer9zG+JDdDcCTmQ4V1MXH8pqbVwZG45PQrhEyLVzfve
         bi7nAncGQO9mmE0TxSoNFKc2DJ7OjBP51qMCBq1aaA2eZHMHVLFuBOzUzp7xV3z0XS
         HLI4uoD3WDWwjXCYIocfC2OcHIWkbH8V0y0W49Yh2RUswa/zMX2mtQBfdYypZA19mG
         dpzkOVmT/vLNw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/01/2020 09:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.11 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.4.11-g9d61432efb21
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
