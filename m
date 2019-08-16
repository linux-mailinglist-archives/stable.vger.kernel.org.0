Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E248FEC9
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 11:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfHPJV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 05:21:28 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17973 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfHPJV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 05:21:28 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d5675a30001>; Fri, 16 Aug 2019 02:21:39 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 16 Aug 2019 02:21:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 16 Aug 2019 02:21:27 -0700
Received: from localhost (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Aug 2019 09:21:27
 +0000
From:   Thierry Reding <treding@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
Date:   Fri, 16 Aug 2019 11:21:16 +0200
Message-ID: <20190816092116.16044-1-treding@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565947299; bh=Upt1JD8Jkgdd5LH12EQAOvqwztwGLsJsPkMQjqijHso=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:
         Content-Transfer-Encoding;
        b=ToEPqDdxQV5Nrn0bG8JJUDPFxAgoKNcaSPt0SDv78KGes/km7bs0VYo4DCwaw1GQL
         Rddkp2aI9dFkO5jKeR8kccpzsMzneG1Y0Zgi1nRR376t9YBREC6wp1Ds07/113Is+P
         jatoB6uqpRFAFSniSkrAeqs65LSt5ZMK2MxnJMHD1E+mYEcyshOv5Aa+DQutXt0iex
         l3FK+YyGLuC7JVv3cOZu74ezANtP8a76fOHrGudqxsCpDCTEwdkXE1WdlrE/rTitW3
         mhhMe9qi9VeMEUbceD4v0hzuv2KTFiuJtpFs1Yajmrb2sFEw7ky6A7NGv58d8adkWG
         BJrnrBV39EGCQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Aug 2019 19:00:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.67 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.67=
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

Linux version:	4.19.67-rc1-gabb1bb8b9ba6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry

