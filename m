Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C2E6DFA8D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 17:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDLPtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 11:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDLPtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 11:49:25 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E999F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:22 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i8so2864348plt.10
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681314561; x=1683906561;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=k5Tatzfegn+Czy45SeH8CmmuMcHxJGcj+qdmhpBSEq8=;
        b=pPBnQ92jjzLNQs+oEE9fiW92t5kWIeUHHOq31KJ+klBQFBIQqD+scYxS8R9eHtTc+B
         AVcmognRTbsTrgRyN0t99Ef2IhRheMiHskLEoXBSw/Q+1aGqBAOhXSV9pDDwP1XPd5Pw
         1+TBwm+6pcKAUDRdfh0ejTHj0vM4hC/NJEGIrohAI2xKKKL5nWIPBrLb0Byvvk4U0cTV
         w7WO5GWpfL+wbUPrNJoy5Bty59P9xeL8wzdYlcZ3vQHsRiCFLsGNbK5QhYdEAYv1R9TB
         P02jbmPCVBmNjUUNXVgcl4ADggtvePA/06f7yFQ6ajGvUY34xosZAMRD3cjeVr7JUAtI
         Tiew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681314561; x=1683906561;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k5Tatzfegn+Czy45SeH8CmmuMcHxJGcj+qdmhpBSEq8=;
        b=Zwr+MfAF4sQm67mqiwh6t1E7pIeejSws4jSbPTOaPIFcDKyLqwF0rNyaE0OepLKmmU
         XMkMAJD4LEDfnQ7XHdBD4PEuHbVlCEZ8HnzcEC2L+NGW3nN0hOAD+Fq3RSPZyDU5ftog
         bwWJJvbhVGhKHMyqzpYMPpu1jSNlsWLGeXa30Xcj32uGxAHAtGWMpOxedGVEeqw/uleR
         W94ZZ+8UlEeDDvCQ8HejxaK8RPNFboIuQAzDAMANsDEvK4n3lC6Xcm7+hrThNr/PW3Xn
         bD0Avohri5QQsXTQCQFgIw9NKy3rze0KYAQMpEi3kEeXShcbI0XKEQo9oxcA58W+bYCp
         BXFg==
X-Gm-Message-State: AAQBX9fyFSFJJF4GumUc4TtgqzYUfkPmWxlie+zk8ZABaeIKloGoU0mt
        Hymzaz6IWCyO+iblgLUjncw3AuX4cwvwrKuXQcr8ZA==
X-Google-Smtp-Source: AKy350ZdHX4eWtaFD9okuKEB0u8AhD9rOeosE6nm/zLpdlNk5NSqNkanYO4H24Wwrp5xSE84luSUlw==
X-Received: by 2002:a05:6a20:b388:b0:e9:5b0a:e7e7 with SMTP id eg8-20020a056a20b38800b000e95b0ae7e7mr3099829pzb.15.1681314561141;
        Wed, 12 Apr 2023 08:49:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q16-20020a62e110000000b006396be36457sm5356786pfh.111.2023.04.12.08.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 08:49:20 -0700 (PDT)
Message-ID: <6436d300.620a0220.1f4e4.b42f@mx.google.com>
Date:   Wed, 12 Apr 2023 08:49:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-343-gfc6bc40ea0ba
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 183 runs,
 10 regressions (v6.1.22-343-gfc6bc40ea0ba)
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

stable-rc/queue/6.1 baseline: 183 runs, 10 regressions (v6.1.22-343-gfc6bc4=
0ea0ba)

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

meson-gxl-s905d-p230         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-343-gfc6bc40ea0ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-343-gfc6bc40ea0ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc6bc40ea0ba3175647b80783687fc03ef03c591 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a1c069a3ce32412e8600

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a1c069a3ce32412e8605
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T12:18:53.219318  + set +x

    2023-04-12T12:18:53.226549  <8>[   10.503282] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948560_1.4.2.3.1>

    2023-04-12T12:18:53.334792  #

    2023-04-12T12:18:53.336050  =


    2023-04-12T12:18:53.438370  / # #export SHELL=3D/bin/sh

    2023-04-12T12:18:53.439141  =


    2023-04-12T12:18:53.541096  / # export SHELL=3D/bin/sh. /lava-9948560/e=
nvironment

    2023-04-12T12:18:53.541972  =


    2023-04-12T12:18:53.644122  / # . /lava-9948560/environment/lava-994856=
0/bin/lava-test-runner /lava-9948560/1

    2023-04-12T12:18:53.645400  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a0e5df6a3377d62e8610

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a0e5df6a3377d62e8615
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T12:15:18.049379  + set<8>[   12.151387] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9948529_1.4.2.3.1>

    2023-04-12T12:15:18.049489   +x

    2023-04-12T12:15:18.154464  / # #

    2023-04-12T12:15:18.255483  export SHELL=3D/bin/sh

    2023-04-12T12:15:18.255670  #

    2023-04-12T12:15:18.356463  / # export SHELL=3D/bin/sh. /lava-9948529/e=
nvironment

    2023-04-12T12:15:18.356639  =


    2023-04-12T12:15:18.457594  / # . /lava-9948529/environment/lava-994852=
9/bin/lava-test-runner /lava-9948529/1

    2023-04-12T12:15:18.457862  =


    2023-04-12T12:15:18.462505  / # /lava-9948529/bin/lava-test-runner /lav=
a-9948529/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a0e7df6a3377d62e8620

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a0e7df6a3377d62e8625
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T12:15:15.881139  <8>[    9.881423] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948525_1.4.2.3.1>

    2023-04-12T12:15:15.884386  + set +x

    2023-04-12T12:15:15.986167  / #

    2023-04-12T12:15:16.087388  # #export SHELL=3D/bin/sh

    2023-04-12T12:15:16.087572  =


    2023-04-12T12:15:16.188502  / # export SHELL=3D/bin/sh. /lava-9948525/e=
nvironment

    2023-04-12T12:15:16.188704  =


    2023-04-12T12:15:16.289641  / # . /lava-9948525/environment/lava-994852=
5/bin/lava-test-runner /lava-9948525/1

    2023-04-12T12:15:16.289923  =


    2023-04-12T12:15:16.294631  / # /lava-9948525/bin/lava-test-runner /lav=
a-9948525/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a001052ad24a042e85f7

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a001052ad24a042e8622
        failing since 0 day (last pass: v6.1.22-278-gb95c5e4f2816, first fa=
il: v6.1.22-327-g5d6cb90df983)

    2023-04-12T12:11:22.258522  + set +x
    2023-04-12T12:11:22.262179  <8>[   18.218115] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 317224_1.5.2.4.1>
    2023-04-12T12:11:22.378571  / # #
    2023-04-12T12:11:22.481125  export SHELL=3D/bin/sh
    2023-04-12T12:11:22.481743  #
    2023-04-12T12:11:22.583500  / # export SHELL=3D/bin/sh. /lava-317224/en=
vironment
    2023-04-12T12:11:22.583884  =

    2023-04-12T12:11:22.685545  / # . /lava-317224/environment/lava-317224/=
bin/lava-test-runner /lava-317224/1
    2023-04-12T12:11:22.686197  =

    2023-04-12T12:11:22.692917  / # /lava-317224/bin/lava-test-runner /lava=
-317224/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a0d28e620b69842e860a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a0d28e620b69842e860f
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T12:15:04.727466  <6>[   10.955491] lava-test-case (198) used=
 greatest stack depth: 13280 bytes left

    2023-04-12T12:15:04.727575  + set +x

    2023-04-12T12:15:04.733956  <8>[   10.963860] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948570_1.4.2.3.1>

    2023-04-12T12:15:04.838761  / # #

    2023-04-12T12:15:04.939888  export SHELL=3D/bin/sh

    2023-04-12T12:15:04.940076  #

    2023-04-12T12:15:05.041079  / # export SHELL=3D/bin/sh. /lava-9948570/e=
nvironment

    2023-04-12T12:15:05.041266  =


    2023-04-12T12:15:05.142246  / # . /lava-9948570/environment/lava-994857=
0/bin/lava-test-runner /lava-9948570/1

    2023-04-12T12:15:05.142679  =

 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a0d3df6a3377d62e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a0d3df6a3377d62e85ec
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T12:14:58.829984  + set +x<8>[   10.195748] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9948550_1.4.2.3.1>

    2023-04-12T12:14:58.830092  =


    2023-04-12T12:14:58.932575  #

    2023-04-12T12:14:59.033765  / # #export SHELL=3D/bin/sh

    2023-04-12T12:14:59.033913  =


    2023-04-12T12:14:59.134812  / # export SHELL=3D/bin/sh. /lava-9948550/e=
nvironment

    2023-04-12T12:14:59.134971  =


    2023-04-12T12:14:59.235728  / # . /lava-9948550/environment/lava-994855=
0/bin/lava-test-runner /lava-9948550/1

    2023-04-12T12:14:59.236043  =


    2023-04-12T12:14:59.240650  / # /lava-9948550/bin/lava-test-runner /lav=
a-9948550/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a0e71028e120162e85fa

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a0e71028e120162e85ff
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T12:15:13.318860  + <8>[   10.711544] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9948537_1.4.2.3.1>

    2023-04-12T12:15:13.319442  set +x

    2023-04-12T12:15:13.430139  / # #

    2023-04-12T12:15:13.533224  export SHELL=3D/bin/sh

    2023-04-12T12:15:13.534244  #

    2023-04-12T12:15:13.636469  / # export SHELL=3D/bin/sh. /lava-9948537/e=
nvironment

    2023-04-12T12:15:13.637302  =


    2023-04-12T12:15:13.739177  / # . /lava-9948537/environment/lava-994853=
7/bin/lava-test-runner /lava-9948537/1

    2023-04-12T12:15:13.740518  =


    2023-04-12T12:15:13.745088  / # /lava-9948537/bin/lava-test-runner /lav=
a-9948537/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a0e61028e120162e85ef

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a0e61028e120162e85f4
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T12:15:17.069878  <8>[   12.341219] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948575_1.4.2.3.1>

    2023-04-12T12:15:17.174657  / # #

    2023-04-12T12:15:17.275740  export SHELL=3D/bin/sh

    2023-04-12T12:15:17.275930  #

    2023-04-12T12:15:17.376844  / # export SHELL=3D/bin/sh. /lava-9948575/e=
nvironment

    2023-04-12T12:15:17.377077  =


    2023-04-12T12:15:17.478099  / # . /lava-9948575/environment/lava-994857=
5/bin/lava-test-runner /lava-9948575/1

    2023-04-12T12:15:17.478382  =


    2023-04-12T12:15:17.483042  / # /lava-9948575/bin/lava-test-runner /lav=
a-9948575/1

    2023-04-12T12:15:17.489697  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
meson-gxl-s905d-p230         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a2b4236e36fa1d2e85f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6436a2b4236e36fa1d2e8=
5f3
        new failure (last pass: v6.1.22-343-gd99c3fff7381) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64369e64931629d84d2e8604

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gfc6bc40ea0ba/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64369e64931629d=
84d2e860c
        failing since 0 day (last pass: v6.1.22-327-g5d6cb90df983, first fa=
il: v6.1.22-343-gd99c3fff7381)
        1 lines

    2023-04-12T12:04:30.259849  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dcri=
t RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-04-12T12:04:30.259991  =


    2023-04-12T12:04:30.306914  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eb673308, epc =3D=3D 80201ff4, ra =3D=
=3D 80204944
    2023-04-12T12:04:30.307164  =


    2023-04-12T12:04:30.344846  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-12T12:04:30.345097  =

   =

 =20
