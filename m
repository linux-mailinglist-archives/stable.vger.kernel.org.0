Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED256B5125
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 20:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjCJTwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 14:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjCJTwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 14:52:37 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15C616AFE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:52:34 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id kb15so6370836pjb.1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678477954;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pgTzwdLG18CM9V4k87l40QybxjriMIzut3ZB3RMGFsI=;
        b=PZ/BfRv7mlCbrw6HQI5Fvmk0Mfk2pGQFI56/c1ADXzoiblHQBsLG4HcPFzdBftvQw+
         o6hQ/2SJXNOHFGDOcPIX4i/21x2vlbp+06Mct9ZG1QJraLfSW6Sko6LM9RwdcOTa18+h
         LTM5hjKCzTGA2cKyfozvWdJGx5S/+Fp5DJ/WUpxO/AtWjrkMvZAd5u+ySjXJn9r9LSQt
         qZfEaexseXoSLdLEct5h8p7i7PffRffmQF6QCp1CS0dnU4Inedllza3mPgESWqjjyjDp
         6eB0RKr6nMyfd/YiXvwr85UQYlxYrjuDgYhtftpIQI0a/nVbmrMgMBb+HPltuOlMkE5+
         r1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678477954;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pgTzwdLG18CM9V4k87l40QybxjriMIzut3ZB3RMGFsI=;
        b=xD2XVJ3h/4HrtGjllpVvmJxs6kF9FLlxRhMNscZ+oyyf8lY0Z19mQ1I9McwaOPJVBN
         U4JG3shKYp7IXBCMly1cVXwrEpxR+Ik3+EDPSLlNiS+Wa3qmX0wyy536Z9QtDVgwFd2E
         wxCkQV4npJp77AO3JPRoTZcJcjApX+QpwrA3ihB1soiHCM4po3p+UMce6iM1eHKKGvwC
         TrTy2BdZJuTO/nWpJZoQSuKIGONQa263Irz5MLvXlIhq1AhK4A7whWNYYy/8o85FPN3l
         Me8NC1g5QN+w6UyFdFIRX32FHhjAJET92Yxh5Asn7g+6+S+ENe6IAAcbyHr+SR1SGp/H
         gQhg==
X-Gm-Message-State: AO0yUKVsMxDuRI1cwxGDqR1lMJ8kQRkd+HqyP3l90KFGun6prGQfFlnI
        oUb8akax4GnXB9l3xTCSoLhaaUrAgWeqzwDh6tjjZKtm
X-Google-Smtp-Source: AK7set/OrKRET6U8RlmKyQVlryvFB5zRfow/lAHAtUfo7BsqQAyzleOOdWpN9kzFx+L8UNSb3KqxcA==
X-Received: by 2002:a17:90b:33c7:b0:233:e426:6501 with SMTP id lk7-20020a17090b33c700b00233e4266501mr27115218pjb.19.1678477953640;
        Fri, 10 Mar 2023 11:52:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6-20020a17090ad48600b00233db0db3dfsm333723pju.7.2023.03.10.11.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 11:52:33 -0800 (PST)
Message-ID: <640b8a81.170a0220.e695f.0fc8@mx.google.com>
Date:   Fri, 10 Mar 2023 11:52:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.99
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 237 runs, 27 regressions (v5.15.99)
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

stable/linux-5.15.y baseline: 237 runs, 27 regressions (v5.15.99)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

mt8173-elm-hana              | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm...ok+kselftest | 1          =

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.99/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      abddfcf701a5427cb1bddeaa130bceb72b160aa5 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/640b55d68bd344d6e08c864b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-acer-cb317-1h-c3z6-dedede.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-acer-cb317-1h-c3z6-dedede.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b55d68bd344d6e08c8=
64c
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b5742bb14403f358c870f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-acer-cb=
317-1h-c3z6-dedede.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-acer-cb=
317-1h-c3z6-dedede.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b5742bb14403f358c8=
710
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/640b55d8f3da2397808c8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b55d8f3da2397808c8=
654
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b57537f20be6ec88c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C4=
33TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C4=
33TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b57537f20be6ec88c8=
653
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/640b55c2484a2e3cf08c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b55c2484a2e3cf08c8=
63a
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b57538a63cbf92f8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C4=
36FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C4=
36FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b57538a63cbf92f8c8=
630
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/640b55d6e1a4eccf778c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b55d6e1a4eccf778c8=
632
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b5741bb14403f358c870c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx=
9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx=
9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b5741bb14403f358c8=
70d
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640b5758ec2b9010e08c8667

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b5758ec2b9010e08c866f
        failing since 50 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-03-10T16:14:00.792265  + set +x<8>[    9.946290] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3402190_1.5.2.4.1>
    2023-03-10T16:14:00.792454  =

    2023-03-10T16:14:00.898699  / # #
    2023-03-10T16:14:01.000113  export SHELL=3D/bin/sh
    2023-03-10T16:14:01.000643  #
    2023-03-10T16:14:01.102399  / # export SHELL=3D/bin/sh. /lava-3402190/e=
nvironment
    2023-03-10T16:14:01.103038  =

    2023-03-10T16:14:01.205152  / # . /lava-3402190/environment/lava-340219=
0/bin/lava-test-runner /lava-3402190/1
    2023-03-10T16:14:01.206042  =

    2023-03-10T16:14:01.206393  / # /lava-3402190/bin/lava-test-runner /lav=
a-3402190/1<3>[   10.353358] Bluetooth: hci0: command 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/640b55d68bd344d6e08c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b55d68bd344d6e08c8=
651
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b5754ec2b9010e08c8661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-dell-la=
titude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-dell-la=
titude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b5754ec2b9010e08c8=
662
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/640b586c57a353d1e98c8658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b586c57a353d1e98c8=
659
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b58bb1e4c5715258c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-dell-la=
titude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-dell-la=
titude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b58bb1e4c5715258c8=
635
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/640b5704238fc8d5fb8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/baseli=
ne-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b5704238fc8d5fb8c8=
630
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b587f924e47947e8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360=
-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360=
-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b587f924e47947e8c8=
631
        new failure (last pass: v5.15.98) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
mt8173-elm-hana              | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/640b57a20c54b03be98c8645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b57a20c54b03be98c8=
646
        failing since 45 days (last pass: v5.15.89, first fail: v5.15.90) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b519cd2ae8951578c86a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/i=
386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/i=
386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b519cd2ae8951578c8=
6a3
        failing since 23 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b568425a0f272e78c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/i=
386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/i=
386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b568425a0f272e78c8=
632
        failing since 23 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b531ba8dcbc60f68c8672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b531ba8dcbc60f68c8=
673
        failing since 23 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b577bc99fc5dbe68c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b577bc99fc5dbe68c8=
630
        failing since 23 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b581531da90292b8c869a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b581531da90292b8c8=
69b
        failing since 23 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b599141d661fa058c8667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b599141d661fa058c8=
668
        failing since 23 days (last pass: v5.15.93, first fail: v5.15.94) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b577c80f29d8e5b8c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x86=
_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b577c80f29d8e5b8c8=
633
        failing since 13 days (last pass: v5.15.92, first fail: v5.15.96) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b580131da90292b8c8673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b580131da90292b8c8=
674
        failing since 13 days (last pass: v5.15.90, first fail: v5.15.96) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b59f50c5a3e80138c864f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86_=
64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b59f50c5a3e80138c8=
650
        failing since 13 days (last pass: v5.15.92, first fail: v5.15.96) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b5307875e6c59628c866a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi-mixed=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi-mixed=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b5307875e6c59628c8=
66b
        failing since 13 days (last pass: v5.15.90, first fail: v5.15.96) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b5740bb14403f358c8709

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.99/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b5740bb14403f358c8=
70a
        failing since 13 days (last pass: v5.15.92, first fail: v5.15.96) =

 =20
