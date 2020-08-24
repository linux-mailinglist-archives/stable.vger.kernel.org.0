Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD04250722
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHXSJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:09:11 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12223 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgHXSJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:09:01 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4401fe0001>; Mon, 24 Aug 2020 11:07:58 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 11:09:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 24 Aug 2020 11:09:00 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 18:09:00 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 18:08:59 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/73] 4.19.142-rc2 review
In-Reply-To: <20200824164729.443078729@linuxfoundation.org>
References: <20200824164729.443078729@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <d89ab8be152e4edea12bce82046b2b33@HQMAIL105.nvidia.com>
Date:   Mon, 24 Aug 2020 18:08:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598292478; bh=RIMVRl2FWpuhLu7tharvXNelmdbjF7Rr5S0t9SO+mpc=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=JIzhXZr8cY/tqpIUbNuXcgdalEM26DB7+mmzC6WyKl+55fNA15w4kC+amaJ9jTTyY
         GjsMA8d3y2quLglrwgve0zvxLq/cdP9HforG/7t6eg1N+tNxvAa0DYOwq751DS0KYr
         izYIuZ7OFkUbZs7gQOAXgP0OOYw2Fwcy3WEz7iz20waVsuyAvduSbrqwss8Fb9Fscw
         QcXGsfw8kZB/2+iBjv274R36D92To42kTyPhsga+2gLg6AIn/5gvFI2Xyz+Qa2r6vb
         GLeRe+IEX0RQA44hiP6yBFhKxI+o9koKcLyvvBIOGIBfYUJvYVFkKtufMJ2xeGsX7t
         SyjcNWQes/2Jw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 18:49:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.142 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.142-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.142-rc2-gd06cb8bccfe1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
