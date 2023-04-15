Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D8B6E33E4
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 23:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjDOVrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 17:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDOVry (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 17:47:54 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891C235B1
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 14:47:52 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q2so26756181pll.7
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 14:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681595272; x=1684187272;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=spAPCszV6lTHkLlo4cyEpYLYFDKFF0ZlgszqsyOlZn4=;
        b=C9pVoaRaKLE7K5cCKwKLEJ76VgpOUHyBPzam1boA973I/6ctgAQLi5rBQUthEIQbN+
         P5liWzIhV3ImjapRpvchtI1pF2jDuFrR3gXeoLfOnhipTuWpspCrhxebqMOxy210xT9T
         2NFhCtf73xIpQ3fo0d96sC7aj6u7AbH6AIl7r5lGsZx9bu4subbXq/j72FwSg/Vn2IGf
         HgzdbCcWiwg1UokZ7yLrLtkaKmeUpTMdegfKSLkYJHbv46U9uzNPa1aDZR1dJf+/UR/w
         stMmJ+gnEIfhvfWPCKNAedR+aKwnXodS9YOKv4u7orGWeNfKJycWZo6gKhC6T8m49OGW
         HqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681595272; x=1684187272;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=spAPCszV6lTHkLlo4cyEpYLYFDKFF0ZlgszqsyOlZn4=;
        b=CEBHCgiq2FZ1fn/OAcQD0ot1k+OsgcoEErJVckd4yZbMQyrpmIQABeGwhVjPZC7QqT
         EPrS3MIpBsrXcZVGyModDQQYCnwltcF9aoMPp9hPbrN8OQM4TicvRbMivkUtm0E1hxgC
         7oh800UWnOEP5gFERUKNQ7MbjIxlKPilZ44kA1ZzeUCfhecs42t6o7ggaGWZQw3T3nhn
         jG8/+2Cd8DZGN0X88F3fEL5OA99M1hZbvQt1Gi60xAb5KYD7nLMVuBFM32Sd35CqzRzV
         Neqw1694+x6yGYexdwClwB9Jgf9BuUKDHXCu5JBm+Kdhk3pNZ/b0e7DhfvR3AWNSmDpx
         Bk/A==
X-Gm-Message-State: AAQBX9c/8hsggvdOKiAzmJ5TsPVoOo7EEalq9js5vEAkfjTAEQicD9qY
        6ApgYS6JEXxJ4dss9t7t8toqvOPAgQP65TcZWy+QN3hG
X-Google-Smtp-Source: AKy350brQN+WBs5DMkc2e4Sble61dvWzT108zP0qRkX7Ds1KxEDVWWGGik8kcvHNsbGZc77f3BO0sQ==
X-Received: by 2002:a17:902:c40f:b0:1a0:549d:399e with SMTP id k15-20020a170902c40f00b001a0549d399emr9484868plk.21.1681595271617;
        Sat, 15 Apr 2023 14:47:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jw20-20020a170903279400b001a5023e7395sm5016217plb.135.2023.04.15.14.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 14:47:51 -0700 (PDT)
Message-ID: <643b1b87.170a0220.16bd.b3e7@mx.google.com>
Date:   Sat, 15 Apr 2023 14:47:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-364-gf7dc7e601a2a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 190 runs,
 7 regressions (v6.1.22-364-gf7dc7e601a2a)
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

stable-rc/queue/6.1 baseline: 190 runs, 7 regressions (v6.1.22-364-gf7dc7e6=
01a2a)

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

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-364-gf7dc7e601a2a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-364-gf7dc7e601a2a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7dc7e601a2a86fe0445fb56ab002c87b4973bf1 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ae831ead298d4222e863b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ae831ead298d4222e8640
        failing since 17 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:08:34.288082  + set +x

    2023-04-15T18:08:34.294609  <8>[   10.584487] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9994560_1.4.2.3.1>

    2023-04-15T18:08:34.396707  #

    2023-04-15T18:08:34.497964  / # #export SHELL=3D/bin/sh

    2023-04-15T18:08:34.498163  =


    2023-04-15T18:08:34.599079  / # export SHELL=3D/bin/sh. /lava-9994560/e=
nvironment

    2023-04-15T18:08:34.599283  =


    2023-04-15T18:08:34.700183  / # . /lava-9994560/environment/lava-999456=
0/bin/lava-test-runner /lava-9994560/1

    2023-04-15T18:08:34.700476  =


    2023-04-15T18:08:34.706329  / # /lava-9994560/bin/lava-test-runner /lav=
a-9994560/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ae83581b6fa21012e8624

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ae83581b6fa21012e8629
        failing since 17 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:08:31.964033  + set<8>[   11.158308] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9994604_1.4.2.3.1>

    2023-04-15T18:08:31.964461   +x

    2023-04-15T18:08:32.071985  / # #

    2023-04-15T18:08:32.174742  export SHELL=3D/bin/sh

    2023-04-15T18:08:32.175467  #

    2023-04-15T18:08:32.277160  / # export SHELL=3D/bin/sh. /lava-9994604/e=
nvironment

    2023-04-15T18:08:32.277890  =


    2023-04-15T18:08:32.379557  / # . /lava-9994604/environment/lava-999460=
4/bin/lava-test-runner /lava-9994604/1

    2023-04-15T18:08:32.380779  =


    2023-04-15T18:08:32.386111  / # /lava-9994604/bin/lava-test-runner /lav=
a-9994604/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ae8327ce8f3c5082e860e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ae8327ce8f3c5082e8613
        failing since 17 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:08:35.688892  <8>[   10.608240] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9994586_1.4.2.3.1>

    2023-04-15T18:08:35.692232  + set +x

    2023-04-15T18:08:35.793912  #

    2023-04-15T18:08:35.895227  / # #export SHELL=3D/bin/sh

    2023-04-15T18:08:35.895421  =


    2023-04-15T18:08:35.996332  / # export SHELL=3D/bin/sh. /lava-9994586/e=
nvironment

    2023-04-15T18:08:35.996538  =


    2023-04-15T18:08:36.097473  / # . /lava-9994586/environment/lava-999458=
6/bin/lava-test-runner /lava-9994586/1

    2023-04-15T18:08:36.097750  =


    2023-04-15T18:08:36.103200  / # /lava-9994586/bin/lava-test-runner /lav=
a-9994586/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ae857c68b0319242e860d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ae857c68b0319242e8612
        failing since 17 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:09:12.435130  + set +x

    2023-04-15T18:09:12.441705  <8>[   10.337924] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9994546_1.4.2.3.1>

    2023-04-15T18:09:12.545904  / # #

    2023-04-15T18:09:12.646888  export SHELL=3D/bin/sh

    2023-04-15T18:09:12.647075  #

    2023-04-15T18:09:12.748082  / # export SHELL=3D/bin/sh. /lava-9994546/e=
nvironment

    2023-04-15T18:09:12.748766  =


    2023-04-15T18:09:12.850416  / # . /lava-9994546/environment/lava-999454=
6/bin/lava-test-runner /lava-9994546/1

    2023-04-15T18:09:12.851567  =


    2023-04-15T18:09:12.856865  / # /lava-9994546/bin/lava-test-runner /lav=
a-9994546/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ae8209db7de84f22e866c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ae8209db7de84f22e8671
        failing since 17 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:08:18.796812  + set +x<8>[   10.442680] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9994543_1.4.2.3.1>

    2023-04-15T18:08:18.796917  =


    2023-04-15T18:08:18.899063  #

    2023-04-15T18:08:19.000152  / # #export SHELL=3D/bin/sh

    2023-04-15T18:08:19.000347  =


    2023-04-15T18:08:19.101227  / # export SHELL=3D/bin/sh. /lava-9994543/e=
nvironment

    2023-04-15T18:08:19.101426  =


    2023-04-15T18:08:19.202292  / # . /lava-9994543/environment/lava-999454=
3/bin/lava-test-runner /lava-9994543/1

    2023-04-15T18:08:19.202542  =


    2023-04-15T18:08:19.207408  / # /lava-9994543/bin/lava-test-runner /lav=
a-9994543/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ae835b819a54dbf2e8614

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ae835b819a54dbf2e8619
        failing since 17 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:08:33.596017  + set<8>[   10.774621] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9994576_1.4.2.3.1>

    2023-04-15T18:08:33.596591   +x

    2023-04-15T18:08:33.705009  / # #

    2023-04-15T18:08:33.807366  export SHELL=3D/bin/sh

    2023-04-15T18:08:33.807574  #

    2023-04-15T18:08:33.908499  / # export SHELL=3D/bin/sh. /lava-9994576/e=
nvironment

    2023-04-15T18:08:33.908707  =


    2023-04-15T18:08:34.009854  / # . /lava-9994576/environment/lava-999457=
6/bin/lava-test-runner /lava-9994576/1

    2023-04-15T18:08:34.010968  =


    2023-04-15T18:08:34.016241  / # /lava-9994576/bin/lava-test-runner /lav=
a-9994576/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ae828b819a54dbf2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-36=
4-gf7dc7e601a2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ae828b819a54dbf2e85eb
        failing since 17 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-15T18:08:29.960015  + set<8>[   12.558969] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9994559_1.4.2.3.1>

    2023-04-15T18:08:29.960123   +x

    2023-04-15T18:08:30.064401  / # #

    2023-04-15T18:08:30.165541  export SHELL=3D/bin/sh

    2023-04-15T18:08:30.165762  #

    2023-04-15T18:08:30.266718  / # export SHELL=3D/bin/sh. /lava-9994559/e=
nvironment

    2023-04-15T18:08:30.266896  =


    2023-04-15T18:08:30.367776  / # . /lava-9994559/environment/lava-999455=
9/bin/lava-test-runner /lava-9994559/1

    2023-04-15T18:08:30.368043  =


    2023-04-15T18:08:30.373150  / # /lava-9994559/bin/lava-test-runner /lav=
a-9994559/1
 =

    ... (12 line(s) more)  =

 =20
