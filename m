Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CB73A32C6
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 20:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhFJSOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 14:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhFJSOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 14:14:04 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8766FC061574
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 11:12:08 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 69so1466689plc.5
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 11:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nd0Zr2HEB5WmQZcf4adonbMTHkO68JGMMaoE//xzzOU=;
        b=VBlWXldGPnXwtHuoWFLZWrDTlSi+jQuGX5fJxU3+9J3AicG7QL/FtGH04VryBuRb87
         kNHtoTy9k0yDqLjYEmBfVoS6t9oMyqVjwKnn/+YfiQU7X5hONyVvB40tmEupbTQxGACW
         yG3BaHbuWx5AIgsUBx4cym7ZGU3RTzcCciyAbzV8Jq0g3fKeUVJMGgq9ZRZxet3eiYZo
         lIevG2ELszg66sQm14FO6T4ap6ESkDiKXLJre+z7KyOThMYTd86pCXoAtg63G8oLr3r2
         HNiAjn7EaVXJnIKnZS1UIYyi8HQqid7D1wMvZ1uNgSJyH0HBeuoCecOZOGGjbYmYbaP7
         xjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nd0Zr2HEB5WmQZcf4adonbMTHkO68JGMMaoE//xzzOU=;
        b=ubED5vRBabbAhyQcsl5AQOOK3HSW4jOrhTxGqUvefO+aX0NNaF/LEvbmnpsTK6mhnL
         IXQInLCvrPNdpra1z4/r9o3qnp96YFmpFJjNWYyfBcSVrTlK9o5dKCmiSn3QV62WmxNQ
         PYUT0ZXum+rjpeJ9zcBsnfv4/Wvwghy0Qb8Vz6g+BtjXYnbU4JJzlIYnwRsEfocmYdoI
         J+SQcv8HX6O/rveGE9JnPTboJfIQj5CKONL6rAxFrVBzmOu+Yiare8w6VTsQXByvwFpV
         756wtiUBz1hH9oMLTibEDNcvAAoUpHe7YG+mERjIE+is9gAzHFO1BJY7LPVClu6lPToq
         OfRw==
X-Gm-Message-State: AOAM532pBvTvM3bBGSUsK+6AmhemIr4kkgB3Uc5KsaTJ5Y7GxsY5aIxq
        iZkegRuFhC+K+UFgrR2LGeIwphlg/glXFqyZ
X-Google-Smtp-Source: ABdhPJzdumzaqb51ITkynQBabPLQS92KFneBA3L2YfcrRYh0RUVXjhp5ISrHCR5knYCrTnvkUaMLhQ==
X-Received: by 2002:a17:90a:5511:: with SMTP id b17mr4715272pji.121.1623348727856;
        Thu, 10 Jun 2021 11:12:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mg22sm3012602pjb.26.2021.06.10.11.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:12:07 -0700 (PDT)
Message-ID: <60c255f7.1c69fb81.73853.9a1e@mx.google.com>
Date:   Thu, 10 Jun 2021 11:12:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.271-29-g918dba268ee4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 121 runs,
 4 regressions (v4.9.271-29-g918dba268ee4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 121 runs, 4 regressions (v4.9.271-29-g918dba2=
68ee4)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.271-29-g918dba268ee4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.271-29-g918dba268ee4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      918dba268ee45b6b505fbbea853ddb9bc5eea517 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c21fff577ab5c8310c0e1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-g918dba268ee4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-g918dba268ee4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c21fff577ab5c8310c0=
e1e
        failing since 208 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c220003e0976ae960c0df8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-g918dba268ee4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-g918dba268ee4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c220003e0976ae960c0=
df9
        failing since 208 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c21fd912ff45151e0c0e4c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-g918dba268ee4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-g918dba268ee4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c21fd912ff45151e0c0=
e4d
        failing since 208 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c21f90064ff3b8fd0c0e01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-g918dba268ee4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-g918dba268ee4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c21f90064ff3b8fd0c0=
e02
        failing since 208 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
