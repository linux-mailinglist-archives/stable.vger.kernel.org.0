Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7293CF3D9
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 07:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbhGTE3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 00:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240562AbhGTE3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 00:29:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC41C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 22:10:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so1785552pjo.3
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 22:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HJrAhsIkAVqPuH1BM/tCvpHq2bYuWY8/izmUbBwR/gQ=;
        b=HpCsgJEG6Y4ahM1pekSVVKWnzMBESZYUd03ubPq36j6YTIh+mI4JMgTG+FXFVvYTMx
         vThcx9uokkU9EsWk2EQVkTgfpHdmHM99w/IqU/sqnuCC6Uub80OIfGWs5b7YnG5vEC5t
         nvfm4Gl/tA4C+P6QXB37wE2aZt/2iktoH1H2QsgqcusKlVgTNTa6U/xnYYJD7O9GAq91
         FbGvzsTUPXpxuXp4DeVsrseyYAvinewkps4VoGs4gjiFnVob+xX0l/v/Kj5Cl4gcf2qv
         kZHA3cPNaoWsnXrc/AwQCmAEruS/q+1whhJhW78vIjeMtZQfzt1/c2Rc+qFdN8iEOIzm
         ly7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HJrAhsIkAVqPuH1BM/tCvpHq2bYuWY8/izmUbBwR/gQ=;
        b=X1MvJBd4AePZz2ekcoPsaMFibINrTw+v8Nt9pVc7o1nEUuWsa3ETyNoiH73jHsWzaE
         diBjNvaVfF/OCzcF5gSerpkFP5JFnPTTTPe6IP5CSlLvCTDIwYU7l38zwii1N+3WJcNu
         7bgtt/hqdGxphTjPXTFIVHnk2KpZVlP+mxh91U0evqnYb6I7yyZ6aRx4CvhsB2n9H3sE
         Xz9aNXe8Pbfw1fs0XEjFSqXUhaEke50K/HzauS6e0IyOQDRtURW226YupRBstVey8e9v
         xNiBimN3Agvr6p7WNtfHM4HSIc4lwPVVjbdQviHT3okUB+U2TbzmjUFn5QboSOa5e02S
         f28w==
X-Gm-Message-State: AOAM530G4/tKm4aBVK75ZTu2nOiL1KQqSnXezTEqqce315PPW4HexQBE
        nof8PgM2FKf0Db0XYiBIo8Tk+X/Avpgvlw==
X-Google-Smtp-Source: ABdhPJxvxQKglYPt9Rzu1Gq/tEeoYogmGgeH0tVFR7+weKIAL1WcOJJWJCFU/W9vnDJ/82I9rGguZw==
X-Received: by 2002:a17:90a:7a86:: with SMTP id q6mr34480117pjf.141.1626757826891;
        Mon, 19 Jul 2021 22:10:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e4sm25999652pgi.94.2021.07.19.22.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 22:10:26 -0700 (PDT)
Message-ID: <60f65ac2.1c69fb81.143e7.c479@mx.google.com>
Date:   Mon, 19 Jul 2021 22:10:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.275-189-g9a5ee5f15ce7
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 115 runs,
 8 regressions (v4.4.275-189-g9a5ee5f15ce7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 115 runs, 8 regressions (v4.4.275-189-g9a5e=
e5f15ce7)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.275-189-g9a5ee5f15ce7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.275-189-g9a5ee5f15ce7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a5ee5f15ce7173e76ab3da5a14b374eab0af960 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f6251c7522149be011609d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6251c7522149be0116=
09e
        failing since 247 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f62603220e9e4cbb11609a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62603220e9e4cbb116=
09b
        failing since 247 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f625277b73347d511160a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f625277b73347d51116=
0a3
        failing since 247 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f62746cfd6a76ee81160b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62746cfd6a76ee8116=
0ba
        failing since 247 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f62594b41777b9eb1160bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62594b41777b9eb116=
0be
        failing since 247 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f626a305f29ddb2c1160ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f626a305f29ddb2c116=
0ac
        failing since 247 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f6258684a2716de91160ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6258684a2716de9116=
0ac
        failing since 247 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f62829d768aba3cf1160ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-189-g9a5ee5f15ce7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62829d768aba3cf116=
0ac
        failing since 247 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
