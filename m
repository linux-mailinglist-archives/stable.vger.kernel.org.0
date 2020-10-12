Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C962328BFAD
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 20:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgJLS1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 14:27:47 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5198 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgJLS1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 14:27:47 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f849fb10001>; Mon, 12 Oct 2020 11:25:53 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 18:27:47 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 12 Oct 2020 18:27:47 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/54] 4.9.239-rc1 review
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2387659d6cae4daf973ba4ca3859cc81@HQMAIL109.nvidia.com>
Date:   Mon, 12 Oct 2020 18:27:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602527153; bh=fxKykNoHbsxEHMC7CmzPQqGCP5ljuFre5ZeT2epq4G0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=V9eyQIWjMRpbLVHryKu4gT5tqBgv6HHEdxiKJ7MbH7vWOpxBr93Gvuhu1rrmKlO/l
         yYBD1vr5N84/vP3m1++9omKN272Tjg1hxNNIfSq+WtwtCFUvcYrxp3sQRrqVVHOemk
         GUCWMlaEECmoyZ+wrfvrsv0Mzubl7cogjPOoZjb7K62dEgTpmwXVOhjUh02+edskGL
         be1I44ewNkoIeEBv/dgCM084iJ7/JuoiOQZmU4DhmsYAHsM6z9B9Q/0DwXPlb1PaEk
         RfXOLYxxT6APAQ5ABCv+hEEegJXXWu89eYnYpY9qjgFmuMG7InsyrkQSEbqlc19D3a
         XH0nDmTu6hMKg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Oct 2020 15:26:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.239 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.239-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.239-rc1-g132affe7fbd6
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
