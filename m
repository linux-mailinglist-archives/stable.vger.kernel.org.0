Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A563C6349F7
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 23:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiKVWZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 17:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbiKVWZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 17:25:34 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6D460693
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 14:25:33 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id y13so15663364pfp.7
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 14:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5+FLgPyL5MYV4jIO2HQVB939SQE0nVs9AsnLyf3dKSg=;
        b=6zoCO/sAPjhZxn5Dbtswf7ewyS2D/yEzLHh8se3Uc9dJ+uVZpDe2EmjTb7xutxxc2H
         GSXE9p62QFiVlL8/lvi1jwrJ/DZ6W6BxjW7vtEzL+uNIIaK1lBkcVg9Ewca6gRQfmTXg
         HsuRH7K3ACsLjcFym3RsOKDGcKvUdGjLOcCwlVNDKLUsEyei+k2OBOJBOzLgrRJiMPAn
         qUFuEs7oDMheFyAoX5fvvOit5UBmbSWVlQVkntyZAAWbi20z+xOPkgRimwNAW6OFiekV
         dAEEIhYosQjQwyvgQ7wLFe4Szn7vN+vCsjo86E/jp/XrCw/Wre1V9TK5CyZ8beH+TQxI
         v+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5+FLgPyL5MYV4jIO2HQVB939SQE0nVs9AsnLyf3dKSg=;
        b=n22Zg9PrJ4QRRNo75aoOW7rpFPLU2s2OWchYUwc9ofBqt8RBTeKyosSO5JCpfEtbl/
         bGYhE+pHbAc9+QgFER/qvVTnG39ayoNShvJP0tf5vmWPo5iKv2ig7gKedNJfWmfVXiAd
         AbB/HHm1OOVRD2DvE5g/DzgXlU8AhE9J2SwxtNquVpL4n86pLghwW+muXlKEUd94+1Bu
         c9eOEWBI9Rc0SG0x4iBmctUUDWLKsKrLNzG+rzr7uIth239BAsRVbyLkGjBcsidE4V7t
         WRvom7hqjwljP9Bi94Iqcw/O6JB9epDtli8ItcToteU7qXp7N85YWzvU4zjJIEeSVmeI
         fJcA==
X-Gm-Message-State: ANoB5pnTHenueOh1BDJ/dFbaJb0Mfuw+9zW31uzw2IlL9HvH8ZJmWXtm
        FJuHKNEQ0JhuEcMXClfKw0phBgVd14oaaSrQEaQ=
X-Google-Smtp-Source: AA0mqf5pAQ/HGOMOo6IfEboxJPyHBWRz7dk23z2m6rXAPF8HQbx+dy9/fzjlLeUDQPoiKkCzRTDv2Q==
X-Received: by 2002:aa7:9a4e:0:b0:563:b1bc:7f98 with SMTP id x14-20020aa79a4e000000b00563b1bc7f98mr5832816pfj.29.1669155931958;
        Tue, 22 Nov 2022 14:25:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o9-20020aa79789000000b0056afd55722asm11152303pfp.153.2022.11.22.14.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 14:25:31 -0800 (PST)
Message-ID: <637d4c5b.a70a0220.372f5.18fa@mx.google.com>
Date:   Tue, 22 Nov 2022 14:25:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.299-75-gbecf7b212e509
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 106 runs,
 17 regressions (v4.14.299-75-gbecf7b212e509)
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

stable-rc/queue/4.14 baseline: 106 runs, 17 regressions (v4.14.299-75-gbecf=
7b212e509)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.299-75-gbecf7b212e509/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.299-75-gbecf7b212e509
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      becf7b212e509c043eb68154712d32ee13e3b802 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1c2334b490c8952abcfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1c2334b490c8952ab=
cfe
        failing since 218 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fi=
rst fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1b50793a6198252abd04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1b50793a6198252ab=
d05
        failing since 196 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1c178e8b5e6bce2abd6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1c178e8b5e6bce2ab=
d6d
        failing since 196 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/637d3c1bce724b689c2abd4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d3c1bce724b689c2ab=
d4f
        failing since 196 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/637d3de72342ff7e902abd55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d3de72342ff7e902ab=
d56
        failing since 196 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1b4fc0c5e0a5212abd04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1b4fc0c5e0a5212ab=
d05
        failing since 196 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1c194c0644334c2abcfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1c194c0644334c2ab=
cfb
        failing since 196 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/637d3c07d6f598fa5a2abd22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d3c07d6f598fa5a2ab=
d23
        failing since 196 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/637d3eff3fd1e2aeee2abcfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d3eff3fd1e2aeee2ab=
cfb
        failing since 196 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1b51793a6198252abd0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1b51793a6198252ab=
d0b
        failing since 196 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1c168e8b5e6bce2abd66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1c168e8b5e6bce2ab=
d67
        failing since 196 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/637d3d4718a6e5b19b2abd01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d3d4718a6e5b19b2ab=
d02
        failing since 196 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/637d3dd335ac44a3052abd09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d3dd335ac44a3052ab=
d0a
        failing since 196 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1b4e793a6198252abcfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1b4e793a6198252ab=
cff
        failing since 196 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/637d1c188e8b5e6bce2abd6f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d1c188e8b5e6bce2ab=
d70
        failing since 196 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/637d3bf3d6f598fa5a2abd19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d3bf3d6f598fa5a2ab=
d1a
        failing since 196 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/637d3eafcb7e1111e12abd13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.299=
-75-gbecf7b212e509/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d3eafcb7e1111e12ab=
d14
        failing since 196 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =20
