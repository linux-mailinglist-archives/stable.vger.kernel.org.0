Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C2438E7F3
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 15:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhEXNq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 09:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbhEXNq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 09:46:27 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F171C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 06:44:58 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 6so20117791pgk.5
        for <stable@vger.kernel.org>; Mon, 24 May 2021 06:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GlfZ+7f1cIGj1jZTrYmigVAiFsRaNp8wDABxi+Lk05c=;
        b=1+qmRXjIzrPeRxl1s50RmanahdaMRxpMtVKFJTZseCeYodG8icgyaz/JSG/DM5Kn+R
         sIZ4IKKdkMhSkEb8l5sCLKa+HNLOUb04tslmObKTNH0q4lo0f1J2c1Z5kS//pHpYXiPH
         03n1vRiU6T7e/2kTU7qVB7QYliPAovHa+zWOX6sk6g0UCJIi4N17ndRRTcUg2TIE96pM
         ugd9sB2daqLbz+0Vl2VnZghKmUEJc3fSpkL577JDdbFgKgG2tGx0MBKS4CK+GTm0cLk8
         PCfwJnPWDm4vQaqzzdJKba7PEvTX12SlmJDkhUU2Q40iAfJGtVwd0yUtW992Mcq814yw
         JZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GlfZ+7f1cIGj1jZTrYmigVAiFsRaNp8wDABxi+Lk05c=;
        b=fKQ663s3BzGzAR4fp5AS+cbnWOi1nUGA92HFcLoY/NMTA1qDgg0qI9TtQDV/TevGl1
         tq+927JBPnZA0vILeOa0EQisHDATMPrJ9t3tCGbVtBYOxkSVHfD70c64acgA89Z9RLYI
         wgnhhCqLMKksQ1XJz9O4VLmCFsEFocBMLkOC91whkBJNlfcKiBhBtslAFGoRiVJ13jbw
         thctkmtLBjNwD1OzUzaCl1q5XWBjpDQtImJggUEQuNj4Ax20qlhi23Uazy3QtUWtLNch
         6tWoXdT+kBBzInWVxg4LVWQM7N9CQFNLUCAA38WlScJuhlA4lPHmsxRlcxMiOVjSdPFZ
         Xswg==
X-Gm-Message-State: AOAM533uDn51YK5hDaaQtAKRuHJ3O0OFjEHuXrE5H2dAVF9mk3OJFXst
        qsm/+vTUxO2aHP1dRsVDlx4dkpwZVx/Pz3fI
X-Google-Smtp-Source: ABdhPJy8/m/YuEG6kryZMfD3WaDOcetE3XxQc83PxhjmB5GMrVNOOcRTO/vWp5KKi+reQZD0Mlg27Q==
X-Received: by 2002:a05:6a00:234d:b029:2de:275a:9ce9 with SMTP id j13-20020a056a00234db02902de275a9ce9mr25570296pfj.42.1621863897391;
        Mon, 24 May 2021 06:44:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g19sm10862062pfj.138.2021.05.24.06.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:44:56 -0700 (PDT)
Message-ID: <60abadd8.1c69fb81.2a096.2f4b@mx.google.com>
Date:   Mon, 24 May 2021 06:44:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.39
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 110 runs, 3 regressions (v5.10.39)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 110 runs, 3 regressions (v5.10.39)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.39/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.39
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b561d56bcd16ef44705d4e92f1e9c4d5e63f157f =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =


  Details:     https://kernelci.org/test/plan/id/60ab7ab2aba5ae570cb3afaf

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60ab7ab2aba5ae5=
70cb3afb5
        new failure (last pass: v5.10.38-46-g4313768a0a3e)
        8 lines

    2021-05-24 10:06:28.419000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address c0977b64
    2021-05-24 10:06:28.419000+00:00  ke<8>[   42.756120] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ab7ab2aba5ae5=
70cb3afb6
        new failure (last pass: v5.10.38-46-g4313768a0a3e)
        76 lines

    2021-05-24 10:06:28.424000+00:00  kern  :alert : [c0977b64] *pgd=3D0080=
840e(bad)
    2021-05-24 10:06:28.424000+00:00  kern  :alert : 8<--- cut here ---
    2021-05-24 10:06:28.425000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address c0977b64
    2021-05-24 10:06:28.426000+00:00  kern  :alert : pgd =3D 986a4d49
    2021-05-24 10:06:28.426000+00:00  kern  :alert : [c0977b64] *pgd=3D0080=
840e(bad)
    2021-05-24 10:06:28.462000+00:00  kern  :emerg : Internal error: Oops: =
8000000d [#1] ARM
    2021-05-24 10:06:28.463000+00:00  kern  :emerg : Process udevd (pid: 10=
6, stack limit =3D 0x3e196364)
    2021-05-24 10:06:28.464000+00:00  kern  :emerg : Stack: (0xc426fe38 to =
0xc4270000)
    2021-05-24 10:06:28.465000+00:00  kern  :emerg : fe20:                 =
                                      c4288300 c426fe84
    2021-05-24 10:06:28.466000+00:00  kern  :emerg : fe40: c428830c c426fec=
4 c426fe74 c426fe58 c0295a44 c068ba74 c068b5b0 00000001 =

    ... (45 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60ab7ea367eeda83a2b3afb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab7ea367eeda83a2b3a=
fb4
        failing since 4 days (last pass: v5.10.37-290-g7ba05b4014e8, first =
fail: v5.10.38) =

 =20
