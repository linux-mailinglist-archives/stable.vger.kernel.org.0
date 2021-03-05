Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473B232F1C2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCERva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:51:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3066 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhCERvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:51:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60426f8f0001>; Fri, 05 Mar 2021 09:51:11 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Mar
 2021 17:51:10 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Mar 2021 17:51:10 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/39] 4.14.224-rc1 review
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <43f530d34a594a1fbd0605de2bf374d7@HQMAIL105.nvidia.com>
Date:   Fri, 5 Mar 2021 17:51:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614966671; bh=GnfwTsIOvVRqHJWl2YyFqEjJnQzSh5oj/sNUUHcTF2c=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=BloGEQKxmG+nhxMaxcZcWmBI1cQNaFWuK/grVFwShQTgTk5ZdnKGG9fNaHNlWqDQN
         MnbmMYh9jbQlx5REVixo2q61s3JX0ZviwZDbUO+qc9o/1rg0GwTh53z9IilIcCgN1L
         9C2mLCuYZtGhia09g47cRAzPy4qErcDhIJ0fAspi4PWtEWtzOtVya957TwO01hi8q0
         BYwlsW381KG9NtvWMQb3s4uJ4bITfG3ymlc43NlWNIZYFR89Gtaijs3euxsR/4OjvI
         8aV8/NHHXiKUdd4dbidkewKC7U9lW5kxaNMtBGNP7JQOCTfRMKPp4dHXtnQHmQbzC+
         9Oo4eJOtOH4Bg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 05 Mar 2021 13:21:59 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.224 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.224-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.224-rc1-g31fdc1da4f57
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
