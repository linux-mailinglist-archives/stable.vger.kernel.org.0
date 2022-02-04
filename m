Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8624A918F
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 01:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352302AbiBDAWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 19:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbiBDAWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 19:22:16 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDCAC061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 16:22:16 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d5so3936555pjk.5
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 16:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kjo9DhVH+PlNBLtV+Fgz941bLnbjoy7j3ijq2xYk7T4=;
        b=PNjEi/gUacbSBo2CghCZhRJFSL8kvP6xQ+UDREMGgDXkHJ4WZ7aGXo2GSY9JNBTC0F
         wvgV6770s3zn9MMK2bksa9fbfTHDNW/1U6hKpW9MPbJEDiC3C2158L+OvCfghjRRBQPW
         Ohd/MdR7k8ekSlq2OfQG0X+Sle1q4s6OX2Ix88Ot01lSLSjTd0fV/2gSPJe7jqso/S2y
         9hSOJQ5j+aMuoCet13hdcLFsOykExxhyR2H5MWR3wW11UsOdriPVPr4QGMPjMwT9wlp6
         wV04vap1pBuuPOR3D/qv34gzNuyBK5iBJZfF9DqZ1uTzJLNnFt2k8CrGKZnLjJDykwpy
         0Veg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kjo9DhVH+PlNBLtV+Fgz941bLnbjoy7j3ijq2xYk7T4=;
        b=e/qIXiXEImDzKax4W2TcDwAmiYlAnL8nc0B9LNU5WJJBqIIcsqO1Gy8rmkaA7b/maf
         6HfQBaJRxXG6OhpgOAq7XMxwylWkJH+Rz1wtY0AxoNlDkod6JCCSoQd0JJWGEs/AZvYj
         ugb+xiGBHJHvmehCWqEQ9FriFRYqCdHaeEgLxu/l2m3XZcDhxZ6cJGCEh4fyWDb8nZH1
         6K97ieDhyAB2UNkhqtSlud+QmQLWEiVT/IM+cbW9mPzvGnYk3EoCznolPpO/uEhGWMo+
         QT4eq3wvPqCrVWsZhnnFdBXbjfBiaHFdxRYxMe2uZKpwyKhESa8I5k2/aux4DFG7S9yv
         afTQ==
X-Gm-Message-State: AOAM531Zis9CQCthjWxx2/aChzW3LrhDZ4fIlCc3fwGdYQbG7xt/hnF6
        W0fjydn/8fh0/rueTiUd3KK/VHRR/0RyROu9
X-Google-Smtp-Source: ABdhPJxvLu1d5Xs5/0E6HhT9t47/7rO8ejiSu17rUOOOSOmke8BAOWC/OH3+xllwCS5P19wcTdMwjA==
X-Received: by 2002:a17:902:70ca:: with SMTP id l10mr442646plt.174.1643934135859;
        Thu, 03 Feb 2022 16:22:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mw14sm135877pjb.6.2022.02.03.16.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 16:22:15 -0800 (PST)
Message-ID: <61fc71b7.1c69fb81.56ebf.09f4@mx.google.com>
Date:   Thu, 03 Feb 2022 16:22:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.176-2-g7e6bfcec6bfd
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 131 runs,
 4 regressions (v5.4.176-2-g7e6bfcec6bfd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 131 runs, 4 regressions (v5.4.176-2-g7e6bfcec=
6bfd)

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
el/v5.4.176-2-g7e6bfcec6bfd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.176-2-g7e6bfcec6bfd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e6bfcec6bfd357008cec5adf5eafedf95fc26d7 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fc3a492f23cb88b95d6efd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
-g7e6bfcec6bfd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
-g7e6bfcec6bfd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fc3a492f23cb88b95d6=
efe
        failing since 49 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fc3a013ed0accdd95d6ef5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
-g7e6bfcec6bfd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
-g7e6bfcec6bfd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fc3a013ed0accdd95d6=
ef6
        failing since 49 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fc3a4b944d21e3175d6ef5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
-g7e6bfcec6bfd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
-g7e6bfcec6bfd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fc3a4b944d21e3175d6=
ef6
        failing since 49 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fc3a392f23cb88b95d6ef0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
-g7e6bfcec6bfd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-2=
-g7e6bfcec6bfd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fc3a392f23cb88b95d6=
ef1
        failing since 49 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
