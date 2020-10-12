Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AA728BFAF
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 20:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgJLS1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 14:27:48 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7119 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgJLS1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 14:27:48 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f84a0170000>; Mon, 12 Oct 2020 11:27:35 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 18:27:47 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 12 Oct 2020 18:27:47 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/49] 4.19.151-rc1 review
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2c309f30ccd449d7836b6e8582b75197@HQMAIL105.nvidia.com>
Date:   Mon, 12 Oct 2020 18:27:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602527255; bh=UnBl9Eg2eYGZq0T555D2QrH7At8JfpRrUOSbLqdC4GY=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=BwnqDmkwuyMEKlcJu30QLLO5kUSWVjs0zfrvytX1YJivok2lgwkATS2J4Lm7ByIi4
         d7Dp87jImOfmg+E7820T229o0MCJhCXS9blAJSDGMG5wHlw/3pj/rAbl8+cSoH+r85
         TxdUSFzOqZ0JUggNmIKO14I8DdJnrt0zgNUzLNdCDZIx6KVUKmP9K12unTns6eJR5w
         l/ds1dtOVn4uIbTSvpxfT3SF2syN01zZQEsJFyx20osIomx3t+V7bFeyzpqjoGAQx9
         P8jALK5BXW9iX7BDm7GCRbWbQUW2nhHfYcxhYWY5mQ1mQ89j3aWD8HnkBB6IAcgzf4
         E9PvbqnJTg58Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Oct 2020 15:26:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.151 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.151-rc1.gz
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

Linux version:	4.19.151-rc1-g7457eed4b647
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
