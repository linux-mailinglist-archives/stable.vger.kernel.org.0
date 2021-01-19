Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813FA2FB924
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 15:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395411AbhASOS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 09:18:26 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12045 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389820AbhASLwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 06:52:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6006c7e30003>; Tue, 19 Jan 2021 03:52:03 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Jan
 2021 11:52:03 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 19 Jan 2021 11:52:03 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/152] 5.10.9-rc1 review
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5ccd28b1256b45b18e8bdfade7f8e210@HQMAIL105.nvidia.com>
Date:   Tue, 19 Jan 2021 11:52:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611057123; bh=jAMCzCYs3b1Rf6ebped2qephrq63Ufby2YyCEHwb0q0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=QPJZ95KheGvzF0VySGSvqOvQ2TdOnhcLkQAgnZukB7w+sbwPJ8Ap1Bu5b5kUxsejw
         obgZFN4CdAz+wRdZ4lkJbSMqvriqWXr3+D5aGIvydm9MhM0VwYKQsxCacjl3wmr7QZ
         sGF0BEhH027lkkTECda7j7oSDoY1hDqOb2q3JUx2zDZipR+fyhjFECqhe3tJSqf4Az
         HEXT8zl+7ZyhioKLE+TrhPsQQy+IujhYvPhX0Pt2XC9HrMa2B780o54GTs324OOajJ
         C0Yp+dQZeudJtM71fOdrXrrwErAiSxhY5lZBSnMdKDMQSKNhx9JntKVozmCnV3KjBL
         Lt3OwVUJyubuQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jan 2021 12:32:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.9 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.9-rc1.gz
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

Linux version:	5.10.9-rc1-g293595df2bc4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
