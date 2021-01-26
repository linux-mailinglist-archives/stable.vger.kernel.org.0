Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19130303E0C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 14:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390522AbhAZNFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 08:05:15 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6740 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392513AbhAZM7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 07:59:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601011940000>; Tue, 26 Jan 2021 04:56:52 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 12:56:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 26 Jan 2021 12:56:52 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
In-Reply-To: <20210126094313.589480033@linuxfoundation.org>
References: <20210126094313.589480033@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <bf085f01d1eb42c6948fa25a6a70c15d@HQMAIL107.nvidia.com>
Date:   Tue, 26 Jan 2021 12:56:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611665812; bh=aau67H83Algiw12WE2wiSp6/AeLyih2nD4lWpo9xiKg=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=MDniaaTdHxMToTOh9qpBepyd+gSJqfrjTTLsY1aHbd5q3OmRT5kVp3aTZM6DQeGJL
         xP7SlLUCbouebqGZK5dw9vSLGaslk/7FEZMQQzL7quVw97k6Z+kwdwSEtCB56NLjjz
         umOBs8z/LwaFc+Ygvw7JyY9BVitCZOKFS9wHbu7ax0eTiUBdUZcxuGMMUSuhU6aLcY
         Y3ksCqxxisvZf0Vzi4uIWuusyvnENMQ2rL71ROXBqA2DybcJ1yIeVsZAv/Uy3rU7NI
         ssvFDng3CvBpEB2w0v8+i03b0FptQiXxkYbEZB8LnqSX99I43bfYSxXmXoqYFNlRrI
         o4p/3J4BXzaaQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Jan 2021 11:03:12 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.11 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc2.gz
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

Linux version:	5.10.11-rc2-g460ab443f340
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
