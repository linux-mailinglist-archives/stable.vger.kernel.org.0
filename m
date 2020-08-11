Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B552417A6
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 09:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgHKH4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 03:56:05 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11132 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbgHKH4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 03:56:05 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f324f070000>; Tue, 11 Aug 2020 00:55:51 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 11 Aug 2020 00:56:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 11 Aug 2020 00:56:04 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 11 Aug
 2020 07:56:04 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 11 Aug 2020 07:56:02 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/48] 4.19.139-rc1 review
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <7d75d490b4ff4513ac0d9dbeb167532d@HQMAIL105.nvidia.com>
Date:   Tue, 11 Aug 2020 07:56:02 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597132551; bh=YG/+swQExQULGx6223RTBGGDK9PODesTfgYs7G7X77U=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=UunPB2sq/Kp2egfJHwnVmTUdfi/5UgZoiWT0a0a9jsp/cCmJY/pcCsLEyz/1x/IXc
         iqzDWTFazWrF4+4TwMNMxiDUmZU+QB0fiL9AyL6Vp2ZNIidW2sGP9lMP0otX4QTJfA
         vECZjMg4JHyO/P/Y8oyv2x23x5Ou1JQcqcgrJdQHLkNAKdCEg6cdkMFK7CroK0akiz
         eHgq5QMhG0GtYeGkcyHwFgHennwxwMQ/dQSB8yUkkCHV0uqLkvLlOPq6cWROIoFE+d
         3Vi4TzJAXfqMOaTmjg447LhfkuM3Hs2MbfrIZ+SHKMcSPFEhVEsafrX9AHVa/rRyuM
         rvfXt/3vTpiyg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Aug 2020 17:21:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.139 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.139-rc1.gz
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

Linux version:	4.19.139-rc1-gb0e1bc72f7dd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
