Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0676273B22
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 08:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbgIVGqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 02:46:07 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18112 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgIVGqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 02:46:07 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f699d510000>; Mon, 21 Sep 2020 23:44:33 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 22 Sep
 2020 06:46:06 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 22 Sep 2020 06:46:06 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.8 000/118] 5.8.11-rc1 review
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <632a6d3896b644dea98be80d747174ba@HQMAIL111.nvidia.com>
Date:   Tue, 22 Sep 2020 06:46:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600757073; bh=BKxIkOjRR0F9KY2dd8WqgosOO4gtk08eCPD2602RGO4=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=HBS/kIht5/Y0igBBmcaVQ4McvhtO5NuEZul7Elf+RpjkYVsf8IwprzQfWX3BVNHdv
         3+hD2vFx6ZT+ibjblkmmAamZGz9ldOd6HFCfvESR27yNkNYE/4kUITa9Ccm/Qh0Ctv
         DqHh40iGQM2At25ttlGa9fU7aUk2UI3PQoZTedLbvLMlatFgdRNIDG+KFzYBRyAnB9
         4PAl67D7HEG3D4Kh2bLJXbhAgxCGzyCH927wGuDuOJjD0I/WCET01ltkycAP2CtNdq
         ouCUHsCs7W138VACWSR9b1KOXTEl1v1odX3EXhGxnw1DXW+brKILZm3nbbC4rdMMxa
         CdA3it1J5E0pQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 18:26:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.11 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.8:
    14 builds:	14 pass, 0 fail
    26 boots:	26 pass, 0 fail
    60 tests:	60 pass, 0 fail

Linux version:	5.8.11-rc1-gf2ae9d9cdf48
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
