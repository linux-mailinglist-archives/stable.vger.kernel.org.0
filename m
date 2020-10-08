Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50C1286C93
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 04:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgJHCID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 22:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgJHCID (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 22:08:03 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6215C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 19:08:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 7so2899845pgm.11
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 19:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tUKn7hTgkxQp4VCVIHeiH08QXEzETrR7jDEndVSe+gc=;
        b=srh2vTe0GPymqlOPlY7WL/wasFWKr8hxzWOdTM+XdcAhO/ZbhXn7ZflZDOxhOW8Q2a
         8IN+NL42ngO+dwGKfl3pFnKqaPVZ8lkNQDW3nNAeee9KDAKjEMYbRC2872lOw43HA9mK
         gpFC1t3LjUH+KF4ch4YBnzTWPPyhiEYdG0Z0SEKtg/xsWCKn8tZPHdVur4tZEMGztqDI
         vZmZ1LgIqDPRTnEnRoDBC40Su9KxsERHphl3V5r0Fim7gOT6504riEoIvPs/+gdkLy1s
         h3tSihDo/ikAWnp2Mkur0OUyoRuh57oRP+Q9nnuWlZKw/kT8c0tDjBP5aDpan17xVOY1
         +G4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tUKn7hTgkxQp4VCVIHeiH08QXEzETrR7jDEndVSe+gc=;
        b=Z8RYzc/kYrP9PyPEXEluOfEbd06ns8nj8SMtrXolYQIeTit0/0KVU2Xdkv7JqVPR/S
         TSmehEX/drXxhrS4T+Glbc1nNGSr6DPuRiU3M+OPBhN92xO3w37VM1olO4JMpRa2bf0r
         OXBxM/PIC4raOXrsjpgNWA3q/MlHS98Wwz4BTdyIY7qXiR/dnPROylQ5/tM8hWoMZ0kG
         balZytub7db9wbPeEZwfu/P9qgi4e9Dg3LRJO2+++XjPwGg0yNgxbJVULFhwZ0sZ5C9/
         dzVlNClYMGC57xk6XXBfaESO6F2MRvZ2HX8wpXR8hdcCg/lFVfHFQpLHZeTa7DTbkHey
         OUrQ==
X-Gm-Message-State: AOAM5333j89UjVhoJME2JHa2bZuwHWWVgkZ4LGSSYfwXI7g6NQ43nk7W
        DFVPe7qe63g9Le5thqieNQx3/Oeq2YuZeQ==
X-Google-Smtp-Source: ABdhPJy2kcccuVG/kRgAAaADAPTKYdgxXKR8qxP8jMenwxCeO04/qe+L4lPN0djdT62xN01DqPF2WA==
X-Received: by 2002:a63:535e:: with SMTP id t30mr5289983pgl.157.1602122880981;
        Wed, 07 Oct 2020 19:08:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q4sm4596651pjl.28.2020.10.07.19.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 19:08:00 -0700 (PDT)
Message-ID: <5f7e7480.1c69fb81.c5252.8a74@mx.google.com>
Date:   Wed, 07 Oct 2020 19:08:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-66-gb916ff7b71f9
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 101 runs,
 4 regressions (v5.4.69-66-gb916ff7b71f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 101 runs, 4 regressions (v5.4.69-66-gb916ff7b=
71f9)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-66-gb916ff7b71f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-66-gb916ff7b71f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b916ff7b71f93014bf4282ef9812e2cd2db60b56 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7e15cdb5d009c0214ff3e0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-66=
-gb916ff7b71f9/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-66=
-gb916ff7b71f9/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7e15cdb5d009c0=
214ff3e4
      new failure (last pass: v5.4.69-62-gc2842380f027)
      1 lines

    2020-10-07 19:21:56.263000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-07 19:21:56.263000  (user:khilman) is already connected
    2020-10-07 19:22:12.159000  =00
    2020-10-07 19:22:12.159000  =

    2020-10-07 19:22:12.160000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-07 19:22:12.160000  =

    2020-10-07 19:22:12.161000  DRAM:  948 MiB
    2020-10-07 19:22:12.174000  RPI 3 Model B (0xa02082)
    2020-10-07 19:22:12.262000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-07 19:22:12.294000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (376 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f7e1596ffb1fdc0a64ff3f2

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-66=
-gb916ff7b71f9/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-66=
-gb916ff7b71f9/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f7e1596ffb1fdc0a64ff406
      failing since 8 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-07 19:22:45.329000  <8>[   22.928054] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f7e1596ffb1fdc0a64ff407
      failing since 8 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-07 19:22:46.351000  <8>[   23.949708] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f7e1596ffb1fdc0a64ff408
      failing since 8 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-07 19:22:47.372000  <8>[   24.971503] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
