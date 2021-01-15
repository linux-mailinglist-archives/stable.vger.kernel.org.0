Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5261C2F84FD
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 20:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbhAOTCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 14:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbhAOTCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 14:02:15 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47D2C0613C1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 11:01:35 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g15so6583339pgu.9
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 11:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/1PV3ABLDXjtGwuMnnqdbww21zOAS+npqcpC7a1cOAI=;
        b=M588Kp3JXhwMlF2yvBze5XLSf2SesSfJSvtlaeZaSLw7ol/WH+zaJanmLGt4+FRS6B
         3agS3CRq+KoANSb58ti3Kn7fePnrEwJd0DgWMttqjuvqN9Ex7zOs9hOJti8I0HeU2luH
         FMbk6dfkeI9egbeOEpIGSWgRZbJ30vzeUxj4RDtbrzFSFZ5ptNe9r9Ih2jW4lXaNQsmr
         DILy5Oc9AAEis1Weikt7vy6vfQmwXsh9ULFwuAedV8EOBjivPaCb3x/ZhVnlr+0Ky8rC
         ATNJ5qVyRX2g+Aa9d7+SwIcVEmrlVr22nwlXZU/9i2jly3ZC3FcSOPP3S8hS2X8i+BNh
         gGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/1PV3ABLDXjtGwuMnnqdbww21zOAS+npqcpC7a1cOAI=;
        b=uhUQGw3cE2bIbZr+txJv9QWoBSHyK9l52iKrst9TeoDp5xKgzPGB3gQ2VSM2k1YNVQ
         6IuPSLojtlwZr1lWP2W6DoxnG6lnSVuNv/tUyRUzK/YUyDrK2iYeyZQyAwoMQOT8+7e6
         ++rExDh8q6ZeyAXqy7XvDVJmM8J1usgM15xXasDB1WbOhVCLYiJnRRgwzwqsK4vnItXY
         JcebMKan7cTM81N8FHkIxwdhT2Z1TDYNWIIr8XMvOldn3llmrtA/v5eAo2zFAn8mBbuG
         vHQGcS1h3XoHsGztgnC7LT6kApSPB8uBL5wH40FNIPzlx4N/WuqawReJ7K+ZDF2lHgmj
         tIXg==
X-Gm-Message-State: AOAM531UK4vcTWeljqHEhzWs98+XPWU/GusL3w5xNY2W6/FBvNpdsHIl
        woZLyvRgXDt9MO2HSe55K1Tnh7lpqi39Zg==
X-Google-Smtp-Source: ABdhPJy4orfnz2vi6BA/qbBi+Fy1UQqvs/SE/wITN6Is0ZnzGsFtida+i4bQkdR8ySV7/tvMlxxytw==
X-Received: by 2002:a62:65c1:0:b029:1aa:ba52:fdfd with SMTP id z184-20020a6265c10000b02901aaba52fdfdmr13987594pfb.7.1610737294927;
        Fri, 15 Jan 2021 11:01:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u25sm8966116pfn.170.2021.01.15.11.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 11:01:34 -0800 (PST)
Message-ID: <6001e68e.1c69fb81.45be.725e@mx.google.com>
Date:   Fri, 15 Jan 2021 11:01:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.251-19-gbca740d5a2a1
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 95 runs,
 9 regressions (v4.4.251-19-gbca740d5a2a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 95 runs, 9 regressions (v4.4.251-19-gbca740=
d5a2a1)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_i386           | i386 | lab-baylibre  | gcc-8    | i386_defconfig     =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.251-19-gbca740d5a2a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.251-19-gbca740d5a2a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bca740d5a2a15e70a7b3cba962dc1d27f26204f7 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6001acc8413d52b289c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001acc8413d52b289c94=
cd0
        failing since 62 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6001adc7ff4d829f10c94ce7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001adc7ff4d829f10c94=
ce8
        failing since 62 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6001ac5163c103def0c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001ac5163c103def0c94=
cce
        failing since 62 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6001bc05aa874974e7c94d48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001bc05aa874974e7c94=
d49
        failing since 62 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6001ac7bfd2adad9a7c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001ac7bfd2adad9a7c94=
ccf
        failing since 62 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6001adb4fad68b70e8c94d23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001adb4fad68b70e8c94=
d24
        failing since 62 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6001ac199a5ca86145c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001ac199a5ca86145c94=
cbb
        failing since 62 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6001bb905bef0dcc67c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001bb905bef0dcc67c94=
cba
        failing since 62 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_i386           | i386 | lab-baylibre  | gcc-8    | i386_defconfig     =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6001ab42efd90831dcc94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.251=
-19-gbca740d5a2a1/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001ab42efd90831dcc94=
cd2
        new failure (last pass: v4.4.251-19-g7515459825c89) =

 =20
