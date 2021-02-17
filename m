Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0369A31E333
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 00:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhBQXq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 18:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhBQXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 18:46:27 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17CEC061756
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 15:45:46 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z9so264329pjl.5
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 15:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s6BFsJAWlHWGq0IkwYWM+ZPrYPC67lXxqBZojqe5hX8=;
        b=JskOPP4fCeSlivJQa0b0KZzSLbMUze8pOjd96xXSm/Z5aSXX8BaW87hdj+BVXpN36s
         OnIkQvADfOfND4P0egEX1wr3YV/dTPeWUWQ4Z+aqZZ3WEVpFJZF88f/9/I9WCJ/BZdd2
         Qlwh5QAZGz8lTbNiMLB3RVycCgkznbAxEVVIjp/0j+T19a8q1ppJrZGh0pIXAQqNvOKu
         U2ccRQtPGby9KnJ4WYR3zKXseopU4IBOMaeCcDkGJfwZUkiaJGRyOkkQYoBnBye8Sako
         +oTXC3xTY5QwuiSgkpRu0p+dXuSEBptl++u8dcmerkfh3q4XjZRdPGoP14A9G1pplOZg
         +Zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s6BFsJAWlHWGq0IkwYWM+ZPrYPC67lXxqBZojqe5hX8=;
        b=MYuP40Psa61ToOX0qeY9Cy1NyU+7i0tBy+PkljEyp758ezCWPq2fI3Ohgf4G0p4Znz
         yN1Xm5hFfrvXke0lbk9n+mL3lyt3iHfNvzV+q6rVqC0Jr6bWSdmQjdybb6KNHNtJrAtf
         8U+BhugiWnEQ8BATKK+AURO79C6VOumkMePdK7ntXz1u9FN81eSM+i8x7Ckt8nKVm1pA
         poUYCpNMrYHbYVwLcPXpzyVT0VuPmrlv+nCoNFfLCxPJD75oEzyir1XuGsHD0NzRITYm
         usQD2qhHhTRq0ahxYs+/XOoTaLRmbhrdtlLHraG+dSqJOZFQYVW11A6a/xKHVJASms89
         lBTA==
X-Gm-Message-State: AOAM5320qSKjZH0WWk5NQaDUbHiDOsd16U6HL6qlG7SPRoMe+NOCleJu
        Pb4UlSU5TW8Z/txStGF1Spyx2ITQO8+OKQ==
X-Google-Smtp-Source: ABdhPJyvxKJHi7NVkiF/8GKj3pUOHKSgJRNxVsc+SJ594SpYMcmRwRSuUfWcG1Hik6m7Oe7sQsHelQ==
X-Received: by 2002:a17:902:c083:b029:e3:46fb:8e58 with SMTP id j3-20020a170902c083b02900e346fb8e58mr1332428pld.62.1613605546054;
        Wed, 17 Feb 2021 15:45:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h11sm3496826pfr.201.2021.02.17.15.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 15:45:45 -0800 (PST)
Message-ID: <602daaa9.1c69fb81.a9b50.839c@mx.google.com>
Date:   Wed, 17 Feb 2021 15:45:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 116 runs, 3 regressions (v5.10.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 116 runs, 3 regressions (v5.10.17)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b          | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13b6016e96f628ac1cfb3c0b342911fd91c9c005 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b          | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/602d72cef2e6a2000eaddd0c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602d72cef2e6a200=
0eaddd0f
        new failure (last pass: v5.10.16-105-g643709657afaa)
        3 lines

    2021-02-17 19:44:36.469000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-17 19:44:36.470000+00:00  (user:khilman) is already connected
    2021-02-17 19:44:52.430000+00:00  =00
    2021-02-17 19:44:52.430000+00:00  =

    2021-02-17 19:44:52.430000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-17 19:44:52.431000+00:00  =

    2021-02-17 19:44:52.431000+00:00  DRAM:  948 MiB
    2021-02-17 19:44:52.448000+00:00  RPI 3 Model B (0xa02082)
    2021-02-17 19:44:52.531000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-17 19:44:52.563000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (401 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/602d737a3c37c27fceaddda4

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboa=
rd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboa=
rd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/602d737a3c37c27=
fceaddda8
        new failure (last pass: v5.10.16-17-g91ae446e84dab)
        4 lines

    2021-02-17 19:50:05.627000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-02-17 19:50:05.628000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-02-17 19:50:05.628000+00:00  kern  :alert : [<8>[   45.832020] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-02-17 19:50:05.629000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602d737a3c37c27=
fceaddda9
        new failure (last pass: v5.10.16-17-g91ae446e84dab)
        26 lines

    2021-02-17 19:50:05.679000+00:00  kern  :emerg : Process kworker/1:1 (p=
id: 53, stack limit =3D 0x(ptrval))
    2021-02-17 19:50:05.680000+00:00  kern  :emerg : Stack: (0xc2459eb0 to<=
8>[   45.878575] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-02-17 19:50:05.680000+00:00   0xc245a000)
    2021-02-17 19:50:05.680000+00:00  kern  :emerg : 9ea0<8>[   45.889652] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 735588_1.5.2.4.1>
    2021-02-17 19:50:05.681000+00:00  :                                    =
 1e9b10fe 4306d536 ef86abe0 cec60217   =

 =20
