Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB5B6AAC17
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 20:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCDTT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 14:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjCDTT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 14:19:27 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD9313D5A
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 11:19:23 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so9457977pjh.0
        for <stable@vger.kernel.org>; Sat, 04 Mar 2023 11:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677957562;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=61otmLAOuvbMxR5pqKdwv8UIb6vLPInWgIg+/V5kkRg=;
        b=1YICMZlLmhJjAidN3zDr2DrNlHuuJMmHLRUerZbuGSic6yqwENBU4Ntt0LUUAUJFGZ
         He+qAUFKIlWSpXJF4jpp30ICaVfTm7hsr4jEs2Q9NDfH4QUbvPHTUYKwEtmvxpCvqPzz
         3TT6fNi6sz3Jp1B2UjPbRY1rma4DaEvKh8npEfzXpin+ibQIw0I4epe3styzz6iQtLDm
         5yaDctEYgJg5ySVzqCIE8JYTrMqI3+abUfnB0jIFkJSOx6ELE3WNu3w1TETO4RWkRzXs
         H0JEqthGI6g1IKm2v0TY7G6SZXFEdl31dt6asKwlm0Awq1B66+nrBkil4VkfYengWqjm
         HuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677957562;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=61otmLAOuvbMxR5pqKdwv8UIb6vLPInWgIg+/V5kkRg=;
        b=TVedFKrIxxhoBiuwJgWbR73pPRtrv9oJyp0efJDagoIAMDZPrGBF8B8pdeoejfjt8K
         wFw5qksx1bitKjyiCJ7Ss2hQoF9p1u9dGMmcihzqaxkb7go8gu8pOdk0ZPM8qvii/CYD
         R1kFVpSzDEP9B0Kzg715MEcqzOd8vVkDjalCAU7dW8zHvIHyJosRORZY2MqNtU5QXWXr
         IHtd4WrMCiJxcfpQA0PQJzKY60BGogDa3UIBRqb5YkGGKwRXrepfnq5jQZ9JeMQM+Up+
         i/T1A327x6cNGbMqc8h877+45Po94o+lzoft3HnPVdkmRKXUAK7kObJA7DJICE4phxES
         9acA==
X-Gm-Message-State: AO0yUKVeYRiNLk5xbEkUPr10aOj0+n2fP+FPlo/VnWoEqgnldbBnkh6R
        qDqKLAUrJVGyan7LAEs3mZchPVBmphoyw1mx/65sKdZa
X-Google-Smtp-Source: AK7set+xK2IBytpV0yGP4f0N64/2fysoX5F7bTm40HZ/GtmJP6t7m4hhmqtUduWpP3wZ9/qcZkUTIA==
X-Received: by 2002:a17:902:f691:b0:19d:1fce:c9ec with SMTP id l17-20020a170902f69100b0019d1fcec9ecmr7836440plg.37.1677957561819;
        Sat, 04 Mar 2023 11:19:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kt4-20020a170903088400b00186cf82717fsm3684644plb.165.2023.03.04.11.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 11:19:21 -0800 (PST)
Message-ID: <640399b9.170a0220.4aa99.7343@mx.google.com>
Date:   Sat, 04 Mar 2023 11:19:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.234-3-gd386ca8d984d1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 186 runs,
 42 regressions (v5.4.234-3-gd386ca8d984d1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 186 runs, 42 regressions (v5.4.234-3-gd386ca8=
d984d1)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

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

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.234-3-gd386ca8d984d1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.234-3-gd386ca8d984d1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d386ca8d984d13fb7809f4cc723d2c5b433915b5 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6403675230c984339e8c8659

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6403675230c984339e8c8662
        failing since 33 days (last pass: v5.4.230-81-g2ad0dc06d587, first =
fail: v5.4.230-108-g761a8268d868)

    2023-03-04T15:44:01.165404  <8>[    9.840753] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3385188_1.5.2.4.1>
    2023-03-04T15:44:01.273650  / # #
    2023-03-04T15:44:01.377099  export SHELL=3D/bin/sh
    2023-03-04T15:44:01.378269  #
    2023-03-04T15:44:01.480397  / # export SHELL=3D/bin/sh. /lava-3385188/e=
nvironment
    2023-03-04T15:44:01.481517  =

    2023-03-04T15:44:01.583810  / # . /lava-3385188/environment/lava-338518=
8/bin/lava-test-runner /lava-3385188/1
    2023-03-04T15:44:01.585402  =

    2023-03-04T15:44:01.585894  / # /lava-3385188/bin/lava-test-runner /lav=
a-3385188/1<3>[   10.240578] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-04T15:44:01.590318   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6403627e1594753d818c867f

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6403627e1594753d=
818c8684
        failing since 136 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-03-04T15:23:20.222267  / # =

    2023-03-04T15:23:20.223151  =

    2023-03-04T15:23:22.287328  / # #
    2023-03-04T15:23:22.287949  #
    2023-03-04T15:23:24.301540  / # export SHELL=3D/bin/sh
    2023-03-04T15:23:24.301997  export SHELL=3D/bin/sh
    2023-03-04T15:23:26.318029  / # . /lava-3385046/environment
    2023-03-04T15:23:26.318451  . /lava-3385046/environment
    2023-03-04T15:23:28.333725  / # /lava-3385046/bin/lava-test-runner /lav=
a-3385046/0
    2023-03-04T15:23:28.335719  /lava-3385046/bin/lava-test-runner /lava-33=
85046/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6403654bb8232c41558c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403654bb8232c41558c8=
64a
        failing since 298 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640368430b9ab00d958c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640368430b9ab00d958c8=
631
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6403658a1f6e98728a8c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403658a1f6e98728a8c8=
641
        failing since 298 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640368842506b2d6238c8656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640368842506b2d6238c8=
657
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640365c7d2ca1387788c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640365c7d2ca1387788c8=
653
        failing since 298 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6403683557534e42ff8c866d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403683557534e42ff8c8=
66e
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64036549bd34520d048c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64036549bd34520d048c8=
651
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640368440b9ab00d958c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640368440b9ab00d958c8=
634
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64036576e4ee017b1b8c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64036576e4ee017b1b8c8=
633
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640368974c0210aeb78c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640368974c0210aeb78c8=
63e
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6403652758b4bd574a8c865a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403652758b4bd574a8c8=
65b
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6403683957534e42ff8c867b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403683957534e42ff8c8=
67c
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6403654cb8232c41558c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403654cb8232c41558c8=
652
        failing since 298 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6403684102045094948c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403684102045094948c8=
630
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640365c6a1708cefe98c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640365c6a1708cefe98c8=
651
        failing since 298 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640368476aea5834e78c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640368476aea5834e78c8=
65d
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6403661717fa1d4b6f8c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403661717fa1d4b6f8c8=
651
        failing since 298 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640368255756bc40f38c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640368255756bc40f38c8=
64f
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64036547b8232c41558c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64036547b8232c41558c8=
638
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64036842fa6b8161928c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64036842fa6b8161928c8=
630
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6403654eb8232c41558c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403654eb8232c41558c8=
655
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64036883e1cfeef4788c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64036883e1cfeef4788c8=
649
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6403652c8fe0f8b18f8c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403652c8fe0f8b18f8c8=
63c
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6403683357534e42ff8c8667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403683357534e42ff8c8=
668
        failing since 221 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/64036571f4c5f4461b8c8671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64036571f4c5f4461b8c8=
672
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/640366a2190c330eab8c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640366a2190c330eab8c8=
65a
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/6403667bfc2e0681e88c865a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6403667bfc2e0681e88c8=
65b
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640365bed2ca1387788c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640365bed2ca1387788c8=
631
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640369a70b88e576398c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640369a70b88e576398c8=
630
        failing since 18 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640366de9cc7ce6c4f8c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640366de9cc7ce6c4f8c8=
643
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640369fffe16ad54168c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640369fffe16ad54168c8=
631
        failing since 18 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64036695190c330eab8c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64036695190c330eab8c8=
656
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640369a16e57d3d2218c8695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640369a16e57d3d2218c8=
696
        failing since 18 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640365bfd2ca1387788c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640365bfd2ca1387788c8=
637
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640369a87a8b113f0b8c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640369a87a8b113f0b8c8=
647
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640366f26e7911d4a18c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640366f26e7911d4a18c8=
64b
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64036a26553c868cf18c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64036a26553c868cf18c8=
630
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640366a39b30de98298c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640366a39b30de98298c8=
637
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640369b00b88e576398c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640369b00b88e576398c8=
63b
        failing since 18 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64036728f0998bc84d8c8641

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.234-3=
-gd386ca8d984d1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64036728f0998bc84d8c864a
        failing since 31 days (last pass: v5.4.230-108-g761a8268d868, first=
 fail: v5.4.230-109-g0a6085bff265)

    2023-03-04T15:43:09.182195  / # #
    2023-03-04T15:43:09.284548  export SHELL=3D/bin/sh
    2023-03-04T15:43:09.285088  #
    2023-03-04T15:43:09.386480  / # export SHELL=3D/bin/sh. /lava-3385189/e=
nvironment
    2023-03-04T15:43:09.387047  =

    2023-03-04T15:43:09.488487  / # . /lava-3385189/environment/lava-338518=
9/bin/lava-test-runner /lava-3385189/1
    2023-03-04T15:43:09.489357  =

    2023-03-04T15:43:09.506660  / # /lava-3385189/bin/lava-test-runner /lav=
a-3385189/1
    2023-03-04T15:43:09.594505  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-04T15:43:09.595052  + cd /lava-3385189/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
