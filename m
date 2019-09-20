Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EA9B90FC
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 15:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbfITNst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 09:48:49 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5361 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728494AbfITNst (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 09:48:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d84d8c60000>; Fri, 20 Sep 2019 06:48:54 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 20 Sep 2019 06:48:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 20 Sep 2019 06:48:48 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Sep
 2019 13:48:48 +0000
Received: from [10.21.132.148] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Sep
 2019 13:48:45 +0000
Subject: Re: [PATCH 5.2 000/124] 5.2.17-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190919214819.198419517@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <968601a3-71ee-f562-df15-263f91933738@nvidia.com>
Date:   Fri, 20 Sep 2019 14:48:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568987334; bh=2I5U542l/4RuD/2S6pr7XwLcfxiurU49CscvGZ0WcX4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=cgBWisj/6Kk8eDbx0KwqHfQlz2xluXmDW2P4f4UBXUbw7rvHLIzbvLxPSfpwHlwpD
         XvPuB9l88oa/rAEPnL8KHlSqsv9vS9MNsDEq6yjX8sWUY4zCRBPem3F6pqq1CXLerL
         xHHRFoxVrY3SMaWhyuRcd6UeIMLuUBawh18f5zSsY4jVNV22uAm6noFEmRsWrzCL3q
         2ddd9O2LzHMzn2MCl8785jTRwVY6/1UivjxuepMOx5CCaBT06+OgLb+QRWj7p8nzQW
         gxbJ0ABCjeXH/OH5IOz0dCRpE0UkVREgM56CRJIBK/qoCwphaGiU49x0gM68n0ohFC
         m24fFBMLwGuSQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/09/2019 23:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.17 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.2:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.2.17-rc1-g690411952b3d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
