Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6D74005E2
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 21:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhICTgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 15:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhICTgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 15:36:21 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC9EC061757
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 12:35:21 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id w8so81288pgf.5
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 12:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6K4nJVPDXdliPER7L1Aoeu1FJ4W3ySTmNXN/2lgU9tg=;
        b=Ko/gijLYzYeKeiKULkFL3YP0HU+9b2C4YhuEcKXCM7VrgLaULRSJdTpOTnXnqhRSXb
         t1eETjIiWWSyiOz7afcgifoaOGx3LwP0YP9nz57PTJ+Lv1RPbsExMkQtnQBRAktLIv4H
         mzAPZBf0xPFzDRUzCgoHM09jiuWC7+UYiEH3YIfrn7uIOMmkbJFubiechA8PHhjpi2pF
         taQ5YWHFkD+yRuZP5LCuKX05C/fTgVW9cg6rXRqgSR/dUt/ax54JL9W6v87AVu3jUT4n
         Ii+purB0qr01Fc9bqcHGcqMsmeBXUSzEH+FT8GmbwrylP2vE27rrVtyVuNepC1PSW+Nr
         MIDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6K4nJVPDXdliPER7L1Aoeu1FJ4W3ySTmNXN/2lgU9tg=;
        b=gyRU01VFSV/R0fzY7ePfkUbAhCspc6kLWadrZc7EoGdlUa9ygohZEh6EztF0RLHY0H
         tYHfyCSHGGPIF9SHSqWX73jehpczTJ48CdrEpdY3CRGf6ke01kd66mry8A8HKymhMZYU
         oERCClB2fT8hdgQ6WnNFoZ3FPCv1dP8W6FYJog6n3mxxjq//mM8Udi9wgSsdfTzPJL9Y
         MblxP7vZsVc0ANrKRlG6LGmQiV/GH0BnVAcqV667LR+nQQlLwRQL1QeUvnWyrwqlrDcn
         aO+Yxd/M5pQ9D++8fOB91i4ktKDyRKhnd83aen+V0Vd73j3PHJqhYBzkUmrNw8oiEAmS
         7eyw==
X-Gm-Message-State: AOAM533uHAMfrQaLz63Ch0C4Vq99H6aLRtYqPUGYPxLGj3qAqB5/eArj
        ncjW0j0XhTd5btuT6OQktggtGGpOBvF56Ac9
X-Google-Smtp-Source: ABdhPJwYPsRItyYv14RwQTlGTc5epbv1/zOUVqPdzIB0Mq5Ul46Cts7yIUILxMmR5MJ2FVWRMkSOUQ==
X-Received: by 2002:a63:ed17:: with SMTP id d23mr549618pgi.29.1630697720708;
        Fri, 03 Sep 2021 12:35:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm176342pfk.87.2021.09.03.12.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 12:35:20 -0700 (PDT)
Message-ID: <613278f8.1c69fb81.80831.0de4@mx.google.com>
Date:   Fri, 03 Sep 2021 12:35:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.1-2-gd77b951d0670
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 179 runs,
 1 regressions (v5.14.1-2-gd77b951d0670)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 179 runs, 1 regressions (v5.14.1-2-gd77b951d=
0670)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.1-2-gd77b951d0670/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.1-2-gd77b951d0670
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d77b951d067059ddd98a338d25142c741ff846cc =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613247e39bc2e93aa1d59674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-2=
-gd77b951d0670/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-2=
-gd77b951d0670/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613247e39bc2e93aa1d59=
675
        new failure (last pass: v5.14-11-gedf67340fd41) =

 =20
