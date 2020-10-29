Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5330B29E442
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 08:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgJ2HfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 03:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgJ2HY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 03:24:57 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B34C0610D2
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 22:30:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 10so1410852pfp.5
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 22:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t5aqIeN02QdRTHeekp8DnNUp+q+mIfpDwpQEf+PVuAE=;
        b=lp6I+Xq3SQqWCcWDTtyazC3Q9EGKN0DLC40tqlJJF7Y0Zm5iDeUNI2dDWGyk+u0lYB
         kOjHjsEPocMGf+LUKu8fyg1X80Hy9vK9NfeoHc8TNI1vhL/dixPTG9i38SOooi6mMP3G
         AWAJOJhuOgMwKLkQQC4205Y5J4tIzXaXdgeoN4UUpG1nqSm+5gN+HNapMxxSA2e/0OGP
         22WUhcxrWtdBbD+93MIYV8Pl5XvLYnObdvv4UBc0NiSUP6CK84zKfou9yXXpVWWqATDZ
         Xf3nTQVuhIZSaJvda1ipvus7XQtkbRtiUblGd64P7pyafs3rHGqpEcHTHQKMLPCnAHXH
         +qXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t5aqIeN02QdRTHeekp8DnNUp+q+mIfpDwpQEf+PVuAE=;
        b=Pb4Vn9WQarvjKu9KOMMRYKe6LeNxsG6SC52Y4IKp2KWmgo6BpP3J5swY2+pmz+8/GH
         xfvquxmhOujMDBwIMfWeJQ1EXmcwuCmHHeK5K7d7AYXdUgBFVw8qbE4AoXWrgbjgauTv
         LtZ//PXUkXlOQWXRiY/uSBUSebPfgWIjxLgWeH4Gvs5aGBUjPfbo0uphwc7RTF9uqoFN
         hB9nvOVOeGSYLyJfc2mKjzY/kEp0HZXNzq/ApKTCKdithbzGXuIQiyjrUn1mJECGtaSl
         vSzdEbiXxBygsdfKKt0rTFBk3TQcaTtpADEAv8r4MM6Jjhf2d/W56aMv3Uk0fiPkJ7BW
         QF5g==
X-Gm-Message-State: AOAM530qG1AhUao+evod4/wYFGxQFMMcEdOwUGwLWiO7+bFMOvOEuZBF
        vQ0NfaOWNI725Gu7VYqwyGn8CZhatLJC2Q==
X-Google-Smtp-Source: ABdhPJy9YQmH13DU8n3UcKdhILMOVUCjNEmpIz8ox0Z/Px24AxfMhVwee3zi2oIKbUxaWBe77vXz3A==
X-Received: by 2002:a17:90a:6301:: with SMTP id e1mr2517483pjj.131.1603949443466;
        Wed, 28 Oct 2020 22:30:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 194sm1325344pfz.182.2020.10.28.22.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 22:30:42 -0700 (PDT)
Message-ID: <5f9a5382.1c69fb81.d700b.4144@mx.google.com>
Date:   Wed, 28 Oct 2020 22:30:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-146-g77699231ef31
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 186 runs,
 3 regressions (v4.19.152-146-g77699231ef31)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 186 runs, 3 regressions (v4.19.152-146-g7769=
9231ef31)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

beagle-xm       | arm   | lab-baylibre  | gcc-8    | omap2plus_defconfig | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-146-g77699231ef31/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-146-g77699231ef31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77699231ef31707b7a32ebb22682bc7cd4e8a4b2 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1e95572b346f62381035

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-146-g77699231ef31/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-146-g77699231ef31/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9a1e95572b346f=
6238103a
        failing since 1 day (last pass: v4.19.152-261-gd2b228260b67, first =
fail: v4.19.152-265-g35a69550df89)
        1 lines

    2020-10-29 01:43:02.844000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-29 01:43:02.844000+00:00  (user:khilman) is already connected
    2020-10-29 01:43:18.629000+00:00  =00
    2020-10-29 01:43:18.630000+00:00  =

    2020-10-29 01:43:18.630000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-29 01:43:18.630000+00:00  =

    2020-10-29 01:43:18.630000+00:00  DRAM:  948 MiB
    2020-10-29 01:43:18.646000+00:00  RPI 3 Model B (0xa02082)
    2020-10-29 01:43:18.733000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-29 01:43:18.765000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
beagle-xm       | arm   | lab-baylibre  | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9a20cf6f31e66cea381051

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-146-g77699231ef31/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-146-g77699231ef31/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a20cf6f31e66cea381=
052
        new failure (last pass: v4.19.152-265-g35a69550df89) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1ff4cdba17f1c038101e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-146-g77699231ef31/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-146-g77699231ef31/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9a1ff4cdba17f=
1c0381025
        failing since 2 days (last pass: v4.19.152-260-gbad1094e2c61, first=
 fail: v4.19.152-261-gd2b228260b67)
        2 lines =

 =20
