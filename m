Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BAE29068B
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408413AbgJPNqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:46:54 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15515 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407452AbgJPNqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:46:53 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f89a3f20002>; Fri, 16 Oct 2020 06:45:22 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Oct
 2020 13:46:53 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 16 Oct 2020 13:46:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/16] 4.9.240-rc1 review
In-Reply-To: <20201016090437.205626543@linuxfoundation.org>
References: <20201016090437.205626543@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3f71754af7db4ce4b04c00e197ab2bb1@HQMAIL105.nvidia.com>
Date:   Fri, 16 Oct 2020 13:46:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602855922; bh=IeCTusc3JaLzJb7eJ1rcE/VE00ZFmvGWmRJ1saervXs=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=qwPA7kiiViY87pu9lIaVylHFnFSUfTtOysx6O/JVS1YxGCK8qPo6R376BJ3OP+cK0
         mTXcZ0vIX3jmGBvXIAQevTOLtoHUY/rl9futWWWN8NhGAO44pcfwqoSokcrWFucrez
         57QPuAP2/PtTfDe/zAvyGmC7l9m7VKo+bkeswrvpEJwxLUVO3J62aQUuwEtruFj9EN
         EdHmKYO0TQ4Rtnm282z06ikXOwpTYvemBOGZPYwOqIm3rt3aPPOfK1OicGbODPcyBW
         UrRA36/uNTNG5j8iv7etVv1SlSgZv6BJVqDKEDlN4029QE4CsGouoj1OEYjlYMLbw+
         R20AX+krWcbqA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Oct 2020 11:07:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.240 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.240-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.240-rc1-geb0fbe0c6b1c
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
