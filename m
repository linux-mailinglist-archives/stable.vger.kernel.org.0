Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB652CA40C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 14:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391112AbgLANkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 08:40:10 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18618 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387823AbgLANkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 08:40:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc647910003>; Tue, 01 Dec 2020 05:39:29 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 13:39:29 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 1 Dec 2020 13:39:29 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/98] 5.4.81-rc1 review
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <00d793454af6436787feee552380f957@HQMAIL107.nvidia.com>
Date:   Tue, 1 Dec 2020 13:39:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606829969; bh=ZfMvdL1FTzLfVX4Fu+SV0DLvKV+fVV3w2FJhYGyr/nI=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=S+DLLSLDKyvKfjxL9oanHhL13frp0kzBq5cWQPEAaJW9QsACAaijA+lbebuJBRaZA
         sHjoAdCRfC4FLzUA3WNe8nDfPdZWUfgLpFg6dUhMLj/PdCNNlZYdopXY4Q1XwSNhk5
         aKuXif0nrXpR3C68F+AEhJlyXlT3E7WB82utuGCoKdF6M8foFPRBcLMB9QlZS9tRpP
         YjhwmHmyriEdnpQSY+7828K9i/UHkEpDsJ8RDToqtSdyVJBrC3+sCYq3vWbMiOtgGK
         2kt1y1hQS6TruB41eshriZIn0gvRtwqWL4E5ySeiK2xVvHpAsuTVK1/nYLCmzEUnH0
         o1vv2FkMdaBrQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 01 Dec 2020 09:52:37 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.81 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.81-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.81-rc1-g89a0528bfd8d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
