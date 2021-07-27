Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2631D3D7125
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 10:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbhG0I01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 04:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbhG0I00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 04:26:26 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79553C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 01:26:26 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e5so12969458pld.6
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 01:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/jcBZxOenD6D5KVodKhpMGF8/aWhTIlvXga/nwOfVSA=;
        b=rGX3FkVuwCHR65IUBcNAZ+dtUHSioNs4C1ukXprkccc3Mlegjpd9blVqaqsobW5gcp
         5gXVqBJUWzzzT6Prwyy6g0/fx5gu3L3K0kuTom1EmyRwwSqvM4BKrKUp8c7hNxmPlvWS
         46mNZetQ1c2rFQa6PlADfNFs9wFyrdYqFw5DtrR4dU6X5ZWpqvpKnHYTgi1//6SQAegS
         HsasgG6stBmAIy/o/Ea541RTuS/V08HVbDu/JpvJ5lztKkg76RzTVXm/0fV8D75tTJf1
         OCVs//HRkimxW/kYHBTErvNOujggUseyqhmtvd522r6jFTckGWccE7N5zD/ZgZu5Qkb7
         eSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/jcBZxOenD6D5KVodKhpMGF8/aWhTIlvXga/nwOfVSA=;
        b=G+GvcvW1/JttcfnILe4XbITFb0a82EI7RugwYtvpk7KHxT1CUptaPRKjjGzmH60t+y
         /NEzpkmGPgln1UP70RGWSTAfy13I5CxXuP0Bpb7RJTDqKCiK4AP9p7snZycHXaBj6t0L
         jffHJs4GFPyx3OmvuqMtRsjXT7TJgmdvQC3kaTOmAUnZYkRepqzYBInZydcwWBY+uDsa
         EcIOUZU67k9iTztAjUUc29q+KhQ/0KWffdVWts/MubyQQbZYzzLx3JGESLFzI8Pbq7vY
         G2Ae/DnPslRBzW7lWu8PNFy2pdaMmTHfvDSSlFNpYnl/JmQ8c+mNrcHx13EOb/wS7lGF
         ahKA==
X-Gm-Message-State: AOAM531EYWRWRUUOTPGE+nDSJH5/NkF5/fI/0OyJz+nH4MzlOsGwRx/d
        yU12jV0NRN7rJQbQHQQF311oCdaAShOjgA==
X-Google-Smtp-Source: ABdhPJz0krhLWTVC4d0Ica+2Ktz4udsEoz6t4dSfBVmqZHUZ+z/vxX07nfBCnS23V4HgeMGXzNtoCQ==
X-Received: by 2002:a17:90a:d50f:: with SMTP id t15mr3249394pju.160.1627374385977;
        Tue, 27 Jul 2021 01:26:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z14sm2660491pfn.156.2021.07.27.01.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 01:26:25 -0700 (PDT)
Message-ID: <60ffc331.1c69fb81.b821e.8c2e@mx.google.com>
Date:   Tue, 27 Jul 2021 01:26:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.198-120-g0a9163342b8b
Subject: stable-rc/queue/4.19 baseline: 114 runs,
 2 regressions (v4.19.198-120-g0a9163342b8b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 114 runs, 2 regressions (v4.19.198-120-g0a91=
63342b8b)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.198-120-g0a9163342b8b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.198-120-g0a9163342b8b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a9163342b8b58efd1743cde403d84a29eedb657 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff8657a024c2556f3a2f48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-120-g0a9163342b8b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-120-g0a9163342b8b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff8657a024c2556f3a2=
f49
        failing since 255 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff8647d202ac29133a2f3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-120-g0a9163342b8b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.198=
-120-g0a9163342b8b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff8647d202ac29133a2=
f40
        failing since 255 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
