Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08170250727
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgHXSJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:09:13 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18673 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHXSJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:09:03 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4402310001>; Mon, 24 Aug 2020 11:08:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 11:09:03 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 24 Aug 2020 11:09:03 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 18:09:03 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 18:09:03 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.8 000/149] 5.8.4-rc2 review
In-Reply-To: <20200824164745.715432380@linuxfoundation.org>
References: <20200824164745.715432380@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <0d2ab7718bfb4123ab6b26ba7cc99eab@HQMAIL101.nvidia.com>
Date:   Mon, 24 Aug 2020 18:09:03 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598292529; bh=CqBjrXvKsPYK7AYJ3vIc95zP/QU7lodhsCHMyRDk/xU=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=JDSUj5Q6HJ0O/SAU4VHnmPXC4X9Fb3gvtW1WzajULxAL3BBte9pEZXSjGb/PbNxv9
         W9xrdfJ7ySuSlIknpr8DQ3yxIi8X1PBU/rABIeATMxGsMl39bxuFh2OLsdXysQ0zLO
         AXDFeg7IGjQyT09NbDi1i/DRSCDrgod9ke/27cM8Lek7avVGlkmlUY03MH/bTUeKNc
         3/ACttpGWQsdUS87q+Mmts6J++zUhqMuOmz5EQLbXCxg35boTQ/MjS33F6GUsxY57l
         m1Xic3y/KtyG3m+j2qtwG1a7H/cUO258aHyaaHOZ9fqji7/jkfeXVvBSQJavXeMxpY
         we6VgFnVNrh6g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 18:48:20 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.4 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.8:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    60 tests:	60 pass, 0 fail

Linux version:	5.8.4-rc2-gff3effda97ba
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
