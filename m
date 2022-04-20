Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9747650889D
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378673AbiDTNAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 09:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbiDTNAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 09:00:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CFE3E5CE
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:57:57 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id d23-20020a17090a115700b001d2bde6c234so3461050pje.1
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vtyy9codORAieiLu/VxB+oUj1LW9HQvn1ZVYhOZLXYQ=;
        b=VM6sWLLxwXVyeqtCwZExPitx4Yzw573Zvuojc/r/chvyTEUfiXr9Vjd8RoU/A0VFDU
         Unhb0R9X04rnYAJzY+YQYbJOT61o/H98KArl7kq0pDuKpNqUl1HPyAYvyyHquHUZomjL
         fUAPIH7A0XZCBpwJUFuuHaGVfjxZ9j3rLwJG2EKlHlAktBYVCosqM+02fPZ4llbGgTSg
         OPAcS+DR+XvPJ91H13IAPYmapAjd7ZE/N5qQdLv3MsRboZAWGL15MP2wRVoAObVW7iDJ
         RkNnk7oK9xVNWPCFWHkdWGxiR+yFPMcgfI2hMNRTapmS5az2k4QCjqKFeAwYF+JsUpax
         hcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vtyy9codORAieiLu/VxB+oUj1LW9HQvn1ZVYhOZLXYQ=;
        b=LKandE2VmbRHceTuxnvJRfvGH7wK+7BpV6dRoUnBbWRhdHpfhYltVbCK7j2yrQfjq9
         5YfT12/4PcTcqnXxLzrLGf+33cZwin9S+eFNDXCInevJn3grph9B/8/ab/PlfBVyqkBk
         DfpLC+cS34sgwCHNrbcI49QxdpdO3ns5o79jTNuk8vXp4ShSNDciHtAu3urdkOZVOFxM
         y9knIux0mi8sc+zdCw0IEjAYrVBpNPz5+bQ9sgh2En1Nf04zVS9G173/e3/bjjCCZE7F
         geKdQAx9Xm+3Fm7qLH5/8SEgBkCsbxldqu73KF4m8M6Yt7bDv60aHK9SfYX7N4UOgheG
         fPig==
X-Gm-Message-State: AOAM532XI36GHocjqnXCqGdqG8GQduQIxlkmMdy+LWIZ7V93repvDF0D
        MK4KYVo621ZQX63gE1MM+qI+/iyYlIANJN+Q
X-Google-Smtp-Source: ABdhPJzszT/J+UuNii+q88p2RdlPOzWHpXm2dJnPrRmTVc/XS2jggBozQZbuJ7ihX2lkVxzINKNmTA==
X-Received: by 2002:a17:903:1206:b0:151:7d67:2924 with SMTP id l6-20020a170903120600b001517d672924mr20370796plh.45.1650459476919;
        Wed, 20 Apr 2022 05:57:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t20-20020a63eb14000000b0039e28245722sm19631375pgh.54.2022.04.20.05.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 05:57:56 -0700 (PDT)
Message-ID: <62600354.1c69fb81.7eb1d.ec0d@mx.google.com>
Date:   Wed, 20 Apr 2022 05:57:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.239
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 110 runs, 3 regressions (v4.19.239)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 110 runs, 3 regressions (v4.19.239)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.239/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.239
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      eadf658bb74981dd2509d9e1863574b9f0f90fff =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625fd1746ecd2c5befae0687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.239/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.239/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fd1746ecd2c5befae0=
688
        failing since 13 days (last pass: v4.19.235, first fail: v4.19.236) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625fd173b16ab6baabae06f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.239/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.239/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fd173b16ab6baabae0=
6f8
        failing since 4 days (last pass: v4.19.234, first fail: v4.19.238) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625fd36d4c79c88f51ae06a4

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.239/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.239/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625fd36e4c79c88f51ae06c6
        failing since 34 days (last pass: v4.19.231, first fail: v4.19.235)

    2022-04-20T09:33:22.169293  /lava-6129852/1/../bin/lava-test-case
    2022-04-20T09:33:22.177872  <8>[   36.869864] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
