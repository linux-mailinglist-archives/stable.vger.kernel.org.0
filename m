Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2E765A531
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 15:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiLaO4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 09:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiLaO4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 09:56:30 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9296CB04
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 06:56:28 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id m4so24678509pls.4
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 06:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkeXf7r9I3ISIjYyW1D+4Jwb2+4vgFvkdy/Wc8BRNvc=;
        b=1bWoboMPA5pTTT6M6W/s7uJpVXkbMXIZ8GTcaApvQkmxvLYyBV3ptXlERcgMADS1P3
         y9k88kUc/xJ4W2U440CbNGV+rzbcU+ubEhozYznP4zJZZuLdqwQFaU9kGT6R+fk7VtjS
         a1g0JDarYbpykoCMj6U1I0RgNz4nlmg4XstlLffWHQsRJ2FGG3koyq5n76aic6QimsLd
         ydOwXBZe2C0iJTKJBnopjofsyCvLvMtRFoXHUrjr3mKKEku9VKitDYYfNFdHTpVIdhAk
         XImM3KI6fXEdgmvRINQ0dfMCDySK0BadbdQinRuG2KMGUChOme7YNOCvIceCaz0/gkFr
         1FLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZkeXf7r9I3ISIjYyW1D+4Jwb2+4vgFvkdy/Wc8BRNvc=;
        b=iOsEOq4YQ3HiKnfaz2huEY5sLTyTiN3fCPRgFWU7ehWMsINrElLr7JHHbDiN6IuE58
         FCTdmzdUsjGEu8k4DyW8eX2W7oznV5mugBC4MIqW92qTWD/0krIRKDxejnlAuXEaipxL
         98+RiUekuXF3aYOeT1eGw3xdy9VgWO31n+yXujjZF24Ek090M9Dn1wurloSYlYMcerE4
         9uA7EFMVQvqKedLSeDYahS/bZ1YKBXLDAGRLf80h9Z2Bgkt1Ovk5U/bobkzGmIEPvelI
         /d1PGP1BFjNf5rDlKf/21HNyo4PlCpc3kJmqXcLVIQw7Z+pHFYk6tb9UA1uiFMsUcCxf
         MqwA==
X-Gm-Message-State: AFqh2kpU60YJDJGMUfnGlLGm7wQRf83d+8UGARo6mUIogeetHGN4uMKw
        c9VuVrNtxc0dRQh7HdBLRy8Isb04rOIprxuU
X-Google-Smtp-Source: AMrXdXuCM7Xx9a5xyQXGUvCN/Y4aHP6zk8p2xtNMZMlgklBwzv4kPc8xQVP69nTnJswhAdLeILfxRw==
X-Received: by 2002:a17:902:7601:b0:192:8e8b:bcf with SMTP id k1-20020a170902760100b001928e8b0bcfmr15695714pll.56.1672498587715;
        Sat, 31 Dec 2022 06:56:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c2-20020a63d502000000b0046ff3634a78sm14484194pgg.71.2022.12.31.06.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 06:56:27 -0800 (PST)
Message-ID: <63b04d9b.630a0220.8198b.7de4@mx.google.com>
Date:   Sat, 31 Dec 2022 06:56:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.302-261-g7b81a38344790
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 113 runs,
 17 regressions (v4.14.302-261-g7b81a38344790)
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

stable-rc/queue/4.14 baseline: 113 runs, 17 regressions (v4.14.302-261-g7b8=
1a38344790)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.302-261-g7b81a38344790/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.302-261-g7b81a38344790
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b81a38344790fc68e3e80368536f24e350bd097 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63b019bac22f2823b04eee50

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b019bac22f2823b04ee=
e51
        failing since 256 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fi=
rst fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63b019cfc9f0c742c24eee1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b019cfc9f0c742c24ee=
e1f
        failing since 158 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b01d2b8d7f019a294eee1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b01d2b8d7f019a294ee=
e20
        failing since 235 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63b019a9df024a4a3f4eee22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b019a9df024a4a3f4ee=
e23
        failing since 158 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b01d2c8d7f019a294eee25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b01d2c8d7f019a294ee=
e26
        failing since 235 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63b019ccdf024a4a3f4eee4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b019ccdf024a4a3f4ee=
e50
        failing since 158 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b01d2ae694ea3c864eee24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b01d2ae694ea3c864ee=
e25
        failing since 235 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63b019bbc22f2823b04eee55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b019bbc22f2823b04ee=
e56
        failing since 158 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b01d2f8d7f019a294eee2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b01d2f8d7f019a294ee=
e2d
        failing since 235 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63b019cdd4cda0de2d4eee33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b019cdd4cda0de2d4ee=
e34
        failing since 158 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b01d27e694ea3c864eee19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b01d27e694ea3c864ee=
e1a
        failing since 235 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63b019bcc22f2823b04eee58

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b019bcc22f2823b04ee=
e59
        failing since 158 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b01d3f8d7f019a294eee48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b01d3f8d7f019a294ee=
e49
        failing since 235 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63b019cb53e8e992584eee27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b019cb53e8e992584ee=
e28
        failing since 158 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b01d298d7f019a294eee19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b01d298d7f019a294ee=
e1a
        failing since 235 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63b019bad4cda0de2d4eee19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b019bad4cda0de2d4ee=
e1a
        failing since 158 days (last pass: v4.14.267-41-g23609abc0d54, firs=
t fail: v4.14.289-19-g8ed326806c84) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b01d2e8d7f019a294eee29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-261-g7b81a38344790/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b01d2e8d7f019a294ee=
e2a
        failing since 235 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =20
