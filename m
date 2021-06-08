Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0B739FEA2
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhFHSIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbhFHSIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 14:08:30 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1945C061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 11:06:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id y11so9017398pgp.11
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 11:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VHL90LenP0715xNVjZo/Sq5LIxsEfl2lK15igIQtbJY=;
        b=jJJD8xIecCNa8xfeawddYz42brwXv+X2gXeiZ0EU0wFA3nkldpIj4UcIPEELRhoGD6
         je9TZhI/OXdxcV3UwPpSj8F+BZ3J+rHRUYOZRk799xAgZHsb0HEahYi5ar+1RXsroaSp
         zjKvv6myLKaKnR0KV9IcJahgDy76PsSnQKdX8D8eXeQ9VfjfSMc+DoqYuETdvmQAwIAM
         rx1YExNYFaaiW6l6ydQByaZCqfxl0SVu/Y5siMXQ+GJspWx/S9SZe7/+1pc/mTh2p4il
         K9D162optOvTcRMKdZhO/rUaIzM74Xf7uFA8MYl1nwdpKS24/1EiIS4qyWZJZR+8O2AT
         C2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VHL90LenP0715xNVjZo/Sq5LIxsEfl2lK15igIQtbJY=;
        b=SKqos0czYG5ND2C2MW729OFyxD6W43OJo6s2Xfb4LJzqbd8HTpA+w6T/2PIDuR80S+
         hrkhD0uh3cGMDksYnfyCPKcbqERI6YFPU2fHaiuCXgmTvsQqQl+SHnS+BqECFyg3ZZAr
         Ni1xhpfUKW3xnJibMgbRWE94J/H2r6Y1QVvypNMUUhDuTKaV0MkErKMbtprfiJrhRjml
         F6M22zNHcpwmyzKfuHNCzP4IpBjr4UxNPzbwV4BhAtUWcJo+GRAMIkm3iAGY0L00Coyr
         bUkSnDuZPi6K1uY/WaeHhZuKT331cuhiU1OCeei8yChFZ/sQZyKWu9d+LFJXSG0aBlYO
         XXww==
X-Gm-Message-State: AOAM531qdaONiCeRbRMUAlY3g8F2c7+e0YJvIn0feUg+zbysJkdFu72/
        Mdik/UV4GelPMH73H6RDk6ShR9xFc3AJfdrF
X-Google-Smtp-Source: ABdhPJxVM3GcGkn1QGPzVo635BaSJxxX8CGBn1P0nye/ZQlM/wPyg3tmpXJ6e0PQ2DcmeTzoIj0E7Q==
X-Received: by 2002:a62:3344:0:b029:24c:735c:4546 with SMTP id z65-20020a6233440000b029024c735c4546mr1175780pfz.1.1623175580151;
        Tue, 08 Jun 2021 11:06:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q23sm6231504pgm.31.2021.06.08.11.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 11:06:19 -0700 (PDT)
Message-ID: <60bfb19b.1c69fb81.2cf98.1a8f@mx.google.com>
Date:   Tue, 08 Jun 2021 11:06:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.42-108-gb2062faadc3d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 1 regressions (v5.10.42-108-gb2062faadc3d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 161 runs, 1 regressions (v5.10.42-108-gb2062=
faadc3d)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.42-108-gb2062faadc3d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.42-108-gb2062faadc3d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2062faadc3d17cd397f0a37d2126e18e24784e0 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf7c4d5030df8a840c0e7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
108-gb2062faadc3d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
108-gb2062faadc3d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf7c4d5030df8a840c0=
e7d
        failing since 5 days (last pass: v5.10.40-261-g8e56f01eb8e7, first =
fail: v5.10.41-251-g1360515527f5) =

 =20
