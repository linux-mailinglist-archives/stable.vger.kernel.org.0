Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CD240A24D
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 03:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbhINBF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 21:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbhINBF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 21:05:26 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11783C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 18:04:10 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id n18so11081706pgm.12
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 18:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ac350+E/FAsBFuR1kSgp+ws0ZScKxtG0U4hqdhSmtPw=;
        b=vIk0VjiR/BxlvoNvmVWoAnASRncYwyl3S+k9VJINEP2nIlFYpeKP2Qa9x2cpkilYtB
         hfelBKlLtY2gvua7Ip2vgSoPCJqyrJ4OTL57GVizlLlCzV369KtOOzhhTvZbw9rfPOtQ
         tl7DJMhMV8HOpnDFQ3n7FgFprpzSrXm+3+RNzBb3FgZGPvIaoVdF9Uu2jj9Db3k0ohVP
         xfm90NmNRlcskK8chCCvKdNYn8l9YQSoV9CloXl5UPvfLnunIQ9QzZn0vhrJ8sgBXLnH
         OvHbBqg8FmW938UkjIa6bIjgScIKcA+J7arFz4KtkZXItuQQn21M12biePAoXHfpJn8m
         4MFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ac350+E/FAsBFuR1kSgp+ws0ZScKxtG0U4hqdhSmtPw=;
        b=4nbNteRS2CYU6uhGIdGrEgZ3zRUWedSJYLcyxa57H/z21CAw22euEBv5tFxQc+HXiW
         piIAiTZk9Kc4D0GeC9px+jdPvjcsJy8vUotUcThfvxgz+axE+77Q+UG8Y6G7ez9R57YD
         SxaJv6bSDlY7kMLHo7DwlUoTGvPu5d9nuz/4gall/TdePvRDZzq9WIcPi41Ae0jdRbT6
         tqkKe8JZKZT+fXFUloTUpUpZRrJweZjWT3dSOc2IXsjkRZuhiIwIYIIfgIPtO4w+qCiX
         t/OzuUhYt+lVzo+Vy/XGmLUc0GcQQj5ridjQK4hkGkos44bPoltRBoosLeapaTitRfx0
         YGvA==
X-Gm-Message-State: AOAM530wWa305GMF/bQRBYh+D4dc2/aL0jd8vJfK1oV5xgfpa87zNaSP
        wEQ+hGBpX5m2RX0lnmam8hOD8aLQp3BtlxPg
X-Google-Smtp-Source: ABdhPJwv+OBaSb7Se8x326kyGj2fNI82nqMcceoLT/Y2XfHuh8pVEsVxEcU6pecmPrmlW6lHsB/w5g==
X-Received: by 2002:a63:4f17:: with SMTP id d23mr13316777pgb.253.1631581449392;
        Mon, 13 Sep 2021 18:04:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c21sm8215822pfd.200.2021.09.13.18.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 18:04:09 -0700 (PDT)
Message-ID: <613ff509.1c69fb81.6bade.839d@mx.google.com>
Date:   Mon, 13 Sep 2021 18:04:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.64-237-ge306b25768e3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 167 runs,
 5 regressions (v5.10.64-237-ge306b25768e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 167 runs, 5 regressions (v5.10.64-237-ge30=
6b25768e3)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =

sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.64-237-ge306b25768e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.64-237-ge306b25768e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e306b25768e344bf338aeb3b1439af89af21b31e =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/613feece6797cae7f399a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-237-ge306b25768e3/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-237-ge306b25768e3/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613feece6797cae7f399a=
2ff
        failing since 74 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/613fc1cbe837109b6b99a32d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-237-ge306b25768e3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-237-ge306b25768e3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/613fc1cbe837109=
b6b99a334
        new failure (last pass: v5.10.64-215-g5352b1865825)
        4 lines

    2021-09-13T21:37:57.909487  kern  :alert : 8<--- cut here ---
    2021-09-13T21:37:57.940421  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-09-13T21:37:57.940720  kern  :alert : pgd =3D (ptrval)
    2021-09-13T21:37:57.941879  kern  :alert : [<8>[   39.580604] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-09-13T21:37:57.942181  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/613fc1cbe837109=
b6b99a335
        new failure (last pass: v5.10.64-215-g5352b1865825)
        26 lines

    2021-09-13T21:37:57.993463  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-09-13T21:37:57.993764  kern  :emerg : Process kworker/1:3 (pid: 66=
, stack limit =3D 0x(ptrval))
    2021-09-13T21:37:57.994288  kern  :emerg : Stack: (0xc306feb0 to<8>[   =
39.627296] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-09-13T21:37:57.994562   0xc3070000)
    2021-09-13T21:37:57.994813  kern  :emerg : fea0<8>[   39.638869] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 841491_1.5.2.4.1>
    2021-09-13T21:37:57.995060  :                                     00000=
000 00000003 c306e000 cec60217   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/613fc2ca8a24fac2fb99a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-237-ge306b25768e3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-237-ge306b25768e3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fc2ca8a24fac2fb99a=
2fc
        failing since 0 day (last pass: v5.10.64, first fail: v5.10.64-215-=
g5352b1865825) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/613fc2313f51a31d5d99a31c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-237-ge306b25768e3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
4-237-ge306b25768e3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613fc2313f51a31d5d99a=
31d
        failing since 0 day (last pass: v5.10.64, first fail: v5.10.64-215-=
g5352b1865825) =

 =20
