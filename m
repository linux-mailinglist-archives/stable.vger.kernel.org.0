Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A092B6DCEA8
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 03:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDKBEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 21:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjDKBEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 21:04:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79B2172B
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 18:04:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p8so6316971plk.9
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 18:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681175074; x=1683767074;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eLRpy9v7OwZHVdUE2P1sVYToxpi6fAPIiEBrHI07Vng=;
        b=lrb7ZLDvVfT5JvCabj8b1GjV2+CrDTJRjS3T5kExIZlHcYe0YR6XzKfUcUWOrTPukp
         BNd2jt0Aq9r5/2X9OX0BQSn6c0/WOrkUEH41DcG3aqN7BXI07o3kEtt97vvhygncZpjZ
         W1na7k9IyzpEnuThZfHXP8WXwI/mEkEdafxoMJqyoHFfd45xGN51W9tXNavXet9zSyyw
         D9khX8cj6EIlvglxl8xXbQ/jK1SEN8zEOjFCi8a0ZPb5gNP9KEgSaZZKNmaBGa5HX0i5
         4As5DtcKbuh+k2pqUCDHl7t0OEzs+vEi0Zi05ag/EIsEei/3NI1HmwKSEUcH/27O2JW6
         D/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681175074; x=1683767074;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eLRpy9v7OwZHVdUE2P1sVYToxpi6fAPIiEBrHI07Vng=;
        b=1BXJG9fExHpg7fNYbOfDPL9nMS5oqS5cWJo25Iqa66IV/6MSAizzpBUmIATUBoJU7z
         Nb/4jEni8WEEmN2taq5IVvysPBkoVmkZrGOUQc2varHUhUW6nBhCGxUJPjG4ptmbEUUa
         as0943Od55nmbsLUp5cMG61E4dYMqfFgcaGIUC25OFx9VJEr1Y6W164CqUl6dWBwErM7
         lEhUF95PPFFlDDnnemruJMrpN7H9Dwa8d3rpW3XoL9ZL28YgDbDGU8999ABy845TlDW2
         2o/ezbbilTBh+DqZpPQIMom+TtbaoB7I85xMvzMpW/Fwj/d9Y2cwUXsAIqlfMPpqpoB4
         HlHQ==
X-Gm-Message-State: AAQBX9fOM6v1YgZ6TzIcHyfbOPeDR9IxRxnxMcY3Ie3GJP9TmibqSB1z
        uH+n37J+OwvZYF5Za+3THf16uGtNbdghSOn3aOs=
X-Google-Smtp-Source: AKy350Y+rOPrbc4TVU/soW21knOkTZ7rgDavWZvrtT1MzdA1JS0uMAW1FntHQkHg2XQ+B3LJOPzNXw==
X-Received: by 2002:a05:6a20:c114:b0:d9:9994:5136 with SMTP id bh20-20020a056a20c11400b000d999945136mr12375219pzb.7.1681175074052;
        Mon, 10 Apr 2023 18:04:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13-20020aa7914d000000b00627fafe49f9sm8421573pfi.106.2023.04.10.18.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 18:04:33 -0700 (PDT)
Message-ID: <6434b221.a70a0220.c04de.fc07@mx.google.com>
Date:   Mon, 10 Apr 2023 18:04:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-278-gb95c5e4f2816
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 182 runs,
 9 regressions (v6.1.22-278-gb95c5e4f2816)
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

stable-rc/queue/6.1 baseline: 182 runs, 9 regressions (v6.1.22-278-gb95c5e4=
f2816)

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

odroid-xu3                   | arm    | lab-collabora | gcc-10   | multi_v7=
_defconfig           | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-278-gb95c5e4f2816/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-278-gb95c5e4f2816
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b95c5e4f2816826965fe29a7c90deaa2526564da =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64347c1aef31ff8d642e8607

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64347c1aef31ff8d642e860c
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-10T21:13:46.287324  + set +x

    2023-04-10T21:13:46.293983  <8>[   10.725529] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9927389_1.4.2.3.1>

    2023-04-10T21:13:46.396188  #

    2023-04-10T21:13:46.497556  / # #export SHELL=3D/bin/sh

    2023-04-10T21:13:46.498239  =


    2023-04-10T21:13:46.600039  / # export SHELL=3D/bin/sh. /lava-9927389/e=
nvironment

    2023-04-10T21:13:46.600712  =


    2023-04-10T21:13:46.702481  / # . /lava-9927389/environment/lava-992738=
9/bin/lava-test-runner /lava-9927389/1

    2023-04-10T21:13:46.703550  =


    2023-04-10T21:13:46.709575  / # /lava-9927389/bin/lava-test-runner /lav=
a-9927389/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64347c2ca57006ebc72e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64347c2ca57006ebc72e85eb
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-10T21:14:06.445507  + <8>[   11.134217] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9927449_1.4.2.3.1>

    2023-04-10T21:14:06.446051  set +x

    2023-04-10T21:14:06.553734  / # #

    2023-04-10T21:14:06.656595  export SHELL=3D/bin/sh

    2023-04-10T21:14:06.657384  #

    2023-04-10T21:14:06.759491  / # export SHELL=3D/bin/sh. /lava-9927449/e=
nvironment

    2023-04-10T21:14:06.760313  =


    2023-04-10T21:14:06.862562  / # . /lava-9927449/environment/lava-992744=
9/bin/lava-test-runner /lava-9927449/1

    2023-04-10T21:14:06.863895  =


    2023-04-10T21:14:06.869608  / # /lava-9927449/bin/lava-test-runner /lav=
a-9927449/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64347c15a8670d360f2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64347c15a8670d360f2e85eb
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-10T21:13:52.031378  <8>[   10.263865] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9927411_1.4.2.3.1>

    2023-04-10T21:13:52.034749  + set +x

    2023-04-10T21:13:52.136516  #

    2023-04-10T21:13:52.237895  / # #export SHELL=3D/bin/sh

    2023-04-10T21:13:52.238133  =


    2023-04-10T21:13:52.339110  / # export SHELL=3D/bin/sh. /lava-9927411/e=
nvironment

    2023-04-10T21:13:52.339389  =


    2023-04-10T21:13:52.440338  / # . /lava-9927411/environment/lava-992741=
1/bin/lava-test-runner /lava-9927411/1

    2023-04-10T21:13:52.440629  =


    2023-04-10T21:13:52.445631  / # /lava-9927411/bin/lava-test-runner /lav=
a-9927411/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64347c22e2ce48bd692e85ff

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64347c22e2ce48bd692e8604
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-10T21:13:55.044136  + <8>[   10.027930] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9927419_1.4.2.3.1>

    2023-04-10T21:13:55.047808  set +x

    2023-04-10T21:13:55.152844  /#

    2023-04-10T21:13:55.255654   # #export SHELL=3D/bin/sh

    2023-04-10T21:13:55.256354  =


    2023-04-10T21:13:55.358090  / # export SHELL=3D/bin/sh. /lava-9927419/e=
nvironment

    2023-04-10T21:13:55.358354  =


    2023-04-10T21:13:55.459414  / # . /lava-9927419/environment/lava-992741=
9/bin/lava-test-runner /lava-9927419/1

    2023-04-10T21:13:55.460665  =


    2023-04-10T21:13:55.465292  / # /lava-9927419/bin/lava-test-runner /lav=
a-9927419/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64347c181416e86bca2e8614

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64347c181416e86bca2e8618
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-10T21:13:47.758684  <8>[    9.946197] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9927418_1.4.2.3.1>

    2023-04-10T21:13:47.761792  + set +x

    2023-04-10T21:13:47.869676  / # #

    2023-04-10T21:13:47.972568  export SHELL=3D/bin/sh

    2023-04-10T21:13:47.973246  #

    2023-04-10T21:13:48.074975  / # export SHELL=3D/bin/sh. /lava-9927418/e=
nvironment

    2023-04-10T21:13:48.075705  =


    2023-04-10T21:13:48.177480  / # . /lava-9927418/environment/lava-992741=
8/bin/lava-test-runner /lava-9927418/1

    2023-04-10T21:13:48.178563  =


    2023-04-10T21:13:48.183582  / # /lava-9927418/bin/lava-test-runner /lav=
a-9927418/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64347c35ca8ae024f52e8611

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64347c35ca8ae024f52e8616
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-10T21:14:06.114264  + set<8>[    8.545172] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9927406_1.4.2.3.1>

    2023-04-10T21:14:06.114832   +x

    2023-04-10T21:14:06.222354  / # #

    2023-04-10T21:14:06.323408  export SHELL=3D/bin/sh

    2023-04-10T21:14:06.323763  #

    2023-04-10T21:14:06.425121  / # export SHELL=3D/bin/sh. /lava-9927406/e=
nvironment

    2023-04-10T21:14:06.425807  =


    2023-04-10T21:14:06.527618  / # . /lava-9927406/environment/lava-992740=
6/bin/lava-test-runner /lava-9927406/1

    2023-04-10T21:14:06.528805  =


    2023-04-10T21:14:06.533593  / # /lava-9927406/bin/lava-test-runner /lav=
a-9927406/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64347c1b1416e86bca2e8625

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64347c1b1416e86bca2e862a
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-10T21:13:43.568746  <8>[    9.826043] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9927395_1.4.2.3.1>

    2023-04-10T21:13:43.674928  / # #

    2023-04-10T21:13:43.777830  export SHELL=3D/bin/sh

    2023-04-10T21:13:43.778665  #

    2023-04-10T21:13:43.880593  / # export SHELL=3D/bin/sh. /lava-9927395/e=
nvironment

    2023-04-10T21:13:43.881465  =


    2023-04-10T21:13:43.983423  / # . /lava-9927395/environment/lava-992739=
5/bin/lava-test-runner /lava-9927395/1

    2023-04-10T21:13:43.984872  =


    2023-04-10T21:13:43.989727  / # /lava-9927395/bin/lava-test-runner /lav=
a-9927395/1

    2023-04-10T21:13:43.996522  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
odroid-xu3                   | arm    | lab-collabora | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64347e3e2c10d17d212e8620

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64347e3e2c10d17d212e8=
621
        new failure (last pass: v6.1.22-234-g45cb819bb347) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64347e0ed549cea9882e863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-27=
8-gb95c5e4f2816/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64347e0ed549cea9882e8=
63f
        failing since 1 day (last pass: v6.1.22-178-gaa9876e65686, first fa=
il: v6.1.22-234-g45cb819bb347) =

 =20
