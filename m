Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3376E6113
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjDRMUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjDRMUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:20:40 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CC01BC0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:20:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-246bb512038so1795400a91.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681820437; x=1684412437;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0xyWu8bOqFkI1eQwMEGUS0zO4pCCmLhcMBEJ1DGjxsE=;
        b=riCkE6VdKMBxg2a+4DO4/XQWaD75QEMkxEU7zctCInB2NAFl0NBbluve17N+IUXAhU
         mlvG9kGXLz7TYgD/mswg+ZScJ8W+OX4+Y6b1AQe6nXJOpYo81opThvBgaveWEqry1NqQ
         jA0KB5K/DyanvqDVIQopIfZlw4kIQt3FnsTPDHR48B88cCtXn26+DLpeoMuCRdsWti41
         a4GKE3pW6oFfPduaEgJeEdKBoXT3a7HNEJv4Dfkmbw818TqCT43Cdv9NKNCW28iOdJD9
         +LuaR9ufvRKXNG9MBPPGq+vZdw/QU1um72alWOXnAv0/oryDqWZFWwym+CJlPyeSKxxf
         zVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681820437; x=1684412437;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0xyWu8bOqFkI1eQwMEGUS0zO4pCCmLhcMBEJ1DGjxsE=;
        b=NrHP4zRtT3TWgx7pCR0wG/YMfpd9x0NEgIsbh+5/psiOAP5Zw3081/xpeY78ccILJe
         4+Gomv4eJcvFB2NUqc+AP7Y2Vwn83wuutEzQSqEWHQ4peaWxnxBYMugCUcHCP/0sjYLF
         FwmHKRL48cPGIAnFPugV6ZsmAyG5RXTXzQ3yP5P55K10W5RFD75IAvIpcS/0wEggXt9U
         J/rdAQzSsEFLhqgF2L3597S3ZnTsqk6om0JXTl2a8V0y3ULq/uklVk+MZx7gvdWH9iJK
         vdvpomdntn+tqcty+CG8C7Axbjp4di9Q/0seIy1uS3fyg13K/n6BnFvZU0nchev/1WpW
         +Dsw==
X-Gm-Message-State: AAQBX9fIFrz1GXT9x6gsdzou20vp7dhTw1oq2yHrhh4l4dgiWXukZGY0
        1oI118J1vP9RXhpX8ericeX1zghMk3icRibUZdj/aae+
X-Google-Smtp-Source: AKy350YSB3v2PyElgHg7jtJFNHdfksJ8fAlIYXDBOo3fZy6udQTD3iKKIN8qiUcgFSDi6T+cyC+Lhg==
X-Received: by 2002:a17:90a:f00b:b0:249:6fc1:cd76 with SMTP id bt11-20020a17090af00b00b002496fc1cd76mr874761pjb.43.1681820437155;
        Tue, 18 Apr 2023 05:20:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n18-20020a17090ade9200b00246cf1a8d3dsm8648531pjv.17.2023.04.18.05.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 05:20:36 -0700 (PDT)
Message-ID: <643e8b14.170a0220.d66c6.307f@mx.google.com>
Date:   Tue, 18 Apr 2023 05:20:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-479-g35f051d5ebe4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 187 runs,
 9 regressions (v6.1.22-479-g35f051d5ebe4)
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

stable-rc/queue/6.1 baseline: 187 runs, 9 regressions (v6.1.22-479-g35f051d=
5ebe4)

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

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-479-g35f051d5ebe4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-479-g35f051d5ebe4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35f051d5ebe48e8f06e6ade08ee74a03ab52a874 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e572a2a46e767952e8602

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e572a2a46e767952e8607
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T08:38:44.660413  <8>[   10.406508] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024537_1.4.2.3.1>

    2023-04-18T08:38:44.663711  + set +x

    2023-04-18T08:38:44.771596  / # #

    2023-04-18T08:38:44.872548  export SHELL=3D/bin/sh

    2023-04-18T08:38:44.872718  #

    2023-04-18T08:38:44.973557  / # export SHELL=3D/bin/sh. /lava-10024537/=
environment

    2023-04-18T08:38:44.973803  =


    2023-04-18T08:38:45.074828  / # . /lava-10024537/environment/lava-10024=
537/bin/lava-test-runner /lava-10024537/1

    2023-04-18T08:38:45.075100  =


    2023-04-18T08:38:45.080528  / # /lava-10024537/bin/lava-test-runner /la=
va-10024537/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e56a0ed7ba86c062e863a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e56a0ed7ba86c062e863f
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T08:36:29.668273  + set<8>[   11.522596] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10024519_1.4.2.3.1>

    2023-04-18T08:36:29.668853   +x

    2023-04-18T08:36:29.776549  / # #

    2023-04-18T08:36:29.879790  export SHELL=3D/bin/sh

    2023-04-18T08:36:29.880582  #

    2023-04-18T08:36:29.982389  / # export SHELL=3D/bin/sh. /lava-10024519/=
environment

    2023-04-18T08:36:29.983073  =


    2023-04-18T08:36:30.084858  / # . /lava-10024519/environment/lava-10024=
519/bin/lava-test-runner /lava-10024519/1

    2023-04-18T08:36:30.085935  =


    2023-04-18T08:36:30.090977  / # /lava-10024519/bin/lava-test-runner /la=
va-10024519/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e56ad7fc5c364882e85f0

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e56ad7fc5c364882e85f5
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T08:36:55.840727  <8>[    9.804438] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024542_1.4.2.3.1>

    2023-04-18T08:36:55.843820  + set +x

    2023-04-18T08:36:55.948829  =


    2023-04-18T08:36:56.049781  / # #export SHELL=3D/bin/sh

    2023-04-18T08:36:56.049973  =


    2023-04-18T08:36:56.150847  / # export SHELL=3D/bin/sh. /lava-10024542/=
environment

    2023-04-18T08:36:56.151042  =


    2023-04-18T08:36:56.251997  / # . /lava-10024542/environment/lava-10024=
542/bin/lava-test-runner /lava-10024542/1

    2023-04-18T08:36:56.252267  =


    2023-04-18T08:36:56.256962  / # /lava-10024542/bin/lava-test-runner /la=
va-10024542/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643e58add2c24ad32b2e870e

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e58add2c24ad32b2e8740
        failing since 1 day (last pass: v6.1.22-446-gccec7b96e5e7, first fa=
il: v6.1.22-454-g7711a076dd12)

    2023-04-18T08:45:08.579065  + set +x
    2023-04-18T08:45:08.581637  <8>[   16.930440] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 343976_1.5.2.4.1>
    2023-04-18T08:45:08.696184  / # #
    2023-04-18T08:45:08.798654  export SHELL=3D/bin/sh
    2023-04-18T08:45:08.799485  #
    2023-04-18T08:45:08.900909  / # export SHELL=3D/bin/sh. /lava-343976/en=
vironment
    2023-04-18T08:45:08.901399  =

    2023-04-18T08:45:09.003529  / # . /lava-343976/environment/lava-343976/=
bin/lava-test-runner /lava-343976/1
    2023-04-18T08:45:09.004834  =

    2023-04-18T08:45:09.011323  / # /lava-343976/bin/lava-test-runner /lava=
-343976/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e56c3691a21b2fd2e861c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e56c3691a21b2fd2e8621
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T08:37:06.070107  + set +x

    2023-04-18T08:37:06.077057  <8>[   10.141898] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024516_1.4.2.3.1>

    2023-04-18T08:37:06.181673  / # #

    2023-04-18T08:37:06.282792  export SHELL=3D/bin/sh

    2023-04-18T08:37:06.283019  #

    2023-04-18T08:37:06.383923  / # export SHELL=3D/bin/sh. /lava-10024516/=
environment

    2023-04-18T08:37:06.384132  =


    2023-04-18T08:37:06.485117  / # . /lava-10024516/environment/lava-10024=
516/bin/lava-test-runner /lava-10024516/1

    2023-04-18T08:37:06.485421  =


    2023-04-18T08:37:06.490129  / # /lava-10024516/bin/lava-test-runner /la=
va-10024516/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e56ac728728b6e02e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e56ac728728b6e02e85ed
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T08:36:37.518507  <8>[   10.726339] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024574_1.4.2.3.1>

    2023-04-18T08:36:37.522213  + set +x

    2023-04-18T08:36:37.630881  / # #

    2023-04-18T08:36:37.734121  export SHELL=3D/bin/sh

    2023-04-18T08:36:37.734761  #

    2023-04-18T08:36:37.836390  / # export SHELL=3D/bin/sh. /lava-10024574/=
environment

    2023-04-18T08:36:37.836673  =


    2023-04-18T08:36:37.937749  / # . /lava-10024574/environment/lava-10024=
574/bin/lava-test-runner /lava-10024574/1

    2023-04-18T08:36:37.938020  =


    2023-04-18T08:36:37.942924  / # /lava-10024574/bin/lava-test-runner /la=
va-10024574/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e56ab1614b764bf2e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e56ab1614b764bf2e85ed
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T08:36:52.087215  + <8>[   11.159868] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10024558_1.4.2.3.1>

    2023-04-18T08:36:52.087303  set +x

    2023-04-18T08:36:52.192000  / # #

    2023-04-18T08:36:52.292993  export SHELL=3D/bin/sh

    2023-04-18T08:36:52.293162  #

    2023-04-18T08:36:52.394200  / # export SHELL=3D/bin/sh. /lava-10024558/=
environment

    2023-04-18T08:36:52.394402  =


    2023-04-18T08:36:52.495525  / # . /lava-10024558/environment/lava-10024=
558/bin/lava-test-runner /lava-10024558/1

    2023-04-18T08:36:52.495795  =


    2023-04-18T08:36:52.500601  / # /lava-10024558/bin/lava-test-runner /la=
va-10024558/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e569afc19a092c12e8626

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e569bfc19a092c12e862b
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T08:36:29.400304  + set<8>[   11.330652] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10024508_1.4.2.3.1>

    2023-04-18T08:36:29.400400   +x

    2023-04-18T08:36:29.505233  / # #

    2023-04-18T08:36:29.606406  export SHELL=3D/bin/sh

    2023-04-18T08:36:29.607111  #

    2023-04-18T08:36:29.708894  / # export SHELL=3D/bin/sh. /lava-10024508/=
environment

    2023-04-18T08:36:29.709819  =


    2023-04-18T08:36:29.811689  / # . /lava-10024508/environment/lava-10024=
508/bin/lava-test-runner /lava-10024508/1

    2023-04-18T08:36:29.812515  =


    2023-04-18T08:36:29.817549  / # /lava-10024508/bin/lava-test-runner /la=
va-10024508/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5817a03f9c6c012e860f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g35f051d5ebe4/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5817a03f9c6c012e8=
610
        new failure (last pass: v6.1.22-462-g16a9aa862d1a) =

 =20
