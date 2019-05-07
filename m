Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A42163EC
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 14:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfEGMok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 08:44:40 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10507 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEGMok (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 08:44:40 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cd17db30001>; Tue, 07 May 2019 05:44:35 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 07 May 2019 05:44:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 07 May 2019 05:44:39 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 May
 2019 12:44:36 +0000
Subject: Re: [PATCH 4.19 00/99] 4.19.41-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190506143053.899356316@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <53e6c4f2-5088-f8fb-965f-0d2bced2a3ad@nvidia.com>
Date:   Tue, 7 May 2019 13:44:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1557233075; bh=kWP5cVdlYzlkZBN+RhlOTtb7Zu9iY2UKCpMWCNnHKO0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=mjOrXi/xWOd10AwNg0stZPrjZqXwQTP23Zk6m2XbUG5xBxa7owwCaBNwnprLKp5a2
         dFVsrUmNaZryuIhxUaMxnu86eH2D/J5zgI8LNFBrd7KWRZM5FmpJFbdaBH2aVJRBdT
         0qeovigzod+UCHhbPXTIN6cIXX6MgGQkcsD6AodAbFEPDw2SrU05yHJ2E1he47/Tbx
         K68g7ShgX1xk0//cjYzjNoSmeA3AdDN/xu7YTV155IsC5bpAU578aNIVkvtDAuDXHY
         5EvIe3z44JK2GwpdloPQ6jCgaCo2r6WNhaml4ChcGlB9GGFgN9Ur6L1OKvqOE7ttcv
         bqOyP+5nUNj4g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/05/2019 15:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.41 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 08 May 2019 02:29:12 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.41-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.41-rc1-gf897c76a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
