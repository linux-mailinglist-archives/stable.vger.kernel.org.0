Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9FD57517C
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 17:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbiGNPMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 11:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239856AbiGNPMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 11:12:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02C261D77
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 08:12:44 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id z1so673868plb.1
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 08:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xtomO2InHxPP7OWo6uYDVIH3u9lQwNmVC+l6Jb/FR1A=;
        b=BLRTCpC9FGtY6aZLE4fqpW2JQr9/TCFs0h86Ay/GHK9baFz6dx7iy1DrchDXLlN4/s
         vdAPKjtuXKriCmUtFslLXpVTZCC4bGDFcrs+APaCEXTbUjlRrWEmyxJNrd7YrBhu27ED
         wRZ+kmrISSJpqSHgBOgXDLuL/suPk70oaK89qQJB5U5RdlRNVLCI5UHgxqNuN833Ud2B
         eNiwRRXEG+tvd7SsAfE4QGvcYpim+c26CU7VO8iu7vteea8z6ba+u8rxEejern/gBond
         id4PNrv3GfP3jaf8ebMPikb9VGjgGBqNKm3HtP9ytBxnrLPTc3AEMILSgNYYtOeMYScs
         udpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xtomO2InHxPP7OWo6uYDVIH3u9lQwNmVC+l6Jb/FR1A=;
        b=aAl2Hy12E7LFmjsaTQXd+LrKWZC6uoIdMrp0wr0oK7b3xdt0c1VVjJmAjl2iisIh03
         bBubSjzIqDeVFqCUi5N0nYp4tdp+Y81NtdrnLg2SaStvpuRkX7cP5Sg3SyZJbKSamwok
         oPQu0MAwP96f0PspmVybQnRoTuwk68dg9YSP9SPmchmuBuKo/lEAXWTVSoMSjiD/Pwuv
         oq+vGy5kAxczyLjykJeXDNwl0DBm02h6xeYbwyxbOmjaLKgB1+cTHomtdnI3OQJs8yKY
         Wpm7AysVqZJ8flosNO5Y5VLQjgL9bmz2kk2pXapOK4ECCoquOC7B3qKiSfXFqlLmRuuS
         uQlA==
X-Gm-Message-State: AJIora9ose4RUY6ORsY4TtNqn+nB2V8vFXCwNdCz62vxuxkGo1dhiu7W
        Tc9lpmsRfopAAan7/sULplxNfnsRmfOZy8y3myo=
X-Google-Smtp-Source: AGRyM1t14AhUt4sg/U6ICRfqG9ZmEmMDfc5ui4sFfrcWX8lJdz4Zyo7OWA4LSJf3HXWIamONzUjNBQ==
X-Received: by 2002:a17:90a:474c:b0:1ec:f898:d85b with SMTP id y12-20020a17090a474c00b001ecf898d85bmr10568994pjg.11.1657811563786;
        Thu, 14 Jul 2022 08:12:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6-20020a622506000000b0052b2bf4cc42sm695889pfl.111.2022.07.14.08.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 08:12:42 -0700 (PDT)
Message-ID: <62d0326a.1c69fb81.d74df.115f@mx.google.com>
Date:   Thu, 14 Jul 2022 08:12:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.11-62-gf8ff14144283
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 153 runs,
 6 regressions (v5.18.11-62-gf8ff14144283)
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

stable-rc/queue/5.18 baseline: 153 runs, 6 regressions (v5.18.11-62-gf8ff14=
144283)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

jetson-tk1             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.11-62-gf8ff14144283/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.11-62-gf8ff14144283
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f8ff1414428389d227925653c11d1d690141fe19 =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62cffda0045946eae9a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cffda0045946eae9a39=
bce
        failing since 8 days (last pass: v5.18.9-96-g91cfa3d0b94d, first fa=
il: v5.18.9-102-ga6b8287ea0b9) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
jetson-tk1             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62cffe7a7b39894d14a39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cffe7a7b39894d14a39=
be1
        failing since 1 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cffd96c26aa49a5ea39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cffd96c26aa49a5ea39=
bce
        failing since 1 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cffe3766a4bf4c93a39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cffe3766a4bf4c93a39=
be5
        failing since 1 day (last pass: v5.18.10-27-gbe5c4eef4e40, first fa=
il: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62d007d697c944621aa39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d007d697c944621aa39=
bda
        failing since 1 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62d009029c16173fa9a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-gf8ff14144283/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d009029c16173fa9a39=
bdc
        failing since 1 day (last pass: v5.18.10-27-gbe5c4eef4e40, first fa=
il: v5.18.11-61-g8656c561960d) =

 =20
