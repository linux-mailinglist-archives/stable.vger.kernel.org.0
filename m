Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10273966A5
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 19:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhEaRPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 13:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbhEaRN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 13:13:58 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7142C0611E4
        for <stable@vger.kernel.org>; Mon, 31 May 2021 08:24:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ot16so6770789pjb.3
        for <stable@vger.kernel.org>; Mon, 31 May 2021 08:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PI9A/nkFYDFaGpWPLtF/0Y5zz0fYuNrewUAb5In0/B4=;
        b=ZltN3M10zz1B0NX4urbeJ4q2tF4MTVkF+2vYV0DM0FdXKgdEUujSosp/UTJY65AZpl
         Zv9QnsInbwODTc42xzAuAlFMN+g4Ca1xUymCkdP7xR5wKEHKt1ugV7DwdfodfgUuPx13
         pM1r9PqAE64Ig4NJ5xNmu6vTnDX2IT5yhVUqTaX1qi8TsfNmqBi7szEz4rsqgdMW68Y6
         cr6Pc8JekKe/ZN7LXGQu1msrOxh8LJ6ee9jdzQognnMxvi7a5Opfb12SDCCKI6KkOQ5w
         8Q8Mip9tLB2mQ/4NgIf7RoKigSs4srw4B2w+PsPW/Z9ZHZfaJDN8fJqbx9qXJVMx5NMR
         RVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PI9A/nkFYDFaGpWPLtF/0Y5zz0fYuNrewUAb5In0/B4=;
        b=CQATefAejGVTBisHhtsGMmNLkw45xLU9cfUc7uU+BvFhbvnO8Wfa5FEnQru/t4+UAd
         Aw7nNO3nmUayrzeDq+2TLvJ80BCC0D/v+Rr4sKbJA8v320qs0Yca37ocQHk77+FNFGnN
         j6Hl+h/7KS7GHpOZWMyzC3Dy2MkChqTXr8gqwt8w0D56yWlVnxPoirwHdYutUAG1mHUZ
         sNLJKa6dVewrdm9KmS7Far4MmrVSDJz5wncmqS18xP9xxuPQKHaNLEeflci6sAT62Elq
         7fJNYzOZenI/KKV3BrfQCrqPSB+44o52uSuCoWP5IuqLLnNoRyh71nUYAJAYb9Tau5tT
         JVRA==
X-Gm-Message-State: AOAM53277uP46VBSg8WXCIDjDV2FhjcqRDyRROpk5LpEz6Ztzi9vQkAK
        d1e2hJVVg8bFSFc3XszTxY5t7597qGKTx+kI
X-Google-Smtp-Source: ABdhPJw8q0rak1K3jJsbCtj0lbdTHXzeLqfE/q4XTzG2gpzYpxeRdvHj9t/6SN70pfDyI6Vd1RGaZg==
X-Received: by 2002:a17:902:ea11:b029:105:3a88:5c5d with SMTP id s17-20020a170902ea11b02901053a885c5dmr4628229plg.56.1622474669081;
        Mon, 31 May 2021 08:24:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t20sm8438330pjs.11.2021.05.31.08.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 08:24:28 -0700 (PDT)
Message-ID: <60b4ffac.1c69fb81.dfbf3.82f3@mx.google.com>
Date:   Mon, 31 May 2021 08:24:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-117-gd2af6de74b0f
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 129 runs,
 4 regressions (v4.19.192-117-gd2af6de74b0f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 129 runs, 4 regressions (v4.19.192-117-gd2af=
6de74b0f)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.192-117-gd2af6de74b0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.192-117-gd2af6de74b0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d2af6de74b0f761d332679106c8e94a0367bb718 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4c4fb47f7675b7eb3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-117-gd2af6de74b0f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-117-gd2af6de74b0f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4c4fb47f7675b7eb3a=
f98
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4c50563fe29d459b3afae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-117-gd2af6de74b0f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-117-gd2af6de74b0f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4c50563fe29d459b3a=
faf
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4c4d222b8c342f7b3afb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-117-gd2af6de74b0f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-117-gd2af6de74b0f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4c4d222b8c342f7b3a=
fba
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4c49c8624c88043b3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-117-gd2af6de74b0f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-117-gd2af6de74b0f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4c49c8624c88043b3a=
fb0
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
