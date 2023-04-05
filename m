Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DBA6D8475
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjDERDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbjDERCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:02:51 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CED9769F
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 10:01:24 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f22so30885284plr.0
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 10:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680714032;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vtRq3p94hrJRtvI+C+XhZlCAliCtbN/xHYikYMVDyno=;
        b=OAiI9oHHp1mQneaJ3yIxWLEIvxNRDDdJ8gYFf9+z/X5j1NtUFuKUjh2p7YpfiAWSMZ
         3hhL60qnFUWBex6NZccafUWWrJgk27GaJnFjNBXWMYncPgPy/eG3T4xcEuh41H4MtIKK
         lIL0PNuIVjhmbyNaVTDOI9+ZLSNLrJof/WYc4SSdD9rupoW481nperApIBl3RBUjOvKa
         MZrtq4PqdJJyb1zFC6CQxYC7IUel53pHaI35+E3KeBk/1YT3Xi+9bdOrHIc+FEhHkOdK
         7YAcy4DgXmMX59LhaZ4mnX1IK2v703hZ2m7hCpB2EideV9tF2wyHdsaMFIBbQVUT6dTk
         9QPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680714032;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vtRq3p94hrJRtvI+C+XhZlCAliCtbN/xHYikYMVDyno=;
        b=XF9+dN/Jxn5w0yR8vpPxX9wZK7d1XABtGwRH3pT6KjebQlYfDpnEcWa2W/PaBfrLuy
         xyld0Y8/Xrk06iynEWtJAbihgCibk64PXfzzuFnYpW1vnPtpwLxEQiRTwPsbwSLC05VN
         Hwcxqpcwtw6GC0O5CzMLeFH7nkjCSE38OgPOzlj9ENGJdHMN0528+7SNhSMyLF66UVAP
         xBCuQClRvQmgjU0SlelJ4aizkF9JlB3BrHMa/+MqVNYulVSX8amWAqm24biKuAErSNi9
         N2OuaBzvNZo4idK2BNtw9cFkzGEsJcLaR2IXau2rGSQoE2NIBxkgRiAmoZ4uXduuwAX5
         GiIA==
X-Gm-Message-State: AAQBX9d/OHWbgJunHMs8LNTPqWRuDI309VyZS4ipZSsXyx5qsfFT8b/9
        9mCvVq9kVmttLDUvSOs0lnnj2+zDD8LEcgEJruTVxQ==
X-Google-Smtp-Source: AKy350aw5ZYQNuhQ0nsTIE+5yAq3aSGhTjZak0CyGjQuS2ajzASllUnDrlXISdnOPmHcd5yNnqiVDQ==
X-Received: by 2002:a05:6a20:4e13:b0:c6:c85f:da5b with SMTP id gk19-20020a056a204e1300b000c6c85fda5bmr6701062pzb.55.1680714031423;
        Wed, 05 Apr 2023 10:00:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17-20020aa78b11000000b0062dfe944c61sm8397400pfd.218.2023.04.05.10.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 10:00:31 -0700 (PDT)
Message-ID: <642da92f.a70a0220.4ed34.fecf@mx.google.com>
Date:   Wed, 05 Apr 2023 10:00:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-99-g3f25b549b7376
Subject: stable-rc/queue/5.15 baseline: 169 runs,
 9 regressions (v5.15.105-99-g3f25b549b7376)
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

stable-rc/queue/5.15 baseline: 169 runs, 9 regressions (v5.15.105-99-g3f25b=
549b7376)

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

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-99-g3f25b549b7376/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-99-g3f25b549b7376
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f25b549b7376b4f448707360d8b4db40d393a76 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d771de405938fed79e96d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d771de405938fed79e972
        failing since 8 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-05T13:26:36.656922  <8>[   10.938225] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9879580_1.4.2.3.1>

    2023-04-05T13:26:36.659872  + set +x

    2023-04-05T13:26:36.764568  / # #

    2023-04-05T13:26:36.865592  export SHELL=3D/bin/sh

    2023-04-05T13:26:36.865782  #

    2023-04-05T13:26:36.966805  / # export SHELL=3D/bin/sh. /lava-9879580/e=
nvironment

    2023-04-05T13:26:36.967000  =


    2023-04-05T13:26:37.067885  / # . /lava-9879580/environment/lava-987958=
0/bin/lava-test-runner /lava-9879580/1

    2023-04-05T13:26:37.068153  =


    2023-04-05T13:26:37.073788  / # /lava-9879580/bin/lava-test-runner /lav=
a-9879580/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d771f5bc082d8a779e927

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d771f5bc082d8a779e92c
        failing since 8 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-05T13:26:35.492138  + set<8>[   11.708449] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9879598_1.4.2.3.1>

    2023-04-05T13:26:35.492624   +x

    2023-04-05T13:26:35.600961  / # #

    2023-04-05T13:26:35.702328  export SHELL=3D/bin/sh

    2023-04-05T13:26:35.702669  #

    2023-04-05T13:26:35.803464  / # export SHELL=3D/bin/sh. /lava-9879598/e=
nvironment

    2023-04-05T13:26:35.803710  =


    2023-04-05T13:26:35.904902  / # . /lava-9879598/environment/lava-987959=
8/bin/lava-test-runner /lava-9879598/1

    2023-04-05T13:26:35.905466  =


    2023-04-05T13:26:35.910256  / # /lava-9879598/bin/lava-test-runner /lav=
a-9879598/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d7722b736a823e979e963

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d7722b736a823e979e968
        failing since 8 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-05T13:26:42.204648  <8>[   11.095864] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9879577_1.4.2.3.1>

    2023-04-05T13:26:42.208195  + set +x

    2023-04-05T13:26:42.313633  #

    2023-04-05T13:26:42.416861  / # #export SHELL=3D/bin/sh

    2023-04-05T13:26:42.417711  =


    2023-04-05T13:26:42.519671  / # export SHELL=3D/bin/sh. /lava-9879577/e=
nvironment

    2023-04-05T13:26:42.520644  =


    2023-04-05T13:26:42.622855  / # . /lava-9879577/environment/lava-987957=
7/bin/lava-test-runner /lava-9879577/1

    2023-04-05T13:26:42.624392  =


    2023-04-05T13:26:42.629553  / # /lava-9879577/bin/lava-test-runner /lav=
a-9879577/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642d777bb7d00faf1479e939

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642d777bb7d00faf1479e=
93a
        failing since 61 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642d75c65df152187d79e97e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d75c65df152187d79e983
        failing since 78 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-05T13:20:45.058966  + set +x<8>[   10.006090] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3473626_1.5.2.4.1>
    2023-04-05T13:20:45.059688  =

    2023-04-05T13:20:45.169219  / # #
    2023-04-05T13:20:45.272462  export SHELL=3D/bin/sh
    2023-04-05T13:20:45.274001  #
    2023-04-05T13:20:45.376837  / # export SHELL=3D/bin/sh. /lava-3473626/e=
nvironment
    2023-04-05T13:20:45.377777  =

    2023-04-05T13:20:45.378289  / # <3>[   10.273167] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-05T13:20:45.480206  . /lava-3473626/environment/lava-3473626/bi=
n/lava-test-runner /lava-3473626/1
    2023-04-05T13:20:45.481169   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d77946ce3d7934479e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d77946ce3d7934479e927
        failing since 8 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-05T13:28:36.610873  + set +x

    2023-04-05T13:28:36.617078  <8>[   10.128797] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9879601_1.4.2.3.1>

    2023-04-05T13:28:36.721564  / # #

    2023-04-05T13:28:36.822538  export SHELL=3D/bin/sh

    2023-04-05T13:28:36.822748  #

    2023-04-05T13:28:36.923678  / # export SHELL=3D/bin/sh. /lava-9879601/e=
nvironment

    2023-04-05T13:28:36.923857  =


    2023-04-05T13:28:37.024762  / # . /lava-9879601/environment/lava-987960=
1/bin/lava-test-runner /lava-9879601/1

    2023-04-05T13:28:37.025027  =


    2023-04-05T13:28:37.029494  / # /lava-9879601/bin/lava-test-runner /lav=
a-9879601/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d7722688f0ea26679e926

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d7722688f0ea26679e92b
        failing since 8 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-05T13:26:34.164808  <8>[   10.967627] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9879645_1.4.2.3.1>

    2023-04-05T13:26:34.168019  + set +x

    2023-04-05T13:26:34.269614  #

    2023-04-05T13:26:34.370663  / # #export SHELL=3D/bin/sh

    2023-04-05T13:26:34.370907  =


    2023-04-05T13:26:34.471844  / # export SHELL=3D/bin/sh. /lava-9879645/e=
nvironment

    2023-04-05T13:26:34.472107  =


    2023-04-05T13:26:34.573037  / # . /lava-9879645/environment/lava-987964=
5/bin/lava-test-runner /lava-9879645/1

    2023-04-05T13:26:34.573425  =


    2023-04-05T13:26:34.578114  / # /lava-9879645/bin/lava-test-runner /lav=
a-9879645/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d772276f2b3c9b179e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d772276f2b3c9b179e927
        failing since 8 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-05T13:26:34.303645  + set<8>[   11.505701] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9879623_1.4.2.3.1>

    2023-04-05T13:26:34.303852   +x

    2023-04-05T13:26:34.409210  / # #

    2023-04-05T13:26:34.512383  export SHELL=3D/bin/sh

    2023-04-05T13:26:34.513227  #

    2023-04-05T13:26:34.615307  / # export SHELL=3D/bin/sh. /lava-9879623/e=
nvironment

    2023-04-05T13:26:34.616212  =


    2023-04-05T13:26:34.718173  / # . /lava-9879623/environment/lava-987962=
3/bin/lava-test-runner /lava-9879623/1

    2023-04-05T13:26:34.719452  =


    2023-04-05T13:26:34.724258  / # /lava-9879623/bin/lava-test-runner /lav=
a-9879623/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d770e6d092e40ca79e93d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-99-g3f25b549b7376/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d770e6d092e40ca79e942
        failing since 8 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-05T13:26:34.190929  + set +x<8>[    9.608611] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9879638_1.4.2.3.1>

    2023-04-05T13:26:34.191018  =


    2023-04-05T13:26:34.295740  / # #

    2023-04-05T13:26:34.396693  export SHELL=3D/bin/sh

    2023-04-05T13:26:34.396938  #

    2023-04-05T13:26:34.497927  / # export SHELL=3D/bin/sh. /lava-9879638/e=
nvironment

    2023-04-05T13:26:34.498113  =


    2023-04-05T13:26:34.599084  / # . /lava-9879638/environment/lava-987963=
8/bin/lava-test-runner /lava-9879638/1

    2023-04-05T13:26:34.599441  =


    2023-04-05T13:26:34.604261  / # /lava-9879638/bin/lava-test-runner /lav=
a-9879638/1
 =

    ... (12 line(s) more)  =

 =20
