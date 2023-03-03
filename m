Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F7E6A9CEC
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 18:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjCCRNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 12:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCCRNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 12:13:52 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EC91514E
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 09:13:48 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u5so3354976plq.7
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 09:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677863628;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=G12uBiMo11jWLfmYJSnFK/+6SRLpjPICgml2c0gBnuA=;
        b=sqWi8Bt9MkFTQ68BZblcxgL6BWIAcjRPQOfJYH/LbMTRYLQa2P90NgHW0U9UTAKJxh
         xNERNwcWvZuRUjOCll5a1xdQEEDRiQCvprP7mOXPJBQPI9bsjxn8dAMbbVA7t2u0fotv
         elwV6xYMKaQJpE+S4MXPDEfKfS/phcbRjcHTXBb7ML4m0HK0+FFsPx54sCi++Yvn8jg8
         4c0ixJEn+VHR6zmFblOPKVoG/FmFcKp1koDVyusg8WPgamdcE7NO1vqepYcrNYaPYJEe
         iEw8YXDN0bXOnbvtE6NyDPcw0z5znZfcbujLXBchA/hWC88LebILxB0vUtxQMs/DYJXZ
         L+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677863628;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G12uBiMo11jWLfmYJSnFK/+6SRLpjPICgml2c0gBnuA=;
        b=Y2MIpo4XrQpk8z/cugYjxGJX0EvWwZFmVgwszIbTPLAhufS6aVc8gLNyJlwIe7gSeB
         RkpmSCOuoOnp4Sg0CcftKqRM944KOR5Fd/UJX2amx/zqeCpK2SBY6ZeQeBqnm1nP8z+u
         G3EekZsNP6A4lcRl1jcjgrrpxrz3lwDuOABRNFsnCXiW3h4j2T6MxSuGLhmzvYJnQpzD
         K7TkKQ55bAzeJQPiwnAFQrvshm5ghh8EKPLbxYy+9JXq7yrLR9tdRsXLVdRlNxiU5f9p
         tGpCxVGxjYpmwzxtxymrqt9bTJlThUjijCvadK2hp+onZFN1EtKC8yAjONRIutka6fTT
         a7Sw==
X-Gm-Message-State: AO0yUKWVQU6GBQ54HDFMQ3pJvIFZIvuICXQXvtBPId1yQnNfwRu52l9G
        i/PMjSFuoHfi2bXeDvWCMlJo0P7ZN6Mfo5cODltakQ==
X-Google-Smtp-Source: AK7set9Q2SKAHvMgkWjbyPzFkLBq2kfXJK4vW6jje9E1qzO0/j+imaqSzjHR5yC/kJjhkPNwM8b4lg==
X-Received: by 2002:a17:902:ea11:b0:194:cc66:66f7 with SMTP id s17-20020a170902ea1100b00194cc6666f7mr3097063plg.19.1677863626558;
        Fri, 03 Mar 2023 09:13:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kd5-20020a17090313c500b00198f256a192sm237809plb.171.2023.03.03.09.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 09:13:45 -0800 (PST)
Message-ID: <64022ac9.170a0220.6f301.0cb7@mx.google.com>
Date:   Fri, 03 Mar 2023 09:13:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.275
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 146 runs, 53 regressions (v4.19.275)
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

stable/linux-4.19.y baseline: 146 runs, 53 regressions (v4.19.275)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | davinc=
i_all_defconfig        | 2          =

imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6ul-pico-hobbit           | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =

rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.275/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.275
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5504146b2053f842426834d275002974109f39a6 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f989645b3c4d208c8648

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f989645b3c4d208c8651
        failing since 43 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:43:20.260691  + set +x<8>[    9.736116] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9402521_1.4.2.3.1>

    2023-03-03T13:43:20.260780  =


    2023-03-03T13:43:20.362786  #

    2023-03-03T13:43:20.463988  / # #export SHELL=3D/bin/sh

    2023-03-03T13:43:20.464199  =


    2023-03-03T13:43:20.565112  / # export SHELL=3D/bin/sh. /lava-9402521/e=
nvironment

    2023-03-03T13:43:20.565289  =


    2023-03-03T13:43:20.666215  / # . /lava-9402521/environment/lava-940252=
1/bin/lava-test-runner /lava-9402521/1

    2023-03-03T13:43:20.666468  =


    2023-03-03T13:43:20.671955  / # /lava-9402521/bin/lava-test-runner /lav=
a-9402521/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f9d837bcda21448c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f9d837bcda21448c8638
        failing since 43 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:44:31.091191  + set +x

    2023-03-03T13:44:31.097370  <8>[   11.411186] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9402531_1.4.2.3.1>

    2023-03-03T13:44:31.206159  / # #

    2023-03-03T13:44:31.309195  export SHELL=3D/bin/sh

    2023-03-03T13:44:31.310025  #

    2023-03-03T13:44:31.412260  / # export SHELL=3D/bin/sh. /lava-9402531/e=
nvironment

    2023-03-03T13:44:31.413252  =


    2023-03-03T13:44:31.515411  / # . /lava-9402531/environment/lava-940253=
1/bin/lava-test-runner /lava-9402531/1

    2023-03-03T13:44:31.516940  =


    2023-03-03T13:44:31.522317  / # /lava-9402531/bin/lava-test-runner /lav=
a-9402531/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f84f13671a84168c8662

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f84f13671a84168c866b
        failing since 25 days (last pass: v4.19.271, first fail: v4.19.272)

    2023-03-03T13:38:04.968609  + set +x
    2023-03-03T13:38:04.973024  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 90770_1.5.2.=
4.1>
    2023-03-03T13:38:05.087328  / # #
    2023-03-03T13:38:05.190710  export SHELL=3D/bin/sh
    2023-03-03T13:38:05.191719  #
    2023-03-03T13:38:05.293743  / # export SHELL=3D/bin/sh. /lava-90770/env=
ironment
    2023-03-03T13:38:05.294699  =

    2023-03-03T13:38:05.396969  / # . /lava-90770/environment/lava-90770/bi=
n/lava-test-runner /lava-90770/1
    2023-03-03T13:38:05.398429  =

    2023-03-03T13:38:05.404711  / # /lava-90770/bin/lava-test-runner /lava-=
90770/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f9a07254c8fc7e8c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f9a07254c8fc7e8c8638
        failing since 38 days (last pass: v4.19.268, first fail: v4.19.271)

    2023-03-03T13:43:41.665550  + set +x<8>[   25.501556] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3381452_1.5.2.4.1>
    2023-03-03T13:43:41.665796  =

    2023-03-03T13:43:41.775370  / # #
    2023-03-03T13:43:41.876876  export SHELL=3D/bin/sh
    2023-03-03T13:43:41.877262  #
    2023-03-03T13:43:41.978433  / # export SHELL=3D/bin/sh. /lava-3381452/e=
nvironment
    2023-03-03T13:43:41.978804  =

    2023-03-03T13:43:42.079970  / # . /lava-3381452/environment/lava-338145=
2/bin/lava-test-runner /lava-3381452/1
    2023-03-03T13:43:42.080513  =

    2023-03-03T13:43:42.122283  / # /lava-3381452/bin/lava-test-runner /lav=
a-3381452/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f94e05563766dc8c8650

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f94e05563766dc8c8659
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:42:14.141643  <8>[   15.516783] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 90843_1.5.2.4.1>
    2023-03-03T13:42:14.250158  / # #
    2023-03-03T13:42:14.352956  export SHELL=3D/bin/sh
    2023-03-03T13:42:14.353700  #
    2023-03-03T13:42:14.456035  / # export SHELL=3D/bin/sh. /lava-90843/env=
ironment
    2023-03-03T13:42:14.456842  =

    2023-03-03T13:42:14.559222  / # . /lava-90843/environment/lava-90843/bi=
n/lava-test-runner /lava-90843/1
    2023-03-03T13:42:14.560391  =

    2023-03-03T13:42:14.564455  / # /lava-90843/bin/lava-test-runner /lava-=
90843/1
    2023-03-03T13:42:14.631853  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640201a88bab75be128c865e

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640201a88bab75be128c8665
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T14:18:00.516948  <8>[    8.881814] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 864531_1.5.2.4.1>
    2023-03-03T14:18:00.626289  / # #
    2023-03-03T14:18:00.727649  export SHELL=3D/bin/sh
    2023-03-03T14:18:00.727981  #
    2023-03-03T14:18:00.829101  / # export SHELL=3D/bin/sh. /lava-864531/en=
vironment
    2023-03-03T14:18:00.829396  =

    2023-03-03T14:18:00.930564  / # . /lava-864531/environment/lava-864531/=
bin/lava-test-runner /lava-864531/1
    2023-03-03T14:18:00.931036  =

    2023-03-03T14:18:00.936771  / # /lava-864531/bin/lava-test-runner /lava=
-864531/1
    2023-03-03T14:18:01.003298  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f974c23f6994c08c8631

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f974c23f6994c08c863a
        new failure (last pass: v4.19.274)

    2023-03-03T13:42:52.790164  + set +x<8>[   19.008046] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 90859_1.5.2.4.1>
    2023-03-03T13:42:52.790546  =

    2023-03-03T13:42:52.902020  / # #
    2023-03-03T13:42:53.005119  export SHELL=3D/bin/sh
    2023-03-03T13:42:53.005867  #
    2023-03-03T13:42:53.108313  / # export SHELL=3D/bin/sh. /lava-90859/env=
ironment
    2023-03-03T13:42:53.109092  =

    2023-03-03T13:42:53.211223  / # . /lava-90859/environment/lava-90859/bi=
n/lava-test-runner /lava-90859/1
    2023-03-03T13:42:53.212612  =

    2023-03-03T13:42:53.217101  / # /lava-90859/bin/lava-test-runner /lava-=
90859/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f92ad2603e7a7b8c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f92ad2603e7a7b8c8638
        failing since 43 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:41:50.445852  <8>[    7.316676] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3381444_1.5.2.4.1>
    2023-03-03T13:41:50.553092  / # #
    2023-03-03T13:41:50.654609  export SHELL=3D/bin/sh
    2023-03-03T13:41:50.654977  #
    2023-03-03T13:41:50.756137  / # export SHELL=3D/bin/sh. /lava-3381444/e=
nvironment
    2023-03-03T13:41:50.756501  =

    2023-03-03T13:41:50.857722  / # . /lava-3381444/environment/lava-338144=
4/bin/lava-test-runner /lava-3381444/1
    2023-03-03T13:41:50.858275  =

    2023-03-03T13:41:50.863186  / # /lava-3381444/bin/lava-test-runner /lav=
a-3381444/1
    2023-03-03T13:41:50.948024  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | davinc=
i_all_defconfig        | 2          =


  Details:     https://kernelci.org/test/plan/id/6401f7fdc4d94ffb2c8c863c

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6401f7fdc4d94ff=
b2c8c863f
        new failure (last pass: v4.19.271)
        4 lines

    2023-03-03T13:36:44.889263  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2023-03-03T13:36:44.890001  kern  :emerg : flags: 0x0()
    2023-03-03T13:36:44.890561  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2023-03-03T13:36:44.892509  kern  :emerg : flags: 0x0()
    2023-03-03T13:36:44.959570  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-03-03T13:36:44.960491  + set +x   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6401f7fdc4d94ff=
b2c8c8640
        new failure (last pass: v4.19.271)
        6 lines

    2023-03-03T13:36:44.703413  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2023-03-03T13:36:44.704110  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2023-03-03T13:36:44.704550  kern  :alert : page dumped because: nonzero=
 mapcount
    2023-03-03T13:36:44.704952  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2023-03-03T13:36:44.705337  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2023-03-03T13:36:44.706607  kern  :alert : page dumped because: nonzero=
 mapcount
    2023-03-03T13:36:44.748438  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f910577cb1b0f38c8661

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f910577cb1b0f38c866a
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:41:18.607800  / # #

    2023-03-03T13:41:18.710890  export SHELL=3D/bin/sh

    2023-03-03T13:41:18.711741  #

    2023-03-03T13:41:18.813819  / # export SHELL=3D/bin/sh. /lava-9402448/e=
nvironment

    2023-03-03T13:41:18.814671  =


    2023-03-03T13:41:18.916906  / # . /lava-9402448/environment/lava-940244=
8/bin/lava-test-runner /lava-9402448/1

    2023-03-03T13:41:18.918187  =


    2023-03-03T13:41:18.929809  / # /lava-9402448/bin/lava-test-runner /lav=
a-9402448/1

    2023-03-03T13:41:18.977799  + export 'TESTRUN_ID=3D1_bootrr'

    2023-03-03T13:41:19.029684  + cd /lava-9402448/1/tests/1_bootrr
 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f75aa2ddccc55d8c8638

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f75aa2ddccc55d8c8641
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:34:08.873786  + set +x[    7.142680] <LAVA_SIGNAL_ENDRUN =
0_dmesg 914165_1.5.2.3.1>
    2023-03-03T13:34:08.873959  =

    2023-03-03T13:34:08.981392  / # #
    2023-03-03T13:34:09.083388  export SHELL=3D/bin/sh
    2023-03-03T13:34:09.083978  #
    2023-03-03T13:34:09.185175  / # export SHELL=3D/bin/sh. /lava-914165/en=
vironment
    2023-03-03T13:34:09.185650  =

    2023-03-03T13:34:09.286831  / # . /lava-914165/environment/lava-914165/=
bin/lava-test-runner /lava-914165/1
    2023-03-03T13:34:09.287380  =

    2023-03-03T13:34:09.290381  / # /lava-914165/bin/lava-test-runner /lava=
-914165/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f8f164d3c3f7868c86c1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f8f164d3c3f7868c86ca
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:40:54.090245  + set +x
    2023-03-03T13:40:54.090422  [    4.850630] <LAVA_SIGNAL_ENDRUN 0_dmesg =
914176_1.5.2.3.1>
    2023-03-03T13:40:54.196792  / # #
    2023-03-03T13:40:54.298351  export SHELL=3D/bin/sh
    2023-03-03T13:40:54.298747  #
    2023-03-03T13:40:54.399903  / # export SHELL=3D/bin/sh. /lava-914176/en=
vironment
    2023-03-03T13:40:54.400287  =

    2023-03-03T13:40:54.501469  / # . /lava-914176/environment/lava-914176/=
bin/lava-test-runner /lava-914176/1
    2023-03-03T13:40:54.501972  =

    2023-03-03T13:40:54.504716  / # /lava-914176/bin/lava-test-runner /lava=
-914176/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6ul-pico-hobbit           | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f93c0796cd85858c867d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f93c0796cd85858c8686
        new failure (last pass: v4.19.265)

    2023-03-03T13:41:40.581389  + set +x
    2023-03-03T13:41:40.581557  [   11.835364] <LAVA_SIGNAL_ENDRUN 0_dmesg =
914178_1.5.2.3.1>
    2023-03-03T13:41:40.689058  / # #
    2023-03-03T13:41:40.790524  export SHELL=3D/bin/sh
    2023-03-03T13:41:40.790923  #
    2023-03-03T13:41:40.892669  / # export SHELL=3D/bin/sh. /lava-914178/en=
vironment
    2023-03-03T13:41:40.893119  =

    2023-03-03T13:41:40.994333  / # . /lava-914178/environment/lava-914178/=
bin/lava-test-runner /lava-914178/1
    2023-03-03T13:41:40.994827  =

    2023-03-03T13:41:41.000194  / # /lava-914178/bin/lava-test-runner /lava=
-914178/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f8c764d3c3f7868c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401f8c764d3c3f7868c8=
630
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fa06da6a2bbc218c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fa06da6a2bbc218c8=
636
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fbfdd89f14e97d8c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fbfdd89f14e97d8c8=
640
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fea54f32e9c3c48c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fea54f32e9c3c48c8=
643
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f8d764d3c3f7868c8684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401f8d764d3c3f7868c8=
685
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fa05f596eca96f8c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fa05f596eca96f8c8=
637
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fbfea050f743468c8665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fbfea050f743468c8=
666
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fdf12c6dcf523b8c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fdf12c6dcf523b8c8=
64f
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f8c5e47049de588c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401f8c5e47049de588c8=
639
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fa03d1d57dc6dc8c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fa03d1d57dc6dc8c8=
632
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fbd403b97fc7148c865d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fbd403b97fc7148c8=
65e
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fdc94b8953012d8c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fdc94b8953012d8c8=
649
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f8c6983606a86d8c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401f8c6983606a86d8c8=
63d
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fa04d1d57dc6dc8c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fa04d1d57dc6dc8c8=
645
        failing since 216 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fbe9a03cec97a78c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fbe9a03cec97a78c8=
645
        failing since 295 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fddd4c3f731cc98c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fddd4c3f731cc98c8=
63b
        failing since 216 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401fa030c9b6d11548c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401fa030c9b6d11548c8=
63b
        failing since 216 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f50d9d705f68ba8c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6401f50d9d705f68ba8c8=
64b
        failing since 97 days (last pass: v4.19.266, first fail: v4.19.267) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/6401f913577cb1b0f38c866c

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/6401f913577cb1b0f38c86a0
        failing since 42 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:41:11.111294  BusyBox v1.31.1 (2023-02-24 15:56:01 UTC)<8=
>[   14.522028] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>

    2023-03-03T13:41:11.112471   multi-call binary.

    2023-03-03T13:41:11.112927  =


    2023-03-03T13:41:11.117221  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-03-03T13:41:11.117665  =


    2023-03-03T13:41:11.122296  Print numbers from FIRST to LAST, in steps =
of INC.
   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/6401f913577cb1b0f38c86a1
        failing since 42 days (last pass: v4.19.269, first fail: v4.19.270) =


  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f913577cb1b0f38c86b4
        failing since 42 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:41:07.260053  <8>[   10.671869] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-03-03T13:41:07.267899  + <8>[   10.684142] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9402450_1.5.2.3.1>

    2023-03-03T13:41:07.269769  set +x

    2023-03-03T13:41:07.376257  #

    2023-03-03T13:41:07.479341  / # #export SHELL=3D/bin/sh

    2023-03-03T13:41:07.480165  =


    2023-03-03T13:41:07.582165  / # export SHELL=3D/bin/sh. /lava-9402450/e=
nvironment

    2023-03-03T13:41:07.583002  =


    2023-03-03T13:41:07.685357  / # . /lava-9402450/environment/lava-940245=
0/bin/lava-test-runner /lava-9402450/1

    2023-03-03T13:41:07.686498  =

 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =


  Details:     https://kernelci.org/test/plan/id/6401f94d40deddd9268c863b

  Results:     79 PASS, 9 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6401f94d40deddd9268c8661
        failing since 351 days (last pass: v4.19.231, first fail: v4.19.235)

    2023-03-03T13:42:14.831162  /lava-9402416/1/../bin/lava-test-case<8>[  =
 34.892505] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s0-probed RESUL=
T=3Dpass>

    2023-03-03T13:42:14.831464  =


    2023-03-03T13:42:15.844580  /lava-9402416/1/../bin/lava-test-case

    2023-03-03T13:42:15.853154  <8>[   35.914956] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-rt5514-present: https://kernelc=
i.org/test/case/id/6401f94d40deddd9268c8676
        failing since 44 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:42:14.362784  RST [INC]] LAST

    2023-03-03T13:42:14.362874  =


    2023-03-03T13:42:14.367845  Print numbers from FIRST to LAST, in steps =
of INC.

    2023-03-03T13:42:14.370390  FIRST, INC default to 1.

    2023-03-03T13:42:14.370687  =


    2023-03-03T13:42:14.373951  	-w	Pad to last with leading zeros

    2023-03-03T13:42:14.376548  	-s SEP	String separator
   =


  * baseline.bootrr.rk3399-gru-sound-driver-max98357A-present: https://kern=
elci.org/test/case/id/6401f94d40deddd9268c8677
        failing since 44 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:42:14.331703  	<8>[   34.390235] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Drk3399-gru-sound-driver-dp-present RESULT=3Dfail>

    2023-03-03T13:42:14.334931  -w	Pad to last with leading zeros

    2023-03-03T13:42:14.337289  	-s SEP	String separator

    2023-03-03T13:42:14.341325  /lava-9402416/1/../bin/lava-test-case

    2023-03-03T13:42:14.347334  BusyBox v1.31.1 (2023-02-24 16:18:20 UTC) m=
ulti-call binary.

    2023-03-03T13:42:14.347611  =


    2023-03-03T13:42:14.360909  Usage: seq [-w] [-s SEP] [FI<8>[   34.41691=
6] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-driver-max98357A-p=
resent RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-dp-present: https://kernelci.or=
g/test/case/id/6401f94d40deddd9268c8678
        failing since 44 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:42:14.309311  <8>[   34.367040] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-da7219-present RESULT=3Dfail>

    2023-03-03T13:42:14.313634  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-03-03T13:42:14.313742  =


    2023-03-03T13:42:14.318857  Print numbers from FIRST to LAST, in steps =
of INC.

    2023-03-03T13:42:14.321742  FIRST, INC default to 1.

    2023-03-03T13:42:14.321845  =

   =


  * baseline.bootrr.rk3399-gru-sound-driver-da7219-present: https://kernelc=
i.org/test/case/id/6401f94d40deddd9268c8679
        failing since 44 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:42:14.282033  <8>[   34.343309] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-present RESULT=3Dpass>

    2023-03-03T13:42:14.298668  BusyBox v1.31.1 (2023-02-24 16:18:20 UTC) m=
ulti-call binary.

    2023-03-03T13:42:14.299021  =

   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f8e064d3c3f7868c8692

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f8e064d3c3f7868c869b
        failing since 44 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:40:22.418453  + set +x
    2023-03-03T13:40:22.420322  <8>[   17.094114] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 406789_1.5.2.4.1>
    2023-03-03T13:40:22.528191  / # #
    2023-03-03T13:40:22.630785  export SHELL=3D/bin/sh
    2023-03-03T13:40:22.631454  #
    2023-03-03T13:40:22.733115  / # export SHELL=3D/bin/sh. /lava-406789/en=
vironment
    2023-03-03T13:40:22.733690  =

    2023-03-03T13:40:22.734128  / # <3>[   17.351206] brcmfmac: brcmf_sdio_=
htclk: HT Avail timeout (1000000): clkctl 0x50
    2023-03-03T13:40:22.835898  . /lava-406789/environment/lava-406789/bin/=
lava-test-runner /lava-406789/1
    2023-03-03T13:40:22.836949   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f9ebf0d73feef78c86af

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f9ebf0d73feef78c86b8
        failing since 43 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:44:57.887168  <8>[   15.933886] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 90787_1.5.2.4.1>
    2023-03-03T13:44:57.994455  / # #
    2023-03-03T13:44:58.096933  export SHELL=3D/bin/sh
    2023-03-03T13:44:58.097801  #
    2023-03-03T13:44:58.200038  / # export SHELL=3D/bin/sh. /lava-90787/env=
ironment
    2023-03-03T13:44:58.200936  =

    2023-03-03T13:44:58.303262  / # . /lava-90787/environment/lava-90787/bi=
n/lava-test-runner /lava-90787/1
    2023-03-03T13:44:58.304615  =

    2023-03-03T13:44:58.308931  / # /lava-90787/bin/lava-test-runner /lava-=
90787/1
    2023-03-03T13:44:58.340253  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f882025fb33bec8c8634

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f882025fb33bec8c863d
        failing since 44 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:39:01.043069  <8>[   15.158418] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 406790_1.5.2.4.1>
    2023-03-03T13:39:01.149739  / # #
    2023-03-03T13:39:01.252039  export SHELL=3D/bin/sh
    2023-03-03T13:39:01.252628  #
    2023-03-03T13:39:01.354132  / # export SHELL=3D/bin/sh. /lava-406790/en=
vironment
    2023-03-03T13:39:01.354702  =

    2023-03-03T13:39:01.456360  / # . /lava-406790/environment/lava-406790/=
bin/lava-test-runner /lava-406790/1
    2023-03-03T13:39:01.457351  =

    2023-03-03T13:39:01.473925  / # /lava-406790/bin/lava-test-runner /lava=
-406790/1
    2023-03-03T13:39:01.490011  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f7d3c4cdb062d28c863d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f7d3c4cdb062d28c8646
        failing since 44 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:36:03.606706  / # #

    2023-03-03T13:36:03.708571  export SHELL=3D/bin/sh

    2023-03-03T13:36:03.709098  #

    2023-03-03T13:36:03.810440  / # export SHELL=3D/bin/sh. /lava-9402381/e=
nvironment

    2023-03-03T13:36:03.811020  =


    2023-03-03T13:36:03.912326  / # . /lava-9402381/environment/lava-940238=
1/bin/lava-test-runner /lava-9402381/1

    2023-03-03T13:36:03.913075  =


    2023-03-03T13:36:03.915886  / # /lava-9402381/bin/lava-test-runner /lav=
a-9402381/1

    2023-03-03T13:36:03.988210  + export 'TESTRUN_ID=3D1_bootrr'

    2023-03-03T13:36:03.988518  + cd /lava-9402381<8>[   15.627940] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 9402381_1.5.2.4.5>
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64020d6e9186edeff88c8640

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64020d6e9186edeff88c8649
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T15:08:11.551780  <8>[   17.274444] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 406793_1.5.2.4.1>
    2023-03-03T15:08:11.658656  / # #
    2023-03-03T15:08:11.760897  export SHELL=3D/bin/sh
    2023-03-03T15:08:11.761468  #
    2023-03-03T15:08:11.863068  / # export SHELL=3D/bin/sh. /lava-406793/en=
vironment
    2023-03-03T15:08:11.863773  =

    2023-03-03T15:08:11.965364  / # . /lava-406793/environment/lava-406793/=
bin/lava-test-runner /lava-406793/1
    2023-03-03T15:08:11.966379  =

    2023-03-03T15:08:11.968864  / # /lava-406793/bin/lava-test-runner /lava=
-406793/1
    2023-03-03T15:08:12.090829  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f913ec911c18938c867e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f913ec911c18938c8687
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:41:14.575457  / # #
    2023-03-03T13:41:14.677357  export SHELL=3D/bin/sh
    2023-03-03T13:41:14.677740  #
    2023-03-03T13:41:14.779136  / # export SHELL=3D/bin/sh. /lava-3381435/e=
nvironment
    2023-03-03T13:41:14.779697  =

    2023-03-03T13:41:14.881043  / # . /lava-3381435/environment/lava-338143=
5/bin/lava-test-runner /lava-3381435/1
    2023-03-03T13:41:14.881694  =

    2023-03-03T13:41:14.886691  / # /lava-3381435/bin/lava-test-runner /lav=
a-3381435/1
    2023-03-03T13:41:14.983524  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-03T13:41:14.984012  + cd /lava-3381435/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f66b7eecc3acaa8c864c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f66b7eecc3acaa8c8655
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:29:52.811801  <8>[    7.844577] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3381397_1.5.2.4.1>
    2023-03-03T13:29:52.916879  / # #
    2023-03-03T13:29:53.018553  export SHELL=3D/bin/sh
    2023-03-03T13:29:53.019042  #
    2023-03-03T13:29:53.120568  / # export SHELL=3D/bin/sh. /lava-3381397/e=
nvironment
    2023-03-03T13:29:53.121047  =

    2023-03-03T13:29:53.222598  / # . /lava-3381397/environment/lava-338139=
7/bin/lava-test-runner /lava-3381397/1
    2023-03-03T13:29:53.223455  =

    2023-03-03T13:29:53.242473  / # /lava-3381397/bin/lava-test-runner /lav=
a-3381397/1
    2023-03-03T13:29:53.307338  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64022170826c15879e8c8634

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64022170826c15879e8c863d
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T16:33:41.548010  + set +x
    2023-03-03T16:33:41.549904  <8>[   15.350352] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 406792_1.5.2.4.1>
    2023-03-03T16:33:41.657723  / # #
    2023-03-03T16:33:41.760331  export SHELL=3D/bin/sh
    2023-03-03T16:33:41.760866  #
    2023-03-03T16:33:41.862553  / # export SHELL=3D/bin/sh. /lava-406792/en=
vironment
    2023-03-03T16:33:41.863208  =

    2023-03-03T16:33:41.964874  / # . /lava-406792/environment/lava-406792/=
bin/lava-test-runner /lava-406792/1
    2023-03-03T16:33:41.965888  =

    2023-03-03T16:33:41.967609  / # /lava-406792/bin/lava-test-runner /lava=
-406792/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/6402212006101864228c86de

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6402212006101864228c86e7
        failing since 44 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T16:31:59.580401  <8>[   10.360412] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 406780_1.5.2.4.1>
    2023-03-03T16:31:59.688426  / # #
    2023-03-03T16:31:59.790884  export SHELL=3D/bin/sh
    2023-03-03T16:31:59.791452  #
    2023-03-03T16:31:59.893099  / # export SHELL=3D/bin/sh. /lava-406780/en=
vironment
    2023-03-03T16:31:59.893651  =

    2023-03-03T16:31:59.995310  / # . /lava-406780/environment/lava-406780/=
bin/lava-test-runner /lava-406780/1
    2023-03-03T16:31:59.996291  =

    2023-03-03T16:31:59.998120  / # /lava-406780/bin/lava-test-runner /lava=
-406780/1
    2023-03-03T16:32:00.042520  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f9a17254c8fc7e8c863a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f9a27254c8fc7e8c8643
        failing since 42 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:43:44.993798  + set +x

    2023-03-03T13:43:45.001219  <8>[   17.959944] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9402443_1.5.2.3.1>

    2023-03-03T13:43:45.109378  #

    2023-03-03T13:43:45.110000  =


    2023-03-03T13:43:45.211537  / # #export SHELL=3D/bin/sh

    2023-03-03T13:43:45.211936  =


    2023-03-03T13:43:45.313236  / # export SHELL=3D/bin/sh. /lava-9402443/e=
nvironment

    2023-03-03T13:43:45.313642  =


    2023-03-03T13:43:45.414933  / # . /lava-9402443/environment/lava-940244=
3/bin/lava-test-runner /lava-9402443/1

    2023-03-03T13:43:45.415576  =

 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f7333828d687e98c868c

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f7333828d687e98c8695
        failing since 42 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-03T13:33:19.942820  kern  :emerg : Process udevadm (pid<8>[   1=
8.405008] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3D=
lines MEASUREMENT=3D11>

    2023-03-03T13:33:19.946440  : 140, stack limit =3D 0x(ptrval))

    2023-03-03T13:33:19.953976  kern  <8>[   18.418884] <LAVA_SIGNAL_ENDRUN=
 0_dmesg 9402286_1.5.2.3.1>

    2023-03-03T13:33:19.956375  :emerg : Stack: (0xc2c77f2c to 0xc2c78000)

    2023-03-03T13:33:19.964756  kern  :emerg : 7f20:                       =
     c02e8030 00000000 00000000 c026d6dc 00000003

    2023-03-03T13:33:19.972833  kern  :emerg : 7f40: ee369b40 bececf74 c2c7=
7f80 00000000 c2c76000 00000004 00000003 c0270590

    2023-03-03T13:33:19.980847  kern  :emerg : 7f60: edfe61d0 c026d6dc ee36=
9b40 ee369b40 bececf74 00000003 c0101264 c02707f4

    2023-03-03T13:33:19.988869  kern  :emerg : 7f80: 00000000 00000000 c2c7=
7fb0 517caa44 b6fef7c0 00000003 b6fef7c0 becec468

    2023-03-03T13:33:19.997002  kern  :emerg : 7fa0: 00000004 c0101000 0000=
0003 b6fef7c0 00000003 bececf74 00000003 00000000

    2023-03-03T13:33:20.005209  kern  :emerg : 7fc0: 00000003 b6fef7c0 bece=
c468 00000004 00000003 0003c90c becece58 00000003
 =

    ... (23 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f7a943e2984ada8c864d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f7a943e2984ada8c8654
        failing since 44 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:35:20.287153  <8>[    3.737692] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 864517_1.5.2.4.1>
    2023-03-03T13:35:20.392131  / # #
    2023-03-03T13:35:20.493420  export SHELL=3D/bin/sh
    2023-03-03T13:35:20.493711  #
    2023-03-03T13:35:20.594725  / # export SHELL=3D/bin/sh. /lava-864517/en=
vironment
    2023-03-03T13:35:20.595081  =

    2023-03-03T13:35:20.696089  / # . /lava-864517/environment/lava-864517/=
bin/lava-test-runner /lava-864517/1
    2023-03-03T13:35:20.696603  =

    2023-03-03T13:35:20.698928  / # /lava-864517/bin/lava-test-runner /lava=
-864517/1
    2023-03-03T13:35:20.735954  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6401f92521011201818c8665

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.275/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6401f92521011201818c866c
        failing since 44 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-03T13:41:38.189909  / # #
    2023-03-03T13:41:38.291733  export SHELL=3D/bin/sh
    2023-03-03T13:41:38.292182  #
    2023-03-03T13:41:38.393543  / # export SHELL=3D/bin/sh. /lava-864519/en=
vironment
    2023-03-03T13:41:38.393998  =

    2023-03-03T13:41:38.495369  / # . /lava-864519/environment/lava-864519/=
bin/lava-test-runner /lava-864519/1
    2023-03-03T13:41:38.496107  =

    2023-03-03T13:41:38.498760  / # /lava-864519/bin/lava-test-runner /lava=
-864519/1
    2023-03-03T13:41:38.535769  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-03T13:41:38.536072  + cd /lava-864519/1/tests/1_bootrr =

    ... (11 line(s) more)  =

 =20
