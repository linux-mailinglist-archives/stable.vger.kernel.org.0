Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239746ED32D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 19:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjDXRJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 13:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDXRJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 13:09:34 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181245B88
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 10:09:32 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b5465fc13so3861497b3a.3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 10:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682356171; x=1684948171;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=foHLpoBi2gDh4QWPRwwph8H2d1HKqkjROUQlON7AOfg=;
        b=yZ6GRQxzLD+WSlpqx0Ob7zUsHPjzMsP0tGU2ZGnpWjDi8/XkrJn+EN534ptldgk7NE
         vu4MqTvnULtqcF6jLq0a7Z6s/FDUqn0MKMUtOnJEqBoyULjkGH9VafjvbU9w1YCNVUsR
         HduMpIMGUfFsgiFXC3JuS0aSQIweXiun78LaFE5BYuUhbLaB6RCgbTFLGMUX+UFFJUTJ
         Pkj0NxKpL8C2jmV6mBOgKmHLifWAcPR9RlgaeS1p7/VWxz5golYbQNS5zVAk+nqGtaJF
         SSS/sqEOdAhInpO3PzI1iHU8dG7Eqm47Xd6PGMrhd2Dibw3zDvJ1QcUd0ss3kSh+TLg8
         h23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682356171; x=1684948171;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=foHLpoBi2gDh4QWPRwwph8H2d1HKqkjROUQlON7AOfg=;
        b=WplLHJuh6On55TyM43Uxztud4xWpcavtGWo7U4KXIk+fo0f0LIqvfANtzs6P0loRxw
         dTPuZohnu9/7z8Fv+ZmdqUWoOBh9cgkRf5miPuqwWeXvVkhPYdiXcDIImANmp3TvYHnV
         LMrHwhHYX2aC9dQmQWXAKx9Y+yN2diA5jx4jGbPckXtCgtBn0o+q+oCIkmGVAYtVif1+
         LvPAN+k2IneIGp+MOJzsbq0kmXq1G0r2YnOxgUqQAzuN3jRAN3/t+jh8RC0lmvVSj5eE
         mkJ0pjJphZ4GwQYFTy54uvzi23Xf2PM8gnvH6GWmDu/OI8F4RDmLxcrSp23TvhzSsz7t
         MNGA==
X-Gm-Message-State: AAQBX9dtQGVKKsN6Ljq7NA1Ueipo+CxOTs8NuKtNW25Ww7AMfmlGAyMY
        P7RU2JksnqtEepYY7UJ89+v0jC2xTc4EVJS/t8uS8A==
X-Google-Smtp-Source: AKy350aJrqDQGx27WdOmWjWkJxX6aShdk0XydBA3uk7yLx7tLT+xiW9emItI/bCh+vZ6yi/iRqUjBA==
X-Received: by 2002:a17:902:bb8c:b0:1a9:58d7:356f with SMTP id m12-20020a170902bb8c00b001a958d7356fmr9191096pls.9.1682356170983;
        Mon, 24 Apr 2023 10:09:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bj5-20020a170902850500b0019719f752c5sm6773370plb.59.2023.04.24.10.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 10:09:30 -0700 (PDT)
Message-ID: <6446b7ca.170a0220.5d763.d60a@mx.google.com>
Date:   Mon, 24 Apr 2023 10:09:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-343-gd8e1df6990366
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 136 runs,
 10 regressions (v5.15.105-343-gd8e1df6990366)
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

stable-rc/queue/5.15 baseline: 136 runs, 10 regressions (v5.15.105-343-gd8e=
1df6990366)

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

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

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
nel/v5.15.105-343-gd8e1df6990366/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-343-gd8e1df6990366
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8e1df6990366745bc81f276b0f9578abb7d4b09 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644681715293f892a82e860e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644681715293f892a82e8613
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T13:17:17.193295  <8>[   10.671702] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10103510_1.4.2.3.1>

    2023-04-24T13:17:17.196241  + set +x

    2023-04-24T13:17:17.300808  #

    2023-04-24T13:17:17.301911  =


    2023-04-24T13:17:17.403810  / # #export SHELL=3D/bin/sh

    2023-04-24T13:17:17.404408  =


    2023-04-24T13:17:17.505688  / # export SHELL=3D/bin/sh. /lava-10103510/=
environment

    2023-04-24T13:17:17.506358  =


    2023-04-24T13:17:17.607723  / # . /lava-10103510/environment/lava-10103=
510/bin/lava-test-runner /lava-10103510/1

    2023-04-24T13:17:17.608905  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446816d248f21d7472e85f9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446816e248f21d7472e85fe
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T13:17:23.522441  + set +x<8>[   11.330752] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10103493_1.4.2.3.1>

    2023-04-24T13:17:23.522877  =


    2023-04-24T13:17:23.630824  / # #

    2023-04-24T13:17:23.732844  export SHELL=3D/bin/sh

    2023-04-24T13:17:23.733794  #

    2023-04-24T13:17:23.835128  / # export SHELL=3D/bin/sh. /lava-10103493/=
environment

    2023-04-24T13:17:23.835554  =


    2023-04-24T13:17:23.936423  / # . /lava-10103493/environment/lava-10103=
493/bin/lava-test-runner /lava-10103493/1

    2023-04-24T13:17:23.936806  =


    2023-04-24T13:17:23.941744  / # /lava-10103493/bin/lava-test-runner /la=
va-10103493/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446816ca7acc8ed072e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446816ca7acc8ed072e85fc
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T13:17:19.782654  <8>[    7.887916] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10103462_1.4.2.3.1>

    2023-04-24T13:17:19.786074  + set +x

    2023-04-24T13:17:19.888812  =


    2023-04-24T13:17:19.990639  / # #export SHELL=3D/bin/sh

    2023-04-24T13:17:19.991399  =


    2023-04-24T13:17:20.092610  / # export SHELL=3D/bin/sh. /lava-10103462/=
environment

    2023-04-24T13:17:20.092776  =


    2023-04-24T13:17:20.193272  / # . /lava-10103462/environment/lava-10103=
462/bin/lava-test-runner /lava-10103462/1

    2023-04-24T13:17:20.193602  =


    2023-04-24T13:17:20.198455  / # /lava-10103462/bin/lava-test-runner /la=
va-10103462/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6446840ca5b24827122e863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6446840ca5b24827122e8=
63d
        failing since 80 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644687405f422540512e85f4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644687405f422540512e85f9
        failing since 97 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-24T13:41:58.311530  + set +x<8>[    9.923967] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3526979_1.5.2.4.1>
    2023-04-24T13:41:58.312089  =

    2023-04-24T13:41:58.424677  / # #
    2023-04-24T13:41:58.526503  export SHELL=3D/bin/sh
    2023-04-24T13:41:58.527483  #
    2023-04-24T13:41:58.528001  / # export SHELL=3D/bin/sh<3>[   10.112918]=
 Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-24T13:41:58.629856  . /lava-3526979/environment
    2023-04-24T13:41:58.630227  =

    2023-04-24T13:41:58.731425  / # . /lava-3526979/environment/lava-352697=
9/bin/lava-test-runner /lava-3526979/1
    2023-04-24T13:41:58.732020   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644681675293f892a82e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644681675293f892a82e8606
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T13:17:10.167284  + <8>[   10.700308] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10103496_1.4.2.3.1>

    2023-04-24T13:17:10.167369  set +x

    2023-04-24T13:17:10.268499  #

    2023-04-24T13:17:10.369500  / # #export SHELL=3D/bin/sh

    2023-04-24T13:17:10.369740  =


    2023-04-24T13:17:10.470235  / # export SHELL=3D/bin/sh. /lava-10103496/=
environment

    2023-04-24T13:17:10.470461  =


    2023-04-24T13:17:10.571006  / # . /lava-10103496/environment/lava-10103=
496/bin/lava-test-runner /lava-10103496/1

    2023-04-24T13:17:10.571288  =


    2023-04-24T13:17:10.575817  / # /lava-10103496/bin/lava-test-runner /la=
va-10103496/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446816ebc28c859842e85fe

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446816ebc28c859842e8603
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T13:17:12.609275  + set +x

    2023-04-24T13:17:12.616043  <8>[   10.699599] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10103499_1.4.2.3.1>

    2023-04-24T13:17:12.718552  =


    2023-04-24T13:17:12.819182  / # #export SHELL=3D/bin/sh

    2023-04-24T13:17:12.819398  =


    2023-04-24T13:17:12.919937  / # export SHELL=3D/bin/sh. /lava-10103499/=
environment

    2023-04-24T13:17:12.920148  =


    2023-04-24T13:17:13.020695  / # . /lava-10103499/environment/lava-10103=
499/bin/lava-test-runner /lava-10103499/1

    2023-04-24T13:17:13.021034  =


    2023-04-24T13:17:13.026041  / # /lava-10103499/bin/lava-test-runner /la=
va-10103499/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64468168fbda812e662e85f5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64468168fbda812e662e85fa
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T13:17:19.880697  + <8>[   10.890525] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10103450_1.4.2.3.1>

    2023-04-24T13:17:19.880782  set +x

    2023-04-24T13:17:19.984499  / # #

    2023-04-24T13:17:20.085048  export SHELL=3D/bin/sh

    2023-04-24T13:17:20.085187  #

    2023-04-24T13:17:20.185726  / # export SHELL=3D/bin/sh. /lava-10103450/=
environment

    2023-04-24T13:17:20.185875  =


    2023-04-24T13:17:20.286484  / # . /lava-10103450/environment/lava-10103=
450/bin/lava-test-runner /lava-10103450/1

    2023-04-24T13:17:20.286727  =


    2023-04-24T13:17:20.291497  / # /lava-10103450/bin/lava-test-runner /la=
va-10103450/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644686ce47cf831e2c2e8609

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644686ce47cf831e2c2e860e
        failing since 87 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-24T13:40:04.546480  + set +x
    2023-04-24T13:40:04.546892  [    9.381346] <LAVA_SIGNAL_ENDRUN 0_dmesg =
935846_1.5.2.3.1>
    2023-04-24T13:40:04.653636  / # #
    2023-04-24T13:40:04.755170  export SHELL=3D/bin/sh
    2023-04-24T13:40:04.755593  #
    2023-04-24T13:40:04.856820  / # export SHELL=3D/bin/sh. /lava-935846/en=
vironment
    2023-04-24T13:40:04.857259  =

    2023-04-24T13:40:04.958519  / # . /lava-935846/environment/lava-935846/=
bin/lava-test-runner /lava-935846/1
    2023-04-24T13:40:04.959202  =

    2023-04-24T13:40:04.962039  / # /lava-935846/bin/lava-test-runner /lava=
-935846/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64468162248f21d7472e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-343-gd8e1df6990366/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64468162248f21d7472e85f0
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T13:17:03.540784  + set<8>[   11.698193] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10103507_1.4.2.3.1>

    2023-04-24T13:17:03.540882   +x

    2023-04-24T13:17:03.645305  / # #

    2023-04-24T13:17:03.745938  export SHELL=3D/bin/sh

    2023-04-24T13:17:03.746136  #

    2023-04-24T13:17:03.846635  / # export SHELL=3D/bin/sh. /lava-10103507/=
environment

    2023-04-24T13:17:03.846826  =


    2023-04-24T13:17:03.947330  / # . /lava-10103507/environment/lava-10103=
507/bin/lava-test-runner /lava-10103507/1

    2023-04-24T13:17:03.947701  =


    2023-04-24T13:17:03.952476  / # /lava-10103507/bin/lava-test-runner /la=
va-10103507/1
 =

    ... (12 line(s) more)  =

 =20
