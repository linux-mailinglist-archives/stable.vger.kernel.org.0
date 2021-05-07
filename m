Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FF93768E3
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 18:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbhEGQg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 12:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbhEGQgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 12:36:24 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC0BC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 09:35:24 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d29so7527484pgd.4
        for <stable@vger.kernel.org>; Fri, 07 May 2021 09:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=52JnJrHPLnxSnDnPgC+ZFYAIAWnDRTFLGgj5aVhPwdM=;
        b=ovy3Uy1m8y8UlYBZD/HsIwXslpT9b1Vj9UGggAOw445CGpUlVuHlVc/wnLxD0orcyf
         UwJhkZUSNZMw/VQXsXkuY+k3I8InFbsbNy4L1+AlLKbMV7QrRnfla9OtHbQrLdnX/+2H
         HoMXibuJx1olYD2kZBoBl6Z73jYtHEb1yKet8r15/DNls6xfLXJXmvl9vOkhlScJ2kY/
         WV4pKs6ZKjsqsdea5/wdagn8MyX84esBbfzIePor737kQDN121jVDmJn2Jx/92QNy6m2
         8vJBbvsJd8PQzD5ftwUKrTdWB4Ryrnqg/ZgftO2Crc0xUFBNBKXEszIA4rqw5ip38Uc3
         5Frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=52JnJrHPLnxSnDnPgC+ZFYAIAWnDRTFLGgj5aVhPwdM=;
        b=maMlD2QTPvsaL8PvLQQoxvhghoVk+M3/TcUV3WOYPsAQkPeeOlGOGwdB7kHUMbq6Bq
         LRDZfYc7qF72erh/41Pmh5OyBH05CRjExNSJ8RBBImcSrwHAxBmHukgGZqomU4aVSAGl
         Hsyfw9huTWshkvlpXdiqcO49V8hKYL1KXSoHFEnOMa2uNXteZAS5yGLzQmZtKDx7saXM
         zuwJ/0lAYE+UPp2fgyGFeULXEvJLvFD8FosA7kks+KKd0WC1E/J3C3/LmC8cGMMyQwxJ
         IWI3PRXSUCSbVEoHZ+RtsIUNN6Z9r9K6dP59LSTCEF1Gau25FgHKYldVT2Rzz6stsfo1
         Vrzw==
X-Gm-Message-State: AOAM530FtYedXtNwSBbBLXSBEHTId+0Lg8juzkdOv70gBgnDtMeiBbcn
        GBIaERghnypls9HokmyiXKAIo0pSaFSYi54u
X-Google-Smtp-Source: ABdhPJz2xTp99euXXtTFyMAEIQvI4y2FAgv4LO1TkFBR9Vd6w+pmft309Cpw5e9KUH3EBlqXnYArYQ==
X-Received: by 2002:a63:2226:: with SMTP id i38mr10785087pgi.215.1620405323821;
        Fri, 07 May 2021 09:35:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm4847487pgi.64.2021.05.07.09.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:35:23 -0700 (PDT)
Message-ID: <60956c4b.1c69fb81.f6a7c.eb03@mx.google.com>
Date:   Fri, 07 May 2021 09:35:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-6-gcd66b55308ad
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 69 runs,
 3 regressions (v4.9.268-6-gcd66b55308ad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 69 runs, 3 regressions (v4.9.268-6-gcd66b5530=
8ad)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-6-gcd66b55308ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-6-gcd66b55308ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd66b55308adb5fc07a985e864a859d55df1aad6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6095382787c22cc10e6f547d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gcd66b55308ad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gcd66b55308ad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095382787c22cc10e6f5=
47e
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6095386d2f953fd9fa6f5482

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gcd66b55308ad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gcd66b55308ad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095386d2f953fd9fa6f5=
483
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60954d32dfa847bc026f546d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gcd66b55308ad/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-gcd66b55308ad/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60954d32dfa847bc026f5=
46e
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
