Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C729C11BEEE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 22:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLKVNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 16:13:37 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7506 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLKVNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 16:13:37 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df15bf90000>; Wed, 11 Dec 2019 13:13:29 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 11 Dec 2019 13:13:36 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 11 Dec 2019 13:13:36 -0800
Received: from [10.26.11.206] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Dec
 2019 21:13:34 +0000
Subject: Re: [PATCH 5.4 00/92] 5.4.3-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191211150221.977775294@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a55b4e47-7411-083e-c9ec-8e55db90b415@nvidia.com>
Date:   Wed, 11 Dec 2019 21:13:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576098809; bh=J4kUrNCfnxLI/2vnGKXYe+Y/xOHfWTzxPwP4SF1uUIc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=JVVU6zMNsMcURrS3X+GK5FjA0I/ODsL+P/nK7BYArF8FF3jne0rcHYbnQfMsf9UiH
         Sf69B7HDquUzJNeMCWjXvZoFvnmo++sn74LE6AEJdAEmjHigTP8qAup9eFx3Uc071Q
         YKRraOQVWdlTgXnH61R43q26EqPkwlmXFtsGEOgY9oAWZ3M2FrSX7ZZM9q0ntDvg8N
         PZ/zBzimwMKCghfffiwXYgqP/Dt7eaj983KJGauTt0BYJP5pw99g+nKrKUP05a8ot3
         vBwIaNgoEtlhm6CeJOrFwlphHI3UWDEMxSZdjx8l1hnN5NHeFar2mMX8O7MYbJbRri
         EQWXnmPiVaPiA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/12/2019 15:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.3 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc1.gz
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

Linux version:	5.4.3-rc1-g6b42537b2c89
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
