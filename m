Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6223D234648
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 14:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgGaMxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 08:53:10 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1993 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgGaMxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 08:53:09 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2414270000>; Fri, 31 Jul 2020 05:52:55 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 31 Jul 2020 05:53:08 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 31 Jul 2020 05:53:08 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 31 Jul
 2020 12:53:08 +0000
Received: from [127.0.1.1] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 31 Jul 2020 12:53:01 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/19] 5.4.55-rc1 review
In-Reply-To: <20200730074420.502923740@linuxfoundation.org>
References: <20200730074420.502923740@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <92ca732f3d9841fca229544fc0638f90@HQMAIL107.nvidia.com>
Date:   Fri, 31 Jul 2020 12:53:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596199975; bh=vJaZ4m1RAR61KFuYnUIjF0IoucFXg2rEEqjMGKsWyuo=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=U2KRA3GBF6jx2Irp/rmbr1h8dczWYhCUUwXPdUUz6P49E1KaF9nJ0NJUIUggaxBnR
         HRC/Wg/oZehjyBUzieL4X4fxXaE5kBxIV6C2pI6zY/puuBlHHFoWB+Kwk+CD5PBeRn
         Hpo0EEvXfmKWiOqm/+yrJmSuhEg7njj81q033xy49Uhe1UlniF5c3Nts74bV2X1iiR
         5lVmZSDtS4VVM5ljWsfzFBo/RiB1xsOBI/L/stbu7t7GLfBxj4DFj8tlqX8pPrngSi
         xdMiMp51OPGrKwseK4cincx5uHgg9lcRR5T9TCmqk+wy3X2flgUu68XxbG8EZYX+jn
         u9WjNXK+9TZsw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jul 2020 10:04:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.55 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.55-rc1-g6666ca784e9e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Jon
