Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78BE309F0D
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 22:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhAaVPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 16:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhAaVJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 16:09:54 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F209C06178A
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:09:12 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id t29so10234092pfg.11
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=udQZ8KEM31I1ohSIYhV4f++zFFrptyo2SsdheTOBF2c=;
        b=ExOajPF0JFFgeNnp+kP25WBrik13PjYCqricmxzBtuslEAIo6XhF+1mx1n4kK8ATQS
         tAid4BJbU8702GzDc6SD+cgTvClE/Z5zBKKxa4lVryoWjK4GfdXc3J5/EzUtg/jH26a9
         a/38s563Kf+nDmU6sLeYvNJV7lEB00W8X6GI9tBp1stwDmGUKoPy5NMWZDG4TWDe2kJn
         f5dJ+i/1SPmeWigS5uYE68bitzKb0Z1fjzVH9eqVisXgnVW0BiUPbYGiwK+p+Dt3yjVf
         eBihTX/27cEwgZeepEVh1gP14JTMG4q35W7aH3pktlTvkBTZbhEe4TVRxGmvlT2u2E+g
         jc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=udQZ8KEM31I1ohSIYhV4f++zFFrptyo2SsdheTOBF2c=;
        b=jA0LReUb1U6kXMKQwdDDD9QNV/kqebShi21Xzn9yJR31/Do3A7yxenjCMlNKczoc8R
         RyzNIwjFJ7SV530IuvPuL/7AgXJ0wqOAw7IBQtca+dgJ7815ycIZPEFCpnTynuouaoIc
         zfFI5Q+vSraJPRCrinCL8XjTGKSdPzcxOGfz3fXeTqENahz6dGJchr+8NouY5o68+AxZ
         +tGvLHdhuz0LlrI90s2we4cCEk17dh40SRIrkgi15e8UgmHlad6tT2f3DQ+MRLtlB/vL
         ZBE0sUjAXuh+vIxXNOBuluWc/ADJYGyXKXRRyO9944J/RpCXhZtEjcje4/kMTvYRjJlK
         gKpw==
X-Gm-Message-State: AOAM531Q32XpqrVndUN+MWLbVFtGkAW5GDvYFgezVLmhhW6U5AIT0PPo
        lwTnaqJ7qUKM4YcxjtB05lpx8qjm9NWujw==
X-Google-Smtp-Source: ABdhPJyDbCCdltYJkrp+cFyJx6lFGm5BwNkyCbXwxPOQ6hIBfotCMx77gdRcln2uOCsNc73LC861PQ==
X-Received: by 2002:a65:5bc8:: with SMTP id o8mr13768343pgr.100.1612127351325;
        Sun, 31 Jan 2021 13:09:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o1sm275957pjk.18.2021.01.31.13.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 13:09:10 -0800 (PST)
Message-ID: <60171c76.1c69fb81.8d40f.0a03@mx.google.com>
Date:   Sun, 31 Jan 2021 13:09:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.12-31-g38757cf9716b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 183 runs,
 4 regressions (v5.10.12-31-g38757cf9716b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 183 runs, 4 regressions (v5.10.12-31-g38757c=
f9716b)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =

meson-gxbb-p200          | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.12-31-g38757cf9716b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.12-31-g38757cf9716b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38757cf9716b32dc71c4fed9c6a30dd2e2579794 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/6016e7058db3bfe154d3dfe2

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
31-g38757cf9716b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
31-g38757cf9716b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6016e7058db3bfe=
154d3dfe6
        new failure (last pass: v5.10.12-3-g0bb4aea7b36b5)
        4 lines

    2021-01-31 17:20:35.916000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-01-31 17:20:35.917000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-01-31 17:20:35.917000+00:00  kern  :alert : [<8>[   11.322493] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-01-31 17:20:35.918000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6016e7058db3bfe=
154d3dfe7
        new failure (last pass: v5.10.12-3-g0bb4aea7b36b5)
        26 lines

    2021-01-31 17:20:35.969000+00:00  kern  :emerg : Process kworker/2:2 (p=
id: 81, stack limit =3D 0x(ptrval))
    2021-01-31 17:20:35.969000+00:00  kern  :emerg : Stack: (0xc33cbeb0 to<=
8>[   11.369657] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-01-31 17:20:35.970000+00:00   0xc33cc000)
    2021-01-31 17:20:35.970000+00:00  kern  :emerg : bea0<8>[   11.381042] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 660830_1.5.2.4.1>
    2021-01-31 17:20:35.970000+00:00  :                                    =
 c176a600 c396c674 00000000 cec60217   =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6016ece1eb9c978647d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
31-g38757cf9716b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
31-g38757cf9716b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016ece1eb9c978647d3d=
fca
        new failure (last pass: v5.10.12-3-g0bb4aea7b36b5) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxbb-p200          | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6016edc7bdc43e3a04d3dfe3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
31-g38757cf9716b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
31-g38757cf9716b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016edc7bdc43e3a04d3d=
fe4
        new failure (last pass: v5.10.12-3-g0bb4aea7b36b5) =

 =20
