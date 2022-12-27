Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6AA656E9E
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiL0UZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiL0UZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:25:29 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCE7C7F
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 12:25:28 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q68so1905947pgq.9
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 12:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WScp8TOET4FtjvWrLNetxx1C3N9IwgvU3L7QRgQUsoM=;
        b=5f7c8OGEQnW4PyYIgo9ZVZ7f3W6Up9o/z3AiT+nXqQh7tAGEKlSmH9pxU4o6U8hjQ6
         2JCfGQljXXf9xLHCN2VcVERtMvbRveZqEwtWUK3qHxcvtW0uIQx2H2VeUBLxbY1On0MC
         ReeBTzxhfbr7IZMuQhgXyKQpOZ97EyIuL9AV/SHOgHQwTu89Z6aH7yccAhHV/go6awdT
         VHOwSyL/eTlgoIUyKqetpDBl3c3qx4bmmGETwq8jxlDdCcRHoSQ9WYSfMaKt5yYpItjN
         hmbRePllCu0GNFX+Q7MgqXEN33/OKv7aQrTKiHdYyjWkWbQUJVMxJk1tGNlqUMPh9tmH
         rqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WScp8TOET4FtjvWrLNetxx1C3N9IwgvU3L7QRgQUsoM=;
        b=GbYd/YdM9ptyN7+loWorysN/DbscjCC0y7C8FvbCtWp+RuGHiRXD1XXY4sjCveFF3b
         aDJK1ulA0IAQin4M8w99TwrIK596iMhHgvXzj0iWbAFVmvdouj2+/EU8OwP3t47zguiu
         aNBdLJ/JF2+htEgm4iBhgJZwzl+rWWOTUyr7p09sFl/ysIpOby1MgXyag3v5NZejD6Ni
         5Zv+WYncw3zgBR4dXM1RlldyDOWp3Lc4ETbsegceCwDAmgSqweZxo5+NF85zRAOxaseH
         YzCR5CXzvybEgslklCdw+PQAHzADli50JfeeIbhM88zD38BItDSXMmYUil0Oebfse0MU
         HgMQ==
X-Gm-Message-State: AFqh2krNtukHjX5BpuzD2LPEz/QnVAajmrr3YDRGuT0cweQJP28Muhde
        FJUrJ3xEUdGy4xcODziLcx9BSnlJKlFBNCbtNGU=
X-Google-Smtp-Source: AMrXdXt8CYqkqBl4po81jigziHJHwhYl1gLAaTQEm4Xj+tt6bGxmW6JBaoW8baEnHg1oUi8DfHXV9w==
X-Received: by 2002:aa7:8284:0:b0:580:e549:559e with SMTP id s4-20020aa78284000000b00580e549559emr10495467pfm.17.1672172728068;
        Tue, 27 Dec 2022 12:25:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g130-20020a625288000000b0056c2e497b02sm9243335pfb.173.2022.12.27.12.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 12:25:27 -0800 (PST)
Message-ID: <63ab54b7.620a0220.a7290.0717@mx.google.com>
Date:   Tue, 27 Dec 2022 12:25:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.228-444-g51f90a04ce8e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 110 runs,
 4 regressions (v5.4.228-444-g51f90a04ce8e)
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

stable-rc/queue/5.4 baseline: 110 runs, 4 regressions (v5.4.228-444-g51f90a=
04ce8e)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.228-444-g51f90a04ce8e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.228-444-g51f90a04ce8e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      51f90a04ce8e9b7b064acf401a2cbc4a5d641189 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63ab28500bd74b39b84eee26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
44-g51f90a04ce8e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
44-g51f90a04ce8e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab28500bd74b39b84ee=
e27
        failing since 154 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63ab2112320cf9b2de4eee2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
44-g51f90a04ce8e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
44-g51f90a04ce8e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab2112320cf9b2de4ee=
e2e
        failing since 154 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63ab2828fa81b3c5284eee2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
44-g51f90a04ce8e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
44-g51f90a04ce8e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab2828fa81b3c5284ee=
e2c
        failing since 154 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63ab210f32b743618c4eee21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
44-g51f90a04ce8e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
44-g51f90a04ce8e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab210f32b743618c4ee=
e22
        failing since 154 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
