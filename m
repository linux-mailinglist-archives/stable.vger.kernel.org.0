Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563185A4E8B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiH2Nul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiH2Nuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:50:40 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E05A77EB3
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:50:36 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id bh13so7745691pgb.4
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=S4tUuBcj0zB1ecVQbpwk1TVgXbZLzyd/WNNcdhZiqhk=;
        b=SSJW6Q8EieQTNR+63qwlkXV1PqyVlo2zfNRdMOe4hIUVENXKLu6yiMa/5jetOaIXX4
         wVxkP9VIAMpxlvuKtLA7BoYED1aK+GngCY1+cOF8pYF6SHGOKT0HQygkeIoAqtF9ZFt+
         Mm8SkgXAy+927XZO3j+Graij6nRRg+GODep3dTmnxeSFhLF4Jgdangr6cF0qRd4zG5gK
         FBMz48bwW37Tg83YkwWZF0gfxaQCoaqRc1UvHxfx2i8tgBxAfnki9lNPhyYvntzSqA0a
         GV6CxdDD8U9lNW6PEbJb0/nbcK78V1jw2SWxde2k0s5gjmDWp3yupPuyKLs1DMxEJctf
         5YaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=S4tUuBcj0zB1ecVQbpwk1TVgXbZLzyd/WNNcdhZiqhk=;
        b=vdU3PsFbEnh1C5hUu7DIhz0Cw7jhHKZqlGRvhRuLGrvKRXTvdbKMCNw36wWVZU6sRO
         S0YEaRo98awNlYsrBAt3y95G8h23n7st1sOuJUoIQo18WbSyXqTMOVMNTdP9CDvZ5OLS
         C90qnhj+puigQCT+ocCzqsDiOKQ/f7mTdn0S8L2q8V0wDcTdbn+nWNYXjOxLoid49IqR
         8h3YPvdU69vZgj0W4q15EMIwOknhzbS5tBQhV2U6kCzTN7SsWUHjPEw8O6iiipovT7bT
         GCHb1t1DhQXALZmKjm+xNsmJVt8MN/zALalSG6W6R+0Hu47BiJfxpcwpT0ZVA/8PbF47
         1UyA==
X-Gm-Message-State: ACgBeo2ton4SI2awUEdUNjPvZIzHCh/1U/mZN2M40xzatBDvT7EM/JbE
        rb0Hlz1mIDpZ520tHdLJPTx1b7GpIYJrkX2xPus=
X-Google-Smtp-Source: AA6agR7InoeGdTeifzQ0VWQNzQbb3D0TzylNuF87tM0iTSKHNHQKEQl2FrVyYwkeJ8POHEXpl0i0ZQ==
X-Received: by 2002:a05:6a00:b55:b0:538:579c:d5ae with SMTP id p21-20020a056a000b5500b00538579cd5aemr2493539pfo.22.1661781036245;
        Mon, 29 Aug 2022 06:50:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9-20020a634949000000b0041d322b3bf6sm6465698pgk.77.2022.08.29.06.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:50:35 -0700 (PDT)
Message-ID: <630cc42b.630a0220.28d2b.a286@mx.google.com>
Date:   Mon, 29 Aug 2022 06:50:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.63-136-g30057c8a3a38
Subject: stable-rc/linux-5.15.y baseline: 187 runs,
 4 regressions (v5.15.63-136-g30057c8a3a38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 187 runs, 4 regressions (v5.15.63-136-g300=
57c8a3a38)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

panda            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.63-136-g30057c8a3a38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.63-136-g30057c8a3a38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30057c8a3a385f835170ec6275e501ceaf7e4ebe =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/630c91f02f307543cd355672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-136-g30057c8a3a38/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-136-g30057c8a3a38/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c91f02f307543cd355=
673
        failing since 108 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/630c97320424a4aed735564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-136-g30057c8a3a38/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-136-g30057c8a3a38/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c97320424a4aed7355=
64c
        failing since 13 days (last pass: v5.15.59, first fail: v5.15.60-78=
0-ge0aee0aca52e6) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/630c953dbdfe15b5c9355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-136-g30057c8a3a38/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-136-g30057c8a3a38/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c953dbdfe15b5c9355=
659
        failing since 5 days (last pass: v5.15.60-779-g8c2db2eab58f3, first=
 fail: v5.15.62-245-g1450c8b12181) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/630c92008fd30b6fdb355664

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-136-g30057c8a3a38/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-136-g30057c8a3a38/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/630c92008fd30b6fdb35568a
        failing since 174 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-08-29T10:16:05.556817  <8>[   32.449350] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-08-29T10:16:06.581408  /lava-7124385/1/../bin/lava-test-case
    2022-08-29T10:16:06.591954  <8>[   33.484630] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
