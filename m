Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E2B24BC8C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgHTMsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:48:54 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14324 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgHTMsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 08:48:51 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3e71250000>; Thu, 20 Aug 2020 05:48:37 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 20 Aug 2020 05:48:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 20 Aug 2020 05:48:51 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Aug
 2020 12:48:51 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 20 Aug 2020 12:48:48 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/92] 4.19.141-rc1 review
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <5ae3c0e6dcc6410ca1b5a72d1a488f9b@HQMAIL105.nvidia.com>
Date:   Thu, 20 Aug 2020 12:48:48 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597927717; bh=75uYkFrHtcwRAH/p3/mbEhne9lNqNgQzkaO5gh4+R0I=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=D3YkkkaqZAlqgnm7oojH3dRb4z3ZKW0g4qz2DW5vaoEliSM2tQW8MBOAJcryZ+Sfa
         hXnd4MqJXp3oAf1FQhEW+rRW9RR33JhULB/TIvOA/FLql38ivO46vpTHczw+J4VLvZ
         +6IkDrAX0XNfufWR/mBuNKEJiem52uA6S2U4rguZfOckzEthyrdAsD/FqD/o6vLxQC
         crEGWHtpkes3ve53Z4vBuVR9hrumxSQo1ZX83/MrROvV6cG+EajfZQC6y9e6mV70Hr
         BtyBwP7fcaYksVQf6aDmhysqG2HMQdXNoYrbN90041rIZWmpbATJQ/oriWvtJJyunu
         UKZcwrXdXzAWw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 11:20:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.141 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.141-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.141-rc1-g294e46de3a1d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
