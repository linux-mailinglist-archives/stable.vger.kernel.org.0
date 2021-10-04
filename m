Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E387421547
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 19:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhJDRpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 13:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhJDRpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 13:45:20 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7FAC061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 10:43:31 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id m26so1920614pff.3
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 10:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qvQUUTY/369aNiVvhybgCFVyVNo2lK4kpVjG871eGcs=;
        b=iW46sPRqvx1Ttc7q2R4DNZ2mUg8F6m1wgL89YynNE3p4Q6q5gh4k+YxuIbZhbXJt4q
         R382HXg0bnYy0UIMBsVZtkxArzrFu5H4PYSttGWSFsi9ENDHxoZlkURX6ZTKNcF3YUNj
         e0PCHb6YA33f25SU8XAdVK0L7WmV35ESmWTMYUvJcWs38PXnx0bZIUeHinNK2fn8wP1u
         0BcaWodVKpu6ME0S3yhs+PKKSz/P4JhMFZ/iTw5hzou+KtTgcSNiqafp5QQMip1xw1rf
         shZLt31xxoUjcB8ihZ5yg/RPDm+QOzYF4NedllH7DyLrapvQWZNn9EGSNbREUlozpY0R
         VFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qvQUUTY/369aNiVvhybgCFVyVNo2lK4kpVjG871eGcs=;
        b=GPbH4Xr043COJ1cLfdN+WJ+uOuCKbLRbIGhIHRRkAGVaLxbLMMw9SbUMaYL7qpBePb
         BG/VrnuiKaKrFuHyGZO8MeSd7A3zo8S+4hYFtUKKXDB//MeWlTfmXovZheDi1z9wg8ux
         0DOpBDMO6soiPZ3+7LS0YgEy4LMduRVf7Exe/7BmPi2i/jXTO/4w/jA5JkMMiDlwIvN0
         hqOsV6Ym+rorPScwJxyQnPUl1V3QNnDfSXmERShzpGEg7lIbFPzr8N/porO5V6YCFste
         ESFxT0BZr/8ejT9eHs2odlX0QARNzEl1Z7K/tOkEjTo70I2f/tB+2hc5EeHz3nU20JBX
         yRXQ==
X-Gm-Message-State: AOAM533l4SNiyQxv+IyX+UUci9TOaAv2LoFZ6Erhv3WuLVL4p2GSS95P
        /3gRpDNI0KA461g7ubVckDL1jbvbcMId7QPz
X-Google-Smtp-Source: ABdhPJzZMIKpQZjSzDt+ouTj7LP9FPLE38fXsb1hhwROlNFrrW9TKaodeDHuQgaob6NpG4ziU0DnxQ==
X-Received: by 2002:a63:2361:: with SMTP id u33mr11949040pgm.369.1633369410889;
        Mon, 04 Oct 2021 10:43:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14sm14955764pfq.61.2021.10.04.10.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 10:43:30 -0700 (PDT)
Message-ID: <615b3d42.1c69fb81.6c3ec.bbbe@mx.google.com>
Date:   Mon, 04 Oct 2021 10:43:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-57-gda93303c75cb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 125 runs,
 4 regressions (v4.9.284-57-gda93303c75cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 125 runs, 4 regressions (v4.9.284-57-gda93303=
c75cb)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.284-57-gda93303c75cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.284-57-gda93303c75cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da93303c75cb742afc54244b16ee6b7fc50c9611 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615b0a50200bd8d37199a35f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gda93303c75cb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gda93303c75cb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b0a50200bd8d37199a=
360
        failing since 324 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615b0fff239325c73899a30e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gda93303c75cb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gda93303c75cb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b0fff239325c73899a=
30f
        failing since 324 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615b0ac4a43faa022f99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gda93303c75cb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gda93303c75cb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b0ac4a43faa022f99a=
2de
        failing since 324 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615b0bcb3bf0c4308b99a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gda93303c75cb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-5=
7-gda93303c75cb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b0bcb3bf0c4308b99a=
2f3
        failing since 324 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
