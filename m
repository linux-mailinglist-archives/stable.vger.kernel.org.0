Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB72E306390
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 19:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhA0SsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 13:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhA0SsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 13:48:21 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AB6C061573
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 10:47:36 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id w14so1791018pfi.2
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 10:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oDRb+8rrZXzNTOWTprDgqDh8BBeJhE3ZS51dcy/J7Eg=;
        b=VzpExH9N7wZ9P/Iy1qC5IhQ9e+xZl0/LQjgkrw+fD+XwKvZYzO4WqUms+R8cGl28U3
         ShihH8UE8bcd4iJ47PSkfTILpFK6q3Vez48hv4VyECotc0Ql31/MckBAZwB4koBAhZdi
         uVtvrxnVc9j/YzLzDobfTqLmIITYco9NIPFlM62PZ7gxGsDmr50CReJLHPiVMYbjNk07
         5ZQWoSOb8eU/KqDtYBX/a+sXe/uT0lfOcG1jOcy+INjfDajlD1POwbhBITd8Ynm4LY0j
         iZ1zekAqPaZLguVVYQqE8RM0R4lKr71v1JnI2e436IhL4MNuwDyQTX1J+pgp2EawmA7o
         Fdag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oDRb+8rrZXzNTOWTprDgqDh8BBeJhE3ZS51dcy/J7Eg=;
        b=On8y9Qpdmm3Cykq/MFtXovClvgbjLQpnBxyQIU+eKbpF+axhv2hHkeVP0gI2PTTNCc
         f69j7ZqpJv96S1ER4qkBiXTtJZ0OQpPtx1jj7T3PIK1ncMO9PS78t/bajDqbrdU5ecbl
         tH3B+l08UC5onsImpU/0GnofhYUJy1Cj7eGAM9OlTbon9w+QG+ze+i1/s/fmf723NsDp
         7yBvM2j9g2/pNxHIJ7J9phvo76BhPF3g/rIUW+WLT72Tmd/3ijr1lrkRx+pusq2XxePV
         wEhBh/FGD11w2bDnnhJDkN8GD6vwND/mvDhw6nLQG3TEAik+4p54/szIPBnAPdFT/Q/e
         CEOw==
X-Gm-Message-State: AOAM530Zpagpt5AUdNXiYK6xpza2Y9A+TYKD9neJxB0Q3L02WNPsBtqD
        S8TjlOmTntBvMZ5uMihpfWuS5fsArAEu2LXG
X-Google-Smtp-Source: ABdhPJzVPofPsBQi69vuPOLY1rX/U8yhm4OKhCO1tfYxucyVS52Pa8ULPHZmeFgbrSjsb+yp7I8i6w==
X-Received: by 2002:a62:aa0a:0:b029:1c2:1baa:eaea with SMTP id e10-20020a62aa0a0000b02901c21baaeaeamr12182164pff.52.1611773255331;
        Wed, 27 Jan 2021 10:47:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j10sm2775880pjy.9.2021.01.27.10.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 10:47:34 -0800 (PST)
Message-ID: <6011b546.1c69fb81.945ac.63fd@mx.google.com>
Date:   Wed, 27 Jan 2021 10:47:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.11
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 175 runs, 1 regressions (v5.10.11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 175 runs, 1 regressions (v5.10.11)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b97134d151275424dc83864d6d2cf52f327adaef =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601180daaa8e6dba45d3dffc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
1/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
1/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601180daaa8e6dba45d3d=
ffd
        new failure (last pass: v5.10.10-204-g460ab443f340) =

 =20
