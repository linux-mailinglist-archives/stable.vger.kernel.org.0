Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BE16E8021
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 19:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjDSRKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 13:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjDSRKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 13:10:04 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B35EF3
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 10:10:02 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-24704a7bf34so3191831a91.1
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 10:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681924201; x=1684516201;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vF6HvvZ8A3lWPeiHFwGKPSF3U8lVv0rkKbst/AlI0Eg=;
        b=ZGnBrMTahoVeZeynWbJZCrw1H3+LDq861dHeMa6pLfWbUOLD6mMrxrOatMDo9UdTWt
         Fy8TT2i9SQaGI1pSA6OelwBmkKvddZzZK9Zmh/AlOYADMuZ4LH4hOfoBjpRiG7WHqGgW
         90s+/8uXXYL0YVPs0PbwtPOXojObunKRXnGzy9dm/54kb7iZV/to5oD/1OwUF7YNLGxs
         7tRY9bjpaBPBZ235+pNFZN2ikxv9ZiB09WZG7hiC2TQG9TKeB+Lu7aQ7koctPIskf7nJ
         ncEEfxV4Jho0ZlJnK4B4uQ3jxTRgYq0XxRJ22QhN9h83Fmtn1JfXK9dEAyDBpUEW9rMh
         O64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681924201; x=1684516201;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vF6HvvZ8A3lWPeiHFwGKPSF3U8lVv0rkKbst/AlI0Eg=;
        b=g/1nV+4PMdZXYLjoDSEgcmjWw6ENi8iJ1V3eVD/l2cWC7CH8aQ3Tx39C/MOzxr49m2
         mC54q/rTYjqWCYiB8Mdyg6Uc5uHhAI2u8IAo+boASN/2xV5fqicYmDPdUbOI+buL/TVE
         OdmlB13ZheH7qE/12BlHLIQ8ANrn14Dbo1mv7+BpGZPATj0HIxYC0T7AMwC6D23rNxyM
         YbEML7h+Q98p4JcZtEf2ik9uqSpYak1MouNbyENO9qxQ4PcIDQcIXOmsO2hbKN7k54CG
         +Hjo5N9eMAWXVej92uRQVo9sduxIBF4SWWDrTE24qN6/Dw8dkbzNi9thfZJ1FK4z9eOo
         Kwyg==
X-Gm-Message-State: AAQBX9esvpytRWrubNZN30/IE526PS4PDqV4NslcndXygqEwaVNINhYi
        tDigeFPfMh7vlGpiaWfFON7tAZuj2FkRzkMWws9Vt1m4
X-Google-Smtp-Source: AKy350bJ+7fXBFz2YiN8IX14kDnZ0v21p2E1BNtctStmuj003dcSJRMq5bXcYRHbN9+Etx/4qawiAQ==
X-Received: by 2002:a17:90a:1b69:b0:246:f70e:e2ff with SMTP id q96-20020a17090a1b6900b00246f70ee2ffmr3705943pjq.0.1681924201221;
        Wed, 19 Apr 2023 10:10:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s10-20020a17090ad48a00b00247a2498075sm1637410pju.48.2023.04.19.10.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 10:10:00 -0700 (PDT)
Message-ID: <64402068.170a0220.30124.3cc9@mx.google.com>
Date:   Wed, 19 Apr 2023 10:10:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-275-g86ea15e4013d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 176 runs,
 10 regressions (v5.15.105-275-g86ea15e4013d)
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

stable-rc/queue/5.15 baseline: 176 runs, 10 regressions (v5.15.105-275-g86e=
a15e4013d)

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
nel/v5.15.105-275-g86ea15e4013d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-275-g86ea15e4013d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86ea15e4013d58dc61031396dfe2cb7c1a79723d =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fee3558ce9b250f2e861b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fee3558ce9b250f2e8620
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T13:35:42.088363  <8>[    8.122237] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10046671_1.4.2.3.1>

    2023-04-19T13:35:42.091591  + set +x

    2023-04-19T13:35:42.196269  / # #

    2023-04-19T13:35:42.297326  export SHELL=3D/bin/sh

    2023-04-19T13:35:42.297538  #

    2023-04-19T13:35:42.398453  / # export SHELL=3D/bin/sh. /lava-10046671/=
environment

    2023-04-19T13:35:42.398640  =


    2023-04-19T13:35:42.499521  / # . /lava-10046671/environment/lava-10046=
671/bin/lava-test-runner /lava-10046671/1

    2023-04-19T13:35:42.499865  =


    2023-04-19T13:35:42.505502  / # /lava-10046671/bin/lava-test-runner /la=
va-10046671/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fee26f01265a0f82e85f2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fee26f01265a0f82e85f7
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T13:35:12.265244  + set<8>[   10.906274] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10046589_1.4.2.3.1>

    2023-04-19T13:35:12.265326   +x

    2023-04-19T13:35:12.369358  / # #

    2023-04-19T13:35:12.470314  export SHELL=3D/bin/sh

    2023-04-19T13:35:12.470478  #

    2023-04-19T13:35:12.571285  / # export SHELL=3D/bin/sh. /lava-10046589/=
environment

    2023-04-19T13:35:12.571501  =


    2023-04-19T13:35:12.672201  / # . /lava-10046589/environment/lava-10046=
589/bin/lava-test-runner /lava-10046589/1

    2023-04-19T13:35:12.672477  =


    2023-04-19T13:35:12.677047  / # /lava-10046589/bin/lava-test-runner /la=
va-10046589/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fee318d8a5d62912e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fee318d8a5d62912e860d
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T13:35:29.007214  <8>[   10.369431] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10046600_1.4.2.3.1>

    2023-04-19T13:35:29.010677  + set +x

    2023-04-19T13:35:29.116634  #

    2023-04-19T13:35:29.118058  =


    2023-04-19T13:35:29.220375  / # #export SHELL=3D/bin/sh

    2023-04-19T13:35:29.221230  =


    2023-04-19T13:35:29.323200  / # export SHELL=3D/bin/sh. /lava-10046600/=
environment

    2023-04-19T13:35:29.324075  =


    2023-04-19T13:35:29.426233  / # . /lava-10046600/environment/lava-10046=
600/bin/lava-test-runner /lava-10046600/1

    2023-04-19T13:35:29.427793  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643fefc17fb6e2f4ee2e85e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fefc17fb6e2f4ee2e8=
5e8
        failing since 75 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fef5a088f4c91982e85fb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fef5a088f4c91982e8600
        failing since 92 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-19T13:40:32.999601  + set +x<8>[    9.974913] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3512242_1.5.2.4.1>
    2023-04-19T13:40:33.000226  =

    2023-04-19T13:40:33.108766  / # #
    2023-04-19T13:40:33.212158  export SHELL=3D/bin/sh
    2023-04-19T13:40:33.212963  #
    2023-04-19T13:40:33.315108  / # export SHELL=3D/bin/sh. /lava-3512242/e=
nvironment
    2023-04-19T13:40:33.316089  <3>[   10.192826] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-04-19T13:40:33.316643  =

    2023-04-19T13:40:33.418550  / # . /lava-3512242/environment/lava-351224=
2/bin/lava-test-runner /lava-3512242/1
    2023-04-19T13:40:33.420011   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fee348d8a5d62912e862c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fee348d8a5d62912e8631
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T13:35:30.556754  + set +x

    2023-04-19T13:35:30.563133  <8>[   10.245688] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10046627_1.4.2.3.1>

    2023-04-19T13:35:30.669118  / # #

    2023-04-19T13:35:30.771700  export SHELL=3D/bin/sh

    2023-04-19T13:35:30.772474  #

    2023-04-19T13:35:30.874392  / # export SHELL=3D/bin/sh. /lava-10046627/=
environment

    2023-04-19T13:35:30.875258  =


    2023-04-19T13:35:30.977086  / # . /lava-10046627/environment/lava-10046=
627/bin/lava-test-runner /lava-10046627/1

    2023-04-19T13:35:30.978162  =


    2023-04-19T13:35:30.982759  / # /lava-10046627/bin/lava-test-runner /la=
va-10046627/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fee298d8a5d62912e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fee298d8a5d62912e85f0
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T13:35:16.158294  <8>[   11.015957] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10046621_1.4.2.3.1>

    2023-04-19T13:35:16.161770  + set +x

    2023-04-19T13:35:16.269190  / # #

    2023-04-19T13:35:16.371745  export SHELL=3D/bin/sh

    2023-04-19T13:35:16.372525  #

    2023-04-19T13:35:16.474289  / # export SHELL=3D/bin/sh. /lava-10046621/=
environment

    2023-04-19T13:35:16.475003  =


    2023-04-19T13:35:16.576779  / # . /lava-10046621/environment/lava-10046=
621/bin/lava-test-runner /lava-10046621/1

    2023-04-19T13:35:16.577885  =


    2023-04-19T13:35:16.583063  / # /lava-10046621/bin/lava-test-runner /la=
va-10046621/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fee36cf86604bae2e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fee36cf86604bae2e85ed
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T13:35:42.568891  + <8>[   11.399188] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10046607_1.4.2.3.1>

    2023-04-19T13:35:42.568977  set +x

    2023-04-19T13:35:42.673917  / # #

    2023-04-19T13:35:42.774826  export SHELL=3D/bin/sh

    2023-04-19T13:35:42.775024  #

    2023-04-19T13:35:42.875713  / # export SHELL=3D/bin/sh. /lava-10046607/=
environment

    2023-04-19T13:35:42.875868  =


    2023-04-19T13:35:42.976783  / # . /lava-10046607/environment/lava-10046=
607/bin/lava-test-runner /lava-10046607/1

    2023-04-19T13:35:42.977033  =


    2023-04-19T13:35:42.981748  / # /lava-10046607/bin/lava-test-runner /la=
va-10046607/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fef2e6497a89b532e85f6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fef2e6497a89b532e85fb
        failing since 82 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-19T13:39:35.750727  + set +x
    2023-04-19T13:39:35.751065  [    9.361529] <LAVA_SIGNAL_ENDRUN 0_dmesg =
930884_1.5.2.3.1>
    2023-04-19T13:39:35.857876  / # #
    2023-04-19T13:39:35.959583  export SHELL=3D/bin/sh
    2023-04-19T13:39:35.960024  #
    2023-04-19T13:39:36.061347  / # export SHELL=3D/bin/sh. /lava-930884/en=
vironment
    2023-04-19T13:39:36.061832  =

    2023-04-19T13:39:36.163192  / # . /lava-930884/environment/lava-930884/=
bin/lava-test-runner /lava-930884/1
    2023-04-19T13:39:36.164119  =

    2023-04-19T13:39:36.166938  / # /lava-930884/bin/lava-test-runner /lava=
-930884/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fee363e1ff306912e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-275-g86ea15e4013d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fee363e1ff306912e85ec
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T13:35:40.612084  + set +x<8>[   11.108961] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10046660_1.4.2.3.1>

    2023-04-19T13:35:40.612170  =


    2023-04-19T13:35:40.717250  / # #

    2023-04-19T13:35:40.818259  export SHELL=3D/bin/sh

    2023-04-19T13:35:40.818489  #

    2023-04-19T13:35:40.919393  / # export SHELL=3D/bin/sh. /lava-10046660/=
environment

    2023-04-19T13:35:40.919631  =


    2023-04-19T13:35:41.020633  / # . /lava-10046660/environment/lava-10046=
660/bin/lava-test-runner /lava-10046660/1

    2023-04-19T13:35:41.021014  =


    2023-04-19T13:35:41.025548  / # /lava-10046660/bin/lava-test-runner /la=
va-10046660/1
 =

    ... (12 line(s) more)  =

 =20
