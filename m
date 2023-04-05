Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9AE6D7286
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 04:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbjDECe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 22:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbjDECe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 22:34:27 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2074710D2
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 19:34:25 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q20so11571294pfs.2
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 19:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680662064;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=53sYNsqttVyLXERveUKqr+R3WoWVJAGITj+bygzjtdU=;
        b=r9FQcXlzhM925oSRGx27COkwqdkop4VGSj0Tpjbe6RMF/nD3qEfLvxQYw3cvKkyhTC
         c1hCoMtBO5XuQiSa3tsWEh6TpzIlLZSPlFbdBdqc3yzURIZok6kBrun5YzoImGMkPtUm
         gVVPADv0qp/7KSzsV4jDapLm5u6V8cVZ9wwxeDvR9V6d31YqVwAY5kQdcogHM5pyr/WG
         M4uoKgZJ5Iru6ZQ08EWHz8TFocQJK+yr6nJCQsbHG8PlyU8ebHvvC4+A6yqKMDy9ocXG
         czI30qFujK+eMhhp59WAutibjQPEr6rZSBsLBW12EcNzHTAS6e+eQkkcqzeJOEiZcfXq
         ES2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680662064;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=53sYNsqttVyLXERveUKqr+R3WoWVJAGITj+bygzjtdU=;
        b=zBfQ3warbhX7tjzHw9CfrLZAfpAteCMQugUBcwgOP4kXUkL9eQKNgcH4WkholIl2L8
         lMTh1+3WbNMLfaJhprhI1tPJUtOwRdtTvpE5i3ncS/+5hBcWFnabEzlNTJ+WfAhaKH/b
         fP8MhYQ3X1a5d3KKy6nGkv//+AD7JNUfLNU23VkK0LtkQmffFU4eBpAm5xhTOI7xkMY3
         ILhFWoV/nSmPIqseJCWbko4BYAXQ75Zes5p2hU/vSs5584sJhxlIe7gkrlobRjJL+POy
         Ky/iOWP0T6hmxR+e2C7xncp5/iRlxs4VuBa7Dmnn9CU8bohnK7Vw2qaYMxPxCIvNIsv9
         Sgqw==
X-Gm-Message-State: AAQBX9efuvxLQ4F9Falld7ahc/A+DzXs0ZZtjvE7Ofi2SGtx8HOnZdM7
        WojMQLaVrF96AUyFjpKKOieOaG45MGtzMTZGPF5+dg==
X-Google-Smtp-Source: AKy350ZgGjBlAeXo2KF7qxYuH85xbp4idEESmY+dW0GB7GXjHbuj7pCqHtkMGSOKnGiHv66c7rY+Nw==
X-Received: by 2002:aa7:9549:0:b0:626:29ed:941f with SMTP id w9-20020aa79549000000b0062629ed941fmr4431597pfq.5.1680662064225;
        Tue, 04 Apr 2023 19:34:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8-20020aa791c8000000b005a8dcd32851sm9673155pfa.11.2023.04.04.19.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 19:34:23 -0700 (PDT)
Message-ID: <642cde2f.a70a0220.67de0.3e95@mx.google.com>
Date:   Tue, 04 Apr 2023 19:34:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-180-ge7511568ce95
Subject: stable-rc/linux-6.1.y baseline: 135 runs,
 7 regressions (v6.1.22-180-ge7511568ce95)
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

stable-rc/linux-6.1.y baseline: 135 runs, 7 regressions (v6.1.22-180-ge7511=
568ce95)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22-180-ge7511568ce95/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22-180-ge7511568ce95
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7511568ce95fadd2a8f6727b0ace195f8149d94 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ca621d8e63a694a79e940

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ca621d8e63a694a79e945
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T22:34:54.313436  <8>[   10.618246] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9870078_1.4.2.3.1>

    2023-04-04T22:34:54.316522  + set +x

    2023-04-04T22:34:54.424722  / # #

    2023-04-04T22:34:54.527366  export SHELL=3D/bin/sh

    2023-04-04T22:34:54.528033  #

    2023-04-04T22:34:54.629810  / # export SHELL=3D/bin/sh. /lava-9870078/e=
nvironment

    2023-04-04T22:34:54.630433  =


    2023-04-04T22:34:54.732244  / # . /lava-9870078/environment/lava-987007=
8/bin/lava-test-runner /lava-9870078/1

    2023-04-04T22:34:54.733430  =


    2023-04-04T22:34:54.738471  / # /lava-9870078/bin/lava-test-runner /lav=
a-9870078/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ca62becb63fb5cf79e93b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ca62becb63fb5cf79e940
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T22:35:03.606315  + set +x<8>[   11.917084] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9870038_1.4.2.3.1>

    2023-04-04T22:35:03.606483  =


    2023-04-04T22:35:03.711131  / # #

    2023-04-04T22:35:03.813899  export SHELL=3D/bin/sh

    2023-04-04T22:35:03.814165  #

    2023-04-04T22:35:03.915397  / # export SHELL=3D/bin/sh. /lava-9870038/e=
nvironment

    2023-04-04T22:35:03.916158  =


    2023-04-04T22:35:04.018061  / # . /lava-9870038/environment/lava-987003=
8/bin/lava-test-runner /lava-9870038/1

    2023-04-04T22:35:04.019267  =


    2023-04-04T22:35:04.024129  / # /lava-9870038/bin/lava-test-runner /lav=
a-9870038/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ca62bfa392565a979e93d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ca62bfa392565a979e942
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T22:34:59.648030  <8>[   10.994898] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9870091_1.4.2.3.1>

    2023-04-04T22:34:59.651188  + set +x

    2023-04-04T22:34:59.756335  #

    2023-04-04T22:34:59.859236  / # #export SHELL=3D/bin/sh

    2023-04-04T22:34:59.859995  =


    2023-04-04T22:34:59.961958  / # export SHELL=3D/bin/sh. /lava-9870091/e=
nvironment

    2023-04-04T22:34:59.962688  =


    2023-04-04T22:35:00.064639  / # . /lava-9870091/environment/lava-987009=
1/bin/lava-test-runner /lava-9870091/1

    2023-04-04T22:35:00.065766  =


    2023-04-04T22:35:00.071666  / # /lava-9870091/bin/lava-test-runner /lav=
a-9870091/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ca6149acce79cca79e960

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ca6149acce79cca79e965
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T22:34:50.348629  + set +x

    2023-04-04T22:34:50.355290  <8>[   10.625587] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9870030_1.4.2.3.1>

    2023-04-04T22:34:50.460129  / # #

    2023-04-04T22:34:50.561266  export SHELL=3D/bin/sh

    2023-04-04T22:34:50.561499  #

    2023-04-04T22:34:50.662456  / # export SHELL=3D/bin/sh. /lava-9870030/e=
nvironment

    2023-04-04T22:34:50.662686  =


    2023-04-04T22:34:50.763653  / # . /lava-9870030/environment/lava-987003=
0/bin/lava-test-runner /lava-9870030/1

    2023-04-04T22:34:50.764010  =


    2023-04-04T22:34:50.768076  / # /lava-9870030/bin/lava-test-runner /lav=
a-9870030/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ca6084ac9118c8579e946

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ca6084ac9118c8579e94b
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T22:34:33.090007  <8>[   10.148083] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9870104_1.4.2.3.1>

    2023-04-04T22:34:33.093301  + set +x

    2023-04-04T22:34:33.199151  =


    2023-04-04T22:34:33.301347  / # #export SHELL=3D/bin/sh

    2023-04-04T22:34:33.302102  =


    2023-04-04T22:34:33.403802  / # export SHELL=3D/bin/sh. /lava-9870104/e=
nvironment

    2023-04-04T22:34:33.404557  =


    2023-04-04T22:34:33.506680  / # . /lava-9870104/environment/lava-987010=
4/bin/lava-test-runner /lava-9870104/1

    2023-04-04T22:34:33.507967  =


    2023-04-04T22:34:33.512715  / # /lava-9870104/bin/lava-test-runner /lav=
a-9870104/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ca61ffa392565a979e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ca61ffa392565a979e927
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T22:34:48.850182  + set<8>[   11.176173] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9870093_1.4.2.3.1>

    2023-04-04T22:34:48.850277   +x

    2023-04-04T22:34:48.955129  / # #

    2023-04-04T22:34:49.056123  export SHELL=3D/bin/sh

    2023-04-04T22:34:49.056372  #

    2023-04-04T22:34:49.157351  / # export SHELL=3D/bin/sh. /lava-9870093/e=
nvironment

    2023-04-04T22:34:49.157573  =


    2023-04-04T22:34:49.258598  / # . /lava-9870093/environment/lava-987009=
3/bin/lava-test-runner /lava-9870093/1

    2023-04-04T22:34:49.259807  =


    2023-04-04T22:34:49.265030  / # /lava-9870093/bin/lava-test-runner /lav=
a-9870093/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ca6064ac9118c8579e93b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
180-ge7511568ce95/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ca6064ac9118c8579e940
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-04T22:34:30.955837  + set<8>[   12.061837] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9870095_1.4.2.3.1>

    2023-04-04T22:34:30.955931   +x

    2023-04-04T22:34:31.060602  / # #

    2023-04-04T22:34:31.161629  export SHELL=3D/bin/sh

    2023-04-04T22:34:31.161829  #

    2023-04-04T22:34:31.262702  / # export SHELL=3D/bin/sh. /lava-9870095/e=
nvironment

    2023-04-04T22:34:31.262891  =


    2023-04-04T22:34:31.363867  / # . /lava-9870095/environment/lava-987009=
5/bin/lava-test-runner /lava-9870095/1

    2023-04-04T22:34:31.364146  =


    2023-04-04T22:34:31.368481  / # /lava-9870095/bin/lava-test-runner /lav=
a-9870095/1
 =

    ... (12 line(s) more)  =

 =20
