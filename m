Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283982AC010
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgKIPjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:39:52 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14957 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgKIPjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:39:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa962cd0001>; Mon, 09 Nov 2020 07:39:57 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Nov
 2020 15:39:51 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 9 Nov 2020 15:39:51 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/117] 4.9.242-rc1 review
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7a5ecdf3d3da4b8c8af4da14975b0789@HQMAIL111.nvidia.com>
Date:   Mon, 9 Nov 2020 15:39:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604936397; bh=yW37J29wHHjzn3P78WU/ODoEP3TKhbaSBx1PFqrr7Xs=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Do8jL602T+62zpNhPshXpOEl4hio2V90UjkOzsXZhrps6nmwXt/ZmU73gL78IR2SV
         j87AoTGIcqQ/xEYarcoohotgA32gRnXVUbR9C4/VdY2LVb91CBSv9tLJd0uiPcpRAc
         6+pJzI5WFntqS/W6EzQThOb3f6AjNg0DAg+v6y5UnoxTNfNvbvDiOdVsqeHsMtsTQ8
         N6HWPmZkumHKYxIIIWR29adiveBxE0Jqe8w7KIdZonMEeZitu+FFfYXh5U2T39drCg
         EwVY+DI2cRf0A8/VQc+hKMXq7EHria8EZ2w9jlkF93peKa4knNGp1AcBCOEQOTys30
         ReDkFQlMzxsAw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 09 Nov 2020 13:53:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.242 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.242-rc1.gz
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
    10 boots:	10 pass, 0 fail
    16 tests:	16 pass, 0 fail

Linux version:	4.9.242-rc1-g8c35ccda0e15
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
