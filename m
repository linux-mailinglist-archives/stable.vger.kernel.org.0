Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B3E6D2C10
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 02:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbjDAAVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 20:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbjDAAVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 20:21:36 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A112E1D2DD
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 17:21:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u10so22863443plz.7
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 17:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680308494;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ADli+AUYAgwhl89JuDDC3uSoJhucelBwkFt6D8tjlMk=;
        b=UDIe3ye0YyK6smIMlp2TjMBfeSUoxo1zrKbPZqDFZMgGstJDPndkXFio0K6/koU+t4
         M6ufA6OW7OsjqOuhJGvO3n8M5rXyfIZb3wBcpTSbGmPssUVH/0JHaowDScSK2eL7Adcp
         djsCcFqqdbGsLO6xmj8jURP6wump5KMj78e/7YSEgXSX5i6oQD1M8nkHBOgLyeckjV3o
         v6QuTW3mCooO1JRRVoZRqTZhKilmSS1+3MOdq1fOBLJDK8UcC0TDsnRtaDCmCxjcZK8Y
         eViy3J/TShdMuxtOL6jKtVedtRNOzT5ywMmmM3O8SmQmjC+DkbfHUbI9Tt8SXJROq792
         3mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680308494;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ADli+AUYAgwhl89JuDDC3uSoJhucelBwkFt6D8tjlMk=;
        b=eCIqsc96XIzl/zCmS2kqY8O4TrXwtqL0Fv+NxYxAEt9P2IWgegquxV297+1F4bYhyc
         H4EJsk8K1Pp+crnSRFKAOzWHuxpRROf2UpMTX1rT6WPcpu34qgk0VfS/Ijv51vV5SnAE
         RxCIZ9M2hx6PfwJ3xd6/jWf3aomOkXB1NjlQmLtzqe6ZIvFJLIVmWhnn7UNPOCvoRHrf
         bsqYuqy7ZtW1j4me0ulxd8IfgOiN60kQtdxgXk7BiNHr2apFzsABUXTpsRQOggDsnHGw
         h5fuLNLSO5mCdPUM7R8Etd8E9rBedGIPlZ/R8Dt45MzzXkK29fN+CM7tSEEVSmSWbja5
         b5XQ==
X-Gm-Message-State: AAQBX9cDWByBwb4/cLXBd4/xo8pad7AoiSVCc2CZMPaxShPu2gg0SU+n
        T6J9MqfAXbzw6dRE6frfdr15LGeKodMI/tiO7mveEA==
X-Google-Smtp-Source: AKy350baggapO5xOLPQROEeTX6W35qLqdnwYSnEIfpBpuEJ+JvTr+7j0CMTlH5etlViR9r/CL308ZA==
X-Received: by 2002:a17:90b:3911:b0:23f:9d83:ad76 with SMTP id ob17-20020a17090b391100b0023f9d83ad76mr31586478pjb.23.1680308493776;
        Fri, 31 Mar 2023 17:21:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v2-20020a17090a0e0200b00240aff612f0sm2092849pje.5.2023.03.31.17.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 17:21:33 -0700 (PDT)
Message-ID: <6427790d.170a0220.e225c.54b0@mx.google.com>
Date:   Fri, 31 Mar 2023 17:21:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/6.1
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-65-g0f37ac1f7e1d4
Subject: stable-rc/queue/6.1 baseline: 178 runs,
 7 regressions (v6.1.22-65-g0f37ac1f7e1d4)
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

stable-rc/queue/6.1 baseline: 178 runs, 7 regressions (v6.1.22-65-g0f37ac1f=
7e1d4)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-65-g0f37ac1f7e1d4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-65-g0f37ac1f7e1d4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f37ac1f7e1d4e0fc82af425a6da7b604723f41f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64274561356122df5662f7bc

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64274561356122df5662f7c1
        failing since 3 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-03-31T20:40:38.541219  + set +x

    2023-03-31T20:40:38.547919  <8>[   10.070768] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9834895_1.4.2.3.1>

    2023-03-31T20:40:38.655631  / # #

    2023-03-31T20:40:38.756887  export SHELL=3D/bin/sh

    2023-03-31T20:40:38.757081  #

    2023-03-31T20:40:38.858051  / # export SHELL=3D/bin/sh. /lava-9834895/e=
nvironment

    2023-03-31T20:40:38.858225  =


    2023-03-31T20:40:38.959111  / # . /lava-9834895/environment/lava-983489=
5/bin/lava-test-runner /lava-9834895/1

    2023-03-31T20:40:38.959439  =


    2023-03-31T20:40:38.964978  / # /lava-9834895/bin/lava-test-runner /lav=
a-9834895/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64274548020c92d0dc62f77b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64274549020c92d0dc62f780
        failing since 3 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-03-31T20:40:28.264221  + <8>[   11.585375] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9834901_1.4.2.3.1>

    2023-03-31T20:40:28.264322  set +x

    2023-03-31T20:40:28.368869  / # #

    2023-03-31T20:40:28.469850  export SHELL=3D/bin/sh

    2023-03-31T20:40:28.470085  #

    2023-03-31T20:40:28.571007  / # export SHELL=3D/bin/sh. /lava-9834901/e=
nvironment

    2023-03-31T20:40:28.571255  =


    2023-03-31T20:40:28.672233  / # . /lava-9834901/environment/lava-983490=
1/bin/lava-test-runner /lava-9834901/1

    2023-03-31T20:40:28.672588  =


    2023-03-31T20:40:28.677732  / # /lava-9834901/bin/lava-test-runner /lav=
a-9834901/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6427454dc8990ebb9462f775

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6427454dc8990ebb9462f77a
        failing since 3 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-03-31T20:40:22.632881  <8>[   10.267683] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9834870_1.4.2.3.1>

    2023-03-31T20:40:22.636196  + set +x

    2023-03-31T20:40:22.737874  #

    2023-03-31T20:40:22.838990  / # #export SHELL=3D/bin/sh

    2023-03-31T20:40:22.839219  =


    2023-03-31T20:40:22.940112  / # export SHELL=3D/bin/sh. /lava-9834870/e=
nvironment

    2023-03-31T20:40:22.940358  =


    2023-03-31T20:40:23.041274  / # . /lava-9834870/environment/lava-983487=
0/bin/lava-test-runner /lava-9834870/1

    2023-03-31T20:40:23.041592  =


    2023-03-31T20:40:23.046780  / # /lava-9834870/bin/lava-test-runner /lav=
a-9834870/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64274535943683392d62f76e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64274535943683392d62f773
        failing since 3 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-03-31T20:40:11.684907  + set +x

    2023-03-31T20:40:11.691295  <8>[   10.352994] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9834879_1.4.2.3.1>

    2023-03-31T20:40:11.796600  / # #

    2023-03-31T20:40:11.897649  export SHELL=3D/bin/sh

    2023-03-31T20:40:11.897885  #

    2023-03-31T20:40:11.998793  / # export SHELL=3D/bin/sh. /lava-9834879/e=
nvironment

    2023-03-31T20:40:11.999025  =


    2023-03-31T20:40:12.099979  / # . /lava-9834879/environment/lava-983487=
9/bin/lava-test-runner /lava-9834879/1

    2023-03-31T20:40:12.100304  =


    2023-03-31T20:40:12.104644  / # /lava-9834879/bin/lava-test-runner /lav=
a-9834879/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6427454c020c92d0dc62f79e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6427454c020c92d0dc62f7a3
        failing since 3 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-03-31T20:40:20.673267  <8>[   10.469913] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9834910_1.4.2.3.1>

    2023-03-31T20:40:20.676475  + set +x

    2023-03-31T20:40:20.778063  / #

    2023-03-31T20:40:20.879192  # #export SHELL=3D/bin/sh

    2023-03-31T20:40:20.879365  =


    2023-03-31T20:40:20.980287  / # export SHELL=3D/bin/sh. /lava-9834910/e=
nvironment

    2023-03-31T20:40:20.980470  =


    2023-03-31T20:40:21.081245  / # . /lava-9834910/environment/lava-983491=
0/bin/lava-test-runner /lava-9834910/1

    2023-03-31T20:40:21.081518  =


    2023-03-31T20:40:21.086333  / # /lava-9834910/bin/lava-test-runner /lav=
a-9834910/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6427454b020c92d0dc62f793

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6427454b020c92d0dc62f798
        failing since 3 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-03-31T20:40:22.465273  + set<8>[   11.112099] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9834868_1.4.2.3.1>

    2023-03-31T20:40:22.465414   +x

    2023-03-31T20:40:22.570192  / # #

    2023-03-31T20:40:22.670994  export SHELL=3D/bin/sh

    2023-03-31T20:40:22.671277  #

    2023-03-31T20:40:22.772326  / # export SHELL=3D/bin/sh. /lava-9834868/e=
nvironment

    2023-03-31T20:40:22.772568  =


    2023-03-31T20:40:22.873312  / # . /lava-9834868/environment/lava-983486=
8/bin/lava-test-runner /lava-9834868/1

    2023-03-31T20:40:22.873645  =


    2023-03-31T20:40:22.878255  / # /lava-9834868/bin/lava-test-runner /lav=
a-9834868/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6427453f5e3b85fa9462f77a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-65=
-g0f37ac1f7e1d4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6427453f5e3b85fa9462f77f
        failing since 3 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-03-31T20:40:24.629855  <8>[   11.561844] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9834911_1.4.2.3.1>

    2023-03-31T20:40:24.734415  / # #

    2023-03-31T20:40:24.835504  export SHELL=3D/bin/sh

    2023-03-31T20:40:24.835760  #

    2023-03-31T20:40:24.936749  / # export SHELL=3D/bin/sh. /lava-9834911/e=
nvironment

    2023-03-31T20:40:24.936985  =


    2023-03-31T20:40:25.037935  / # . /lava-9834911/environment/lava-983491=
1/bin/lava-test-runner /lava-9834911/1

    2023-03-31T20:40:25.038216  =


    2023-03-31T20:40:25.042686  / # /lava-9834911/bin/lava-test-runner /lav=
a-9834911/1

    2023-03-31T20:40:25.049657  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
