Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36633B140
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 10:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388146AbfFJIvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 04:51:01 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7356 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387753AbfFJIvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 04:51:01 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cfe19f40001>; Mon, 10 Jun 2019 01:51:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 10 Jun 2019 01:51:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 10 Jun 2019 01:51:00 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 10 Jun
 2019 08:50:58 +0000
Subject: Re: [PATCH 4.14 00/35] 4.14.125-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190609164125.377368385@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7f2b2146-b07b-a06c-0401-3846b08eb584@nvidia.com>
Date:   Mon, 10 Jun 2019 09:50:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL106.nvidia.com (172.18.146.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560156660; bh=N86RBNjAa5Q/KdZeD7TxrpE3X32QLmeOS5ZJSlXFVkM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Zh3q0z3LZz5+MfdrDuSLgEhEiATJhkWH3U9sDGb3i+THgd1QA73ru9DqbnHhMUwU7
         BpSPWZLrTxrlryc993NGQiYk6K+Nkb/JXKsRhSlIeN5FVv+Oc5tc/K5rA0roT3819C
         XhekFEUlufZ/f/9hxuDyDHilOtBd0umg0m7YQqWYMKLH7z1O3yc2tpiNza2jzfOs0u
         /DavMhXFv4GabJFcS8RzQO9vfGqUCJnApDMZm7eOIWj7tXvwzKtMpy5aACuN82OFPt
         GEy5Rm+GrFXO+yNTifi3kiDQLXlOtYbqdYctAeK57fIzTjLV3BhLsIYPlMCDO8rdkx
         7GTIAbVOOmYKw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/06/2019 17:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.125 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:40:01 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.125-rc1.gz
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

Linux version:	4.14.125-rc1-g396ea3538ca4
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
