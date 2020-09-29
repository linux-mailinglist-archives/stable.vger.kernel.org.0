Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28F827D283
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 17:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgI2PPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 11:15:40 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2911 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbgI2PPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 11:15:40 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f734f370001>; Tue, 29 Sep 2020 08:13:59 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 15:15:39 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 29 Sep 2020 15:15:39 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/388] 5.4.69-rc1 review
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <40a13a7036b0484eb73cb55b8754f74e@HQMAIL105.nvidia.com>
Date:   Tue, 29 Sep 2020 15:15:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601392439; bh=GXM8LXpDv7N89zCpoWLewb6NKzGPVQNvZYzppZ4s7ys=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=M3ugajcY1K7f+uaJ9dLZyf2IwT3W6lnktgzeyGKF94M013HqkUUi4BzePUGINNXyg
         oBCWL1VWexu8Bl3R+E/Z06aCwT/y8OEFC4NMr4FvrxkbESitEZ4sB0293BX7MgDq5i
         YhXwLiC6TKYJlZhXuK+fz1bd/A2ot1vScGAiZ52EeMnDCkRtpk77qqiVniaVFrUs4+
         R2tlAiqrMtaNDGQ4PMskNvw6gHvb9B4jX/Z3YHrv5U0UhRQDBpWCUUg3oseoWZJyLB
         ix1EEzYI/iO5blA5V196e+wZbhOQDpHZAgQUkJ0QJcBMD9a4CmiBPYwGR+yIKHxoJd
         RFouzoU2SKKbg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 12:55:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.69 release.
> There are 388 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.69-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    14 builds:	14 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.69-rc1-g256bdd45e196
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
