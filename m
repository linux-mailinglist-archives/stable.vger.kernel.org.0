Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479716DFA23
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 17:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjDLPbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 11:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjDLPbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 11:31:11 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D359003
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:30:45 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w11so11783902plp.13
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681313444; x=1683905444;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=EQy7venH6aGybXanKq6ie6tqvbAkz4YRt5If3hhSu7Y=;
        b=FTr6hz2MoChT7gn4G9sWnNROd2XvshQJYrBSk8Pd1S7Psj0MfJtvIA057xBwYzwbON
         w+w/JwDgBAXBO8EdEGwVnya16o04foUPSwQVjbE3/8Q/8rdqPZUzJ5HTrRQChQ4dIIYu
         Twrn16d+TyxRS3Jk35iA4TlWYKPbFiBuC1MpbGb8SS6iuI0tMeMlM4jGTRIDPWfiEBqX
         9BtSCLg9d+ZSoMu9DP5VxfbWHIG39rtIrgai5XPjH/QjjPHK7G7QDYKn9hTfQW35H+V5
         k7ok3kJ5MW1gLgj+HlpT69sfadFGf65KBwUcxmKRMdDe0pCnO9+2+r1/8UySWDtbVHTz
         GPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681313444; x=1683905444;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EQy7venH6aGybXanKq6ie6tqvbAkz4YRt5If3hhSu7Y=;
        b=J8ByFb6+4SZiiJ1D4+QHxLt7NvvjEsR2pqEhgHoRWwwbyhpsZkVUnjd1j7hBJrw7MU
         VIBg6uBMIRV6PYFOHJ6Ze+P1fV8CxKlXNGHu14l2gW70HEWKRff1RMaXKQ+u6KDU2ujY
         eoLj7qGsZBbG2UF4IaspmwsJj6wcMIpHnG7ZN23BEMSPyl7fCE1xmzPELOhPC+AnnJTY
         nK4Ycq6K6rj6TggQRVuN8oQq24og4+dwziDoWkFat91gIpeVGIoi2kaj94i2nJd31yyY
         0e+dL9pL7RBIlERIJYk/4kdJipeQdv0X3PpdT/wWjdgRUbkzXNG7wmAaqGWpCZ/bMfDl
         NpnQ==
X-Gm-Message-State: AAQBX9f+K15lpgpO/yhK/h0mAXaEOXOEpVPfTjsid6y/uZLaCWSzu4nE
        uzeY1iXxTCBQUEeAHYYBshbLnOYUBKBEOqmYJwpLyQ==
X-Google-Smtp-Source: AKy350ZNZEJM1bqICu+8WhZX17M4cGhFnj9dgqDrMhpRVau3kxx1i+zZ7va4llhNUVzxoI2EqkwHBA==
X-Received: by 2002:a17:902:f545:b0:1a6:3d40:d74b with SMTP id h5-20020a170902f54500b001a63d40d74bmr3948849plf.16.1681313444123;
        Wed, 12 Apr 2023 08:30:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z24-20020a1709028f9800b0019aeddce6casm10109022plo.205.2023.04.12.08.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 08:30:43 -0700 (PDT)
Message-ID: <6436cea3.170a0220.341db.47a7@mx.google.com>
Date:   Wed, 12 Apr 2023 08:30:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-194-g415a9d81c640
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 179 runs,
 11 regressions (v5.15.105-194-g415a9d81c640)
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

stable-rc/linux-5.15.y baseline: 179 runs, 11 regressions (v5.15.105-194-g4=
15a9d81c640)

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

fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

meson-gxl-s905d-p230         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105-194-g415a9d81c640/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105-194-g415a9d81c640
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      415a9d81c640534731472ca364ec9cb77008a8e0 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64369d8867e87189082e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64369d8867e87189082e85fc
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-12T12:00:52.335854  <8>[   11.167467] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948367_1.4.2.3.1>

    2023-04-12T12:00:52.340217  + set +x

    2023-04-12T12:00:52.447866  / # #

    2023-04-12T12:00:52.550354  export SHELL=3D/bin/sh

    2023-04-12T12:00:52.551219  #

    2023-04-12T12:00:52.653184  / # export SHELL=3D/bin/sh. /lava-9948367/e=
nvironment

    2023-04-12T12:00:52.653479  =


    2023-04-12T12:00:52.754614  / # . /lava-9948367/environment/lava-994836=
7/bin/lava-test-runner /lava-9948367/1

    2023-04-12T12:00:52.754871  =


    2023-04-12T12:00:52.760585  / # /lava-9948367/bin/lava-test-runner /lav=
a-9948367/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64369cd69fa22c6d272e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64369cd69fa22c6d272e8606
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-12T11:58:07.166660  + set<8>[   11.720488] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9948361_1.4.2.3.1>

    2023-04-12T11:58:07.166801   +x

    2023-04-12T11:58:07.271731  / # #

    2023-04-12T11:58:07.372924  export SHELL=3D/bin/sh

    2023-04-12T11:58:07.373172  #

    2023-04-12T11:58:07.474171  / # export SHELL=3D/bin/sh. /lava-9948361/e=
nvironment

    2023-04-12T11:58:07.474455  =


    2023-04-12T11:58:07.575459  / # . /lava-9948361/environment/lava-994836=
1/bin/lava-test-runner /lava-9948361/1

    2023-04-12T11:58:07.575860  =


    2023-04-12T11:58:07.580568  / # /lava-9948361/bin/lava-test-runner /lav=
a-9948361/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64369cd585cc6ef86c2e8616

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64369cd585cc6ef86c2e861b
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-12T11:58:05.845652  <8>[   10.864386] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948335_1.4.2.3.1>

    2023-04-12T11:58:05.848894  + set +x

    2023-04-12T11:58:05.950436  #

    2023-04-12T11:58:05.950728  =


    2023-04-12T11:58:06.051653  / # #export SHELL=3D/bin/sh

    2023-04-12T11:58:06.051902  =


    2023-04-12T11:58:06.152847  / # export SHELL=3D/bin/sh. /lava-9948335/e=
nvironment

    2023-04-12T11:58:06.153058  =


    2023-04-12T11:58:06.254025  / # . /lava-9948335/environment/lava-994833=
5/bin/lava-test-runner /lava-9948335/1

    2023-04-12T11:58:06.254320  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64369d8a4aee3201632e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64369d8a4aee3201632e8=
5e7
        failing since 334 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64369b1ec69a9f1c2e2e8614

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64369b1ec69a9f1c2e2e8619
        failing since 85 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-04-12T11:50:43.244267  <8>[    9.953719] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3489031_1.5.2.4.1>
    2023-04-12T11:50:43.351394  / # #
    2023-04-12T11:50:43.453023  export SHELL=3D/bin/sh
    2023-04-12T11:50:43.453455  #
    2023-04-12T11:50:43.554886  / # export SHELL=3D/bin/sh. /lava-3489031/e=
nvironment
    2023-04-12T11:50:43.555305  =

    2023-04-12T11:50:43.656589  / # . /lava-3489031/environment/lava-348903=
1/bin/lava-test-runner /lava-3489031/1
    2023-04-12T11:50:43.657239  <3>[   10.273592] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-04-12T11:50:43.657429  =

    2023-04-12T11:50:43.662441  / # /lava-3489031/bin/lava-test-runner /lav=
a-3489031/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64369d36815d4e2b2e2e86c3

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64369d36815d4e2b2e2e86c8
        failing since 39 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-04-12T11:59:26.820590  [   10.844887] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1198069_1.5.2.4.1>
    2023-04-12T11:59:26.926065  / # #
    2023-04-12T11:59:27.027671  export SHELL=3D/bin/sh
    2023-04-12T11:59:27.028142  #
    2023-04-12T11:59:27.129542  / # export SHELL=3D/bin/sh. /lava-1198069/e=
nvironment
    2023-04-12T11:59:27.130095  =

    2023-04-12T11:59:27.231700  / # . /lava-1198069/environment/lava-119806=
9/bin/lava-test-runner /lava-1198069/1
    2023-04-12T11:59:27.232248  =

    2023-04-12T11:59:27.233934  / # /lava-1198069/bin/lava-test-runner /lav=
a-1198069/1
    2023-04-12T11:59:27.252044  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a08054d212b8512e85ec

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a08054d212b8512e85f1
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-12T12:13:36.605397  + set +x

    2023-04-12T12:13:36.611825  <8>[   10.885651] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948316_1.4.2.3.1>

    2023-04-12T12:13:36.716527  / # #

    2023-04-12T12:13:36.817596  export SHELL=3D/bin/sh

    2023-04-12T12:13:36.817799  #

    2023-04-12T12:13:36.918698  / # export SHELL=3D/bin/sh. /lava-9948316/e=
nvironment

    2023-04-12T12:13:36.918940  =


    2023-04-12T12:13:37.019908  / # . /lava-9948316/environment/lava-994831=
6/bin/lava-test-runner /lava-9948316/1

    2023-04-12T12:13:37.020261  =


    2023-04-12T12:13:37.024770  / # /lava-9948316/bin/lava-test-runner /lav=
a-9948316/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64369e78a74acbd4502e8600

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64369e78a74acbd4502e8605
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-12T12:04:49.700719  + set +x

    2023-04-12T12:04:49.707186  <8>[    7.976749] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948355_1.4.2.3.1>

    2023-04-12T12:04:49.809465  =


    2023-04-12T12:04:49.910441  / # #export SHELL=3D/bin/sh

    2023-04-12T12:04:49.910609  =


    2023-04-12T12:04:50.011523  / # export SHELL=3D/bin/sh. /lava-9948355/e=
nvironment

    2023-04-12T12:04:50.011711  =


    2023-04-12T12:04:50.112676  / # . /lava-9948355/environment/lava-994835=
5/bin/lava-test-runner /lava-9948355/1

    2023-04-12T12:04:50.112937  =


    2023-04-12T12:04:50.118253  / # /lava-9948355/bin/lava-test-runner /lav=
a-9948355/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64369cd441ad360c9f2e8616

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64369cd441ad360c9f2e861b
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-12T11:57:52.404854  + set<8>[   11.095375] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9948318_1.4.2.3.1>

    2023-04-12T11:57:52.404935   +x

    2023-04-12T11:57:52.509762  / # #

    2023-04-12T11:57:52.610718  export SHELL=3D/bin/sh

    2023-04-12T11:57:52.610911  #

    2023-04-12T11:57:52.711828  / # export SHELL=3D/bin/sh. /lava-9948318/e=
nvironment

    2023-04-12T11:57:52.712014  =


    2023-04-12T11:57:52.812896  / # . /lava-9948318/environment/lava-994831=
8/bin/lava-test-runner /lava-9948318/1

    2023-04-12T11:57:52.813199  =


    2023-04-12T11:57:52.817696  / # /lava-9948318/bin/lava-test-runner /lav=
a-9948318/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64369ce8fa09fbb6882e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64369ce8fa09fbb6882e8606
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-12T11:58:09.153344  <8>[   11.314644] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948345_1.4.2.3.1>

    2023-04-12T11:58:09.257942  / # #

    2023-04-12T11:58:09.360881  export SHELL=3D/bin/sh

    2023-04-12T11:58:09.361575  #

    2023-04-12T11:58:09.463373  / # export SHELL=3D/bin/sh. /lava-9948345/e=
nvironment

    2023-04-12T11:58:09.464225  =


    2023-04-12T11:58:09.566001  / # . /lava-9948345/environment/lava-994834=
5/bin/lava-test-runner /lava-9948345/1

    2023-04-12T11:58:09.566271  =


    2023-04-12T11:58:09.570944  / # /lava-9948345/bin/lava-test-runner /lav=
a-9948345/1

    2023-04-12T11:58:09.576552  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
meson-gxl-s905d-p230         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64369dd74aee3201632e864f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-194-g415a9d81c640/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64369dd74aee3201632e8=
650
        new failure (last pass: v5.15.105-100-gaacd621499911) =

 =20
