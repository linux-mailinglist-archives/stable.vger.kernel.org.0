Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B1C31E307
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 00:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhBQXcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 18:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbhBQXcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 18:32:51 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81580C061574
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 15:32:11 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t26so9524242pgv.3
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 15:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N+6juJ0uLeym1+ZdUIeoj0WHQU/pA6PNTx5rFhIbgyI=;
        b=Y8uVE4QIAcFKADNb3U1vzMxEEeqwICQlZ8pnhnIOPNdbXOpBXpRg0qA4jK2bl0yRvU
         SkHS9Qx1CLmc8P2YBIg45CQ0f/ELqvBH7Twert7GT8GjZQb2ls/gtlYweZJ1bm/H5OSh
         aVJx5CWNbWRjuah0l4T4AROe+aplov9Gv8j/7PKi8JVAD6FCxp614dzD+RGcqag6hPMv
         JrQw6ItCA+jnKLSxq8uHpHBAd1vPtN90eyuVGYws8V0IfcEo1X++iNF2IO8u9z1GclNd
         A67u1zn9STfeoImmprPpC0wFlvDAiKyxweRULd8L87cez0ByuOAnkI0vW0IYGNcX0xQU
         CQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N+6juJ0uLeym1+ZdUIeoj0WHQU/pA6PNTx5rFhIbgyI=;
        b=iZjjfcGhGkPUXUiXUvS0j1P/3jabGDU085SpqJZsqzwXGnfZ+tBUNHkR4hxMEJuC3Q
         6qnsS0HNDNuqIiJ/xpKnD6QvrUYl/yYfXvMcZ25KmIF8dcDKqJ/pX8JEB6YFftStkAfK
         b6Nn5b4FcwSLrmnd3R1CceJ/aNvKJNCfY/P7QGPYJcPUre88DcvpWM3zR+/rzMCKaGsU
         UEcOAixkUu0Fml1FXyo4wV6rpaVz9ggFBZKXqOTu4yJKboQBvkEdTbc8HW11xpM2BbbX
         PzJ0PtapG+SB7g/Hueewf+QBW/gRRncdeqAP4eB7lsDGodu5FI9q7Q0Falh6hFc/szDR
         xYqg==
X-Gm-Message-State: AOAM531YRhdM6UdCHqhems+o7RE2zcITYXZm0bommybW+eKcP3x4KxyM
        NQdnlyKltn5iYB0x/jYBfct9cVdZ4eUcOQ==
X-Google-Smtp-Source: ABdhPJwuMlRn2fOdVifCcp7BOdxpccfPQHZbbpjdbXVGLMUV08lbKQPEDyb1vumuEmzOKIXjOUfkOw==
X-Received: by 2002:a62:dd48:0:b029:1d5:e29c:621c with SMTP id w69-20020a62dd480000b02901d5e29c621cmr1508634pff.31.1613604729403;
        Wed, 17 Feb 2021 15:32:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6sm3289627pfd.5.2021.02.17.15.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 15:32:08 -0800 (PST)
Message-ID: <602da778.1c69fb81.87249.7b15@mx.google.com>
Date:   Wed, 17 Feb 2021 15:32:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 60 runs, 2 regressions (v4.9.257)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 60 runs, 2 regressions (v4.9.257)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =

r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.257/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.257
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      282aeb477a10d09cc5c4d73c54bb996964723f96 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6024699b84a41870753abe8e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6024699b84a41870753ab=
e8f
        new failure (last pass: v4.9.257-19-gb6978209a21b) =

 =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602468b57fe1c539f53abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602468b57fe1c539f53ab=
e63
        failing since 84 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
