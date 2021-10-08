Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5BD426217
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 03:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhJHBic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 21:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhJHBib (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 21:38:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C51FC061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 18:36:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso4152113pjb.1
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 18:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+IGpoiyzFanligWuRmGXoo1QqOYB207pOw7VsjY9xgQ=;
        b=sLGP92XGRI/3y2/EvU5JcUkwNq6tGN8jpA/jdZO3bEMSXgERk5xMNgV9HOlYEpkSfH
         nIOSjG7rRNsuAXTZLgrmu8ujkRQ+VR+GLyP0szGCSI33PQBv9BJiG8u+ZZKc4RXtY0Cu
         DtY1wGZhcnp3WuTWe+J2vFIYMAnpVxcoR+To4pU1x0UbKDSIzXNrar82VA5QQCwUrNrh
         RDNJedi+IM6Qh/2Zo03/IKaOEU7JknQ2LqPYHwr2midOy2n1o609bInGh7cZOLlFPPdV
         9NsvplsAnC8Mjq9OIvlUjTxQZCsImNpxhjsgLs3KLNg78up4ACXShM27SwVavvBiCx1g
         DjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+IGpoiyzFanligWuRmGXoo1QqOYB207pOw7VsjY9xgQ=;
        b=VkekJxqZyRvW6fEMEAGv/0ESsSLsB274gIsksnAILwVismMiCnUx5RPEg/jDUWoE/j
         stXBtsHWK5S9sRfUfAmvVzYs6oIWtUeCYJRuMMLQUErYWRqa5GVzR6RDxAW3at0i2MbB
         lXgGheQ3bUT0vPuWLb8sXzQC213x2Y8hgmTmhtqzriiDDYrhfancuDeWIIBaWAFwpq5F
         491NbwAxTNwPA11ShmpTTxcHtCAveU3TsomVcOvsAL8SpdP/78Se7mA/YMlUbB6DFddO
         RFguH+g9CsfXlGyj6gIjmeAIMeQ6S6JROT/7r1cdyQHRnAoJnGSOiH5UlEjPCO/Ju+JV
         yhpA==
X-Gm-Message-State: AOAM533nI+mS/dCwxr1LFVETYVw3zzXvb7I+u2qmNk5sbK/cuOyj3gAC
        x3g4PjHVHXQY2hY0j3hK4siLryQXSNqL2GDy
X-Google-Smtp-Source: ABdhPJyGBejJ9mryu35a9DpnJmbVnmYeFsrTaUk2tsGwQ6yR7CRLpQflUiKLBi/sQ8pIv9+3LnFeDQ==
X-Received: by 2002:a17:90b:4c86:: with SMTP id my6mr8597630pjb.203.1633656996622;
        Thu, 07 Oct 2021 18:36:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q21sm540420pgk.71.2021.10.07.18.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 18:36:36 -0700 (PDT)
Message-ID: <615fa0a4.1c69fb81.e2e81.2b38@mx.google.com>
Date:   Thu, 07 Oct 2021 18:36:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.286-8-g1da3f70f914f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 64 runs,
 4 regressions (v4.4.286-8-g1da3f70f914f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 64 runs, 4 regressions (v4.4.286-8-g1da3f70f9=
14f)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.286-8-g1da3f70f914f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.286-8-g1da3f70f914f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1da3f70f914f20ae6906d212d2f9c6529a30dd1d =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/615f6f0cc0b235b5f199a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g1da3f70f914f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g1da3f70f914f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f6f0cc0b235b5f199a=
2f3
        failing since 328 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/615f6f2e12fcd4f00599a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g1da3f70f914f/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g1da3f70f914f/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f6f2e12fcd4f00599a=
30c
        failing since 328 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/615f6ea907f7bb3d7b99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g1da3f70f914f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g1da3f70f914f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f6ea907f7bb3d7b99a=
2db
        failing since 328 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/615f6e7a1fb6989a3299a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g1da3f70f914f/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g1da3f70f914f/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f6e7a1fb6989a3299a=
2e3
        failing since 328 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
