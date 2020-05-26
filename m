Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335031A78AB
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438562AbgDNKoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:44:15 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7494 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438559AbgDNKoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 06:44:11 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e9591ad0001>; Tue, 14 Apr 2020 03:34:21 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 14 Apr 2020 03:36:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 14 Apr 2020 03:36:10 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:36:09 +0000
Received: from [10.26.73.15] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:36:06 +0000
Subject: Re: [PATCH 4.14 00/38] 4.14.176-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200411115437.795556138@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <3c24966c-eb4c-d99a-67ea-d2592143100a@nvidia.com>
Date:   Tue, 14 Apr 2020 11:36:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1586860462; bh=3wwQdwm2zxXX7jgsDaXpMCfGRvIeeYiR991RevpkigM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=a7u3ZMlvkqmSlFqSEZovMc7q0NTyYcwvS9RSq/Wezc9+MZats9h5iDB3gFue3Z7w+
         TBFCITO6OCpFQZxT2tzgLwa1b5GXNeoWs30vYBekgg3jh7zPNhyY+cAn5VnYOckCmE
         HWXBx0POA9JF7AeFYDTwpTazsbBrGm/YSrR2ygDdWY7tOCHg3BeUbbmDpmDAIP62jb
         +gGB4uvk5r6B4FRD3LVSFRuGBvNMnKwSUWqi59zHZ1OfHlGNsCMzFrybY82nORuJeM
         Edy8Bl8+y+Jnwk+WVGzPcfQZW7F2ypukzUcX6CfnLn3Xq3k1Kflnc6foyonmTpBNLi
         5LSKk7RqmVKig==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/04/2020 13:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.176 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.176-rc1-g42fb2965c7ca
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
