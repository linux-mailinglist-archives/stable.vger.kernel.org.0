Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C29E5874B3
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 02:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbiHBAGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 20:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbiHBAGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 20:06:43 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751492AE1
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 17:06:42 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d16so3825484pll.11
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 17:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5BJFAXvg+yQTQg/DqK+yLd76ce/q1ovbWNTJGR9dw5Q=;
        b=Bc4kef7+QPQeOkVkhX3a7X+1OTaDOjEl5nQ8Z5YMLQXj41d1Vt89HW4ruF+lfN5Ymh
         E+SegZXeC4mMb5AkWXskE830fIB+OyesuABIVkZXULXoAWFTW5jQOqSQfKlZjKLWbkCL
         aKldEaJ3c1hpZ99szqI/wLgxLZJ9D2Fh82Fh6jwhvFoff1lvGeIUiSAszJThTU2x3Sv5
         Zg6pr20HNxcal7rIhJXLUDlxvElkwjMeskNa1y4k2SvN2lm0kV0teV2AZPfC2+tstBv6
         JbfTw9jCAIvPnLx6ddh3umBKIr8AU51Vltlt7vgzu0dgGs0qJXaX9rBEgQaiAfbSdZTU
         Uh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5BJFAXvg+yQTQg/DqK+yLd76ce/q1ovbWNTJGR9dw5Q=;
        b=cTIqOc5BjlMxHHIOIpXYmqY3E3jxNLZw7X6Yhapm09EztLhc3UyiauRXRkQQ9hIxPX
         CeiBUc/dEo9vHiYGHNWBMmC34UdyNPQLd9Yqcs46+6/OcVvv3g2MXm9iOr9uFTqnZ/sQ
         Dyw5aFEW5Ybe7K8OYaGe5AaschidFLYA3+HouDOu/lZv/CFDEIYJ7FRRHCc01dRXMxcu
         NRPaY0eXQAKKgbEDeheBLpwpPiZJBIZv83WYw6Oqg4acWDZDr464J0IeqNnFRlFVhYXj
         KixV/FK6JcZtl3emVA6/QJhVX0RQPANdKglqCXvpOCzByP1VMs7B+tkxTwh5cPSe5WA0
         M/Nw==
X-Gm-Message-State: ACgBeo1Ct5LknxyuYDOiDp9UHkqrJKLC1rUdXQbRYU5IG6nwZfw8Nh6H
        opM5nJ1NPHnK43lY5fovANspuqW8PfIylln/veA=
X-Google-Smtp-Source: AA6agR5CZmCiidZZhKyHxJyriGPcYnkdksi65XNsFEXA8StDMFvuSgKaPrIkD8ZSR77ysY6AGt0C6g==
X-Received: by 2002:a17:903:234c:b0:16f:352:8917 with SMTP id c12-20020a170903234c00b0016f03528917mr1480989plh.61.1659398801815;
        Mon, 01 Aug 2022 17:06:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b0016bdc98730bsm10305871plh.151.2022.08.01.17.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 17:06:41 -0700 (PDT)
Message-ID: <62e86a91.170a0220.68bba.fb99@mx.google.com>
Date:   Mon, 01 Aug 2022 17:06:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.207-122-g3e701f9f7740c
Subject: stable-rc/queue/5.4 baseline: 73 runs,
 7 regressions (v5.4.207-122-g3e701f9f7740c)
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

stable-rc/queue/5.4 baseline: 73 runs, 7 regressions (v5.4.207-122-g3e701f9=
f7740c)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.207-122-g3e701f9f7740c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.207-122-g3e701f9f7740c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e701f9f7740c5d26751ce171896201c8158374b =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e83a33b7652b7131daf092

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e83a33b7652b7131daf=
093
        failing since 6 days (last pass: v5.4.180-77-g7de29e82b9db, first f=
ail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e83a2a582053ce7adaf06e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e83a2a582053ce7adaf=
06f
        failing since 6 days (last pass: v5.4.180-77-g7de29e82b9db, first f=
ail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e83a49b6bb4ce0dadaf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e83a49b6bb4ce0dadaf=
065
        failing since 83 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e83a34b6bb4ce0dadaf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e83a34b6bb4ce0dadaf=
058
        failing since 6 days (last pass: v5.4.180-77-g7de29e82b9db, first f=
ail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e83a2c582053ce7adaf07c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e83a2c582053ce7adaf=
07d
        failing since 6 days (last pass: v5.4.180-77-g7de29e82b9db, first f=
ail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e83a477de5c5aa76daf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e83a477de5c5aa76daf=
069
        failing since 6 days (last pass: v5.4.180-77-g7de29e82b9db, first f=
ail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e83a29582053ce7adaf06b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g3e701f9f7740c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e83a29582053ce7adaf=
06c
        failing since 6 days (last pass: v5.4.180-77-g7de29e82b9db, first f=
ail: v5.4.207-73-ga2480f1b1dda1) =

 =20
