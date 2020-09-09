Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320612627B2
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 09:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgIIHEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 03:04:00 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1035 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgIIHDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 03:03:49 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f587e190000>; Wed, 09 Sep 2020 00:02:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 09 Sep 2020 00:03:40 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 09 Sep 2020 00:03:40 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 07:03:39 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 9 Sep 2020 07:03:39 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/65] 4.14.197-rc1 review
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <8dd61140d73644059e37b5ceacad8868@HQMAIL107.nvidia.com>
Date:   Wed, 9 Sep 2020 07:03:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599634969; bh=tKlAotxin+h4pAjExmn/byNvi1oJ/xa3uF7fYSemn6s=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=O6D15XRQMGm+WSM6MLS8dbRo5rIC127nIpcg+loZ9+7IwjCkwOCRooT/1xC6LMBDv
         DJi1swcUXztnyRVx4raxurzGdVze5Xezh0MoC+aoQC3Uf9BlugPjvKbEjQ5UXZykkQ
         KxCS6RXh6ISh768I2hvHYm1tSNhcVdUDfBVT3/k2N98x2N2Pa5zslFwXGwoPBpzIyc
         bnu12J0Iq5cPdyqJ3+Db0i9codBpWhd5Lwl6tLgyKiOy/jEpTaDCulVoL0IaZ/JZ3m
         ag5aw5Sg7dG3txRR0Q0SELdzpOBsCB4auuB5BAaj5uQY5dbkCxgioKUacQpk/P7MHc
         YyODs23ubBfRA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Sep 2020 17:25:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.197 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.197-rc1.gz
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

Linux version:	4.14.197-rc1-gd520aac0cd79
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
