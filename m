Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43431ADCC
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 20:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBMTlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 14:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBMTls (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 14:41:48 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DEEC061574
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 11:41:08 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id z6so1739354pfq.0
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 11:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SqlgnUP08ZC6b3W6uwpKB9Oc8moyIEK4kdbNWishwlo=;
        b=LMzjbY3DpX70vKkdXDUEnHFgU++CTWUgSs2Y5u/iDqMXehKOyO6i+KriaBtZ4cvXlO
         PR+JGUom0JK/TARuq4StNkZzbPGGUyVt/C7lPAFnppwQWro5SIPO2lUqPJSpKiayOIOs
         HsUQPswClgNSvQIjBI/uyI74M2UefdHhxWjvlJkIV/ZZeCjmIYJMfv7Hdk/muDzbV1Ap
         CoH3H1qF3GG5FT/1k125qr4Xdy7sbviShQatb15CWnlKVOFhk+5fHw4VcpFzf+ZtRpji
         l5UE/qEyN3bEMv7ohQrrHydIM0Fs5MmBmDQRJKIzal536lIIAqZH1jEjg2mNZxCSHjo3
         sFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SqlgnUP08ZC6b3W6uwpKB9Oc8moyIEK4kdbNWishwlo=;
        b=blydf4g436NfT6mIUfHZrIJ1J5FILEcQ6jSQXVbX8iCTktIJ2OW4gdPl3SUgJ8hMUk
         +kGHHd8fZ7X9JfLdwiPUTlWzR4SrTAMpilRWoddFgB17MUJO6fVoizY1JE5kwFMmA7iG
         y8rGG5e/lA+qtCEH+Hgjg6SW6MSI+C9YL83oG1Ql6ePXTc/wQvUITXcG7+EbwFZ4qRqy
         zL8cGyKWMs5qqKE/4oXYo3DxT2bxGGOWCEFyGfWfdg/fYSftPUyw9D2iGesw6CJM5n8l
         S+iVHC9h5kta2zUkeaIqSUtsyp+8V4QP7HbD5kgyfZ56m08lK7l9076hQ3P17ZJxfXX7
         DyHw==
X-Gm-Message-State: AOAM533QZIqIgQPsE7tzPYKtyxyzBnnu54CXnrwTKBq3OPa8cv7GzMyI
        Wf/wvG5WslTl4xFf0tbU2QKMq7YMm4LO2g==
X-Google-Smtp-Source: ABdhPJwQpSGOLKLA8mMyP6dnNyXgnfuw6+sBPhg0gFFypHFN/Uddzmgv2y6BSji0oH4Zre2+P0uMrw==
X-Received: by 2002:a63:38c:: with SMTP id 134mr8557875pgd.302.1613245267358;
        Sat, 13 Feb 2021 11:41:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q15sm11622359pfk.181.2021.02.13.11.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 11:41:06 -0800 (PST)
Message-ID: <60282b52.1c69fb81.67df5.9c2c@mx.google.com>
Date:   Sat, 13 Feb 2021 11:41:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.257-12-g0688ff644ea1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 27 runs,
 1 regressions (v4.4.257-12-g0688ff644ea1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 27 runs, 1 regressions (v4.4.257-12-g0688ff64=
4ea1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.257-12-g0688ff644ea1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.257-12-g0688ff644ea1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0688ff644ea1f10d95a9a56bad76f7a3575959b2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6027f94f6e82e4e5363abe7e

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-1=
2-g0688ff644ea1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-1=
2-g0688ff644ea1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6027f94f6e82e4e=
5363abe85
        failing since 7 days (last pass: v4.4.255-14-ge5269953cc26, first f=
ail: v4.4.256-14-g2d58dd4004a4)
        2 lines

    2021-02-13 16:07:39.926000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
