Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE247282789
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 02:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgJDAMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 20:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgJDAMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 20:12:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985ACC0613D0
        for <stable@vger.kernel.org>; Sat,  3 Oct 2020 17:12:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u3so3159380pjr.3
        for <stable@vger.kernel.org>; Sat, 03 Oct 2020 17:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lu9zf05Y0yzOLsc8V/dWJlWAPzTWMjuytIa6YxXlZrw=;
        b=I1TMCjIF0Zm0dS8BNcG+lEC+BApezti9CE0QjZuTh4EW9JLCuflYNcwdZi+V3NirN9
         cBnUoeoR2Eri1+9aVrAeiJ8M+2GBfgHLQCWyWn8xoCgZfa2SXNdjBlEpVcIMh96sswI1
         9d9mCJLksJU19unx7/dvKL8PUoj8eXDoMrTUAllaKe9JSZlerqxqP4nxlU2EIN8nUupI
         NNiavUxorRlrB5gUhjI0e4xunFAtF2HQoxnQ1xenumMeXpcA1OqueiipbrFFDiDTkHVv
         +YRF9PvJJEcCiGkwU8vxEBNFjy157XPXSrsx2f30d/hkvZjN0NrssfCmR6MI3wc+hlAn
         J5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lu9zf05Y0yzOLsc8V/dWJlWAPzTWMjuytIa6YxXlZrw=;
        b=PI673j9lwjklYH2eU89zPQELmKJZvJPxUL/lPu5DUyyv/odc+yEvs4TTYuc6eh1azC
         Unc+sa9Obszf6nuvkt7czCxO8fm4it2GrV5ryJkw5fBKGKd3A1LG2Z75yydcQQrbBP4X
         1n5QRokqx3w8cExT8fRcN7Fg+qwro4ciV6G0p5tN5TtZpbEwrzKbdrR/lDhyBLu+DPTu
         Ej1BcxD/xAV3Ap71G7Rje7wezMzyEJh/kww/FvetUrg7A6xDv36idB2MezI8hWs5soi4
         +4MlADv6MlzfNjPyKyjwhvDKoxQEFXFyWBm8OwI9nCbmikfdnjAqPLPCkyw1NvenCIzc
         ASXQ==
X-Gm-Message-State: AOAM533mCC8pC/OpeVbQseavIlj1w4pOssIFR6wPFAXZvyAvVlufPAha
        ntfrqpmWHLsjEIePfdWUlKcDQqK3aKtqPA==
X-Google-Smtp-Source: ABdhPJy0BR3N5qH3wT2V74WvLxkWfrdN39kSxkGZ0yoUqGKuyDSt56Oqb46dRcrzuEE2BY2s4Cb3GA==
X-Received: by 2002:a17:90a:a394:: with SMTP id x20mr9476724pjp.213.1601770344739;
        Sat, 03 Oct 2020 17:12:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b23sm2987185pji.10.2020.10.03.17.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 17:12:23 -0700 (PDT)
Message-ID: <5f791367.1c69fb81.3b8e7.576d@mx.google.com>
Date:   Sat, 03 Oct 2020 17:12:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-2-g6653697ce929
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 95 runs,
 1 regressions (v4.9.238-2-g6653697ce929)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 95 runs, 1 regressions (v4.9.238-2-g6653697ce=
929)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 2/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.238-2-g6653697ce929/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.238-2-g6653697ce929
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6653697ce929d662248e4524e158321cb2d987c5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 2/4    =


  Details:     https://kernelci.org/test/plan/id/5f78d9a66e59aae2104ff3e0

  Results:     2 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-2=
-g6653697ce929/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-2=
-g6653697ce929/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f78d9a66e59aae=
2104ff3e6
      failing since 0 day (last pass: v4.9.238-4-ge285c292897c, first fail:=
 v4.9.238-2-ga41cdac0290c)
      2 lines

    2020-10-03 20:05:54.108000  <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert =
RESULT=3D[   20.471191] usbcore: registered new interface driver smsc95xx
    2020-10-03 20:05:54.112000  pass UNITS=3Dlines MEASUREMENT=3D0>
    2020-10-03 20:05:54.150000  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2020-10-03 20:05:54.159000  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
234 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
