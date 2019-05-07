Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040BF163E1
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 14:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfEGMoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 08:44:08 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5119 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEGMoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 08:44:08 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cd17d9f0000>; Tue, 07 May 2019 05:44:15 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 07 May 2019 05:44:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 07 May 2019 05:44:07 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 May
 2019 12:44:05 +0000
Subject: Re: [PATCH 4.9 00/62] 4.9.174-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190506143051.102535767@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5e60aa52-9f2c-6ad7-deba-2eabc62e3a09@nvidia.com>
Date:   Tue, 7 May 2019 13:44:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1557233055; bh=99W7NoGj/2+MpnAHWb6Rwi1DR4t4YhmB5sC2H0ZEc4I=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=YEAFvQPaQ+I0/e3AoFMJfackyq8hkXtxAQGre5EOP9z/pkOvZbQ1B1A5GgJmZNGll
         dSlTqSsHxUzY6hTVV9UPdmhY3so1TgLBdDJNtZc4mnHsDQgQrjg66WlwcYc6JQzMuO
         mZJAAcx0bMgLa7EBPULHDl74gRWareVParCRubu0BMGDFiEkRXrXD+enPvZOj5dEqs
         E0GZqj9sGVRzVI5ZtfBy+wKqBi+5EE8aQ/DK70PdFQF+mi5/89zuUtZdr+HEnBy3Nf
         5K3FXURHNLY6gdpU2r8+883Sioa3R0KrDtnAIayXg9IRRApMFlbuQ9Eke5u3xY0wYS
         1FSGK3R+QaFgg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/05/2019 15:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.174 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 08 May 2019 02:29:15 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.174-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.174-rc2-g43d95ff
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
