Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C94860CA0E
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 12:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbiJYK34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 06:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiJYK31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 06:29:27 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ED41570E
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 03:28:45 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b185so5179773pfb.9
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 03:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AlcCvw5iHYP7epWL5ONFsTKwPpsRmtAsMyHlequSyW8=;
        b=IzfwmDFGHeCOLI/gbvarpKMedDOO8R00Ciqs9WafcwJwYHcy3Au07QQOTMKw7TkFwN
         lRq3yRZi500htKHFsBEXYsyAZMBxSUivkv7HfLRUevg/H6zUBKvWGdb/HfT4IDDB/T4c
         frP6eEnLDhy/Tvbq3OB0Z0V5RkXxS/EIgTsPYuEazYsmO6o71s40dSFPV/ke2mzn67q9
         LZ7+kEe1Q/Yg/Bnk1Jq8YrjDiW1uEEt4zFeY/oomwYsn61a3i7u4/lQwHgpGldqXFj/l
         zPTOcad+p4S0x6LVooWlUK2RF9DFB9ydFUR9sJ9MIiAiLe9ou1uVAd4F5LUJgHReS5DT
         4/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AlcCvw5iHYP7epWL5ONFsTKwPpsRmtAsMyHlequSyW8=;
        b=72b0a7nisyGuPXLXCdExmpqfmvK6wD+nj1tEiSEyO587ewxEMn/UL3oIYYpf5hiZGX
         648JHVFwAFB+9T1AAoecXUWEcwk6iTxE0Szue6xkXSiib89gn9tzfB1dX/z1D62Axrs4
         VvlZY020QnvDQNOI4HNicj0huHb5yr4bl/66LNKUqYmZ2Fjah50V5MG6yCuu39eaMZrr
         aU3Tbl4Ex1FnqQBye23gSdCKILA3TTfFoXxHKerXKEtReTLJ0yl3+VZVeWbmBpwnBqC5
         9l7wkYBTCcjEmYOqGVTIcgv04gRlaIGsX0t4KBp8BOunL51gArW4+xJXFvf2GsAHZxe8
         e8Kw==
X-Gm-Message-State: ACrzQf1OO2MNJlLLKbwQLkgKRwlmaI90u+xSQ1yQunaczOxek2Ng0uMX
        Ymc2+WZTdQRlYDwp5cYKT2rAJBTlK0Hw/9qQ
X-Google-Smtp-Source: AMsMyM7LIcbmzQG/nUPCVQ2MNPhoKLy+0Ssn5M0kcoLDHunnIVuDg59vB8YPY7j5AS2gGYeRjTnnxA==
X-Received: by 2002:a05:6a00:cd1:b0:563:8df5:2b8b with SMTP id b17-20020a056a000cd100b005638df52b8bmr38309459pfv.67.1666693725040;
        Tue, 25 Oct 2022 03:28:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r19-20020a170902c61300b00186b6a04636sm967644plr.255.2022.10.25.03.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 03:28:44 -0700 (PDT)
Message-ID: <6357ba5c.170a0220.27a64.2022@mx.google.com>
Date:   Tue, 25 Oct 2022 03:28:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.330-160-g5bb2c3c178f3
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 57 runs,
 8 regressions (v4.9.330-160-g5bb2c3c178f3)
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

stable-rc/linux-4.9.y baseline: 57 runs, 8 regressions (v4.9.330-160-g5bb2c=
3c178f3)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.330-160-g5bb2c3c178f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.330-160-g5bb2c3c178f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5bb2c3c178f36dd75d9e5050ce4e40c3a33792a8 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63569ab1747b20ed3f5e5b67

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63569ab1747b20ed3f5e5=
b68
        failing since 167 days (last pass: v4.9.312-36-gbfd3fd9fa677, first=
 fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63569c7b77bf283fa05e5b4b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63569c7b77bf283fa05e5=
b4c
        failing since 167 days (last pass: v4.9.312-36-gbfd3fd9fa677, first=
 fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63569ab4747b20ed3f5e5b73

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63569ab4747b20ed3f5e5=
b74
        failing since 167 days (last pass: v4.9.312-36-gbfd3fd9fa677, first=
 fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63569ca48889492d3a5e5b5f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63569ca48889492d3a5e5=
b60
        failing since 167 days (last pass: v4.9.312-36-gbfd3fd9fa677, first=
 fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63569ab0747b20ed3f5e5b64

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63569ab0747b20ed3f5e5=
b65
        failing since 167 days (last pass: v4.9.312-36-gbfd3fd9fa677, first=
 fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63569c6791d851f36b5e5b73

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63569c6791d851f36b5e5=
b74
        failing since 167 days (last pass: v4.9.312-36-gbfd3fd9fa677, first=
 fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63569ab2747b20ed3f5e5b6d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63569ab2747b20ed3f5e5=
b6e
        failing since 167 days (last pass: v4.9.312-36-gbfd3fd9fa677, first=
 fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63569c8f8889492d3a5e5b3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.330=
-160-g5bb2c3c178f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63569c8f8889492d3a5e5=
b3e
        failing since 167 days (last pass: v4.9.312-36-gbfd3fd9fa677, first=
 fail: v4.9.312-60-g806e59090c6c) =

 =20
