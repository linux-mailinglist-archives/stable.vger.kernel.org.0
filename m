Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE644BE771
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354965AbiBUKgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:36:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355076AbiBUKfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 05:35:25 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0BE38BCB
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 01:55:44 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 4so3854102pll.6
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 01:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IbKPLy6jPAu/NluNhEhQpwvJfda9Z2kJDzcsC36a8T0=;
        b=5YeIymOH4jWtyl74mmITUycDv64NibAnONn1idrZdaqwWn0yKFUa4GRKJA3zjpsjVR
         UjVPfkfPzZt79x5GPI5ehKU4eu9grFvqQsQYSQVVGoFJwT3EZQJD+fhfFbACZueBRUnt
         Gmiu8CkxiL/Mx+zoE509Ckiyv2JrmcrCUrBRmermK4/0P4X97UhtQpO+ECZ/wfmMtTnP
         7pga15blKEuDFjdXf84FUjN02s9QVq4xvb5NuPEmxAb12IvndB31zpy1kKMDjbciriDa
         S8cQjeT5hsP3xrYVQcqvnNTqLpWq0pCFXdlLn97ZSa9/X7q1fX+RAumOfFIu6FWTmyH4
         zj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IbKPLy6jPAu/NluNhEhQpwvJfda9Z2kJDzcsC36a8T0=;
        b=O7VXxKAjz00pt+gNlwSVEakqVo4LEB3vZLxI6vujeX3+C4MFDV6cZWbOiK30mY+Du9
         +LTueACbfPHWKohC7bQh6aQJ5ihue4eMlqli6vPxLg35IEJPjIcUUgqv4Qz17Gfa25AX
         KqlMlVsjUeMKpIIm7+Pqx+fArX9LgYa9SLCyutfs6lGh41zgqyi5Hm9YUqXX71n1uohn
         FTyA1F8TiRkRwSaK4IXgZ1TFQPdkyQZXMQ46gz76g/a3zrrqqWqTPOSkpO7WKaiPZWJc
         MBqFMrzh0bBOQRogSGPTWzcY2q/mw+vjKZhdgob1cCL0br6xITGoaiDHHqM1F2wzRHLa
         AzHA==
X-Gm-Message-State: AOAM531VHZ+zHJdyMlqZa+sfHIWiy3fmetgdzs1SK0Gf6ufb/vBBiSfS
        ElbQ8ssboBKhwqY16R0Bh24kR0LJvCMia6/j
X-Google-Smtp-Source: ABdhPJwOc/kWNZqmZ3Q6CSSjFHAx8ItBF1gfWwQbtZW8Q/InmapKbX+PUufVszmCA9GHbUHL3HZILw==
X-Received: by 2002:a17:90a:13c3:b0:1b8:d015:66d2 with SMTP id s3-20020a17090a13c300b001b8d01566d2mr25104165pjf.96.1645437343957;
        Mon, 21 Feb 2022 01:55:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nu11sm7475283pjb.36.2022.02.21.01.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 01:55:43 -0800 (PST)
Message-ID: <6213619f.1c69fb81.f9764.4977@mx.google.com>
Date:   Mon, 21 Feb 2022 01:55:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.180-74-g8504f6c48ff1
Subject: stable-rc/queue/5.4 baseline: 140 runs,
 20 regressions (v5.4.180-74-g8504f6c48ff1)
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

stable-rc/queue/5.4 baseline: 140 runs, 20 regressions (v5.4.180-74-g8504f6=
c48ff1)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm-virt-gicv2-uefi   | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config         | 1          =

qemu_arm-virt-gicv2-uefi   | arm   | lab-broonie  | gcc-10   | multi_v7_def=
config         | 1          =

qemu_arm-virt-gicv3-uefi   | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config         | 1          =

qemu_arm-virt-gicv3-uefi   | arm   | lab-broonie  | gcc-10   | multi_v7_def=
config         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.180-74-g8504f6c48ff1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.180-74-g8504f6c48ff1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8504f6c48ff139704264cc3ee947ddaf4128d196 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm-virt-gicv2-uefi   | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config         | 1          =


  Details:     https://kernelci.org/test/plan/id/62132cbce664866e21c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132cbce664866e21c62=
969
        failing since 67 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm-virt-gicv2-uefi   | arm   | lab-broonie  | gcc-10   | multi_v7_def=
config         | 1          =


  Details:     https://kernelci.org/test/plan/id/62132cdae664866e21c62995

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132cdae664866e21c62=
996
        failing since 67 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm-virt-gicv3-uefi   | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config         | 1          =


  Details:     https://kernelci.org/test/plan/id/62132cbdb8b260e792c62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132cbdb8b260e792c62=
982
        failing since 67 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm-virt-gicv3-uefi   | arm   | lab-broonie  | gcc-10   | multi_v7_def=
config         | 1          =


  Details:     https://kernelci.org/test/plan/id/62132d13c2817497ccc62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132d13c2817497ccc62=
982
        failing since 67 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62132f00992bb01fabc62974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132f00992bb01fabc62=
975
        failing since 11 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-46-g5f71cf7c3b4b) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/6213307f2dbd415fd8c62971

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213307f2dbd415fd8c62=
972
        failing since 12 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62132f08992bb01fabc62998

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132f08992bb01fabc62=
999
        failing since 11 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-46-g5f71cf7c3b4b) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/621330bf5db0457dcec629ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621330bf5db0457dcec62=
9af
        failing since 12 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62132f51054c27e6c5c6299b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132f51054c27e6c5c62=
99c
        failing since 11 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-46-g5f71cf7c3b4b) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/6213307efe2fa30dd9c6299a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213307efe2fa30dd9c62=
99b
        failing since 12 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62132f6bdad455ef97c6297e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132f6bdad455ef97c62=
97f
        failing since 11 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-46-g5f71cf7c3b4b) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62133088e71952ef37c62989

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133088e71952ef37c62=
98a
        failing since 12 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62132f026c81fedf9ec62982

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132f026c81fedf9ec62=
983
        failing since 11 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-46-g5f71cf7c3b4b) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/6213307be71952ef37c62978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213307be71952ef37c62=
979
        failing since 12 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62132f1bfd2bb2b7fbc62993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132f1bfd2bb2b7fbc62=
994
        failing since 11 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-46-g5f71cf7c3b4b) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62133085fe2fa30dd9c629a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133085fe2fa30dd9c62=
9a3
        failing since 12 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62132eff6c81fedf9ec6297c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132eff6c81fedf9ec62=
97d
        failing since 11 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-46-g5f71cf7c3b4b) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/6213307cde3d9e1359c6298b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213307cde3d9e1359c62=
98c
        failing since 12 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62132f076c81fedf9ec6299a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62132f076c81fedf9ec62=
99b
        failing since 11 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-46-g5f71cf7c3b4b) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/621330862dbd415fd8c62978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
4-g8504f6c48ff1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621330862dbd415fd8c62=
979
        failing since 12 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =20
