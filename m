Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3E76B5556
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 00:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCJXJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 18:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjCJXJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 18:09:57 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D55813847D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:09:56 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id z10so3960055pgr.8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678489795;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9kdPS4A2254EWAH0s+ExPLGTnY3fyCjrZPOK88jH3xo=;
        b=QzD/3vpTFRIIrvK8NIwUShV7uID4lhHAcMW7O99t8WfrNzTiuTSImI34YtotvfB0aa
         jmRUIVEw5jVgq8R/o4lix1XEjtJJXf5ZRHv1USz9pIOdZiLDfmXFdSoLKKo/fldTekm9
         ezw7CH1+4sizImFpF1Y2pO9hIe6gxFC3r1inWPOaYZcOgwhMuAgUkv8RapLSUBqLSyRY
         k1ccgzEXegKR/wJuHRPl/F0lPrCzUJm/Z/3Owiv0Ip/ye0hskpi+bCEZLX4yGzBPiFnI
         vvnDQKAowV6qW8V95xSPOFfNJIgzOqH/cCZI9oYeaSWMJenOOY9j7U6y1qeJplfdJVkq
         9ySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678489795;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9kdPS4A2254EWAH0s+ExPLGTnY3fyCjrZPOK88jH3xo=;
        b=UyTygkwgcQo/fH6h67KhMF1gtFnCSO5IEQlBji9NQ1DLTcXAp7mz0QxywSgYhYCLWO
         IudXj9XrPW65KtbNeuJHcGiYSvV6iBCdQODW5l3mvarcPGq2sED3ukgene9UFCDTflOU
         twTot/BkDmYGbodZlk3loltaMjSgVCrXObKJePL/yqzuBzSbWiBlLpMr49v50eZ3C63u
         RM/0Q+BHOc29SsokLND1tynUZH82KGFLpGIjwqwZFUkvp5XXQFYCf9irO0bIEyfveXVi
         fHoemFdO+ESpaj/di52bk4iRna8UUYqVTURpuK8o7t74uDvROhdDNfl3CXQyNokxzDfW
         j44A==
X-Gm-Message-State: AO0yUKVh5gWvvxZvfrvfjcfVSXQwLN0TLU47baWrSfhfrF5w31XwUIYN
        a//CiFP9czV1fcUPsMcKMO7ZCBorPArcdlTAzChEmbpm
X-Google-Smtp-Source: AK7set9av5oru1mNzmJnzY/FQkjKODUSxed0D8a6ConSR27qJx8Ykn5ZGjoq+wbBLRUJt3Lq0VZKNg==
X-Received: by 2002:a62:3001:0:b0:5d2:1d72:3b31 with SMTP id w1-20020a623001000000b005d21d723b31mr22649010pfw.2.1678489795364;
        Fri, 10 Mar 2023 15:09:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 22-20020aa79256000000b005a75d85c0c7sm316984pfp.51.2023.03.10.15.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 15:09:55 -0800 (PST)
Message-ID: <640bb8c3.a70a0220.807dd.1b50@mx.google.com>
Date:   Fri, 10 Mar 2023 15:09:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.16-200-gf1fc28d9870a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 176 runs,
 4 regressions (v6.1.16-200-gf1fc28d9870a)
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

stable-rc/queue/6.1 baseline: 176 runs, 4 regressions (v6.1.16-200-gf1fc28d=
9870a)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie   | gcc-10   | bcm2835_defcon=
fig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig  | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig  | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.16-200-gf1fc28d9870a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.16-200-gf1fc28d9870a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1fc28d9870a8491c47371ef2481a95e69e4ffb3 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie   | gcc-10   | bcm2835_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/640b815dbffe3c78288c864a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.16-20=
0-gf1fc28d9870a/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.16-20=
0-gf1fc28d9870a/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b815dbffe3c78288c8653
        new failure (last pass: v6.1.15-888-g401964048e543)

    2023-03-10T19:13:05.593004  + set +x
    2023-03-10T19:13:05.597259  <8>[   17.474926] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 138406_1.5.2.4.1>
    2023-03-10T19:13:05.714459  / # #
    2023-03-10T19:13:05.817602  export SHELL=3D/bin/sh
    2023-03-10T19:13:05.818405  #
    2023-03-10T19:13:05.920977  / # export SHELL=3D/bin/sh. /lava-138406/en=
vironment
    2023-03-10T19:13:05.921810  =

    2023-03-10T19:13:06.023698  / # . /lava-138406/environment/lava-138406/=
bin/lava-test-runner /lava-138406/1
    2023-03-10T19:13:06.024713  =

    2023-03-10T19:13:06.031104  / # /lava-138406/bin/lava-test-runner /lava=
-138406/1 =

    ... (14 line(s) more)  =

 =



platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/640b858dfa308f25598c8647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.16-20=
0-gf1fc28d9870a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.16-20=
0-gf1fc28d9870a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b858dfa308f25598c8=
648
        failing since 5 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8593fa308f25598c865e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.16-20=
0-gf1fc28d9870a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.16-20=
0-gf1fc28d9870a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8593fa308f25598c8=
65f
        failing since 5 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/640b856157ffaa7c818c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.16-20=
0-gf1fc28d9870a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.16-20=
0-gf1fc28d9870a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b856157ffaa7c818c8=
641
        failing since 5 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =20
