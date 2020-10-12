Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4274E28B446
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 14:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388300AbgJLMBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 08:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388209AbgJLMBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 08:01:02 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D933CC0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 05:01:01 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id b193so13128935pga.6
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 05:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3DbaD950IweCE+INGEXQ2URTYcp343iDhjoGQknJFV0=;
        b=X4dP55Tog2inXL4z26gw8hTh2OB+vol6ZsbAOqN+eVzmpqOwZUTBHdeLwSNGs1uRe5
         iPFlJnATj/c+g76iAAtt5hrHrEgNZwoLUqFSWd2b/S0gMTbnFVY+wq04kZI0BmiD+P6K
         iZLgwL1Eatw6aDZXkm9BkqcS1Yk78QPhbLSN2haUDx3xHGlog0WLealUgKxGnFns3WHL
         7A2DkdiVuMGrR8Mm9qIyy9WMyzsbFuPyEdL7W+QKQjYaiS3xVgwzXberu7fqYeHj9xhL
         8/gowBitypnaMNff2tIRNMTyDIbUEWI99EAwFNkUtciAVo7s6xxZfOR7DJq8O2pLD0GD
         J3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3DbaD950IweCE+INGEXQ2URTYcp343iDhjoGQknJFV0=;
        b=gPaqff+akUZJF2jFfz2PoJUffgBjvyBv3pn4wmei5kobUoRNRQpKrhOW88PewNcmGF
         hiRjHEj3K2nAdMoE9Xqrtn39Uko//3Jt5CHLXU/JWgTG2/KWSA/DOkMi4eUYwfeDS32p
         lxYM9yVOi1XqZMCVWdq0ed+yCsbGu2gVSTm0qO6H1WOqqFyKJXfDZsNDd09g2x2yfZqm
         dFiHT1ADu4JfZi/SRyvSRJCvlLbC02OkW4XUIXGzCVKCkbk1ss/LdJDwmkJAY8vGY74S
         +6Es5b7zRlvifOHWkLjH0RL1H0XyKXs1ptRK6NhwuBSFkgtNjsRY49YdhR5ErwZG461g
         1XqA==
X-Gm-Message-State: AOAM530titb6V773k2ZwGBmeGFi/jdAA3j/bOWUdeClphDSR62YaGUQy
        2SNhEwQF1qL3Nj+wePf5KmSH5jYGcs8Dyg==
X-Google-Smtp-Source: ABdhPJwpbqyYtLOzmykcMWx56n3hAJfj+EUfdFCAkJcT4ZgvRbfwensQ7OBuZ7wE5ajfPZOUzZC3Vg==
X-Received: by 2002:a17:90a:9504:: with SMTP id t4mr3912470pjo.82.1602504060997;
        Mon, 12 Oct 2020 05:01:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x5sm20315139pfp.113.2020.10.12.05.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 05:01:00 -0700 (PDT)
Message-ID: <5f84457c.1c69fb81.bf69a.7702@mx.google.com>
Date:   Mon, 12 Oct 2020 05:01:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-76-g7e5fbbf60f5e
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 142 runs,
 4 regressions (v5.4.70-76-g7e5fbbf60f5e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 142 runs, 4 regressions (v5.4.70-76-g7e5fbbf6=
0f5e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.70-76-g7e5fbbf60f5e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.70-76-g7e5fbbf60f5e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e5fbbf60f5ea4c197157f721480e81477009204 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f83e9e673b835cf1d4ff3f3

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-76=
-g7e5fbbf60f5e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-76=
-g7e5fbbf60f5e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f83e9e673b835cf=
1d4ff3f7
      new failure (last pass: v5.4.70-46-geff08a1fdd2e)
      2 lines

    2020-10-12 05:28:07.907000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-12 05:28:07.907000  (user:khilman) is already connected
    2020-10-12 05:28:23.242000  =00
    2020-10-12 05:28:23.242000  =

    2020-10-12 05:28:23.242000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-12 05:28:23.242000  =

    2020-10-12 05:28:23.243000  DRAM:  948 MiB
    2020-10-12 05:28:23.258000  RPI 3 Model B (0xa02082)
    2020-10-12 05:28:23.344000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-12 05:28:23.377000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (380 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f83ea2a8d28644e5f4ff3e0

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-76=
-g7e5fbbf60f5e/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-76=
-g7e5fbbf60f5e/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f83ea2a8d28644e5f4ff3f4
      failing since 12 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-12 05:31:13.612000  <8>[   23.275142] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f83ea2a8d28644e5f4ff3f5
      failing since 12 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-12 05:31:14.634000  <8>[   24.297051] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f83ea2a8d28644e5f4ff3f6
      failing since 12 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-12 05:31:15.655000  <8>[   25.318409] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
