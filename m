Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE03531FE3
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 02:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiEXAe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 20:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiEXAe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 20:34:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A2C9BAFA
        for <stable@vger.kernel.org>; Mon, 23 May 2022 17:34:27 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gg20so15423611pjb.1
        for <stable@vger.kernel.org>; Mon, 23 May 2022 17:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5HpskVCmvkZTevxUocJYAhGIZwTwap6u4ZnUDFvaY38=;
        b=QjpJZExK+0fT+YX7fWjMUyYmIK00ZiqmbmenauNUNAXPyM3NegWdwWFg+HZp7jLg1B
         KlMeMZQA6wDLNe4xnsbRerxm08xKRlXa+YOEIbKMFZIYzyDdQbdjQCoQuCjxaceVV36d
         rcBbzbSzz/8Sa8EPNn/nVOKBTJQeWY49CaS5Lb127TtxEfHbNsxY7QIgLfqODWDMCR5a
         Umjb92tHJ8vkxb1EjHJKBTSZvxUF8c/9xwjl8p/4ryzQ/dT9Yc6p1xkIkT60hsfyLHKN
         B3pbU+hsq9p+HE9fF9Nu7guOcgVTkZcvQjRMFSlnyy5LH8GyQjC9JJdIEY3PlEiw5EEg
         4FCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5HpskVCmvkZTevxUocJYAhGIZwTwap6u4ZnUDFvaY38=;
        b=DoSIayu00nWabtubBVPqYw0PlYPLVTnQ4v4T+POIPfYyxmtL9DVTLsXH8uVXQZVtG6
         FfSrX6glaYoNhIyCasXG21p2BB/punjoFMVk8uvURX74tv/illr0KP1YcYG5iG2ssryT
         /6EpKrF+iZAuwhqq7gm4b54LAMCbELChdQMLSe7lzwdltZpVIGWhTIF9knhb9/Lv5/RT
         kOpQndZhUvTGfKtkMl8icstl+pHP4DBC2B1wHD14biE0Kxr4ei12IehN+2JC5xt/LBdb
         9nic8TU6IFSdxn52EZYnfSyQzGg+aatzvhIRGht7rqlMuMekxO8uj0UgFqWIYQ1XlgtH
         I/Kw==
X-Gm-Message-State: AOAM533U4UFZcMA39wKKBMhwKJfch4u2cdSVfSU7+lWrVbNCQqO1VaK9
        HJZMu01T6e+na0u/afR+5u9o7J8sl9el5O4hisA=
X-Google-Smtp-Source: ABdhPJwSgyV1tQqz4mC1gzBxRiOsKWWQHxYyLQdgI8IjO9AaUZLmX0Wmpxq4qyXcDykvpHAxMWKI0Q==
X-Received: by 2002:a17:90b:4f47:b0:1e0:5156:c7ee with SMTP id pj7-20020a17090b4f4700b001e05156c7eemr1667022pjb.87.1653352466998;
        Mon, 23 May 2022 17:34:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902ec8200b0015e8d4eb234sm5674656plg.126.2022.05.23.17.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 17:34:26 -0700 (PDT)
Message-ID: <628c2812.1c69fb81.8847e.d418@mx.google.com>
Date:   Mon, 23 May 2022 17:34:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.41-132-gede7034a09d1
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 155 runs,
 5 regressions (v5.15.41-132-gede7034a09d1)
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

stable-rc/queue/5.15 baseline: 155 runs, 5 regressions (v5.15.41-132-gede70=
34a09d1)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
beagle-xm               | arm   | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig        | 1          =

jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =

jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =

rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.41-132-gede7034a09d1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.41-132-gede7034a09d1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ede7034a09d10f4fcbce7c8ba42837cafe5f70b7 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
beagle-xm               | arm   | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/628bf2a3c544a9eaa3a39bfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628bf2a3c544a9eaa3a39=
bfd
        failing since 54 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/628bf5ccb3caea3169a39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628bf5ccb3caea3169a39=
bd2
        new failure (last pass: v5.15.40-98-g6e388a6f5046) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/628bf7c09ffc382d3aa39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628bf7c09ffc382d3aa39=
bcf
        new failure (last pass: v5.15.40-98-g6e388a6f5046) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628bf0dfbc75a836d7a39be9

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/628bf0dfbc75a836d7a39c0b
        failing since 77 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-23T20:38:38.573870  /lava-6450274/1/../bin/lava-test-case
    2022-05-23T20:38:38.584948  <8>[   33.822918] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/628bf79ad6a784b2aaa39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
132-gede7034a09d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628bf79ad6a784b2aaa39=
bda
        new failure (last pass: v5.15.41-44-g056e35d45b1e9) =

 =20
