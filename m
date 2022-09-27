Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C475ECADE
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 19:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiI0Rbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 13:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbiI0Rbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 13:31:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAE8CF495
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 10:31:41 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g1-20020a17090a708100b00203c1c66ae3so10725505pjk.2
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 10:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=iXf3qD5wCSR7/aoQcYrDmWKBIhSjRM3LQLKGbzkgUBA=;
        b=f0+oU/K/eqEYqzgdxKqAOxPyb7FsDjuKvkU1eRrCdBI/CepHnBUG9Z/JKKQMcwIz0Z
         G5uXDnJEDXCkfTnWzai/JBNCl6W8YJ38dBU/RHz46Qsk+YpziheUtriaBi6Z26YU62mD
         znlhkHnmPWWx5J40leEMtVRAdZvZeP/kDj2Swx3xZe7toJ/m5wIIPNyXBTsyo/qM4XZ8
         RTfmWqUEyxIKZSTgLKMDILoFeYHPUNeFPVZjWC1OsTrSocCuic0fx41T83aLvoKsC1t4
         B+WjnAbnW/xr0WuUlDm1Cq2diFfHXWXQkt/bVmdm1s24GeQzaBC9gJEw7cXCQ6f8hDVm
         0ozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=iXf3qD5wCSR7/aoQcYrDmWKBIhSjRM3LQLKGbzkgUBA=;
        b=fkwJoGx55R7z5Dhhi9TYAFwrXLEpePxbSD3Hi1echqd2/h79p03uzqIHU0iYgmtg/Z
         sUbCzn6qkCOeyDA8nIW9bAct0AGcJ/jAvfETNjAQFJGHNbu/LmhrcpjXcTEFKOs7saKG
         sLrCfGJ9oFWwcopFIksQt4NZa8QfCYt5Jimosx3EPtnw9CeZbth5jPZ/UXaqecIKjhea
         3cf8gUDRpvPUq2qb4RLslK9uKIcS/wFb/51LHE6meq7EHLK2ctYgzFpyMK+VZqOQo32T
         SarOz/cZuKHmlmU/DB9NDVYoXlZXRYcYTZltac0hLnyYK9/tQLHJ3mvihZmF5vPXhtMM
         XIJA==
X-Gm-Message-State: ACrzQf1PLBnhxWKG25qeFkOiKpsupnuPyyILOs4oigtjrg/t1aOjEeSd
        Ze90ayD4rZQQ14ywC2L4K+9iT1mAAXV6CQ4N
X-Google-Smtp-Source: AMsMyM5MAh85HjH4vecsdTLFP8hhVMLdAzhwrhQtW6X3v6exGgGY6Wq/QNI4y6lG0czI6+iDw3PM3A==
X-Received: by 2002:a17:902:d506:b0:178:3599:5e12 with SMTP id b6-20020a170902d50600b0017835995e12mr28026344plg.70.1664299900627;
        Tue, 27 Sep 2022 10:31:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 189-20020a6204c6000000b005380c555ba1sm2103911pfe.13.2022.09.27.10.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 10:31:40 -0700 (PDT)
Message-ID: <6333337c.620a0220.19ea9.39df@mx.google.com>
Date:   Tue, 27 Sep 2022 10:31:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-143-g3650cef9cafca
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 95 runs,
 5 regressions (v5.15.70-143-g3650cef9cafca)
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

stable-rc/queue/5.15 baseline: 95 runs, 5 regressions (v5.15.70-143-g3650ce=
f9cafca)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
beagle-xm            | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g | 1          =

imx7ulp-evk          | arm  | lab-nxp       | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

imx7ulp-evk          | arm  | lab-nxp       | gcc-10   | multi_v7_defconfig=
  | 1          =

panda                | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g | 1          =

qemu_arm-vexpress-a9 | arm  | lab-collabora | gcc-10   | vexpress_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.70-143-g3650cef9cafca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-143-g3650cef9cafca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3650cef9cafca8ecd6dc9b60ee89773f28657257 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
beagle-xm            | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/633300d3e4bd797118ec4eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633300d3e4bd797118ec4=
ecb
        failing since 5 days (last pass: v5.15.69-17-g7d846e6eef7f, first f=
ail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
imx7ulp-evk          | arm  | lab-nxp       | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6332fe34ffec51eadfec4eb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332fe34ffec51eadfec4=
eb5
        failing since 1 day (last pass: v5.15.70-117-g5ae36aa8ead6e, first =
fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
imx7ulp-evk          | arm  | lab-nxp       | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6333044be4379d6958ec4eb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6333044be4379d6958ec4=
eb8
        failing since 1 day (last pass: v5.15.69-44-g09c929d3da79, first fa=
il: v5.15.70-123-gaf951c1b9b36) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/63330f153ed9f48127ec4eab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63330f153ed9f48127ec4=
eac
        failing since 35 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-vexpress-a9 | arm  | lab-collabora | gcc-10   | vexpress_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6332fbf8461de8f268ec4ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/vexpress_defconfig/gcc-10/lab-collabora/baseline-qem=
u_arm-vexpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g3650cef9cafca/arm/vexpress_defconfig/gcc-10/lab-collabora/baseline-qem=
u_arm-vexpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332fbf8461de8f268ec4=
ecf
        new failure (last pass: v5.15.70-142-gf38e88261ee1) =

 =20
