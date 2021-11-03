Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFEA444A9E
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 23:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhKCWH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 18:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhKCWH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 18:07:26 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0A4C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 15:04:49 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id h74so3842244pfe.0
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 15:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QPglms7AVHKveby6vvVidBQ5SMaHFucr1xjZ4sY32Kk=;
        b=vLUTqfwIQu0Tjg8TXhZuKFX/wUjJQ15RwinRj4UIDUx+shbhiZFJIq9JfdZpLqkH1I
         PQiWBwwiz7ibu2cbjqyFvz1qp2VfN+Q4fBowMWtH0yZOdswrXt251ezj6kcJXCXbPGls
         mzvPSjc6ZQRU9qJi8bmB1L27e1mb/e2v8/MFoaiVBJSAAcDmWoPrbefS083m0dt7X2s9
         iYYPeK4OQfKMDGy38uF0gw+Vhn2VT5GYm/Lgq3RicWFzrmT7ve0lPziYi55066XqbOsi
         J1YZ4ZZ6uvOv1jIm0sO5U5VSmtQ70fUA0IP765kuNukGoJHWEJ++W/GUUcw5CzmtRw0Y
         BSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QPglms7AVHKveby6vvVidBQ5SMaHFucr1xjZ4sY32Kk=;
        b=UY4ULBLj9JF0oihckZIohFT29WWi55FzY4oacYt816jSMU/b4542yWT1J5SfAypv7v
         cpE9TqM0k8RazzZR3FKMXi6Qn074917Jl46tfE60qlaOBBysssCqzcgLIvN3Wu/5TBqJ
         9/OVRQxghtqxS4THu4HCnlYQiEUYYZAAspYqEvriXGy+DGfRuGZCniT3aEhXkwyRk1YC
         HLOY4zXe699z+x3difYc1OrlCaDKIdLkpzkgCx60iPMV3Ov0nMwGjjj4nxXPvJUdEaCc
         scotWH/tgcGScj1Fk3CmUl15f/YkKN+sEKKfSLAespXdPtYCzLOHADPRH1D8bzLFDlqX
         9XVg==
X-Gm-Message-State: AOAM531eDAKNEhAWSvgfCpL3Q0XVr7KMHj2HqLVS7GoUmnlkP35JW9YS
        5U77brdKZHB8DgWyH5Cu5CUiElerIJZP5tz3
X-Google-Smtp-Source: ABdhPJyjAws2OMBMFggao3JUXuggi3OsD3vJWd8k2nqCF3hvHIXaY5/dF4vM1Ckp51Nz+4r7rhQ29w==
X-Received: by 2002:a62:158b:0:b0:480:7e39:91a9 with SMTP id 133-20020a62158b000000b004807e3991a9mr32800986pfv.64.1635977089158;
        Wed, 03 Nov 2021 15:04:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f16sm3626637pfe.172.2021.11.03.15.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 15:04:48 -0700 (PDT)
Message-ID: <61830780.1c69fb81.79d7d.bc9e@mx.google.com>
Date:   Wed, 03 Nov 2021 15:04:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16-6-g90b81889e7b9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 162 runs,
 1 regressions (v5.14.16-6-g90b81889e7b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 162 runs, 1 regressions (v5.14.16-6-g90b8188=
9e7b9)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.16-6-g90b81889e7b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.16-6-g90b81889e7b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90b81889e7b9b36a1a39d4fb205f05967a0be74f =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6182d38993c03e3aa533593d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
6-g90b81889e7b9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
6-g90b81889e7b9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6182d38993c03e3aa5335=
93e
        failing since 10 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
