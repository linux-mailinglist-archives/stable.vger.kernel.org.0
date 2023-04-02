Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4E86D3A19
	for <lists+stable@lfdr.de>; Sun,  2 Apr 2023 21:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjDBTyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Apr 2023 15:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBTyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Apr 2023 15:54:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0C5CA2F
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 12:54:17 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n14so10242626plc.8
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 12:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680465257;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7A/JeTOpAjLb3UnNlH6J/unEkSENGdI2oGAsPkUHcm0=;
        b=2pUTL39TKQO3JhoQWolBPjVSadjI6X7hl7brRygv4S/2ekeaB3HICmZuHCLbmf1ZvA
         ADHxcKNhAxpNqzO9c0IyYV3ulOQPRUuKCCFnY95nXkG/mDCYDc+WBz4pblHEd5z8ig2s
         AKTvRmk7ATELV9a5veZc2Acj2953AYkCwrRtDOZfLsLCuH6Y1Il59uoaEXTUxXMlI6rW
         Rm/yLQj04ZtENqOpE0gTnHyONrrCo6CnzVUCeHVFJ07qISR9tCnKHZQ3TuRMY3uT6KF9
         QvkW7++aK7EUb7h/crl3PlzVvb4EOf3yDOLSQvtD3wAhjafeXiWZqVNNyeEicSIPlYi0
         y5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680465257;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7A/JeTOpAjLb3UnNlH6J/unEkSENGdI2oGAsPkUHcm0=;
        b=H4VwPuas1g0L3yUUwE9ZirV9bpsK/0QHITdp7GZkppmPrzlKi2mmNCPBGPBp4YPNEU
         b9AnRNDhIaVoWHO/Q/sQywgYX46JgU+q+lDBwiv4TimKabRDUD8EU2iMcvpgRonFbvDY
         5zSZDhZKNkV1NiqlMGWNt7Z2+mMGgcTeLMJcp+CTpXoyiDl+YSuUpqoJZfebMcHPYoay
         UghVP5R+VIQQFxQTi9zrsv8O3AP2ZOMDgB+LcxZqVAv1gi+pmlbuz6ChlaadIm5X6uUL
         bIPhpld6XPpBu6HmHsDPH93GcGfbUlTbw5oIGqZXrZT7/BiQKg7aJqKUaXsDyNVszJ+l
         7kiw==
X-Gm-Message-State: AAQBX9czDLAe0iqgh6Ua/elE0Bx0m7KFADyct2hcoPGzsb49YT5vI5ea
        TDXO+Z6ricsAysHN/0tecDCw6bvwf6Pr+Y7L9ps=
X-Google-Smtp-Source: AKy350ZxztsLgaHfJiZYFXa17p+tfth1uJAmLn7G4capuo6HX9NqueV08qnMRt4kOZdmiSpxKlFQBA==
X-Received: by 2002:a17:903:124d:b0:1a2:4921:f9a1 with SMTP id u13-20020a170903124d00b001a24921f9a1mr35023545plh.44.1680465257034;
        Sun, 02 Apr 2023 12:54:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s4-20020a170902988400b001a1a8e98e93sm5083423plp.287.2023.04.02.12.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 12:54:16 -0700 (PDT)
Message-ID: <6429dd68.170a0220.1ec62.9845@mx.google.com>
Date:   Sun, 02 Apr 2023 12:54:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/6.1
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-119-g59b6cd554df0
Subject: stable-rc/queue/6.1 baseline: 178 runs,
 8 regressions (v6.1.22-119-g59b6cd554df0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 178 runs, 8 regressions (v6.1.22-119-g59b6cd5=
54df0)

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

bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-119-g59b6cd554df0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-119-g59b6cd554df0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      59b6cd554df0a14fe6c53a19e75f8fef8c824f8e =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a49458dd19aed662f7cd

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a49458dd19aed662f7d2
        failing since 4 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-02T15:51:33.522554  <8>[    9.783638] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842141_1.4.2.3.1>

    2023-04-02T15:51:33.525924  + set +x

    2023-04-02T15:51:33.628552  =


    2023-04-02T15:51:33.730444  / # #export SHELL=3D/bin/sh

    2023-04-02T15:51:33.731264  =


    2023-04-02T15:51:33.833177  / # export SHELL=3D/bin/sh. /lava-9842141/e=
nvironment

    2023-04-02T15:51:33.833387  =


    2023-04-02T15:51:33.934361  / # . /lava-9842141/environment/lava-984214=
1/bin/lava-test-runner /lava-9842141/1

    2023-04-02T15:51:33.934663  =


    2023-04-02T15:51:33.940409  / # /lava-9842141/bin/lava-test-runner /lav=
a-9842141/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a49158dd19aed662f7bf

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a49158dd19aed662f7c4
        failing since 4 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-02T15:51:24.746686  + <8>[   11.593918] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9842203_1.4.2.3.1>

    2023-04-02T15:51:24.747227  set +x

    2023-04-02T15:51:24.855787  / # #

    2023-04-02T15:51:24.958720  export SHELL=3D/bin/sh

    2023-04-02T15:51:24.959654  #

    2023-04-02T15:51:25.061520  / # export SHELL=3D/bin/sh. /lava-9842203/e=
nvironment

    2023-04-02T15:51:25.062508  =


    2023-04-02T15:51:25.164659  / # . /lava-9842203/environment/lava-984220=
3/bin/lava-test-runner /lava-9842203/1

    2023-04-02T15:51:25.166030  =


    2023-04-02T15:51:25.170831  / # /lava-9842203/bin/lava-test-runner /lav=
a-9842203/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a4aaf83779aef562f76e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a4aaf83779aef562f773
        failing since 4 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-02T15:51:55.862124  <8>[    9.945676] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842126_1.4.2.3.1>

    2023-04-02T15:51:55.865522  + set +x

    2023-04-02T15:51:55.967511  #

    2023-04-02T15:51:56.068967  / # #export SHELL=3D/bin/sh

    2023-04-02T15:51:56.069191  =


    2023-04-02T15:51:56.170098  / # export SHELL=3D/bin/sh. /lava-9842126/e=
nvironment

    2023-04-02T15:51:56.170306  =


    2023-04-02T15:51:56.271215  / # . /lava-9842126/environment/lava-984212=
6/bin/lava-test-runner /lava-9842126/1

    2023-04-02T15:51:56.271537  =


    2023-04-02T15:51:56.276074  / # /lava-9842126/bin/lava-test-runner /lav=
a-9842126/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a767424df809db62f7a0

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a767424df809db62f7d3
        new failure (last pass: v6.1.22-65-g0f37ac1f7e1d4)

    2023-04-02T16:03:30.219354  + set +x
    2023-04-02T16:03:30.222180  <8>[   16.362450] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 264974_1.5.2.4.1>
    2023-04-02T16:03:30.337407  / # #
    2023-04-02T16:03:30.439243  export SHELL=3D/bin/sh
    2023-04-02T16:03:30.439730  #
    2023-04-02T16:03:30.541591  / # export SHELL=3D/bin/sh. /lava-264974/en=
vironment
    2023-04-02T16:03:30.542544  =

    2023-04-02T16:03:30.644971  / # . /lava-264974/environment/lava-264974/=
bin/lava-test-runner /lava-264974/1
    2023-04-02T16:03:30.646091  =

    2023-04-02T16:03:30.651999  / # /lava-264974/bin/lava-test-runner /lava=
-264974/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a478837a77bb2f62f788

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a478837a77bb2f62f78d
        failing since 4 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-02T15:51:14.232686  + set +x

    2023-04-02T15:51:14.239063  <8>[   10.745429] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842205_1.4.2.3.1>

    2023-04-02T15:51:14.343545  / # #

    2023-04-02T15:51:14.444671  export SHELL=3D/bin/sh

    2023-04-02T15:51:14.444896  #

    2023-04-02T15:51:14.545884  / # export SHELL=3D/bin/sh. /lava-9842205/e=
nvironment

    2023-04-02T15:51:14.546090  =


    2023-04-02T15:51:14.647118  / # . /lava-9842205/environment/lava-984220=
5/bin/lava-test-runner /lava-9842205/1

    2023-04-02T15:51:14.647422  =


    2023-04-02T15:51:14.651466  / # /lava-9842205/bin/lava-test-runner /lav=
a-9842205/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a49583d9b0431562f7ea

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a49583d9b0431562f7ef
        failing since 4 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-02T15:51:42.242880  <8>[   10.193155] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842166_1.4.2.3.1>

    2023-04-02T15:51:42.245988  + set +x

    2023-04-02T15:51:42.348036  =


    2023-04-02T15:51:42.449141  / # #export SHELL=3D/bin/sh

    2023-04-02T15:51:42.449344  =


    2023-04-02T15:51:42.550276  / # export SHELL=3D/bin/sh. /lava-9842166/e=
nvironment

    2023-04-02T15:51:42.550469  =


    2023-04-02T15:51:42.651415  / # . /lava-9842166/environment/lava-984216=
6/bin/lava-test-runner /lava-9842166/1

    2023-04-02T15:51:42.651667  =


    2023-04-02T15:51:42.656878  / # /lava-9842166/bin/lava-test-runner /lav=
a-9842166/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a48f83d9b0431562f78a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a48f83d9b0431562f78f
        failing since 4 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-02T15:51:21.780346  + set<8>[    8.590990] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9842139_1.4.2.3.1>

    2023-04-02T15:51:21.780804   +x

    2023-04-02T15:51:21.889342  / # #

    2023-04-02T15:51:21.991083  export SHELL=3D/bin/sh

    2023-04-02T15:51:21.991876  #

    2023-04-02T15:51:22.093767  / # export SHELL=3D/bin/sh. /lava-9842139/e=
nvironment

    2023-04-02T15:51:22.094531  =


    2023-04-02T15:51:22.196366  / # . /lava-9842139/environment/lava-984213=
9/bin/lava-test-runner /lava-9842139/1

    2023-04-02T15:51:22.196635  =


    2023-04-02T15:51:22.202024  / # /lava-9842139/bin/lava-test-runner /lav=
a-9842139/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a47a837a77bb2f62f7a1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-11=
9-g59b6cd554df0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a47a837a77bb2f62f7a6
        failing since 4 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-02T15:51:11.689885  <8>[   12.020902] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842213_1.4.2.3.1>

    2023-04-02T15:51:11.795047  / # #

    2023-04-02T15:51:11.896041  export SHELL=3D/bin/sh

    2023-04-02T15:51:11.896259  #

    2023-04-02T15:51:11.997077  / # export SHELL=3D/bin/sh. /lava-9842213/e=
nvironment

    2023-04-02T15:51:11.997308  =


    2023-04-02T15:51:12.098258  / # . /lava-9842213/environment/lava-984221=
3/bin/lava-test-runner /lava-9842213/1

    2023-04-02T15:51:12.098612  =


    2023-04-02T15:51:12.102665  / # /lava-9842213/bin/lava-test-runner /lav=
a-9842213/1

    2023-04-02T15:51:12.109494  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
