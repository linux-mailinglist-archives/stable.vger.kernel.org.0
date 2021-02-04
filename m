Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF3030CCFE
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhBBUY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:24:28 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15403 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbhBBUWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 15:22:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019b4570000>; Tue, 02 Feb 2021 12:21:43 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 20:21:43 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 2 Feb 2021 20:21:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/142] 5.10.13-rc1 review
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e2e3eb187c7d4f1fb530b2b4ddb5aade@HQMAIL101.nvidia.com>
Date:   Tue, 2 Feb 2021 20:21:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612297303; bh=t0GpZIVRViEbbqtttrx/FThFYyoZF4rxa9CcYXvT8vw=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=i+yBNMruzvMyUKoTzKAFdDceCPts4RpZJOvfSdD8GTQUmQtxUbruW5kqSjjPLwSCq
         I1WJyb87opMncSGqp//HsPRL9RaqNnLTVEJD9L/BiU25lglovuiSSKr9VIfM7nVUbN
         R7LhIpi9PfHzZeGYeAkSClKSfg/RkJj85YeF9Kp27Ml2dygxJ3+3VjeF0TzjphPERX
         hYcLVOuZUrkyFE+DAD+LJVll3txQyPpX6goRy4JO4xdSQroFuhAdfpzLrzrsjZYOp5
         uDjuBL7ze9sbLWWEex0mX/ZeIZq9bIqsunpsdaEFipKj1L0sthLYi1AfzgnarNDXTi
         sqw4jnlH8e12g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Feb 2021 14:36:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.13 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.10.13-rc1-gb34e59747fbb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
