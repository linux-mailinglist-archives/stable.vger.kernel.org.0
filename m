Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689B6526F58
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiENBgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 21:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiENBgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 21:36:06 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0056D38FBEA
        for <stable@vger.kernel.org>; Fri, 13 May 2022 16:41:40 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c11so9323855plg.13
        for <stable@vger.kernel.org>; Fri, 13 May 2022 16:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ndopdyFI2+upuRt9Dhmqoo2PXUrbZEn7TZukb352NXE=;
        b=gJAhySCzhS0orX0yXgmI4MURnPxkUuEhqOEbzKRHaGeAjmJsy/b9xYgkPyYAddCskh
         klXENx8y+0a4+kr3VLLnAFvMvW+1BNl+FACcVbJBxVjTHnS0msdLBzN7PBklS15n3c1f
         5k6p+JPcKDYVexnjJxL2QxSHh8H+Rqa4o23r+lwUFC3qBXZLdfpf/2eIyW9Wrum5fcIm
         a8bZ0kVBW+DKU56zSmon5pywkLpcwbko9IDbH61xGc88qmXcMjQbaKTcKYmEmESEr3uk
         AZI+el0Y/GveQlpewa+WJsdUGvB8ThWD/ACIb1cfkOPJje9JGGzdfTTQhEQiR40g4T4Q
         H0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ndopdyFI2+upuRt9Dhmqoo2PXUrbZEn7TZukb352NXE=;
        b=aRpLZ0bh4Zzub6pIYdncxyyn8Cfj+GdxxKH+KbxLir+BFsm7qeLKOJMXqDgQWNdxM8
         AH9/RzZD/qctiRSOFkIBczrh62OUorRCwRlcwAN7jJo85JZPvNanjcxbU3pPv2INgO55
         zYPR8NrvUzf7H6OZ1H5DIxmcJzM6HsH3GAgmetWshSFwSWTX2zpBP5Keq2rFcLn9o8nL
         OuUZjpdoGRBUx8yEEhfpP35yQAkVNKmK19tzlzg5QWiZ4+7LYfdVZxvg5ESvU88TB1hp
         4qq4XOag1YfC2NOH349XNZlLDecb5eiitD53A8QXlISsQ6IcOrhvGlKrX74FuN8fuKuE
         6y8g==
X-Gm-Message-State: AOAM533Xox9iSZ/9BC9FRF0gL6tryD+sDRAUAuKGD1vR2Y1b/GVEkls+
        y8pxnrL9iEqSSKHnvDY4ibyXfPxx5MajnsvMnQY=
X-Google-Smtp-Source: ABdhPJycg8I/IbuZc1Wghp444mA329QqukKduRB2cJDcwOyH2ryl2GY+c+CIYpdjkDrDqPnB4A7UmQ==
X-Received: by 2002:a17:90b:4b4e:b0:1dc:74d0:c8d4 with SMTP id mi14-20020a17090b4b4e00b001dc74d0c8d4mr7228849pjb.138.1652485300061;
        Fri, 13 May 2022 16:41:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gd23-20020a17090b0fd700b001d792761e2esm4135518pjb.47.2022.05.13.16.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 16:41:39 -0700 (PDT)
Message-ID: <627eecb3.1c69fb81.d4bb7.ac9e@mx.google.com>
Date:   Fri, 13 May 2022 16:41:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.115-10-g6d9472bc9d79
Subject: stable-rc/queue/5.10 baseline: 145 runs,
 8 regressions (v5.10.115-10-g6d9472bc9d79)
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

stable-rc/queue/5.10 baseline: 145 runs, 8 regressions (v5.10.115-10-g6d947=
2bc9d79)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.115-10-g6d9472bc9d79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.115-10-g6d9472bc9d79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d9472bc9d790273efbe0fa8460dc91695630f88 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627ebdccb557446f5c8f574e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ebdccb557446f5c8f5=
74f
        failing since 3 days (last pass: v5.10.113-129-g2a88b987a070, first=
 fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627ec4ce739565bebf8f5717

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ec4ce739565bebf8f5=
718
        failing since 3 days (last pass: v5.10.113-129-g2a88b987a070, first=
 fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627ebddfac3d4701928f571a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ebddfac3d4701928f5=
71b
        failing since 3 days (last pass: v5.10.113-129-g2a88b987a070, first=
 fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627ec4f60607e27d618f5718

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ec4f60607e27d618f5=
719
        failing since 3 days (last pass: v5.10.113-129-g2a88b987a070, first=
 fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627ebdde391f5a40668f5738

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ebdde391f5a40668f5=
739
        failing since 3 days (last pass: v5.10.113-129-g2a88b987a070, first=
 fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627ec4ba748a4450d38f5722

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ec4ba748a4450d38f5=
723
        failing since 3 days (last pass: v5.10.113-129-g2a88b987a070, first=
 fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627ebddcac3d4701928f5717

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ebddcac3d4701928f5=
718
        failing since 3 days (last pass: v5.10.113-129-g2a88b987a070, first=
 fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627ec3a3d3e22ab3d58f5746

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.115=
-10-g6d9472bc9d79/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ec3a3d3e22ab3d58f5=
747
        failing since 3 days (last pass: v5.10.113-129-g2a88b987a070, first=
 fail: v5.10.113-195-g7c30a988fd24) =

 =20
