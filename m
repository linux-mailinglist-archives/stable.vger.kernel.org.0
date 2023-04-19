Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C3A6E80F8
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 20:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjDSSLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 14:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjDSSLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 14:11:01 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4765FCF
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 11:10:58 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b51fd2972so139005b3a.3
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 11:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681927858; x=1684519858;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cpzWhcvBEXtJah2FQEie9b5GzlZVXWN+J+/PraGXSrM=;
        b=BJUmfVUl2vGAO0AaiYxv9+bIvny5tFDzu7tM4kNU6fSeeWy6lHUFgEWstfI7PJzxyA
         rYTQ8dLi/Lb0RTLcCRi9MrIrt2IYZoycW7KrmooIC4Igi/5l+Osi74DH8txo+XbCP8Sg
         YtQZjIF2DsjkQhFkjss9rcgPszCI+2E0vkf+itwRpi7vWBVax5cRpz+NShz9qbNy17ZA
         epKPAbJJSUiou2SROg6waukU33JpKSr0/iUducDE4FemmzREgdCYt9CBRzh6R7W5R8xT
         Pe/Njsx/6fC40Kjn/t0tNxkXLCOePoQhfHhtIhc+MHvB2HOc70rz7+cYCvLR4dJt6UMv
         I6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681927858; x=1684519858;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cpzWhcvBEXtJah2FQEie9b5GzlZVXWN+J+/PraGXSrM=;
        b=O6nK1Wgkx0Zp4DAnDfVp5TF1feHFAtHTRqC+OGGiOIWMNVGBnGBOFtj72n4qNaC1+4
         0IU6hjvjzm5q5pRVq9uNG99Tbzl/YOrWk02oMLfhJ8wBi9WHBXB6UAaT6k60x9TbtWgD
         ix4ROYIPRpRfKt7guZmBO7D15bTuqe5995bKYo2hi2ZXCGGApLVKcP0EPwD0CdOuQn8l
         o6vxI52JR4MjZb5j7+Kca3LCbHfsQRTB7bADs47gk5SlTAZZun/8e/KY6/+nA4zL3Vty
         mVDZKIDoU5nwyPbHSd3aSb2d/bJh3/kPa1yhh+wjaYWoGnoEgmiKnIS3fru2xTKDvVQo
         fvng==
X-Gm-Message-State: AAQBX9fr/uQ8QzpxyvqyX+Zf9qNv/XC4LdC0FUnY+U+qTwFdQdkZCAMA
        pfHTQggTW68mp4iIdxCqsRvlhctyxbhkiBoK44NNHmr7
X-Google-Smtp-Source: AKy350YdE+uHx5DxmJ4Eaaap0gpMGXJpkNP3ttD8jXQJmnPT3a2zELZynPMnQFGu+jhNXH5HAIgw2g==
X-Received: by 2002:a05:6a00:2316:b0:63d:4756:6e9a with SMTP id h22-20020a056a00231600b0063d47566e9amr4894054pfh.27.1681927857957;
        Wed, 19 Apr 2023 11:10:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15-20020a62e30f000000b0063b86aff031sm6851564pfh.108.2023.04.19.11.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 11:10:57 -0700 (PDT)
Message-ID: <64402eb1.620a0220.5d184.fce2@mx.google.com>
Date:   Wed, 19 Apr 2023 11:10:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-475-g45df5d9a8cbd
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 180 runs,
 10 regressions (v6.1.22-475-g45df5d9a8cbd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 180 runs, 10 regressions (v6.1.22-475-g45df=
5d9a8cbd)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

meson-gxbb-nanopi-k2         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22-475-g45df5d9a8cbd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22-475-g45df5d9a8cbd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45df5d9a8cbd69338c2516c670817aef975185c8 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff97334f288e29d2e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff97334f288e29d2e85ec
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T14:23:33.464052  <8>[   10.477258] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10047277_1.4.2.3.1>

    2023-04-19T14:23:33.467431  + set +x

    2023-04-19T14:23:33.568882  #

    2023-04-19T14:23:33.569129  =


    2023-04-19T14:23:33.670064  / # #export SHELL=3D/bin/sh

    2023-04-19T14:23:33.670253  =


    2023-04-19T14:23:33.771163  / # export SHELL=3D/bin/sh. /lava-10047277/=
environment

    2023-04-19T14:23:33.771352  =


    2023-04-19T14:23:33.872246  / # . /lava-10047277/environment/lava-10047=
277/bin/lava-test-runner /lava-10047277/1

    2023-04-19T14:23:33.872518  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff97992cc87857c2e8605

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff97992cc87857c2e860a
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T14:23:45.394443  + <8>[   11.625317] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10047301_1.4.2.3.1>

    2023-04-19T14:23:45.394880  set +x

    2023-04-19T14:23:45.502862  / # #

    2023-04-19T14:23:45.605303  export SHELL=3D/bin/sh

    2023-04-19T14:23:45.606037  #

    2023-04-19T14:23:45.707805  / # export SHELL=3D/bin/sh. /lava-10047301/=
environment

    2023-04-19T14:23:45.708491  =


    2023-04-19T14:23:45.810447  / # . /lava-10047301/environment/lava-10047=
301/bin/lava-test-runner /lava-10047301/1

    2023-04-19T14:23:45.811698  =


    2023-04-19T14:23:45.816265  / # /lava-10047301/bin/lava-test-runner /la=
va-10047301/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff976378928f5d12e85ef

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff976378928f5d12e85f4
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T14:23:30.630255  <8>[   10.439698] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10047263_1.4.2.3.1>

    2023-04-19T14:23:30.633847  + set +x

    2023-04-19T14:23:30.735608  #

    2023-04-19T14:23:30.735966  =


    2023-04-19T14:23:30.837009  / # #export SHELL=3D/bin/sh

    2023-04-19T14:23:30.837244  =


    2023-04-19T14:23:30.938202  / # export SHELL=3D/bin/sh. /lava-10047263/=
environment

    2023-04-19T14:23:30.938455  =


    2023-04-19T14:23:31.039468  / # . /lava-10047263/environment/lava-10047=
263/bin/lava-test-runner /lava-10047263/1

    2023-04-19T14:23:31.039860  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643ffc1998ab3bc9602e86e3

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ffc1998ab3bc9602e8715
        failing since 0 day (last pass: v6.1.22-178-gf8a7fa4a96bb, first fa=
il: v6.1.22-480-g90c08f549ee7)

    2023-04-19T14:34:46.776643  + set +x
    2023-04-19T14:34:46.780251  <8>[   17.412958] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 354471_1.5.2.4.1>
    2023-04-19T14:34:46.898656  / # #
    2023-04-19T14:34:47.001487  export SHELL=3D/bin/sh
    2023-04-19T14:34:47.002138  #
    2023-04-19T14:34:47.104228  / # export SHELL=3D/bin/sh. /lava-354471/en=
vironment
    2023-04-19T14:34:47.104990  =

    2023-04-19T14:34:47.206946  / # . /lava-354471/environment/lava-354471/=
bin/lava-test-runner /lava-354471/1
    2023-04-19T14:34:47.208231  =

    2023-04-19T14:34:47.214913  / # /lava-354471/bin/lava-test-runner /lava=
-354471/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff98a4e3f68309e2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff98a4e3f68309e2e85eb
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T14:23:53.736479  + set +x

    2023-04-19T14:23:53.743298  <8>[   10.728747] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10047246_1.4.2.3.1>

    2023-04-19T14:23:53.848286  / # #

    2023-04-19T14:23:53.949346  export SHELL=3D/bin/sh

    2023-04-19T14:23:53.949637  #

    2023-04-19T14:23:54.050713  / # export SHELL=3D/bin/sh. /lava-10047246/=
environment

    2023-04-19T14:23:54.050904  =


    2023-04-19T14:23:54.151962  / # . /lava-10047246/environment/lava-10047=
246/bin/lava-test-runner /lava-10047246/1

    2023-04-19T14:23:54.153182  =


    2023-04-19T14:23:54.157946  / # /lava-10047246/bin/lava-test-runner /la=
va-10047246/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff978242a3f08ce2e8609

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff978242a3f08ce2e860e
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T14:23:27.884756  + set<8>[   10.595533] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10047281_1.4.2.3.1>

    2023-04-19T14:23:27.884836   +x

    2023-04-19T14:23:27.986787  #

    2023-04-19T14:23:28.087718  / # #export SHELL=3D/bin/sh

    2023-04-19T14:23:28.087875  =


    2023-04-19T14:23:28.188752  / # export SHELL=3D/bin/sh. /lava-10047281/=
environment

    2023-04-19T14:23:28.188946  =


    2023-04-19T14:23:28.289879  / # . /lava-10047281/environment/lava-10047=
281/bin/lava-test-runner /lava-10047281/1

    2023-04-19T14:23:28.290106  =


    2023-04-19T14:23:28.294756  / # /lava-10047281/bin/lava-test-runner /la=
va-10047281/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff978378928f5d12e8609

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff978378928f5d12e860e
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T14:23:27.129279  + set<8>[    8.596007] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10047273_1.4.2.3.1>

    2023-04-19T14:23:27.129762   +x

    2023-04-19T14:23:27.237887  / # #

    2023-04-19T14:23:27.339275  export SHELL=3D/bin/sh

    2023-04-19T14:23:27.340260  #

    2023-04-19T14:23:27.442173  / # export SHELL=3D/bin/sh. /lava-10047273/=
environment

    2023-04-19T14:23:27.443023  =


    2023-04-19T14:23:27.544984  / # . /lava-10047273/environment/lava-10047=
273/bin/lava-test-runner /lava-10047273/1

    2023-04-19T14:23:27.546202  =


    2023-04-19T14:23:27.551851  / # /lava-10047273/bin/lava-test-runner /la=
va-10047273/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff962e811f644932e86c9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff962e811f644932e86ce
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T14:23:17.402575  <8>[   11.727777] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10047250_1.4.2.3.1>

    2023-04-19T14:23:17.507187  / # #

    2023-04-19T14:23:17.608106  export SHELL=3D/bin/sh

    2023-04-19T14:23:17.608303  #

    2023-04-19T14:23:17.709244  / # export SHELL=3D/bin/sh. /lava-10047250/=
environment

    2023-04-19T14:23:17.709448  =


    2023-04-19T14:23:17.810499  / # . /lava-10047250/environment/lava-10047=
250/bin/lava-test-runner /lava-10047250/1

    2023-04-19T14:23:17.810806  =


    2023-04-19T14:23:17.814948  / # /lava-10047250/bin/lava-test-runner /la=
va-10047250/1

    2023-04-19T14:23:17.821943  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
meson-gxbb-nanopi-k2         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643ffd1b0aa09113812e85f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-n=
anopi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-n=
anopi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ffd1b0aa09113812e8=
5f7
        new failure (last pass: v6.1.22-478-g612789500e617) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643ffa1c751a1d36e02e85f5

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
475-g45df5d9a8cbd/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/643ffa1c751a1d3=
6e02e85fd
        failing since 0 day (last pass: v6.1.22-178-gf8a7fa4a96bb, first fa=
il: v6.1.22-480-g90c08f549ee7)
        1 lines

    2023-04-19T14:26:29.006764  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eebb0ee8, epc =3D=3D 80202014, ra =3D=
=3D 80204964
    2023-04-19T14:26:29.006898  =


    2023-04-19T14:26:29.029851  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-19T14:26:29.029970  =

   =

 =20
