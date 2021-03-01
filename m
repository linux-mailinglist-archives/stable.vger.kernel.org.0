Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BA232814E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhCAOt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbhCAOts (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 09:49:48 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C79C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 06:49:08 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i10so2495129pfk.4
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 06:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q4cX+fVk6x952nEWYZZdJy/0WM3VoXq318fAY16rfBk=;
        b=S0mAE6XHxC7t5Qd+0gP7JxwzA3e9qsG/KK/m3tsrPo63GpaI7uxfEAoxGFVRQV8szT
         XNCKcZK3StWmX7qhZsp8pSOknORQeI3PcoQK2i5E/5SKKsAmHZkz1sIzMVOll5GkjopO
         SL7FgXJX4lshs2CMODYH0b6GYzkvWsqBZs/dWucQnrVoBFplejsPTTAKVcsCBmNmFBFz
         5bdeUl/RrO7NmJFe+zSisi513zR9QmcHakdnD0w1Tlm7Uw4Nsy99GbdDyigj7t4cIP38
         e4zfnHO2+zJda/hyK5KXSFtLNxhTlTEiGT032z1fbPo92QtWmArKxmDtaY5sUYK4OekC
         xgVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q4cX+fVk6x952nEWYZZdJy/0WM3VoXq318fAY16rfBk=;
        b=dRdp1MG0hytLNxkFQ4vGxtBc6QkkqaipaNrA9IQwFuneikJR79cUsnDAPIb6XxruhG
         tcNFovf4Bt6PCVfiaaUEJ4FrWoLuzJW0gTy0Br7gbtWscgwSlo5Vck3owYYFllNUGty8
         Kep+KeQaCSwG/x7JCKhECFU5qniJFU2+O6hVoMNJ7TClOgeQNN9YVa2bGvCeCiT/4k6L
         QPXRlef0ti+a+mQpz92+jy2o7UsR5qlbQAZpm9GIwL3XN5bbqM2QaQtX2M6ZihpXYRi3
         PXcmUZov/V8t02LoOiShNKCPm4ph0R8SOlCStpTk+WTD14OQaXppJpGw2oFXwzkcensF
         qp/g==
X-Gm-Message-State: AOAM533Ar/nikXmSop71pn25vFM0D3aHmTVUyAbEky9ACEmZDlk6nOk7
        i27Eir+cMaxceX7qj8KnITjQo9v/XvGlhA==
X-Google-Smtp-Source: ABdhPJwf9ujEAe8MY3UZLgTsx1Gl2CPmiBP/BPHXix+lS/0Es4ERyN9a2/md6DTT0XcH9YU9nNxDYQ==
X-Received: by 2002:a05:6a00:1707:b029:1cc:2d49:9f29 with SMTP id h7-20020a056a001707b02901cc2d499f29mr15225591pfc.8.1614610148073;
        Mon, 01 Mar 2021 06:49:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10sm18398843pjr.27.2021.03.01.06.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 06:49:07 -0800 (PST)
Message-ID: <603cfee3.1c69fb81.90bb8.9d65@mx.google.com>
Date:   Mon, 01 Mar 2021 06:49:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-120-g84565b77654cf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 67 runs,
 3 regressions (v4.14.222-120-g84565b77654cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 67 runs, 3 regressions (v4.14.222-120-g84565=
b77654cf)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =

meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-120-g84565b77654cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-120-g84565b77654cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84565b77654cf7454d9f80b1dfbcde61af16f681 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/603cd147a8518bd8ecaddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-g84565b77654cf/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-g84565b77654cf/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603cd147a8518bd8ecadd=
cc7
        failing since 0 day (last pass: v4.14.222-120-gdc8887cba23e, first =
fail: v4.14.222-120-gdc8887cba23e2) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/603cd5586d38b0e962addce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-g84565b77654cf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-g84565b77654cf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603cd5586d38b0e962add=
ce3
        failing since 0 day (last pass: v4.14.222-11-g13b8482a0f700, first =
fail: v4.14.222-120-gdc8887cba23e) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/603ccafa1f127e17c1addcc8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-g84565b77654cf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-g84565b77654cf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603ccafa1f127e1=
7c1addccd
        failing since 0 day (last pass: v4.14.222-11-g13b8482a0f700, first =
fail: v4.14.222-120-gdc8887cba23e)
        2 lines

    2021-03-01 11:07:34.477000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
