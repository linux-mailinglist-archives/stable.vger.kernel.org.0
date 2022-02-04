Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0174A9EE9
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 19:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377509AbiBDSYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 13:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237893AbiBDSYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 13:24:32 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3D4C061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 10:24:32 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id e16so5703106pgn.4
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 10:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y4q4r4uZotsNffqcZHMgPz7Dvivr0j0o4bhhnnh3xBg=;
        b=OckAOEB+cLBWwPJORySgUtaqf2Owj5m/iytcbobggzEjTqqHMWBudRG/BPN+NlbMXz
         oJmQBbr4cOpEiOOWQ9mNXmkXaJkSc6md20QG7bpfEXABYaUzlGDzbML4oLM6BqqT0F93
         eDJ49faoy2yyvBR+2JgpQUVojJvX7Lg3zfAVgqfLBvNabRs5DZceuk11PcdjDe7DDq8f
         RmcB7oTzJxWguiAVDFn2vFmdfu9k38aHq58cnFyYTHdN31Ky5bsTLMc4KK5T6jmvx0Va
         bImZ4JGP9mZfI+4U0f3kRAQRDq7xpCXypzcz0kRBuRR5wJOnkotZqGuLn6GaAw5NKjRa
         UJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y4q4r4uZotsNffqcZHMgPz7Dvivr0j0o4bhhnnh3xBg=;
        b=o+i12dPl+Jx9WFGxfm3EU+ouV1lonkUVYt8zpl6FiycmLPN1rJg5kbobsETci+2imE
         hlQtC3/6XobKwBedG5m5OQUj0B7mspGCXluIRlpHe3J7mszU8rVCQiVyYAMTAVVKhLQR
         wZTQZ2HbmAI57oKivb0TKKp4wnzKfRwW5JhQEgP5Rnr76kcKPDQc/VpGqvnaLJHesXwa
         D5jW8+EJ4P+z0XgMz4M3Ohd8jFfmGfG4LUIwYG5cXq7gEj0N4OJP5hFoZ9QV9uxuwyDJ
         G36DnbvREfak6JwGUcwEPfPjedO0e48ZEYHwATSGi9hjBXolqOOigpzGyxK4E8u412dh
         R59g==
X-Gm-Message-State: AOAM531ct52mDk7U70nY8t6gEXb7onHYqerIFtCCkZtwuYfwVaOZB+sl
        i6aAXpqmiOyNOqU8LT5rt/ZYAZq98AvRWx6e
X-Google-Smtp-Source: ABdhPJzif1/bpbBfLu51LuDdbzrZCzw8AZ3yCcPUDl+lJ8vIynCrmsQlbxo56Rqu+PRaVB9lwKzTYA==
X-Received: by 2002:a63:8349:: with SMTP id h70mr203681pge.433.1643999072173;
        Fri, 04 Feb 2022 10:24:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oc17sm15968957pjb.12.2022.02.04.10.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:24:31 -0800 (PST)
Message-ID: <61fd6f5f.1c69fb81.9dcaf.814f@mx.google.com>
Date:   Fri, 04 Feb 2022 10:24:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.176-10-gac53e07b07a0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 91 runs,
 4 regressions (v5.4.176-10-gac53e07b07a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 91 runs, 4 regressions (v5.4.176-10-gac53e07b=
07a0)

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
el/v5.4.176-10-gac53e07b07a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.176-10-gac53e07b07a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ac53e07b07a0c02a3684c6b295fefa9703e47c2d =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd353ea1f5c607895d6f00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
0-gac53e07b07a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
0-gac53e07b07a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd353ea1f5c607895d6=
f01
        failing since 50 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd350179b142a03a5d6efc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
0-gac53e07b07a0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
0-gac53e07b07a0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd350179b142a03a5d6=
efd
        failing since 50 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd34eeba1c90d8895d6ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
0-gac53e07b07a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
0-gac53e07b07a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd34eeba1c90d8895d6=
ee9
        failing since 50 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd34ff79b142a03a5d6eef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
0-gac53e07b07a0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
0-gac53e07b07a0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd34ff79b142a03a5d6=
ef0
        failing since 50 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
