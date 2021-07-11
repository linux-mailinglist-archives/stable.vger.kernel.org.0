Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D888C3C3F90
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 23:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhGKV6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 17:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKV6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 17:58:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE86C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 14:55:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s18so837863pgq.3
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 14:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8vbGoSpBc+ViojDUK5kkNureQF37PzET44DNZEi1svw=;
        b=NeqYa/OZTjY3FqHo73qSmcPw/7s/8KzNxu7SdMwVER0FhK44QlnF5nax6E4dLnLfIJ
         egMzpAH+WS00Pp+DZR/fiFjH/Epq9vDxxaaupK0mO2L29SIyDaDy9xDnxhYFuKkFN7c7
         BR6CsMhAnUaHZ2KHg3m8IRVas9Ib/jR2Sn9VDRM7NxPOt4v5+LdpY2PhLmctjM/ciZlj
         iiqyQwVe70g/DpjEDckvBROd8WUQBW6HhlDY3iON4x0lBR57SoBfoeXduprlhnj/gKBc
         HblIPrqHd/aWkvkjc2PTspVHu5FDGnQo8zsnUeEU8gZsAoQOk7Bt8pRd9lsMxYSntE1A
         7LFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8vbGoSpBc+ViojDUK5kkNureQF37PzET44DNZEi1svw=;
        b=DVT6ikgNdWt2Hv9I2ge7XhB/SXFJcBbqztZK6CPbDsfC3cB5XS2q1xtyCxqndIzoS/
         IdVuBcdl7vuin6g7t+xxA8I0TceCZWnuX4APz+kOIy27h45YJpFVPfkhZirstvrIj5Zr
         K60KYcei4nFPKGs/5dJKVf+DIR+7EJR8t+nsL3Tu+isxDU7LvzUuZfIqCnRduu0G4skY
         hU2kXKw514INRZmrkLnPPbXlNT1Cnk8oyPlelUs56EJrWM6WAHHE2T59mKGU2RbeBjyw
         e1GvOuAiHns0pChOICAIlpddkDgTdoMBqzC4QS9EYVPUHyZIYyklQsRYiHk4FxlLedhh
         +Wkg==
X-Gm-Message-State: AOAM532yEvrwYVhrh+5ma/mZJj8zAMzTcAGUMHgunFgJ0c+EV2kJRFaO
        VZVrZdmNrbonfUCiSFy9uq2NZS8xwLwuynNi
X-Google-Smtp-Source: ABdhPJw6y+K3VCJSo6yikZGdHsasTY0FxM3jUHkdi7zTGv4ALTLKJaycelptjNaGq0hhxg46ppu6dg==
X-Received: by 2002:a63:4650:: with SMTP id v16mr50115536pgk.90.1626040530651;
        Sun, 11 Jul 2021 14:55:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18sm18346641pjq.48.2021.07.11.14.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 14:55:30 -0700 (PDT)
Message-ID: <60eb68d2.1c69fb81.ae906.72b7@mx.google.com>
Date:   Sun, 11 Jul 2021 14:55:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49-581-g85a3429452df0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 188 runs,
 7 regressions (v5.10.49-581-g85a3429452df0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 188 runs, 7 regressions (v5.10.49-581-g85a=
3429452df0)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
          | 1          =

d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

hip07-d05         | arm64  | lab-collabora | gcc-8    | defconfig          =
          | 1          =

r8a77960-ulcb     | arm64  | lab-baylibre  | gcc-8    | defconfig          =
          | 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.49-581-g85a3429452df0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.49-581-g85a3429452df0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85a3429452df0e4481f89908cf1e02036ae3cabd =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb3c3aec2f2b837e11796f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb3c3aec2f2b837e117=
970
        new failure (last pass: v5.10.49) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb3ea62e7c8cfba6117993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb3ea62e7c8cfba6117=
994
        new failure (last pass: v5.10.49) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
hip07-d05         | arm64  | lab-collabora | gcc-8    | defconfig          =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb47a24b04f7091d117978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb47a24b04f7091d117=
979
        failing since 10 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
r8a77960-ulcb     | arm64  | lab-baylibre  | gcc-8    | defconfig          =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb38df7c60f8fe811179b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-u=
lcb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-u=
lcb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb38df7c60f8fe81117=
9b2
        new failure (last pass: v5.10.49) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:     https://kernelci.org/test/plan/id/60eb6499b3622c4adf11796b

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-581-g85a3429452df0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb6499b3622c4adf11797f
        failing since 26 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-11T21:37:10.160775  /lava-4178056/1/../bin/lava-test-case
    2021-07-11T21:37:10.179277  <8>[   13.092112] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-11T21:37:10.179742  /lava-4178056/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb6499b3622c4adf117997
        failing since 26 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-11T21:37:08.734619  /lava-4178056/1/../bin/lava-test-case
    2021-07-11T21:37:08.751940  <8>[   11.665525] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-11T21:37:08.752395  /lava-4178056/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb649ab3622c4adf117998
        failing since 26 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-11T21:37:07.721166  /lava-4178056/1/../bin/lava-test-case<8>[  =
 10.645992] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-11T21:37:07.721696     =

 =20
