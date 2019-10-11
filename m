Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFFDD3B33
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 10:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJKIdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 04:33:23 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14884 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfJKIdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 04:33:23 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5da03e540000>; Fri, 11 Oct 2019 01:33:24 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 11 Oct 2019 01:33:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 11 Oct 2019 01:33:22 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Oct
 2019 08:33:22 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Oct
 2019 08:33:20 +0000
Subject: Re: [PATCH 4.14 00/61] 4.14.149-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191010083449.500442342@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <fa909a7c-70d3-c1e9-45a0-584b2c8d0732@nvidia.com>
Date:   Fri, 11 Oct 2019 09:33:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1570782804; bh=BK4Vx06gW4Dt0bUV1MaP4NBOPEX3gOTzi8e/W6roW0c=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=LYPoWSg7Eydj9Lq3CIjDV0qbws38QkK1vLbvoZMys25abHRix/qHFH7aPpN4nI1EW
         s1Nko0NknXm6G/t0z/LbxRQSF/3pSoZ04By9si7gPMSPG1nTcG7GLnJVldNUAlUu+/
         EgxBNMvttvYE4YnGwRFwxoPTT6ag9jW3Ww6+4+cjJWTIpWeZ10irIcnXQPutTRhYWr
         I//Yf6GSfJo/zqy8G9GnnB3+N3A5qu/UvGyaHrquziVo8uoH5KjKER7mNn06yt6OjV
         4WtUkGj5ECfDGkYwf9cOeAaWWrgUbTf6T0Vl+RITbCSvl22882dhFu+R6ZKxe/5zDK
         Uaell/eHZZ8Ew==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/10/2019 09:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.149 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.149-rc1.gz
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
    24 tests:	24 pass, 0 fail

Linux version:	4.14.149-rc1-g8952ae7352b2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
