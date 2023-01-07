Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9570166103F
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 17:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjAGQmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 11:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjAGQmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 11:42:42 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEEABC88
        for <stable@vger.kernel.org>; Sat,  7 Jan 2023 08:42:41 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 17so4972455pll.0
        for <stable@vger.kernel.org>; Sat, 07 Jan 2023 08:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=x55RrecEg9FPcHip9D/4q6s/zi3dj3xy40WIQ36vMH8=;
        b=KJGdSIxAqcECJCWmVJoC3zOFJvLO35Tv+NO3cqVRX128oo/pjmVlRx3GehgZdbiVGT
         yGyxpyFDwHhtow0xsttJlo9/6KLGN+ZoqNTr5DRYB5INrhGtyV5Bc9CIwVSFDYU9dfg3
         4n1vupMh5bY173vgfwfZGOq9fHg9a6ksVUKZ7q/C8GAmtrUYpUbtum6nItmUhDj1CJn+
         XjlBCqVBKy0fz1tmKc4pzEPK+TajrjPEqv0z5dlaKzTPjYcSvUDhR9aM6bxLDB8355DK
         npViv2f9qvTkGzqgEwiDKoCokAe060ge0EvaKimnNJM7wsa1yLMmEvwOPHFhxHKdRlF0
         yjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x55RrecEg9FPcHip9D/4q6s/zi3dj3xy40WIQ36vMH8=;
        b=VnoqKKYhTHDaNgXEavffLLGbdXhyxMyHhdm+oCo/24cRZKugBl2NTPYh7Wd6vvV8kI
         YQ+fqV0vXpoOi2P7GkVzyRbpDulJHRIfoq9BkGRbRHhCniIlgC+6MgZX9VuERp1Ktb6v
         IKK6Bms2FFuior/mGFfcoJK0pixsjgCWeD6/2jNcuTZxsNNuaszKfPlb6D5z/QuzfR2F
         j1ivCIVEwUnit/pWfN86digATGiE9lLAwc2FVGi9aHq7qoFaaPwolzh5yHGqls15nH0+
         FVh4E+YkJxRmfezDozrLpFEPE48uRqm2YSP4NdlG4rCfCcObjDud9Lu0Qwb1+Ef/6puC
         rs9g==
X-Gm-Message-State: AFqh2krLXa/fDmxaOKBPGg4qWMxXv2L+ZtG/QB6n8kF/40SEVFXySbCd
        zJlke5O/48sDq15SBFp3qRbSE/YC2vKrVVqjSByCQQ==
X-Google-Smtp-Source: AMrXdXsa2ElpSpI954tKi58lZ1zM+PJM1gAeizCC9Zzf+eN/Xk+trP7b2DRRu2UktP9wxFcwM1Cqgg==
X-Received: by 2002:a17:902:b60d:b0:188:8745:35af with SMTP id b13-20020a170902b60d00b00188874535afmr71922510pls.63.1673109760437;
        Sat, 07 Jan 2023 08:42:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l9-20020a170903120900b00189618fc2d8sm2919212plh.242.2023.01.07.08.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 08:42:40 -0800 (PST)
Message-ID: <63b9a100.170a0220.54307.4076@mx.google.com>
Date:   Sat, 07 Jan 2023 08:42:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.228-538-gff987b831bd71
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 110 runs,
 4 regressions (v5.4.228-538-gff987b831bd71)
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

stable-rc/queue/5.4 baseline: 110 runs, 4 regressions (v5.4.228-538-gff987b=
831bd71)

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

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.228-538-gff987b831bd71/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.228-538-gff987b831bd71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff987b831bd718235c9addf6d9acf6b91afde7c7 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b96d63028c02ac144eee47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-5=
38-gff987b831bd71/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-5=
38-gff987b831bd71/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b96d63028c02ac144ee=
e48
        failing since 165 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b96d42028c02ac144eee22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-5=
38-gff987b831bd71/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-5=
38-gff987b831bd71/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b96d42028c02ac144ee=
e23
        failing since 165 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b96f1b3dbe793f5e4eee1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-5=
38-gff987b831bd71/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-5=
38-gff987b831bd71/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b96f1b3dbe793f5e4ee=
e1c
        failing since 165 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b96e0b2f987565ea4eee53

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-5=
38-gff987b831bd71/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-5=
38-gff987b831bd71/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b96e0b2f987565ea4ee=
e54
        failing since 165 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
