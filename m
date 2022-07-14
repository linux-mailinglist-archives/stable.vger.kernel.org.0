Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFF0574C63
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 13:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbiGNLno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 07:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiGNLnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 07:43:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872B1F51
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 04:43:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id fz10so2644579pjb.2
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 04:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x0PvDEUz0EwpXpiQjSkPq7Nh76MoRamYP1TE664uuZU=;
        b=IK0HNEtpqvUIL1H88uE5PFAHY3WsFlC7U5e2DDvRVQJ9uRGpP+oFsCqer8amg3Mavz
         w+kZU/8SM6puYF18dt6oQl9/tckTMFhAGidss0y/nIZZ5dlx7COjm8BSSQMMqR9iX+nw
         oxofb43OD0tePJfVn/A1sPRuZyC2mp/k31++BqH8c+D0LDwd4oN4Ptyk8jcDzopYwgOL
         gmd34+udd2VcCVNhhx9CDThsS9HK826IHlot0azhNxEF7yRHpQ/W1lG6pqnuUEJIZgp7
         uy+Wdqiolyf6tHDFFRYxOHEarjZyOu6B/R3JzR2uzeuRuudgnGDRb4mZdneMFcUGWJq6
         L4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x0PvDEUz0EwpXpiQjSkPq7Nh76MoRamYP1TE664uuZU=;
        b=SnIMQCZczsDRlVpavx+oMAkQxQrEVnQZCNB6dMrEG9L+jznys6SAro/SLUUorjfGpq
         L22n3UDXSH1FPtkD6cjNtqN1ZhqEy/NWU1ibgwNPSJhDnj8JtAa28Ftf17Pyo6YzCnCv
         DfEHUlXGNicFRY6HOXzGuS13Dfa4FRvNjhF1Xi4+jBtBHiVqUBYiUALilK96V7tW3DDY
         T0512K+1NsHtPMEWVSnJlS3a8sD78nWBnq8wMa8ArHLrQKF3JNR2Ah11/1+bx3QR+Oql
         MZ4K+7Ru5fGCFeu32NCpFAidio1Ji7/7G4OjCqHQetvwSc99IGZzvGEQNZJihvXbrTFD
         w7iw==
X-Gm-Message-State: AJIora+jckQa5viHGwLEuy7cJVHLTrhV9B38hXqGLNFsX5/PjqLQ5Z2c
        e+hvtEcVHIdJUzRypErEkknGnafKwyEzt1BxEu4=
X-Google-Smtp-Source: AGRyM1sMw6AjjzbK99yTRpnnmCmnk4xJLGoCrUOCKdIXZn3gClRYGZtUeNLi7Yln9gAKdud4EmXzWw==
X-Received: by 2002:a17:90b:8d:b0:1ef:74c8:1541 with SMTP id bb13-20020a17090b008d00b001ef74c81541mr9495030pjb.103.1657799018851;
        Thu, 14 Jul 2022 04:43:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10-20020a170903124a00b0016bf01394e1sm1288498plh.124.2022.07.14.04.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 04:43:38 -0700 (PDT)
Message-ID: <62d0016a.1c69fb81.409aa.1c80@mx.google.com>
Date:   Thu, 14 Jul 2022 04:43:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.54-78-g5737a6dd019b
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 161 runs,
 8 regressions (v5.15.54-78-g5737a6dd019b)
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

stable-rc/queue/5.15 baseline: 161 runs, 8 regressions (v5.15.54-78-g5737a6=
dd019b)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
beagle-xm              | arm    | lab-baylibre | gcc-10   | omap2plus_defco=
nfig          | 1          =

jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =

jetson-tk1             | arm    | lab-baylibre | gcc-10   | tegra_defconfig=
              | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

r8a77950-salvator-x    | arm64  | lab-baylibre | gcc-10   | defconfig      =
              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.54-78-g5737a6dd019b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.54-78-g5737a6dd019b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5737a6dd019b9586e1c462a2d6086a893c766a58 =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
beagle-xm              | arm    | lab-baylibre | gcc-10   | omap2plus_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfd039b34c284adba39c42

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfd039b34c284adba39=
c43
        failing since 105 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfce19ace8665526a39bf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfce19ace8665526a39=
bf7
        failing since 33 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | tegra_defconfig=
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfcfe7ff2e5e9e2aa39bf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfcfe7ff2e5e9e2aa39=
bf9
        failing since 9 days (last pass: v5.15.51-43-gad3bd1f3e86e, first f=
ail: v5.15.51-60-g300ca5992dde) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfcbdc351cc98ecfa39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfcbdc351cc98ecfa39=
be1
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfcc2ddf0adc9af1a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfcc2ddf0adc9af1a39=
bdb
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfcc58f8be75952ba39c3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfcc58f8be75952ba39=
c3d
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfccfa737564fd9da39bfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfccfa737564fd9da39=
bfc
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
r8a77950-salvator-x    | arm64  | lab-baylibre | gcc-10   | defconfig      =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfd24a79c6228a47a39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g5737a6dd019b/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfd24a79c6228a47a39=
be1
        new failure (last pass: v5.15.54-78-ga5f899726e59) =

 =20
