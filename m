Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595753B8A77
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 00:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhF3WeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 18:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhF3WeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 18:34:20 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1277AC061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 15:31:51 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y17so3860443pgf.12
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 15:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pvyntMPPZrC81ZximJkMNTs70LmkBjxhK6bluDbZQng=;
        b=HZsoPQNlff0tL5II922de56RCfqj655IRDp1QK+0cGIoJ1+haSEYllbKwzsKMFiMoz
         pWDn56T7RzfH/fapmlTVubRb4mMBGsLw02ZaNPsaDoHm1BPnDUXoRFYVROkIVR/94udB
         milwD7luJoi5or5hua5gHSnx6ry0OI72hJZ1ROnQnNS9Gt2ayPKL0g+mUtivF+5SRobG
         dpCkTI8cYVA5NA4fkDyhMkHCRZWRy8Lx8YAPhbRgw+5dZCJdoOkR+4nPtQX855/1qlWa
         zJvLu7KnFFOJq3wnUs73M/NcNDn1A0MJYIU7iRZP40UIvIp41yi3MWiNhq5pTfwyZ5C+
         C9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pvyntMPPZrC81ZximJkMNTs70LmkBjxhK6bluDbZQng=;
        b=ixVyu/IdQHsOJJNtWFCFEPfS2gFcWeL78t4hsg8RjrX+NRg8l88Vxy/CZ8xYSgKaoQ
         3KaCPZjfyv63qvtsVm6Sd94b3ibhUB81Plh/hlOlcZJlFnH8U8x3VaGTIFsdjZzKRwAM
         HJBOc4EkkwEP8fqIsfYRoTDbPaZ7mCa5s+M9T43qIsQYXhF98MwyibBrQmVodKs0ynRO
         agkBGpuJ7wUk9WZH8Wq7qHtGBNJCamMkYI9wtueR7ab4nuq+JKJLFv73+VZZcGOg7ybt
         5znaDQ/HeUdMmtKkqyBEC1x9Vw0zX2VgtPYtb2u/liz2Nnu3GkkrfyOXa0eUrfywRV7G
         aFCg==
X-Gm-Message-State: AOAM533fqRcSPZw64B8YVOOT7nwqwe6K5y9b3QfN69m4SyxoZ8+HCO60
        365rvsLfpvt97ftxNML5vDfWrl3IYD0mkS0F
X-Google-Smtp-Source: ABdhPJzfc4yNAMslcx6ukWJZvVKvPPiGpkKCwIRH4pH8p0IIvPkIv2wk0pK747H8UuncbC0BQk1QWA==
X-Received: by 2002:a63:4a18:: with SMTP id x24mr35844019pga.303.1625092310428;
        Wed, 30 Jun 2021 15:31:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c5sm23138388pfi.81.2021.06.30.15.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 15:31:50 -0700 (PDT)
Message-ID: <60dcf0d6.1c69fb81.12503.5d88@mx.google.com>
Date:   Wed, 30 Jun 2021 15:31:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.47
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 153 runs, 2 regressions (v5.10.47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 153 runs, 2 regressions (v5.10.47)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.47/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4357ae26d4cd133a86982f23cb6b321304faac50 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60dcbe1113fa75ce8023bbd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcbe1113fa75ce8023b=
bd8
        new failure (last pass: v5.10.46-101-ga41d5119dc1e) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60dcbd313b9bb0490923bbe2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcbd313b9bb0490923b=
be3
        new failure (last pass: v5.10.46-13-g88b257611f2a) =

 =20
