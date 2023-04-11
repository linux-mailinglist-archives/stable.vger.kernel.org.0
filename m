Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423D26DE580
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 22:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjDKUIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 16:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDKUIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 16:08:36 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1116E87
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:07:39 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c10-20020a17090abf0a00b0023d1bbd9f9eso12250865pjs.0
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681243652; x=1683835652;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0xMJmwNWsOQk6mAHOyhVJOURAHXvHvz3upGJPBC6HU=;
        b=P+iT2G0Jt9sphSZaq+Ql6gknNTLrqU+Poa1b6IDtQbdmbnzXg/5Z0FvGh0i6uKbY4s
         oZEFikJAvqXx6INyH6uueDsG1HaIs+LAtHGJOqa0s0Z/iuPcYrKurK8kMQsTS5krwoDA
         mxiEy+uzi5FFduoy6oeU0KQewIdRt3BR4HdGbgs6CKo0mgAhqcLBX/cs6JXV5vQR6zmv
         sVI46Us+JCZ3AZnFz2q1lZcVpxXz/0kEQmC85r4qJXT4dIkkVZLCdkxqZfBc7KgPU9DX
         lUY0ZMjZnTPgAhIe1B6YxVx10x0XW3n31MyBNVOxQ/I3+ufNQQoO6C4SRRevoShw2e44
         nxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681243652; x=1683835652;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y0xMJmwNWsOQk6mAHOyhVJOURAHXvHvz3upGJPBC6HU=;
        b=kkqu2drJhSs65XKnOdp5jK/Xp2M4Ojp4KwT3Gzuk25qeRWnthiK6iwLJVoQ38iWPhg
         2A8EgH0kjcvOxJy0DWxzeT83Pnf+zFwYkrK2L0QdgT0+0ntHT81v67QJ7P6s1cG2ga9i
         EJNXWiW8ALPFUuJMqxS7KwtS2VTE/Ikkn6flZJ7vjJ2EdIOpgDSMRQsZiykdfksddB6h
         8FEpOXNJDVr+s1WUUSG0vPsgRA0JIH0vgHpThIjhAtZYGkQ2chsorZcAeM3Z8GddzCM3
         CJW/1+W9hLU1Qpsr6Otqct1vEcvpcTlPLpojcL0xYrY9aR7uhRPiHAMO2kizLNm9pelD
         ibvQ==
X-Gm-Message-State: AAQBX9cyuRAhs80TmYnkpQosKegWPJnbCUnsuiNiKSupRD2gMZnzwyIC
        MBPZ7NOhl5Y4b5ELo8rwffkcZ6IPBZ6ZmemhjgjVlw==
X-Google-Smtp-Source: AKy350Yaf2ejNAZQhIE1Ysu6i2+obCBjXWsevhmjib5V4p336OmB0mKKobzVE2uNknTY9cCBrUQuhw==
X-Received: by 2002:a17:90b:4a52:b0:23f:c096:7129 with SMTP id lb18-20020a17090b4a5200b0023fc0967129mr20583853pjb.26.1681243651978;
        Tue, 11 Apr 2023 13:07:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090a880c00b002469c194338sm159582pjn.52.2023.04.11.13.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:07:31 -0700 (PDT)
Message-ID: <6435be03.170a0220.7c4ff.0d92@mx.google.com>
Date:   Tue, 11 Apr 2023 13:07:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-192-g2d6ce1bab2b6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 184 runs,
 9 regressions (v5.15.105-192-g2d6ce1bab2b6)
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

stable-rc/queue/5.15 baseline: 184 runs, 9 regressions (v5.15.105-192-g2d6c=
e1bab2b6)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-192-g2d6ce1bab2b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-192-g2d6ce1bab2b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d6ce1bab2b673b9400d728298b7e12dbc53b220 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64358b1dc93ae75e632e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64358b1dc93ae75e632e85ed
        failing since 14 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-11T16:29:59.424730  + set +x

    2023-04-11T16:29:59.431011  <8>[   10.517785] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9939658_1.4.2.3.1>

    2023-04-11T16:29:59.538471  / # #

    2023-04-11T16:29:59.641196  export SHELL=3D/bin/sh

    2023-04-11T16:29:59.641872  #

    2023-04-11T16:29:59.743645  / # export SHELL=3D/bin/sh. /lava-9939658/e=
nvironment

    2023-04-11T16:29:59.744332  =


    2023-04-11T16:29:59.846034  / # . /lava-9939658/environment/lava-993965=
8/bin/lava-test-runner /lava-9939658/1

    2023-04-11T16:29:59.847129  =


    2023-04-11T16:29:59.853238  / # /lava-9939658/bin/lava-test-runner /lav=
a-9939658/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64358afc4884fd46dc2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64358afc4884fd46dc2e85eb
        failing since 14 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-11T16:29:39.476860  + set<8>[   11.784103] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9939675_1.4.2.3.1>

    2023-04-11T16:29:39.477287   +x

    2023-04-11T16:29:39.585173  / # #

    2023-04-11T16:29:39.687807  export SHELL=3D/bin/sh

    2023-04-11T16:29:39.688510  #

    2023-04-11T16:29:39.790264  / # export SHELL=3D/bin/sh. /lava-9939675/e=
nvironment

    2023-04-11T16:29:39.790924  =


    2023-04-11T16:29:39.892820  / # . /lava-9939675/environment/lava-993967=
5/bin/lava-test-runner /lava-9939675/1

    2023-04-11T16:29:39.894242  =


    2023-04-11T16:29:39.899274  / # /lava-9939675/bin/lava-test-runner /lav=
a-9939675/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64358d17a5501844e12e865a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64358d17a5501844e12e865f
        failing since 14 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-11T16:38:42.825441  <8>[   10.558883] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9939635_1.4.2.3.1>

    2023-04-11T16:38:42.828835  + set +x

    2023-04-11T16:38:42.933900  =


    2023-04-11T16:38:43.034870  / # #export SHELL=3D/bin/sh

    2023-04-11T16:38:43.035005  =


    2023-04-11T16:38:43.135941  / # export SHELL=3D/bin/sh. /lava-9939635/e=
nvironment

    2023-04-11T16:38:43.136082  =


    2023-04-11T16:38:43.237024  / # . /lava-9939635/environment/lava-993963=
5/bin/lava-test-runner /lava-9939635/1

    2023-04-11T16:38:43.237294  =


    2023-04-11T16:38:43.242472  / # /lava-9939635/bin/lava-test-runner /lav=
a-9939635/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64358d9589fecce09a2e8606

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64358d9589fecce09a2e8=
607
        failing since 67 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64358bbe9ae821f3b42e8614

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64358bbe9ae821f3b42e8619
        failing since 84 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-11T16:32:15.482449  + set +x<8>[   10.008791] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3486049_1.5.2.4.1>
    2023-04-11T16:32:15.483802  =

    2023-04-11T16:32:15.601340  / # #
    2023-04-11T16:32:15.705259  export SHELL=3D/bin/sh
    2023-04-11T16:32:15.706136  #
    2023-04-11T16:32:15.808278  / # export SHELL=3D/bin/sh. /lava-3486049/e=
nvironment
    2023-04-11T16:32:15.809244  =

    2023-04-11T16:32:15.911406  / # . /lava-3486049/environment/lava-348604=
9/bin/lava-test-runner /lava-3486049/1
    2023-04-11T16:32:15.913426  =

    2023-04-11T16:32:15.914135  / # <3>[   10.353641] Bluetooth: hci0: comm=
and 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64358c9db6de1999882e8627

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64358c9db6de1999882e862c
        failing since 14 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-11T16:36:29.028976  + set +x

    2023-04-11T16:36:29.035743  <8>[   10.234704] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9939643_1.4.2.3.1>

    2023-04-11T16:36:29.140507  / # #

    2023-04-11T16:36:29.241626  export SHELL=3D/bin/sh

    2023-04-11T16:36:29.241859  #

    2023-04-11T16:36:29.342842  / # export SHELL=3D/bin/sh. /lava-9939643/e=
nvironment

    2023-04-11T16:36:29.343080  =


    2023-04-11T16:36:29.444003  / # . /lava-9939643/environment/lava-993964=
3/bin/lava-test-runner /lava-9939643/1

    2023-04-11T16:36:29.444332  =


    2023-04-11T16:36:29.448920  / # /lava-9939643/bin/lava-test-runner /lav=
a-9939643/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64358bc1a56511c48a2e869d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64358bc1a56511c48a2e86a2
        failing since 14 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-11T16:32:41.471058  + set +x

    2023-04-11T16:32:41.477568  <8>[    8.014484] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9939641_1.4.2.3.1>

    2023-04-11T16:32:41.579579  #

    2023-04-11T16:32:41.579826  =


    2023-04-11T16:32:41.680807  / # #export SHELL=3D/bin/sh

    2023-04-11T16:32:41.680981  =


    2023-04-11T16:32:41.781691  / # export SHELL=3D/bin/sh. /lava-9939641/e=
nvironment

    2023-04-11T16:32:41.781861  =


    2023-04-11T16:32:41.882796  / # . /lava-9939641/environment/lava-993964=
1/bin/lava-test-runner /lava-9939641/1

    2023-04-11T16:32:41.883092  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64358afa9ca61b3aa52e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64358afb9ca61b3aa52e85ec
        failing since 14 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-11T16:29:22.288911  + set<8>[   11.158444] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9939625_1.4.2.3.1>

    2023-04-11T16:29:22.288991   +x

    2023-04-11T16:29:22.393555  / # #

    2023-04-11T16:29:22.494511  export SHELL=3D/bin/sh

    2023-04-11T16:29:22.494786  #

    2023-04-11T16:29:22.595723  / # export SHELL=3D/bin/sh. /lava-9939625/e=
nvironment

    2023-04-11T16:29:22.595901  =


    2023-04-11T16:29:22.696783  / # . /lava-9939625/environment/lava-993962=
5/bin/lava-test-runner /lava-9939625/1

    2023-04-11T16:29:22.697149  =


    2023-04-11T16:29:22.701501  / # /lava-9939625/bin/lava-test-runner /lav=
a-9939625/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64358b097829ddeaa62e8640

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-192-g2d6ce1bab2b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64358b097829ddeaa62e8645
        failing since 14 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-11T16:29:39.150469  <8>[   11.526554] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9939706_1.4.2.3.1>

    2023-04-11T16:29:39.258965  / # #

    2023-04-11T16:29:39.360180  export SHELL=3D/bin/sh

    2023-04-11T16:29:39.360382  #

    2023-04-11T16:29:39.461370  / # export SHELL=3D/bin/sh. /lava-9939706/e=
nvironment

    2023-04-11T16:29:39.462157  =


    2023-04-11T16:29:39.564156  / # . /lava-9939706/environment/lava-993970=
6/bin/lava-test-runner /lava-9939706/1

    2023-04-11T16:29:39.565283  =


    2023-04-11T16:29:39.570070  / # /lava-9939706/bin/lava-test-runner /lav=
a-9939706/1

    2023-04-11T16:29:39.574770  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
