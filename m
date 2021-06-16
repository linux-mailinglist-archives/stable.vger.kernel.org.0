Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1A93AA679
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 00:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhFPWHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 18:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhFPWHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 18:07:35 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA69BC061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 15:05:28 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id x10so1861015plg.3
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 15:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QVZypWxq+KpABQdnm6ZWlU4VJJXld2NXATQcTqms7ic=;
        b=a6qUPPgzuWpBV6MnP9Le/aikqQzuWChq3Pgiq3W+ENWvct0BSQJcQ7aIdnIbS8RB1L
         eQQ2oywQE8zN2V4ts7yEYypi4DeZU0eaE9gTX45qfI17yqtVG77KpJet3SoSR/sMDhA7
         iDpjAFmKrxWdeEwH1NxYKLJcobnapGHiTTl9D+zEeYP/i2yfn1Gm/PE7YSienvK38+lN
         dGdOmop/btjm93Fx4qshOiuQWiVMUjD3p4PnL5/reGJelnaa4QbCSFefWIox3PeDtC6l
         Ox4scJTFYmI4exc1ppUi98XGyDZN8cpB2ObwOnwP2dIk/VipHehrDE9PXHjHkBmIqWBS
         akEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QVZypWxq+KpABQdnm6ZWlU4VJJXld2NXATQcTqms7ic=;
        b=lDOvn6Ilqv0qxcc3Ps7/nKnhrLo+eEWXoTJag9/pBEibPyKtr+ZrBay3JXI4oiIgtM
         3n9a5KH8UXJClXlUXddhSNpjCabQH6V+r/0I4JPm9v08UP/UQyaHE4tXPUtwnIuQ/k89
         myu63YJ3Qi13FzfoJ3gLZXIZ4DRsVk+oJUC4BcCmzBYXrMZDDRzsLvEV+dg9oUzf9z9P
         4g9vlLyIFooV2Z7ZLhbgU8dB2/EwTXD42AWB20N1lJLp7R8HicR5s1eM26pMDCJ7odJm
         C6idiTfUy4gKv6vggFZqHMfMBqN0YP/leKlDXIf6E7kCqfoCfnt+Oh+Jb2rJxOsBJoNj
         52uQ==
X-Gm-Message-State: AOAM533DHwb8NY29TpgjOSw0S+/vhsda90LPqaGnWfcHHyKqwiWu1kNI
        5JI3wVTery6H12qoIL0BTyu6JlxP/Mi09giu
X-Google-Smtp-Source: ABdhPJxQvxqykSMzmEtyhSIWWwUt/oRl4u1noxkpMen2PDUj4+L8bh04y/usuuljeEweFiowr+JfXw==
X-Received: by 2002:a17:90a:6e07:: with SMTP id b7mr12843404pjk.7.1623881128347;
        Wed, 16 Jun 2021 15:05:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i6sm3689580pgg.50.2021.06.16.15.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 15:05:28 -0700 (PDT)
Message-ID: <60ca75a8.1c69fb81.f6d90.ab7c@mx.google.com>
Date:   Wed, 16 Jun 2021 15:05:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-21-g050ebdeaa488
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 45 runs,
 2 regressions (v4.19.195-21-g050ebdeaa488)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 45 runs, 2 regressions (v4.19.195-21-g050e=
bdeaa488)

Regressions Summary
-------------------

platform             | arch | lab         | compiler | defconfig           =
| regressions
---------------------+------+-------------+----------+---------------------=
+------------
qemu_arm-versatilepb | arm  | lab-broonie | gcc-8    | versatile_defconfig =
| 1          =

qemu_arm-versatilepb | arm  | lab-cip     | gcc-8    | versatile_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.195-21-g050ebdeaa488/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.195-21-g050ebdeaa488
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      050ebdeaa48830852f690696606997b274af7148 =



Test Regressions
---------------- =



platform             | arch | lab         | compiler | defconfig           =
| regressions
---------------------+------+-------------+----------+---------------------=
+------------
qemu_arm-versatilepb | arm  | lab-broonie | gcc-8    | versatile_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ca5527e26afaa245413285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-21-g050ebdeaa488/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-21-g050ebdeaa488/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca5527e26afaa245413=
286
        failing since 210 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab         | compiler | defconfig           =
| regressions
---------------------+------+-------------+----------+---------------------=
+------------
qemu_arm-versatilepb | arm  | lab-cip     | gcc-8    | versatile_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ca437a04235a5162413271

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-21-g050ebdeaa488/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-21-g050ebdeaa488/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca437a04235a5162413=
272
        failing since 210 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
