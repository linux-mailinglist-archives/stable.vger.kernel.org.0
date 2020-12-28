Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4029B2E6C2E
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgL1Wzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:47 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9924 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgL1UTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:19:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fea3d900003>; Mon, 28 Dec 2020 12:18:24 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Dec
 2020 20:18:24 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 28 Dec 2020 20:18:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/175] 4.9.249-rc1 review
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b93419bf28af4b85b9f02a64878098a5@HQMAIL107.nvidia.com>
Date:   Mon, 28 Dec 2020 20:18:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609186704; bh=iuXQUS7FlUruadb+qiTp+WNEvakb4DwlBIbSHzEjM3I=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=DHGA/U5neAurCjPCDegzYub1cV0OMQLRd8POf3ll+vWxFsOgH3WlMiPjX90abdytv
         Yd9FfBWo8KnNy28scriFa1iC8wWmHVoKpEljptUTndIsVB6E8OkH7IBpeo7hc/p0Ij
         ES2bHKrtHoZZOjv7OO3gL8Dqeu+Hvki/j8f56dNOjSY9IuhHSkwPAv0Cg7fU/srXFx
         qBLXP0f0fsM8KD+lSZdckhwEUazX2rrBgeEBuFqmpJsQMzOl6QjmPE9WAn4Foh/Lpq
         odu7kKqRzowK4aG8c2KnOaRSjYBRYt0IX3V8XeMEq4RyxiDJ4HpHH37vv7x/mYq0sm
         SHA2r1D+FEMCQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 13:47:33 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.249 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.249-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.249-rc1-gcde5fe0304e3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
