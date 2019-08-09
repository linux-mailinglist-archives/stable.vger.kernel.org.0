Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7928587D30
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 16:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfHIOtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 10:49:17 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2537 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfHIOtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 10:49:17 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d4d87ee0000>; Fri, 09 Aug 2019 07:49:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 09 Aug 2019 07:49:16 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 09 Aug 2019 07:49:16 -0700
Received: from localhost (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Aug 2019 14:49:15
 +0000
From:   Thierry Reding <treding@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/45] 4.19.66-stable review
Date:   Fri, 9 Aug 2019 16:49:13 +0200
Message-ID: <20190809144913.25249-1-treding@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565362158; bh=19xIYnUdXuiKJ7E9/TfhcsjiWB9hdbnX8vtsYhIqhGI=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:
         Content-Transfer-Encoding;
        b=oc95wNrgdWoESV5E5QaaJduBIoLs34cnKDHGKqRopanlS9r4Lg0fJtFFJelCwHrYa
         7qziVKjLMRcWtPKXYxyfg6g35uBA2wzr9mXYEGIlugZOPBa7cVg5w9U8g8fNadzxD0
         RBNzCZXWhCLxRqhA1fMcofF6NHwH5EEd4wYXXu53U5WMv8QPday/4/rwjxm1VaWrvl
         oDYM/Ry/vORrMvYAwgzTjSBG+QxzmZnkcOUGPsUeb5sLkaB4bifczKOeYi6ro6EO8I
         gB5gdhkjJEu3L+ZGn43Ow++9jYv9VkIyiHZx25Gtlgw0vCXD7Uq+sjHL9uT3qPO6gW
         AqkT8YfznFEWA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 08 Aug 2019 21:04:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.66 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.66=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.19.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.66-rc1-gd43238541496
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry

