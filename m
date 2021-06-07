Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CA839D2B6
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 03:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhFGBts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 21:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhFGBtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 21:49:47 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EFBC061766
        for <stable@vger.kernel.org>; Sun,  6 Jun 2021 18:47:57 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 69so7757584plc.5
        for <stable@vger.kernel.org>; Sun, 06 Jun 2021 18:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C44DPqfupkcBF4fN34DuNv7QrYGLUZe9sTKtGA4M/4Y=;
        b=lmhFwoJX+jwshS54lgY5WWPYFR7vM50foNugXynAOaXxRpgVBUiUbCy1du8LZfVfQT
         HQdR0u7tvITQdfMzun96V/XMcelqSPu9gmNEqP1VDey+kLuGK22HJLnepSt5xiK8tJg8
         tCSYrFCfnZ2qxlwKWLUFBniCZ+OOyMEuAFs+hHIvODbw+6uy4IFH7RpPX+ydzxVOA806
         pYCsAnyTF/noLYuEx6KhsPY3E6THzMGV1EfXKkhloleo5h5m2F69ADe6fA64m8b7ksAg
         XtztkZPZ61vc8jfB4bGhLRAq4XcQawo8C8HdrYPHdWEnL/bMxzZjQyGIDHpfb77F08U/
         Bmow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C44DPqfupkcBF4fN34DuNv7QrYGLUZe9sTKtGA4M/4Y=;
        b=uSCuqyiwZirgrHn9h5y/ob67L835Rdq8TUbG0StjI7s6cg/9UMJnImiWZFN6mkkwQj
         Ls25kinPgfokuiqBTgPcDMnq4Zex7YvwcnoS8RwAW5cmALYRqPN6ehlqL21CcN9w6eV2
         JckhEH7Nf35YiSOJKL1ghAId7mLFoNaKmBE6fYfpLA67w2RLwpYK3xdxbXoMIleqFtO4
         Lx7Wt/fswcSvEKjHb41FuDdur15OmkkjR5YNUAF5BA5EuzZq07Er+jPAPAEFhP+UdhLd
         VfZEmEFh2NcIaR5THOj7rTLybv2WtZBDMcWG1H/ri84kVHyDvlMjIqTjczCQUl3pq0u/
         wh5w==
X-Gm-Message-State: AOAM531QoJhw/O2mz6LrrkXMloh+VYUYRRirUmqhuVp1t8AxKCu3uxNx
        iTBlVJMgdMppDFp3Wexqe1781QpQWX/M3Gxd
X-Google-Smtp-Source: ABdhPJxvJz2H1h/62LpgT70iBKlFsproHdiMPwyrdkHn82GRRwmrOEza8YZZS7W+ZJ6LBWCAaredTA==
X-Received: by 2002:a17:902:a40f:b029:fe:fee9:92fe with SMTP id p15-20020a170902a40fb02900fefee992femr15701440plq.26.1623030477046;
        Sun, 06 Jun 2021 18:47:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q21sm6823428pfn.81.2021.06.06.18.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 18:47:56 -0700 (PDT)
Message-ID: <60bd7acc.1c69fb81.573ee.6189@mx.google.com>
Date:   Sun, 06 Jun 2021 18:47:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.235-12-gc3f88167dd62
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 162 runs,
 1 regressions (v4.14.235-12-gc3f88167dd62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 162 runs, 1 regressions (v4.14.235-12-gc3f88=
167dd62)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.235-12-gc3f88167dd62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.235-12-gc3f88167dd62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c3f88167dd62ad7702720b56c90f778fed039a8f =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd49694c95e85b670c0e0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-12-gc3f88167dd62/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-12-gc3f88167dd62/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd49694c95e85b670c0=
e0d
        failing since 97 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
