Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3418414188
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 08:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhIVGKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 02:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbhIVGKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 02:10:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F7FC061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 23:08:47 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k23-20020a17090a591700b001976d2db364so1464477pji.2
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 23:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QvWkHKcSU87xQSHBIIzRNQJXZMiF09xfj06QwTkUQ6A=;
        b=cqdwI7jqBlDtRsQ48apcVog4NZVGg9CMhSx1YT2IyxrMufawkUMQm8LidKdvy6Sx7F
         5zbDJ+ZTsFqwKa/cazQh+x5oQ2DntBCXHJYz16BA9uRXtnzi+REpg6J8ZvRk5t4GxEhB
         wMXyaxap1NPHqvDnpTtO6mk+kuAjx6JN5CjhB4O3iRgcQJNXS9UzwSQS+5F9NPmS1omG
         DohQFTO8v//2tp6CZhjPPeJrbTnA6fuoVs9mqYBgNWvLmk1PCPPqdiIKEibGoUerRBgh
         kaNcfjCawrLYvJUWGeFDwfdPX2AsN+N3M7IICjvVogC5g2tdfpTaEXIy9NFOjJiQTFoM
         Ix/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QvWkHKcSU87xQSHBIIzRNQJXZMiF09xfj06QwTkUQ6A=;
        b=w3646TSY5kUBLjeI93gaonzUjDNtzVrLUNLmmrtSvblirpHYgHEJk73A8jzoS2oDor
         lBKmc8X1H2yDmfjnZ3xnmXSI0eRyVH3f5q1F35hO9ROiLlDselGlAE3lg/PxIqOuAT4J
         mcrVdD89ZCAfCiNUFR0Wzlk0tq4x/Lsh4sQSh2GVYgbeZ0+hsHDSHwzkiyGAsp/GLOFT
         xZMHCSVNVavHDeof2Dq/ufWld8R8tQehcLGa4e0IM+umzgdXjQSm56QcrKquEpIw7BTS
         vUyKSWKmumtvgihFEsaHaonPcRxxz0vKb3kV1uJINRi8PRIvu0elpFL6BN/pS8PJgl7Y
         l1Xg==
X-Gm-Message-State: AOAM532Qu3JC1MW+Ry8+Qho2eT0JeKKLUSuQbUdlhLRZ4JeeJVWJzb35
        CXzZVduzC1noWRMrovG2INmdOPpY6Lg4jfdk
X-Google-Smtp-Source: ABdhPJyslFVN/h3j7lPnX8Y5n3rmDBHS9yFktjb2ssGocIWS+q6ijM5W3ODVIt4GLW3dgtjli7InoA==
X-Received: by 2002:a17:902:d2c3:b0:13d:b9ae:d654 with SMTP id n3-20020a170902d2c300b0013db9aed654mr9267812plc.51.1632290926677;
        Tue, 21 Sep 2021 23:08:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e2sm737101pjk.42.2021.09.21.23.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 23:08:46 -0700 (PDT)
Message-ID: <614ac86e.1c69fb81.bad76.21bc@mx.google.com>
Date:   Tue, 21 Sep 2021 23:08:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.6-171-gc25893599ebc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 81 runs,
 2 regressions (v5.14.6-171-gc25893599ebc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 81 runs, 2 regressions (v5.14.6-171-gc2589=
3599ebc)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.6-171-gc25893599ebc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.6-171-gc25893599ebc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c25893599ebc571ecb26074f1338ac0c642078e4 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614a919bd410e2f4e499a317

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.6=
-171-gc25893599ebc/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.6=
-171-gc25893599ebc/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a919bd410e2f4e499a=
318
        new failure (last pass: v5.14.6-169-g2f7b80d27451) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614a9442f82ca088bb99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.6=
-171-gc25893599ebc/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.6=
-171-gc25893599ebc/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a9442f82ca088bb99a=
2dc
        new failure (last pass: v5.14.6-169-g2f7b80d27451) =

 =20
