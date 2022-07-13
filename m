Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254F4572AD0
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 03:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiGMB1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 21:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbiGMB1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 21:27:30 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7B8BEB52
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 18:27:29 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s206so9138412pgs.3
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 18:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mcHRxfHIXu0Srafi23u53rDhfby1GaJ+TTuBxjtGI00=;
        b=UyGF2co6nVePiTa8hZyNisgbmvhi5cFwCLu0HPhTVsbxM/2/eLVU6GAZeJfbdt1M6U
         It8KSiKqHaVIez9zkbr9TdLpBVrLEvR9fkN04ZWapBbt+27e98Y/vq4EweCAywiuaAXI
         JNQnn+j6M8zlHnwMQ0yIB/oTeNCN2yVlyG5Ki8nBD+bv8LMuCExyOIGLLEXStHfzvkxm
         9HZg+D7URL3WNJBUBtK7q4NpvINAsPB4aRTbI4e1Ey6ysKZaadLgzagr7uU//ob/47r2
         +DKRxAuX2TittDurSZBxtB2wRnajMx8DWAh3KK3a5PCcaR0ScWcRZYoxbjmgHiJgyrXG
         08YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mcHRxfHIXu0Srafi23u53rDhfby1GaJ+TTuBxjtGI00=;
        b=dbAhSH6OtI9AR3WoVlo3Y9N7hqsezN2y+ZJZOloHuVRQPxIY01yZiiHO+Sv/B9khMI
         3niB0hYBBtAU09C108JeRdQjWexa3oGCATX6SwlA6PCz565lY69JwGE6x+CGe41ajX0R
         qI9EQWLyxidavoBqqrl67uaF8fEXMs/Kfs8yS7HaVIayiG40HmX5Xn4l5NDzaL5m5SGw
         d9n4+39y3s9YJJZb0N2mmOa2ZoD410N46pMYnjI425cwt2Bb3lfb2Ir+iyfREa+BBILM
         D8yQ+H3qZ8UyOC4a3O89NQo8ZS6ppgj/ob94/Gy+OjECNJvi1I+7ETToGtfhd5bNoevT
         iQrw==
X-Gm-Message-State: AJIora9SJdZS1SIGd7UMSkmkN4R9Ghb2d9mwxM0B1agmCglOuhOUme7i
        8FDpL/xM7OWdh7Mwml8gTZLMnulYg/46Z/U/
X-Google-Smtp-Source: AGRyM1v/npnsBS50tQpWYVXYI9U+cOW4xCcosJw6Rvm3ULN+iEjMwRG9mrGQ8Kb7FAwZA4PtHCxkug==
X-Received: by 2002:a62:e817:0:b0:52a:b9fa:9a54 with SMTP id c23-20020a62e817000000b0052ab9fa9a54mr735031pfi.61.1657675648333;
        Tue, 12 Jul 2022 18:27:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902ab8600b0016b8b35d725sm7453550plr.95.2022.07.12.18.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 18:27:27 -0700 (PDT)
Message-ID: <62ce1f7f.1c69fb81.b301.b3e2@mx.google.com>
Date:   Tue, 12 Jul 2022 18:27:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.11-61-g8656c561960d
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 148 runs,
 7 regressions (v5.18.11-61-g8656c561960d)
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

stable-rc/queue/5.18 baseline: 148 runs, 7 regressions (v5.18.11-61-g8656c5=
61960d)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

jetson-tk1             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

jetson-tk1             | arm    | lab-baylibre    | gcc-10   | tegra_defcon=
fig              | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.11-61-g8656c561960d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.11-61-g8656c561960d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8656c561960d7e831fe6c11cc84e125a95bc5f02 =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce050ff1a4f1b2c3a39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce050ff1a4f1b2c3a39=
be9
        failing since 7 days (last pass: v5.18.9-96-g91cfa3d0b94d, first fa=
il: v5.18.9-102-ga6b8287ea0b9) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
jetson-tk1             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdfce101aa27f001a39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdfce101aa27f001a39=
bd2
        new failure (last pass: v5.18.10-112-ga454acbfee6a) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
jetson-tk1             | arm    | lab-baylibre    | gcc-10   | tegra_defcon=
fig              | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdfc547e43839d1ca39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdfc547e43839d1ca39=
be3
        new failure (last pass: v5.18.10-27-g3c635995cefa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cde867ebacf78d08a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cde867ebacf78d08a39=
bce
        new failure (last pass: v5.18.10-112-ga454acbfee6a) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdeb8d660c4db1c5a39bfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdeb8d660c4db1c5a39=
bfc
        new failure (last pass: v5.18.10-27-gbe5c4eef4e40) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdeae0db8a54fe53a39bd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdeae0db8a54fe53a39=
bd8
        new failure (last pass: v5.18.10-112-ga454acbfee6a) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdee403b9a6116d1a39bf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g8656c561960d/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdee403b9a6116d1a39=
bf5
        new failure (last pass: v5.18.10-27-gbe5c4eef4e40) =

 =20
