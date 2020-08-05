Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A395523CC01
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 18:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgHEQRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 12:17:54 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18774 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHEQOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:14:50 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2ad51e0000>; Wed, 05 Aug 2020 08:49:50 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 08:51:30 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 08:51:30 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Aug
 2020 15:51:29 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 5 Aug 2020 15:51:26 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/52] 4.19.137-rc3 review
In-Reply-To: <20200804085216.109206737@linuxfoundation.org>
References: <20200804085216.109206737@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <73af217a2325404ba0f8ae42f094662f@HQMAIL101.nvidia.com>
Date:   Wed, 5 Aug 2020 15:51:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596642590; bh=DXS4VKsrB+SuvGtfbEKLfRpzRoE+tvazZidDZdXVZ98=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=JHMhn+fYprUiAm2x1EqtI85AVxgMujS7xi4G0fkC4t4AgH6zWj1XvmssVHpwpXwZH
         IbRIahonD+Pi6DmamnQfZ2aYeZSXUrkZMo7TDa88rt8X6BO8lspfz+So+ucVOj3Lc3
         xRtxsOahyrpmOpKxwRNPOf0Nh48IEjF6VxyXmcsM2bhuI9n2mxLaCpS6EnvCBI4f8E
         t3xEkBzvAtRdUQbv0fbYN8l4Ae6IyhNjZeB7LUftu6v/hHETr4pgUp+7OtA8QBpGMg
         GObZC87M1Y6cLgGqQUjEkopeMZEA7nMUQ2R/Ubpo/7QuXT18GtyD6fjHOMGGhi1/zA
         +vzSrm02eZ3oA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 04 Aug 2020 10:53:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.137 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.137-rc3.gz
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

Linux version:	4.19.137-rc3-ga820898d10fd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
