Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5700C30146C
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 11:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbhAWJ7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 04:59:45 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5866 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbhAWJ7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 04:59:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600bf3680000>; Sat, 23 Jan 2021 01:59:04 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 23 Jan
 2021 09:59:04 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sat, 23 Jan 2021 09:59:04 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/33] 5.4.92-rc1 review
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d3ee21664b5e4a9b8e63e48db33d4042@HQMAIL111.nvidia.com>
Date:   Sat, 23 Jan 2021 09:59:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611395944; bh=TccoXMm+0oeiW3Pm93axK57lQg8EfFR559pXqyOSaG8=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=mjr4QM3w9ei1ILGmPHVOwRbw/TCoKA8/RwLezRjgkhg/WKhQsqg0ZJ9sszj+mSH90
         yogEOKIDetFb2HTBeTgqlMcQL6syLxljGr5UyMjtU/LCVRhIiPT8GliFyAWfuKhPLQ
         l/GZ9O+ORa3qA75PvuEtFiGPJvERFhXISnwXR4VKNVKACtdd32RCQOr8k0vrRA6MyA
         kMrW3Rqk9Luf3lS7utAv8fNrxv1QLeirOXHBq4Etp0xZsaZ3Babi/1vNpYYiX8e4Pr
         yfrDGSRFKJRMPNsR6Pxz2rRbnoT4fOrv+cUhpAJ0E/YqUTRB0ibkI6pKs9/+4AnV30
         YgreEdUn2b/CA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jan 2021 15:12:16 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.92 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.92-rc1-geb6c2292de97
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
