Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2971819A800
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 10:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731861AbgDAI4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 04:56:50 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1392 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgDAI4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 04:56:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e84571f0000>; Wed, 01 Apr 2020 01:56:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 01 Apr 2020 01:56:49 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 01 Apr 2020 01:56:49 -0700
Received: from [10.26.73.165] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 1 Apr
 2020 08:56:46 +0000
Subject: Re: [PATCH 5.4 000/156] 5.4.29-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200331141448.508518662@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <73e0bbf0-c79e-6fca-b3db-89f5c5c0ba03@nvidia.com>
Date:   Wed, 1 Apr 2020 09:56:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200331141448.508518662@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585731360; bh=BPJ21G2chBA54ui71ExULJXA9s23qeMBgn08aAOSm00=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=dgEaVn2J+A/5li10YUi3VxV/CQKJTCGduakkAFG2GQHb0meO9hGmZLZrKBPSkulGG
         MnUNslh+xZblq9HU4cfOcpAFZAph2obi9NpwOE9IARDNQVSDUyfS26du8RCkW5Nc4v
         LYLh+THCN5dW/+VdwFz11hkqX/qHSiK66fVg7vTbpz60ObJkO59STFvLHyCLFOUtJH
         xG3cGNX2SrZEHwBCRolHM2ZjiUaRqjF1Q0hW/c8biSIF3JfTUC/gGLRxr9vqRcKUHq
         fn2dNjmpUJRz9J2eWLPBKaNDAd9UuPmroa2qPFBXtbhx3PM4RsMe9/9RSmvZ6YFEUR
         koSXMdMn/OLKg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 31/03/2020 16:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.29 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2020 14:12:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.29-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    24 boots:	24 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.4.29-rc2-gfae891585ecd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
