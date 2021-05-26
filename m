Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14A4391BFA
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 17:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhEZP3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 11:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbhEZP3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 11:29:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932E2C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 08:28:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q6so989912pjj.2
        for <stable@vger.kernel.org>; Wed, 26 May 2021 08:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wb2rnajC65JahekSP3wqbVHnk49zqzMox7Is3lgFJrI=;
        b=kZvBBpGOgObjcYW8zHox8/GKtKdqJBzW1ZAt07lf+1QiPSo/FZF+STHgAuptahIzkR
         vVMwCvDTgP/Fk17Q7CqvtAVqlP3/ltAqaOy54vf3/JQ0ICy0B7lzbWJ7MlKcAnrvccrJ
         7i+qDea+5BLV2D2D2wnlp1C0w8VoLz8+oGcF/banpjA8VR88pQEoZMKRCxHa+DtZgMe2
         9VyzNv5DMx+FDKBGRuuyVD74DpBKlna1Wb8B7Ie0+/kQtEHBOUXUeH7qaoE58KPvt61v
         KJ3y1JMFkK0u/fGUp4hZvF+WCk+AVA6Rr3ACAtpoyzveZ3wQ8h9YaZwzol2Vm0JhCRtd
         nq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wb2rnajC65JahekSP3wqbVHnk49zqzMox7Is3lgFJrI=;
        b=ho7I6ijaayY50L5+k8E0X00RjADl3G55lqJIqVhbpYmKjc/cuiRqKC9zBub8AbxhqS
         NegV6Ur2hH7pxIg8KuIrzeS7PNmB5K0BsPz0Z6nHdkgLZoJnIAgy8/FuRzGvmGmmPEK1
         R1yB6bT1bv4Wdeeg+SN/FThuektDPWFQ0CLrr29f3wHB8HmXwciJNS2jSjyPG6Df5Zuk
         kwp54KeNLmWHkgsfx4JzCHlyyZYtVYkPdKJ2SYqWuQ6I1SBzIG/NTOa8PDbwvQz3zK9Q
         C8SgP0xcQrIFsB+YWBjBMPgCXqunqsBpebNu+VhBYKS6lC95LfxN0A1wIbNbMVZtYExU
         PSuQ==
X-Gm-Message-State: AOAM5306ZsgMi1KlIl48ZTTxUTgdcHsq4Bi89+/3bfLqpgdE7UK31pep
        MVQzhJkZsU1CEgEEKFfuiKuaSULk7tyUfuZr
X-Google-Smtp-Source: ABdhPJzpFrbgVJCE3yudaZUV3Cdi4Fux6xLi/5knjg8warJ9sgvotBPdJYxvEnYZLJHk65ov4D2AKw==
X-Received: by 2002:a17:902:8341:b029:fa:2aef:7e3c with SMTP id z1-20020a1709028341b02900fa2aef7e3cmr16231871pln.9.1622042886983;
        Wed, 26 May 2021 08:28:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ch24sm4686374pjb.18.2021.05.26.08.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 08:28:06 -0700 (PDT)
Message-ID: <60ae6906.1c69fb81.c5b18.fa64@mx.google.com>
Date:   Wed, 26 May 2021 08:28:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.234
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
Subject: stable/linux-4.14.y baseline: 89 runs, 3 regressions (v4.14.234)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 89 runs, 3 regressions (v4.14.234)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.234/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.234
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ad8397a84e1e425e3f8221638cee2bfa237d9b2c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae357fc85f6d8901b3afda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.234/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.234/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae357fc85f6d8901b3a=
fdb
        failing since 188 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae34f48cf6c46364b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.234/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.234/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae34f48cf6c46364b3a=
f98
        failing since 188 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae356160ce6171aab3b018

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.234/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.234/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae356160ce6171aab3b=
019
        failing since 188 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
