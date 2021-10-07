Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2DB425D1B
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 22:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhJGUWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 16:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbhJGUWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 16:22:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BDAC061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 13:20:09 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so7781757pjb.5
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 13:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n1KlnDu3xSXSEMB7Wqg4Iv7z1dIZBD4KEmHlIP//MMY=;
        b=3vQ1MIem1zKMeug5kZzVMeORfkmj6kuw0YiHSfV7db/sDBb+cx/8oDZcxiNU4rD02/
         0ILspg6gANLJIk4i03LhycOMbDluCTa+ROOPWcMJp0qCeOzXdOoPmG9lvaua4rx+giWh
         PJ2NqYNXWLjibDbkABHPgI/V3xuHkbC8JDvhYknti5Jz376xYqj+Z39iyRcxKdzi271w
         ZzNMCzwmSnGVkXMxZs3pzKIP2OMkpfAVnaf5o1L4otp3o1tvbRUWNikSId3mRZgAObL9
         h0Abs5XsO5gqxifG7Lfy/C/8MS4e1q78/21+i+kd5hyLSvGAEZ5YehrS9LMbO/XR3Avw
         NpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n1KlnDu3xSXSEMB7Wqg4Iv7z1dIZBD4KEmHlIP//MMY=;
        b=S9dXB5yd8rfI6JG0hvHhU/hYFlP/j6nipJyaNFLSL6Gp67v11b4hlXrGGe6HmNK6aD
         n9buNQG9mGnxQUeLJegCZxK2DnAMW9bF68vhHxUiWXRw3d3eNQpEzEtpxX3MUMgyu3rH
         2cExMiliKlVVf6GyG5jtuhmZEZrbEZRQKNKvoJsSBpGMB7IuzLa3RpH8itifc3vI9C5w
         uTpD2PTd4BB1ASgoU3bI1xOUO/8lEzKcEn46J+gTbm+n+Iuy3NXImnZ8+PpzfmCbXkId
         TDYcIhPLniWbbs8jp1uLC5ye+dtFPRgyZfTcGNI5qMFRU/NqOLyFyx3ykT1pJRaU0ZVe
         6FLg==
X-Gm-Message-State: AOAM533mewYEXIQfa/RbvliAkH1JFX0C1kpCYRqlUGj2CRp9egxdZbqw
        G/WTzV6xugSqgWN+sp5qKdqywZgaxWf/mA9y
X-Google-Smtp-Source: ABdhPJzCWGWsV7oysf1eCggogbtnxgxPG89Qqmul05ePbzYUlDcuvA/3mAR739FhfAGOE+rtL4r5HA==
X-Received: by 2002:a17:90a:ee87:: with SMTP id i7mr5881563pjz.194.1633638009007;
        Thu, 07 Oct 2021 13:20:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2sm8834328pjt.23.2021.10.07.13.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:20:08 -0700 (PDT)
Message-ID: <615f5678.1c69fb81.e5f61.9a79@mx.google.com>
Date:   Thu, 07 Oct 2021 13:20:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.286-7-g04ddf095d4a6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 88 runs,
 7 regressions (v4.4.286-7-g04ddf095d4a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 88 runs, 7 regressions (v4.4.286-7-g04ddf095d=
4a6)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
i945gsex-qs         | i386 | lab-clabbe    | gcc-8    | i386_defconfig     =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.286-7-g04ddf095d4a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.286-7-g04ddf095d4a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04ddf095d4a62aef30a78d140c6aacee297be53c =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
i945gsex-qs         | i386 | lab-clabbe    | gcc-8    | i386_defconfig     =
| 1          =


  Details:     https://kernelci.org/test/plan/id/615f1e05651ad8ce0799a2db

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615f1e05651ad8c=
e0799a2e3
        new failure (last pass: v4.4.285-41-ge78bed372f2f)
        1 lines

    2021-10-07T16:18:59.095571  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-10-07T16:18:59.104517  [   12.681960] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/615f1f224bd1753d4399a301

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f1f224bd1753d4399a=
302
        failing since 327 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/615f20b944387faa2499a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f20b944387faa2499a=
2dd
        failing since 327 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/615f30da2798e1178f99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f30da2798e1178f99a=
2de
        failing since 327 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/615f1e95e18b8bc21b99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f1e95e18b8bc21b99a=
2e0
        failing since 327 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/615f1f2d101f4a604999a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f1f2d101f4a604999a=
2f9
        failing since 327 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/615f2effe4764b64bf99a345

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-7=
-g04ddf095d4a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f2effe4764b64bf99a=
346
        failing since 327 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
