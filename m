Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44CC32EF06
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 16:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhCEPhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 10:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhCEPhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 10:37:01 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D611C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 07:37:01 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id g4so1623144pgj.0
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 07:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uF0tJJes44J+zsntM9WK5TTXkHksC3aeqhmfyLqp/xw=;
        b=JUcWRbM3wlxhrZtI0gFF3ec4/qNfCs/tPenpsGBlkBRSHlhqTE2FlxoLvZ3pvA1Yg3
         NjOBEZ2BDnZe1kxdyHzTgxbZQfTwbZvrR2ZObTE+I7CLeWcaBD3CCKsNhKcjZFh3tCYY
         HumTlvUL6VFndAczhLEj9tFE2q6rIYns+QGKbnkdbxlZ9D3qtkwjGn/NiowuI/dcA7Sw
         Y8wRlcJI953LVHl+3dwnqjMGSh6huPBYqh7XGTjAt26IOVKAvNQ+DKBKfPlCEZ+d1RQ+
         QVlczpCe4sFTqqkAMrgcW/xmJOA2z1SyAClNPc2jH+H6lfxDRedcMH84sgjj/NjCK99a
         IqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uF0tJJes44J+zsntM9WK5TTXkHksC3aeqhmfyLqp/xw=;
        b=Q0QTs3XRLMPMjTGwbvLt2sQiGY/x1j6h9AOzm/VNyUcDFMGquwSnM7Z/fTixvubBOW
         Ua/0IbWw1GXq/sOkJa+8F1XIx65Eb+R/CkCe2PasUxnwx27DDOJr16wK8Yes9UndpmL3
         aCn0bYgs1nFwtLi3rCDq8QNAMNaZBttdnUcwgp778uHbI+zcyZjJ8uLDOXfw9JD8Kkxp
         J6M8Sfyb9jt7MBlZGY0wr9eZFAITHC5se6o/4w7nl0EWRSIyuOx+h7KNLW4f5VcbR0G0
         OJqBygGq/GmoyFYoayu5tUb+9lK6MOyBv5xGNfyIOrsXyyRs2rsQ6WxaBThkR0Lmn2TI
         5gyA==
X-Gm-Message-State: AOAM530is8JAMXNDwHB/LOqlD7IQ+avYyLerLA84j8e8JWwF+W5/8fq7
        OeJI9kGyEn9MB0CWmJbwiFPOBe4LKIdCu5sI
X-Google-Smtp-Source: ABdhPJziXVAofDtBQ9/rUlDQR0Lw9RPi8JTCtIpftb+GCOIfSAqu2PxftvcZlGmdre5HReDKuVabEw==
X-Received: by 2002:a62:ee09:0:b029:1c0:ba8c:fcea with SMTP id e9-20020a62ee090000b02901c0ba8cfceamr9323069pfi.7.1614958620723;
        Fri, 05 Mar 2021 07:37:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p3sm3043394pgl.88.2021.03.05.07.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:37:00 -0800 (PST)
Message-ID: <6042501c.1c69fb81.dd879.7907@mx.google.com>
Date:   Fri, 05 Mar 2021 07:37:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-69-ge2b1f6b284321
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 95 runs,
 3 regressions (v5.4.102-69-ge2b1f6b284321)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 95 runs, 3 regressions (v5.4.102-69-ge2b1f6b2=
84321)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-69-ge2b1f6b284321/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-69-ge2b1f6b284321
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e2b1f6b28432113d017908fab5b1d5b9daba2726 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60423de092f6546849addcdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
9-ge2b1f6b284321/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
9-ge2b1f6b284321/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60423de092f6546849add=
cde
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60423118d18af6e299addccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
9-ge2b1f6b284321/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
9-ge2b1f6b284321/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60423118d18af6e299add=
ccd
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6042207c7ae47baef2addd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
9-ge2b1f6b284321/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
9-ge2b1f6b284321/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042207c7ae47baef2add=
d20
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
