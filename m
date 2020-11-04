Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26622A6010
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgKDJE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:04:27 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7456 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbgKDJDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 04:03:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa26e740001>; Wed, 04 Nov 2020 01:03:48 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Nov
 2020 09:03:49 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 4 Nov 2020 09:03:49 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/191] 4.19.155-rc1 review
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b1b7348f053240beae8e7fe648e85735@HQMAIL101.nvidia.com>
Date:   Wed, 4 Nov 2020 09:03:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604480628; bh=jTfVo1z3cZKdbL9Ob2gkG8HFWkZWMhwiiRZi3Z998Bk=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=K1Zvs02offGqtvcPVGyukHU21uyAuqzaZS5jXYcoSqPRUCCRzaeLJOM5iak6DGMZT
         xYHI/JchpEsAyuUjoNwkzWPgh127oTGcTgS1Bl6/q7kvb6exF3KjxuWF2TA8DX8RW+
         O23W8uBU3N/bCOPEW7ujQCqYKIp3+tMzlcvLmWeWtxIEeZ9oHOCwX92AeVUrt63UU+
         7U/PRuvGPVwydW40VS4j91KRMwJZitr4BgLSZwKjkRdWsXYu6b+Vix/O6wTNkRZIpy
         d4oV4ldHcORzBoAL15vD2Xyh9RIxLtcOVKMaTgmfCrSbF5l5JnCUC/UDylDBVcQinr
         yDQiFWiLfaomQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 03 Nov 2020 21:34:52 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.155 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.155-rc1.gz
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

Linux version:	4.19.155-rc1-gd404293c7653
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
