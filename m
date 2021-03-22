Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DC23438D1
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 06:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCVFxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 01:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhCVFw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 01:52:57 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D98EC061574
        for <stable@vger.kernel.org>; Sun, 21 Mar 2021 22:52:57 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t18so7786220pjs.3
        for <stable@vger.kernel.org>; Sun, 21 Mar 2021 22:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HSYvCDZMv4duChCbl4tWmR68CinAyKoWZnTrJ/JOw04=;
        b=o9S9iP4gwzPGVlGNDjlUJM+oTHsoMP6YkVSm3/5ickGJfluJQ/2Fl8+uUv2exsQgWi
         scOm9V2ZGkBHMHOf+bPKxeAoq+ryMZq9qfSTm/a2ZZbIm4D978QUvEQFoZKoFGyHT7y+
         M9ivGJoJY+NqlGeFekFovewXnKoOt1RBqJe9Mdanm1YwMqlOR+tbwl89cNLNMjhwMY2m
         cvkt4poV9ZXglV3eAzw3rttQWKaOQQcNbiaRvWdvlj39Dad6Zoy97CDmJzhPw7yaoKoM
         TdaTPPVXAvga8E/XyCfW36HcVE/0oQR0kSE7n+7ZwXhn0LHpYtswaOwuWlnJCE9CZr6t
         e8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HSYvCDZMv4duChCbl4tWmR68CinAyKoWZnTrJ/JOw04=;
        b=IljkPJafXLgySJ4A2Ti/kobODDBqD7GM04YFurae6i7JVPF3oyR5OJJvhp5LqwILIQ
         atJLYCg7QbSFeWJBLrnP7G9ArXF3JZYiYnoOWZJJQNxgwQBKimIFw1yM1QdoLeSSzkLy
         1weR6kVPFUZiKgGTcz4XQwTukJ/1iaLhVDP4KygIdilDGhRjQ9ivvUUW4zXSmaibgWyu
         Cd9XSHfo8baeq5hnBGaEZZTl8bIoo52pYj3lwiOXIoym51Ju3HijfOjoSxZXg/CGYsyA
         H47M06hQpUaXls1qAHHZemSFiu49lsA7VlxN8m3MfM8qJNFhaoZbbLI6Y0c6M3uVfqrR
         fZOA==
X-Gm-Message-State: AOAM5303bt7rz8QvqYxbEf9657b7J6STXj+e21zz+V7QPAclFnSQau4o
        T6vFp6lHUyKmTeiFq5YhLdiHw+OL13G1HQ==
X-Google-Smtp-Source: ABdhPJz9Wsa6js3PGofQHOT7Q9SGbFNJngWHsGHKMBXdqkoK1N4N+cZt8giQbTbxLD5TOXGKVjSNWQ==
X-Received: by 2002:a17:90a:f2d2:: with SMTP id gt18mr11555617pjb.210.1616392376469;
        Sun, 21 Mar 2021 22:52:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i8sm12411246pjl.32.2021.03.21.22.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 22:52:56 -0700 (PDT)
Message-ID: <605830b8.1c69fb81.58b93.e749@mx.google.com>
Date:   Sun, 21 Mar 2021 22:52:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.25-59-g387026133273
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 190 runs,
 1 regressions (v5.10.25-59-g387026133273)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 190 runs, 1 regressions (v5.10.25-59-g387026=
133273)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s805x-p241 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.25-59-g387026133273/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.25-59-g387026133273
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3870261332731c57ba6d7cc76a678bbb33c757c4 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s805x-p241 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60580141eb76f0a0adaddcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
59-g387026133273/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-p241.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
59-g387026133273/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-p241.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60580141eb76f0a0adadd=
cbc
        new failure (last pass: v5.10.24-13-ge91220a40f8da) =

 =20
