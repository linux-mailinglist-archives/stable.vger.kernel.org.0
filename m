Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F84C5FDD41
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 17:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiJMPer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 11:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJMPeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 11:34:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A06639B
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 08:34:42 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fw14so2314756pjb.3
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 08:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ecMkcKreb00+h/suZCejyU2eMBM4wvgSnNijd05FXsE=;
        b=Jfdoztvw/eJD0yZ2+GHU7VImL1HOAeuJVU6MeG7QqUa1ZhTCXD/I+jERH2I2X/016r
         kB08DYh3bCGnU8SJp/pRLwsFOspqhqCPbWpUVmKjVYay90FXzB9+l/dBsjslL4xkj4WB
         sKA9MSK/VaKZkYdtBYJl8+pbA8nT0sHRlnbdlBizppcfGsgVsaO9HUFuDAOpcfVhrPi3
         bfutCLNP0FNml7BtRyRDRG1rKCKUVDUr5KM5z2JxM895Mu8QgigLXLj3hQGfbG1RDb4w
         3ArgoZ5UMJ1mIYPzdHoGSaT7KX28Wgw9quA2FkjEE1uKhBiNbX+AJcSanxNRgUOt2dvK
         eP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ecMkcKreb00+h/suZCejyU2eMBM4wvgSnNijd05FXsE=;
        b=18Fa0eAbwW2l3W9kFlqB5sZ02IB2OCgNyrzehMsWAFuRVFkI8YwUBdN/iGQjR5IA57
         F19cB9mD1m+StT+s3XoJLSwToQ8zvzJRq/CtnSblkNjLvDY0kFPRSrK7NObazVnG9p+N
         XjJ83c3Unvwf4LdlzqBUW5aWFFIIs7/gooExRgrFWq6JX8UafM3nybvOAsX/Bg4xOmfz
         vIl5CAmYvbfBEEynX0i6IuYMXkgsNL5bdqoczVfZ5icKrkYg95Pf8NMr/RbVSX88F+kr
         /eUlpCjIsftXQdXAVTCXI1/NEo8QPQ09Nwe05ObRofwbgXtsBtwYJNzIytrJ3CI9r+GB
         pskQ==
X-Gm-Message-State: ACrzQf2WT1WDG7ZwJRkg/OlC2vTa2lDNuUAFe38ajZCBIMGFmXp+G9u+
        WTFFm88PoJQJ/fU6wJ1WhzI2ePul/jue29tnDBo=
X-Google-Smtp-Source: AMsMyM4IvUs8Trx2F+iv9el3G8Vdoc2upsrjwhTRG70i0OnXBmU7GdPI7OwymjljZeK2bA3zl6I3gQ==
X-Received: by 2002:a17:902:ecca:b0:183:7473:580c with SMTP id a10-20020a170902ecca00b001837473580cmr402256plh.167.1665675282137;
        Thu, 13 Oct 2022 08:34:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9-20020a170902da8900b00174f7d10a03sm21978plx.86.2022.10.13.08.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 08:34:41 -0700 (PDT)
Message-ID: <63483011.170a0220.ae1e2.00cf@mx.google.com>
Date:   Thu, 13 Oct 2022 08:34:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.217-21-g7357ffcc0f2ae
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 109 runs,
 4 regressions (v5.4.217-21-g7357ffcc0f2ae)
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

stable-rc/queue/5.4 baseline: 109 runs, 4 regressions (v5.4.217-21-g7357ffc=
c0f2ae)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.217-21-g7357ffcc0f2ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.217-21-g7357ffcc0f2ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7357ffcc0f2ae821f0d656ad26a9c32e8cab3232 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/6347fe013d667896dfcab604

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.217-2=
1-g7357ffcc0f2ae/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.217-2=
1-g7357ffcc0f2ae/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6347fe013d667896dfcab=
605
        failing since 79 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/6347fe0324924debfbcab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.217-2=
1-g7357ffcc0f2ae/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.217-2=
1-g7357ffcc0f2ae/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6347fe0324924debfbcab=
5ed
        failing since 79 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6347fea14fe967fe2fcab5ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.217-2=
1-g7357ffcc0f2ae/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.217-2=
1-g7357ffcc0f2ae/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6347fea14fe967fe2fcab=
600
        failing since 79 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/6347fe023d667896dfcab609

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.217-2=
1-g7357ffcc0f2ae/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.217-2=
1-g7357ffcc0f2ae/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6347fe023d667896dfcab=
60a
        failing since 79 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
