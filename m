Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8AD24BC9F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgHTMuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:50:04 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10592 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbgHTMtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 08:49:50 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3e71330000>; Thu, 20 Aug 2020 05:48:51 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 20 Aug 2020 05:49:50 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 20 Aug 2020 05:49:50 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Aug
 2020 12:49:50 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 20 Aug 2020 12:49:48 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.8 000/232] 5.8.3-rc1 review
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <6c4e3ea709b14481b274c8d883d5ac65@HQMAIL105.nvidia.com>
Date:   Thu, 20 Aug 2020 12:49:48 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597927731; bh=YdEaY9eM3R8D4B4dlc/YcP/k6xEuh7m4JwVW9Uu5UDw=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=YaSUq42WJSPzQhIJgNVuSrGu8uTKsi5o4aTdq23mzR231JB3c5Pt8Uuz+REGH38GV
         wWarv1Qc5X3abmo2ocVR5gd3ROBV6N73KrmDCEi3W4qTGDzGtONmH0RTMzIVSLcxOS
         TLAq8sLfqjZjQXdH/D88Twt/jMUd+tyB+2dEfhe/H0NvHkybsRHJVuo0NphNLyCy+v
         TcMPXWIc5SrEZaqyuBIw8CdAuwzc+WzoSo3mC0euDK5VjkPiuG0LyC6b8W5WFesYAu
         opZUlptxDLF2GfK0rb2WHA7G0zhUEBr/oaOPItVj2iIy9w4loZw1amA5uf7Y5p2+Xk
         6aU92neLWre1w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 11:17:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.3 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.8:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    60 tests:	60 pass, 0 fail

Linux version:	5.8.3-rc1-g201fff807310
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Jon
