Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C516948D996
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 15:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiAMORh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 09:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiAMORg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 09:17:36 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DC3C06173F
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 06:17:36 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id u11so4989515plh.13
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 06:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SjIuotzGzF4JeJbCJAoHYMemO2xN0YOCIbGZEU78S3I=;
        b=8P+/l8QxS9JGKWCJ2m7BmMoVSVa9hipURuu9wnGU4hMCmrRNk7IRA9nA8Op6SUu6fG
         egJOTOgLQ7ItgqfxnbX7WsUXiCPppNBx2a+wiaGrqnKpTn6TRiT9kR2q5Dt/shf1HhLh
         /kr13me71KDDd7JmP0P6wXx3jCfIAFLb6nitcdwPs9fc2U0QAisPPQ+Hr4DU1BUu4M3z
         Ldry9YCTxMX0geLn07NzCMB6sDb79EMadEa7GySV5Iu4GKmlT1JdnZUJyJv/suGqcfKn
         k+AsMeFpLDpGoGiXDOdSMx5ShOcTJCZfHUwygUgJ0nrJG1LyMAgEq2DDtTZwblx4LIM0
         K1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SjIuotzGzF4JeJbCJAoHYMemO2xN0YOCIbGZEU78S3I=;
        b=6fIxsjOKrNuzQgzwV8d8T9AWV/rKWXBRgN7SsH5KN06oJomfXuQyaKKiEfJ7hrpG2q
         FzvO8fpTvwrg3JY8ZDxcSTSl4fHieLRZ/Bo/NNJ9h0D3GtdJ8wbPGHi9LEI4I1GHg1aT
         Z5+xN/YYPiTw5K8VedvJYzfN0jq4SU2SEwFob2mgXkgJex5s79ppwpUQasF2MCoUYT7l
         DOyVYFRy5+/yTwnqTIludy3smojFYK+R7KoB7FXy+d7pSx9RUmrSz3V76IqXem9D9q+U
         nX0fUya+pKOhmCVljljQ9zXZzg9jWlg27Th9LMF46WdbSYBzzuapawOMLRTO8YG9jpiK
         mi+A==
X-Gm-Message-State: AOAM530rki1GWU+mfYeJMEaX586gduplz27Ok4TIORSbE+fU/n2DqpGS
        9LlqxevooxoSHbm7rzD2vcMgMoGar77lRyBTTe8=
X-Google-Smtp-Source: ABdhPJwHvp6bXEIIKxbGUD+ewmSY8cyLbiw0eTHTmWsi0mbMNpPhCw8lV0BrM47Ao32H+PUmClELhw==
X-Received: by 2002:a17:902:8544:b0:142:66e7:afbb with SMTP id d4-20020a170902854400b0014266e7afbbmr4767399plo.62.1642083455898;
        Thu, 13 Jan 2022 06:17:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm1578148pfm.32.2022.01.13.06.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 06:17:35 -0800 (PST)
Message-ID: <61e0347f.1c69fb81.91806.30ea@mx.google.com>
Date:   Thu, 13 Jan 2022 06:17:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-1-g308d204c515c
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 170 runs,
 4 regressions (v5.4.171-1-g308d204c515c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 170 runs, 4 regressions (v5.4.171-1-g308d204c=
515c)

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
el/v5.4.171-1-g308d204c515c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-1-g308d204c515c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      308d204c515cde4bc47c541f0c3572c2bdd50b96 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dfff47ccf06a3479ef6740

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
-g308d204c515c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
-g308d204c515c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dfff47ccf06a3479ef6=
741
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dfff506b1d83ace4ef6756

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
-g308d204c515c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
-g308d204c515c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dfff506b1d83ace4ef6=
757
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dfff4869212f660eef674b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
-g308d204c515c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
-g308d204c515c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dfff4869212f660eef6=
74c
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dfff51ccf06a3479ef6746

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
-g308d204c515c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
-g308d204c515c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dfff51ccf06a3479ef6=
747
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
