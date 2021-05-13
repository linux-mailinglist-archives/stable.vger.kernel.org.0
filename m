Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A786237F121
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 04:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhEMCJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 22:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhEMCJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 22:09:30 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906AFC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 19:08:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s22so19847435pgk.6
        for <stable@vger.kernel.org>; Wed, 12 May 2021 19:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oV5gWFWpScaRyIXQmwsfQEWENJUGET+P3HPNoUqj/Ss=;
        b=wjGIhyD+/QfRScmAtw5QIgFuSA18ZCH6h4N8O7EdA6QCMdf6GPolMVXhGPIOzITMcc
         AqfJbqWjZiiFLCX7BdcnK82ef1mGjhoANuDKTGOpyW4DJ7hmR8g22MyIKyttvhAUBLz+
         t0JTbQUNwfCrQ5Y69kNAq4Eq4FdeEgxtKWrWY26m/Ehc9VAVhkTGLn9O58SUQVhjtTe4
         o6iAyzwnxVWijnPKzbRqsuoPV0Y9z4VXBAZ0d1Vc111Or7wQizcv8GfGRbB/JewPzwuS
         qRbbhZopp1a8V/pcm2wrP2u2Z+3qCUpr6xocERNyNq3yFUaFXAUQPeTH2K9TBDRkq9q9
         RBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oV5gWFWpScaRyIXQmwsfQEWENJUGET+P3HPNoUqj/Ss=;
        b=l7BYWCjmy6q33iC+TjgfpwsrsqjANThFSCeVAoiizvV4YKevACc2WgwMIFTO6MAmlF
         VmJC8H/Xh0n6DQmriKQbFJnyIQhvm9F609mhGNYC/RtXbeBjmsXop+WlpgNfDsX/z/O5
         vmImMG+gV6vmF5AgEBojM4aS7GEBc/nIEJHvZ0YMgJGjswUO4A1W18tI/YFv6kTM8jKU
         63yKjl4g5nD6lwixZx9sNWWhduRukdlLP0GWJuWUjQbgpTx/0E7JD1q/gPn/f/xRjvgb
         t4cNNH4BrkRUbpq+dz31Bo/aVUdd1XPwegl2KOvviAsZmk3tRUHpawLdnfH62wmwf5L9
         VzbA==
X-Gm-Message-State: AOAM533eI+/R5r/8psw83I7clX5RVdfOr8Okdv/ePkF/i7fdjY7reLdP
        yXo2vOdLFDLgQ5sqq2LklkhEztCe34cZjEc7
X-Google-Smtp-Source: ABdhPJyzh60TWfSH+WZdScyDPOUrqCjJgek2AufOFTeK5U81v2rptIDdX+CZYSBKt7c4dlcnCkUqJg==
X-Received: by 2002:a62:7c4d:0:b029:289:d38:d1be with SMTP id x74-20020a627c4d0000b02902890d38d1bemr38317140pfc.23.1620871700889;
        Wed, 12 May 2021 19:08:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n20sm831493pjq.45.2021.05.12.19.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 19:08:20 -0700 (PDT)
Message-ID: <609c8a14.1c69fb81.3339a.3ff6@mx.google.com>
Date:   Wed, 12 May 2021 19:08:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.35-831-g77806d1ee43e1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 156 runs,
 1 regressions (v5.10.35-831-g77806d1ee43e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 156 runs, 1 regressions (v5.10.35-831-g778=
06d1ee43e1)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.35-831-g77806d1ee43e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.35-831-g77806d1ee43e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77806d1ee43e1bea3aa5095445eb7a69f02ec8d3 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c5714901f4a0f03199280

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
5-831-g77806d1ee43e1/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
5-831-g77806d1ee43e1/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c5714901f4a0f03199=
281
        new failure (last pass: v5.10.35-300-g4edc8f7e8676) =

 =20
