Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C04471EF8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 01:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhLMAbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 19:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhLMAbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 19:31:45 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6A3C06173F
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 16:31:45 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id iq11so10701970pjb.3
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 16:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Itme8U0b6+JA1uFs6VJtq/0hvKKG2rVoTy5mCxwSNMI=;
        b=pinTgfJEzbH60o2qg2/F9BGjA+X7RprYSeq+Tr5ZX5nBUIIqyUyvyv6HbzUs6xNJx6
         YJxfL0W6cNxhHxXSHmDUCorZ0Zlnv1p2cSLs1zNGchhP/mELMzFAdaY8LGST58GxvSQd
         DqjXvXPrRQJh4RrC3qrEopbTvwZ8G5+v7SpCnpmybSG83PkLQ13lHodk5sPaZNjXu8H5
         0j7WSESwdDsURSAnRJoqd7unFBUMtNtdLXl5l8IhOjlTs/qpOYsAAzNBKc6lakDPKxT6
         OG3FmotnO3Axh3mWzLkIExkfFXn5GdVfrsAGM0EYkmPLaC1ZS4nqfvEfIQ22SF3/ynCx
         eI7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Itme8U0b6+JA1uFs6VJtq/0hvKKG2rVoTy5mCxwSNMI=;
        b=tjktV6wxSXGJNO9/Tr6SbSpC6fj8ksKSd3EQrUqmDMQo6qZ7jZzszy4fAZ2XQ4TxGQ
         gRRUsKHV7bjVss0nUfIdfn2usMr4If3YNh10YU2wop/RkXt7blsWRTGcAO1qcDNOjYij
         xBVdjMulFS0MCAuftXMTCraJ9uVcfcxkeB01lJJp+Jjfq7cwI4M33GBebOCVN9ChUqln
         zZBhmu1R4uw6sBY9nUJWTBE+nr4FsaI7gmyHPIHyvI5MOEUF4BTvCrszeTmjgw3K/2hj
         eW8LjmhE796er5lETPJwZFBrSy0HwxZBR/0Ede6WcacAIotWNx6blKoSbfKFKVlzGFXv
         M5wg==
X-Gm-Message-State: AOAM531jeiIZqi8aUjZg9DP19cWAXN1h17O7hJsP5zHo8LdaAtQRzmBe
        9xi4ABaiGja/QW5j28kGidPamKDV4TaHdpZl
X-Google-Smtp-Source: ABdhPJz9dn1TTi5On0ryp4vzZHGkNuykesRHhGJmJm2+gAPwOmoe0RXyGTpyGzIFp9PYjCkS48i/GQ==
X-Received: by 2002:a17:903:248f:b0:143:8e81:4d7c with SMTP id p15-20020a170903248f00b001438e814d7cmr90267294plw.1.1639355505179;
        Sun, 12 Dec 2021 16:31:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s19sm10068513pfu.104.2021.12.12.16.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 16:31:44 -0800 (PST)
Message-ID: <61b69470.1c69fb81.2e86b.d089@mx.google.com>
Date:   Sun, 12 Dec 2021 16:31:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.220-51-gab7df26443b3
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 190 runs,
 1 regressions (v4.19.220-51-gab7df26443b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 190 runs, 1 regressions (v4.19.220-51-gab7=
df26443b3)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.220-51-gab7df26443b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.220-51-gab7df26443b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab7df26443b3d26a7e56d9a349c0002167fa1e08 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b65b90971b6203f939712e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20-51-gab7df26443b3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20-51-gab7df26443b3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b65b90971b6203f9397=
12f
        new failure (last pass: v4.19.219-49-g36bf297d8737) =

 =20
