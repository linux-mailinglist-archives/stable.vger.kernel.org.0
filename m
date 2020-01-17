Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70836140A77
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 14:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgAQNNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 08:13:20 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8971 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgAQNNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 08:13:20 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e21b2da0000>; Fri, 17 Jan 2020 05:12:58 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 17 Jan 2020 05:13:19 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 17 Jan 2020 05:13:19 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 17 Jan
 2020 13:13:16 +0000
Subject: Re: [PATCH 4.14 00/71] 4.14.166-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200116231709.377772748@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ff6be524-fdb0-66c1-977a-96f521a13025@nvidia.com>
Date:   Fri, 17 Jan 2020 13:13:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579266778; bh=JINbM8EB/HU/d2rIdr6xU/Im+Zb4b59It+btSrtysTw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=gBLmXAF/A2RCOQ+em6ggRElAmkzOFHBytMw3Smfh/m3zhz7ZHfZuRAJaCKVOxpQw6
         LixeIKjjOd3/bkhfos0PYgijWxF6TrNAG3JL1/k1dct5N9CLwYU6ue+2jD3h1BpfSM
         JGRwdHB2fZ3x+3htXZCK6EVfpb6CSkf2LgbSaN3uTOf/7iPYqKDdJ0TpGv+Uz4PEMp
         VxYr0hhfnCTEXCY6TRpGQw1GI8NKnnwQfjekuMGBjD6OORWaL9enbjLU2bjSCkMX1u
         5kw8xAJLi/UiBWKIiHHDf90tqNNo7L9aMV21kyVrO0FBN8eoOCR+0hQcZrLFEdHrSk
         Of6tcgPtePGEA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/01/2020 23:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.166 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.166-rc1.gz
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

Linux version:	4.14.166-rc1-ge0cdfda22253
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
