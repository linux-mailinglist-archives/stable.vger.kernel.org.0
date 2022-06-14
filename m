Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C4654A3F2
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 03:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbiFNB6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 21:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350819AbiFNB6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 21:58:36 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8E5271F
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 18:58:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y196so7319894pfb.6
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 18:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PhtzTDEmyFr8nVO8PUALfobAwKyqQaEfw4hwU6q0Qjg=;
        b=CQxp9w9yNARvryoTz01h97b5vUJZX8PIRG7JN1xPOdDtXI6xV3Ycx6MM9Fl+YdbRBc
         YN9JO3QfmBzTZUFU9H3oUT9vrnwS6RVVEy16mrh0av7+ohBG7MNcWD87oeGWszMRC8gv
         yeQzKOqI/D+0ScATCkJBOmGvX+EZb9VNOExXW13mzU1PzHBJQO1uQ5RXZ90csJLuiKc8
         +Fv6ctngkYXN7fulkVgVcRAL8SsZD92kvECyg2sT3GapyUtzHH1h3YAeXYZ20WoemEyG
         zI9KEnkkigveh4D30KUwlWQ1E6h2t1ii3SgTgoCTPDCYp9YKXTNjKcyHyCGkZw6/wQDV
         S2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PhtzTDEmyFr8nVO8PUALfobAwKyqQaEfw4hwU6q0Qjg=;
        b=Uj7caooi663Q11Nhb6DBQqHYPAxEmMBNN1cra6d8yz2OxVZC+dmulDO1VK6I2wXEa1
         3qaZauA0FcNlZkLz0z4VA1dtZChDgNQcc3m0Xcfyn2BKXmTtC1juSac7331p8/LhGjBJ
         aQGocYd3YLupZD46bw+LE2utQoqC5OklGqpY5DoylMO/gS+OkSwsfgrt6tfFd+epT0l2
         aVasaTRJiUuw7v78w3aXnpP4CMaG9TDu4ekVcysLaHV4lyHtG3Y45Qfw0FfWk9TJO7Pk
         RS34sc9bPaH///x3GxVSvQkDv5MlSL08QePIhNssB5wvCXAKgHC1IH78BNP73MVTAJXH
         DrjA==
X-Gm-Message-State: AOAM530vByus2f69L0wWFNN7WExa+AcgHQfpWpD7kqr3qqK9zucd0po+
        3GgMEbuLaK0/GQ4c9DXN2qNPuTAvFXOZeqsFiHA=
X-Google-Smtp-Source: ABdhPJyIR1tfd25h18/Mr7Z48kWGI2i3c5fpA6aZbSqT7ducIz3X8Yf9H1xUqOJnPqRCkDCtx3Q8Dg==
X-Received: by 2002:a05:6a02:19c:b0:3aa:1bf8:7388 with SMTP id bj28-20020a056a02019c00b003aa1bf87388mr2228046pgb.455.1655171914750;
        Mon, 13 Jun 2022 18:58:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i8-20020a17090a65c800b001e667f932cdsm8087649pjs.53.2022.06.13.18.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 18:58:34 -0700 (PDT)
Message-ID: <62a7eb4a.1c69fb81.f6cb8.9b44@mx.google.com>
Date:   Mon, 13 Jun 2022 18:58:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-920-g677f0128d0ed8
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 181 runs,
 7 regressions (v5.15.45-920-g677f0128d0ed8)
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

stable-rc/linux-5.15.y baseline: 181 runs, 7 regressions (v5.15.45-920-g677=
f0128d0ed8)

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

tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig         | 1          =

tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.45-920-g677f0128d0ed8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.45-920-g677f0128d0ed8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      677f0128d0ed8a3d320b74e8e35b214163070d47 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
beagle-xm               | arm   | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7b8a9043fb6bf9aa39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7b8a9043fb6bf9aa39=
bdd
        failing since 32 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7b449c3ec541600a39c5f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7b449c3ec541600a39=
c60
        failing since 21 days (last pass: v5.15.40, first fail: v5.15.41-13=
3-g03faf123d8c8) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7b4d69ca0597879a39bf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7b4d69ca0597879a39=
bf1
        failing since 21 days (last pass: v5.15.40, first fail: v5.15.41-13=
3-g03faf123d8c8) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7b337e3d00d71eda39bf4

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62a7b337e3d00d71eda39c16
        failing since 98 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-06-13T21:59:08.674437  /lava-6608901/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7b6def29ac9aee2a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-=
bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-=
bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7b6def29ac9aee2a39=
bce
        new failure (last pass: v5.15.45-668-g53f46ca17ebdf) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7caaedeebee6e05a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-t=
egra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-t=
egra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7caaedeebee6e05a39=
be3
        failing since 18 days (last pass: v5.15.41-133-g03faf123d8c8, first=
 fail: v5.15.42) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7cb73647eb85186a39bf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-920-g677f0128d0ed8/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7cb73647eb85186a39=
bf3
        failing since 18 days (last pass: v5.15.41-133-g03faf123d8c8, first=
 fail: v5.15.42) =

 =20
