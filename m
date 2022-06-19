Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490985507E7
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 03:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiFSBro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 21:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiFSBrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 21:47:43 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB6B25F0
        for <stable@vger.kernel.org>; Sat, 18 Jun 2022 18:47:41 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u18so6892655plb.3
        for <stable@vger.kernel.org>; Sat, 18 Jun 2022 18:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dga3utEiplCvuVJKMRiyBOYMea2D/Un0NnspqWKyIgk=;
        b=mpLDy5P1MZ3RhQFXiOhp6o8WhlSrYlpR81nosLLLGtQd1uyBdn57vxF9m3r/Pld0vA
         6OlwPnDi4R9JLBF5PJPUK8SvSvk49zyLXdDwjPxQyc0zdkJuh4FOxZufXLDgy+14V1g0
         Af461iRhi8dzjGLQJHRCii0kJkVJcbeyMYLUes6HpSQfGF5jaqOutWpjzJSCspTQusKs
         HJrfg0Uf8QAfi8doECdf2Qb3Vi1GcjPuugSQdB7G+ZY3Qnid4JrlPrPtn3N0gSL1AY5F
         DdJWobdXBOOty6fR38VLQFuNIR1wY8CCBqXExQgHWA4S9+cmex26nrh4fObAGGYT2GXp
         CHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dga3utEiplCvuVJKMRiyBOYMea2D/Un0NnspqWKyIgk=;
        b=6PVplad9i0LABNCAQWwmA2DiOwKLoZazRovDXcBoe/Ev3MVdOFbBLJJH3LkGCI6mOn
         Ry6/fg8Myhr44phg89/YjeAzPoTmUj1VMRVm9lV5Bw8ZKCDGZQ90i6p2KZe2d+4mAntO
         nNWm7sNSVnDIbkRqA2y20xhH2e/v/NefuucBZKEkGU7lE1kbHCOep5kXUMnLSNI7ts/V
         r94raBScwlqfA7at969Yj2JJGS7xwwLWAxp14+W5ZISWBpVtY/AAK7GUxN2lcIi+Xfu+
         HKEac6Vrndh2RCcaHRJvg9ybsojypAiC+65EUNzLGds4HqV7HTo2or+iDjI4vez1BPPf
         tk+A==
X-Gm-Message-State: AJIora+Q+WkPJdVn12LHLMZCH7lcTKlUlXAZKuHaypS8CMGf72zqqvVz
        Ual1icGqGhZeMZOcjcgPWsD59HtY6sNViR04rYA=
X-Google-Smtp-Source: AGRyM1tl2xJ+9/rXawO/cawqidZJjBDLcTjzRw2KdozaOMT4LoUCIPvRiLaPtHuvc7ln+kd2dcVG+Q==
X-Received: by 2002:a17:90b:4b10:b0:1e8:3609:7fc7 with SMTP id lx16-20020a17090b4b1000b001e836097fc7mr29725983pjb.150.1655603260255;
        Sat, 18 Jun 2022 18:47:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11-20020a170903248b00b001618b70dcc9sm5954746plw.101.2022.06.18.18.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 18:47:39 -0700 (PDT)
Message-ID: <62ae803b.1c69fb81.765f.835c@mx.google.com>
Date:   Sat, 18 Jun 2022 18:47:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.123-34-g2f9d93aa50b2b
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 132 runs,
 3 regressions (v5.10.123-34-g2f9d93aa50b2b)
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

stable-rc/queue/5.10 baseline: 132 runs, 3 regressions (v5.10.123-34-g2f9d9=
3aa50b2b)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.123-34-g2f9d93aa50b2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.123-34-g2f9d93aa50b2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f9d93aa50b2b6bcbf3060a72318c48a9bd951a9 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ae4ca1a42ed7afbea39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-34-g2f9d93aa50b2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-34-g2f9d93aa50b2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae4ca1a42ed7afbea39=
bcf
        failing since 7 days (last pass: v5.10.120-452-g766cc4f88a25c, firs=
t fail: v5.10.120-541-g35309659a1f22) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ae4a83e44edd0baca39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-34-g2f9d93aa50b2b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-34-g2f9d93aa50b2b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae4a83e44edd0baca39=
bd3
        new failure (last pass: v5.10.123-4-gc586992bf6805) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ae491b1ee9bf5837a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-34-g2f9d93aa50b2b/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-34-g2f9d93aa50b2b/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae491b1ee9bf5837a39=
bce
        failing since 22 days (last pass: v5.10.117-97-g901121443947, first=
 fail: v5.10.118-10-gb5ec0c22a820f) =

 =20
