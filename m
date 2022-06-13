Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194AF547F52
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 08:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiFMGFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 02:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbiFMGEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 02:04:42 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BF5E1D
        for <stable@vger.kernel.org>; Sun, 12 Jun 2022 23:04:19 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so3224314pjl.5
        for <stable@vger.kernel.org>; Sun, 12 Jun 2022 23:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vMY29pBymVij1g1lrs4FE2VTc1XWexQTndt6O9vMzPU=;
        b=fzc5IG8SKtKXDmRAukqSNTSHNsUDxhvtHoGaIm+NxtRvLQCTj3OdSyCJ8y5XOXAB8Y
         pMA1qxWmbBg3Hpd/XjLj6vwxOhnvQ6FdOboO0lH+R4x7tS8ZARrOtpQyu5FMH3gPOpSg
         KrUC7/2nXCacrhumuVI5bcTnkl5K5xS3RocVzko7hjsH+dIeBSsaALt00HRqTCJ70wSu
         OyHVCRlxDOHMFkmOpT3TR2DdmKftyekvmCJalAnDNzTJA8EB8xhT7k3D6UnT7v/NTRFI
         Fs7jOayvC78xa28dxSjo3cINzkq1MMkhMBqN5DUe4CVOKbnNoeLdWuTWb5Zg0qFsN2Dv
         YoOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vMY29pBymVij1g1lrs4FE2VTc1XWexQTndt6O9vMzPU=;
        b=dgLB4MXrcBiLNL50V+XcGduQH7DptUtvMvtiX9dnkNHtv5JA31uRC2/Vzh0jx8l28N
         WTObsxjYk+ptLA+nuyLQukh0WGuC03PgRhL/+qLKBNSQYEFWmfNmzSYI8HaYi6aPaPQ4
         esM7WFIpL8sxTkKZLt7GbuXCzH8SV+0JXGKhXNeUKAg9VvKg9uBZlOzu4ybMinJdjXUA
         /hDPssGwglJ4qZOFLEO0SCwjjYgYkWPwsEkC9SIz6ihLXWEYHfvi/Y/BdgrFDoypIB1F
         XtAZkrvrkzzyA/wmshkGTm/RxQtRx7MnUpGz5SI79zNNZN7IcXP6aUYnCWA9BSGHI4IH
         9QIA==
X-Gm-Message-State: AOAM533xlnNZsPzqNQBQPZJxOka9MPk4HxlsgzeK7yicR2zu+zpv7NA2
        zwH+CPVo6OHvDhMxqS6VZv13/CmIITH6eO182N8=
X-Google-Smtp-Source: ABdhPJyFscalYhbki3NrbIvIA2kZVVsg13/8ydgi4asNjp2sLKiBlWUXRTXWuWWpQD9yqTopWba0sw==
X-Received: by 2002:a17:90a:b290:b0:1ea:4358:27b3 with SMTP id c16-20020a17090ab29000b001ea435827b3mr14016909pjr.72.1655100259138;
        Sun, 12 Jun 2022 23:04:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x187-20020a6263c4000000b0050dc76281a4sm4274738pfb.126.2022.06.12.23.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 23:04:18 -0700 (PDT)
Message-ID: <62a6d362.1c69fb81.2d05b.4bbc@mx.google.com>
Date:   Sun, 12 Jun 2022 23:04:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.282-205-gd677828469744
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 51 runs,
 2 regressions (v4.14.282-205-gd677828469744)
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

stable-rc/queue/4.14 baseline: 51 runs, 2 regressions (v4.14.282-205-gd6778=
28469744)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.282-205-gd677828469744/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.282-205-gd677828469744
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d677828469744a217dcec112582e764acefb4170 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/62a69df6393be6262ea39bee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-205-gd677828469744/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-205-gd677828469744/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a69df6393be6262ea39=
bef
        failing since 20 days (last pass: v4.14.278-4-g95c4f04a529a, first =
fail: v4.14.280-33-gfbdef5eaf17e4) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62a69b417149945412a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-205-gd677828469744/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-205-gd677828469744/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a69b417149945412a39=
bdb
        failing since 33 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =20
