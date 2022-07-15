Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87533575F20
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 12:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiGOKIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 06:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiGOKII (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 06:08:08 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B2E87C07
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 03:06:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z1so2832059plb.1
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 03:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BGz+2AKGv4W3ZG0SlZKaLZKt6lSF6nBYCOltzfEZ3Ag=;
        b=0m/JG6/wPvu6ZiqYWZRoqr1AgNURM26sGpK4V9UIkY7RrGDbCb6q4gscnIUNnPoUlY
         CnUG7SQNrqfWmxJTP/5CdNMuXK9nSEmp6n574Hx1zC4ovKBjyAORguA3Q0NwV+P4RA+c
         BYZr8XOh5aimYfdxnm10dOvezpKIGddMdOCUEeICWhwsWupZBEyPlO1EOL40jdcGhMR7
         7CPjPuOTx0rq4g4hRa2nn3rR2Wd5Zc4WF0t0L96909mZWVcQnQ3gwGOz+DfD5fqw2ZAX
         9WhxCduI/K5KHXVchpuoAtRhRtOeMOk4jr0l2XvSmI0QY9aT0k6C1bxIixeaX/1e0Bzi
         cD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BGz+2AKGv4W3ZG0SlZKaLZKt6lSF6nBYCOltzfEZ3Ag=;
        b=v0C11xjqF7WqZfqmKpzWu0Oi5shNwJygNWU5wYVsvwxgOy3nRLWt/sSBdx0BMgJCXd
         qAr5jH+tjSY9782T4nw3l9qw0Qw8aAEu3geioeEnK6jphze054X2VweitgQUke7AmS2a
         YJi9cyFDyWx8ZlOh9kMtV9DNzVj55BDVLA6rFK8hGpIodiI8+eg8IJPcAZYVPhAtgx71
         V+bLsKR5C0I3EyquG8+AcD9dXIiuo9LN+F2bgF5p4qqOl7N/0RXVmZfH4mk06hGz/qPL
         YkIjaGIlcX/julBaF43ezC8o6uDwLgQ/RIAPKEIlU72aA7zCMWr2icx+MTtdZJNPHfCL
         1mig==
X-Gm-Message-State: AJIora8t2ZfnBF9q+AjHNLm9yNfl+CwqU0rL7mCsM4DaGcknhEiVFy+0
        bgV8L58Qa6vhpvridHtFjcFXatqzTDdlypFi
X-Google-Smtp-Source: AGRyM1t+cUTDQNmgFqwvmNDYWbY86GMTIhRu/w9WxoRelcq6rtrT1DvYhMakXCMx69YFI+lejMt42A==
X-Received: by 2002:a17:90a:244:b0:1ef:82a7:524b with SMTP id t4-20020a17090a024400b001ef82a7524bmr21625922pje.244.1657879598041;
        Fri, 15 Jul 2022 03:06:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a11-20020a170902eccb00b0016a034ae481sm3142306plh.176.2022.07.15.03.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 03:06:37 -0700 (PDT)
Message-ID: <62d13c2d.1c69fb81.7d75.4f42@mx.google.com>
Date:   Fri, 15 Jul 2022 03:06:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.54-81-gc4a4b677ef955
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 132 runs,
 6 regressions (v5.15.54-81-gc4a4b677ef955)
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

stable-rc/queue/5.15 baseline: 132 runs, 6 regressions (v5.15.54-81-gc4a4b6=
77ef955)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =

jetson-tk1             | arm    | lab-baylibre | gcc-10   | tegra_defconfig=
              | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.54-81-gc4a4b677ef955/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.54-81-gc4a4b677ef955
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4a4b677ef9558512e7d24109096e4bcfd093f38 =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62d10909dd350dcecca39bfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d10909dd350dcecca39=
bfc
        new failure (last pass: v5.15.54-80-g107b7d3eba74) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | tegra_defconfig=
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62d10ac2d8e3ccb258a39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d10ac2d8e3ccb258a39=
bd3
        failing since 10 days (last pass: v5.15.51-43-gad3bd1f3e86e, first =
fail: v5.15.51-60-g300ca5992dde) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62d1067bb3f838eb0da39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d1067bb3f838eb0da39=
bfb
        failing since 2 days (last pass: v5.15.53-229-g4db18200a074, first =
fail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62d106dfc3099bc3e8a39bd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d106dfc3099bc3e8a39=
bd9
        failing since 2 days (last pass: v5.15.53-229-g4db18200a074, first =
fail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62d10a0bbb4286ef79a39c4c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d10a0bbb4286ef79a39=
c4d
        failing since 2 days (last pass: v5.15.53-229-g4db18200a074, first =
fail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62d10b5f3f792b4a17a39beb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
81-gc4a4b677ef955/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d10b5f3f792b4a17a39=
bec
        failing since 2 days (last pass: v5.15.53-229-g4db18200a074, first =
fail: v5.15.54-78-g9de37b0ed1dc) =

 =20
