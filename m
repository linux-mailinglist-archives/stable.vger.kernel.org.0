Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF436DF736
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 15:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjDLNbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 09:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjDLNbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 09:31:41 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981A76183
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 06:31:15 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b145b3b03so785996b3a.1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 06:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681306273; x=1683898273;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UVmkbV4JSpx6z1QU6Wj7KM6BCYTZ38odSzygMIzV7dg=;
        b=3D9X4H4NUnJdB8rERotEHYpOUPKdq3OeQF0vFu49K/qQXoi8bfNr/DhZmopBZMA13z
         Mch68Kvk9ZVeworZanOjyP/XcKFO0ayhHYFZjkfU/0WJr50HLr/MUdeU1LfLKoojCOlS
         3glFr7A1me3CAndcJPUnVgI4yHzAgykCzIhdq67XuE3q4WWHCRBmPRwZngZBhL1/B5J9
         KyQyHSEJaQavLKdAI/xgBYkprrTgxBbAWqZKlGEpzURKQxfhw5PDFy+xbdJ/fOJk6Xqp
         xyBcjkpX3W9favCLkOJVEWlpHTWtcZ0Fvs5kKy37xbZOXSNAWBMFrS8klriMovAShT8T
         yVlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681306273; x=1683898273;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UVmkbV4JSpx6z1QU6Wj7KM6BCYTZ38odSzygMIzV7dg=;
        b=NOYiBCLPOQBNwkLNZN+LgqanLFLAS9YlPJgw1WmX2px720CaCqHKB4yPziZhrJjK2q
         FoCDhMololKo6xbLP/lbKNLVT7V4ZSsMnG9y1wmDuITb3FRhH1/xNBqPQUk6GbQ/r0lV
         ufjLnSeiW49SJV/NmqniNCQKzjFMnecbpwBzTUfnFYFNlsm7DImVgIXvCv1TLGJJUAm4
         wovkzU1rsRPTnJkgFFGZvs6NlHYMo/fNkhotYke74xZa+FPv4x2XCbLMEJRY3uys2C1N
         IM3DZJenNzfy2Cvu+4iVCmBhk/kxrw9WtUJbG+GfPn0yDvjvxUy5iIDiJJ/xsgvI47OJ
         5A3w==
X-Gm-Message-State: AAQBX9fWd0Pr6eIDzT5FuNNbvscwpqHLMHihxks84gupCkwGUAfuYnj2
        NtqyIIlG6CDsxw7TyZlxZFXJpov08Mhtj1mJIb0=
X-Google-Smtp-Source: AKy350YlI1vVMuWTnxmOMovvfPtOKJTM6betWhMvS7Y89nZT/LU0GTvzdPc7eY3QRiSzbXsTUfHHIw==
X-Received: by 2002:a05:6a00:80cc:b0:635:3881:a848 with SMTP id ei12-20020a056a0080cc00b006353881a848mr2854731pfb.5.1681306273235;
        Wed, 12 Apr 2023 06:31:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n13-20020a63e04d000000b005143d3fa0e0sm6854184pgj.2.2023.04.12.06.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:31:12 -0700 (PDT)
Message-ID: <6436b2a0.630a0220.6ac45.c4d7@mx.google.com>
Date:   Wed, 12 Apr 2023 06:31:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-343-gd99c3fff7381
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 183 runs,
 9 regressions (v6.1.22-343-gd99c3fff7381)
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

stable-rc/queue/6.1 baseline: 183 runs, 9 regressions (v6.1.22-343-gd99c3ff=
f7381)

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
el/v6.1.22-343-gd99c3fff7381/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-343-gd99c3fff7381
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d99c3fff7381c05fd696ed45c9d9ecba185b548b =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436803b501d19927d2e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436803b501d19927d2e85ee
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T09:55:47.281878  <8>[   10.646936] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9946522_1.4.2.3.1>

    2023-04-12T09:55:47.285143  + set +x

    2023-04-12T09:55:47.393094  / # #

    2023-04-12T09:55:47.495689  export SHELL=3D/bin/sh

    2023-04-12T09:55:47.496374  #

    2023-04-12T09:55:47.598270  / # export SHELL=3D/bin/sh. /lava-9946522/e=
nvironment

    2023-04-12T09:55:47.598949  =


    2023-04-12T09:55:47.700905  / # . /lava-9946522/environment/lava-994652=
2/bin/lava-test-runner /lava-9946522/1

    2023-04-12T09:55:47.702040  =


    2023-04-12T09:55:47.708001  / # /lava-9946522/bin/lava-test-runner /lav=
a-9946522/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64367f983c5078632a2e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64367f983c5078632a2e85f0
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T09:53:14.492850  + <8>[   11.086858] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9946453_1.4.2.3.1>

    2023-04-12T09:53:14.492937  set +x

    2023-04-12T09:53:14.597228  / # #

    2023-04-12T09:53:14.698259  export SHELL=3D/bin/sh

    2023-04-12T09:53:14.698456  #

    2023-04-12T09:53:14.799261  / # export SHELL=3D/bin/sh. /lava-9946453/e=
nvironment

    2023-04-12T09:53:14.799464  =


    2023-04-12T09:53:14.900460  / # . /lava-9946453/environment/lava-994645=
3/bin/lava-test-runner /lava-9946453/1

    2023-04-12T09:53:14.900809  =


    2023-04-12T09:53:14.905270  / # /lava-9946453/bin/lava-test-runner /lav=
a-9946453/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64367fab3c5078632a2e862e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64367fab3c5078632a2e8633
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T09:53:30.615561  <8>[   10.794668] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9946563_1.4.2.3.1>

    2023-04-12T09:53:30.618768  + set +x

    2023-04-12T09:53:30.720363  #

    2023-04-12T09:53:30.821607  / # #export SHELL=3D/bin/sh

    2023-04-12T09:53:30.821813  =


    2023-04-12T09:53:30.922685  / # export SHELL=3D/bin/sh. /lava-9946563/e=
nvironment

    2023-04-12T09:53:30.922889  =


    2023-04-12T09:53:31.023784  / # . /lava-9946563/environment/lava-994656=
3/bin/lava-test-runner /lava-9946563/1

    2023-04-12T09:53:31.024059  =


    2023-04-12T09:53:31.029228  / # /lava-9946563/bin/lava-test-runner /lav=
a-9946563/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/64367e82f08fb5683f2e85f4

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64367e82f08fb5683f2e8627
        failing since 0 day (last pass: v6.1.22-278-gb95c5e4f2816, first fa=
il: v6.1.22-327-g5d6cb90df983)

    2023-04-12T09:48:19.530925  + set +x
    2023-04-12T09:48:19.534511  <8>[   17.895484] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 316471_1.5.2.4.1>
    2023-04-12T09:48:19.651443  / # #
    2023-04-12T09:48:19.754022  export SHELL=3D/bin/sh
    2023-04-12T09:48:19.754609  #
    2023-04-12T09:48:19.856182  / # export SHELL=3D/bin/sh. /lava-316471/en=
vironment
    2023-04-12T09:48:19.856821  =

    2023-04-12T09:48:19.958676  / # . /lava-316471/environment/lava-316471/=
bin/lava-test-runner /lava-316471/1
    2023-04-12T09:48:19.959727  =

    2023-04-12T09:48:19.967154  / # /lava-316471/bin/lava-test-runner /lava=
-316471/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64367fe87c49ff60102e8600

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64367fe87c49ff60102e8605
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T09:54:32.632029  + set +x

    2023-04-12T09:54:32.638257  <8>[   10.766635] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9946543_1.4.2.3.1>

    2023-04-12T09:54:32.743128  / # #

    2023-04-12T09:54:32.844179  export SHELL=3D/bin/sh

    2023-04-12T09:54:32.844431  #

    2023-04-12T09:54:32.945408  / # export SHELL=3D/bin/sh. /lava-9946543/e=
nvironment

    2023-04-12T09:54:32.945674  =


    2023-04-12T09:54:33.046664  / # . /lava-9946543/environment/lava-994654=
3/bin/lava-test-runner /lava-9946543/1

    2023-04-12T09:54:33.047047  =


    2023-04-12T09:54:33.051271  / # /lava-9946543/bin/lava-test-runner /lav=
a-9946543/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64367f9990fda682982e8656

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64367f9990fda682982e865b
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T09:53:23.353731  <8>[    7.688686] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9946534_1.4.2.3.1>

    2023-04-12T09:53:23.357276  + set +x

    2023-04-12T09:53:23.459253  /#

    2023-04-12T09:53:23.560577   # #export SHELL=3D/bin/sh

    2023-04-12T09:53:23.560813  =


    2023-04-12T09:53:23.661538  / # export SHELL=3D/bin/sh. /lava-9946534/e=
nvironment

    2023-04-12T09:53:23.661772  =


    2023-04-12T09:53:23.762743  / # . /lava-9946534/environment/lava-994653=
4/bin/lava-test-runner /lava-9946534/1

    2023-04-12T09:53:23.763099  =


    2023-04-12T09:53:23.768278  / # /lava-9946534/bin/lava-test-runner /lav=
a-9946534/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64367f99054f7066822e85ea

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64367f99054f7066822e85ef
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T09:53:22.002143  + set<8>[   11.483232] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9946499_1.4.2.3.1>

    2023-04-12T09:53:22.002258   +x

    2023-04-12T09:53:22.106943  / # #

    2023-04-12T09:53:22.208105  export SHELL=3D/bin/sh

    2023-04-12T09:53:22.208341  #

    2023-04-12T09:53:22.309245  / # export SHELL=3D/bin/sh. /lava-9946499/e=
nvironment

    2023-04-12T09:53:22.309482  =


    2023-04-12T09:53:22.410478  / # . /lava-9946499/environment/lava-994649=
9/bin/lava-test-runner /lava-9946499/1

    2023-04-12T09:53:22.410845  =


    2023-04-12T09:53:22.415308  / # /lava-9946499/bin/lava-test-runner /lav=
a-9946499/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64368127e0932f82f52e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64368127e0932f82f52e85ee
        failing since 14 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-12T09:59:43.770977  + set<8>[   11.126977] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9946545_1.4.2.3.1>

    2023-04-12T09:59:43.771418   +x

    2023-04-12T09:59:43.879204  / # #

    2023-04-12T09:59:43.981999  export SHELL=3D/bin/sh

    2023-04-12T09:59:43.982801  #

    2023-04-12T09:59:44.084735  / # export SHELL=3D/bin/sh. /lava-9946545/e=
nvironment

    2023-04-12T09:59:44.085353  =


    2023-04-12T09:59:44.187076  / # . /lava-9946545/environment/lava-994654=
5/bin/lava-test-runner /lava-9946545/1

    2023-04-12T09:59:44.188422  =


    2023-04-12T09:59:44.193536  / # /lava-9946545/bin/lava-test-runner /lav=
a-9946545/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64367b8633524ef1122e85fb

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
3-gd99c3fff7381/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64367b8633524ef=
1122e8603
        new failure (last pass: v6.1.22-327-g5d6cb90df983)
        1 lines

    2023-04-12T09:36:01.232612  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eb673308, epc =3D=3D 80201ff4, ra =3D=
=3D 80204944
    2023-04-12T09:36:01.232778  =


    2023-04-12T09:36:01.260599  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-12T09:36:01.260807  =

   =

 =20
