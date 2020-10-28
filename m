Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5689B29DC35
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390711AbgJ2AWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 20:22:13 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1417 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388931AbgJ1WiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:38:06 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f99c6a40000>; Wed, 28 Oct 2020 12:29:40 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 28 Oct
 2020 19:29:33 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 28 Oct 2020 19:29:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/191] 4.14.203-rc1 review
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2bfb427edf6340959a02c914587a193c@HQMAIL107.nvidia.com>
Date:   Wed, 28 Oct 2020 19:29:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603913380; bh=MqoeOyXe8jfv2hFd7q5UEs37Fe9cTZxINeAmIulh5dI=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=HYm0dVwWFLKLLhah5d389TM3cEeIjr3Y2NcnAxRsbcS+bTTv68+qmL30wl5ZrhS3R
         r0iG/K7lwtqdVn/ZN3NYaY6J92yfDd3Nf3Uwm99jtvEzjidfBgon4+ElX9OHDanO6d
         na/TC56Nti8Wry1BEv5ubS68RaGxBoFQPti9VVhYHDaN48rBXEeJnzLT577GXdbkv+
         sv3Zg9Zfb74JyCz4EzJTnAxvuHj5Tg598lxxpTATkYSVKKlKOR9q0lNgedgNIhafYQ
         WMnVIu4hCF1OhrooK1s9eCbryyTVWirDqVXgIjLmOtLgLQ2XMKXYnTeb3PtlEYkDyG
         XmsWMpM3oocJQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 14:47:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.203 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.203-rc1.gz
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

Linux version:	4.14.203-rc1-ga42f5f48c6ae
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
