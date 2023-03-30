Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA5D6D0EFC
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjC3TjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjC3TjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:39:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C612ACC0B
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:39:08 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q102so18271413pjq.3
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680205148;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=c6yAvHjln1hauQSVMq5tSGqfAKUtWZNr+L3kMOop/8A=;
        b=pYrkSBz7Dd9b64vnRaZkj8lJQzI9L6RMdjSgN1fuyqvkD2WlnvMaQ/oIm4CasNDo4R
         M5S1Hz2oI82oECF/F3HLlAllhqfxYFuphJF8lz56vJOoKrRbqyDGBZ77yq8QP4KyKa0l
         M6RgptEGIJl/lmNK1cmD1xR3tr5yszO2aJ3J1aLhAxBgpivUjymL1gicP99t5pNV4DPv
         QO5hT1zB5coUy07w2Kf9PByTwBQcYGjpZB4kMElz7EdqwtV9WMyozSUaXhuDR1enYOWR
         Ysp0LgvEisdZ4Y2z81d7M6vuRlydxlbelw2Kj2UcnMPqcoS+NMvtilWeMzUl/WFIu+mv
         XWAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680205148;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c6yAvHjln1hauQSVMq5tSGqfAKUtWZNr+L3kMOop/8A=;
        b=YNGtYTPPi08ItBrDslTcEqw/rhIOTayoWUVbohWDnXYzcdb7Ocd5Nz8h4DBPxowpZR
         7U5/pRiv73SMBVnTeuK2d3OvX0xyehPAvlsHRpBn2XqunGtPM/qBc5cYxXh58S+bHx7s
         T99DJ7kf75a7dOX880kE54RK0wPrnwE5LiEPzcB8dFU3pZJdnEX8BryF8dXtxeF9S/+7
         qRG9PfELfgdAKIRuUUzeRz5HTUiw9gJtIVZ/p68LAG3JFo4Mz25+Ll9Q+LiQ3FyGapGM
         QmKlQM4we3UCoed/JWZXIdQCqRO8a7ojnu3O6kHzbtWw1HZDLfRzqxHJNqZrjm//NJOx
         0OaA==
X-Gm-Message-State: AAQBX9eiIu6qX0OagbKc/vJL/12VkqUaHx2bcmRIpen3Y2OtQ+N/A0QT
        eX88sKbJV/ROJFRmEkdaKVuGLBMRxtJ/0G8qHEE=
X-Google-Smtp-Source: AKy350a4eqYv4l5NFpjWzEnuXun0LLAuC6n5WNBPoaNM4uQRZZfR0MN1M0A5bYyWVNO4yYGM11dshA==
X-Received: by 2002:a17:903:11d2:b0:1a1:bff4:4a06 with SMTP id q18-20020a17090311d200b001a1bff44a06mr31389984plh.24.1680205147966;
        Thu, 30 Mar 2023 12:39:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f11-20020a17090274cb00b001a065d3bb0esm82783plt.211.2023.03.30.12.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 12:39:07 -0700 (PDT)
Message-ID: <6425e55b.170a0220.3463d.0732@mx.google.com>
Date:   Thu, 30 Mar 2023 12:39:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/6.1
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-63-g9a5b42b73d5b
Subject: stable-rc/queue/6.1 baseline: 138 runs,
 8 regressions (v6.1.22-63-g9a5b42b73d5b)
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

stable-rc/queue/6.1 baseline: 138 runs, 8 regressions (v6.1.22-63-g9a5b42b7=
3d5b)

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
el/v6.1.22-63-g9a5b42b73d5b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-63-g9a5b42b73d5b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a5b42b73d5bd4d78cd69c1e776d31e55f22430d =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425aff5dc1f91d37462f791

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425aff5dc1f91d37462f796
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T15:50:52.350752  <8>[   10.048664] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9818336_1.4.2.3.1>

    2023-03-30T15:50:52.354234  + set +x

    2023-03-30T15:50:52.459670  #

    2023-03-30T15:50:52.460729  =


    2023-03-30T15:50:52.562777  / # #export SHELL=3D/bin/sh

    2023-03-30T15:50:52.563454  =


    2023-03-30T15:50:52.665155  / # export SHELL=3D/bin/sh. /lava-9818336/e=
nvironment

    2023-03-30T15:50:52.665983  =


    2023-03-30T15:50:52.767949  / # . /lava-9818336/environment/lava-981833=
6/bin/lava-test-runner /lava-9818336/1

    2023-03-30T15:50:52.769092  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425afbc0a49b6193562f79b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425afbc0a49b6193562f7a0
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T15:50:10.071399  + set<8>[   11.776341] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9818273_1.4.2.3.1>

    2023-03-30T15:50:10.072043   +x

    2023-03-30T15:50:10.180846  / # #

    2023-03-30T15:50:10.284042  export SHELL=3D/bin/sh

    2023-03-30T15:50:10.284939  #

    2023-03-30T15:50:10.387164  / # export SHELL=3D/bin/sh. /lava-9818273/e=
nvironment

    2023-03-30T15:50:10.388162  =


    2023-03-30T15:50:10.490265  / # . /lava-9818273/environment/lava-981827=
3/bin/lava-test-runner /lava-9818273/1

    2023-03-30T15:50:10.491678  =


    2023-03-30T15:50:10.496228  / # /lava-9818273/bin/lava-test-runner /lav=
a-9818273/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425afdff433192a7a62f7cc

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425afdff433192a7a62f7d1
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T15:50:34.225726  <8>[    9.731024] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9818305_1.4.2.3.1>

    2023-03-30T15:50:34.229344  + set +x

    2023-03-30T15:50:34.331150  =


    2023-03-30T15:50:34.432151  / # #export SHELL=3D/bin/sh

    2023-03-30T15:50:34.432353  =


    2023-03-30T15:50:34.533224  / # export SHELL=3D/bin/sh. /lava-9818305/e=
nvironment

    2023-03-30T15:50:34.533470  =


    2023-03-30T15:50:34.634407  / # . /lava-9818305/environment/lava-981830=
5/bin/lava-test-runner /lava-9818305/1

    2023-03-30T15:50:34.634795  =


    2023-03-30T15:50:34.640220  / # /lava-9818305/bin/lava-test-runner /lav=
a-9818305/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/6425acab493bec07b162f78e

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425acab493bec07b162f7c1
        new failure (last pass: v6.1.21-223-g5b480bfab207)

    2023-03-30T15:36:54.864506  + set +x
    2023-03-30T15:36:54.868292  <8>[   17.241120] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 250847_1.5.2.4.1>
    2023-03-30T15:36:54.984467  / # #
    2023-03-30T15:36:55.086831  export SHELL=3D/bin/sh
    2023-03-30T15:36:55.087503  #
    2023-03-30T15:36:55.189330  / # export SHELL=3D/bin/sh. /lava-250847/en=
vironment
    2023-03-30T15:36:55.190066  =

    2023-03-30T15:36:55.292176  / # . /lava-250847/environment/lava-250847/=
bin/lava-test-runner /lava-250847/1
    2023-03-30T15:36:55.293423  =

    2023-03-30T15:36:55.299407  / # /lava-250847/bin/lava-test-runner /lava=
-250847/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425afac79bbaf101262f7b4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425afac79bbaf101262f7b9
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T15:49:58.040214  + set +x

    2023-03-30T15:49:58.047273  <8>[   10.607442] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9818292_1.4.2.3.1>

    2023-03-30T15:49:58.156435  / # #

    2023-03-30T15:49:58.259481  export SHELL=3D/bin/sh

    2023-03-30T15:49:58.260321  #

    2023-03-30T15:49:58.362297  / # export SHELL=3D/bin/sh. /lava-9818292/e=
nvironment

    2023-03-30T15:49:58.363095  =


    2023-03-30T15:49:58.465071  / # . /lava-9818292/environment/lava-981829=
2/bin/lava-test-runner /lava-9818292/1

    2023-03-30T15:49:58.466423  =


    2023-03-30T15:49:58.471487  / # /lava-9818292/bin/lava-test-runner /lav=
a-9818292/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425afc9f433192a7a62f771

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425afc9f433192a7a62f776
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T15:50:13.059556  + set +x

    2023-03-30T15:50:13.065876  <8>[   10.243922] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9818315_1.4.2.3.1>

    2023-03-30T15:50:13.174344  #

    2023-03-30T15:50:13.175659  =


    2023-03-30T15:50:13.277925  / # #export SHELL=3D/bin/sh

    2023-03-30T15:50:13.278868  =


    2023-03-30T15:50:13.380793  / # export SHELL=3D/bin/sh. /lava-9818315/e=
nvironment

    2023-03-30T15:50:13.381671  =


    2023-03-30T15:50:13.483746  / # . /lava-9818315/environment/lava-981831=
5/bin/lava-test-runner /lava-9818315/1

    2023-03-30T15:50:13.485075  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425afc11a81c9b21962f790

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425afc11a81c9b21962f795
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T15:50:09.742250  + set<8>[   11.350342] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9818301_1.4.2.3.1>

    2023-03-30T15:50:09.742679   +x

    2023-03-30T15:50:09.850843  / # #

    2023-03-30T15:50:09.953399  export SHELL=3D/bin/sh

    2023-03-30T15:50:09.954070  #

    2023-03-30T15:50:10.055750  / # export SHELL=3D/bin/sh. /lava-9818301/e=
nvironment

    2023-03-30T15:50:10.056389  =


    2023-03-30T15:50:10.158490  / # . /lava-9818301/environment/lava-981830=
1/bin/lava-test-runner /lava-9818301/1

    2023-03-30T15:50:10.159534  =


    2023-03-30T15:50:10.164654  / # /lava-9818301/bin/lava-test-runner /lav=
a-9818301/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425afb5b9d4df47c562f772

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-63=
-g9a5b42b73d5b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425afb5b9d4df47c562f777
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T15:50:00.257286  + set +x<8>[   12.034096] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9818275_1.4.2.3.1>

    2023-03-30T15:50:00.257374  =


    2023-03-30T15:50:00.361926  / # #

    2023-03-30T15:50:00.463076  export SHELL=3D/bin/sh

    2023-03-30T15:50:00.463262  #

    2023-03-30T15:50:00.564138  / # export SHELL=3D/bin/sh. /lava-9818275/e=
nvironment

    2023-03-30T15:50:00.564317  =


    2023-03-30T15:50:00.665190  / # . /lava-9818275/environment/lava-981827=
5/bin/lava-test-runner /lava-9818275/1

    2023-03-30T15:50:00.665457  =


    2023-03-30T15:50:00.669652  / # /lava-9818275/bin/lava-test-runner /lav=
a-9818275/1
 =

    ... (12 line(s) more)  =

 =20
