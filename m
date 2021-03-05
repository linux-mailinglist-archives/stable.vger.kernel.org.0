Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109C232F1C9
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhCERva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:51:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3053 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhCERvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:51:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60426f8e0003>; Fri, 05 Mar 2021 09:51:10 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Mar
 2021 17:51:10 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Mar 2021 17:51:10 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/52] 4.19.179-rc1 review
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c7a69ba0f99e49a8a435f450b9042db5@HQMAIL101.nvidia.com>
Date:   Fri, 5 Mar 2021 17:51:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614966670; bh=BIYINLAuEX6wMifsS/0pP/RERveb5GH32JkqkUl8lsI=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=n0v8G7FLBxMQhc9I8YFePwliYn61eBjia5GoACZSWYMsqCVCAXhsXSVmI/Ff3qX+D
         fr5pOLZ+PKDPasJOM/PGTfq9Rr0+fZupIu5tfnBCsvTgcTt7kiogBLALOW5epzOmVB
         yBz0uWzx+rty3tDBJHof8seZDlCjdAEUv+F9k3hRhyJyHYdKRcTohWsY+P0u7FRGQS
         Q1kECDm+2eTgxRJ7poNPyYrpP2seDqI6gEWCum5uONfMI4MlYcdGs0HhipxrD9wB7V
         6QXcKKqVC48PmQnNMccWUf/+IqP9/kXyqcU2SLjont9Woapmg/4E/pRaid2CTEW3Te
         sE0GUqERTVG4A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 05 Mar 2021 13:21:31 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.179 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.179-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.179-rc1-g1112456421ca
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
