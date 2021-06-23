Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BA23B21B7
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFWUVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWUVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 16:21:41 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32405C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:19:22 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id t32so3256685pfg.2
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Db1kZ3RpzpZ0ymPWcyw1vhkV3w5I2Xq/jby376qsdyg=;
        b=qYc6MREUrFxRh6gIEDeLL+BU8UPXiCSzgBMIX0pefEwiuV6pN6HUUQ4GKDa1xSeBPb
         Simf1PmHFDFUq2IozExGnhHLtatm0gISw+IlQiDEcaA3rLuFJF05GqCfLgPFtFXhJhxR
         maAEDU3VOt9KkL7es2c9LyN+tkMPONV4vO6oiUlxAd5+AEgk5Dh/8Ic3IfvQeOWqHYmr
         eIYcE3Hr4S1JxIXnDvc5TKSnv6eR2st2fGYDO+qNBKjxsr6QD+XzavviOKpYqFbnDU2E
         X85xZtzeDwuC9JXo5fxFk3Ovmw43e+kWBnZiOFEBpYUjKGsUfxEWzAzBdwZsSFnebav0
         rpMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Db1kZ3RpzpZ0ymPWcyw1vhkV3w5I2Xq/jby376qsdyg=;
        b=g9p8leTeRRaLHSuxjaCPZKTQ/s2YqpG3iRM5jDqMi7HcVCCjMYRo7jqEebtOQYelMH
         AcQnLIBrL9/BHFgCdkj/2XjXtFbfxsszrPFaGLHOVcv/akqpFHgi9aBdqSs9MD3K1bFQ
         vV9bKGANTmYRBSErCz/kK05NGzQ01Gf70S9I5CVUJiUKh0OTetCXLzKVrXXm1GCYg6Oe
         Om9sZNFWF4fYh/PWf73z13laP9wdDASRnKvMXyQl9MFofk8uNPvC4Jez9sN+Kk9jnGM2
         3flFz3H6w1HvZTWxxDh3AnEv8a33/8aXscGp+5ac7ZfKmDnaBjxBSGDX3mmP1sjmypAS
         IB4g==
X-Gm-Message-State: AOAM5321hhfn57c1LNWUH2i4GOKR78BEK0XoTIs0cr0JamUa64JKqiNO
        ONGFSTUd7ZD8GuC7PdXUOH978PkjbeVUtSZi
X-Google-Smtp-Source: ABdhPJx8XTCeMV6o+JSD3XSezCWW98uXd4kUGlNJbn6XwzJXOWheEBhKxQ4BixnwQp1yk36VpIp6VQ==
X-Received: by 2002:a05:6a00:1c6a:b029:304:2fb8:7ef4 with SMTP id s42-20020a056a001c6ab02903042fb87ef4mr1437794pfw.16.1624479561989;
        Wed, 23 Jun 2021 13:19:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w20sm763330pff.90.2021.06.23.13.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:19:21 -0700 (PDT)
Message-ID: <60d39749.1c69fb81.4e1a2.34c7@mx.google.com>
Date:   Wed, 23 Jun 2021 13:19:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-64-g3557f63cfdb4
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 146 runs,
 1 regressions (v4.14.237-64-g3557f63cfdb4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 146 runs, 1 regressions (v4.14.237-64-g3557f=
63cfdb4)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.237-64-g3557f63cfdb4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-64-g3557f63cfdb4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3557f63cfdb41f9eef28972cf01440b2037b0e0f =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d3853cc22b82785a413287

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-64-g3557f63cfdb4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-64-g3557f63cfdb4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d3853cc22b82785a413=
288
        failing since 114 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
