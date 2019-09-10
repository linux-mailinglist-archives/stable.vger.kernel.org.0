Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DF7AE694
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 11:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389217AbfIJJSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 05:18:34 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3532 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbfIJJSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 05:18:33 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d776a6d0000>; Tue, 10 Sep 2019 02:18:37 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Sep 2019 02:18:32 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Sep 2019 02:18:32 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Sep
 2019 09:18:30 +0000
Subject: Re: [PATCH 4.4 00/23] 4.4.192-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190908121052.898169328@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f97b50f6-e5c4-7de4-3e2b-beeaac184be9@nvidia.com>
Date:   Tue, 10 Sep 2019 10:18:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190908121052.898169328@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568107117; bh=qJDUkPJb2mRPZbtMz7qKxXKPcoI7CNW+AGNQ3wuxp3c=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Y+tpokf8o+SEDBfF2u9ej+klbuqL8oTn7jzdySS3ospX4+DoHmiEUXYazKj/H+Zxn
         x/U6wa/CTLJdmza/v9adccFvp1w45tQWD0Ieafy95X5GS0PSgBlfbAbn6VWUILSEGZ
         JlQcmb67uyLl4LQOIdrQtCvTl1lh/Uu5dHACvNMTG5wx5j/txLd426QgbLAoaLph5g
         0PBUsF7qoN7sXFH10bS9gMZ5ZArPAHGmY0ioJI3C5j02pQRX6B80hNEnRoBrd4Xcxi
         QUCxF9gPtlQs6nuBKCpFzCuUTkAKv8T/dNrRQPpmc9Ve4tb3wQQNUc9qCRIT5x7PAG
         rQTSus9g5urgQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 08/09/2019 13:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.192 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.192-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.192-rc1-gfbce796fcbec
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
