Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38453749BE
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 22:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhEEU41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 16:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbhEEU41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 16:56:27 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4958FC061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 13:55:30 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a11so1811557plh.3
        for <stable@vger.kernel.org>; Wed, 05 May 2021 13:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OGZGGkFMpM5EdRMXyRx95iI26SCZO9G6p/BrDLpbR8o=;
        b=ngqHMWFo1pQ3VU1Zpf2ZjzqbumrNlQdv5I09lQIrhO6nZBTZcZpllgZvz2JJDdiIm1
         oZJS9G8p0UMAaJZNkcKPDnzcTZv9ps8sSeILVrlwuxBkw53dL7O3KUUM8/bgKplX5bVr
         gzsvq+D9VClj6W14eWdF5uJZ3NODbd0hYrBDOfli2BoTIPtXLhuegnpWujobM8XL1U5H
         lHWFrtDymRe5EoC9UVHdTOoLgY9FZA0Ecz/1dvGctT4tfxLAM7DOZ6QbYQHx1incfYP4
         Tnc5OOQJ+MHraL/IYZJMqNwJ1ECPfPMUPxSvJZMUkyzmmEA0s6CqgOebKGqBydOemGaX
         iIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OGZGGkFMpM5EdRMXyRx95iI26SCZO9G6p/BrDLpbR8o=;
        b=tvZ6Zps/XTTiY7EJ6GjziRxhjK0u8NeBht9PT2dncMiHP5feXzdW3oTznEa8fxWCFc
         214Po4UgMdlB/Lp8PCiiUgMJQBLYwlU5LlGqN98ryF7op7nwF8gtNmzUFDiXqLPLO9S1
         r0jeTN8VY51ci+nu8S6ddbiTVPPjaD/GOA0JXBJMWEZksNLMklPp8S84FneMsCWPMnC8
         K7dxTxD0kW0E4MYUijyKyxuW0nPlUaedT222vdm+rIPsQttrtwu1xsWgProjK0OdmVcY
         WLANuDgA2XVJ0KhENwBfKImVyD/qwNoCT0oMYchT3q6YUbHwJMYXbk1h6DxbvgyBdiWa
         Ho3A==
X-Gm-Message-State: AOAM532jSxpux/1OJhZ+QJTLSavUtlOt5EFpwEDX5uYdMIkWHsFVmgDt
        h5ZY64/MRuXdlCHhMXxYYnnZeY8GdPlhAa9R
X-Google-Smtp-Source: ABdhPJyYXe5c23TLNN7SkMrnM9gM3gDjBEAq9lLl0Lxexow+o8+gzRfTTGccqkn6VsnB3T8NYuXv7w==
X-Received: by 2002:a17:90b:4908:: with SMTP id kr8mr13164943pjb.85.1620248129637;
        Wed, 05 May 2021 13:55:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n30sm129736pfv.52.2021.05.05.13.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:55:29 -0700 (PDT)
Message-ID: <60930641.1c69fb81.a4ae0.0aff@mx.google.com>
Date:   Wed, 05 May 2021 13:55:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.34-29-g25b7f8da39a32
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 85 runs,
 2 regressions (v5.10.34-29-g25b7f8da39a32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 85 runs, 2 regressions (v5.10.34-29-g25b7f8d=
a39a32)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.34-29-g25b7f8da39a32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.34-29-g25b7f8da39a32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25b7f8da39a32919626c2b98d209cb5d4f5915c4 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6092d27bc4c0b0794a6f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
29-g25b7f8da39a32/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
29-g25b7f8da39a32/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092d27bc4c0b0794a6f5=
468
        new failure (last pass: v5.10.34-6-g4912ffb397b5d) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/6092d4b477509a5c346f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
29-g25b7f8da39a32/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
29-g25b7f8da39a32/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092d4b477509a5c346f5=
469
        new failure (last pass: v5.10.34-11-g3bd7cccd637e1) =

 =20
