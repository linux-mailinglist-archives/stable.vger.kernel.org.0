Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE3E8FF09
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 11:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfHPJ2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 05:28:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16278 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfHPJ2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 05:28:32 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d5677420000>; Fri, 16 Aug 2019 02:28:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 16 Aug 2019 02:28:31 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 16 Aug 2019 02:28:31 -0700
Received: from localhost (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Aug 2019 09:28:31
 +0000
From:   Thierry Reding <treding@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/69] 4.14.139-stable review
Date:   Fri, 16 Aug 2019 11:28:28 +0200
Message-ID: <20190816092828.23201-1-treding@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565947714; bh=+WZGEdvBMjwQb5MjvIDDUHl4rn8SrXDDmJZ6TqLGdQM=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:
         Content-Transfer-Encoding;
        b=Z2nX7D4QsptnCDa6MZ6t2sulNG2KFTCiL5FRDtyI9eBrZQuAa+P1R2eqKJPl0doRn
         nKaKfChl2xkv/QFAYR0vj8CH/5+5ANqdGO0r2Zh7yURpUA+RDMU0sTtcXSwy8D5LQX
         uo/bWbUn8zfn0sm7l3gKIY9YqrTH/JN9hRorJlOAGCmocm+U8FG3CzUeyJITWev7MO
         rLco3c2sviYzFSjUumONVTen51xcXY6aVO/xT9MalSjcr/rZVVqDq7CiXpoe+1XlaX
         1WoHnetiJJBIVBn7K+JYg/zII54RY7cD5GxE5PsWV7nmimThz3av21BJL8BaZNXZMX
         UnBpN6YkVmwzg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Aug 2019 19:00:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.139 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.13=
9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.14.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.139-rc1-g736c2f07319a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry

