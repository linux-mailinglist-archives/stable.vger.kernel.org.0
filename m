Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09316EC270
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 23:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjDWVSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 17:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjDWVSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 17:18:23 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030E6119
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 14:18:22 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b51fd2972so3078437b3a.3
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 14:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682284701; x=1684876701;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7BDxFELqekGFzMJ7Qkn6xhT8fHKtR4rM4QiWA0+EG0U=;
        b=lr/6gT1Oc/AXh4o45/nOWxxarbJBQpuGJHpGLxDF0iZmoTb2pCUZv0gU6u4tixf5y7
         SHQ6RX7G34HETLK7diGuefPyzDbXgZiET9l/XI4MI/10wnm/dWQUlArq93fT9cp3M553
         tNGxc5qmvLbNoRiNj59tGTHZJEE/MMPfPRQa6SatNm66gRTTJDEeQjJRn0Tw5hi/453I
         lqoYsjWof9l0+RPTtjXtzChGxFAHvpHJPpxYtxrx73XJeDAJfO26/ZkLJqNYJ+a1Dyvu
         uU1hMk3a3nXM2uRG3h1q8cJyzoN8bUClxJrOGKL74XaH+KyXZwVYEbzeoDsqllS5pQrb
         HNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682284701; x=1684876701;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7BDxFELqekGFzMJ7Qkn6xhT8fHKtR4rM4QiWA0+EG0U=;
        b=GmWePdHuapXwlAIklcAFYF0ohEQLOEonr9nc2SE+XNsyZKKDrJH4o3qQtkWYj0xnDO
         NQ3oSAa2hBHP4F/K+id54gkXdLdzElN9ynejeJVKhij0/xBfzQ5KDjyG7+vDaAzh6oUC
         bWzkQKMrB3OlVuP3uyshgwkirac1yg4006ipNEkKUc/n95gkvECYSMZcqDughgEZtwG2
         psARNlROlOnB5j886BdcedqUcHc+ggwizsJawgOn+TSx78xijDyh+SGoSfdPMOPMjv5b
         yyBkh82eUo1iQE1aG1plcqOL16BWw08P5QvLpoVJWE7NkUl99IaJ+t4ZZLyTU5UpC7kq
         bFxQ==
X-Gm-Message-State: AAQBX9dJloCF5y/eUNigZTkSSRr94K4DT1nUWwUJMlx7FraDYoGbmd9O
        Y166LQMndNB+MUyqIwqL1j/YC+kg5In7IrT+E+tUkw==
X-Google-Smtp-Source: AKy350Z5sAYOBdT0zlmkPmFpNRdyyTtQo/7KdwDQepcSLLUNSf3eVT2O7+GgruntASfjANfHe30OOw==
X-Received: by 2002:a05:6a20:4321:b0:ec:713f:3cb2 with SMTP id h33-20020a056a20432100b000ec713f3cb2mr16037886pzk.53.1682284701246;
        Sun, 23 Apr 2023 14:18:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l18-20020a62be12000000b0063b7b811ce8sm6020884pff.205.2023.04.23.14.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 14:18:20 -0700 (PDT)
Message-ID: <6445a09c.620a0220.5c169.bf0c@mx.google.com>
Date:   Sun, 23 Apr 2023 14:18:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.238-236-g87ff2b080c307
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 66 runs,
 4 regressions (v5.4.238-236-g87ff2b080c307)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 66 runs, 4 regressions (v5.4.238-236-g87ff2=
b080c307)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
da850-lcdk                   | arm    | lab-baylibre  | gcc-10   | multi_v5=
_defconfig           | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.238-236-g87ff2b080c307/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.238-236-g87ff2b080c307
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87ff2b080c3077985d2269678bff1cb8116c83e6 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
da850-lcdk                   | arm    | lab-baylibre  | gcc-10   | multi_v5=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64456a6ad898aa9b7a2e85fd

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-236-g87ff2b080c307/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da8=
50-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-236-g87ff2b080c307/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da8=
50-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456a6ad898aa9b7a2e8602
        failing since 96 days (last pass: v5.4.227, first fail: v5.4.228-65=
9-gb3b34c474ec7)

    2023-04-23T17:26:39.614783  / # #
    2023-04-23T17:26:39.717850  export SHELL=3D/bin/sh
    2023-04-23T17:26:39.718760  #
    2023-04-23T17:26:39.820877  / # export SHELL=3D/bin/sh. /lava-3524991/e=
nvironment
    2023-04-23T17:26:39.821789  =

    2023-04-23T17:26:39.924102  / # . /lava-3524991/environment/lava-352499=
1/bin/lava-test-runner /lava-3524991/1
    2023-04-23T17:26:39.925809  =

    2023-04-23T17:26:39.966268  / # /lava-3524991/bin/lava-test-runner /lav=
a-3524991/1
    2023-04-23T17:26:40.182786  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-23T17:26:40.185818  + cd /lava-3524991/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644572909d62fc2ea12e85fe

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-236-g87ff2b080c307/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-236-g87ff2b080c307/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/644572909d62fc2e=
a12e8607
        failing since 186 days (last pass: v5.4.219, first fail: v5.4.219-2=
67-g4a976f825745)
        3 lines

    2023-04-23T18:01:28.865247  / # =

    2023-04-23T18:01:28.879689  =

    2023-04-23T18:01:28.984226  / # #
    2023-04-23T18:01:28.988479  #
    2023-04-23T18:01:29.089910  / #export SHELL=3D/bin/sh
    2023-04-23T18:01:29.100519   export SHELL=3D/bin/sh
    2023-04-23T18:01:29.201900  / # . /lava-3525077/environment
    2023-04-23T18:01:29.212595  . /lava-3525077/environment
    2023-04-23T18:01:29.313872  / # /lava-3525077/bin/lava-test-runner /lav=
a-3525077/0
    2023-04-23T18:01:29.324554  /lava-3525077/bin/lava-test-runner /lava-35=
25077/0 =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64456b859ef425eed52e85f9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-236-g87ff2b080c307/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-236-g87ff2b080c307/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456b859ef425eed52e85fe
        failing since 24 days (last pass: v5.4.238, first fail: v5.4.238)

    2023-04-23T17:31:35.360045  + set<8>[   10.676501] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10095351_1.4.2.3.1>

    2023-04-23T17:31:35.360152   +x

    2023-04-23T17:31:35.462549  #

    2023-04-23T17:31:35.462906  =


    2023-04-23T17:31:35.563851  / # #export SHELL=3D/bin/sh

    2023-04-23T17:31:35.564087  =


    2023-04-23T17:31:35.664978  / # export SHELL=3D/bin/sh. /lava-10095351/=
environment

    2023-04-23T17:31:35.665269  =


    2023-04-23T17:31:35.766169  / # . /lava-10095351/environment/lava-10095=
351/bin/lava-test-runner /lava-10095351/1

    2023-04-23T17:31:35.766462  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64456b713310ee153d2e8604

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-236-g87ff2b080c307/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-236-g87ff2b080c307/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456b713310ee153d2e8609
        failing since 24 days (last pass: v5.4.238, first fail: v5.4.238)

    2023-04-23T17:31:13.995987  <8>[   12.742739] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10095291_1.4.2.3.1>

    2023-04-23T17:31:13.999037  + set +x

    2023-04-23T17:31:14.103577  / # #

    2023-04-23T17:31:14.204668  export SHELL=3D/bin/sh

    2023-04-23T17:31:14.204853  #

    2023-04-23T17:31:14.305803  / # export SHELL=3D/bin/sh. /lava-10095291/=
environment

    2023-04-23T17:31:14.305996  =


    2023-04-23T17:31:14.406979  / # . /lava-10095291/environment/lava-10095=
291/bin/lava-test-runner /lava-10095291/1

    2023-04-23T17:31:14.407291  =


    2023-04-23T17:31:14.412460  / # /lava-10095291/bin/lava-test-runner /la=
va-10095291/1
 =

    ... (12 line(s) more)  =

 =20
