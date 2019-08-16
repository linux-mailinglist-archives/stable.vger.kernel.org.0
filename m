Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2266E8FECC
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 11:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfHPJVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 05:21:37 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17987 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfHPJVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 05:21:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d5675ac0000>; Fri, 16 Aug 2019 02:21:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 16 Aug 2019 02:21:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 16 Aug 2019 02:21:36 -0700
Received: from localhost (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Aug 2019 09:21:36
 +0000
From:   Thierry Reding <treding@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 000/144] 5.2.9-stable review
Date:   Fri, 16 Aug 2019 11:21:33 +0200
Message-ID: <20190816092133.16205-1-treding@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565947308; bh=ZjfyMsNImwWcjWQqBXkYaVAytxmgBCBYHGQs5oe6SM4=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:
         Content-Transfer-Encoding;
        b=krHMJOdqWFQrQunnZLRFFWG4us5CesLDqCbSJr/HUZCt7rgVIhtxnO/ZYKxsk6XM9
         wWgjvm36M3mxkAnn8p8UoUfoTUa8OplmyBxTb0jHiuW6UcE8OoPxU81HQGznZHy1qG
         6utm3EG1oKXM/KzJ/MiIOMRaOLPtrsn5I8J8YH0kFmF1hatnxplMrsHD28GptsniD6
         wfhCD/z9nIY7t+pCEtz6o1hzwryflG/64KlyyA5v7acQMAX3rnK1fzJ3HgXBvIiWin
         hvlgkYA+WWwM003loqXMffinn1kRNjid6GezA+MYVHZY8jCFJWlJ8Y6iTa1r84ZBMn
         chWLVo+OHBNEw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Aug 2019 18:59:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.9 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.9-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-5.2.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.2:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.2.9-rc1-g2440e485aeda
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry

