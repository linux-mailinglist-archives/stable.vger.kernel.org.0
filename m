Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6E13183E2
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 04:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBKDP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 22:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhBKDPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 22:15:25 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A465C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 19:14:45 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id e9so2550806pjj.0
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 19:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CJCsG/F/ZtsrzHrlEvysukf0jF7jAMtYm9y4e9/x+dM=;
        b=bRoTyrlDEyhv5GuiZajVXMuL1Gh1kYkNGuuhobdteT3WJHcrnMSsui7dfxFJ7xX5T/
         Gw05AbNb+jmABmzaTix+RL3WwALQyACC+DW9iVjC2HGlRE4KcXfXvp8oBoaxyMYHCuF2
         577vqRCFM608/Bihau2vzXGHzeYBNirwPP3CrOIky6n1pSfZimrMvzR4DNIbXK4rIgYe
         clL1uqQECISSM5USwnCSoPk003f011Dcp0HMgpMyeeqYenNZENJL5T3i8IxQFpsvKsqN
         1QiI+uNZipBNEOb0Ax7ABj+HmX8Fft9Uejx2ukoziIWUuKCimaJZbg0b5btMTm0Mi03x
         zaoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CJCsG/F/ZtsrzHrlEvysukf0jF7jAMtYm9y4e9/x+dM=;
        b=i8f940Q3yx3FESM7baQLaX6PY1o9zchTIGdsxiQF2i1kmBQcm25B8laaqkf2Q0eCM3
         I93Me+TrtFL5SgyRx73gkZiPgg3LRUz2FT41WUESURDtriPOB+0M2Vw5IkRCkkIX1gOQ
         UWGU+Uq9wDCQx3IxrcIsiOXZ2RyYz/FB0NdSoTr5pQqinrPWOmWF/t24dYr0rdRoXyum
         HdKNhT1qdY/lGff7GMkil0VXxCV0eps+hjlcl4saNSD9/7Qr4my2J7A0mpsmkvuxREeN
         HjS5tbYKUAk+fVMiVz68QX+r5DgnqUxV1DKg1tEfzQFwyNqasjXgoc+9OqUhWNg+frah
         qDbQ==
X-Gm-Message-State: AOAM531EiuWZ72uYOx5fKZv1y5gRg8gJ7V9szzLNSUM900Zw7WnfKEgu
        VbXLGGiYQtUgTpRSeNpaNgTKDOORhTqbiA==
X-Google-Smtp-Source: ABdhPJzzrxok+ZwDvM8MYU6yyy5Yli8I+Fxqt9oDtOPvXScrZP0kcNLnoFvD2YxVR8bjvAKnzbgZCQ==
X-Received: by 2002:a17:902:be14:b029:e1:bec9:f4a7 with SMTP id r20-20020a170902be14b02900e1bec9f4a7mr6052621pls.21.1613013284309;
        Wed, 10 Feb 2021 19:14:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x64sm3634130pfc.46.2021.02.10.19.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 19:14:43 -0800 (PST)
Message-ID: <6024a123.1c69fb81.f3b15.954c@mx.google.com>
Date:   Wed, 10 Feb 2021 19:14:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 58 runs, 3 regressions (v4.14.221)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 58 runs, 3 regressions (v4.14.221)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.221/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.221
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29c52025152bab4c557d8174da58f1a4c8e70438 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/602470901bc2f79dd43abe8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602470901bc2f79dd43ab=
e8e
        failing since 316 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/60249a3b3fff1404873abed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60249a3b3fff1404873ab=
ed6
        new failure (last pass: v4.14.220-31-gc7c1196add208) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60246de84bba73d4023abe65

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60246de84bba73d=
4023abe6c
        failing since 3 days (last pass: v4.14.219-16-g9bdfeb6e50d8, first =
fail: v4.14.220)
        2 lines

    2021-02-10 23:36:04.867000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/102
    2021-02-10 23:36:04.876000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
