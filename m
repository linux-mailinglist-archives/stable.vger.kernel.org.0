Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8C46EF7C9
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 17:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241017AbjDZPeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 11:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241212AbjDZPeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 11:34:11 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C26D3C23
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 08:34:08 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a69f686345so57342035ad.2
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 08:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682523247; x=1685115247;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4XrZDIlW6BnIpxppEjJ3Bq8ux+rza4fDOfxSfOUlbOY=;
        b=SFTm4LozOiTYnq6b0VdUpcpQpvWPUx3G082Y5AtdZP9eU+OouyuiJVIZfT8JcOvimk
         lLvDv62vUJ9tUgGyeo9SfjlplEYTedww3n9FpS+vZ6lxT0z27wp1Awmnb27Hdc3H6Nzk
         1JG/EP1CZUVC4wjx9h33zpJ3wrraTQki9ev/VEGfDMjHcm1sBdMl29fa9jBiCFCGcdBk
         v90rdwqVfaeQr0fDFQnhmNaoCxQCqYo4lLxUOLY1gGOr6jq1CcB+5PvCMLkWaiJdBGrR
         PDw8CS84qRg0+doTl0B/7AfGIwncy5/4yLYuzvu4L0e3t4VnAnGqlaLW90dhCe5IMk/t
         MtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682523247; x=1685115247;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4XrZDIlW6BnIpxppEjJ3Bq8ux+rza4fDOfxSfOUlbOY=;
        b=EExE8OThM5sKIpznHE3jRJDzxbEuw7eBJyWsskp4UnBggDgSrbZqkD6huYDbNHyrLo
         s8eBQygGcmW2px3Poqcz4uY+Hjf08EHMr59Cqy0KUzCz9SKjopbcvSsgyl4a8z5pLCcu
         1JQxMXSdbDCqT3I8j99Cr3I/NpO+wMHMkudYsL17i98YH/3jrPJgyurmhMzVamKrXXMr
         YbJq2oi2q4TJVNdfJ1Sl55J0lIr9RMLfjYuW3BTXtNhd3W4MiCm/IRwS1mxUHdW/SeDr
         PxuvS1Axvq7qFsFmSIQW8bZYxORFXsYgCLpsS7amMuP12ifACmDpFZseWFCB3dJvboos
         Ttzg==
X-Gm-Message-State: AAQBX9f5DpVVv0HbJPtl6a1dX4yrSEg/R/rfe71AVgEielA850S2+iex
        OtOf4ql4wLMqlu5R9qI1TYMt6tzGdTxgjMRccGizqw==
X-Google-Smtp-Source: AKy350YlTkjVZWNcCQ7+YZ0dHTNcJHuFVWHi16sr+qHSc0zFJtcwyfI/e/VEbiohuMntnv1PzGI+aA==
X-Received: by 2002:a17:902:e548:b0:19c:a9b8:4349 with SMTP id n8-20020a170902e54800b0019ca9b84349mr26948355plf.32.1682523247215;
        Wed, 26 Apr 2023 08:34:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902820100b0019ef86c2574sm10069654pln.270.2023.04.26.08.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 08:34:06 -0700 (PDT)
Message-ID: <6449446e.170a0220.3d240.4e14@mx.google.com>
Date:   Wed, 26 Apr 2023 08:34:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-346-g97ffc51249f3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 83 runs,
 8 regressions (v5.15.105-346-g97ffc51249f3)
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

stable-rc/queue/5.15 baseline: 83 runs, 8 regressions (v5.15.105-346-g97ffc=
51249f3)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-346-g97ffc51249f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-346-g97ffc51249f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      97ffc51249f3758dba083bb345fdc91397f456de =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64490d68e3b36943e02e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64490d68e3b36943e02e85eb
        failing since 29 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-26T11:39:03.639868  <8>[   10.833001] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10129622_1.4.2.3.1>

    2023-04-26T11:39:03.643577  + set +x

    2023-04-26T11:39:03.747254  / # #

    2023-04-26T11:39:03.847889  export SHELL=3D/bin/sh

    2023-04-26T11:39:03.848088  #

    2023-04-26T11:39:03.948588  / # export SHELL=3D/bin/sh. /lava-10129622/=
environment

    2023-04-26T11:39:03.948775  =


    2023-04-26T11:39:04.049322  / # . /lava-10129622/environment/lava-10129=
622/bin/lava-test-runner /lava-10129622/1

    2023-04-26T11:39:04.049607  =


    2023-04-26T11:39:04.054871  / # /lava-10129622/bin/lava-test-runner /la=
va-10129622/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64490df5e1165762a92e8600

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64490df5e1165762a92e8605
        failing since 29 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-26T11:41:18.165675  + set +x<8>[   10.939244] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10129682_1.4.2.3.1>

    2023-04-26T11:41:18.166114  =


    2023-04-26T11:41:18.273256  / # #

    2023-04-26T11:41:18.375468  export SHELL=3D/bin/sh

    2023-04-26T11:41:18.376292  #

    2023-04-26T11:41:18.477850  / # export SHELL=3D/bin/sh. /lava-10129682/=
environment

    2023-04-26T11:41:18.478581  =


    2023-04-26T11:41:18.579946  / # . /lava-10129682/environment/lava-10129=
682/bin/lava-test-runner /lava-10129682/1

    2023-04-26T11:41:18.581072  =


    2023-04-26T11:41:18.586002  / # /lava-10129682/bin/lava-test-runner /la=
va-10129682/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64490d67d4a3d9a2b02e861a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64490d67d4a3d9a2b02e861f
        failing since 29 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-26T11:39:02.343903  <8>[   10.745769] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10129646_1.4.2.3.1>

    2023-04-26T11:39:02.347249  + set +x

    2023-04-26T11:39:02.452668  =


    2023-04-26T11:39:02.554410  / # #export SHELL=3D/bin/sh

    2023-04-26T11:39:02.555466  =


    2023-04-26T11:39:02.657096  / # export SHELL=3D/bin/sh. /lava-10129646/=
environment

    2023-04-26T11:39:02.657333  =


    2023-04-26T11:39:02.757847  / # . /lava-10129646/environment/lava-10129=
646/bin/lava-test-runner /lava-10129646/1

    2023-04-26T11:39:02.758225  =


    2023-04-26T11:39:02.763213  / # /lava-10129646/bin/lava-test-runner /la=
va-10129646/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64490d55d5110e04962e860a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64490d55d5110e04962e860f
        failing since 29 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-26T11:38:50.455519  + <8>[   11.046420] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10129619_1.4.2.3.1>

    2023-04-26T11:38:50.455600  set +x

    2023-04-26T11:38:50.556786  #

    2023-04-26T11:38:50.557042  =


    2023-04-26T11:38:50.657535  / # #export SHELL=3D/bin/sh

    2023-04-26T11:38:50.657718  =


    2023-04-26T11:38:50.758183  / # export SHELL=3D/bin/sh. /lava-10129619/=
environment

    2023-04-26T11:38:50.758363  =


    2023-04-26T11:38:50.858919  / # . /lava-10129619/environment/lava-10129=
619/bin/lava-test-runner /lava-10129619/1

    2023-04-26T11:38:50.859186  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64490df4cc0470e5ce2e8622

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64490df4cc0470e5ce2e8627
        failing since 29 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-26T11:41:19.643062  <8>[   10.095797] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10129618_1.4.2.3.1>

    2023-04-26T11:41:19.646162  + set +x

    2023-04-26T11:41:19.747349  #

    2023-04-26T11:41:19.747596  =


    2023-04-26T11:41:19.848125  / # #export SHELL=3D/bin/sh

    2023-04-26T11:41:19.848312  =


    2023-04-26T11:41:19.948800  / # export SHELL=3D/bin/sh. /lava-10129618/=
environment

    2023-04-26T11:41:19.948994  =


    2023-04-26T11:41:20.049475  / # . /lava-10129618/environment/lava-10129=
618/bin/lava-test-runner /lava-10129618/1

    2023-04-26T11:41:20.049813  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64490d614520406c0c2e861c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64490d614520406c0c2e8621
        failing since 29 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-26T11:38:53.797755  + <8>[   11.495475] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10129688_1.4.2.3.1>

    2023-04-26T11:38:53.798187  set +x

    2023-04-26T11:38:53.905494  / # #

    2023-04-26T11:38:54.008164  export SHELL=3D/bin/sh

    2023-04-26T11:38:54.008975  #

    2023-04-26T11:38:54.110626  / # export SHELL=3D/bin/sh. /lava-10129688/=
environment

    2023-04-26T11:38:54.111536  =


    2023-04-26T11:38:54.213042  / # . /lava-10129688/environment/lava-10129=
688/bin/lava-test-runner /lava-10129688/1

    2023-04-26T11:38:54.214377  =


    2023-04-26T11:38:54.219150  / # /lava-10129688/bin/lava-test-runner /la=
va-10129688/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64491129e0984614e02e871c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64491129e0984614e02e8721
        failing since 89 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-26T11:55:05.525386  + set +x
    2023-04-26T11:55:05.525596  [    9.401803] <LAVA_SIGNAL_ENDRUN 0_dmesg =
938265_1.5.2.3.1>
    2023-04-26T11:55:05.632526  / # #
    2023-04-26T11:55:05.734197  export SHELL=3D/bin/sh
    2023-04-26T11:55:05.734682  #
    2023-04-26T11:55:05.836194  / # export SHELL=3D/bin/sh. /lava-938265/en=
vironment
    2023-04-26T11:55:05.836657  =

    2023-04-26T11:55:05.937995  / # . /lava-938265/environment/lava-938265/=
bin/lava-test-runner /lava-938265/1
    2023-04-26T11:55:05.938631  =

    2023-04-26T11:55:05.940787  / # /lava-938265/bin/lava-test-runner /lava=
-938265/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64490dcd80d11c1b6e2e862e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-g97ffc51249f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64490dcd80d11c1b6e2e8633
        failing since 29 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-26T11:40:42.070116  + set<8>[   11.771823] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10129689_1.4.2.3.1>

    2023-04-26T11:40:42.070201   +x

    2023-04-26T11:40:42.174540  / # #

    2023-04-26T11:40:42.275172  export SHELL=3D/bin/sh

    2023-04-26T11:40:42.275388  #

    2023-04-26T11:40:42.375900  / # export SHELL=3D/bin/sh. /lava-10129689/=
environment

    2023-04-26T11:40:42.376134  =


    2023-04-26T11:40:42.476728  / # . /lava-10129689/environment/lava-10129=
689/bin/lava-test-runner /lava-10129689/1

    2023-04-26T11:40:42.477029  =


    2023-04-26T11:40:42.481539  / # /lava-10129689/bin/lava-test-runner /la=
va-10129689/1
 =

    ... (12 line(s) more)  =

 =20
