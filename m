Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3683C2A2B
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 22:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhGIUNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 16:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhGIUNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 16:13:44 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27A5C0613DD
        for <stable@vger.kernel.org>; Fri,  9 Jul 2021 13:11:00 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o201so4683473pfd.1
        for <stable@vger.kernel.org>; Fri, 09 Jul 2021 13:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/Y9KPk9RXMpJfDngVZBexC9N57bL12fYZli23afUWxc=;
        b=ZDemEmPSpo2cs5A4vQ1kk5ddoU2GeRqEEL0eHs5EeOW6n4/QQt7jiX5EfjbRp+mj79
         d88XuH003xHhRZFPkbGoTVI4cexN+my3mKcj7MKgvNZ0WJMZsQRcnrNrUQaCR9RZOcly
         ooeoZu12rtHjEznz/7jYfFUtkT+sp1VnuUmRZB7CIYeFWdQAF9ypauqAvJxuGZ/I7yim
         ZhGCNIQljLUiHWWy7hVbngmhDvAciRw8xnI4eP8ht7aqj5lhMdilkjBsFmLoR/2/Npbd
         7hsPnKg5gK96G6cCmipmLpjk0ClogelWgOQXqMzfxl/MDDesr9culVMu6UT59BQ+zQMG
         xr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/Y9KPk9RXMpJfDngVZBexC9N57bL12fYZli23afUWxc=;
        b=rcJimY4LRjbpjQIT3INTlc7n4hxGMMBDjzDwtYa7Z8lKj+qfwJzPLyIgYLDOK8Iqkb
         58yNbGhK4M9cYTJ4zSIJIfEdDjBlentce3mnYng/wUXjUyCkWOHD7cXBBAaovstfWLmx
         pRSmC5lDsIL6SCnT6Tc/hBD5b4jWael2Aue1zYF3qi88ig3DZkyyzHL9MeamOOiRFbvi
         +Dw9WKzsgFidzUjlnKY5P91X/nWMM47xu0OTAAFqOrf48wPZwszi3khhu6dU/4IbNJTX
         g90yjYeSRl5eXuS0EFGD6sH90tFA4XzImEaj1Z5p0hIs8bDPCfjfWJ+RHMykw1GR+20b
         wC3Q==
X-Gm-Message-State: AOAM531RMACyQBTC3BPNfn5VT4IXIgEKAY9vGSHmLUenJs+FmYqMZAJn
        4tg/GyoWI/fF8PE1izB7eYasrMP3bTwulC1f
X-Google-Smtp-Source: ABdhPJzFdtohtnxofW36TuwckxeSjFFeJ97v63SZ5DTl4G3DBE8Rz66FUyjfXY/L7aJ3GIFRnI/07w==
X-Received: by 2002:a63:a545:: with SMTP id r5mr4471324pgu.204.1625861460097;
        Fri, 09 Jul 2021 13:11:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a65sm7814045pfa.11.2021.07.09.13.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:10:59 -0700 (PDT)
Message-ID: <60e8ad53.1c69fb81.5bc82.7412@mx.google.com>
Date:   Fri, 09 Jul 2021 13:10:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.238-25-g9c581bc5c560
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 127 runs,
 2 regressions (v4.14.238-25-g9c581bc5c560)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 127 runs, 2 regressions (v4.14.238-25-g9c581=
bc5c560)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
meson-gxm-q200   | arm64  | lab-baylibre | gcc-8    | defconfig        | 1 =
         =

qemu_x86_64-uefi | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.238-25-g9c581bc5c560/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.238-25-g9c581bc5c560
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9c581bc5c560a2ba098dd8d2bc9bf58b82b93783 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
meson-gxm-q200   | arm64  | lab-baylibre | gcc-8    | defconfig        | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60e87dc49c72827c0a117a5f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-g9c581bc5c560/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-g9c581bc5c560/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e87dc49c72827c0a117=
a60
        failing since 130 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60e87bb6c4381e0f5c117984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-g9c581bc5c560/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-g9c581bc5c560/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e87bb6c4381e0f5c117=
985
        failing since 0 day (last pass: v4.14.238-21-g49bfe4ee578d0, first =
fail: v4.14.238-25-gc68d366ca9ae) =

 =20
