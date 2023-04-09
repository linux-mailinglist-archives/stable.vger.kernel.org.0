Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C786DC0EA
	for <lists+stable@lfdr.de>; Sun,  9 Apr 2023 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDISGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Apr 2023 14:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDISGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Apr 2023 14:06:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4AF2707
        for <stable@vger.kernel.org>; Sun,  9 Apr 2023 11:06:49 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nh20-20020a17090b365400b0024496d637e1so8023992pjb.5
        for <stable@vger.kernel.org>; Sun, 09 Apr 2023 11:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681063609; x=1683655609;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Zgg4ByTHtbinE3XPveQX1AZDdp9D0qs3HY1QT/sDqDA=;
        b=57+a0nF9izacfbUJWz7HQfcccKbG15e34bNnxlfmlizmqvovM/Z+fO5YCV1dgK0RYb
         1d+p5KYrPDUGIkV0ESmKaoaxvw2HXAeou9Vz1lYFSa8Ps0Opqyzqs1JgpknJqKkhGlSv
         Baq02cfyu+tu4j65mq6vbKNVl22xRADbIEvZFAmQ4IfuayzNQEUCT36AxwPavNEsPmiT
         ZU0o5Le50HVG+wf7Am/xW6JiCN8sUwC/mMKWpC15dzA+muBjB7ZbDWCnFcr/pWi0cvvQ
         kki1One/GHbhFJCUCj8oODPTnWngR2BeQtIsV/LsUVzlg7HAAPF0CatBom7xjvIm0lgB
         7sqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681063609; x=1683655609;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zgg4ByTHtbinE3XPveQX1AZDdp9D0qs3HY1QT/sDqDA=;
        b=myeaUIpKmNpGoBpyncCBiVCCF+Ggb4dqYGKxTnPC4Xohdm7zdvpy8NqciTTDYsRK1p
         dFb/iMsbutKflR+gNnHhSyM9S6Nt1qP8fHNGnLN2ejM4/qWcbPPU2e4AWbCnTb2duQi1
         phx+TQRJ982PgyT7CYXoti1E/K5Dw6mXzgfeiI2zHqJVivQFo3IHi4tQABkjXHTmYXvk
         NYW0KWJDSEsRP+6BMzg7duHpWUBZfXkkwVzsI4CJDzttWFFNAJft5M567LmbWaHmMJVY
         0ZGN5Z7numXtMQzcOxGfhzia2EjZsj+urCOPIoklXpMHasM5FkvpzSfV/2HRl2GznGJo
         xLzg==
X-Gm-Message-State: AAQBX9d4O2SP+fKa+t/MTp+5zvB4h6h+qOsYQi3zcCz9SNHr1Ez7Lb+8
        6hIU2BEFrR9/1vnvL8brXOdEJhmFxVfUXwTr/Kk=
X-Google-Smtp-Source: AKy350bxey97k+ISe0CTbxXBnFagRLJcoqh5q57CgV6HF+QNFDPlGspG/dzqudhUTaUlXtqtvhldLw==
X-Received: by 2002:a17:903:22ce:b0:1a0:f8ba:ae55 with SMTP id y14-20020a17090322ce00b001a0f8baae55mr12657731plg.7.1681063608702;
        Sun, 09 Apr 2023 11:06:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ja1-20020a170902efc100b0019e30e3068bsm1816365plb.168.2023.04.09.11.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Apr 2023 11:06:48 -0700 (PDT)
Message-ID: <6432feb8.170a0220.e8879.2c09@mx.google.com>
Date:   Sun, 09 Apr 2023 11:06:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-234-g45cb819bb347
Subject: stable-rc/queue/6.1 baseline: 174 runs,
 8 regressions (v6.1.22-234-g45cb819bb347)
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

stable-rc/queue/6.1 baseline: 174 runs, 8 regressions (v6.1.22-234-g45cb819=
bb347)

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

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-234-g45cb819bb347/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-234-g45cb819bb347
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45cb819bb3473a28659c892cf7852a5f8233d475 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432ca94835f671b0479e941

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432ca94835f671b0479e94a
        failing since 11 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-09T14:24:07.846698  <8>[   10.612698] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9919816_1.4.2.3.1>

    2023-04-09T14:24:07.850158  + set +x

    2023-04-09T14:24:07.958055  / # #

    2023-04-09T14:24:08.060878  export SHELL=3D/bin/sh

    2023-04-09T14:24:08.061727  #

    2023-04-09T14:24:08.163641  / # export SHELL=3D/bin/sh. /lava-9919816/e=
nvironment

    2023-04-09T14:24:08.164457  =


    2023-04-09T14:24:08.266462  / # . /lava-9919816/environment/lava-991981=
6/bin/lava-test-runner /lava-9919816/1

    2023-04-09T14:24:08.267682  =


    2023-04-09T14:24:08.274629  / # /lava-9919816/bin/lava-test-runner /lav=
a-9919816/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432ca9c864edade6679e943

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432ca9c864edade6679e94c
        failing since 11 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-09T14:24:16.903562  + set<8>[   11.768776] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9919809_1.4.2.3.1>

    2023-04-09T14:24:16.904162   +x

    2023-04-09T14:24:17.013061  / # #

    2023-04-09T14:24:17.116231  export SHELL=3D/bin/sh

    2023-04-09T14:24:17.117118  #

    2023-04-09T14:24:17.219378  / # export SHELL=3D/bin/sh. /lava-9919809/e=
nvironment

    2023-04-09T14:24:17.220380  =


    2023-04-09T14:24:17.322415  / # . /lava-9919809/environment/lava-991980=
9/bin/lava-test-runner /lava-9919809/1

    2023-04-09T14:24:17.323882  =


    2023-04-09T14:24:17.328380  / # /lava-9919809/bin/lava-test-runner /lav=
a-9919809/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432caa56ce0510a7979e954

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432caa56ce0510a7979e95d
        failing since 11 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-09T14:24:16.688537  <8>[    8.359860] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9919836_1.4.2.3.1>

    2023-04-09T14:24:16.692024  + set +x

    2023-04-09T14:24:16.793609  #

    2023-04-09T14:24:16.894817  / # #export SHELL=3D/bin/sh

    2023-04-09T14:24:16.894979  =


    2023-04-09T14:24:16.995977  / # export SHELL=3D/bin/sh. /lava-9919836/e=
nvironment

    2023-04-09T14:24:16.996141  =


    2023-04-09T14:24:17.097212  / # . /lava-9919836/environment/lava-991983=
6/bin/lava-test-runner /lava-9919836/1

    2023-04-09T14:24:17.098443  =


    2023-04-09T14:24:17.103873  / # /lava-9919836/bin/lava-test-runner /lav=
a-9919836/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432caeb967163b30a79e933

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432caeb967163b30a79e93c
        failing since 11 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-09T14:25:32.260310  + set +x

    2023-04-09T14:25:32.267114  <8>[   10.723418] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9919842_1.4.2.3.1>

    2023-04-09T14:25:32.375709  / # #

    2023-04-09T14:25:32.478421  export SHELL=3D/bin/sh

    2023-04-09T14:25:32.479212  #

    2023-04-09T14:25:32.581217  / # export SHELL=3D/bin/sh. /lava-9919842/e=
nvironment

    2023-04-09T14:25:32.582016  =


    2023-04-09T14:25:32.684155  / # . /lava-9919842/environment/lava-991984=
2/bin/lava-test-runner /lava-9919842/1

    2023-04-09T14:25:32.685556  =


    2023-04-09T14:25:32.690904  / # /lava-9919842/bin/lava-test-runner /lav=
a-9919842/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432ca8c835f671b0479e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432ca8c835f671b0479e92b
        failing since 11 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-09T14:23:58.338872  + set +x<8>[    9.919322] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9919780_1.4.2.3.1>

    2023-04-09T14:23:58.339310  =


    2023-04-09T14:23:58.446436  #

    2023-04-09T14:23:58.447437  =


    2023-04-09T14:23:58.549478  / # #export SHELL=3D/bin/sh

    2023-04-09T14:23:58.550101  =


    2023-04-09T14:23:58.651827  / # export SHELL=3D/bin/sh. /lava-9919780/e=
nvironment

    2023-04-09T14:23:58.652485  =


    2023-04-09T14:23:58.754260  / # . /lava-9919780/environment/lava-991978=
0/bin/lava-test-runner /lava-9919780/1

    2023-04-09T14:23:58.755377  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432caa408790f5b2279e961

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432caa408790f5b2279e96a
        failing since 11 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-09T14:24:17.713739  + set<8>[   10.975568] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9919783_1.4.2.3.1>

    2023-04-09T14:24:17.714216   +x

    2023-04-09T14:24:17.823604  / # #

    2023-04-09T14:24:17.926368  export SHELL=3D/bin/sh

    2023-04-09T14:24:17.927162  #

    2023-04-09T14:24:18.029085  / # export SHELL=3D/bin/sh. /lava-9919783/e=
nvironment

    2023-04-09T14:24:18.029926  =


    2023-04-09T14:24:18.132139  / # . /lava-9919783/environment/lava-991978=
3/bin/lava-test-runner /lava-9919783/1

    2023-04-09T14:24:18.133479  =


    2023-04-09T14:24:18.138683  / # /lava-9919783/bin/lava-test-runner /lav=
a-9919783/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432ca8cbc36d3f41a79e9b2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432ca8cbc36d3f41a79e9bb
        failing since 11 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-09T14:23:59.707368  <8>[   11.678360] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9919795_1.4.2.3.1>

    2023-04-09T14:23:59.811955  / # #

    2023-04-09T14:23:59.912965  export SHELL=3D/bin/sh

    2023-04-09T14:23:59.913168  #

    2023-04-09T14:24:00.014106  / # export SHELL=3D/bin/sh. /lava-9919795/e=
nvironment

    2023-04-09T14:24:00.014330  =


    2023-04-09T14:24:00.115345  / # . /lava-9919795/environment/lava-991979=
5/bin/lava-test-runner /lava-9919795/1

    2023-04-09T14:24:00.115623  =


    2023-04-09T14:24:00.120288  / # /lava-9919795/bin/lava-test-runner /lav=
a-9919795/1

    2023-04-09T14:24:00.126970  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/6432ccaedf719fc48179e92b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-23=
4-g45cb819bb347/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6432ccaedf719fc48179e=
92c
        new failure (last pass: v6.1.22-178-gaa9876e65686) =

 =20
