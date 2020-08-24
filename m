Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EBF250728
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHXSJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:09:13 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12240 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHXSJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:09:02 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4402000002>; Mon, 24 Aug 2020 11:08:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 11:09:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 24 Aug 2020 11:09:02 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 18:09:01 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 18:09:01 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/51] 4.14.195-rc2 review
In-Reply-To: <20200824164724.981131044@linuxfoundation.org>
References: <20200824164724.981131044@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <2034b0ad99b8420a90783f95698c821c@HQMAIL105.nvidia.com>
Date:   Mon, 24 Aug 2020 18:09:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598292480; bh=5aBCPuTDTaJlAVgMYnagUiCmr+qW1InnkXSTwgDhIFk=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=KIYBAELWi91gqsD8IOdmNpVgBU8/ZKKhy2Fplg6s86Snd5/MA7qKaNw5PvSoq7uz6
         qYqw/ivI55WYj8L2+A5s/ZD+NxDs8FPapKYyyYsjHxZjqdEJi1UOseyyigU4RYgxWJ
         05lDDG9O1tbt89e7q+YZsENqQuXfNqr54ahQb4ihlUTWQz7BByDpVnDwNpRSfNSYf+
         vYg73phLeMPjG57xs6h/q4+J0QcIfSQc/QgCPrEwb1Ioo5wnCt0ECQp3iNSoY2o1Qa
         E1yL50V8XBAx5n8zSR0G3ch0jLVDqqtRuFV/vgIflsJhkd+31lxbAN7euYyHBdggjG
         ZHdN7J/PhOCVQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 18:49:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.195 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.195-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.195-rc2-g376e60828efb
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
