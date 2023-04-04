Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAE86D6311
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 15:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbjDDNgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 09:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbjDDNgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 09:36:52 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A9A4224
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 06:36:39 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id f22so27156849plr.0
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 06:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680615398;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=l9HCSBKjdGIP4vCKH71rwHgSQAGuII0zMSaks6A438M=;
        b=Ebd6CiklnFeCQJjU4uMYPmYV/i6BNqPrj39f0ZhTjD6RktAmu0ck94KJ+Hz/v+rEWA
         7ahQYxDF93bikDslsK3GQHlt6wMtNx+fGFnFQe6CHgmZjFa++l1VrcPTVzLVmcTrvW63
         wdaBU7Y5Y0Lh5LG3diuOZO7NZq0m47Lew711hbBxWOiPbb5d7TKv6a/ARmrcI4wA6pzD
         7hT7kQnmPSF9/vdl+mrfu+KeBb04dBi1IDZkbOsy04ayfR3IC+T/YWe3J/5BOWrQdN3z
         oFPK0QrUNjDVNIOXA0NS7CxNKL8ynDZRkm0KP+2KJS6azxLgQNWWI0r2Y3iG0G/zuo9L
         cmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680615398;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9HCSBKjdGIP4vCKH71rwHgSQAGuII0zMSaks6A438M=;
        b=ihOlARq1X6B542FdyQCBo7UXFsRE8H/Rn+hMFMYnt09/hByYhgH+9FBb64lNv/pcp0
         dDFbqUM5pOiBgQAn7LS4nBVdsW0TmBVV2CRLs7mFH1DIyMuJhP/zmpzQVxwz1qx5vUyL
         Lp+pM6p+1rn34ANaFrZ8wrUdbS6D63Mmcu17s8Kn7NTHT19lUY1SzGwCKpdsDXEf2E8c
         92ZhwLCKsMNn0Tp/Y/pomUl+mi0uns8YjxJ/IxOjckiww0438btREgOFxzlclGIqooSV
         jddfb8sm6qr1dKhWyaNAzIxsIlE+FStPNtkAtI6isddLWn069TIqy/s/jWNWF8IN9MLP
         IzAQ==
X-Gm-Message-State: AAQBX9eAHB6437Vtq+eR0DfVRHgmuD0AVCNJd+N0eQv16cIylW7eGJTS
        gsHhZ26rq2sy4PD8kj989/G8+dk4K0nNOsNt/Wa/DQ==
X-Google-Smtp-Source: AKy350ZFKlwuONGIYLTk+xZZri6lVRmbU4MJAb5NzS6SyWoiYfuE/ha13v8BJVrKdpP9GfAxROJIeg==
X-Received: by 2002:a05:6a20:671b:b0:d9:dbb6:2e67 with SMTP id q27-20020a056a20671b00b000d9dbb62e67mr2197667pzh.31.1680615398071;
        Tue, 04 Apr 2023 06:36:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i22-20020aa79096000000b006249928aba2sm8586460pfa.59.2023.04.04.06.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:36:37 -0700 (PDT)
Message-ID: <642c27e5.a70a0220.3dffa.0688@mx.google.com>
Date:   Tue, 04 Apr 2023 06:36:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-182-g01cd0041b7a5a
Subject: stable-rc/linux-6.1.y baseline: 155 runs,
 8 regressions (v6.1.22-182-g01cd0041b7a5a)
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

stable-rc/linux-6.1.y baseline: 155 runs, 8 regressions (v6.1.22-182-g01cd0=
041b7a5a)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22-182-g01cd0041b7a5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22-182-g01cd0041b7a5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01cd0041b7a5a573cba99332d1c30a82999d7fc1 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642bf1ac54fd39a7de79e923

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bf1ac54fd39a7de79e928
        failing since 4 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T09:45:00.886712  <8>[    9.788659] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9857207_1.4.2.3.1>

    2023-04-04T09:45:00.890404  + set +x

    2023-04-04T09:45:00.998030  / # #

    2023-04-04T09:45:01.100464  export SHELL=3D/bin/sh

    2023-04-04T09:45:01.101142  #

    2023-04-04T09:45:01.202968  / # export SHELL=3D/bin/sh. /lava-9857207/e=
nvironment

    2023-04-04T09:45:01.203606  =


    2023-04-04T09:45:01.305250  / # . /lava-9857207/environment/lava-985720=
7/bin/lava-test-runner /lava-9857207/1

    2023-04-04T09:45:01.306268  =


    2023-04-04T09:45:01.312570  / # /lava-9857207/bin/lava-test-runner /lav=
a-9857207/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642bf1936c4d2d364579e96c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bf1936c4d2d364579e971
        failing since 4 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T09:44:31.609858  + <8>[   10.991260] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9857195_1.4.2.3.1>

    2023-04-04T09:44:31.609946  set +x

    2023-04-04T09:44:31.715188  / # #

    2023-04-04T09:44:31.816266  export SHELL=3D/bin/sh

    2023-04-04T09:44:31.816421  #

    2023-04-04T09:44:31.917338  / # export SHELL=3D/bin/sh. /lava-9857195/e=
nvironment

    2023-04-04T09:44:31.917494  =


    2023-04-04T09:44:32.018463  / # . /lava-9857195/environment/lava-985719=
5/bin/lava-test-runner /lava-9857195/1

    2023-04-04T09:44:32.018699  =


    2023-04-04T09:44:32.023911  / # /lava-9857195/bin/lava-test-runner /lav=
a-9857195/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642bf1978531988a9b79e954

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bf1978531988a9b79e959
        failing since 4 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T09:44:46.156312  <8>[   10.994681] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9857185_1.4.2.3.1>

    2023-04-04T09:44:46.159617  + set +x

    2023-04-04T09:44:46.264918  #

    2023-04-04T09:44:46.368212  / # #export SHELL=3D/bin/sh

    2023-04-04T09:44:46.369036  =


    2023-04-04T09:44:46.471019  / # export SHELL=3D/bin/sh. /lava-9857185/e=
nvironment

    2023-04-04T09:44:46.471841  =


    2023-04-04T09:44:46.573692  / # . /lava-9857185/environment/lava-985718=
5/bin/lava-test-runner /lava-9857185/1

    2023-04-04T09:44:46.574995  =


    2023-04-04T09:44:46.580015  / # /lava-9857185/bin/lava-test-runner /lav=
a-9857185/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/642bf03cbe91c33eaa79e95c

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bf03cbe91c33eaa79e98f
        failing since 6 days (last pass: v6.1.21, first fail: v6.1.21-225-g=
e6bbee2ba76f)

    2023-04-04T09:38:41.814886  + set +x
    2023-04-04T09:38:41.819835  <8>[   17.482728] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 271996_1.5.2.4.1>
    2023-04-04T09:38:41.934507  / # #
    2023-04-04T09:38:42.036690  export SHELL=3D/bin/sh
    2023-04-04T09:38:42.037730  #
    2023-04-04T09:38:42.140152  / # export SHELL=3D/bin/sh. /lava-271996/en=
vironment
    2023-04-04T09:38:42.141010  =

    2023-04-04T09:38:42.243758  / # . /lava-271996/environment/lava-271996/=
bin/lava-test-runner /lava-271996/1
    2023-04-04T09:38:42.245022  =

    2023-04-04T09:38:42.251170  / # /lava-271996/bin/lava-test-runner /lava=
-271996/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642bf2185562f6520579e934

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bf2185562f6520579e939
        failing since 4 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T09:46:50.245914  + set +x

    2023-04-04T09:46:50.251989  <8>[   10.643571] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9857241_1.4.2.3.1>

    2023-04-04T09:46:50.360292  / # #

    2023-04-04T09:46:50.462766  export SHELL=3D/bin/sh

    2023-04-04T09:46:50.463536  #

    2023-04-04T09:46:50.565416  / # export SHELL=3D/bin/sh. /lava-9857241/e=
nvironment

    2023-04-04T09:46:50.566206  =


    2023-04-04T09:46:50.668331  / # . /lava-9857241/environment/lava-985724=
1/bin/lava-test-runner /lava-9857241/1

    2023-04-04T09:46:50.669636  =


    2023-04-04T09:46:50.674530  / # /lava-9857241/bin/lava-test-runner /lav=
a-9857241/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642bf1818bc343144179e94c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bf1818bc343144179e951
        failing since 4 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T09:44:19.838899  <8>[   10.447934] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9857186_1.4.2.3.1>

    2023-04-04T09:44:19.841876  + set +x

    2023-04-04T09:44:19.943909  =


    2023-04-04T09:44:20.044934  / # #export SHELL=3D/bin/sh

    2023-04-04T09:44:20.045141  =


    2023-04-04T09:44:20.146060  / # export SHELL=3D/bin/sh. /lava-9857186/e=
nvironment

    2023-04-04T09:44:20.146262  =


    2023-04-04T09:44:20.247172  / # . /lava-9857186/environment/lava-985718=
6/bin/lava-test-runner /lava-9857186/1

    2023-04-04T09:44:20.247511  =


    2023-04-04T09:44:20.252646  / # /lava-9857186/bin/lava-test-runner /lav=
a-9857186/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642bf1ae85ae90e08379e988

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bf1ae85ae90e08379e98d
        failing since 4 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T09:44:54.191042  + set<8>[    8.642219] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9857232_1.4.2.3.1>

    2023-04-04T09:44:54.191540   +x

    2023-04-04T09:44:54.299425  / # #

    2023-04-04T09:44:54.400434  export SHELL=3D/bin/sh

    2023-04-04T09:44:54.400649  #

    2023-04-04T09:44:54.501389  / # export SHELL=3D/bin/sh. /lava-9857232/e=
nvironment

    2023-04-04T09:44:54.501606  =


    2023-04-04T09:44:54.602595  / # . /lava-9857232/environment/lava-985723=
2/bin/lava-test-runner /lava-9857232/1

    2023-04-04T09:44:54.603855  =


    2023-04-04T09:44:54.608285  / # /lava-9857232/bin/lava-test-runner /lav=
a-9857232/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642bf19a8531988a9b79e977

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
182-g01cd0041b7a5a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bf19a8531988a9b79e97c
        failing since 4 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T09:44:45.370965  + set<8>[   10.883562] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9857227_1.4.2.3.1>

    2023-04-04T09:44:45.371465   +x

    2023-04-04T09:44:45.479161  / # #

    2023-04-04T09:44:45.581624  export SHELL=3D/bin/sh

    2023-04-04T09:44:45.582409  #

    2023-04-04T09:44:45.684227  / # export SHELL=3D/bin/sh. /lava-9857227/e=
nvironment

    2023-04-04T09:44:45.685047  =


    2023-04-04T09:44:45.786922  / # . /lava-9857227/environment/lava-985722=
7/bin/lava-test-runner /lava-9857227/1

    2023-04-04T09:44:45.788237  =


    2023-04-04T09:44:45.792584  / # /lava-9857227/bin/lava-test-runner /lav=
a-9857227/1
 =

    ... (12 line(s) more)  =

 =20
