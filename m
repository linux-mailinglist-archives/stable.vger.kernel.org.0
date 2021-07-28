Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC133D8D9D
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 14:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhG1MTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 08:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbhG1MTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 08:19:12 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AD0C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 05:19:10 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n10so2441155plf.4
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 05:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3BD21+2chDFyZKPTo10PxgI5nBYv5y4huGGvuN1mdTE=;
        b=W/ej1ctGyxzGSIda+cPdVbe31OYkI9YtqwYrrylXjTFbS3rDOTOVUUFP1Rq45aaHGf
         8UvOHrV4yPlEWOo6FQ2qjtvEqzpqm+HqzXTIFFrSJC0yCcXfTWboeQCXFo2yJ2s+H/ti
         G0iGQq13gpSreB0tJkwbrMR5rk/huJbp0+maQ80SA2ARv7+qenZHRnnyUHVEx60PLW6Y
         mm7fSCBrJIfsf65D29+2zGBAmcFvyl4whOy1cccZd/7J/tw/FmOxhtSruB5seWp32h5v
         46qDY76VtK/v3LT83SD/cS1KzRnUhqpB3G8BWQeLtHShRhZZHqrQcqvU25JaKV4juXWC
         +btg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3BD21+2chDFyZKPTo10PxgI5nBYv5y4huGGvuN1mdTE=;
        b=cULu1DOo6qgrJYkCVF65PxATCB7Tf5BTaX06qTRcjx/Rg8unDtZdm/pKCheGWZxfaG
         8Gnfg6AK9WnltQ05lIzW2FuSAtLBiwS/KC/vtj6Qoi++X5A37k7dfBFAoZYyemi4S1XG
         1g8mDhSnW8niDeajZ/FfWK8bhPmaJycLbeYRT5WP8GKyRZzZ0SWhM5X5y/fQRQ2+yzba
         es9Msgqk7AyW5OSYte5xuT/8ME6GFakGsZ5iQps/8W7rYxC04crenz9miapaPr40wruw
         7+CjfZhEbGYVwD7RSp9e9qdA/g14I1hOzJ0V1fCl9MUxm2csnmkfYT5Dz1HZnCMyd0B5
         WTtg==
X-Gm-Message-State: AOAM533amZyOYJc47iSP54FKhYThishWrp+nZLQncll8+zTt4AfL3CYj
        ACrGJhC3NMeIFC7oZI5BVM8oYOFzE6IdDTfc
X-Google-Smtp-Source: ABdhPJyiD9tZc2u0bArc9LhcMVXR9PyYhdgOdamDfjdmmFttWeKvmA4gZHdAqqUZrCYlmMEUIbaNaw==
X-Received: by 2002:a65:4101:: with SMTP id w1mr29188828pgp.5.1627474749374;
        Wed, 28 Jul 2021 05:19:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 201sm8231642pgd.37.2021.07.28.05.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 05:19:09 -0700 (PDT)
Message-ID: <61014b3d.1c69fb81.54983.94ad@mx.google.com>
Date:   Wed, 28 Jul 2021 05:19:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.277
Subject: stable/linux-4.9.y baseline: 20 runs, 1 regressions (v4.9.277)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 20 runs, 1 regressions (v4.9.277)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.277/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.277
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      edcc1d3a1c2e80a7fe254889877c0b073474fd5a =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61011a866efe73ef835018d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.277/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.277/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61011a866efe73ef83501=
8d1
        failing since 251 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
