Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF382320B4
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 16:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgG2Ofe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 10:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgG2Ofd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 10:35:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4134C061794
        for <stable@vger.kernel.org>; Wed, 29 Jul 2020 07:35:33 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y206so2742579pfb.10
        for <stable@vger.kernel.org>; Wed, 29 Jul 2020 07:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YMgJnR8bhlHrVWjDHT7hybbRaNSeaTugojiY8pMp9C0=;
        b=QpiCV3I3wXJ4WPcsM8B7TBYVhzENZc/HwW5OoGe6kw3wqKeffdK5+R2IqkcvcXyP/x
         74JD90HV2sO0t104yWpt2SqAioHwdl2sRsApNw/c8AdP0BX7zBjgxyrbOkjrWyWfm8v8
         +GBQuoNEW3enWTcxG1J5yQ+JTdQJSj23jfhAuZ8HBv8qCLzTiMTLf31tuYIKKhKzF2PJ
         id14DdnbaJYPHGRnkZ2U5fbnRsOVBXqurLsnNX5tVj7si5tyguvxfRZOOa/kWySnl1SQ
         ihCgnw6DIob/u8LJ48ytZxiERsmY6YY49ZdQgJIIsOzyd3Jd82vW9hk3zOzbM+A0Lwc1
         cKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YMgJnR8bhlHrVWjDHT7hybbRaNSeaTugojiY8pMp9C0=;
        b=d51hMCEAGRBVfUJfTitNr6iHUxnXnlktiFYNSscXFe0WIJ7xzOjSX6pC6VnpY5YwBb
         Myyd20YeWQCl1AngTPMVH/luQQfIuvIRVQoHRMDGYAqmxe/bGL99+5a6n0bBJW18xKLb
         Wt5pdDsN0cireVK0rkIlNItYIF+sZcgnynKx4AwCd8vjlmwXQp7ejdzjCW0C1Wzw9hVT
         jc01w3cayLGUsodf62BmA4nVgERzeGE4briivK9YJ5vUKOZVNAuC21VEJrJArHNkka5k
         hNsB/w8ANbR0IbE+v2P/k6zBtDXbe7wp0RJT5BD1AK+geoiVkJGy6wp1gk1yM6xqGAaI
         rjnw==
X-Gm-Message-State: AOAM530urBhXG+nTCoPXVZW51qy+1ijSdBsbIDKgwFGwaGqe+eIarMt6
        wkBiP+qQ6Ng2Jk4ONGCqTIYdKCCbnZ0=
X-Google-Smtp-Source: ABdhPJxiz8Lw3XY3+W1Jhllr6EC/ldU/vbttIownum/er1T8sqFgvVZHydE56eEnXkD3P2nQhIcIzA==
X-Received: by 2002:a62:2e45:: with SMTP id u66mr5760396pfu.121.1596033332876;
        Wed, 29 Jul 2020 07:35:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n24sm2480405pfa.125.2020.07.29.07.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 07:35:31 -0700 (PDT)
Message-ID: <5f218933.1c69fb81.325e6.7783@mx.google.com>
Date:   Wed, 29 Jul 2020 07:35:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.134-87-ga2eeabffd1f3
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 165 runs,
 2 regressions (v4.19.134-87-ga2eeabffd1f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 165 runs, 2 regressions (v4.19.134-87-ga2e=
eabffd1f3)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =

qemu_i386-uefi        | i386 | lab-baylibre | gcc-8    | i386_defconfig  | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.134-87-ga2eeabffd1f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.134-87-ga2eeabffd1f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a2eeabffd1f3dd5af0e99af90bff26c8530d3ee9 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2154fe5788af252c52c1b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-87-ga2eeabffd1f3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-87-ga2eeabffd1f3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2154fe5788af252c52c=
1b6
      failing since 43 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
qemu_i386-uefi        | i386 | lab-baylibre | gcc-8    | i386_defconfig  | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2154a5244758815e52c1b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-87-ga2eeabffd1f3/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-87-ga2eeabffd1f3/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2154a5244758815e52c=
1b1
      new failure (last pass: v4.19.134-87-ge11702667f84) =20
