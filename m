Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A614B44B
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 10:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbfFSIpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 04:45:53 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15364 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730418AbfFSIpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 04:45:53 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d09f6410002>; Wed, 19 Jun 2019 01:45:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 19 Jun 2019 01:45:52 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 19 Jun 2019 01:45:52 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Jun
 2019 08:45:49 +0000
Subject: Re: [PATCH 4.19 00/75] 4.19.53-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190617210752.799453599@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <e086bd67-6c38-9e21-0ed2-b3afb235145f@nvidia.com>
Date:   Wed, 19 Jun 2019 09:45:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560933953; bh=Vl8T1xW1MxWFZa0WTTKCUCWKN9kMrFyIX5pu5+TgO8o=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Fvj0YWWeT6uD2Q9UzlXypsH1RoqS+qy7Z34vKVh9TOFQfI29NHZy7T8UaVdRWkFMM
         fojuCVEYpE5AEQt5rbyYFfFCYBCwVnD8ttwNeKqpBx9kRiISTN3WW/YefL7M7wcJsw
         SBmEYyVGP4jfN+4Kiz903EN56FtBpPopa1AIJzpZ6krzWiap5IgbxIfAsXOvbEqe33
         0VWu4aHUHjbitFbLJedbIJISqv2viMtnWo9pQq6Y51pVSkrMFdFiR+IeH8RhMGQbu8
         YKRzt7cx035/osehRbrgO5jgOAq+bnK4yRqOebw3lJV16mmTXmGg9O7i6WQ/dFOg3z
         6zF/1FzV0V+gw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 17/06/2019 22:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.53 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.53-rc1.gz
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

Linux version:	4.19.53-rc1-gd486e007abd0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
