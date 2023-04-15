Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54476E3161
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 14:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjDOMmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 08:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDOMms (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 08:42:48 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FF7422F
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 05:42:44 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-514156b4976so1498216a12.3
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 05:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681562563; x=1684154563;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Oh1MaxVr2W/rScf1BStdXx04N9fuGagsGZ5gEx1fCqQ=;
        b=CGU6H3CDQaPWcExfulKM5QJLOHJBfaBH10bJwftAi42DZDOZierr+KeNqMEDoHkbbf
         nhTlPu1GfVg4dzObyAF3QlG3TZrrJeQoQMNRjCaaVtYwshbxduwKDNp/9/cfSWSzlJ9D
         AXkbkqszlfPeSBRJvvZ8Ysg6Z4W4dALGOVM9mLqEWeOYdYwmjsiwhVhittdm14Y2USuY
         1njs5acYvREWpybDyAanGWEqgT66GfLdUxTuLzNmL+VsjQNCBDS0+2J8xN5sET0EDSGN
         bb0P2BayLz4wI/9TGHZqEPHjCLxffZF88ZLg84x6FO5FlWxD40KLGMRnL3VFvw6DNbUn
         CxXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681562563; x=1684154563;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oh1MaxVr2W/rScf1BStdXx04N9fuGagsGZ5gEx1fCqQ=;
        b=CO32z2JxeGc6adBpOT6wedwCXaXzv+/nD6L8UQ7oQ5P2/oIaZC7DpZ9Qv396yJw1CX
         mlXIUre8SzdPJbfNh1CGlUBwl99hrs3ATYjBJGMFFzeCZ+cplPOG16Qe0n1cd7+FFOPP
         dPxV00q5pYZB1x4gXwO5zIlVtJPJqZ4pierSaujsDUVRWV7ZcVtMj2/2CEUb1T/0jZR3
         ll+olAnNyybs45BBsNe9j7j/7bT6ziFo4baaTCWAKh6Z9NPBgpmDV9G7xHpS2ry7ZE4L
         YGSr0z2Zc5GWx3KXeDlxBtv6ADrq5870go6POD6ricr48l3JRJaM6zKC1X20DSLxvo0g
         rA2g==
X-Gm-Message-State: AAQBX9dh2dxY7QFvOgAyaa2v+c8SzExR7KCOMOqMEmAOfbDrn18W2yJu
        +HTga6YZqvwNP8c6vM765dNSSAdpSfxd1srrJM2s6P1/
X-Google-Smtp-Source: AKy350aJb/ZR30MO1d7MQNvwEKHdu84exq8ry/SxBuQkbNdQoOFFzQ9PhgA8cisnIjLxqaEFJ8JbWA==
X-Received: by 2002:a05:6a00:1a4d:b0:63b:1bc7:c703 with SMTP id h13-20020a056a001a4d00b0063b1bc7c703mr11965950pfv.10.1681562563145;
        Sat, 15 Apr 2023 05:42:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c22-20020a62e816000000b0063b8428b0d8sm639353pfi.152.2023.04.15.05.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 05:42:42 -0700 (PDT)
Message-ID: <643a9bc2.620a0220.3adeb.0c16@mx.google.com>
Date:   Sat, 15 Apr 2023 05:42:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-189-g165b92fad56a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 195 runs,
 11 regressions (v5.15.105-189-g165b92fad56a)
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

stable-rc/queue/5.15 baseline: 195 runs, 11 regressions (v5.15.105-189-g165=
b92fad56a)

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

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-189-g165b92fad56a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-189-g165b92fad56a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      165b92fad56a7965c4693d6c1f61877bb4dac632 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643a6728e98b6193152e85ea

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a6728e98b6193152e85ef
        failing since 17 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T08:57:59.510685  <8>[   10.921548] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9990396_1.4.2.3.1>

    2023-04-15T08:57:59.513671  + set +x

    2023-04-15T08:57:59.618464  / # #

    2023-04-15T08:57:59.719558  export SHELL=3D/bin/sh

    2023-04-15T08:57:59.719799  #

    2023-04-15T08:57:59.820815  / # export SHELL=3D/bin/sh. /lava-9990396/e=
nvironment

    2023-04-15T08:57:59.821035  =


    2023-04-15T08:57:59.921997  / # . /lava-9990396/environment/lava-999039=
6/bin/lava-test-runner /lava-9990396/1

    2023-04-15T08:57:59.922331  =


    2023-04-15T08:57:59.927582  / # /lava-9990396/bin/lava-test-runner /lav=
a-9990396/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643a66c41a233257002e85fb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a66c41a233257002e8600
        failing since 17 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T08:56:22.982790  + set<8>[   12.117403] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9990336_1.4.2.3.1>

    2023-04-15T08:56:22.982884   +x

    2023-04-15T08:56:23.087590  / # #

    2023-04-15T08:56:23.188413  export SHELL=3D/bin/sh

    2023-04-15T08:56:23.188605  #

    2023-04-15T08:56:23.289521  / # export SHELL=3D/bin/sh. /lava-9990336/e=
nvironment

    2023-04-15T08:56:23.289712  =


    2023-04-15T08:56:23.390607  / # . /lava-9990336/environment/lava-999033=
6/bin/lava-test-runner /lava-9990336/1

    2023-04-15T08:56:23.390951  =


    2023-04-15T08:56:23.395706  / # /lava-9990336/bin/lava-test-runner /lav=
a-9990336/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643a66c74ef2e1350d2e8611

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a66c74ef2e1350d2e8616
        failing since 17 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T08:56:14.438529  <8>[    9.960793] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9990332_1.4.2.3.1>

    2023-04-15T08:56:14.441663  + set +x

    2023-04-15T08:56:14.546523  / # #

    2023-04-15T08:56:14.647580  export SHELL=3D/bin/sh

    2023-04-15T08:56:14.647738  #

    2023-04-15T08:56:14.748643  / # export SHELL=3D/bin/sh. /lava-9990332/e=
nvironment

    2023-04-15T08:56:14.748807  =


    2023-04-15T08:56:14.849731  / # . /lava-9990332/environment/lava-999033=
2/bin/lava-test-runner /lava-9990332/1

    2023-04-15T08:56:14.849978  =


    2023-04-15T08:56:14.855703  / # /lava-9990332/bin/lava-test-runner /lav=
a-9990332/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643a68ae4c343756052e8604

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643a68ae4c343756052e8=
605
        failing since 70 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643a6af647e8de63022e8639

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a6af647e8de63022e863e
        failing since 88 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-15T09:14:13.196179  <8>[    9.964659] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3498324_1.5.2.4.1>
    2023-04-15T09:14:13.306038  / # #
    2023-04-15T09:14:13.409105  export SHELL=3D/bin/sh
    2023-04-15T09:14:13.410175  #
    2023-04-15T09:14:13.514466  / # export SHELL=3D/bin/sh. /lava-3498324/e=
nvironment
    2023-04-15T09:14:13.515631  =

    2023-04-15T09:14:13.617486  / # . /lava-3498324/environment/lava-349832=
4/bin/lava-test-runner /lava-3498324/1
    2023-04-15T09:14:13.618953  =

    2023-04-15T09:14:13.623800  / # /lava-3498324/bin/lava-test-runner /lav=
a-3498324/1
    2023-04-15T09:14:13.663671  <3>[   10.433408] Bluetooth: hci0: command =
0xfc18 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643a66d4b33058f4c82e8637

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a66d4b33058f4c82e863c
        failing since 17 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T08:56:32.508275  + set +x

    2023-04-15T08:56:32.515100  <8>[   10.315725] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9990385_1.4.2.3.1>

    2023-04-15T08:56:32.620007  / # #

    2023-04-15T08:56:32.721181  export SHELL=3D/bin/sh

    2023-04-15T08:56:32.721427  #

    2023-04-15T08:56:32.822403  / # export SHELL=3D/bin/sh. /lava-9990385/e=
nvironment

    2023-04-15T08:56:32.822681  =


    2023-04-15T08:56:32.923680  / # . /lava-9990385/environment/lava-999038=
5/bin/lava-test-runner /lava-9990385/1

    2023-04-15T08:56:32.924042  =


    2023-04-15T08:56:32.928551  / # /lava-9990385/bin/lava-test-runner /lav=
a-9990385/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643a66bc284d76ccfc2e85fb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a66bc284d76ccfc2e8600
        failing since 17 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T08:56:12.925194  <8>[   10.648796] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9990343_1.4.2.3.1>

    2023-04-15T08:56:12.928755  + set +x

    2023-04-15T08:56:13.030304  /#

    2023-04-15T08:56:13.131473   # #export SHELL=3D/bin/sh

    2023-04-15T08:56:13.131656  =


    2023-04-15T08:56:13.232390  / # export SHELL=3D/bin/sh. /lava-9990343/e=
nvironment

    2023-04-15T08:56:13.232594  =


    2023-04-15T08:56:13.333487  / # . /lava-9990343/environment/lava-999034=
3/bin/lava-test-runner /lava-9990343/1

    2023-04-15T08:56:13.333778  =


    2023-04-15T08:56:13.338902  / # /lava-9990343/bin/lava-test-runner /lav=
a-9990343/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643a66c6b33058f4c82e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a66c6b33058f4c82e8606
        failing since 17 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T08:56:14.357228  + set +x<8>[   11.333764] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9990365_1.4.2.3.1>

    2023-04-15T08:56:14.357649  =


    2023-04-15T08:56:14.465397  / # #

    2023-04-15T08:56:14.567902  export SHELL=3D/bin/sh

    2023-04-15T08:56:14.568552  #

    2023-04-15T08:56:14.670351  / # export SHELL=3D/bin/sh. /lava-9990365/e=
nvironment

    2023-04-15T08:56:14.671023  =


    2023-04-15T08:56:14.772794  / # . /lava-9990365/environment/lava-999036=
5/bin/lava-test-runner /lava-9990365/1

    2023-04-15T08:56:14.773834  =


    2023-04-15T08:56:14.778973  / # /lava-9990365/bin/lava-test-runner /lav=
a-9990365/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643a6af847e8de63022e865f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a6af847e8de63022e8664
        failing since 77 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-15T09:14:24.408865  + set +x
    2023-04-15T09:14:24.409105  [    9.358856] <LAVA_SIGNAL_ENDRUN 0_dmesg =
926946_1.5.2.3.1>
    2023-04-15T09:14:24.515971  / # #
    2023-04-15T09:14:24.617542  export SHELL=3D/bin/sh
    2023-04-15T09:14:24.618009  #
    2023-04-15T09:14:24.719196  / # export SHELL=3D/bin/sh. /lava-926946/en=
vironment
    2023-04-15T09:14:24.719672  =

    2023-04-15T09:14:24.820894  / # . /lava-926946/environment/lava-926946/=
bin/lava-test-runner /lava-926946/1
    2023-04-15T09:14:24.821407  =

    2023-04-15T09:14:24.823955  / # /lava-926946/bin/lava-test-runner /lava=
-926946/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643a66b0be5354d7942e8698

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a66b0be5354d7942e869d
        failing since 17 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T08:56:04.677226  <8>[   10.851501] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9990342_1.4.2.3.1>

    2023-04-15T08:56:04.781652  / # #

    2023-04-15T08:56:04.882727  export SHELL=3D/bin/sh

    2023-04-15T08:56:04.882936  #

    2023-04-15T08:56:04.983888  / # export SHELL=3D/bin/sh. /lava-9990342/e=
nvironment

    2023-04-15T08:56:04.984097  =


    2023-04-15T08:56:05.085065  / # . /lava-9990342/environment/lava-999034=
2/bin/lava-test-runner /lava-9990342/1

    2023-04-15T08:56:05.085397  =


    2023-04-15T08:56:05.089818  / # /lava-9990342/bin/lava-test-runner /lav=
a-9990342/1

    2023-04-15T08:56:05.095078  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643a6473bbf07ace762e861f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g165b92fad56a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a6473bbf07ace762e8624
        failing since 73 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-15T08:46:09.578536  / # #
    2023-04-15T08:46:09.684491  export SHELL=3D/bin/sh
    2023-04-15T08:46:09.686382  #
    2023-04-15T08:46:09.789959  / # export SHELL=3D/bin/sh. /lava-3498165/e=
nvironment
    2023-04-15T08:46:09.791816  =

    2023-04-15T08:46:09.895569  / # . /lava-3498165/environment/lava-349816=
5/bin/lava-test-runner /lava-3498165/1
    2023-04-15T08:46:09.898669  =

    2023-04-15T08:46:09.917862  / # /lava-3498165/bin/lava-test-runner /lav=
a-3498165/1
    2023-04-15T08:46:10.059459  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-15T08:46:10.060624  + cd /lava-3498165/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
