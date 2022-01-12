Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CA248BC71
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 02:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347768AbiALB3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 20:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347481AbiALB3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 20:29:36 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F87C06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 17:29:35 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id pj2so1967496pjb.2
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 17:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BA27cKMHY0xGn1GirOn76oUmh7n9Sc4AMZv4gIbzcY4=;
        b=RChT4gsJMsOs5KljZ/CUmNq/MNuRy2hunEK0iFuVHCFeF7XHpWQzknUuQtfRrLMXPd
         5i+nckNfiTtUoLlp4YJGvqIB//FeXVQ9qknjL59TIAQaZm5chvhA2RURVKDbROMNSibY
         Xy2oSjyXWUVSxCqFQ/qLkRMVfJ3IiOEyicEbiBvlMxvh6Vez8swFS22KlsHltVwPNjMd
         RkZqXtmxQ6y4kV8lmwdUGxbete8xGzSfo88GOlfYbeBECNg0RMRSp40sTI7f5rtgRwD2
         ySQ/U9GHgai8oat8ALzkh8D+rYa+ZAC6GFedSmhX2MAenTwwaDrgOrvUWJrAX9ge8z0M
         NzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BA27cKMHY0xGn1GirOn76oUmh7n9Sc4AMZv4gIbzcY4=;
        b=yxI1FFJtgDrGJJmsR5FhmHcdh664A8aFeDQCWTRoDgSF4goJht9ivvJbfI26S8xUkh
         HPjHUGHAfJ7Vw3cxqVw0vZXvOttIBzRbmp4eidR2gbvdxdPjdkQWZp/F/9xdKPXRnIT1
         HKgIdhU7haAtUqbg+HPhx9uKsQyn3td00xulV5YwGoeWxF4wpfhNS72QI0inaHAvXKd4
         cpSK4PUH4n/yR1g41PCSqBjeNVG6CCbj+zOrQ8gyfYrjwKNsP/jeQ9JkgjBT92LnLU4Y
         H4TbB1Gvw8DoXF25SwMK/HMVSXgLDX3V5HlGengw3JCu0xqeVFBFeDNQfK/AryH/82TB
         4I/A==
X-Gm-Message-State: AOAM531AVRq2ZsIpECRomT6Ckk48SjXmafvsAll2jycod8dyILqw2u/f
        dgWSpBRr4Mxu06QlnOiEOIsKdVOAJMNPViD1
X-Google-Smtp-Source: ABdhPJwGG/fFqiMBhD2+QMaaYgqmvY1Lb0EkHdZOH7IbVywQ0Fn/sP5hqQlX2KW3e7vjipzkNk+p9A==
X-Received: by 2002:a17:90a:5d8d:: with SMTP id t13mr6147769pji.47.1641950975309;
        Tue, 11 Jan 2022 17:29:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u31sm4322430pfg.3.2022.01.11.17.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 17:29:35 -0800 (PST)
Message-ID: <61de2eff.1c69fb81.699e4.bd60@mx.google.com>
Date:   Tue, 11 Jan 2022 17:29:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 170 runs, 2 regressions (v4.19.225)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 170 runs, 2 regressions (v4.19.225)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.225/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.225
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e0cdb245b7c83cfa2939071bf0cb7a2ecd31abe =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61ddf841faa2335c70ef6748

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ddf841faa2335c70ef6=
749
        new failure (last pass: v4.19.224) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ddfae688ef9e681def6766

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ddfae688ef9e6=
81def6769
        failing since 8 days (last pass: v4.19.223, first fail: v4.19.223-2=
8-g8a19682a2687)
        2 lines

    2022-01-11T21:47:05.997162  <8>[   20.982360] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-11T21:47:06.041579  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2022-01-11T21:47:06.050978  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
