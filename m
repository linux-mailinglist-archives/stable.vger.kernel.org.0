Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2835499A78
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573064AbiAXVoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454656AbiAXVdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:19 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A40C07597D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:21:31 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so259094pjb.3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vJiOsW6SYE89zyhK9CDB7xFkCAWFcy2UBYeX3SQJE/s=;
        b=HyDAS31qrXyauLHUJ8DZfxTcQ6VgzkOAefpAW3x3cYMKF1SMhd+d2rCKhLxirzhMKh
         qb/yPcY10RXkPObGsH9ZDJYukSoP+/XeIkJ+Ua7YOhS5/beIyCnrfZgfa3pMxdNdpNst
         swGlJueXB49tDgMoEWv92Z8A029nKI8Tw7i/9LQG04hkUa0hsKv4AYdmCf6d0SrjBmQ6
         alglAIP33YQSLV9JfuVAzGgc09aiK+QBg/R3A7Tl8KYGhhzHzm7rHpgJ8meRyo3mQfCb
         n4PcWgZfN3VgwkrqLg+mVLclwxkjc+0KyylK2MC9dSQy917dgnEQipTCwKdzwf9hh7jy
         nNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vJiOsW6SYE89zyhK9CDB7xFkCAWFcy2UBYeX3SQJE/s=;
        b=vZle/XTqmqiMu1VYctKbW0LkTQu28R2+bbPEhSCk7WVgHq/Whw+6oxuhmpqmhQXnYL
         x/k3iYpPxjLvl1Fx697SN/HeAQjwUjNehYUBS8Zd7tmxjBy/VUMd8d3jHTlz1PJGWXcZ
         xweGccQRj22gxK089Kwh7Wj5xCmOAo8vPC+HvKe1IVMvrxhnHgWdlBgT6ws8szmTPS9j
         YxStQnnuCfayduVP+Ct2oxoj1wAbGZ9iOVUu3IgNgfeyZLGFstogv31BAKZtus6YsGSX
         26PDURS/wtD6UTf2IZtQ8EPSy772QxPNq3U56CT8eQG+xZvU4UWTm4D/a0x6EwRjWF0L
         IzLQ==
X-Gm-Message-State: AOAM531N19ziKMFh49U9M2xuZsMkRX6aFJR9wfHu1gP9UGZUYxI4GXsS
        NZBkJh29gaPO3LSIOS83/1EXbnwsxpf3UUrP
X-Google-Smtp-Source: ABdhPJxaYiLNoK80uXf54PIgcr2gvFLvsZ6B8cUEZqfLtnGnzy+kuDp/BzXujcJaC4jFFmY/0AHsdA==
X-Received: by 2002:a17:90b:1806:: with SMTP id lw6mr36408pjb.82.1643055690533;
        Mon, 24 Jan 2022 12:21:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nu15sm207767pjb.5.2022.01.24.12.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:21:30 -0800 (PST)
Message-ID: <61ef0a4a.1c69fb81.b45a7.0e2f@mx.google.com>
Date:   Mon, 24 Jan 2022 12:21:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-115-g214b7b038f18
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 150 runs,
 1 regressions (v4.4.299-115-g214b7b038f18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 150 runs, 1 regressions (v4.4.299-115-g214b=
7b038f18)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig      | regressions
----------+------+---------+----------+----------------+------------
qemu_i386 | i386 | lab-cip | gcc-10   | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.299-115-g214b7b038f18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.299-115-g214b7b038f18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      214b7b038f18f11e9e1a9fcb8911070b867fec64 =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig      | regressions
----------+------+---------+----------+----------------+------------
qemu_i386 | i386 | lab-cip | gcc-10   | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eed7c7f60ed0fb1aabbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-115-g214b7b038f18/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-115-g214b7b038f18/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eed7c7f60ed0fb1aabb=
d12
        failing since 3 days (last pass: v4.4.299-10-g5f58931b34ba, first f=
ail: v4.4.299) =

 =20
