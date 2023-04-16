Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6568D6E3A7F
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjDPR1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDPR1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:27:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2527726B9
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 10:27:04 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z11-20020a17090abd8b00b0024721c47ceaso9856724pjr.3
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 10:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681666023; x=1684258023;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eJIxYwY7xHHE/GQdSK9UmiBSI1M0K4ieUCZ3ey2a65M=;
        b=EL4ZTr5rkobkqGAKrgpB0W33w0MrjpFStG6yNtm3Fsd6z0BHRtVHLj+KSAXdQxJ3Sh
         yZ2HwEkrST4HL2lf74RFEAyDYHba8Ll3iCuvQ9Ihze954xhkh/PQf4URc7i2hiAw/Fjc
         NWYuYj07o/yeo1JBcMnoTM5q7YCo3Lo8sD1nleRg2Cc2zie9chgfmRRqr36Z1yipJiMT
         ZJtaCaqIW+VHx6Hsh4BJXmQmZCPCADRsVrvAPZyr+t9Ni/955ZBpi8RH2p24hGW641jB
         erMYdPmTg84O54ukMUsdAohasIwOg8t005m1iQYmwI6wZfkYZHOG4gxArwcI51G3G3+a
         KQ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681666023; x=1684258023;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eJIxYwY7xHHE/GQdSK9UmiBSI1M0K4ieUCZ3ey2a65M=;
        b=WLvOPWxOleoKEz+dv5iVgCOKoPYeuesbKhigv/q0fwEcnb+7OFSmY6NmuuxVGWrppc
         BNC3/tccKi9X6CQ/xAcAYGqu061xFLxmrLDkwsr0Od1PAzM7il0nV4cdIBXA2Juz9HU+
         aZxx5XqW+s+/BzxCwhlwgWR+vrQuxQ7WWfdy09YpeyFr4+WEpYBvdn9oS8euxeitYorg
         QV45p2dsrf1Kj80VJBA2Hdh2gy0oSZEUj16Euc4EQxIBG5+xLkSccnDRW5H0fmvddvw2
         b5z15a/tsmdVIZzk5FUKwbAMwO6jzF6x/dRp/JkT4y+xztcn79Pkpq5a/ORNC+1ll5t8
         mhOQ==
X-Gm-Message-State: AAQBX9eDXRtuWq09ctkelYyadFg5zt+CmLbrhuXbfCDkQkfp1Lbg+dWD
        kyL9xeLSekVBxRgz3BaqbjsIu/aQqjoWkMUpCLyu2Zzr
X-Google-Smtp-Source: AKy350bcL8gyBBi+BVmn/xszU3ibLy5IEdmUGiaww9b/aVeaGxSY0yt9V9+OSM/MO7ynahoeU4dE5g==
X-Received: by 2002:a05:6a20:160a:b0:ee:3824:664f with SMTP id l10-20020a056a20160a00b000ee3824664fmr11721432pzj.47.1681666023171;
        Sun, 16 Apr 2023 10:27:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 20-20020a630f54000000b004fc1d91e695sm5548366pgp.79.2023.04.16.10.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 10:27:02 -0700 (PDT)
Message-ID: <643c2fe6.630a0220.6154f.bea1@mx.google.com>
Date:   Sun, 16 Apr 2023 10:27:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-438-gda4a613e2013
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 180 runs,
 8 regressions (v6.1.22-438-gda4a613e2013)
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

stable-rc/queue/6.1 baseline: 180 runs, 8 regressions (v6.1.22-438-gda4a613=
e2013)

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
el/v6.1.22-438-gda4a613e2013/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-438-gda4a613e2013
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da4a613e2013b9e8e8d89a4e17273e1a9c710074 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bfbebc1ba4784b72e8610

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bfbebc1ba4784b72e8615
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T13:44:58.670174  + set +x

    2023-04-16T13:44:58.676858  <8>[   10.547695] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005733_1.4.2.3.1>

    2023-04-16T13:44:58.779412  =


    2023-04-16T13:44:58.880527  / # #export SHELL=3D/bin/sh

    2023-04-16T13:44:58.880714  =


    2023-04-16T13:44:58.981651  / # export SHELL=3D/bin/sh. /lava-10005733/=
environment

    2023-04-16T13:44:58.981829  =


    2023-04-16T13:44:59.082884  / # . /lava-10005733/environment/lava-10005=
733/bin/lava-test-runner /lava-10005733/1

    2023-04-16T13:44:59.083159  =


    2023-04-16T13:44:59.089021  / # /lava-10005733/bin/lava-test-runner /la=
va-10005733/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bfbf0b3780aa16c2e865a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bfbf0b3780aa16c2e865f
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T13:44:56.400710  + <8>[   11.355852] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10005755_1.4.2.3.1>

    2023-04-16T13:44:56.400799  set +x

    2023-04-16T13:44:56.505548  / # #

    2023-04-16T13:44:56.606508  export SHELL=3D/bin/sh

    2023-04-16T13:44:56.606696  #

    2023-04-16T13:44:56.707609  / # export SHELL=3D/bin/sh. /lava-10005755/=
environment

    2023-04-16T13:44:56.707803  =


    2023-04-16T13:44:56.808740  / # . /lava-10005755/environment/lava-10005=
755/bin/lava-test-runner /lava-10005755/1

    2023-04-16T13:44:56.809024  =


    2023-04-16T13:44:56.813772  / # /lava-10005755/bin/lava-test-runner /la=
va-10005755/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bfbebb3780aa16c2e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bfbebb3780aa16c2e860d
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T13:45:09.434614  <8>[   11.006216] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005778_1.4.2.3.1>

    2023-04-16T13:45:09.437654  + set +x

    2023-04-16T13:45:09.539523  =


    2023-04-16T13:45:09.640531  / # #export SHELL=3D/bin/sh

    2023-04-16T13:45:09.640748  =


    2023-04-16T13:45:09.741557  / # export SHELL=3D/bin/sh. /lava-10005778/=
environment

    2023-04-16T13:45:09.741828  =


    2023-04-16T13:45:09.842827  / # . /lava-10005778/environment/lava-10005=
778/bin/lava-test-runner /lava-10005778/1

    2023-04-16T13:45:09.843129  =


    2023-04-16T13:45:09.848561  / # /lava-10005778/bin/lava-test-runner /la=
va-10005778/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf9469b9fc123962e85e8

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf9469b9fc123962e861a
        failing since 0 day (last pass: v6.1.22-364-gf7dc7e601a2a, first fa=
il: v6.1.22-364-g39097b93e319)

    2023-04-16T13:33:42.026534  + set +x
    2023-04-16T13:33:42.031379  <8>[   17.432999] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 337254_1.5.2.4.1>
    2023-04-16T13:33:42.144924  / # #
    2023-04-16T13:33:42.248071  export SHELL=3D/bin/sh
    2023-04-16T13:33:42.248790  #
    2023-04-16T13:33:42.350663  / # export SHELL=3D/bin/sh. /lava-337254/en=
vironment
    2023-04-16T13:33:42.351338  =

    2023-04-16T13:33:42.452513  / # . /lava-337254/environment/lava-337254/=
bin/lava-test-runner /lava-337254/1
    2023-04-16T13:33:42.453941  =

    2023-04-16T13:33:42.459872  / # /lava-337254/bin/lava-test-runner /lava=
-337254/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bfbd600560d21492e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bfbd600560d21492e85eb
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T13:44:45.452445  + set +x

    2023-04-16T13:44:45.458934  <8>[   10.236895] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005754_1.4.2.3.1>

    2023-04-16T13:44:45.563918  / # #

    2023-04-16T13:44:45.665076  export SHELL=3D/bin/sh

    2023-04-16T13:44:45.665304  #

    2023-04-16T13:44:45.766050  / # export SHELL=3D/bin/sh. /lava-10005754/=
environment

    2023-04-16T13:44:45.766263  =


    2023-04-16T13:44:45.867179  / # . /lava-10005754/environment/lava-10005=
754/bin/lava-test-runner /lava-10005754/1

    2023-04-16T13:44:45.867483  =


    2023-04-16T13:44:45.871640  / # /lava-10005754/bin/lava-test-runner /la=
va-10005754/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bfbebfd9203f27d2e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bfbebfd9203f27d2e85ed
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T13:44:53.562378  <8>[   10.792725] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005740_1.4.2.3.1>

    2023-04-16T13:44:53.566066  + set +x

    2023-04-16T13:44:53.670837  #

    2023-04-16T13:44:53.671143  =


    2023-04-16T13:44:53.772041  / # #export SHELL=3D/bin/sh

    2023-04-16T13:44:53.772233  =


    2023-04-16T13:44:53.873156  / # export SHELL=3D/bin/sh. /lava-10005740/=
environment

    2023-04-16T13:44:53.873352  =


    2023-04-16T13:44:53.974318  / # . /lava-10005740/environment/lava-10005=
740/bin/lava-test-runner /lava-10005740/1

    2023-04-16T13:44:53.974608  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bfbe818e7fed51e2e8600

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bfbe818e7fed51e2e8605
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T13:44:49.514775  + set<8>[   11.122228] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10005749_1.4.2.3.1>

    2023-04-16T13:44:49.514889   +x

    2023-04-16T13:44:49.619425  / # #

    2023-04-16T13:44:49.720386  export SHELL=3D/bin/sh

    2023-04-16T13:44:49.720632  #

    2023-04-16T13:44:49.821596  / # export SHELL=3D/bin/sh. /lava-10005749/=
environment

    2023-04-16T13:44:49.821857  =


    2023-04-16T13:44:49.922676  / # . /lava-10005749/environment/lava-10005=
749/bin/lava-test-runner /lava-10005749/1

    2023-04-16T13:44:49.923019  =


    2023-04-16T13:44:49.927121  / # /lava-10005749/bin/lava-test-runner /la=
va-10005749/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bfbd285dc2bd22a2e860f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-43=
8-gda4a613e2013/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bfbd285dc2bd22a2e8614
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T13:44:39.648229  <8>[   12.403279] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005730_1.4.2.3.1>

    2023-04-16T13:44:39.753047  / # #

    2023-04-16T13:44:39.853992  export SHELL=3D/bin/sh

    2023-04-16T13:44:39.854148  #

    2023-04-16T13:44:39.954990  / # export SHELL=3D/bin/sh. /lava-10005730/=
environment

    2023-04-16T13:44:39.955165  =


    2023-04-16T13:44:40.056041  / # . /lava-10005730/environment/lava-10005=
730/bin/lava-test-runner /lava-10005730/1

    2023-04-16T13:44:40.056267  =


    2023-04-16T13:44:40.060899  / # /lava-10005730/bin/lava-test-runner /la=
va-10005730/1

    2023-04-16T13:44:40.067262  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
