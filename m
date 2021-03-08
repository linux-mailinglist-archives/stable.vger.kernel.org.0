Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAED3313EB
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 17:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhCHQ55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 11:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCHQ51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 11:57:27 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AFCC06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 08:57:26 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u18so5132067plc.12
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 08:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WrCDytjCheumaW96F+Tbv8u2eMXcjxjCd1ZNHpTo/vg=;
        b=ZUW/NGF/X//KgeLRMhymqOEsi8slINmthwfFxvPvx/VwwfxMrVsV4dyPTcAcGKRgOH
         JtTxhDIzHYqpN16mEJNyP+7HxFTzlsTJ5cu2eJn80RMPtwReE6diU1cGM0qWmO6AzBsd
         oid8j48WnqMMGmqSe5wwCfR5rr1LDMLDjAolEIcaOaqLP/A2bGneUp3DZYdRQ1iwJ6Rw
         +lcZjXqEtQu6b9wriw5hXkATW3ZiLOqpkgDOcqKd6ouCNyTph5k0QJwSNDwhkNWxox8q
         ltmqLDaYd5aucNi768dgf1wtaAIx5w26mx+dlQtsZB5jixijN4FH2SzjnrEHmoOU/5Zi
         5PXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WrCDytjCheumaW96F+Tbv8u2eMXcjxjCd1ZNHpTo/vg=;
        b=lIeuN9a43auVzP86HXU8YLQNnI9JHn8tUk5fEMEMcVw+9EV1cwc1g3hLyK6Y1qZDqU
         4PjsZqSnqcErkPXQG8RL7TPgAd1tK2j2j/oQlx2QxkpyGq0vrI6kUSkRkMk1OlT9RZZ+
         G7qkLx4qGo6bhJz5CCpYc+tbjEWY9lGteB/eidGEsSpWS32naS5uqUo5+BeHGfrOTIwj
         0/n8BtmtGt+EMFx/TL7cvhonxrovG7xqg26PVXMLH45IiKJEK7EQCb2leJDokteyiZQP
         CKZOEH+ij1rJzr1VBMK+QDGh5uoDFkfCxBLKlPIKbO5pb1/+uTtWNDwFRL6sLST02vtH
         3hXQ==
X-Gm-Message-State: AOAM533fMHp+a4kxSkCMxD8jJA4yBHH9T2e081bsWvNDlCYgcszGrHaH
        sYG208dNCWl1fnxQhu//l1BD4Akihuh5dibY
X-Google-Smtp-Source: ABdhPJxsH2BASwlLJdBUiOUuttaVmoQGH8zyxVaDYyjJf24B4BH814xLxOOMDk04a6UZJg+uGpOMqg==
X-Received: by 2002:a17:90a:bd16:: with SMTP id y22mr22200896pjr.46.1615222646224;
        Mon, 08 Mar 2021 08:57:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i14sm11546172pjh.17.2021.03.08.08.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 08:57:25 -0800 (PST)
Message-ID: <60465775.1c69fb81.6ab74.bd19@mx.google.com>
Date:   Mon, 08 Mar 2021 08:57:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.260-5-g06238db4f79c4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 68 runs,
 6 regressions (v4.4.260-5-g06238db4f79c4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 68 runs, 6 regressions (v4.4.260-5-g06238db=
4f79c4)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.260-5-g06238db4f79c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.260-5-g06238db4f79c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06238db4f79c4b3b0f6226a7b821f0af250689b4 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/604624f84132cdf459addcd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604624f84132cdf459add=
cd7
        failing since 113 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/604624e44bcdb92ba5addd0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604624e44bcdb92ba5add=
d0c
        failing since 113 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/604623e983141a3a01addd57

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604623e983141a3a01add=
d58
        failing since 113 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/604624bd4bcdb92ba5addd08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604624bd4bcdb92ba5add=
d09
        failing since 113 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6046247cbb14be90d3addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6046247cbb14be90d3add=
cbe
        failing since 113 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/604623ed2318070e0aaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.260=
-5-g06238db4f79c4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604623ed2318070e0aadd=
cb2
        failing since 113 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
