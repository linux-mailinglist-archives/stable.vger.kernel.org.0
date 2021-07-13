Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731483C68BC
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 04:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhGMC77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 22:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhGMC76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 22:59:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A8EC0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 19:57:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso1041938pjx.1
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 19:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5ELJvJJyW1NAS4p/TNQIvyK2urz5grlqbqsXURQwAQ0=;
        b=NdWTtoLmBjzmn/Fb3Wnj5ZQmi+AICYUWNtZo+gr0mc3gwd9hegDFlCTRI8ApygtnDX
         cGAXmHxj+uQeZt8Xkv8x7q3okJb2eneEzNwQ3Zb4KRweep7OY1cdxlRCK8rnmDIgWYKq
         iiSC7Y1rmm8WCzjDGxzX9KbjgO2ah/fT+5ALfX4LJcqK41LQV8sJJOKl9uk4Pcin02Tq
         ngrC0EM1EX1b71mKt6EiYs7gt498iRh5LyyLirMTyUvfPwtCUJoHexOE+pNWjrkvkhgP
         wSGU2OCa1Y/OqL8YwVumK9z6d+C/L6lBB/wVy/yBoG+hwudjeGF74SSidi+gFh468Zjc
         vjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5ELJvJJyW1NAS4p/TNQIvyK2urz5grlqbqsXURQwAQ0=;
        b=qX5md3kUiV7P/ICARvjZdKNv0b/8sKCamLwgpwkbnT08mGKqdVONIwpVZ1vjEsACyz
         qB4QaAMn5AsabdlM7NW1pT2HrZ5LcC0NNbGDZ7ghgwUpZqR3a1jooSUi4gUCUMetWXSx
         0ZZG6c/7LdVsir5uPoGgbZ8ZZ0BT9qHko2/YP3QA2T6PLIFI+bgoKZy6jjLNsS1IWKuv
         Tep6+N5TVOQ0qYB5FGjMeZ78lvUsPBQtlFC7av1bHdU1VzlaDOzGZqyK/VFznnQfdfuk
         /t6ralT5m7qTl/j5B7j36RPwxhQKfTD/3zGlMFjSwZkIwwT++fkbKVhKQt301TVRFxWs
         dofA==
X-Gm-Message-State: AOAM532X5F1UHHf3eApl9lgWABNQE2c5xkDDKHTQDKy5XsoX/l4N3CDA
        PZxlKMMJYStFX+Tc+HIs7nb5di++vU62c3wT
X-Google-Smtp-Source: ABdhPJziduJJCb33rYijPWqea5N3hwNVPXcxwmR/Vb0QKDWvQSH4A5Es9j9UZN0LYtyBjMN7dgkkZw==
X-Received: by 2002:a17:902:b94a:b029:10d:6f56:eeac with SMTP id h10-20020a170902b94ab029010d6f56eeacmr1897074pls.54.1626145029077;
        Mon, 12 Jul 2021 19:57:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23sm14489596pjq.2.2021.07.12.19.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 19:57:08 -0700 (PDT)
Message-ID: <60ed0104.1c69fb81.1524a.d191@mx.google.com>
Date:   Mon, 12 Jul 2021 19:57:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49-596-gbf7048dec18f0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 188 runs,
 7 regressions (v5.10.49-596-gbf7048dec18f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 188 runs, 7 regressions (v5.10.49-596-gbf704=
8dec18f0)

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

imx8mp-evk        | arm64  | lab-nxp       | gcc-8    | defconfig          =
          | 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.49-596-gbf7048dec18f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.49-596-gbf7048dec18f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf7048dec18f0c20052978985e32be1660daccf6 =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecc756eb7cf438b1117980

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecc756eb7cf438b1117=
981
        failing since 1 day (last pass: v5.10.48-6-gea5b7eca594d, first fai=
l: v5.10.49-580-g094fb99ca365) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecc8aa1b6aa134ba117975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecc8aa1b6aa134ba117=
976
        failing since 1 day (last pass: v5.10.48-6-gea5b7eca594d, first fai=
l: v5.10.49-580-g094fb99ca365) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
hip07-d05         | arm64  | lab-collabora | gcc-8    | defconfig          =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecefedc7b9f99ea2117976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecefedc7b9f99ea2117=
977
        failing since 11 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
imx8mp-evk        | arm64  | lab-nxp       | gcc-8    | defconfig          =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eccb95932eee492a117987

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eccb95932eee492a117=
988
        failing since 0 day (last pass: v5.10.49-592-ge2899f499d8c, first f=
ail: v5.10.49-593-g5e321de204df8) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:     https://kernelci.org/test/plan/id/60ecf0ffb25dc4e8d2117984

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
596-gbf7048dec18f0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ecf0ffb25dc4e8d211799c
        failing since 27 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-13T01:48:34.395245  /lava-4187351/1/../bin/lava-test-case<8>[  =
 13.559760] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-13T01:48:34.395568     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ecf0ffb25dc4e8d21179b4
        failing since 27 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-13T01:48:32.964037  /lava-4187351/1/../bin/lava-test-case
    2021-07-13T01:48:32.981763  <8>[   12.134279] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ecf0ffb25dc4e8d21179b5
        failing since 27 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-13T01:48:31.935561  /lava-4187351/1/../bin/lava-test-case
    2021-07-13T01:48:31.945700  <8>[   11.114666] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
