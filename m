Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A3E1A78B0
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438577AbgDNKoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:44:37 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13962 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438564AbgDNKoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 06:44:17 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e9592140000>; Tue, 14 Apr 2020 03:36:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 14 Apr 2020 03:36:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 14 Apr 2020 03:36:17 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:36:17 +0000
Received: from [10.26.73.15] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:36:14 +0000
Subject: Re: [PATCH 4.19 00/54] 4.19.115-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200411115508.284500414@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <396b60aa-4321-d45b-a7d5-c3c5ecfdf16e@nvidia.com>
Date:   Tue, 14 Apr 2020 11:36:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1586860564; bh=BoJcnr2PrBbH7Cgh8hHbvIL3DbI5+hxlaJeBmc9OOdY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=C8bLlJpt06J7EoH9AY8uXfl/DX+FSLg2wzZyL7+0iDnlMT/JELjbm2+I94G8PdU/z
         GM3Pd8ZS5bJYqLnQnw+444xhIrAMZDelfC3n+JJE5us7c4yg32RwScN4bOfjNeJqcD
         AXSplTgBKVDV0b0jqci0+W0CzhJQsKIgOtJKLPlEmklyDF0hi3vT2LGQlIBg3njpDL
         yGtR/531uT04rR2N6XzF4L2HRnw58oe1yzS+RaZYW1QRYD2VPnh2cuyAhY5t9bjtvb
         q2PuMcOa7EN08k4VMm5JxVb7HxdFzOvKhDDeVb6zLZvmiqUYVeZDMv4brTVljzeTeN
         jpp9hBPgBKrwg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/04/2020 13:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.115 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.115-rc1-g3b903e5affcf
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
