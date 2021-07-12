Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FD93C5B86
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhGLLjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 07:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbhGLLjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 07:39:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09E0C0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 04:36:43 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso10282987pjx.1
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 04:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=37SuMu6o4kCMu7UDrG4s7tCYuXtrzWh7352oRNAZjYE=;
        b=lPCg6NfuDTf8legUF42gxoIvkaWH9y6MY/LIXirhG64boRpcR329mrOptYOeFQQAaN
         GCLqYumh/3jhtIbnNdyCRFHSxEtnwtthR1PH6CxCx0hLhvzaqVfwP9RH6c8i7FHIxn+g
         beuFaPpSd0G2yG+8H4hx2SpacM1ZEYbbO6sVhWw9nWMnKZ+urYNNi8kNRMNHBA9oN6+2
         xMmpFoQ/8Eubr8CrL6iAhO0wUuih1G1aRYEdqOnnglPsNVeAaVEUo9Aev25pyuLD4y/5
         2N7MbGlWPOxTc5rhh/u4t5K3zIX1RLIPvKaUstYTpHIAkIxNsGm7WK7UFQS0TgsjuMr2
         qUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=37SuMu6o4kCMu7UDrG4s7tCYuXtrzWh7352oRNAZjYE=;
        b=FzmSc+TBixctBufjzPw8CWFvSammMbQF3TKrqii2wOdsDu4M6BYyblOn644A1Fb/W/
         frbvitqjkKeQdJC/1+5IbZKQE9KrSiZeFHqN0NqKlxW1sJwRpvUHK9fXGXd5eRrPRntA
         ew+kx1+sF758+YocbpuVRv0Up0GAmti7d8BRKijzkbrs0HJ4iZAlYI0/jsKWj2D73zJN
         ToytsmjkxL7iKHEzKPjqDtHtVbEdbxdamcYj/vfTkk+lSUTEmDM9nVD0wJjH7kkuZuiw
         hkRbcyYt/JhZ1+UEpDZ99VUSWEZ6yMCQaUsaDrINjHoPNmbQKx5PqoI0zKNUAw2yuFuU
         rYUQ==
X-Gm-Message-State: AOAM532unSIFLnwrqwx/XnWnr1LbMkX6mjXutv/ktSk5LuVoZm56Aipd
        OOq4rYuryPsJSSHTjp+0/VuT+CJjlHov+J5+
X-Google-Smtp-Source: ABdhPJwncKJwP+aVbptSHYERWysxBia5zktqmIHYjEfGxokTRQCt5e6iNZ4+s0T12dkA12pqUlquEA==
X-Received: by 2002:a17:903:2c2:b029:101:9c88:d928 with SMTP id s2-20020a17090302c2b02901019c88d928mr43283309plk.62.1626089803245;
        Mon, 12 Jul 2021 04:36:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1sm15028118pfm.123.2021.07.12.04.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 04:36:42 -0700 (PDT)
Message-ID: <60ec294a.1c69fb81.b2e4d.bbd7@mx.google.com>
Date:   Mon, 12 Jul 2021 04:36:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49-593-g5e321de204df8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 164 runs,
 3 regressions (v5.10.49-593-g5e321de204df8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 164 runs, 3 regressions (v5.10.49-593-g5e321=
de204df8)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig |=
 1          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig         |=
 1          =

imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig         |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.49-593-g5e321de204df8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.49-593-g5e321de204df8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e321de204df829365615b98e2731c0a3813bb5e =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ebf471c6c246e2dd117984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g5e321de204df8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g5e321de204df8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebf471c6c246e2dd117=
985
        failing since 0 day (last pass: v5.10.49-593-g1d9b6799b02d7, first =
fail: v5.10.49-592-ge2899f499d8c) =

 =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig         |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ebf84babf0a6ff651179e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g5e321de204df8/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g5e321de204df8/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebf84babf0a6ff65117=
9e9
        failing since 10 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig         |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ebf7be85b8b36a8511796c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g5e321de204df8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g5e321de204df8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebf7be85b8b36a85117=
96d
        new failure (last pass: v5.10.49-592-ge2899f499d8c) =

 =20
