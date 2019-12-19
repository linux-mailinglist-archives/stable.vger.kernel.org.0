Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F139B126E55
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 21:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfLSUFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 15:05:16 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46518 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfLSUFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 15:05:15 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so7197866wrl.13
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 12:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IDab6Lhy0egQpQtLVvNP3lbeteiH2YDGTTgMC4J1R+s=;
        b=q0MhacBT2i3BxTkRDKSHlZXTumdLjXyrueR5Y+KOTttCaNYL/KSjZem3P55n1kvUGy
         ZemKukhg6ImIgnU9f0eSIYtHFPCHKv831B1EOpLglTatR+7oEc3x8CRWl9hVCAiEbHns
         xI6WRccB0Govbnp3js+/vUqC7eIn7fpv4GxtXaeEwkZ7UYU/uKcKMRqdtdJ5Vab9A0pj
         ++zj6T0sy+sWWbDKRz/UVwnGBenGYHQZvI9HgaaaQt1hTDJ8UXDW8wQHjftzWzEsFRwf
         4ihRNUQHVBZlrnC5O85JGqYCBBR0x6Fgyb3avbHWohAVlheUq4MprjJ74PbdDIQJ//js
         C2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IDab6Lhy0egQpQtLVvNP3lbeteiH2YDGTTgMC4J1R+s=;
        b=cmO1Ztxmmo8mshyh53lJZ3MwoRNxFUjBB5gLUNqTqqAx6FQbIiyWjxJMnTQQIRWMMC
         xenmk8dnBnULqR6ffOtLCO4cDJq877N4OWlBoL8x25xl6fTAFOtjA+AyHQ5RTw2yAS/b
         kenqiLW9dRlLwXRSsaeEqtfViu6zKDHoL8sdCMK01dKD4Vawoci9aDgQ8hAJBp0K3AXX
         2SgX8eKSxQqo/2GG6yDdrRCTgzqlrHSU13z571l1uLL597xdvl66t1Z5AUlq8NKJiyOg
         dHDfzyVUFlOi1ZW+JmGYhrd1Q20MwSYE7PsN1FHM91e1+/Ztv6+cfmHN5Gi9jEXYlX4u
         A0Tg==
X-Gm-Message-State: APjAAAXpqXQLRIorVTLKZ6lJ+z19nozlDmWGxPkjb9/gO/1st+WzEnMJ
        kQ0DKm+P066xbPtl06ttACMDKNUnH8vEWw==
X-Google-Smtp-Source: APXvYqy8b0Ib5aIt0OKv2k7X0EoG0zcJZ0pK802m6IdFeyQlbFH5Upm8DCirzcZBBuAj4rK+LniA+Q==
X-Received: by 2002:adf:f606:: with SMTP id t6mr10938129wrp.85.1576785913806;
        Thu, 19 Dec 2019 12:05:13 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n3sm7216580wrs.8.2019.12.19.12.05.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 12:05:13 -0800 (PST)
Message-ID: <5dfbd7f9.1c69fb81.fc66f.5303@mx.google.com>
Date:   Thu, 19 Dec 2019 12:05:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-163-gfa8359d689a7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 75 boots: 1 failed,
 69 passed with 5 offline (v4.4.206-163-gfa8359d689a7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 75 boots: 1 failed, 69 passed with 5 offline (v=
4.4.206-163-gfa8359d689a7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-163-gfa8359d689a7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-163-gfa8359d689a7/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-163-gfa8359d689a7
Git Commit: fa8359d689a7649d0f197a295edce3eb7c1ac175
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 17 SoC families, 15 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
