Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862EF6BEA76
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 14:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjCQNtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 09:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjCQNtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 09:49:21 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF5318A9D
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 06:49:19 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id iw3so5343263plb.6
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 06:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679060958;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nER8IgySblKFhefPfJszDj9HOFHOFk2jTDDWms2qaVc=;
        b=1SxnqbFXOSFHu6verzzBMpE7/BFkhL2DYpvMIGBNIaIvBV817ictPx/GLyw0s7oWCr
         3Z6dT8yBv5mhfZZNGQhQZxEVhUvXioWHQQTT6EfmwKsw41hf7Hq+nknPLVtMCkuUbUJY
         hRfyT/t6LnWu3dpEwys4gICeuzmf2k/GCCaSGhTKzGGllBXb3alzzvyKvIFniFtU7cCu
         RotqSfkyGQ/x3FmMFNlOO0p5M4FLplCsc9p42eDKyLmMHZa0HcdwcduGfcbqQyv0Vo4f
         kkrO8LhHWqry5JZAbfPLyqHNazMOI6oJ9/n0ziczx5FWu5M8SiqhhFbmzMYnkICKJBwG
         vQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679060958;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nER8IgySblKFhefPfJszDj9HOFHOFk2jTDDWms2qaVc=;
        b=uzfxyCf/Xwsy/SPWjSAQDezQsE6ikjg/3jLI6QmOSWHZYt91rLyskJctFJJ5PHO/1r
         GPRBbAueEAFh0q7zLtVGgvg2h3ySk5yAEm8cA7tnfPpZJs/eu/Fuyc+phivdlraPEjZX
         ddkIJmN34l/AcCdwXNaztL6m/2Nfh8mZ7NSH5XA/H6Ot3aBHr6Y2tAJUErUSs1qGQtWT
         OTIZ5HZxIll+VJeFMyFNjLN/gbRv4asOuUvyrj6fyOM2QuTqDKroEMkWLY1gc3XM6D++
         RhNf8GgYBcSDUfQK9bLuH8nd8HjgAMKBfsJu8heidQR2kMWAkAEi1KBlpqkC/rT0ykKe
         EajA==
X-Gm-Message-State: AO0yUKXtWjA19bczhN9pDKXbu5hw6BQWceFn6IBd6zsHfKJa1DlzGqcy
        SRaQdWtBCJ9dbc484pZrm8nagYlUcIMM4Fig67JNGA==
X-Google-Smtp-Source: AK7set+FM8Nw2jkgpZEolm6GoRHUtw7Yabnhn8eFURH8uuVP34sELWCtUeH7lzPTUNTKmdSv5ndNww==
X-Received: by 2002:a17:903:187:b0:19a:f02c:a05b with SMTP id z7-20020a170903018700b0019af02ca05bmr8888236plg.3.1679060958376;
        Fri, 17 Mar 2023 06:49:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s4-20020a656904000000b004fab4455748sm1520297pgq.75.2023.03.17.06.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 06:49:18 -0700 (PDT)
Message-ID: <64146fde.650a0220.c1d4f.2ad4@mx.google.com>
Date:   Fri, 17 Mar 2023 06:49:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.174-90-g01282b3a88d2d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 114 runs,
 9 regressions (v5.10.174-90-g01282b3a88d2d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 114 runs, 9 regressions (v5.10.174-90-g01282=
b3a88d2d)

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
nel/v5.10.174-90-g01282b3a88d2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.174-90-g01282b3a88d2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01282b3a88d2da3c3e3346e073457bf88932d486 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64143a4c18f1237b9b8c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64143a4c18f1237b9b8c8=
636
        failing since 2 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64143ac2d0d21f98d38c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64143ac2d0d21f98d38c8=
636
        failing since 2 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64143a49676bc213d38c866f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64143a49676bc213d38c8=
670
        failing since 2 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/641437c458515323128c8630

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641437c458515323128c8669
        failing since 31 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-17T09:49:33.650843  <8>[   20.657422] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 177060_1.5.2.4.1>
    2023-03-17T09:49:33.793297  / # #
    2023-03-17T09:49:33.906740  export SHELL=3D/bin/sh
    2023-03-17T09:49:33.910814  #
    2023-03-17T09:49:34.018130  / # export SHELL=3D/bin/sh. /lava-177060/en=
vironment
    2023-03-17T09:49:34.022246  =

    2023-03-17T09:49:34.129623  / # . /lava-177060/environment/lava-177060/=
bin/lava-test-runner /lava-177060/1
    2023-03-17T09:49:34.136654  =

    2023-03-17T09:49:34.139697  / # /lava-177060/bin/lava-test-runner /lava=
-177060/1
    2023-03-17T09:49:34.239736  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641439d569128c0c888c8630

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641439d569128c0c888c8639
        failing since 49 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-17T09:58:32.540471  <8>[   11.056943] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3419631_1.5.2.4.1>
    2023-03-17T09:58:32.648082  / # #
    2023-03-17T09:58:32.749619  export SHELL=3D/bin/sh
    2023-03-17T09:58:32.750376  #
    2023-03-17T09:58:32.852071  / # export SHELL=3D/bin/sh. /lava-3419631/e=
nvironment
    2023-03-17T09:58:32.852466  =

    2023-03-17T09:58:32.852651  / # <3>[   11.291236] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-03-17T09:58:32.953771  . /lava-3419631/environment/lava-3419631/bi=
n/lava-test-runner /lava-3419631/1
    2023-03-17T09:58:32.954537  =

    2023-03-17T09:58:32.959260  / # /lava-3419631/bin/lava-test-runner /lav=
a-3419631/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64143a5d2b6449ecf08c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64143a5d2b6449ecf08c8=
634
        failing since 2 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64144423fa46e8f3fb8c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64144423fa46e8f3fb8c8=
63e
        failing since 2 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64143e0ae7f2e244b98c86ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64143e0ae7f2e244b98c8=
6bb
        failing since 2 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641439330b4fd6a9f88c864a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.174=
-90-g01282b3a88d2d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641439330b4fd6a9f88c8653
        failing since 43 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-17T09:55:41.635158  / # #
    2023-03-17T09:55:41.737151  export SHELL=3D/bin/sh
    2023-03-17T09:55:41.737553  #
    2023-03-17T09:55:41.838886  / # export SHELL=3D/bin/sh. /lava-3419628/e=
nvironment
    2023-03-17T09:55:41.839327  =

    2023-03-17T09:55:41.940535  / # . /lava-3419628/environment/lava-341962=
8/bin/lava-test-runner /lava-3419628/1
    2023-03-17T09:55:41.941234  =

    2023-03-17T09:55:41.946537  / # /lava-3419628/bin/lava-test-runner /lav=
a-3419628/1
    2023-03-17T09:55:42.010647  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-17T09:55:42.050664  + cd /lava-3419628/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
