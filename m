Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAE66BD4E6
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCPQP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCPQP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:15:58 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CABFCA1CA
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 09:15:21 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id iw3so2289249plb.6
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 09:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678983318;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=S5cdHoHm+vTOL4iKOSEdUAuVUNF5/135zKXHlSp3BTk=;
        b=AvJ/t0fo6qAr1e3QqwL9eVp4y8o7ba3zrfbOuA1FTTj0p8WHlrmYQEMDd6kPp0BKuf
         Cq5xjBVhaHQ3Uhslc9PDqJrR3roGQOdCBC7RGvaoTeg5PEHmCiWyMH49vrfAWJaPCQ6N
         heyIUKoxo0KrepBGFH7Y0aOcqHOIab3afeNFtiHGoh1d/vkqX6IVIORu4l+PX1DHQn7x
         k9NXQkFTrQirWi5NlOQsSlUIJ9zBMeG3zcHrnFxhdqH89N4qr+2DI8WRuyHHOYw+zMwK
         doHVdpd7KQnx/AGpMsVX3mgqa7bwxmViAGKBYxHu5ri3qDsbU+V14TcfvC7ieyMFyN2s
         qrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678983318;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S5cdHoHm+vTOL4iKOSEdUAuVUNF5/135zKXHlSp3BTk=;
        b=WTEAfCt+zbaKD0F+/u/Z2VybJ4RgU2eTPIX2RzyqEelrCX0uoUJma+TF4t57hZ0h+H
         CdtlPTO7sdIlQJqUq54YnvlZvVAQPDGclEp1Kuis9pRMdDi8FW6oL4OSatPQ6aW5RFdb
         vh3qWteqmHYKRccxDy0KUJ2pC/bqeUzD058L8Xn/tJVZpumretC4Gjvlz9HdQVtZJ/No
         OyhigpASaj1yX+RDHU2z4SDABH6SoPiwhNhaIGPmvOvWI6jzNmAuxG1eVxa9RGj5DNpW
         3GwJfzCpFlSBJDV7SrmbQK0QXALton3amN/uN8RnTMtm/0izvM5IjX8OpYmkULRGYUJk
         FXFQ==
X-Gm-Message-State: AO0yUKUXzwUYRh9jLo0q9tTkPjAcOPa0dbdn2x4lfNejbzvYhMPr4yGI
        Nngfe9e8xjqLhx3itLEN1rKBkracAeaYSt6hL6haMcWb
X-Google-Smtp-Source: AK7set+wsPsSnLu2dc1CKEyAcBOZJeST/7assMZZ9rGtnSK31OmSKIJOsoyNKtILOtfg2Mze/Ae0aA==
X-Received: by 2002:a05:6a20:6a1a:b0:c7:af88:3c8f with SMTP id p26-20020a056a206a1a00b000c7af883c8fmr4732760pzk.25.1678983318001;
        Thu, 16 Mar 2023 09:15:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c7-20020aa78e07000000b0058a3d8eab6asm5657817pfr.134.2023.03.16.09.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 09:15:17 -0700 (PDT)
Message-ID: <64134095.a70a0220.10d08.ca3c@mx.google.com>
Date:   Thu, 16 Mar 2023 09:15:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-94-g3f1dbb65a450
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 156 runs,
 9 regressions (v5.10.173-94-g3f1dbb65a450)
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

stable-rc/queue/5.10 baseline: 156 runs, 9 regressions (v5.10.173-94-g3f1db=
b65a450)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.173-94-g3f1dbb65a450/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.173-94-g3f1dbb65a450
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f1dbb65a450359f1d6a5f4473040bacf01b4ef9 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64130b8e537978f5b88c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64130b8e537978f5b88c8=
633
        failing since 1 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64130a27cd856a1e0d8c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64130a27cd856a1e0d8c8=
634
        failing since 1 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64130a2993ace2053b8c8673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64130a2993ace2053b8c8=
674
        failing since 1 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6413088944b75e9c9a8c865c

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6413088a44b75e9c9a8c8692
        failing since 30 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-16T12:15:59.750125  + set +x
    2023-03-16T12:15:59.753960  <8>[   21.339586] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 172026_1.5.2.4.1>
    2023-03-16T12:15:59.864030  / # #
    2023-03-16T12:15:59.966785  export SHELL=3D/bin/sh
    2023-03-16T12:15:59.967392  #
    2023-03-16T12:16:00.069287  / # export SHELL=3D/bin/sh. /lava-172026/en=
vironment
    2023-03-16T12:16:00.069875  =

    2023-03-16T12:16:00.171790  / # . /lava-172026/environment/lava-172026/=
bin/lava-test-runner /lava-172026/1
    2023-03-16T12:16:00.172864  =

    2023-03-16T12:16:00.176547  / # /lava-172026/bin/lava-test-runner /lava=
-172026/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64130ad4dcb082c2658c8662

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64130ad4dcb082c2658c866b
        failing since 49 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-16T12:25:42.190197  + set +x<8>[   11.044183] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3416974_1.5.2.4.1>
    2023-03-16T12:25:42.190702  =

    2023-03-16T12:25:42.299338  / # #
    2023-03-16T12:25:42.402421  export SHELL=3D/bin/sh
    2023-03-16T12:25:42.402781  #
    2023-03-16T12:25:42.504081  / # export SHELL=3D/bin/sh. /lava-3416974/e=
nvironment
    2023-03-16T12:25:42.504421  =

    2023-03-16T12:25:42.605549  / # . /lava-3416974/environment/lava-341697=
4/bin/lava-test-runner /lava-3416974/1
    2023-03-16T12:25:42.606216  =

    2023-03-16T12:25:42.611025  / # /lava-3416974/bin/lava-test-runner /lav=
a-3416974/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64130a3fe3f9df96958c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64130a3fe3f9df96958c8=
630
        failing since 1 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64130a29cd856a1e0d8c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64130a29cd856a1e0d8c8=
63a
        failing since 1 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64130b56f68b97ec868c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64130b56f68b97ec868c8=
65a
        failing since 1 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64130a88c8950bf6d38c8669

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-94-g3f1dbb65a450/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64130a88c8950bf6d38c8672
        failing since 42 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-16T12:24:12.370462  / # #
    2023-03-16T12:24:12.472502  export SHELL=3D/bin/sh
    2023-03-16T12:24:12.473063  #
    2023-03-16T12:24:12.574380  / # export SHELL=3D/bin/sh. /lava-3416973/e=
nvironment
    2023-03-16T12:24:12.574740  =

    2023-03-16T12:24:12.676087  / # . /lava-3416973/environment/lava-341697=
3/bin/lava-test-runner /lava-3416973/1
    2023-03-16T12:24:12.676728  =

    2023-03-16T12:24:12.681224  / # /lava-3416973/bin/lava-test-runner /lav=
a-3416973/1
    2023-03-16T12:24:12.745238  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-16T12:24:12.792946  + cd /lava-3416973/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
