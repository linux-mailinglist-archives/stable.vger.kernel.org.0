Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D492507C3
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHXSeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:34:46 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2652 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHXSep (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:34:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4408360000>; Mon, 24 Aug 2020 11:34:30 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 11:34:44 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 24 Aug 2020 11:34:44 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 18:34:43 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 18:34:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/34] 4.4.234-rc2 review
In-Reply-To: <20200824164719.331619736@linuxfoundation.org>
References: <20200824164719.331619736@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <389096c398024a9b8df359bb0864e1d3@HQMAIL105.nvidia.com>
Date:   Mon, 24 Aug 2020 18:34:43 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598294070; bh=k8fkdxVgCEO5zBklbLP3cckHN8jUlsuPTeGHwhdl1U0=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=lGgrEk4iTVWl1ivOnrjtqDclTEry4jJu8iX+PcLhZBafXyPRvPmxHPmRnybRFfl7j
         gcI/6XqUouIeE8DSu06azV92RDxisrzNg8KuFcYwSmRmdWPb8brHkgMc597vjelNRr
         UH9HC6ARk1rIsO4e7q8OTtqYccBstNCGlfi7/ZHA8cNN/tfkZ9thJ02RdSLP/1pKH8
         HFYg46l9HS3hnFMMNTBl2KuK2dPxXzWkpKaQg1XZQMGj0c7Ht89FdZetGkxaux8yfs
         qbXABxBypWniniWzhQ/m+t6BvfjqdC2JojcEPrAj90OSYoev24LmkXIeCcpIRgOoOi
         Jzx90onTsbE0w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 18:49:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.234 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.234-rc2.gz
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

Linux version:	4.4.234-rc2-gf607f7ffa21b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
