Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24291575183
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 17:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiGNPOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 11:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiGNPOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 11:14:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B19DE8E
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 08:14:42 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so8921090pjo.3
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 08:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fvbAWlhmkG0E/d3AMm2i9mYiDiKIYpE2c4qCxx+f+WI=;
        b=OGRgDpsDQX2GI1/5lNjV8Dpm07YAqTtqTg1HjRQpxpw2YrN22oOYX3JsOyfHEAIvpB
         COAXken2R5flnicVo1NBV3884aI4tSFU/ndxTU/gwqOkFS1OAbSwShmRfTE3hgaoi+US
         M69nuZg4Qv9fjd1X9AMsg1MEaXsiWPGQIqjvzwRBdOIIiBnUPh0+eYQ65cKCOXzEWvEm
         zhP+qNiXM6KtUIlXKGCJHQUHgN92SvjopKN0c/DG5PNHkSdhJxGo9ONfQ+NwAJ/GE8Qo
         qhj/0RdJOD3PH5s5FrEhH7JcB2cpoSwMY4utnJ5BoNWRg1p8aG4ukwEAttPJHps5Yk7N
         WOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fvbAWlhmkG0E/d3AMm2i9mYiDiKIYpE2c4qCxx+f+WI=;
        b=OzdWJc90jZhS57aKZ//x5WnE32+j6cbx4fWruca6B0hgVeFAoDY4seYapyNxwgz+9J
         x5zOaiLvaubOfcOKBkyBrPQOTkCr4j2fT6guFwwGpkyy0UyXx0d3+OeRRB//AUf2Q/eC
         pqMrecmdW84Yx+2cr++1tEzThLJLdK3Fe5HhFIjdEe6PHNXoQzqNaDJC1Q+GA/qC45P/
         PB9c1RQ5wB+JZpQ3wHhs8+ehCRSwIu8CSiFKinr+/sBLDlweLdOEz7j/3WU0GHOZpXb0
         3/sMUuNG+D3XgYuqIk8zOz+VvIXqSssD+8YVNochsNRb4YXj9zbuFp4NgjXwA4dgDE5H
         FMvw==
X-Gm-Message-State: AJIora8HdaT7SXW4UDRGSuyVmFLUCLSAN61irkW+AFhOYFW8Qk0mt1xt
        0jMo7WfP/C4eavNN0WF9BU3HhSP9ZAB8GeTnni8=
X-Google-Smtp-Source: AGRyM1tINKgGayWzZMD8GT2u4f51LWXSZ/EMHFDms1vSVzZM13EQ4CYzxAQbxcKCBj7GSvZx6v15dw==
X-Received: by 2002:a17:90b:3d81:b0:1ef:a950:a0cd with SMTP id pq1-20020a17090b3d8100b001efa950a0cdmr16822854pjb.43.1657811681443;
        Thu, 14 Jul 2022 08:14:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c66-20020a621c45000000b00528ce53a4a6sm1776240pfc.196.2022.07.14.08.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 08:14:40 -0700 (PDT)
Message-ID: <62d032e0.1c69fb81.8eec7.29dc@mx.google.com>
Date:   Thu, 14 Jul 2022 08:14:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.54-80-g1cc020ff12e44
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 121 runs,
 8 regressions (v5.15.54-80-g1cc020ff12e44)
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

stable-rc/queue/5.15 baseline: 121 runs, 8 regressions (v5.15.54-80-g1cc020=
ff12e44)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
beagle-xm              | arm    | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig          | 1          =

jetson-tk1             | arm    | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig           | 1          =

jetson-tk1             | arm    | lab-baylibre  | gcc-10   | tegra_defconfi=
g              | 1          =

mt8173-elm-hana        | arm64  | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook   | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.54-80-g1cc020ff12e44/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.54-80-g1cc020ff12e44
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cc020ff12e4400b3b23f32df3da8b0a8dd3ac9f =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
beagle-xm              | arm    | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cffeb70137c453c8a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cffeb70137c453c8a39=
bce
        failing since 105 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
jetson-tk1             | arm    | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62d000aa50b46b8ab6a39beb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d000aa50b46b8ab6a39=
bec
        failing since 33 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
jetson-tk1             | arm    | lab-baylibre  | gcc-10   | tegra_defconfi=
g              | 1          =


  Details:     https://kernelci.org/test/plan/id/62cffaacbbb9bfd4a7a39bf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cffaacbbb9bfd4a7a39=
bf2
        failing since 9 days (last pass: v5.15.51-43-gad3bd1f3e86e, first f=
ail: v5.15.51-60-g300ca5992dde) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
mt8173-elm-hana        | arm64  | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62d00266605d816aeca39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d00266605d816aeca39=
bd6
        new failure (last pass: v5.15.54-79-g7cd2ee02c205a) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cffa0466af1dd625a39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cffa0466af1dd625a39=
be8
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cffb35ea45c5d09fa39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cffb35ea45c5d09fa39=
bd5
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62d0028551674cecfaa39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d0028551674cecfaa39=
be6
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62d003daee38f0dde9a39c11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g1cc020ff12e44/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d003daee38f0dde9a39=
c12
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =20
