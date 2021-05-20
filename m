Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00E3389BE0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 05:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhETDbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 23:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhETDbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 23:31:52 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DD2C061574
        for <stable@vger.kernel.org>; Wed, 19 May 2021 20:30:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so4663904pjp.4
        for <stable@vger.kernel.org>; Wed, 19 May 2021 20:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=95v4+UY+2TwVYeVwU6QZarXXRrfwlzzA1koXJ8chI7U=;
        b=PWMw/puVVNCzQeugPXdF6873duImPTpaXWUOxRJe98O/jYR3aT6s7C34JsvWwpGCt4
         hhhE34qMXEqcrpPB74GpBhqh6LsmPA8uCnx6yPp7Sv4W0jCjDMpXwf473kNEY5SmcYDt
         GrYGbU8e7N2PCwbgSS55HYUPVWKW+2VkTUspETjbnQTGU4ZePrxgnp3pqnJLyR3+I/GL
         CZCU6ryZBfG1nYczUEboWdmrMzwAk7fzCTq2dthpJp0fINmEuphUssO1MT2OZIAGWZNh
         httd2Mxamf8bKBkWkgVTLj1sE9OodK5fpqX6005rLEPLalazcaBhj2Jlfpv/gXX/e9kZ
         AYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=95v4+UY+2TwVYeVwU6QZarXXRrfwlzzA1koXJ8chI7U=;
        b=n1K9SWeTCDWP/wA+U6qgP/+HNRn8WNicYZqHbxDKSz0+Y46zamSGByZzZ/o4r4iA77
         3WFPb7w2bpvVLeHT/UGrVTK+cwq1ZS6LMG0hpyiVQ8G6evgibBi5HKDQf0heLHMJ7ioT
         3s0zkq2Z2MdfxlUtWjw06Wa1ObA437kUfYa7+hZ+aILpITo31dWcI1pxgTH15VuXjQ5S
         Or7uY1Ak4ZKkXl3iyamsMxdErxBW8q+YWXt0dkCHDNdmEOQyViFEaSW0jM6zt64MBEBW
         B0wqKydPPKp42uNgB+l43gRSOPb5x8LjyYMbxuzYnUIhBZHdX4CpfH6oCtfL6zLvevIk
         hYcg==
X-Gm-Message-State: AOAM530aySlxn99BrFRVcCiykln7jmWu9e81vrfhwvuJ5PnKb7pBk75r
        ZTRFfDfoRzs4yoKMfxR6V3JNLBe7hPLuI2Nt
X-Google-Smtp-Source: ABdhPJxx8t7czjj66838ACkQAHLrKQX32majdV5386Oz16gdDBxBwLxzg+wZaNf38FBt7Tx4I4jC9w==
X-Received: by 2002:a17:90a:94ca:: with SMTP id j10mr2711308pjw.59.1621481431235;
        Wed, 19 May 2021 20:30:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s65sm694873pjd.15.2021.05.19.20.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:30:30 -0700 (PDT)
Message-ID: <60a5d7d6.1c69fb81.9e840.3bbb@mx.google.com>
Date:   Wed, 19 May 2021 20:30:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.38
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 173 runs, 4 regressions (v5.10.38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 173 runs, 4 regressions (v5.10.38)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig  | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      689e89aee55c565fe90fcdf8a7e53f2f976c5946 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a5a164d32a6b96aeb3b08c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5a164d32a6b96aeb3b=
08d
        new failure (last pass: v5.10.37-290-g7ba05b4014e8) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60a5a7ea781d77d392b3afd8

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboa=
rd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboa=
rd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a5a7ea781d77d=
392b3afde
        new failure (last pass: v5.10.37-290-g7ba05b4014e8)
        4 lines

    2021-05-20 00:04:58.152000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-05-20 00:04:58.153000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 39.540331] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-05-20 00:04:58.154000+00:00  =

    2021-05-20 00:04:58.154000+00:00  kern  :alert : [00000313] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a5a7ea781d77d=
392b3afdf
        new failure (last pass: v5.10.37-290-g7ba05b4014e8)
        47 lines

    2021-05-20 00:04:58.206000+00:00  kern  :emerg : Process kworker/1:1 (p=
id: 52, stack limit =3D 0x(ptrval))
    2021-05-20 00:04:58.207000+00:00  kern  :emerg : Stack: (0xc2373d58 to =
0xc2374000)
    2021-05-20 00:04:58.207000+00:00  kern  :emerg : 3d40:                 =
                                      c32eb9b0 c32eb9b4
    2021-05-20 00:04:58.207000+00:00  kern  :emerg : 3d60: c32eb800 c32eb81=
4 c144a488 c09c5634 c2372000 ef86c580 8020001d c32eb800
    2021-05-20 00:04:58.208000+00:00  kern  :emerg : 3d80: 000002f3 db4653d=
c c19c7834 c2001d80 c3a2ba00 ef86c560 c09d2d8c c144a488
    2021-05-20 00:04:58.249000+00:00  kern  :emerg : 3da0: c19c7818 db4653d=
c c19c7834 c3a2c1c0 c32bbf00 c32eb800 c32eb814 c144a488
    2021-05-20 00:04:58.249000+00:00  kern  :emerg : 3dc0: c19c7818 0000000=
c c19c7834 c09d2d5c c14481b0 00000000 c32eb80c c32eb800
    2021-05-20 00:04:58.250000+00:00  kern  :emerg : 3de0: fffffdfb c22d8c1=
0 c2432e00 c09a8c84 c32eb800 bf048000 fffffdfb bf044138
    2021-05-20 00:04:58.250000+00:00  kern  :emerg : 3e00: c3a2a9c0 c325a70=
8 00000120 c32306c0 c2432e00 c0a0286c c3a2a9c0 c3a2a9c0
    2021-05-20 00:04:58.250000+00:00  kern  :emerg : 3e20: 00000040 c3a2a9c=
0 c2432e00 00000000 c19c782c bf06b084 bf06c014 0000001e =

    ... (37 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60a5a64fc8a2503aa0b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5a64fc8a2503aa0b3a=
f98
        new failure (last pass: v5.10.37-290-g7ba05b4014e8) =

 =20
