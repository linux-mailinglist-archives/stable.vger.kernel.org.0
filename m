Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B42444CA9
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 01:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhKDAlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 20:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhKDAlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 20:41:06 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865EBC061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 17:38:29 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u33so4119675pfg.8
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 17:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lThHzLv/wG363gQi81E5zzoK+ceJOiKwmMcyQN4fDIg=;
        b=1/fBiSGMFqEhltr3riWEksE77Y+exx0inKcFEby5Mutc4L+8MfA7QV6rjC8M6i7C6Z
         YcYGsC6/LU/p6l01aRlesqCaS879Pj0YEmqOyXEwgPMHSP05oI+LaPc9Nz73Hgbzz7cY
         MxTaO5exY7Aen1yUzXtoNe/Y0KmWbKIavzk+7QA0P3xF9zOnXMPo4gkfaz+P+sjmuSjT
         vTGieKsaeQyYDj916Jp0eMPDdO5bgBBaxLCv8kgL2n8ZGZefyaeQiG8LTdE8AVrfdQUr
         gzE3Uz27HefDkKZt2nOLgBIpxfP20xNyQD1XNNCz92/6jAl2MAJOsSNkoz7GQlq4XR5K
         oUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lThHzLv/wG363gQi81E5zzoK+ceJOiKwmMcyQN4fDIg=;
        b=d5Sqxzch1uwxgjhsOkYSoOoaK2s31mjdyFU1QTAeT3MMfhofTlEjWFaBao4QrxGKh5
         iC5A8UyUx/t+Wk8lUskbXEvShaEEKDszHolbr9zWu0vw+7ukuWfxThkf+eE/IXkBsNT4
         sGWjySKvH0nCo6qsw0xElLPZNPBWpM3265CspeBdmtgKTAJxIi1RWBd7l9LeP1oapd3b
         N8QRbmdFgTK6x/+QqF63orhfXC8YRjv7VA0p7fY/lorxLaLJHU36HFJj0TVVoEriwk+7
         ITgKLTv3J8u7YFTGPnGIJypFmR7LvpCuksnHz5KNMArpScdG8hlvDihzoSHiRHJ595QH
         g3cw==
X-Gm-Message-State: AOAM531jqnFLzM2uR8iq15yap++003+K+jKAMdDfBhpBM2aEy3EBNq9A
        mppNFe4pPxdQX35iNOkD/n+2dP8mivIJIkK9
X-Google-Smtp-Source: ABdhPJw/0jy19Gsdo7aEU2ZZUbfF2fhLGxTJaTcsMCAgrtP2nec2XzmPmHT2nYe76TOnfq1cADKxoA==
X-Received: by 2002:a63:564e:: with SMTP id g14mr6050061pgm.366.1635986308892;
        Wed, 03 Nov 2021 17:38:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m15sm2668299pjf.49.2021.11.03.17.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 17:38:28 -0700 (PDT)
Message-ID: <61832b84.1c69fb81.7352.96ae@mx.google.com>
Date:   Wed, 03 Nov 2021 17:38:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16-7-g8beefd9827da
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 158 runs,
 1 regressions (v5.14.16-7-g8beefd9827da)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 158 runs, 1 regressions (v5.14.16-7-g8beefd9=
827da)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.16-7-g8beefd9827da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.16-7-g8beefd9827da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8beefd9827daa6d16e037ca1bbb31947a7d90de6 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6182f96266563d69ea3358fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
7-g8beefd9827da/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
7-g8beefd9827da/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6182f96266563d69ea335=
8fe
        failing since 10 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
