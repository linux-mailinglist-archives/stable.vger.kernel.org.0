Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FE128BFAB
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 20:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgJLS1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 14:27:34 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7067 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgJLS1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 14:27:33 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f84a0090000>; Mon, 12 Oct 2020 11:27:21 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 18:27:33 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 12 Oct 2020 18:27:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/39] 4.4.239-rc1 review
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d839ba5b54404ac483d9e2b0b1e8da36@HQMAIL101.nvidia.com>
Date:   Mon, 12 Oct 2020 18:27:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602527241; bh=jwygHflDFho+TZBCetQR5o7CsOpYEh7ivNOz6C/HnFk=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=OPv6LFj8IdqMbKMetCK55sCkqvDCL9Y4Fj8xraXvT3reh3GjV+0lnJPZ341I7+hhZ
         U147k/hPiFoSwFebiOT58BEDzsTa5Zir4zd5NIMWtd6SJBITnxed1GYRjnombOGdUf
         7iS/Rj3K3t5Fi0ThtigSBucOfrPv8FJDl/8ZhPjO+g1dmPSKlArm3qHneJjVu2GbgL
         YxlLIwZxsYKwXBBNh8UxFXAofBDNIYAv4XddGqKIiRrN/suqVDLJrXJ89/5Ad2YeKe
         Ag6CSngrgcImZ3dLM3/yQ4Owc9Ss1caqfOK+R+sc8yxa3aQ/U0Y8ZG5aL+p6hm5P9q
         a933S/+piaPnw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Oct 2020 15:26:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.239 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.239-rc1.gz
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

Linux version:	4.4.239-rc1-g36437aaa5512
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
