Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F90B32BC13
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383070AbhCCNkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhCCCvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 21:51:02 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CA5C06178A
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 18:50:17 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id jx13so3254359pjb.1
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 18:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nOu75EnS5rz4z1PA5wdzBTqNlI+czKi7clzsWAq9ewI=;
        b=sDeTDfEbx5f+mfo1bjZ2O88xyR81v/J+24YUe75re69MLXNsiTfn6j+mxds/YOQGyy
         0UfqC27gLHFby8EAnIlqv4ipihRBiGe/WGUd22ad8IO6uw558bxnn1zP2+F1wkzqIP7X
         wrh/uVBnFSHzvfcCPt17n1LyznZn5B4rBX1XpKVzC4NT1bU7RdV2LMwvRXBAHzV9xI7B
         +MB7womlOblgK0pmkDxEmtagQfPHJYr7U+/aG7EVAl+gpX+FI7Za8dTlnfmrotPqdW/9
         rwXrSvy564VgQ01wIocwowUk++gcRpxVYU2pXTWG6Sc/a2TWXY4q2wBEgNMSdcL/DQOD
         MR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nOu75EnS5rz4z1PA5wdzBTqNlI+czKi7clzsWAq9ewI=;
        b=Tt1M+ckE1xv/yewq13P/9WCIALiOvm73HcxOt/IMqltCDY93DlK97nYJfYKw+qg/Xo
         A808AO4PcHcjiZSwZawU20IKF9HoaJNNNHWx4DSSDUF5rgty9HOISUCk+sXMx5LY4On1
         2tYduv+s9QP0IMRBp2TAiCqjWh8rVyZ+cT6Aywx8dY/mMfUd++O5quM65BQJ6rA+1BxR
         Sq3ZhypgpCdkVPiAKDruHBQUPw8bY2xvW3rOo0A5OTxwBS5qp2NP+yYHi0LtMc0SL+PO
         PBLjnqEX5Y9qatEbVKEZVYYJSWqu55VsQL7uXWTjngLXEsdvlBepstgVxdLXh/G3Epjg
         yMCQ==
X-Gm-Message-State: AOAM530bI2Ul3mEoYQ/HcpFr6aHw61oysb9/eyQxdovW5QKCZt2/vir/
        9h5Nq96EvhT9Pa+Gi+F6uZl4qtAqkG/c+g==
X-Google-Smtp-Source: ABdhPJxUwC4kT8YUPX2Yc13AonBCysyAtzVEj3DvGAzKhweRKqUD/0uqp1ii5e4y8ai1nGpNk9WDpg==
X-Received: by 2002:a17:902:7618:b029:e5:c9ce:cb3c with SMTP id k24-20020a1709027618b02900e5c9cecb3cmr649621pll.74.1614739816910;
        Tue, 02 Mar 2021 18:50:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ml17sm5554759pjb.45.2021.03.02.18.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 18:50:16 -0800 (PST)
Message-ID: <603ef968.1c69fb81.27425.d1f8@mx.google.com>
Date:   Tue, 02 Mar 2021 18:50:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-338-g44433bdfc6fdb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 144 runs,
 3 regressions (v5.4.101-338-g44433bdfc6fdb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 144 runs, 3 regressions (v5.4.101-338-g4443=
3bdfc6fdb)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.101-338-g44433bdfc6fdb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.101-338-g44433bdfc6fdb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44433bdfc6fdb454620f64bf0148f3480a45afdd =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603ebfb8dcb096b876addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-338-g44433bdfc6fdb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-338-g44433bdfc6fdb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ebfb8dcb096b876add=
cc1
        failing since 108 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603ebfa5a1cdbc4df8addce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-338-g44433bdfc6fdb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-338-g44433bdfc6fdb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ebfa5a1cdbc4df8add=
ce3
        failing since 108 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603ebf62a0b529e9f2addcda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-338-g44433bdfc6fdb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-338-g44433bdfc6fdb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ebf62a0b529e9f2add=
cdb
        failing since 108 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
