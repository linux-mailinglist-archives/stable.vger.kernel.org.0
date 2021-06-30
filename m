Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AC43B7BD0
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 04:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhF3Ckn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 22:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbhF3Ckl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 22:40:41 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA94C061787
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 19:38:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id l11so783697pji.5
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 19:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qSX0+nHR+U7wA5owQcyNiSeFufMbzgaBE1aV1lnt+R8=;
        b=aBBLZbiSe8KmAMIwO5GnHbqGPG7lOutrus480Ydk/wGEOai4uvJ1MmPOVEn3CSWnWz
         qKjfWWcF/Qojn5hjNvdEGaWpln2bg/HZtP+kCSGV2yLj951vsRSf08+RpD2Ge85JALZC
         JsCTA9AsvL80RwLm7Dtq78pPGh9zDF/squXF7hmD28u/aJ8dAnTU7ok1cSOCqbKo+CFm
         7uuFE/OVwZMOMuFSQGxE/0n08d0KDpA1vUR3cQTdSPV8jnZtEVhwypaP6m/JluorO5kh
         OSDE9Y58FTypd1BmQo57ILVhPTR17O5X9+Ld+wnW3e0314K0YEtEKuOMuIA+FhVhrp7G
         x9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qSX0+nHR+U7wA5owQcyNiSeFufMbzgaBE1aV1lnt+R8=;
        b=OCqPIccNpw+TTTt+75o/y1cY3Fsf7AasXGemKBcAQfbxda4INOaNFXefq5Lzr/EpwH
         fpZnhb7VHsgo/BTi0KpbzKmU59AGIeZoqOccmcoQkMTXEvzcgmYfjbL0Kritzlrv+6cV
         9vS+I1hg58hvG/dUztrD5+2lbbWTm0Q9yAR991X7sIHyBnAGpQ4L+DMSrwf0gm7auBjf
         JgV5BMPnm9NwDmiY/usUfwlhuM+Au8cQ8ctUXgjt3/JV6D7lQxUE/g3CTlDBLZz1B9w8
         cJuMVwTWv39TUXFsvHQEBH80WzExlLM7hVTpBBzSNh8XZfzyvifsD85bGXsaZdbeaGDm
         g2Hw==
X-Gm-Message-State: AOAM530gRlJ8eC17jxxjnwaCeLYizyRupVpD6nLX1o+vWm/Othdu8ok8
        IUkEs9qLrW7E/ycp3OAJkaZiSrrinYWLVhAE
X-Google-Smtp-Source: ABdhPJx1zce+yrGxZ7IJIYQFVKgFy/8NLRmHm/YMxwv5s4EN5CHvPyVgWw3ThJMT3qUtrW3nmc6pCw==
X-Received: by 2002:a17:90a:db98:: with SMTP id h24mr36643273pjv.62.1625020692995;
        Tue, 29 Jun 2021 19:38:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19sm18123951pfh.155.2021.06.29.19.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 19:38:12 -0700 (PDT)
Message-ID: <60dbd914.1c69fb81.a9308.7108@mx.google.com>
Date:   Tue, 29 Jun 2021 19:38:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.273-56-gc1d107bc0e6b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 86 runs,
 6 regressions (v4.4.273-56-gc1d107bc0e6b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 86 runs, 6 regressions (v4.4.273-56-gc1d107=
bc0e6b)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.273-56-gc1d107bc0e6b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.273-56-gc1d107bc0e6b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1d107bc0e6b3fa9e91e11eabf1b80c5fffffa88 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60dba8ea70024672ae23bbd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dba8ea70024672ae23b=
bd4
        failing since 227 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60dba90a70024672ae23bc46

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dba90a70024672ae23b=
c47
        failing since 227 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60dbabe27817c3b10523bbcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dbabe27817c3b10523b=
bd0
        failing since 227 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60dba872a28028d94e23bbe0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dba872a28028d94e23b=
be1
        failing since 227 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60dba8f6252604dcb223bc12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dba8f6252604dcb223b=
c13
        failing since 227 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60dbab5da73fddb90823bbd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.273=
-56-gc1d107bc0e6b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dbab5da73fddb90823b=
bd2
        failing since 227 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
