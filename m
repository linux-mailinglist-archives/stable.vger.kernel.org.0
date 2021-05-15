Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF01381981
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 17:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhEOPKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 11:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhEOPKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 11:10:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D625C061573
        for <stable@vger.kernel.org>; Sat, 15 May 2021 08:09:27 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k15so1404547pgb.10
        for <stable@vger.kernel.org>; Sat, 15 May 2021 08:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tsi8G/SDst6dGYVDAuciJ/cyuv6/RshtMqLnjaqjY00=;
        b=cb0pL0kSQg54WOUrJWExggW0iS+TE2q0KYFWgekmcLTMZICKLc0SnUbXk32gRVKA3w
         1zYERl7+Rf6sjCMeeKgYMHgDMmahB4dyIQYSxA2nU4IvD1K8Bz+i7rA6Hte+wfm9eHNn
         HO+LT/hySrtgZwF0T+3uUwvvr7GQygSsHZXRQ8adBt9q54gpo0DO0FTlLXPVpZ/QOS7p
         mMFbyJyUvTUb2mhC9NOsayJukaNpdVvlOeCmvkvW89TLwh4ziE/NGm+vjKBqjDcjj8zL
         oD/FGQMYXSX58XFQj4Zt4F3+jNVOIj5KLV4XH1zgKe+fCJXl9k3iwM2myFC9AxB+WtqT
         Bq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tsi8G/SDst6dGYVDAuciJ/cyuv6/RshtMqLnjaqjY00=;
        b=BrV03TneijkdmTy9oLP1kIBmbt9EttEyBsfNnZ1srDUFOtXm/Tn83+b+QZah95gewn
         xCt++v5POvNUcPPjfcoawjlfuYQn60/SCSffXkA79w+hXA3H5gmyr1VEQ0SK1UIw0G1U
         iJWmXdlulqPrDwf5A0c11kM7J3yjztl8gMwCr0jWa5cRVup492h0H+yN/V9SztjskYVT
         F4pRVAylOKEvs2LmhqQdGUty6tkBILSpLA55vVxuOgc9lZjEVAZ4YM/hhGK0oRuONM2T
         wtHeFSBZ7fg8nRXksvvGITLTKTSiuoyL1yXh+G9U66x39OgHS1OsJaXA6oEk3YjR1Zcb
         NH5Q==
X-Gm-Message-State: AOAM532/CPtKgbymlM03tImEdjbsMOq08l/QdG0xQ29ZAoup/HyEveZU
        p7zMjeie3EIB4g3sXTRV3wqUvSN+aYM1dH7/
X-Google-Smtp-Source: ABdhPJy/K0FLEB6xT9am9y5O8WBwftM2KCyNU+gYhXaMnsmF3nFL5mAmHB2/ga54DDmjje7rf5PMuQ==
X-Received: by 2002:a63:fe0e:: with SMTP id p14mr30619222pgh.116.1621091366540;
        Sat, 15 May 2021 08:09:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3sm11369251pjw.35.2021.05.15.08.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 08:09:26 -0700 (PDT)
Message-ID: <609fe426.1c69fb81.86284.59bd@mx.google.com>
Date:   Sat, 15 May 2021 08:09:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.21-229-gd46f592c4fca
X-Kernelci-Branch: linux-5.11.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.11.y baseline: 111 runs,
 2 regressions (v5.11.21-229-gd46f592c4fca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.11.y baseline: 111 runs, 2 regressions (v5.11.21-229-gd46=
f592c4fca)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.11.y/ker=
nel/v5.11.21-229-gd46f592c4fca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.11.y
  Describe: v5.11.21-229-gd46f592c4fca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d46f592c4fcaf3916871ec7119a4ff5a8aa30d3f =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/609fb088e3872fe9beb3af97

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-229-gd46f592c4fca/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-229-gd46f592c4fca/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/609fb088e3872fe=
9beb3af9e
        new failure (last pass: v5.11.21)
        1 lines

    2021-05-15 11:28:50.376000+00:00  <8>[   15.321259] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-05-15 11:28:50.377000+00:00  + set +x   =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/609fb49a2190fc9d30b3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-229-gd46f592c4fca/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-229-gd46f592c4fca/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fb49a2190fc9d30b3a=
f9f
        new failure (last pass: v5.11.21) =

 =20
