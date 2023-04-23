Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44476EC0D9
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 17:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDWPnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 11:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDWPnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 11:43:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EA010E5
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 08:43:29 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b8b19901fso4763558b3a.3
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 08:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682264609; x=1684856609;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ek8rXGyIxbW/Blkq1PoP7jcY4/DkUd9c+0XMyJKuFw=;
        b=IRN9YmAyB+qp9kLylgxQvxZeLsFDoPQ0/NhJkSFA4vMCqLHaF+RAceYI+PerppxfIJ
         WmM6D+GDEHYrkLKhiDBJlN0trG4jpuay8U/Wyk8xjuiBmeSHcwu1WICo6hnIRz/sHDx+
         97fQ22TuSwePBbsxmq92o1a3inxOkaHCb0yqFXXNZLRYqJpBz9k83rEA7JWMG0CYFtC+
         qySI9I0n4I6lEf4N0F/1z6YVpjiz0Bi26XQiwxZbyK5nv/rAp/i33zJvIAIJV7oDgxgd
         8zSnuPROTB1zj2l3WbBkelq0RpBLyzDQszOMxUfKZJFzieruItHucpIgeN6ZNoiRvota
         KszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682264609; x=1684856609;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Ek8rXGyIxbW/Blkq1PoP7jcY4/DkUd9c+0XMyJKuFw=;
        b=JAhTPJsYvTfysVGxUp9QQ0HTyVWc96HYIJGFE4B9blQNNhlKyNVB5kiaKYzmB7MSMF
         OKyGZoGSwN3D51f8QdvDhX751E4FK5NLVk54zTP8tMUt9KKHv+6v7WRjGWfsE38vD+4Y
         XQMGLF82kB8jT5PWKOw6gLDgwwh4Xk0QAXRAD7Kvxgt8V31doEiMWzA8Rfs6EC/J04WC
         w5oJT6Gcrn8HRJ6+T4EplmWh8plefQNQgP98oM/p5d4A1ng/1YU118ZF/ucV/WoyKbqy
         AqBJR55ddqcDdvmg/DJvXB0ITqzDbXZRMhQ4BKqAxhOyMq6+smycaMarouPtcVS0BArw
         CTGw==
X-Gm-Message-State: AAQBX9eFMlG5nWs+Pex2cQoGaWEtmYkPj1v9UR5sasyfTtlsodETe9xT
        +jY/URIwp9+1OlER+bgOErdlzjg3HXTfvpS/6n4Qfg==
X-Google-Smtp-Source: AKy350ZeD+UX9KCuJ5vANLnk2kRNGTSliw464q3IKvzfoqf0umI8x1EXVYyF5NkQ44LHJKihrnIOJA==
X-Received: by 2002:a05:6a00:1a13:b0:639:a518:3842 with SMTP id g19-20020a056a001a1300b00639a5183842mr15262753pfv.7.1682264608716;
        Sun, 23 Apr 2023 08:43:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a22-20020a056a000c9600b00628e9871c24sm5854753pfv.183.2023.04.23.08.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 08:43:28 -0700 (PDT)
Message-ID: <64455220.050a0220.9e71e.b148@mx.google.com>
Date:   Sun, 23 Apr 2023 08:43:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-326-g7c8f5261a6fcf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 136 runs,
 10 regressions (v5.15.105-326-g7c8f5261a6fcf)
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

stable-rc/queue/5.15 baseline: 136 runs, 10 regressions (v5.15.105-326-g7c8=
f5261a6fcf)

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
nel/v5.15.105-326-g7c8f5261a6fcf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-326-g7c8f5261a6fcf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7c8f5261a6fcf4bce1c8c54d532d1d4a0c809908 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64451f206ffc5620ff2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64451f206ffc5620ff2e85eb
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T12:05:36.083023  + set +x

    2023-04-23T12:05:36.088980  <8>[   12.619764] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10091751_1.4.2.3.1>

    2023-04-23T12:05:36.193543  / # #

    2023-04-23T12:05:36.294557  export SHELL=3D/bin/sh

    2023-04-23T12:05:36.294759  #

    2023-04-23T12:05:36.395670  / # export SHELL=3D/bin/sh. /lava-10091751/=
environment

    2023-04-23T12:05:36.395872  =


    2023-04-23T12:05:36.496867  / # . /lava-10091751/environment/lava-10091=
751/bin/lava-test-runner /lava-10091751/1

    2023-04-23T12:05:36.497171  =


    2023-04-23T12:05:36.502968  / # /lava-10091751/bin/lava-test-runner /la=
va-10091751/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64451f28a5793583472e8606

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64451f28a5793583472e860b
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T12:05:36.886039  + <8>[   11.742733] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10091764_1.4.2.3.1>

    2023-04-23T12:05:36.886122  set +x

    2023-04-23T12:05:36.990838  / # #

    2023-04-23T12:05:37.091799  export SHELL=3D/bin/sh

    2023-04-23T12:05:37.091950  #

    2023-04-23T12:05:37.192857  / # export SHELL=3D/bin/sh. /lava-10091764/=
environment

    2023-04-23T12:05:37.193018  =


    2023-04-23T12:05:37.293973  / # . /lava-10091764/environment/lava-10091=
764/bin/lava-test-runner /lava-10091764/1

    2023-04-23T12:05:37.294414  =


    2023-04-23T12:05:37.298818  / # /lava-10091764/bin/lava-test-runner /la=
va-10091764/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64451f26b8a084b4eb2e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64451f26b8a084b4eb2e860d
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T12:05:45.311824  <8>[   10.681261] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10091757_1.4.2.3.1>

    2023-04-23T12:05:45.314807  + set +x

    2023-04-23T12:05:45.416915  =


    2023-04-23T12:05:45.517779  / # #export SHELL=3D/bin/sh

    2023-04-23T12:05:45.518020  =


    2023-04-23T12:05:45.618916  / # export SHELL=3D/bin/sh. /lava-10091757/=
environment

    2023-04-23T12:05:45.619136  =


    2023-04-23T12:05:45.720051  / # . /lava-10091757/environment/lava-10091=
757/bin/lava-test-runner /lava-10091757/1

    2023-04-23T12:05:45.720344  =


    2023-04-23T12:05:45.725099  / # /lava-10091757/bin/lava-test-runner /la=
va-10091757/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6445224306322b3e6c2e8607

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6445224306322b3e6c2e8=
608
        failing since 79 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6445214f59c3e1edb92e860a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445214f59c3e1edb92e860f
        failing since 96 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-23T12:15:00.986489  <8>[    9.930187] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3523718_1.5.2.4.1>
    2023-04-23T12:15:01.097755  / # #
    2023-04-23T12:15:01.201232  export SHELL=3D/bin/sh
    2023-04-23T12:15:01.202172  #
    2023-04-23T12:15:01.304358  / # export SHELL=3D/bin/sh. /lava-3523718/e=
nvironment
    2023-04-23T12:15:01.305440  =

    2023-04-23T12:15:01.407760  / # . /lava-3523718/environment/lava-352371=
8/bin/lava-test-runner /lava-3523718/1
    2023-04-23T12:15:01.409719  =

    2023-04-23T12:15:01.413658  / # /lava-3523718/bin/lava-test-runner /lav=
a-3523718/1
    2023-04-23T12:15:01.507181  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64451f13272ed3f56c2e8606

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64451f13272ed3f56c2e860b
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T12:05:27.502462  + set +x

    2023-04-23T12:05:27.509123  <8>[   10.852123] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10091748_1.4.2.3.1>

    2023-04-23T12:05:27.613467  / # #

    2023-04-23T12:05:27.714667  export SHELL=3D/bin/sh

    2023-04-23T12:05:27.714883  #

    2023-04-23T12:05:27.815790  / # export SHELL=3D/bin/sh. /lava-10091748/=
environment

    2023-04-23T12:05:27.815980  =


    2023-04-23T12:05:27.916966  / # . /lava-10091748/environment/lava-10091=
748/bin/lava-test-runner /lava-10091748/1

    2023-04-23T12:05:27.917286  =


    2023-04-23T12:05:27.921452  / # /lava-10091748/bin/lava-test-runner /la=
va-10091748/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64451f11126d0ef7232e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64451f11126d0ef7232e85eb
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T12:05:22.391164  + set +x

    2023-04-23T12:05:22.397451  <8>[   10.830555] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10091731_1.4.2.3.1>

    2023-04-23T12:05:22.502078  / # #

    2023-04-23T12:05:22.603201  export SHELL=3D/bin/sh

    2023-04-23T12:05:22.603432  #

    2023-04-23T12:05:22.704394  / # export SHELL=3D/bin/sh. /lava-10091731/=
environment

    2023-04-23T12:05:22.704624  =


    2023-04-23T12:05:22.805635  / # . /lava-10091731/environment/lava-10091=
731/bin/lava-test-runner /lava-10091731/1

    2023-04-23T12:05:22.805973  =


    2023-04-23T12:05:22.810978  / # /lava-10091731/bin/lava-test-runner /la=
va-10091731/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64451f27a5793583472e85fb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64451f27a5793583472e8600
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T12:05:35.617504  + set<8>[   11.767098] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10091750_1.4.2.3.1>

    2023-04-23T12:05:35.617589   +x

    2023-04-23T12:05:35.722176  / # #

    2023-04-23T12:05:35.823020  export SHELL=3D/bin/sh

    2023-04-23T12:05:35.823218  #

    2023-04-23T12:05:35.924094  / # export SHELL=3D/bin/sh. /lava-10091750/=
environment

    2023-04-23T12:05:35.924269  =


    2023-04-23T12:05:36.025158  / # . /lava-10091750/environment/lava-10091=
750/bin/lava-test-runner /lava-10091750/1

    2023-04-23T12:05:36.025464  =


    2023-04-23T12:05:36.030180  / # /lava-10091750/bin/lava-test-runner /la=
va-10091750/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64451f68e32bded6972e8600

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64451f68e32bded6972e8605
        failing since 86 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-23T12:06:55.997052  + set +x
    2023-04-23T12:06:55.997234  [    9.345400] <LAVA_SIGNAL_ENDRUN 0_dmesg =
934743_1.5.2.3.1>
    2023-04-23T12:06:56.104808  / # #
    2023-04-23T12:06:56.206377  export SHELL=3D/bin/sh
    2023-04-23T12:06:56.206828  #
    2023-04-23T12:06:56.309142  / # export SHELL=3D/bin/sh. /lava-934743/en=
vironment
    2023-04-23T12:06:56.309590  =

    2023-04-23T12:06:56.410876  / # . /lava-934743/environment/lava-934743/=
bin/lava-test-runner /lava-934743/1
    2023-04-23T12:06:56.411538  =

    2023-04-23T12:06:56.414104  / # /lava-934743/bin/lava-test-runner /lava=
-934743/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64451f0a6fab4d29722e860a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-326-g7c8f5261a6fcf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64451f0a6fab4d29722e860f
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T12:05:11.779896  + set<8>[   11.094873] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10091786_1.4.2.3.1>

    2023-04-23T12:05:11.779995   +x

    2023-04-23T12:05:11.884692  / # #

    2023-04-23T12:05:11.985656  export SHELL=3D/bin/sh

    2023-04-23T12:05:11.985858  #

    2023-04-23T12:05:12.086797  / # export SHELL=3D/bin/sh. /lava-10091786/=
environment

    2023-04-23T12:05:12.087007  =


    2023-04-23T12:05:12.187946  / # . /lava-10091786/environment/lava-10091=
786/bin/lava-test-runner /lava-10091786/1

    2023-04-23T12:05:12.188248  =


    2023-04-23T12:05:12.193027  / # /lava-10091786/bin/lava-test-runner /la=
va-10091786/1
 =

    ... (12 line(s) more)  =

 =20
