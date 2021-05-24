Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B7C38F54B
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 00:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhEXWCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 18:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbhEXWCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 18:02:55 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960A2C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:01:26 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id m190so21118789pga.2
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9SqJ+FalSEjt//75MMBQXnCweZ1UIewUNDKauL1zty4=;
        b=B9vprJn/CJJBPP2XGCBAkP3Y8Gc60G3qvs0KVYBiEXUrOXvR1FYRqyQqDbWOF+tNQY
         B9zuedQK6okOETCNPkb9DmD5s8sRfthiL8HZGMBh8psLS3C+vRue996Epzj7LtJ6QiSG
         zz1Y9MY4A+GIZEMDLml05JlbbvpVJhKnaaCrmjGZANxLcgloCmcf11f2mbdl5tXxXv87
         vfeODfRFYuqryiwu7aU2E0HY23jsPsQYTWcQEsy5RJXho90rOcdSjCyPw6EsBo/DRgum
         a020QJRhknULNVI8y2oV0FOxr3O4RgWz9wIizLkeUMyb82pwXx5362zbxII7Oh/hcGnb
         RRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9SqJ+FalSEjt//75MMBQXnCweZ1UIewUNDKauL1zty4=;
        b=FMO65BDQOomeSzTUSq9Z0K1nmbIyYTnb/lqoQSJoD36L8gDQlcTZx8c/DgTzYOQIOZ
         a/f8cSCz/e2VkiN0izfOfWbX/ZLlTZpOV+VBwckFLLBSBRiEZNUSmA/D2bQavaXch+Bz
         kglyMUwsLnsXeo304dJsmXsB2+L2ETu52SlLAJ5d0gaDEa9dn8yOYUp+GzJo/gDmcca9
         61KKpyLEQxKBsXcEYNFpLWVUPbXF2Gwc5yyViJy6gB6IofvHZTo7hajjDptTJvV4gMjr
         FJ2dXquFVVe3zMhxUcfpSp2DSwEeOziGfY1jlbGYlij8j4j1XgvLESTZJEAruGhT4MLg
         ngqg==
X-Gm-Message-State: AOAM533eSYEScWbEWtigUPROM+M3Oh56oSW6M6DClNu3Mc/G9rpTD3FN
        SGB8v+6W5CxixsIWm86tZUU3Egu7JIv3Gkfw
X-Google-Smtp-Source: ABdhPJyW8w5He0+HZyBGbMly6sNh7JgAAdGFRrzC0vWImi1TuP3h6NNvi6cikF+ciZo0aQk2lFZaHg==
X-Received: by 2002:a62:ea03:0:b029:2e7:8445:243c with SMTP id t3-20020a62ea030000b02902e78445243cmr12424619pfh.54.1621893685898;
        Mon, 24 May 2021 15:01:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 69sm11876116pfx.115.2021.05.24.15.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 15:01:25 -0700 (PDT)
Message-ID: <60ac2235.1c69fb81.ecb8f.73a4@mx.google.com>
Date:   Mon, 24 May 2021 15:01:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.269-37-gc1efed5276d2
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 77 runs,
 4 regressions (v4.9.269-37-gc1efed5276d2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 77 runs, 4 regressions (v4.9.269-37-gc1efed=
5276d2)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.269-37-gc1efed5276d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.269-37-gc1efed5276d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1efed5276d233a93736fd701ad502ce298890cd =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60abeb7370739c6185b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
-37-gc1efed5276d2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
-37-gc1efed5276d2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abeb7370739c6185b3a=
fa8
        failing since 191 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60abea08bd866d506eb3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
-37-gc1efed5276d2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
-37-gc1efed5276d2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abea08bd866d506eb3a=
fa8
        failing since 191 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60abec05ea19c1c589b3afc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
-37-gc1efed5276d2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
-37-gc1efed5276d2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abec05ea19c1c589b3a=
fc1
        failing since 191 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60abeaf5c9f80931f2b3afcc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
-37-gc1efed5276d2/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.269=
-37-gc1efed5276d2/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abeaf5c9f80931f2b3a=
fcd
        failing since 187 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
