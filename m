Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA050659276
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 23:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiL2WdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 17:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiL2WdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 17:33:18 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF7EBC25
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 14:33:17 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id s7so20206794plk.5
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 14:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xvwBoqAsbb5Sbad7dVfQvck9vAjbe/AmyuEdyP6Zp30=;
        b=2hTJm+bNcyVp7E5MXp/sB0OmsL4zC69nQnPrT5zsJvp9d8KCqJTjnm5vq3tso98FXx
         iVD+pJZvf9mjqTfdHZqeQLsOA/F5/CfDDM3+l7NZSAIn978Vc4UntL7jhHBdNnzf3ObJ
         Iio2+0eFI4zt4+PKImJ4SzpTQD5PeKx0FvvYKYw6Th68YMgZuVXxeaycXInYLiTLQptU
         xg3GoAF4AmZG3B0ry9eoPrhrMjvTlwbWH+Ps5rX5vez0a/NiAB+ivMRhE4HkdHJLMEd3
         nvl2/wzPa4371tQosX1rPeMbmeJBXsrZIH/226G6AhB8iRRHfTMCW55fbCwM6QL8VyTQ
         sPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xvwBoqAsbb5Sbad7dVfQvck9vAjbe/AmyuEdyP6Zp30=;
        b=o1MBVY3dkD5bH5qqDtGsC5pw41etLkFfBDhOsAy/7k40EoTKKqORKXxObxUmSbs/1u
         rJ7ycldjvejKvZwNowS4wWdXpFXQm7/hXAg2bhBnArDLlXWrIloogCXvm5srS3sk06Qc
         KYw76AdqoSQsSaDZUq3AOLyTd5WJJF6Yr9m+tGFRxJnFI1HXRGDroZRhx1RSNbuOTUYY
         1Wp7ME76DKk/wZOmTuBy+6pkiGfaw9touVooDoefJqI+ye9cTcftzGFLVcGPbWCqa4ga
         PjCiDITmFAXbb6ejRHvYNqUWPsmYix++4gEdrkEw6RT28KkI1cLZFyXpFu5JMHIQHUbQ
         rYYg==
X-Gm-Message-State: AFqh2koDphltvTTrJqiRGoCmvnzoZ0VuJxM7+sq9ileNhl8/sgT1hmH2
        G2oaxvs6lY5cb71ATXKRpp0Vf3/F/o1xfK3G
X-Google-Smtp-Source: AMrXdXvnRRxxnomETBMqaTvc+xRXHxY6Hovx1PB/NyvmQtsKDuD7NDdCw7QF8zVpaG4XeGOIK1qBVA==
X-Received: by 2002:a05:6a20:4995:b0:aa:7eab:25a5 with SMTP id fs21-20020a056a20499500b000aa7eab25a5mr33539371pzb.34.1672353196814;
        Thu, 29 Dec 2022 14:33:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6-20020a63df46000000b0047685ed724dsm11525028pgj.40.2022.12.29.14.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 14:33:16 -0800 (PST)
Message-ID: <63ae15ac.630a0220.6a97b.40ba@mx.google.com>
Date:   Thu, 29 Dec 2022 14:33:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.228-455-g4f0e4301660ea
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 121 runs,
 5 regressions (v5.4.228-455-g4f0e4301660ea)
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

stable-rc/queue/5.4 baseline: 121 runs, 5 regressions (v5.4.228-455-g4f0e43=
01660ea)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
        | 1          =

sun8i-a83t-bananapi-m3     | arm   | lab-clabbe    | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.228-455-g4f0e4301660ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.228-455-g4f0e4301660ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4f0e4301660eaa1961d923168645a3ba2e2d8f6a =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/63adde6be9ac485b6a4eee24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63adde6be9ac485b6a4ee=
e25
        failing since 156 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/63adddec6f4b10d0914eee38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63adddec6f4b10d0914ee=
e39
        failing since 156 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/63adde5733ae2e0aec4eee36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63adde5733ae2e0aec4ee=
e37
        failing since 156 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/63adddc7a43bc488f94eee1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63adddc7a43bc488f94ee=
e1f
        failing since 156 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
sun8i-a83t-bananapi-m3     | arm   | lab-clabbe    | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63addd9d443f1004304eee27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g4f0e4301660ea/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63addd9d443f1004304ee=
e28
        new failure (last pass: v5.4.213-20-gb5fbdb698d2a1) =

 =20
