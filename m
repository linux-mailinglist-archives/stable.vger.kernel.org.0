Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A713C40EF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 03:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhGLBhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 21:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLBhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 21:37:54 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28FFC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 18:35:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d12so16578071pgd.9
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 18:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Sj14qXZgmQuoll1f/Pi3CiMjmXVDlUXmD+4O7f5nC74=;
        b=Byfwbxy8wN1xdXC0bQgJWE0/Ol00vES4VoDfNUdWu8Vc+PmQ/Eil+xjwYq/+ZsNFCA
         wDdh2XMZFnbChKmX2pme1XKWOEUN0K21P7CqPkh5QJSTW6SoJaFqHfjB6o9p18f2D99A
         hifshuPCGcK6Z05dd1rwazsYD6dbQ2Uqzg3NcP0d5qsy6/Ivlvjzr78EzeqqVzhB7Ft7
         5kL/zR2JBUyVUEygyEv0ZxifZj5drlRpq0UK2RqdOIPA6RxoBQ1N/uEg4Adtwz90cSnb
         Ror6LEmB3+VH9+W40ltc6TqZiIhxMYYw+fi9XJvXvMz4HIpo5+bzDOcsvRoiAULq0+1u
         qeXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Sj14qXZgmQuoll1f/Pi3CiMjmXVDlUXmD+4O7f5nC74=;
        b=nRN+xU7VERFwIFpEZ4MHdNwS/fo3eZfmJHzU16Ub2838LLXMa6IjeZoSXVQlxNZWGx
         5tPH5AvNZMAyZf+6HuEIVgLi3iEmn8/iGMhSQFSyJUtotY51HXbHNqIRd2eOSYL9Ob7P
         ALyjSnnDzuKR95BASDySLhANASyHnB8tQUnI/lWViw9niCTlHSQ8d6cdW0XM+bW0d2mq
         UbD/JAkUd5Jo0ZON8LvmKMw6KRFN/K/eCRQzkuNKTnx2pujJNgl+3dY/9+UyoVp6udan
         bZsRzLOJnDVLQxvXEsT3uwY/il+dai1Dq3rKSoZGWedX26PW4cTJobpkWGTC7JDoYses
         3ATQ==
X-Gm-Message-State: AOAM530A0WElMQe9lYvsZ4WK5+CRP4/EQNf3EoVEe0KbaEI6pECPIGDI
        gBcjmnZ95ME3Anfm4Rtmc3vZj+T14hlsCCvB
X-Google-Smtp-Source: ABdhPJxuDUuRJ/t3DuN1KFWoTlm0OOcELES5Q8QCv72VcoM8q9oOx5ea9nSex9RK7PcJ0wuGLsAcHw==
X-Received: by 2002:a62:581:0:b029:301:9082:7283 with SMTP id 123-20020a6205810000b029030190827283mr49783325pff.37.1626053705995;
        Sun, 11 Jul 2021 18:35:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o10sm13353901pfu.131.2021.07.11.18.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 18:35:05 -0700 (PDT)
Message-ID: <60eb9c49.1c69fb81.f4bd6.7b66@mx.google.com>
Date:   Sun, 11 Jul 2021 18:35:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.1-802-gfce173dc9c592
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 128 runs,
 4 regressions (v5.13.1-802-gfce173dc9c592)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 128 runs, 4 regressions (v5.13.1-802-gfce1=
73dc9c592)

Regressions Summary
-------------------

platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 1          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =

imx6sx-sdb         | arm    | lab-nxp      | gcc-8    | multi_v7_defconfig =
          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.1-802-gfce173dc9c592/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.1-802-gfce173dc9c592
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fce173dc9c59217eca776207e97f4ef3e0244baa =



Test Regressions
---------------- =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb662503f11ef64611798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-802-gfce173dc9c592/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-802-gfce173dc9c592/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb662503f11ef646117=
990
        new failure (last pass: v5.13.1-783-g664307fdb480) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb64cdf464d167df11797a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-802-gfce173dc9c592/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-802-gfce173dc9c592/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb64cdf464d167df117=
97b
        failing since 0 day (last pass: v5.13.1, first fail: v5.13.1-783-g6=
64307fdb480) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb662103f11ef646117987

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-802-gfce173dc9c592/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-802-gfce173dc9c592/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb662103f11ef646117=
988
        failing since 0 day (last pass: v5.13.1, first fail: v5.13.1-783-g6=
64307fdb480) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
imx6sx-sdb         | arm    | lab-nxp      | gcc-8    | multi_v7_defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb696926a743d2661179b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-802-gfce173dc9c592/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-802-gfce173dc9c592/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb696926a743d266117=
9b9
        new failure (last pass: v5.13.1-783-g664307fdb480) =

 =20
