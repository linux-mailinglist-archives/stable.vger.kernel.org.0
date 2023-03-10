Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E7C6B54C4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 23:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjCJWqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 17:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCJWqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 17:46:46 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4DB5274
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:46:40 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so11395176pjh.0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678488400;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4EZVesCIq20tAdumtG/MQNmNsOWKcoBkNxwTH4THM3M=;
        b=6+T/HvHXTKuXFCTrIDWTDlVRh3jWPvjvzaVVimrrM7q8HGMILrlqpJskyKtVE1CFYs
         K+KwEAKKn4sdJqNVhrWFk9ikhzQQq09+duokmqqBRULQhLWBj8hHtT8ul4ss/gx1taoE
         9qDFIg+TemPV03Awsgp4urM71mzXiTTgAMSeXMSBIwhbeB0Ob40vOPKm2H+8wnMEZ4KF
         hERPhQfM+dnN8BUIlAVhZ7I74Jfh1ANKQqgbJ+3id3/KwhiLD1NQBHMUsBk+ByA6H6gB
         0O4OHOFrkB0nGeCfY45ooJCZIPDinwjNEoSxOnLf8rU8ZnCyD57rJCo+osePNrPHvrCS
         elFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678488400;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4EZVesCIq20tAdumtG/MQNmNsOWKcoBkNxwTH4THM3M=;
        b=gtFFie3TL0TG2SPOXMnudwaQW0wsR1syRVk4uZfGQAp+mAj3IyxLMD/qh4bX0PbVqW
         69dhudJugiEmmK8vb5lDTRlzJzhEZlyHUJ96Tl/U6QkKW6xwoPT2Jn/tREkW0FMbqSO0
         vzy6w84ilg7i3iLfm14X7sf19QY3QQrqODBspBkprtiCw2qXbGaK/gslIJB4JZY/t+He
         Ld5NEwRh5Le+tkPPmY3enRalM8uyFp51d+6gZVpNSvD/GsA2OzoibNSCboV7kzrGuXQh
         NNXdrk5rUWRzlxyPChr8BXnUs6tuyJIdY2LRIHdVzQA+D7qAeYbg5Bw0otYm3xpNrGub
         bhfw==
X-Gm-Message-State: AO0yUKV5Bu91ZBTrMPUU1/W4tzvbxqHj6/H4aGVt9CHQtIOQ3JDnWdC6
        8xm2VXKN4g+22MOILWvQCQEa4Z4xJpa6wlfnTkMmSTat
X-Google-Smtp-Source: AK7set/5dfn7cFpYQC7IUXPcFNV08hx8e0e9B/usALecFIhj0+gvcDMHqwgh2ygZkePE0fQMKRpDzA==
X-Received: by 2002:a05:6a21:3288:b0:cb:6dcb:d6e7 with SMTP id yt8-20020a056a21328800b000cb6dcbd6e7mr29784626pzb.52.1678488399511;
        Fri, 10 Mar 2023 14:46:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g21-20020a62e315000000b0058e08796e98sm269528pfh.196.2023.03.10.14.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 14:46:39 -0800 (PST)
Message-ID: <640bb34f.620a0220.b28c7.143d@mx.google.com>
Date:   Fri, 10 Mar 2023 14:46:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.99-137-g7bc88ced9f274
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 174 runs,
 20 regressions (v5.15.99-137-g7bc88ced9f274)
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

stable-rc/linux-5.15.y baseline: 174 runs, 20 regressions (v5.15.99-137-g7b=
c88ced9f274)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3288-veyron-jaq            | arm    | lab-collabora | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.99-137-g7bc88ced9f274/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.99-137-g7bc88ced9f274
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7bc88ced9f274f04919e749a79e4c9c482df4d04 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7fbd6db32c6b018c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-acer-cb317-1h-c3z6-dedede.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-acer-cb317-1h-c3z6-dedede.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7fbd6db32c6b018c8=
641
        failing since 2 days (last pass: v5.15.98, first fail: v5.15.98-568=
-gfa8d909622db) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7fde31b10650fa8c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7fde31b10650fa8c8=
651
        failing since 2 days (last pass: v5.15.98, first fail: v5.15.98-568=
-gfa8d909622db) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7fbb6db32c6b018c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7fbb6db32c6b018c8=
635
        failing since 2 days (last pass: v5.15.98, first fail: v5.15.98-568=
-gfa8d909622db) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7fca6db32c6b018c8662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7fca6db32c6b018c8=
663
        failing since 2 days (last pass: v5.15.98, first fail: v5.15.98-568=
-gfa8d909622db) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640b81117ed85245558c8730

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b81117ed85245558c8=
731
        failing since 302 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640b82ca0ee35b15588c863a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b82ca0ee35b15588c8643
        failing since 52 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-03-10T19:19:29.669007  <8>[   10.119413] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3402971_1.5.2.4.1>
    2023-03-10T19:19:29.779316  / # #
    2023-03-10T19:19:29.882821  export SHELL=3D/bin/sh
    2023-03-10T19:19:29.883830  #
    2023-03-10T19:19:29.985987  / # export SHELL=3D/bin/sh. /lava-3402971/e=
nvironment
    2023-03-10T19:19:29.987048  =

    2023-03-10T19:19:30.089297  / # . /lava-3402971/environment/lava-340297=
1/bin/lava-test-runner /lava-3402971/1
    2023-03-10T19:19:30.091376  =

    2023-03-10T19:19:30.096100  / # /lava-3402971/bin/lava-test-runner /lav=
a-3402971/1
    2023-03-10T19:19:30.180842  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7fbc77c85448e58c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7fbc77c85448e58c8=
649
        failing since 2 days (last pass: v5.15.98, first fail: v5.15.98-568=
-gfa8d909622db) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7fcf31b10650fa8c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7fcf31b10650fa8c8=
63b
        failing since 2 days (last pass: v5.15.98, first fail: v5.15.98-568=
-gfa8d909622db) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7fbd77c85448e58c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7fbd77c85448e58c8=
64f
        failing since 2 days (last pass: v5.15.98, first fail: v5.15.98-568=
-gfa8d909622db) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7fae37b51450bf8c866a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7fae37b51450bf8c8=
66b
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7f8e6d8d96039b8c865f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i=
386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i=
386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7f8e6d8d96039b8c8=
660
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7d0b3a817cb3458c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7d0b3a817cb3458c8=
641
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7fec4e69213ff58c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7fec4e69213ff58c8=
640
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7d5f68353706a68c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7d5f68353706a68c8=
64a
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8044d18c9ba5998c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8044d18c9ba5998c8=
642
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7d0a3a817cb3458c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7d0a3a817cb3458c8=
63b
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7feb4e69213ff58c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7feb4e69213ff58c8=
637
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b7d5e8a6d5ffd158c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b7d5e8a6d5ffd158c8=
643
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b801ade23c77d3f8c8667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b801ade23c77d3f8c8=
668
        failing since 24 days (last pass: v5.15.93, first fail: v5.15.93-68=
-g2bf3e29e9db2) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640b825a4c7f86b2c98c864c

  Results:     65 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-r=
k3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
9-137-g7bc88ced9f274/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-r=
k3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
640b825a4c7f86b2c98c868d
        new failure (last pass: v5.15.98-572-g95417703d86d2)

    2023-03-10T19:17:29.708509  /lava-9541220/1/../bin/lava-test-case

    2023-03-10T19:17:29.735719  <8>[   20.672347] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>
   =

 =20
