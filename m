Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595C92627AC
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 09:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgIIHEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 03:04:01 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2851 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729005AbgIIHDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 03:03:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f587dc70001>; Wed, 09 Sep 2020 00:01:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 09 Sep 2020 00:03:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 09 Sep 2020 00:03:42 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 07:03:41 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 9 Sep 2020 07:03:41 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.8 000/186] 5.8.8-rc1 review
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <71fefa0c8e26421ba1ae3619108bf836@HQMAIL105.nvidia.com>
Date:   Wed, 9 Sep 2020 07:03:41 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599634887; bh=zC54vULAtgX8EJTD6PPnmlQJz+t1V8c63W5123IYcOw=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=cdo1oMPWQ0Xz/ER6+SIdfdOHo07EDnJ4QOONCw7qiHu0PRYNozcTDFqNcAmHAHblr
         vEubzPZOrPCYiYT664YgZplayJxdwmmaTiPjKskIMk1EwbGrfiEVinpDaQb59yriW8
         3HrspfFEWoy7JR/0fBpVoACI7M6G4UWA/rygcMxdCAEgwucRxQ8buDdieJBgNuvr19
         a3Hh1al3XRABm+auVEj9fVrdOhsPEb+Iq5jrfa3lLieGKodAKvima/z1IoyEROYd0a
         f39xe8EvKjM3v1L8kcUaLHeaLaiKtweHLiDKECQKFZjU/1QTtA62yYHFNY+gGLfyJN
         iGR36AiKUF5jA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Sep 2020 17:22:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.8 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.8:
    14 builds:	14 pass, 0 fail
    26 boots:	26 pass, 0 fail
    60 tests:	60 pass, 0 fail

Linux version:	5.8.8-rc1-g456fe9607f8f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
