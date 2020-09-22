Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD20273B25
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 08:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgIVGqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 02:46:20 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14370 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgIVGqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 02:46:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f699daf0000>; Mon, 21 Sep 2020 23:46:07 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 22 Sep
 2020 06:46:19 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 22 Sep 2020 06:46:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/46] 4.4.237-rc1 review
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
References: <20200921162033.346434578@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3cf96c7d11ec4209b090c995043ee92c@HQMAIL109.nvidia.com>
Date:   Tue, 22 Sep 2020 06:46:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600757167; bh=a/HoP50si4tsfKKJxxyM5kTu4N9lzHNGUyZW8i0Qsq8=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Mecgh+DwNW0exXUVNF20CIWAzIHpV45hnX/Jjanb1/l1jDGEiN1iB8jDQGgJhk2Qy
         QZ881UuTPZ/q5uUMN35vPqFDnQdyzzy8WRXzIQSZHzmgur5TtM6y1SB82w6f/nDFyy
         he83XSo/yvBZtoInQejsm6NYISx/vwf2mrJjA/A1ljbmeHFORsfZcXpvokZz45Q2sB
         zNBahG9F1eoG/p4kzGG7m0HA2cVoSU6UNwCQJ3ZLeqIF8sWQBC+nJnXomajUU/kp3i
         9npz80lwoK53m9dkGBwyY8dULgdKbSmbzaL/TVd/ep80NQUwaSRsShXdZDgT7aW7A2
         Sq7MlGfGn8XBw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 18:27:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.237 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.237-rc1.gz
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

Linux version:	4.4.237-rc1-g546770fa5bdd
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
