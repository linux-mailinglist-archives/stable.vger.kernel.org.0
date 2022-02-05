Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0414AAAC0
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380816AbiBESAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380829AbiBESAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 13:00:08 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06C9C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 10:00:07 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id v74so7985294pfc.1
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 10:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6Tnd6UAvYfX7HDzKfAbX2d2ktyfmb9HhFG0Kd16Ae2s=;
        b=w/IpwUIuVhYo/Yih+yh/5VnslO6U4sZPY3a7EB7fkZAMsqMTOF/iinMz/s5idLlErJ
         nVfw0LE4mQzzvzP5URJsnOyR4rSfojJIVrqELEozBxEQIfwisTlXqwJhEvKtDvzXqmiu
         Q08/5EWBKduW2lNcsLLqO0sW8aIpY0YsBOFkYeJ1DKT47lmlCwUPi1AEj2sr9T7N/3BG
         zW1sWwR3LdVCA29/kl2mNHRgk/W34FW+sDgMEH+JmSp9tu43p6RRK2ibu+C3wpu1AmgM
         q+qwtzS6+cjyqOCH6kf/NAtmh5OISFEAzqxNT7BneqzsAjWUUzUNjZ7loZ/9rlDdsxel
         Lexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6Tnd6UAvYfX7HDzKfAbX2d2ktyfmb9HhFG0Kd16Ae2s=;
        b=ZL2Utf7xMPtZ+M94XUrHaNR2ZJeHSRpdkFNAQGOhaC5ZIuWTl+fnkNU4CLEAdJm17O
         ZfI7GzcXfCoN4g6VTXBGK9V2Dae6lViNFAyAMQkkPG8QsBc/eYDYMS3M/k5VqOGcZFgV
         RujaVI4kjpzvjVHaYzhN/EZ0azZeutkFmJPAmd+RAXfRxDlCRMZLnfL/xkLDotdKAT3t
         cGo1Vw9/lkBJfC/HPbNfFtLw+UsGxEaBhj7UuUrZG5CA8vHnzOzfVMfejHys5sIKacCg
         3m12Z6TPOEWC+vR/B/nb+vdF+ku8RV1seARloJtZAT5z4yuLCp8SPTnYmgLnVQj9uCyO
         P2VA==
X-Gm-Message-State: AOAM531hJ8CE7z3sZEolmLLVw1/gnaBdHyTzOz5g4q3973aBXMfc7FNk
        VZoB15kVGm8DGn7LpSWE/3bpnATvQmy5QQN8
X-Google-Smtp-Source: ABdhPJy5EOyHazT1znvUBNAxRhn0sv/dSj5BrTwA3zSB4ZLK1nXb5dqe0uXtXEyRQSjhN/OTkkz9og==
X-Received: by 2002:aa7:9634:: with SMTP id r20mr8604710pfg.57.1644084006787;
        Sat, 05 Feb 2022 10:00:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2sm6640375pfj.211.2022.02.05.10.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 10:00:06 -0800 (PST)
Message-ID: <61febb26.1c69fb81.e8e1.0c5d@mx.google.com>
Date:   Sat, 05 Feb 2022 10:00:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.176-11-gb8f53f917128
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 131 runs,
 4 regressions (v5.4.176-11-gb8f53f917128)
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

stable-rc/queue/5.4 baseline: 131 runs, 4 regressions (v5.4.176-11-gb8f53f9=
17128)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.176-11-gb8f53f917128/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.176-11-gb8f53f917128
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8f53f91712808313bf7b5bd9947d7095968248a =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe84b897b7d302a65d6f0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
1-gb8f53f917128/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
1-gb8f53f917128/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe84b897b7d302a65d6=
f0d
        failing since 51 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe8436222aa710325d6f78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
1-gb8f53f917128/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
1-gb8f53f917128/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe8436222aa710325d6=
f79
        failing since 51 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe84ccd6717d56455d6f02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
1-gb8f53f917128/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
1-gb8f53f917128/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe84ccd6717d56455d6=
f03
        failing since 51 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe844b8c34ba9ad85d6f27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
1-gb8f53f917128/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
1-gb8f53f917128/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe844b8c34ba9ad85d6=
f28
        failing since 51 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
