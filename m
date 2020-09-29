Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0A427D27B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 17:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731253AbgI2PPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 11:15:37 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11579 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbgI2PPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 11:15:37 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f734f8c0006>; Tue, 29 Sep 2020 08:15:24 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 15:15:37 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 29 Sep 2020 15:15:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/85] 4.4.238-rc1 review
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <423e3889c50848979fad9e67dfd88947@HQMAIL105.nvidia.com>
Date:   Tue, 29 Sep 2020 15:15:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601392524; bh=m8z3o0Lb1G7cUHmS51Lpfnxt2Has+zA85O3HarECSpg=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=axoqVuOq7ZVCn7uISulmR2omxtENPgAWObT9gNZHipq0rG2kSaFQcmFHWPiGd/Sko
         DZqnw6dcUnA3apr8jpYFTBE5ym05rT9ZvSEBE+Rg2nt6VVVQ6YaZxMJlpipADcppGR
         W1/GzzNZ8CqZH3vU0N7DwKUX1ncG5wrMnK+Mg2+EaHvKzqcrRpTlY5PIsSqPh9JnxZ
         MKuwWkLAwI4PdKrtzZTArG9MvMpp1OWDmS95doIeqcEiTbG0x0R/OoW3mS54vSkVkF
         SH1TAIONDc/eWJtUvvcv4rSZ5IrowiFpvoD1wcKxtli5olZlTJNOPGA127gG6oW4Ho
         4Fp0oukA8HEDA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 12:59:27 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.238 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    28 tests:	28 pass, 0 fail

Linux version:	4.4.238-rc1-g0d240bae7702
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
