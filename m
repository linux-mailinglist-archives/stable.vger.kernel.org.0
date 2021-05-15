Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90BD381583
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 05:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhEOD1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 23:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhEOD1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 23:27:31 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA69EC06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 20:26:19 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id h16so1134844pfk.0
        for <stable@vger.kernel.org>; Fri, 14 May 2021 20:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OliDutuCwghyOZFEhh/+4jnJ2USH3Eojvv51iBmLucA=;
        b=e4fHrdlZH7rRLaQtpfkn4GAdPiikDHw7iVlQPj5WHOlzPoSwMfjyzkrL8sdn3hDpWn
         7/PTLxeCPVcbbcU6pGXKILjNzjWdBGRoU0R3d83wh96wrzvtaCRlH5Uir7dzSLizVywF
         80vvijpuB+DVDWjn6LGFwrmXMO7as3w88kyJ/jnlvdnpFu/jJ1XhcNBB1twao5KUuWR7
         fEw0ydj7jhaFFlw3d6fgNNxTep9o9Kjkk39iE5B2Rc31BzNNGuIhq0yVHLd1JNDwZ3fE
         v2oTI9XigYLxMU+Te0K7kN1Yv2quInxC7MopGMizzhgD1iVPmuMyrFaHFgWHMSVxPFer
         ku5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OliDutuCwghyOZFEhh/+4jnJ2USH3Eojvv51iBmLucA=;
        b=c9JVx7U3wEmye7IHwypfDdpnQaerG8l39EAehDm2GrEDF74STlVZAL9EexHzubHwPR
         GVt3+OxW2LcdrJGQ9i/Ty6jWFMhAez+27wT7C/71QbaqQnBIARfp+WjoTTEwn1AjEa8L
         rNuavbAIGNs1Zixy0Pc8MP7lV3VyDP4Xp3JCr33BsyYntwQE7PDJNX4jHDyqXFUK2gLc
         sNySEoszFHIHheJRzZ/yyXO6aDkrZa6t1pNIa68TjlWSrZMxM0xQ9T5DBe5j8s9NhBg+
         OJazbTKKWV4bhPLyZ3B2w3n5YUUmI9ATGoh2yUYvv3hD46EPMCMzBieHHKkVzf6daA+A
         S9zQ==
X-Gm-Message-State: AOAM531b/6BVs15PJtzcFRaoNfft7koWj6Mmithor7Qmnx5D9BD53uhz
        22UfMe6Q10wSwhVxo5wN7uuSZLbvf+0YYc1x
X-Google-Smtp-Source: ABdhPJyIx2c8ewlb8NutLOhpTI5RP0p0LDCLclab67T9o22qyZTHa6k/HiljuIJ4q5aK0uhxl+2sOQ==
X-Received: by 2002:a62:7c12:0:b029:2d9:a70:2b9c with SMTP id x18-20020a627c120000b02902d90a702b9cmr521641pfc.22.1621049178901;
        Fri, 14 May 2021 20:26:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm2678935pfh.114.2021.05.14.20.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 20:26:18 -0700 (PDT)
Message-ID: <609f3f5a.1c69fb81.d6dce.a460@mx.google.com>
Date:   Fri, 14 May 2021 20:26:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.119
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 85 runs, 2 regressions (v5.4.119)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 85 runs, 2 regressions (v5.4.119)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-8    | defconfig | 1 =
         =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.119/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.119
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b82e5721a17325739adef83a029340a63b53d4ad =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/609f0bc6d9d16d5ab8b3afc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f0bc6d9d16d5ab8b3a=
fc7
        failing since 175 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/609f0e1c0e67bd3b75b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f0e1c0e67bd3b75b3a=
f99
        new failure (last pass: v5.4.117-430-g12be7a21d622) =

 =20
