Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C352F19CB
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbhAKPeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:34:04 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17363 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbhAKPeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:34:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc6fc30004>; Mon, 11 Jan 2021 07:33:23 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 15:33:23 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 15:33:23 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/145] 5.10.7-rc1 review
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5a5c3f8ac53e4e9a9e7710ab6896b4ff@HQMAIL109.nvidia.com>
Date:   Mon, 11 Jan 2021 15:33:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610379203; bh=561GL7xaudSJ4uq0BU4dvRYXG+O5+8gUD64o2BSkhzE=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=NkIaiCZTisVdQzk9nRV2ckkXPxa1VN7k8Z7j36gOTLUsaJdankoAe66DMAkkwzaAA
         Mao135nAcUf6gRs7lk1VE5SfE6MpJzfmb3bHRXX//7DtnI4SDCaBz/crI+lQww+OCQ
         6XCda2VSFa/u8GWE8WlYpN/sk9R3ynxGtCewSC4t/w9ZQeONId3TPps1TLe5iVT7vE
         VHEpl3ruwMksk2z8hOzguix/qJh8Wmv/oLiuSTxCbbH67uYYZXTpym+4WVMri2f4Ep
         giB8Lwo0+V2PDI+o7IOXDJUgFheK76HDk5576KxG2PRFkwzkqbyS3BTL3nbUa3QPp/
         nar4c9Y+P045Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 14:00:24 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.7 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.7-rc1.gz
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
    64 tests:	64 pass, 0 fail

Linux version:	5.10.7-rc1-gc627df405028
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
