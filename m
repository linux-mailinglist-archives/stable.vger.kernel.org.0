Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8934F572ADB
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 03:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiGMBeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 21:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiGMBeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 21:34:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29C471BEF
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 18:34:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s21so9890729pjq.4
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 18:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uoyaRe4/uI2eDQBJcgFWc52lq7q/gvSrjT0/D44pzis=;
        b=RXLlJUO340pAuQME6f43q0yCpZqg1fNe4FO76kslxUdXCMOMrMYDLOpPzk6lRWmSJs
         d7b9ZH+7RnBPK/HuFsQ3ebofcWJFjvSPAyCvKhHCk1T+vfAppSlFH2+Rchgbg1eohJfV
         cuA9KhsD/3ebNBhKm2uD7vGoPbNdow9Pu+w6e3dyYVAN/xbao9v5DRMMTBEteb2HdEK0
         kcWcLTYPUVxqO1Zn5ZBN2qjbA7wyMJZrsEjBvoEDMm5udlDnfroVFGvGNWq+ZnUbaIJ4
         R71aLz0Osq58zImkADYq2kM1pFjEHX50aTCvO/DrkFdLt+pZmPagAYF1ULG2CsT4JGGR
         L4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uoyaRe4/uI2eDQBJcgFWc52lq7q/gvSrjT0/D44pzis=;
        b=4GHrRktlaJ+p0eJJ+aUpLF3yyCHON4QVxH2Q/GfJBY8xplKez2bzoA+lxr4b31pRha
         SJ052Ib1cA2i/wnh5M1AtouCjOPDeYOkErdlIUy4awsE2N1k90oKomXQ62VEnL+jkq7T
         2nn6QnVR3vm+EaT+uFeDhHVjUYQpDKoWNQqb6vF1jK+mA/nLRZX7RipJyR4LBhV55mjg
         RK2/S+Ji15NaMMYJgpT6VgR8AnCiLwAX0BGk9DGw+bYQK+sONrEgJwSZeJCF1BQ5cHI6
         sLdMRK/gOiqIhZEdYXG/xyOPjd2RRvyqHdid2kZJQOCKixBXGbfZHCcgkbklzLuRsPpc
         T4Nw==
X-Gm-Message-State: AJIora+HJujPFW9QH2NtJXgfAVFB1yIaMvQsEFvefvgMLGC0mnYQbnzb
        ZgbvzngcI90LnBce8uX/bfJGCQov7mr4byxR
X-Google-Smtp-Source: AGRyM1vWrAR1MLHAlyCvNPsxYLI3SQKPVPmLbVvo32jsRXV7LDaSpGQoAzxGDjkOvRTsoI5S+lPprA==
X-Received: by 2002:a17:902:6bc6:b0:16a:569d:33da with SMTP id m6-20020a1709026bc600b0016a569d33damr1069314plt.59.1657676062940;
        Tue, 12 Jul 2022 18:34:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i1-20020a654d01000000b00415d873b7a2sm6544927pgt.11.2022.07.12.18.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 18:34:22 -0700 (PDT)
Message-ID: <62ce211e.1c69fb81.83a5d.997c@mx.google.com>
Date:   Tue, 12 Jul 2022 18:34:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.54-78-g9de37b0ed1dc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 101 runs,
 5 regressions (v5.15.54-78-g9de37b0ed1dc)
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

stable-rc/queue/5.15 baseline: 101 runs, 5 regressions (v5.15.54-78-g9de37b=
0ed1dc)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.54-78-g9de37b0ed1dc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.54-78-g9de37b0ed1dc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9de37b0ed1dcfa97f24120227b4d0c53481ef908 =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce01304cb5ade55fa39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce01304cb5ade55fa39=
bdd
        failing since 31 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdebf4851fb8781ba39c05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdebf4851fb8781ba39=
c06
        new failure (last pass: v5.15.53-229-g4db18200a074) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdec048f2f3dc770a39be6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdec048f2f3dc770a39=
be7
        new failure (last pass: v5.15.53-229-g4db18200a074) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdef2dc5b01795cea39c16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdef2dc5b01795cea39=
c17
        new failure (last pass: v5.15.53-229-g4db18200a074) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdef6a79f74c2f47a39c38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-g9de37b0ed1dc/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdef6a79f74c2f47a39=
c39
        new failure (last pass: v5.15.53-229-g4db18200a074) =

 =20
