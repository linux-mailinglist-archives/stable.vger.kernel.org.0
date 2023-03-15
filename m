Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55DC6BBC62
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjCOSjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjCOSi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:38:56 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1CD20067
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:38:20 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p6so21126020plf.0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678905490;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eg/p+nyYGCC8NjuJZLtvD775u8VBjcOBJJJbjpQk/qM=;
        b=mwnoBs6w9JYSYn66i2e3HyRPGXQp308+4moSUEQGoL73oD1ovQOP1vPHfara/YTnWl
         ZQa6v1ykEEH3WZOoZx714hbZGQ1MAWOaz5gT2fNA+iORfPThWbLvddAqUbfiWaZm25Ov
         vnHkutrM0nLtV9JBYaxTFGACL+ZhmE0GuCOX5Kj3D4TPnFvtJ7W1d8rx7+Js4EmBj+VI
         jPLs8ENCxgch5cNgNqMwHCSCOLVYSXgECmpjPLQu0ZbNs0MBl5oCM/0SA8HVDDlZR+0K
         7wIhDsAfqWPTIHNMZCrGbQHzO6kWLNVB/IUXAP92qUdKw3rLd8egc9W2SI+fPMSfqNW+
         ws6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678905490;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eg/p+nyYGCC8NjuJZLtvD775u8VBjcOBJJJbjpQk/qM=;
        b=0+qF2dMPgKs4AZeuz2i1KwBPth9H6tA4tAn3ZlVNU8kxmAsbf3Kseoa910YVPCZGA6
         Zr0wMnjC0vqSL/hVAmFpzP9ETT2hg+FQURYGQnS/6cZAw+8WFQBiD/ZVKiGK1MvY5Rrc
         RWjnWlLJvOGALTUpHuinYWHn5nzeqfsXPexxTtkEIF1KvgB3ZhNmVAWRncwneTBCDkHV
         vP+0kV9NxrWEkgu9U859Z8KxvXZsVdATI5edUBpgpUDC5C+yEEvkEGsdhuSl0akCrPt9
         h1YMwQsQjl8Q75LxeQzAPtPAOoT4igc4AY4f7wPIsW7NgKoZW9ZH6F76aJTgwud/5B4g
         OCYQ==
X-Gm-Message-State: AO0yUKU322IvPanHK94x53ggscvDTG5LyvM9zZ+cQVZfrG5ZPlhcsh4S
        Hy37WUM5EIzEGstJhi0bcAxuRa6d7kzEWmfhLTgopNeb
X-Google-Smtp-Source: AK7set82pOT527yYBjJc227zIvzn7D9/NY6mov8qk0Umz3Ld+gfOOAGK156US8EUHGyTaDm4dD/Akg==
X-Received: by 2002:a05:6a20:4987:b0:d6:7d3a:c78 with SMTP id fs7-20020a056a20498700b000d67d3a0c78mr806597pzb.1.1678905489803;
        Wed, 15 Mar 2023 11:38:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y2-20020a655b02000000b00478c48cf73csm3599811pgq.82.2023.03.15.11.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 11:38:09 -0700 (PDT)
Message-ID: <64121091.650a0220.19679.7ed8@mx.google.com>
Date:   Wed, 15 Mar 2023 11:38:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.308-25-g9872a4efa94f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 134 runs,
 23 regressions (v4.14.308-25-g9872a4efa94f)
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

stable-rc/queue/4.14 baseline: 134 runs, 23 regressions (v4.14.308-25-g9872=
a4efa94f)

Regressions Summary
-------------------

platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
hp-x360-14-G1-sona         | x86_64 | lab-collabora | gcc-10   | x86_64_def=
con...6-chromebook | 1          =

meson-gxl-s905x-khadas-vim | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =

meson8b-odroidc1           | arm    | lab-baylibre  | gcc-10   | multi_v7_d=
efconfig           | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

rk3399-gru-kevin           | arm64  | lab-collabora | gcc-10   | defconfig+=
arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.308-25-g9872a4efa94f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.308-25-g9872a4efa94f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9872a4efa94fc6f15d40ed2520664c8f925219a2 =



Test Regressions
---------------- =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
hp-x360-14-G1-sona         | x86_64 | lab-collabora | gcc-10   | x86_64_def=
con...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411ded6f60c97a69a8c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411ded6f60c97a69a8c8=
647
        failing since 0 day (last pass: v4.14.308-22-gb3edefd64b5f0, first =
fail: v4.14.308-24-ge21306554563) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
meson-gxl-s905x-khadas-vim | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de4f0a5f2b142f8c8656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de4f0a5f2b142f8c8=
657
        failing since 253 days (last pass: v4.14.285-35-g61a723f50c9f, firs=
t fail: v4.14.285-46-ga87318551bac) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
meson8b-odroidc1           | arm    | lab-baylibre  | gcc-10   | multi_v7_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6411ddab99d3309d2c8c8647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411ddab99d3309d2c8c8=
648
        failing since 395 days (last pass: v4.14.266-18-g18b83990eba9, firs=
t fail: v4.14.266-28-g7d44cfe0255d) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de566b24d05fb58c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de566b24d05fb58c8=
630
        failing since 309 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411e0f64165669eed8c868e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411e0f64165669eed8c8=
68f
        failing since 309 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de5ac730fea2e38c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de5ac730fea2e38c8=
635
        failing since 309 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411e2043eca7a5e388c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411e2043eca7a5e388c8=
633
        failing since 309 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de4ed3de1b65a28c865a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de4ed3de1b65a28c8=
65b
        failing since 309 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411e0fa975a95aae48c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411e0fa975a95aae48c8=
63e
        failing since 309 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de56d3de1b65a28c8669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de56d3de1b65a28c8=
66a
        failing since 309 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411e2173eca7a5e388c8679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411e2173eca7a5e388c8=
67a
        failing since 309 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de546ee67d066f8c8681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de546ee67d066f8c8=
682
        failing since 309 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411e0f44165669eed8c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411e0f44165669eed8c8=
64a
        failing since 309 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de596b24d05fb58c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de596b24d05fb58c8=
636
        failing since 309 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411e0d64165669eed8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411e0d64165669eed8c8=
631
        failing since 309 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de522c8e464d9b8c8680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de522c8e464d9b8c8=
681
        failing since 232 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411e0f547c1367d398c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411e0f547c1367d398c8=
632
        failing since 232 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de570a5f2b142f8c8662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de570a5f2b142f8c8=
663
        failing since 232 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411e2033eca7a5e388c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411e2033eca7a5e388c8=
630
        failing since 232 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411de4d6ee67d066f8c8673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411de4d6ee67d066f8c8=
674
        failing since 232 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6411e0a54ad16c1c1e8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411e0a54ad16c1c1e8c8=
631
        failing since 232 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
rk3399-gru-kevin           | arm64  | lab-collabora | gcc-10   | defconfig+=
arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6411e0f4cf1c1cb2c48c863b

  Results:     49 PASS, 23 FAIL, 2 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.308=
-25-g9872a4efa94f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6411e0f4cf1c1cb2c48c8643
        failing since 1 day (last pass: v4.14.307-192-gb83524918e9da, first=
 fail: v4.14.308-15-gf690886b9316f)

    2023-03-15T15:14:54.757264  /lava-9633881/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6411e0f4cf1c1cb2c48c865f
        failing since 1 day (last pass: v4.14.307-192-gb83524918e9da, first=
 fail: v4.14.308-15-gf690886b9316f)

    2023-03-15T15:14:52.718757  [   48.447469] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-15T15:14:53.732418  /lava-9633881/1/../bin/lava-test-case

    2023-03-15T15:14:53.742272  [   49.472000] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
