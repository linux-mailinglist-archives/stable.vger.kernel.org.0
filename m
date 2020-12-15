Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4AE2DA7AE
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 06:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgLOF1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 00:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgLOF1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 00:27:20 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB168C061793
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 21:26:39 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v1so526345pjr.2
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 21:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=42HAheGkAHMcDoLNi0iMUjWkaydDSYgAjAeH4m9/m8s=;
        b=iEKORmJ3D/4qaA1TBeQW64tepoomsukQGh6wtUMW4EcFHXG6UqVQqkFZjbedDsnX10
         KBLuqdZ9KhdvRdzSnSkP60SL2Uq89AAEihZSHquc11HLPWUzO9xG3fRu555v/+/r6AMX
         Qlbz9A0QAg9oSSArS1d/yNRdAm9kQmifYFSfSFQKj5KwqqGeU6doVsqOmAl2yNlB0tn/
         hDexrrdpT84veML1CxjtQ9GXMFkp8AY9sLoHwjrXitkClmjD5QAo4pIeUdqV4/uS7N+T
         OLFwcGVt6W/2Grvx+8nmECSvu4T82Zr8EwOqBuH8SpRHNJa8baIs/XBTgDrAw00tS9IN
         1itQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=42HAheGkAHMcDoLNi0iMUjWkaydDSYgAjAeH4m9/m8s=;
        b=qGraIfkg1gtWTzqEpEZqd1Pdqjk+EGv3DTVlFSS6Y83LpXg99ZyVINertpFaNZFDlE
         WZHJ0S1EcqfA4moaAakHWTF+73nFHdvNLNO7cH5oz55Mxuz9Epcf+0WluPNkHJxWZ0JV
         BAZy69Y8S+ewvIZjw2ZPw/j+Fda9LZlCZ2//rUzpml1x64dHtpkjAuyr3E4Fepvt86E+
         FwojzxPpxahD+7c3NVAy11tjA3d/IKhoiJfXTzXohWHXf18eJ2poExaw9IuzDL2E7M6c
         Y6GJOW82Qe/VGH9Z1NgwfQntE72LFf4d7KlQt6i+oOUXQbHgDjEBassvFiOzSBXL1xfB
         Aj0g==
X-Gm-Message-State: AOAM531qTgMXsSFr8q1VQn6I3lDVfLt7HXMpGOtaa5cRv+sFkpYLjXPj
        0NOgzTHDoyVVqNueexw78QZCBZuZCRv4Lw==
X-Google-Smtp-Source: ABdhPJxdbyGMzy4JjpAwQYQiqCeS2RXYDfDC3K7qs78O+P8EKVVob7cZeeSlRIHEMLJOJgHXa+M3aw==
X-Received: by 2002:a17:902:aa4a:b029:da:e73b:1bfe with SMTP id c10-20020a170902aa4ab02900dae73b1bfemr25079612plr.67.1608009998492;
        Mon, 14 Dec 2020 21:26:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w18sm3309960pfj.120.2020.12.14.21.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 21:26:37 -0800 (PST)
Message-ID: <5fd8490d.1c69fb81.f5bee.7f98@mx.google.com>
Date:   Mon, 14 Dec 2020 21:26:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.248-9-g0a6071f17447
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 57 runs,
 4 regressions (v4.4.248-9-g0a6071f17447)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 57 runs, 4 regressions (v4.4.248-9-g0a6071f=
17447)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.248-9-g0a6071f17447/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.248-9-g0a6071f17447
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a6071f17447a76d85170b1c3a9b7f002080c4e7 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fd816bab3fa3ebd6bc94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.248=
-9-g0a6071f17447/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.248=
-9-g0a6071f17447/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd816bab3fa3ebd6bc94=
cc8
        failing since 30 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fd816d0507b7f7ad5c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.248=
-9-g0a6071f17447/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.248=
-9-g0a6071f17447/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd816d0507b7f7ad5c94=
cba
        failing since 30 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fd816bec65ff766a5c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.248=
-9-g0a6071f17447/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.248=
-9-g0a6071f17447/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd816bec65ff766a5c94=
ccb
        failing since 30 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fd816d6507b7f7ad5c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.248=
-9-g0a6071f17447/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.248=
-9-g0a6071f17447/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd816d6507b7f7ad5c94=
cbf
        failing since 30 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =20
