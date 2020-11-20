Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE5E2BB105
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgKTQ4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:56:35 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4070 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730224AbgKTQ4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:56:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb7f5360000>; Fri, 20 Nov 2020 08:56:23 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 16:56:33 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 20 Nov 2020 16:56:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/14] 4.19.159-rc1 review
In-Reply-To: <20201120104539.806156260@linuxfoundation.org>
References: <20201120104539.806156260@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <55ec01dcd2f844a682b89ce4d4abf7a3@HQMAIL111.nvidia.com>
Date:   Fri, 20 Nov 2020 16:56:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605891383; bh=0WsXkuTYoZnwFODF6GnsXQxNDHDAXFRiphe8K7Y5MBA=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=dIgu/7+7WelO4fHr6PQG1hQyWLuFjlGseggIoxs9MIPSCxJmJ3rAJ7WS9NhVcette
         K9yUFWgVD78b9vHX6we2n86OMRD/QX/KTo82ucitYUIaQre+ZfoSs0nsPQR/J6Ucjz
         ZGmQA7uiCwPdn8Cv5db2KvOsr6BOleZADzydTxrZ/yjyrVxrk5Ir5Gp0GXMbgAWFJ8
         QxTALQrZnY+WZEwWR9akRZ/7P931VZtRU6Vz1nyoc/NEnTNWlw7H/DdPYATjCbhpao
         /kVrsi2aQPZ7ojyIdpBHpHFBi7SG27hbdsd0f2aAzNv+TBTnN82z5wm/ndjtXNVd3f
         KNizlVzUfKMiw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 12:03:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.159 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.159-rc1.gz
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

Linux version:	4.19.159-rc1-g5ab11a539ca7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
