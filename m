Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782C124C054
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 16:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgHTOMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 10:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgHTOMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 10:12:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB43C061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 07:12:16 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id c10so2619540pjn.1
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 07:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SmFWYpljLoXOWAkHi/CYFH+N/Avuqz514QaOrKw+n/A=;
        b=fXmfrP8kT7qzRhjyCgwIc0R3jZF5qk+d0HQ2Eoi/G2mkgZeQg2mY+UcrSOS2fgxhMJ
         pWEGd0xsoie5cCvSfyUTochRYhmughXj0A8e4u0cwoJ8ux96kjqe6h5wtL+NA0AIEj4u
         E5AI9P+ajXYC2JHTiXC2tgRamlx5/rEb3iCZOay5Dt1y5qqCmqadFrM6uCCjVRXy7Jt7
         kgKrdHhp/4pkylk7PUgcbTLA77kBkOo/Z6KOpgaEg0PtvldB9uwo+BUQh5yaQHonCz7k
         E80lpZOqhss77xOa1oPJiDS/85ir7C4uEbPCFTodLiQ3d46dPg+9V+i8Ul71N/nq+gr4
         qvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SmFWYpljLoXOWAkHi/CYFH+N/Avuqz514QaOrKw+n/A=;
        b=RhAiTmXzX02vOq8K8liTv+yNnS1gxXePQ5ipE2nXU/axHl8kcVxIIpDHJcGRuHUXBT
         XQEG8O2sY3enzgNA48cN6yjpActgqdsg/HL+9EDn6b+k36z16MePTrdaHjshbWotp7Wb
         9xBi5OUdUQWQAxcTj8EONUTgjKGXkXBQ4W766n0MVbiRt5VPmK+cQFWvTAHKEtnGj/Sk
         EMnMW0zb6LUvz4/sP/eX9HVbftAsbj0GiC85JDPcrLldl94sqmv1T37Mhjv68G34Q1I6
         WthYIwa+FVWVyDCCvd5wvcDuDpEyfNiRDswZFIzSOwNr3E3N9JUTQUzovUgm8z26vQzz
         LLMA==
X-Gm-Message-State: AOAM53244QJCsXehiK+lRYEgC/5Qjz6p98V2iXuMU7swX1WLRJHZ6/Ve
        EtMKGITsCci+qfnxYm5r5BIBXg29dlB7bw==
X-Google-Smtp-Source: ABdhPJwVOqUk3U5su1GQKmwf+1f7UdHC/f8PGOeSqu0AVDiU0nCfkLd3/G93hSnl7K6qxPgwPlzKzg==
X-Received: by 2002:a17:90a:f313:: with SMTP id ca19mr2779469pjb.226.1597932735206;
        Thu, 20 Aug 2020 07:12:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c20sm312845pjv.31.2020.08.20.07.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 07:12:14 -0700 (PDT)
Message-ID: <5f3e84be.1c69fb81.2b296.08c7@mx.google.com>
Date:   Thu, 20 Aug 2020 07:12:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.140-93-g294e46de3a1d
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 158 runs,
 3 regressions (v4.19.140-93-g294e46de3a1d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 158 runs, 3 regressions (v4.19.140-93-g294=
e46de3a1d)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =

hsdk                  | arc   | lab-baylibre | gcc-8    | hsdk_defconfig  |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.140-93-g294e46de3a1d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.140-93-g294e46de3a1d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      294e46de3a1d3cb90ac476ac92ffc835a7a1e716 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3e4fd115129f4c2ed99a39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
40-93-g294e46de3a1d/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
40-93-g294e46de3a1d/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3e4fd115129f4c2ed99=
a3a
      failing since 65 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f3e4f3ece23fa4badd99a44

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
40-93-g294e46de3a1d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
40-93-g294e46de3a1d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3e4f3ece23fa4b=
add99a46
      new failure (last pass: v4.19.140-49-gb66477930082)
      1 lines

    2020-08-20 10:23:42.016000  / # =

    2020-08-20 10:23:42.027000  =

    2020-08-20 10:23:42.130000  / # #
    2020-08-20 10:23:42.138000  #
    2020-08-20 10:23:43.398000  / # export SHELL=3D/bin/sh
    2020-08-20 10:23:43.409000  export SHELL=3D/bin/sh
    2020-08-20 10:23:44.970000  / # . /lava-10056/environment
    2020-08-20 10:23:44.981000  . /[   27.546207] Bluetooth: hci0: command =
0x0c14 tx timeout
    2020-08-20 10:23:44.982000  lava-10056/environment
    2020-08-20 10:23:47.810000  / # /lava-10056/bin/lava-test-runner /lava-=
10056/0
    ... (9 line(s) more)
      =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
hsdk                  | arc   | lab-baylibre | gcc-8    | hsdk_defconfig  |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3e50d280c9fc2bdcd99a3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
40-93-g294e46de3a1d/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
40-93-g294e46de3a1d/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3e50d280c9fc2bdcd99=
a3e
      failing since 30 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
