Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAC82D1459
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 16:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgLGPEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 10:04:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2039 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgLGPEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 10:04:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fce44660000>; Mon, 07 Dec 2020 07:04:06 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 15:04:05 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 7 Dec 2020 15:04:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/32] 4.19.162-rc1 review
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
References: <20201206111555.787862631@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fb7d5c5a2eb14a278ba51a6966a1a9be@HQMAIL105.nvidia.com>
Date:   Mon, 7 Dec 2020 15:04:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607353446; bh=IbmHj+PuziEK/6VNNiqSqnNXwGaBmRbbqcerA7U4ZsE=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=JS/BvsHufOtLFjasI2LNhlMgqE6Y6xgUd+Hu5DKGXCSCdAhfNc2pE9vUCKP786CBw
         2Pu5u8RxB0bqAuKFQNOAD3v4tJL3bdtMvFyxBTT/ea14vXF24pZOS+oRr25lt4AgEu
         D0Yz6HiPPjRYvN2B44Ap6F9shMwPBmYAwKak4HrkPG+/yIIrIkTpg0/Op6/ZHIKtag
         7PB6ILDeSOLvqRe0JLIaIWNASGnOZBo+z8VBOiUbNWJ3suob7fyRhmQMUJgnVh1nfB
         3T4SbBxLGpmnYMuN3dZRPMnwOLZdvRKkhLDhW5Zn4FbBhK5O76aN3E5gndXZ0Iv6V8
         JaMAMExGPZbFg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 06 Dec 2020 12:17:00 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.162 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.162-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    15 builds:	15 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.162-rc1-g35a4debf26a4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
