Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9912631B7B4
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 11:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBOK7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 05:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhBOK7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 05:59:16 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F6EC061756
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 02:58:36 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z9so3678949pjl.5
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 02:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5eEXob/BguKffEzoc+vln1Zv1S0DuYGQLp5kj5Y5B6o=;
        b=TmBRxN8V0q5O1x3G1UwPUSGZygoztNi5fBtiF3/GeDp//UKRAUWgMre4OrJRekhDu0
         ieYc75Tn5fOoafFc5A7D6ZsRKdrT73F2eWSnzuDGUX6LqQY0XkwBapUtgiWdpmnRQa/V
         CgZRmDmRmBOJTpTkNWEuDq8N/VvtlYVd6613xCyrotc+JTfs7gEmVK4BTj1VarGzSURJ
         4RwbdqMUwWNF1tUxfG7k3YDgADnFWjSukTD74XybmFgr6riNg3D0m4V31RClD2vqX150
         bYmDszhbvxM0xyM4IztzQV/ZG8/jAtmDTkpp8Yoxv0I5UZEIjXQ+QYduvPiKkeKAQ0an
         eedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5eEXob/BguKffEzoc+vln1Zv1S0DuYGQLp5kj5Y5B6o=;
        b=HKW0qLCkHgOYv5VsM5UhFCcf2770FgF7NxTCPPaWDVgx7KpWH3wZOvLbODAd6nVFmc
         7ZBaAX1yry6hAtEjAYyAGgHB3cGB6qGm85liHNOA6DeOJxKMG61Z6l0wuzMwEz6vejqw
         ZRPHuBc34E5C18DvA2mG5yrUwueH9tZ3ozKf7lr6howtIKVSg2bf1woIqakgq6ppvm60
         +kmYXQab7CquuLQx4WyjsdUWbLA/mbqEBtV5RMKR3MFkC2qfOMpM46e6fkAE0jiqlcDo
         9Yta7cFXACAIBtO17q4QSgMv7f6MAYgMT7zt69NQfpfVUNXoxShCayTp+YGFEpymA/Tu
         l+RA==
X-Gm-Message-State: AOAM531N8laDztqpFmM1/8NtuPGsmoGiotqUzUmnYaHZh3mCJNF5T8oF
        WdMIYCvkWzNZJvdNiooIjhc+qRXz+2lkxQ==
X-Google-Smtp-Source: ABdhPJzHyCw+H44/VagxaLpLdEE6vqz6XjYOTFM5ksvIsLHc63J8vcp1rqHnaQ5kH1wj9OAsMi9d/Q==
X-Received: by 2002:a17:90a:6901:: with SMTP id r1mr4725786pjj.131.1613386716006;
        Mon, 15 Feb 2021 02:58:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13sm18872904pfc.198.2021.02.15.02.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 02:58:35 -0800 (PST)
Message-ID: <602a53db.1c69fb81.7c733.731c@mx.google.com>
Date:   Mon, 15 Feb 2021 02:58:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-34-g899619a3e3e7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 61 runs,
 2 regressions (v4.14.221-34-g899619a3e3e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 61 runs, 2 regressions (v4.14.221-34-g899619=
a3e3e7)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-34-g899619a3e3e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-34-g899619a3e3e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      899619a3e3e7bec64c51046891b274599260be38 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/602a1d5a2d85f763c53abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-34-g899619a3e3e7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-34-g899619a3e3e7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602a1d5b2d85f763c53ab=
e63
        failing since 68 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/602a1bde67da8526fd3abeb1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-34-g899619a3e3e7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-34-g899619a3e3e7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602a1bde67da852=
6fd3abeb8
        failing since 8 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-15 06:59:38.500000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-15 06:59:38.516000+00:00  [   20.568206] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
