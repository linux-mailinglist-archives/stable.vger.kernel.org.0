Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F9C6C0679
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 00:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjCSXFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 19:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCSXFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 19:05:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3383136D2
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 16:05:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso14480380pjb.3
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 16:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679267120;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yohYRbcFRawZ1dLz9igwU0E8jqu7ie4ooFT20m/2TOk=;
        b=OxW/J2zGjlFNwTGKvd+ZJxrTz1LOJn/9eksGAvvh0bqhxdaYSWnuo6vqrF7jTPHMxb
         e+s6FICbf/eXTO0wV0qaY5KTMPfFSafNk2iS42Fb/NagWzwtAGhCqNCxMospky+ydeTm
         fVteTWwcY8lg1i+XHXpZuXiINZo3lV/+6twCJiXUKsbER0SEMfXsclzLZpzLk1TloeXy
         Kcl7BvQ59YP5xPP6n5GZ1PP1cA2saE30hI/+YRAf+wM/kMu+fpCqVGMF1XoE5x1PMIZN
         2qsDsqQKn883MkVN4KZwykWeIf9Df8lXTidSg6BKW0yiYa1ry1dX0MD2HTXw68imnD6q
         sOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679267120;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yohYRbcFRawZ1dLz9igwU0E8jqu7ie4ooFT20m/2TOk=;
        b=woRl95rmjNUB2NnOjEcIeGJm5DtzZ4Bim+5YwUxx74URdYlrpd8qli7xaTbZbzHv9d
         4ecLlpiNXFKqt9zW5rt6RGdy7myLqV4RU+hxG/HqCD/WRy6leci9NjNQs2ufJTQMkVl4
         Gn2/qt17RhQToGHjQAFicBS54nBYaekMprEKxrw+cCaMEfaVPJFT/fDHRGvsZv5L6cOm
         siOqRD8tCACcRseTR61dhGffz8KCtSSZXnlnRAP7bMxWlithwl6mmZCP+3O0dDdRUbeg
         QVw4oQDDVn42c8JmNI5WNKRCmhsMKp6thzmo/b+favFdF5Mxd9itgmKHyrw5X3x9JevF
         n2Uw==
X-Gm-Message-State: AO0yUKVrErAdTA9L7gEIrEUzyFogtKpjBp/+ua2Ov1wtAucrAJHgp5ai
        9agzPQ5v/ejh5GLmQWTsBzu1k07dOyH91tPXMGnD+w==
X-Google-Smtp-Source: AK7set908ERu35SlOtGcHkJiih8024AIA+CiZxFZvOR8D5s4eXQ+piktuyUGRm/45v7jUtSInkzWXQ==
X-Received: by 2002:a05:6a20:8361:b0:d4:9cb2:902f with SMTP id z33-20020a056a20836100b000d49cb2902fmr12004892pzc.59.1679267120143;
        Sun, 19 Mar 2023 16:05:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o15-20020a63e34f000000b00502fd70b0bdsm4925581pgj.52.2023.03.19.16.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 16:05:19 -0700 (PDT)
Message-ID: <6417952f.630a0220.5b3c4.7e34@mx.google.com>
Date:   Sun, 19 Mar 2023 16:05:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.175-39-g974af93cea52e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 164 runs,
 11 regressions (v5.10.175-39-g974af93cea52e)
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

stable-rc/queue/5.10 baseline: 164 runs, 11 regressions (v5.10.175-39-g974a=
f93cea52e)

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

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.175-39-g974af93cea52e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.175-39-g974af93cea52e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      974af93cea52ebfe7d23e2cbaef7e9210a6f2439 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641760ed657cb93a8c8c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641760ed657cb93a8c8c8=
636
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641760ed657cb93a8c8c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641760ed657cb93a8c8c8=
639
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641761047047740fa58c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641761047047740fa58c8=
638
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64175e24a37e7848848c8661

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64175e24a37e7848848c869b
        failing since 33 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-19T19:10:06.792719  <8>[   21.013510] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 187858_1.5.2.4.1>
    2023-03-19T19:10:06.900007  / # #
    2023-03-19T19:10:07.001965  export SHELL=3D/bin/sh
    2023-03-19T19:10:07.002579  #
    2023-03-19T19:10:07.104247  / # export SHELL=3D/bin/sh. /lava-187858/en=
vironment
    2023-03-19T19:10:07.104863  =

    2023-03-19T19:10:07.206621  / # . /lava-187858/environment/lava-187858/=
bin/lava-test-runner /lava-187858/1
    2023-03-19T19:10:07.207339  =

    2023-03-19T19:10:07.212731  / # /lava-187858/bin/lava-test-runner /lava=
-187858/1
    2023-03-19T19:10:07.322067  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641761f30a0aab941b8c8661

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641761f30a0aab941b8c866a
        failing since 52 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-19T19:26:34.137489  <8>[   10.934466] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3425243_1.5.2.4.1>
    2023-03-19T19:26:34.243750  / # #
    2023-03-19T19:26:34.345187  export SHELL=3D/bin/sh
    2023-03-19T19:26:34.345547  #
    2023-03-19T19:26:34.446725  / # export SHELL=3D/bin/sh. /lava-3425243/e=
nvironment
    2023-03-19T19:26:34.447064  =

    2023-03-19T19:26:34.548083  / # . /lava-3425243/environment/lava-342524=
3/bin/lava-test-runner /lava-3425243/1
    2023-03-19T19:26:34.548591  =

    2023-03-19T19:26:34.548723  / # <3>[   11.291387] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-19T19:26:34.553835  /lava-3425243/bin/lava-test-runner /lava-34=
25243/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6417610105201be2698c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417610105201be2698c8=
635
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64176103e43646cf128c864f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64176103e43646cf128c8=
650
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6417622ee85445dd798c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417622ee85445dd798c8=
630
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6417645eee2483cf2e8c867b

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6417645eee2483cf2e8c8685
        failing since 5 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-19T19:36:52.124348  /lava-9689418/1/../bin/lava-test-case

    2023-03-19T19:36:52.135083  <8>[   34.987537] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6417645eee2483cf2e8c8686
        failing since 5 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-19T19:36:51.086754  /lava-9689418/1/../bin/lava-test-case

    2023-03-19T19:36:51.098715  <8>[   33.950643] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641761c1d19dd922e58c8654

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-g974af93cea52e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641761c1d19dd922e58c865d
        failing since 45 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-19T19:25:30.067627  / # #
    2023-03-19T19:25:30.169533  export SHELL=3D/bin/sh
    2023-03-19T19:25:30.170005  #
    2023-03-19T19:25:30.271327  / # export SHELL=3D/bin/sh. /lava-3425242/e=
nvironment
    2023-03-19T19:25:30.271855  =

    2023-03-19T19:25:30.373556  / # . /lava-3425242/environment/lava-342524=
2/bin/lava-test-runner /lava-3425242/1
    2023-03-19T19:25:30.374338  =

    2023-03-19T19:25:30.378883  / # /lava-3425242/bin/lava-test-runner /lav=
a-3425242/1
    2023-03-19T19:25:30.442936  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-19T19:25:30.477723  + cd /lava-3425242/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
