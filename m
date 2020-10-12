Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8055228BFB2
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 20:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgJLS1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 14:27:49 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5213 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgJLS1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 14:27:49 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f849fb20001>; Mon, 12 Oct 2020 11:25:54 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 18:27:48 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 12 Oct 2020 18:27:48 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/85] 5.4.71-rc1 review
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4b4574891018489dacd0db93d090ec66@HQMAIL107.nvidia.com>
Date:   Mon, 12 Oct 2020 18:27:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602527154; bh=Ukd8Rw623Byj03+wM9JNI+39zYhoY/aAhHf38Pv7HI0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=ZNwdDrzC3lirfdqV6vrwqjIRQquwFtEyHDYKjEFFCN/fGaqLCFSKv22Y3PBTLuuDy
         BcG+IUSfjsPS46dzGBiwnjMJrLbLGfcKRyAEUbsAunYSbUhWzZAjEF9TOG9WDtv5tP
         pR5CXuHR8aBKtH+P9ESGx/i4QRxsGFXvp0SyTJn9K0asKZQe16N9Ik9hCIZFdrxsRW
         v8svP9ayvLnFEoXm/lTjnjxDt0ybzJ5ED41WzHaleLjvzAzNa0mRaJklmBPPATugfU
         sFnDK/W50idnYLm70sKkAEL9+zEfScb+eHBmxFiYhOA7vjyD06Cr7HMQc4Dw9UclWd
         PKZZ2Rz6yaeqg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Oct 2020 15:26:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.71 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.71-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.71-rc1-g228d88e992eb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
