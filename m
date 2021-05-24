Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B884538F29E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 19:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhEXR4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 13:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbhEXR4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 13:56:11 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74821C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:54:43 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d78so20559958pfd.10
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EqkjTNSWAXZSUloR2skT4FVlZB1cvhYNVfvgpCtf51k=;
        b=LTVkLqFpJdFBbJqwJmadY8HGGwLFdS/h57WvA+Qs/endKTHXkTI7kl4PYmedX4RVOB
         fc+CUc2S3/4EZy+yfjrwQW70N7zbmRazJc+tNtrDDGKDFabUAoldZn24OMd7cqR2YQcH
         MR7/eh+l4M6rSupYaIh19YJYqJ7C8C7Txf1c7U9rhh/JVENUfrHu/L17Feb+JRj7ayqe
         d2LlNU39/m2hqorrb5lGYrEO1TEra156iaEwgsJHU2qPDOzEGgW5dc1byzxn2TxKrrvc
         5LV+TehLV3BS8UatKNH6Ib9EqBbd+9XJw1YSNd5s3zzBfH8gl7Irhwb83J7qQtVQUJ0f
         l1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EqkjTNSWAXZSUloR2skT4FVlZB1cvhYNVfvgpCtf51k=;
        b=tc9LvETJqr/DIzA6k7Q2QSd0k/mxtgP5L4j7YGBwJ6udfVRUrcJGqyNR1+sVILHxYY
         jReBtILQot7jUhEmxS9K6nmJNDLZOcGRA/0UggWZNUeo/SO1raM7iU7vACRUnP1dSn9t
         LxQQg1dWGn7Q7tOIqenlAXnHoIlGPgIH3XAdOrAcb0gvKX2/xiufOj5WNsAvk2dbuRpD
         lxnAq5Kc6PWwq4BzzeC01d5r9k1SAsmnFzi2ahW2ga7APZguuMjIqwXfKZmZk8YM+rof
         OUeny5SI5Nkcsv7Pn4ey52D9IuwdC1fyGdUL33ZB47UUMRZwoW29WBktxl+tmPGsz1wI
         4y0w==
X-Gm-Message-State: AOAM532J7X7mk8W/tm/ZFkUIHg5a581GdnGc/b8WMQvo+PMVXGnIv60l
        cCndtRFPzKho553U9sEHbVGILbYkGJ+3fwG5
X-Google-Smtp-Source: ABdhPJyt0mbxTxHZvLj8J/kK0YjTuFCQx8CII9uHfiz1EAkipXE3GsDCcbPRjedQTC+WZqgnjsQ/Ag==
X-Received: by 2002:aa7:839a:0:b029:27a:8c0b:3f5e with SMTP id u26-20020aa7839a0000b029027a8c0b3f5emr26145834pfm.69.1621878882825;
        Mon, 24 May 2021 10:54:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e23sm11829517pfl.84.2021.05.24.10.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 10:54:42 -0700 (PDT)
Message-ID: <60abe862.1c69fb81.5a07e.6bd3@mx.google.com>
Date:   Mon, 24 May 2021 10:54:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.269-36-g71f0cedd18d0
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 75 runs,
 3 regressions (v4.9.269-36-g71f0cedd18d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 75 runs, 3 regressions (v4.9.269-36-g71f0cedd=
18d0)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.269-36-g71f0cedd18d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.269-36-g71f0cedd18d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71f0cedd18d0dc511546a8359fb11116255d2e09 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abb61fc716254669b3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-g71f0cedd18d0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-g71f0cedd18d0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abb61fc716254669b3a=
f9e
        failing since 191 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abb54b05e1497c87b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-g71f0cedd18d0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-g71f0cedd18d0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abb54b05e1497c87b3a=
f98
        failing since 191 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abb631aaaf836374b3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-g71f0cedd18d0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
6-g71f0cedd18d0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abb631aaaf836374b3a=
faa
        failing since 191 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
