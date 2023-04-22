Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF15F6EBC09
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 00:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDVWwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 18:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDVWwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 18:52:15 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA27183
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 15:52:13 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b57c49c4cso2888171b3a.3
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 15:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682203932; x=1684795932;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0XGno+w4am6xlERqZI0bw9y7bDZ8BlhKlvoeMRUjuQg=;
        b=IXnj+toKI07vVl95ypUpVc5C253Tkv53xOVa/XO2R+7i8SmCseQKGwhk07n3c+JYHD
         BMlAz6QH09P28rWdjz97A0h5/QNBpdES2073imHOO2zPBTFup06sPiS6vLCSxYHNCWeP
         WAGcG45gJnI3doExlWNZklgUCfZ4/zzu0EXvd3UkjkUDPcno5xL4x10DDPcFibu8zcS3
         W2XXDS1KJK2te+wxA2/b42dPeGdYW5bAFgVUwc8vuagDUoRgNCNDgl0DEaKk5QGmz1kl
         z8D5bNdmrSxdifuduhbnhbJdW49akolfQo4+oy1swo+y7h50lIJb/UxELCjwy78wYkhD
         l0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682203932; x=1684795932;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0XGno+w4am6xlERqZI0bw9y7bDZ8BlhKlvoeMRUjuQg=;
        b=FMWEJ3SJNvCEI/K4z1zgRpNxMeA3SQ0VFAkjebN1tly3BPutLG4Q24RIN9OUjkYpWv
         YHEw24FCM/RWc2FZZRm2oCf+HRziHfO8MXPWKTQaoZ6jJa1/P8r0acE2rwfhNGKThVAK
         d7PpYWiyNn+mQuLdK6Xrp2by2KWoHTiYHoo5DMZUzKdhqtKajuCFnjJjCPuF95sBAPno
         2b/yJoRWBINjj4bWtc7N1N4UuFW9Kh/1T94ShrNUPeISwQsiljIa01nnHjqLUcWnCwj4
         cxoReGbx602U4ZbK15NN3nEvrgsmMyn42URTLGOZ6OprwDo9g4voN5i/GjNsEMAPcG5v
         03aQ==
X-Gm-Message-State: AAQBX9eXUYPndMdaOuYebDTIREAPNYjOTCoTIyULKNe2iw8bzzn+DNxF
        JHlxK3vXjRpY5r2Rh+uADebL4iP3GIZr9ix8f7lOG9jr
X-Google-Smtp-Source: AKy350bwcePJLMBufweFg6V9JhwWd84zujL3e3TKPsufKdi/WSdTASIa7K/NfEJ1djwv6PAB4u/LGg==
X-Received: by 2002:a05:6a00:22c1:b0:63b:4e99:807d with SMTP id f1-20020a056a0022c100b0063b4e99807dmr12629058pfj.8.1682203932412;
        Sat, 22 Apr 2023 15:52:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d19-20020a056a0024d300b0063b488f3305sm4945922pfv.155.2023.04.22.15.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 15:52:12 -0700 (PDT)
Message-ID: <6444651c.050a0220.57fe0.9b0a@mx.google.com>
Date:   Sat, 22 Apr 2023 15:52:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-556-g2944ac9cf90bf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 98 runs,
 8 regressions (v6.1.22-556-g2944ac9cf90bf)
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

stable-rc/queue/6.1 baseline: 98 runs, 8 regressions (v6.1.22-556-g2944ac9c=
f90bf)

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

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-556-g2944ac9cf90bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-556-g2944ac9cf90bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2944ac9cf90bfb0f0c498e50b0fa9234b3c75a85 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442d44e26dbea5532e8634

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442d44e26dbea5532e8639
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T18:53:38.149676  + set +x

    2023-04-22T18:53:38.156059  <8>[    7.893925] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10086048_1.4.2.3.1>

    2023-04-22T18:53:38.264599  / # #

    2023-04-22T18:53:38.367747  export SHELL=3D/bin/sh

    2023-04-22T18:53:38.368569  #

    2023-04-22T18:53:38.470567  / # export SHELL=3D/bin/sh. /lava-10086048/=
environment

    2023-04-22T18:53:38.471371  =


    2023-04-22T18:53:38.573390  / # . /lava-10086048/environment/lava-10086=
048/bin/lava-test-runner /lava-10086048/1

    2023-04-22T18:53:38.574728  =


    2023-04-22T18:53:38.580549  / # /lava-10086048/bin/lava-test-runner /la=
va-10086048/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442d47b9d44f2b492e8623

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442d47b9d44f2b492e8628
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T18:53:35.810299  + set<8>[   11.182842] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10086076_1.4.2.3.1>

    2023-04-22T18:53:35.810896   +x

    2023-04-22T18:53:35.918944  / # #

    2023-04-22T18:53:36.022466  export SHELL=3D/bin/sh

    2023-04-22T18:53:36.022945  #

    2023-04-22T18:53:36.124471  / # export SHELL=3D/bin/sh. /lava-10086076/=
environment

    2023-04-22T18:53:36.125292  =


    2023-04-22T18:53:36.227266  / # . /lava-10086076/environment/lava-10086=
076/bin/lava-test-runner /lava-10086076/1

    2023-04-22T18:53:36.228503  =


    2023-04-22T18:53:36.233640  / # /lava-10086076/bin/lava-test-runner /la=
va-10086076/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442d45e26dbea5532e8641

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442d45e26dbea5532e8645
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T18:53:41.496098  <8>[   10.206351] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10086079_1.4.2.3.1>

    2023-04-22T18:53:41.499151  + set +x

    2023-04-22T18:53:41.605338  =


    2023-04-22T18:53:41.707554  / # #export SHELL=3D/bin/sh

    2023-04-22T18:53:41.708380  =


    2023-04-22T18:53:41.810473  / # export SHELL=3D/bin/sh. /lava-10086079/=
environment

    2023-04-22T18:53:41.811349  =


    2023-04-22T18:53:41.913443  / # . /lava-10086079/environment/lava-10086=
079/bin/lava-test-runner /lava-10086079/1

    2023-04-22T18:53:41.914690  =


    2023-04-22T18:53:41.920533  / # /lava-10086079/bin/lava-test-runner /la=
va-10086079/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64442ff291f42c2ef52e863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64442ff291f42c2ef52e8=
63b
        failing since 2 days (last pass: v6.1.22-477-g2128d4458cbc, first f=
ail: v6.1.22-474-gecc61872327e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442d2a527c24779f2e860a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442d2a527c24779f2e860f
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T18:53:19.945264  + set +x

    2023-04-22T18:53:19.951625  <8>[    8.099112] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10086073_1.4.2.3.1>

    2023-04-22T18:53:20.056795  / # #

    2023-04-22T18:53:20.157911  export SHELL=3D/bin/sh

    2023-04-22T18:53:20.158092  #

    2023-04-22T18:53:20.259022  / # export SHELL=3D/bin/sh. /lava-10086073/=
environment

    2023-04-22T18:53:20.259207  =


    2023-04-22T18:53:20.359889  / # . /lava-10086073/environment/lava-10086=
073/bin/lava-test-runner /lava-10086073/1

    2023-04-22T18:53:20.360220  =


    2023-04-22T18:53:20.365321  / # /lava-10086073/bin/lava-test-runner /la=
va-10086073/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442d208caac6be472e85f6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442d208caac6be472e85fb
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T18:53:03.161299  <8>[   10.352647] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10086084_1.4.2.3.1>

    2023-04-22T18:53:03.164790  + set +x

    2023-04-22T18:53:03.266426  #

    2023-04-22T18:53:03.367655  / # #export SHELL=3D/bin/sh

    2023-04-22T18:53:03.367818  =


    2023-04-22T18:53:03.468793  / # export SHELL=3D/bin/sh. /lava-10086084/=
environment

    2023-04-22T18:53:03.468973  =


    2023-04-22T18:53:03.569963  / # . /lava-10086084/environment/lava-10086=
084/bin/lava-test-runner /lava-10086084/1

    2023-04-22T18:53:03.570309  =


    2023-04-22T18:53:03.575343  / # /lava-10086084/bin/lava-test-runner /la=
va-10086084/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442d4442f69e19a42e8612

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442d4442f69e19a42e8617
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T18:53:34.387031  + set<8>[   11.010311] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10086060_1.4.2.3.1>

    2023-04-22T18:53:34.387504   +x

    2023-04-22T18:53:34.495961  / # #

    2023-04-22T18:53:34.598775  export SHELL=3D/bin/sh

    2023-04-22T18:53:34.599569  #

    2023-04-22T18:53:34.701464  / # export SHELL=3D/bin/sh. /lava-10086060/=
environment

    2023-04-22T18:53:34.702240  =


    2023-04-22T18:53:34.803910  / # . /lava-10086060/environment/lava-10086=
060/bin/lava-test-runner /lava-10086060/1

    2023-04-22T18:53:34.805109  =


    2023-04-22T18:53:34.810091  / # /lava-10086060/bin/lava-test-runner /la=
va-10086060/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442d4690a90e31672e861c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g2944ac9cf90bf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442d4690a90e31672e8621
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T18:53:39.121480  + set<8>[   10.896151] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10086126_1.4.2.3.1>

    2023-04-22T18:53:39.121590   +x

    2023-04-22T18:53:39.226493  / # #

    2023-04-22T18:53:39.327494  export SHELL=3D/bin/sh

    2023-04-22T18:53:39.327731  #

    2023-04-22T18:53:39.428669  / # export SHELL=3D/bin/sh. /lava-10086126/=
environment

    2023-04-22T18:53:39.428900  =


    2023-04-22T18:53:39.529868  / # . /lava-10086126/environment/lava-10086=
126/bin/lava-test-runner /lava-10086126/1

    2023-04-22T18:53:39.530198  =


    2023-04-22T18:53:39.534526  / # /lava-10086126/bin/lava-test-runner /la=
va-10086126/1
 =

    ... (12 line(s) more)  =

 =20
