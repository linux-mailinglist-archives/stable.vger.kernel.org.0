Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B0D273B1E
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 08:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgIVGqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 02:46:06 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14320 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgIVGqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 02:46:06 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f699da10000>; Mon, 21 Sep 2020 23:45:53 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 22 Sep
 2020 06:46:05 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 22 Sep 2020 06:46:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/72] 5.4.67-rc1 review
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c164394252f84e72881369d762c2dc50@HQMAIL109.nvidia.com>
Date:   Tue, 22 Sep 2020 06:46:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600757153; bh=gdrpcO/8VtNpKBfX7bPebSkjPW8Xx8jnSp7ZI9OGW/o=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=V/IMjSQsoZ91XdhMNVXrF65mJxh+VugtH49UikEVE5ufQwTfb29XuatsM+bgDU9ax
         9TmoGml+Zn4Ridcvj1N9qVTIgjp8cEuw5d99MtbrcHFMCbcVStwCAxdJjsczqNq7qK
         kix8KUuCkpBQXY7ghrv+Dz3ch5AlLdLQTC6WZOUe151qSfD2b/VtWbZVvSE/O8EIA3
         ROeTmLt41nGDxCHxuOtcqrbn2/r8IlmHG4A94aNTkOQ3qjcucDhBHmW5Y7OHs7j/BZ
         2ETGIo0xhmoGKOFkaf7H2UHXPnVFBN/64ejXau3Zo01BWZ7JdeOz8rLwXxK5D4hl1Y
         f8kYb5KQN3fvQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 18:30:39 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.67 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:31:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.67-rc1.gz
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

Linux version:	5.4.67-rc1-gbe4995216657
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
