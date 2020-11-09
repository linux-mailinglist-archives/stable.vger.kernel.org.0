Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6DA2AC00D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbgKIPjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:39:35 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14938 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729845AbgKIPje (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:39:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa962bc0000>; Mon, 09 Nov 2020 07:39:40 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Nov
 2020 15:39:34 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 9 Nov 2020 15:39:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/86] 4.4.242-rc1 review
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b1ac1066f30f4aa09c60300999aea039@HQMAIL101.nvidia.com>
Date:   Mon, 9 Nov 2020 15:39:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604936380; bh=BhI+BcXKb1HwmSH0w+KlazMxRK9qnIROusq/GhISLwc=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=oASNpiSbSA5i4MYB3i7lUC1iWl3l/dg2uqMPOxKGMWPsLvYZwfa6wiQgLAfXEyXy7
         aVJmkhY+m9fV5awLRga4O8KUTbMjI5wqIgVwrrmw2T0Q0RzM+p6oZ4/iAh/7GbQ624
         WzlhDkXgRO/ev8WZaObwAx/VNIun9nTXkyr+n3iRfAdGaXT9FwGxX7bTOTFxg5mEKA
         MvUKkE15Lgbt5YKQyQfpu8nj/++3ReHXYtlMzoyM5K7YZ5B97v5B+Whevijb1Z+RYz
         F7hkZIVlFmZ5ZqR+DJ8QowKeMvqQEat2j7VcJm711xyN7IjY3ogpp76M8HYWNo4IrS
         CKdBoNuhHTnSQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 09 Nov 2020 13:54:07 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.242 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.242-rc1.gz
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
    6 boots:	6 pass, 0 fail
    14 tests:	14 pass, 0 fail

Linux version:	4.4.242-rc1-gcbe5dd8b3604
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
