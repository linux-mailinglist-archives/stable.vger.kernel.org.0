Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8F487D2A
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 16:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436566AbfHIOsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 10:48:55 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2514 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436516AbfHIOsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 10:48:55 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d4d87d80000>; Fri, 09 Aug 2019 07:48:56 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 09 Aug 2019 07:48:54 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 09 Aug 2019 07:48:54 -0700
Received: from localhost (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Aug 2019 14:48:54
 +0000
From:   Thierry Reding <treding@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 00/56] 5.2.8-stable review
Date:   Fri, 9 Aug 2019 16:48:46 +0200
Message-ID: <20190809144846.25144-1-treding@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565362136; bh=1pu8tY0gDCedgHeJnrzdPuT5ZxddOwZQ8TMfewXnEwI=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:
         Content-Transfer-Encoding;
        b=I1qcOkKnTwOTM7YiK86pqiRrHKuYqS5Ww46Yo/QJyvK/5ltzF3Ydjj0Vboy9vvhbC
         dDEnjf2ibK0hXMlEu4FLjsE2rhZMxhk1jDffP/HjE11AOo/024neQKAR/Xkc1YqA8r
         w+FT29a3dUtDMVaAxtgkNp/NhEKef8ZjqSBAuUiBT2WyTJwIdseY1EF48Vs1AnPDUi
         Y8J+9HBoUN/d6cqmnpS3cjMzOuMWgCLnxnzC2hwzP4NFaiw/yBn+9BC12JSykZlVO4
         7H78QjJOJSQ1wpei8t3c/ElBfZ8kXE/dE73Ty2U9iEobZBa+T4yVbUhWIN7n1liMlO
         tf06An2ETSG7w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 08 Aug 2019 21:04:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.8 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.8-r=
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

Linux version:	5.2.8-rc1-gbd703501e2df
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry

