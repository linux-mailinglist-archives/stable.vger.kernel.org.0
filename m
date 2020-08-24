Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C41624FB2A
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 12:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgHXKRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 06:17:07 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10240 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbgHXKQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 06:16:50 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4393820001>; Mon, 24 Aug 2020 03:16:35 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 03:16:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 24 Aug 2020 03:16:48 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 10:16:48 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 10:16:48 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/50] 4.14.195-rc1 review
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <f5852c365eb44d27bd7404da5bd4e87b@HQMAIL105.nvidia.com>
Date:   Mon, 24 Aug 2020 10:16:48 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598264195; bh=glKHJT3ZzWcTqSQ+Xc1XHK7u9jGqJ4tm9SCI/ZZXvJg=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=YRPj31USapmYEC6ndutx9aup4ZAsbNq8r9BSFYMowtA5d9ufg2OOaLodn2uyoz9fL
         k13FVZQrcKaBr6fjApTC4HwCzwBWuRsSGzPs6v8dMBaBo42Q8QEd+rbtVR+xS8g4ag
         Ng7Bi/kutc2Fqzktbx0225azm6/d6dXe568GYm3Hb2bjUPzkccBs0Ylo0PneTgLMHc
         AkvoQKwixVaKBPoQT2sreREI4NX8RFGmuhdLsOz9RzoNznkNO8biKXyGCuuqdFMzAu
         pqzyia01KZRXIetd5mhdj//GrdKNEvGsdsDNXY9VRjXrh8cP3YW/BRNyUYPWyiseRw
         H6jyzthwc16Dg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 10:31:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.195 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.195-rc1.gz
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

Linux version:	4.14.195-rc1-g509a87150f17
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
