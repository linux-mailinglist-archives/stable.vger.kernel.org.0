Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5151B58F5
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgDWKUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:20:31 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13709 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgDWKUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 06:20:31 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea16be20000>; Thu, 23 Apr 2020 03:20:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 23 Apr 2020 03:20:30 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 23 Apr 2020 03:20:30 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 23 Apr
 2020 10:20:30 +0000
Received: from [10.26.73.193] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 23 Apr
 2020 10:20:27 +0000
Subject: Re: [PATCH 4.9 000/125] 4.9.220-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200422095032.909124119@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0ed825fb-23a8-c13a-e43d-cad72c30eafa@nvidia.com>
Date:   Thu, 23 Apr 2020 11:20:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587637218; bh=Yv3wUjLY8G63J4qeeE74s5ZiPcWBE9HHZLLy8LYTXhM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hHNS5AiiHmZffLrUuiiJp/dMx1fyw4zwGhklvuElQZO3N57AFGvA6NcLGv7if/bxM
         FeVQCKCP55F6PN2MXnUP/NESL79C0G5k8I7SAwXx2sy2tFWZ3gvgk5EgIvaMyRG7v0
         sBPqqsRN3kXt2qO32IGDler1TIilN5/lyAbl2ifHGmYIZ/ZL5ndjS2OdlVuUwvad4E
         7RTkNapLBmNhtvqAxbalVFR2iJ6QSwh3Sy4WLCEdnFoIfB38Tc/ylS9Rnx4UAj0iSH
         jwiaKO/5QK1bSavHgTNhT5VKf9BzzBwF4X1YnKyej9HOPHajPYB5so5y9Tour1/J3t
         Rhi0mvjGfSroA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/04/2020 10:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.220 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.220-rc1-gf6cef26090da
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
