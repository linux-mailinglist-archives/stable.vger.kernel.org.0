Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F121E23CEE5
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHETIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:08:12 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14520 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgHES5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 14:57:17 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2aff010000>; Wed, 05 Aug 2020 11:48:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 11:50:13 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 11:50:13 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Aug
 2020 18:50:13 +0000
Received: from [127.0.1.1] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 5 Aug 2020 18:50:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 0/6] 4.19.138-rc1 review
In-Reply-To: <20200805153505.472594546@linuxfoundation.org>
References: <20200805153505.472594546@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <061de3a1d5c54ac3ac7bbd22f76e3fa2@HQMAIL107.nvidia.com>
Date:   Wed, 5 Aug 2020 18:50:05 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596653313; bh=apBZlh2BQ0rsKXsX2lUKhJ9qwxxSy4epC6ZyIz26Whg=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=Y8LosXRk3dkQjRP4u90I0DnVWnuhJxE7atad9oSX6iMRmToZlB1dH1AHS/NvzQZSn
         A0dv1gVdolKBEjyxAVTyWjJJcPRobFhQdcdDuLYgt6/9r2QDECxKdPFkxfGGdO1a1S
         YIOnosWcWoNwX06OLO0pX1CX3IBkqMwCP6rJZ7MSfGP0Tpko89jNdpzi+WzMUFSndO
         uVOkmV4ImPs603BnDX2ZopZHoJ/i6O143piNZMwtzam5nZdOMpA3x2MBIhzjyAw/+2
         Tf+tMy791W6uhU/k9jk8/blYDTa7NgX56QbFIFDRFPplvxUHR+nbGalGRhXudsqZAh
         EhHSoSAS79FJA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 Aug 2020 17:52:59 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.138 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.138-rc1.gz
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

Linux version:	4.19.138-rc1-g2f4ec68a8dc8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
