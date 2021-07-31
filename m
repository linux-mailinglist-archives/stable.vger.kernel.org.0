Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6D83DC6E5
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 18:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhGaQYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 12:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhGaQYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 12:24:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24929C0613CF
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 09:24:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so18737926pji.5
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 09:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ShZHMdsN6M7B5MobXYgR/vW0kl1S2n8XoRWMZKn66Yg=;
        b=Mf8PlGPhFfztTRQt4a8H0vVx+rhgrmuOWRcSGZEoNZ2Tw05aXifrRFQY4bqXPmvVCD
         MNezCbAi6+2m496Eq5/MS/GWNqDXcPudiWCKyPOl9cO1KdH90KVFRCDAlu82IrqlxS3d
         EhcDCYdWqDLLmSB/UmFwqf4xkKUJF3SqhaNJ/zNMYIxsMeb8iVjaDsZn78uyeb7F64Ew
         dUPCse9AMhNQ9Pv5DKf6GIo6WnZnhe/jD209ri+zmeTVSL/gmdkkeqxGCXuKMuqQddv1
         goehNZzxNDArD4CP2yttEPAgtEEpCANjnyi8P5bfTrI4sHsJnkUgnx6twgaPt+M7r0dD
         dB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ShZHMdsN6M7B5MobXYgR/vW0kl1S2n8XoRWMZKn66Yg=;
        b=hFredV0EU+JRuP4dBEjBVbLNe6XppXe8ouo38xOp0mlrLMWybe5xK6VHaEUWCcGRl+
         ei3+UQ9bUg6qokSd1TbgTJqXjYn1aQgN5AWRzbuz3unK4FHMqESQW3Py3e3C6k5mVOKA
         EI2jKaGigP5V51P/mjRrk6JQGEEogpGN+zf19cF3cgtnig3GTRAZNeyrj7qZq5fxk89c
         dIT7RfYPWUOQHw/hAbWQ1Cb39OuMK6VYq8QziTL5fbKrlGOgjWvzhRfXm1iP5dAItCJI
         WMeOUvT2LaEKCnzV9UKvtjTkWRBSte4ZvzVxAUrDGXXqwF2FDU3m+XOmaaKqRUauCehT
         oYMA==
X-Gm-Message-State: AOAM530m8yAtBn6lpjDjD+PhT8LnxVuEfyhTWmblMKSGaAA4F9Tu26St
        Nv2i1ZIj1ZXMlXjJPx8aMmcR4RutWwW5dTkl
X-Google-Smtp-Source: ABdhPJyVxkQEztatYQge0yXfL5ibozRbURXL5MwQp/JP91NAMFqnkFFjN1Smtwl7F+SHjuhX2cnVeg==
X-Received: by 2002:a63:510f:: with SMTP id f15mr3404595pgb.222.1627748644515;
        Sat, 31 Jul 2021 09:24:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y67sm1732076pfg.218.2021.07.31.09.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 09:24:04 -0700 (PDT)
Message-ID: <61057924.1c69fb81.ca66.39e8@mx.google.com>
Date:   Sat, 31 Jul 2021 09:24:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.277-24-g96096930bdc2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 86 runs,
 3 regressions (v4.9.277-24-g96096930bdc2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 86 runs, 3 regressions (v4.9.277-24-g96096930=
bdc2)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.277-24-g96096930bdc2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.277-24-g96096930bdc2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96096930bdc23f9539085a0f75fb4ae0886478d9 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6105426a401a9076ed85f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
4-g96096930bdc2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
4-g96096930bdc2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105426a401a9076ed85f=
45b
        failing since 259 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61054252246fb2ade685f47d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
4-g96096930bdc2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
4-g96096930bdc2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61054252246fb2ade685f=
47e
        failing since 259 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6105434b65d44fef8885f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
4-g96096930bdc2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-2=
4-g96096930bdc2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105434b65d44fef8885f=
45b
        failing since 259 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
