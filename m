Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64FD47D970
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 23:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhLVWza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 17:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhLVWza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 17:55:30 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDD0C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 14:55:29 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id jw3so3450371pjb.4
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 14:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W5w/xGqsCSngprRupsJ18a+0KuAbjLtzkyV/FntuY98=;
        b=PNEn0PyxFOIYUHri8l0xRyyxXvzRjmrIRtymz3JvFKWy6xoOn33il2oWWT/JHWK34e
         o4sCqG6MsfuxHoZKbQ711Y+6QoEfBCSAhkJQR8nHWjeUw+ydkH9Xopf5BLoO0ysnjpxi
         g1fF/1QCuI7ho3KTeT5nVX5TPIom1Tc0bMRLJefFJzWqnen/7V6Wd9uE0b+clp+U+Nxl
         Sed4eVDYAC3LTj9gfNNVFvojL3hCFb6B4dXcHFPStcb9yv7kyKbhyqT2WEYpRq11171p
         E5tdkv8+f96cbcYTru6oZWMd/ClABmhv6Qe3aqL3Ob2kBBYQ8GXMWYX14h0zKIv1v3w8
         Izdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W5w/xGqsCSngprRupsJ18a+0KuAbjLtzkyV/FntuY98=;
        b=mHdHIl64Ucfc8AdopV/b6l1eR2+/ThAofYpiCsXrHxbAM6Jft70OlIAfXC0Tt2NzQt
         GuWDSp/xHDJylgCx0G9QFvp24obFAbbKzRwHr9fXxjec/jelB7x6Ri7e0JBFdD5jobFz
         G948NwhnGyA5pmrpnm9KWJMp+y6fnR4va7+SDot5Z2xLiqQvGTlYiGwCoY13WNlc6fEb
         ECAADwU0l3yxiUXLrsME/6KpHqsmrPcq73zPdP25+cpZsq3jDo1PHsHCvVdYnVzVzI/3
         kVL4KkD57UOtkzU2b0ByJeB6ufWjt/cwcm93t6hr0mWuYMhab4gITV7xBLM4CklneyI5
         Ej4w==
X-Gm-Message-State: AOAM530O3sP6IebsCUC1HMvVYU0Xjyo1XEwC7g97oSbzXHp/gyGdlLnx
        ZUFtcT3hc7GHrPe8XcK92fKSDBcCIM/KPTWEHEw=
X-Google-Smtp-Source: ABdhPJxAfakdahTVJIJPLFYj42p+8hfMs/SHBv0ppLLIBkGF1puHIewsQyBA9JZEcKcPLsh3CrxqYQ==
X-Received: by 2002:a17:90a:ba13:: with SMTP id s19mr3609632pjr.62.1640213729078;
        Wed, 22 Dec 2021 14:55:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k6sm7026190pjt.14.2021.12.22.14.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 14:55:28 -0800 (PST)
Message-ID: <61c3ace0.1c69fb81.1aa24.41b6@mx.google.com>
Date:   Wed, 22 Dec 2021 14:55:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.168
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 187 runs, 4 regressions (v5.4.168)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 187 runs, 4 regressions (v5.4.168)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.168/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.168
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f843cf57202d0db77b31adb8d2ebb93690e91f2 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c372be447a0318b839711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c372be447a0318b8397=
11f
        failing since 6 days (last pass: v5.4.165, first fail: v5.4.165-19-=
gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c372de066838fda3397146

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c372de066838fda3397=
147
        failing since 6 days (last pass: v5.4.165, first fail: v5.4.165-19-=
gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c372e714dfd8223d39713e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c372e714dfd8223d397=
13f
        failing since 6 days (last pass: v5.4.165, first fail: v5.4.165-19-=
gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c372f114dfd8223d397155

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c372f114dfd8223d397=
156
        failing since 6 days (last pass: v5.4.165, first fail: v5.4.165-19-=
gb780ab989d60) =

 =20
