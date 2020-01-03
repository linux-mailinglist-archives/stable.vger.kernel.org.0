Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFA912FBD5
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 18:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgACRvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 12:51:38 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7581 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgACRvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 12:51:38 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e0f7f190001>; Fri, 03 Jan 2020 09:51:21 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 03 Jan 2020 09:51:37 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 03 Jan 2020 09:51:37 -0800
Received: from [10.26.11.112] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 3 Jan
 2020 17:51:35 +0000
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200102215829.911231638@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f709c06a-ce46-a235-e0d1-5b7331c80c66@nvidia.com>
Date:   Fri, 3 Jan 2020 17:51:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578073881; bh=t+TDPbU2X4GNZgcq8rWoIrCweygU3B8/luC6azV+RBw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=V3gec+Gbg3YD3Oz4aR93CKw+Z4U5tegU2PumgsfEAPjXWqXDX530cQZVqb8crIeJD
         XDdIn/+6AZyyWFOnwvauKz1j0D8ogd28DmKuuqadDAuqky7JeOVfZOHVZMF08LDYtq
         SpGXH8KpKlUceOsosxMsh09dCTWCxCkTlvMDLLx2QekCZmjzteWX3a0NE3g7js0CZK
         kWGT/7euYmWMPlfiDx22Ve6SPt1vYiwLoBHDzP47mNEAkS3GAfVerjrtzRRx2HV+mn
         Th9UUzBurz472VlLPsQy8ib6pMojx1qiB4X1qBxlNuOvOf5Mn4LbxN9e6nDIXTDb6M
         CvdUmKdomtmWw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/01/2020 22:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.8 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 21:55:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.8-rc1.gz
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

Linux version:	5.4.8-rc1-gb06e60adec89
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
