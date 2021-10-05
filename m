Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D00422ACB
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 16:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhJEOTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 10:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbhJEOSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 10:18:00 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4DDC061768
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 07:15:49 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l6so2408332plh.9
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 07:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uXpmeGw2sK6izbs1te7n3jFwl5bmDcQ23kAqFWE2LVY=;
        b=a2aD1uDcZWqQLKDERKrA6TzexDC7hH2MG2Z0W4v0gjAdUIVUdGEc+oBb7GyfuJ2bJD
         wKH2iHt5NmHrYaFkgsXTJ68Hw3rd9TZQr++Ll5q6CsHBfp3Yf6mEONvseaZpZ+QE6NtH
         MhzmDuf19AlRB2UG1K2c2kVT6V3gkfS7w6hVXmZdWFgJayIR3Og8z8Na73arO1SF1uY4
         GGyigMvqQtJsFZNsCDZeP7GqwPf7opHrs1Sn/bKpmqs4Amrh34pCB0wfYjn4jKfbZJYM
         s8I0iIs6/6TUEPx7erwnQA8SZhhn//VtZTaqxBVRPMnrFbXiTMo6jYLOWkzTXXbU6ECI
         Nt5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uXpmeGw2sK6izbs1te7n3jFwl5bmDcQ23kAqFWE2LVY=;
        b=EG1mHUXdIK3HAbicjT3hFBYoY/LlmqbQvXeJp/vDUaEMiiOyXLYhObE8jxzHdLOchS
         9UfGg6Plir7BFwCMbeF4Nvd8JIZuNN44p7jy/aOxeOA3M1yDTNbwvibsZbYces1UtPRP
         96hEd09lqfOegzjPyyIAfkcZJtaM0PCjuMDQQaaMPCXRi6lDqsartH1CJd9H6VeFqz+h
         kH3KP4/i8Fn55S6leGR0e6RNLfoiE3H8XB4Yw62oVmm1/zOZpWqiJWYUo8R5uIXp/96s
         QEo3w/S77pgZjjmPD++E48MLkXjTfC1SVmSiCXDbPJOBef97JDBPAJMDCUwMKgleIx/6
         arVw==
X-Gm-Message-State: AOAM533j9goVP7xNMfXpYSO600a9l6rPX7mYWZkuUwr4HLTlzs3ueO6Z
        hnZZQrTOPYSmzT7YBR0IMZ/Wu6GkUldz5P7R
X-Google-Smtp-Source: ABdhPJzZzwSA6RP2MXwLJNcKjztuzfofHfEPqPvknglM+ymd3ysmVApse7LdoVzWec4gDILYXB/5BA==
X-Received: by 2002:a17:902:c409:b0:13c:a5e1:cafc with SMTP id k9-20020a170902c40900b0013ca5e1cafcmr5376174plk.52.1633443345553;
        Tue, 05 Oct 2021 07:15:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z4sm18574623pfz.99.2021.10.05.07.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 07:15:45 -0700 (PDT)
Message-ID: <615c5e11.1c69fb81.dd578.80cb@mx.google.com>
Date:   Tue, 05 Oct 2021 07:15:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-57-gfa88ca183137
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 98 runs,
 3 regressions (v4.9.284-57-gfa88ca183137)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 98 runs, 3 regressions (v4.9.284-57-gfa88ca18=
3137)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.284-57-gfa88ca183137/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.284-57-gfa88ca183137
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa88ca183137b23db7f3de172cba769b6122c6b5 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c27b0fee70b23d799a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gfa88ca183137/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gfa88ca183137/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c27b0fee70b23d799a=
2f4
        failing since 325 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c4236a38d591ef499a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gfa88ca183137/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gfa88ca183137/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c4236a38d591ef499a=
2fa
        failing since 325 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c2868b927d4730c99a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gfa88ca183137/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gfa88ca183137/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c2868b927d4730c99a=
2ea
        failing since 325 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
