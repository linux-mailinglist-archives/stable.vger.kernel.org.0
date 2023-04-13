Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F7A6E08E1
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 10:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjDMI1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 04:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjDMI07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 04:26:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5AA98
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 01:26:55 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m18so14194762plx.5
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 01:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681374414; x=1683966414;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vPbm9f/b/+qrAtOd8pNMKDS/x4VDucp1c0+JJnLIMdo=;
        b=c54LJAy/0ZZFG7Qah787GcBQzygGp+VtpnCnwpt5YYcJkwqh+PPg7G4i3G7V5R5SGw
         6JyXafYJbQocdFIq/xEsDBSH6tOyb1t8J0ng7g4E1qWWTmVsDb9Ux/rFUzfasrN9tvIq
         ++PkMhaL2cvD2grnpY98hs8r1SSD0j1AhoqZn8VPe3hx/4Lh5IGzQ6hr/JmF881ODx9D
         7kmALMbKjM4bXT08vJFsgjYAm3XBQGRskwWOOEg/KzE6sb6by+j1UTR+N1nGNr53hY4w
         fVuWJBUGnbCjKyQYaXeETJTbOS/EMbCP8AevioCfdtCaG0Ft/fcDtzasd+mASZTR5uz7
         ODSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681374414; x=1683966414;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vPbm9f/b/+qrAtOd8pNMKDS/x4VDucp1c0+JJnLIMdo=;
        b=BOvakkS2vUO3NDTXvcp3o1NGM7eRC+FqYa4nSYDw+IxiwrlIFusaYMZlwir/zfstfG
         vbYP4wnMWuva+IZt+aGnW6kUVHhkpBj6HVL68NL5VGC5+kEeWAJC+c/9oEUHG4wDt5aJ
         665PhwYcndwV3/7XW16HEQtbxeiJrkD5kWxFhCEa5no+HTbgkfRsvXzjDUxvS4OI3h9a
         wzhrslDL4vhdhDyDaWFBPsEI3NXodEVozpBNyk4FDjU3zz0ZbQEWGzmaUmuybTlgcGhs
         tq1P4vVXoSi3GUcuVMW3jLmgn430/s6J2dlEozrIDOJ7rYR77jiLbscS54/Pk5mEJa7P
         k5YA==
X-Gm-Message-State: AAQBX9eDqjwDErPJKG8xXGYBcim+9SoGZHXGhqR/qIaKNyolnLNn0WGe
        6yyysm97HbuDrUCHAUkSsYzCakJ3k52ngnswj4s3knZ0
X-Google-Smtp-Source: AKy350YWadBBvcwinUpN0AKrobO53D7eyvqMVvyGVwAJErOjOC82I62iQ6Y07OmDI/urH+jYzbvYZg==
X-Received: by 2002:a17:902:c443:b0:1a0:48c6:3b43 with SMTP id m3-20020a170902c44300b001a048c63b43mr1183516plm.37.1681374414445;
        Thu, 13 Apr 2023 01:26:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902d88600b001a64851087bsm894135plz.272.2023.04.13.01.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 01:26:54 -0700 (PDT)
Message-ID: <6437bcce.170a0220.fa5ae.1c15@mx.google.com>
Date:   Thu, 13 Apr 2023 01:26:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-189-g2331fd118796
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 186 runs,
 10 regressions (v5.15.105-189-g2331fd118796)
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

stable-rc/queue/5.15 baseline: 186 runs, 10 regressions (v5.15.105-189-g233=
1fd118796)

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

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre  | gcc-10   | sunxi_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-189-g2331fd118796/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-189-g2331fd118796
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2331fd1187964574cb220f5510dd58b4a077a12c =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643787f954e0782b202e864d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643787f954e0782b202e8652
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T04:41:12.232536  + set +x

    2023-04-13T04:41:12.238719  <8>[   10.293749] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9957112_1.4.2.3.1>

    2023-04-13T04:41:12.343495  / # #

    2023-04-13T04:41:12.444592  export SHELL=3D/bin/sh

    2023-04-13T04:41:12.444828  #

    2023-04-13T04:41:12.545851  / # export SHELL=3D/bin/sh. /lava-9957112/e=
nvironment

    2023-04-13T04:41:12.546074  =


    2023-04-13T04:41:12.647013  / # . /lava-9957112/environment/lava-995711=
2/bin/lava-test-runner /lava-9957112/1

    2023-04-13T04:41:12.647306  =


    2023-04-13T04:41:12.652771  / # /lava-9957112/bin/lava-test-runner /lav=
a-9957112/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643787bdf72ea0799c2e85f3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643787bdf72ea0799c2e85f8
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T04:40:09.041513  + set<8>[   10.967846] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9957069_1.4.2.3.1>

    2023-04-13T04:40:09.041641   +x

    2023-04-13T04:40:09.146083  / # #

    2023-04-13T04:40:09.247080  export SHELL=3D/bin/sh

    2023-04-13T04:40:09.247280  #

    2023-04-13T04:40:09.348167  / # export SHELL=3D/bin/sh. /lava-9957069/e=
nvironment

    2023-04-13T04:40:09.348364  =


    2023-04-13T04:40:09.449415  / # . /lava-9957069/environment/lava-995706=
9/bin/lava-test-runner /lava-9957069/1

    2023-04-13T04:40:09.450987  =


    2023-04-13T04:40:09.455523  / # /lava-9957069/bin/lava-test-runner /lav=
a-9957069/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643787bd8f8cf4a8062e85fe

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643787bd8f8cf4a8062e8603
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T04:40:14.890215  <8>[   10.746790] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9957099_1.4.2.3.1>

    2023-04-13T04:40:14.893160  + set +x

    2023-04-13T04:40:14.996103  #

    2023-04-13T04:40:14.996377  =


    2023-04-13T04:40:15.097334  / # #export SHELL=3D/bin/sh

    2023-04-13T04:40:15.097538  =


    2023-04-13T04:40:15.198538  / # export SHELL=3D/bin/sh. /lava-9957099/e=
nvironment

    2023-04-13T04:40:15.199198  =


    2023-04-13T04:40:15.300960  / # . /lava-9957099/environment/lava-995709=
9/bin/lava-test-runner /lava-9957099/1

    2023-04-13T04:40:15.302056  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64378ca9e3a25042402e8698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64378ca9e3a25042402e8=
699
        failing since 68 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643788f95d9eaa91312e8642

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643788fa5d9eaa91312e8647
        failing since 85 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-13T04:45:15.085346  <8>[   10.012525] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3491165_1.5.2.4.1>
    2023-04-13T04:45:15.193818  / # #
    2023-04-13T04:45:15.295377  export SHELL=3D/bin/sh
    2023-04-13T04:45:15.295735  #
    2023-04-13T04:45:15.396859  / # export SHELL=3D/bin/sh. /lava-3491165/e=
nvironment
    2023-04-13T04:45:15.397230  =

    2023-04-13T04:45:15.498280  / # . /lava-3491165/environment/lava-349116=
5/bin/lava-test-runner /lava-3491165/1
    2023-04-13T04:45:15.498932  =

    2023-04-13T04:45:15.504032  / # /lava-3491165/bin/lava-test-runner /lav=
a-3491165/1
    2023-04-13T04:45:15.592964  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378ade27af042a192e8618

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378ade27af042a192e861d
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T04:53:34.232368  + set +x

    2023-04-13T04:53:34.238990  <8>[   10.334393] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9957043_1.4.2.3.1>

    2023-04-13T04:53:34.344019  / # #

    2023-04-13T04:53:34.444988  export SHELL=3D/bin/sh

    2023-04-13T04:53:34.445179  #

    2023-04-13T04:53:34.545877  / # export SHELL=3D/bin/sh. /lava-9957043/e=
nvironment

    2023-04-13T04:53:34.546095  =


    2023-04-13T04:53:34.647036  / # . /lava-9957043/environment/lava-995704=
3/bin/lava-test-runner /lava-9957043/1

    2023-04-13T04:53:34.647399  =


    2023-04-13T04:53:34.651703  / # /lava-9957043/bin/lava-test-runner /lav=
a-9957043/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6437889b4b1f4057d22e86af

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6437889b4b1f4057d22e86b4
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T04:43:50.297447  <8>[   10.741677] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9957093_1.4.2.3.1>

    2023-04-13T04:43:50.300997  + set +x

    2023-04-13T04:43:50.402709  #

    2023-04-13T04:43:50.403242  =


    2023-04-13T04:43:50.504677  / # #export SHELL=3D/bin/sh

    2023-04-13T04:43:50.505340  =


    2023-04-13T04:43:50.607115  / # export SHELL=3D/bin/sh. /lava-9957093/e=
nvironment

    2023-04-13T04:43:50.607923  =


    2023-04-13T04:43:50.710034  / # . /lava-9957093/environment/lava-995709=
3/bin/lava-test-runner /lava-9957093/1

    2023-04-13T04:43:50.711314  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643787aa80b629446a2e85f2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643787aa80b629446a2e85f7
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T04:40:05.135592  + set<8>[    8.632015] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9957083_1.4.2.3.1>

    2023-04-13T04:40:05.135697   +x

    2023-04-13T04:40:05.240835  / # #

    2023-04-13T04:40:05.343713  export SHELL=3D/bin/sh

    2023-04-13T04:40:05.344426  #

    2023-04-13T04:40:05.446299  / # export SHELL=3D/bin/sh. /lava-9957083/e=
nvironment

    2023-04-13T04:40:05.446514  =


    2023-04-13T04:40:05.547456  / # . /lava-9957083/environment/lava-995708=
3/bin/lava-test-runner /lava-9957083/1

    2023-04-13T04:40:05.547755  =


    2023-04-13T04:40:05.551918  / # /lava-9957083/bin/lava-test-runner /lav=
a-9957083/1
 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378887d7dad09d952e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378887d7dad09d952e85eb
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T04:43:33.078510  + set<8>[   11.953336] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9957056_1.4.2.3.1>

    2023-04-13T04:43:33.078594   +x

    2023-04-13T04:43:33.183191  / # #

    2023-04-13T04:43:33.284328  export SHELL=3D/bin/sh

    2023-04-13T04:43:33.284513  #

    2023-04-13T04:43:33.385467  / # export SHELL=3D/bin/sh. /lava-9957056/e=
nvironment

    2023-04-13T04:43:33.385650  =


    2023-04-13T04:43:33.486597  / # . /lava-9957056/environment/lava-995705=
6/bin/lava-test-runner /lava-9957056/1

    2023-04-13T04:43:33.486886  =


    2023-04-13T04:43:33.491209  / # /lava-9957056/bin/lava-test-runner /lav=
a-9957056/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre  | gcc-10   | sunxi_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643785c3d3a88e3cc82e85ec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-189-g2331fd118796/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643785c3d3a88e3cc82e85f1
        failing since 71 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-13T04:31:37.406243  / # #
    2023-04-13T04:31:37.511778  export SHELL=3D/bin/sh
    2023-04-13T04:31:37.513292  #
    2023-04-13T04:31:37.616673  / # export SHELL=3D/bin/sh. /lava-3491013/e=
nvironment
    2023-04-13T04:31:37.618258  =

    2023-04-13T04:31:37.721603  / # . /lava-3491013/environment/lava-349101=
3/bin/lava-test-runner /lava-3491013/1
    2023-04-13T04:31:37.724279  =

    2023-04-13T04:31:37.731920  / # /lava-3491013/bin/lava-test-runner /lav=
a-3491013/1
    2023-04-13T04:31:37.873836  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-13T04:31:37.874901  + cd /lava-3491013/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
