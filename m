Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3493E2D37
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 17:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243246AbhHFPJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 11:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242756AbhHFPJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 11:09:03 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258DCC0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 08:08:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mt6so17113934pjb.1
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 08:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zs4mg0cKgPN4TCbExFF18o0Rgx1JmBOF/ooBFDupHII=;
        b=JljxlQ1o1u6vsqcVVlSDDFi2JccVXWtl8Dw83dZkH47jD6rhtZFj+5B3KmwGxqwO9Z
         hrBvbH1lvgcgYOpicSjAqE5hDOBE6NpfER5J6FST92ESgjnD7qXc7XXMGf37a/23ZNtT
         0HdkGLQo4XW/I11XgXcYl2jQgGQwAYYyAd7TUf3sOIcMjfDrgWSvSR3unrSiXEYGnZjO
         /KhYvTCBX/KZu4DJXwlym02+t3KAjr67mGB+dLgoQkTd++Xep+PgO0jy9B6VpP/CbNn6
         Rt/ZK9KO07IlsilYeyMOwh0bgirvYxikki+RAyUROE8Rz3RDBf31yj1+B7Ix3bP3Lbbv
         Vr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zs4mg0cKgPN4TCbExFF18o0Rgx1JmBOF/ooBFDupHII=;
        b=H2YvAxpFIcqJDIiBXx/smVlZU9iqoyqZ5FtbH0o+zAaHtCMzLE+kGojqtcgVIrjWXn
         ULK9Ys8S3PDNDuW0dQa5GAAtj1MnSqfbJCCXUgAIiPZde7ZBo8Uep2OJmqkxDhMyCSfm
         xGJ2zYeu4wlzLQc/kNTh8+aW6kIjGc2jnkGHUpkMBcFtuAKqvudW8mdPcM+U8Or32yp4
         xPjBlI+UZqtrXnlL7dpySKxU/uI6mskHjt9xM2lC5RSav0DtwI4sZ6Mc1HWmQSst1QE+
         hvNF6Lv+wb4IEoaA4J66K5JFHI64v02GFfeU5Ly+pvLdD2SJ71xHIyNBwqIeulieyNLy
         l+ng==
X-Gm-Message-State: AOAM533UonxKww7zJ606yQfUGfKTCmDoZJzSKPtw4/ECTrkYFXu5+4Kr
        Wiaw9E8ERHvPXRqyjDufzX0SZizrca0woA==
X-Google-Smtp-Source: ABdhPJy1vTSfUK4j+GBmWsJUK9DifXBB9ov3AwW7/NbH52Eud3czrgTfvw48VJNPj8jfrTZ+w8v77w==
X-Received: by 2002:a63:556:: with SMTP id 83mr223170pgf.1.1628262527420;
        Fri, 06 Aug 2021 08:08:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 16sm10878267pfu.109.2021.08.06.08.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 08:08:47 -0700 (PDT)
Message-ID: <610d507f.1c69fb81.bc93f.ff7e@mx.google.com>
Date:   Fri, 06 Aug 2021 08:08:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.8-35-ge21c26fae3e0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 118 runs,
 3 regressions (v5.13.8-35-ge21c26fae3e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 118 runs, 3 regressions (v5.13.8-35-ge21c26f=
ae3e0)

Regressions Summary
-------------------

platform          | arch  | lab          | compiler | defconfig           |=
 regressions
------------------+-------+--------------+----------+---------------------+=
------------
beagle-xm         | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =

imx6ull-14x14-evk | arm   | lab-nxp      | gcc-8    | multi_v7_defconfig  |=
 1          =

imx8mp-evk        | arm64 | lab-nxp      | gcc-8    | defconfig           |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.8-35-ge21c26fae3e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.8-35-ge21c26fae3e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e21c26fae3e0509fe44d5088f1992193573e6f63 =



Test Regressions
---------------- =



platform          | arch  | lab          | compiler | defconfig           |=
 regressions
------------------+-------+--------------+----------+---------------------+=
------------
beagle-xm         | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610d17fc803a0dfb3eb13686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-ge21c26fae3e0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-ge21c26fae3e0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d17fc803a0dfb3eb13=
687
        failing since 8 days (last pass: v5.13.5-224-g078d5e3a85db, first f=
ail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform          | arch  | lab          | compiler | defconfig           |=
 regressions
------------------+-------+--------------+----------+---------------------+=
------------
imx6ull-14x14-evk | arm   | lab-nxp      | gcc-8    | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610d276fa90eeb886bb13679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-ge21c26fae3e0/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x14=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-ge21c26fae3e0/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x14=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d276fa90eeb886bb13=
67a
        new failure (last pass: v5.13.8-33-g3fddce574f66) =

 =



platform          | arch  | lab          | compiler | defconfig           |=
 regressions
------------------+-------+--------------+----------+---------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp      | gcc-8    | defconfig           |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610d20169c8d01926ab136a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-ge21c26fae3e0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
5-ge21c26fae3e0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d20169c8d01926ab13=
6a4
        new failure (last pass: v5.13.8-33-gd8a5aa498511) =

 =20
