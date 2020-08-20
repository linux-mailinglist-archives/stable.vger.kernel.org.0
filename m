Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACA924BA7C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgHTMJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:09:55 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4427 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbgHTMJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 08:09:10 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3e67ab0003>; Thu, 20 Aug 2020 05:08:11 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 20 Aug 2020 05:09:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 20 Aug 2020 05:09:10 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Aug
 2020 12:09:10 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 20 Aug 2020 12:09:07 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/149] 4.4.233-rc1 review
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <4fc7700c268547b98b246c7db0981b1a@HQMAIL101.nvidia.com>
Date:   Thu, 20 Aug 2020 12:09:07 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597925291; bh=thGoBeq76LfxuxdrjPtN8chojzu2uHy4lLhU70ggHA4=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=mHzIGCicHVV2zmcLBybeQbmmXKKwyApbWp7QloOdJJO6LPKsE5cfgx59ww+GMVked
         aNr+TDhIfdIJlAiVsQz4elQ04lEEYV1GB2d094hlEiwxplIamUzneHK1hUruKtfFfA
         erv8C15CcXDKTguy8ZxRnT4Oj31Ku0pRJfu9FYxEEDutz76rnf3snSV+/8MXUyPdLS
         hDwQfXBtmYQ2oGvE9jsacTMQ59QCq8H+l8Tx9Mr6BBAbvyzF0UV6n7G6NlYpTW4IZD
         iB7p8LY7OweA9zXbUHlMSBHOKxuVPJ5k/ITsAZAJFY0/ucbI3KBsvwiReN07Y6ZSkA
         Gm5mSylNsFOaw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 11:21:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.233 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:21:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.233-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    28 tests:	28 pass, 0 fail

Linux version:	4.4.233-rc1-g1c57f0a7ac38
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Jon
