Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B821220418
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 06:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgGOErk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 00:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgGOErk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 00:47:40 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D237BC061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 21:47:39 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id j19so2334589pgm.11
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 21:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XPC5dCUCIaB5TJaXT3hx/Fp53Y9ttvKOw7W3CxEtolg=;
        b=LGCbfQzR3FOD48/vJv41PO5FBXHfDEmxPtKt3jWKvaYlbN2dzwVYObfUhzV+hwkPFT
         9dSSWUV5P/poJwNstrGd2PBeDQ3v/MKGfHpl7L0GfSBZPAz1YYnA/bab6xpxgYmHzYKM
         oEftt4vSTeQO0mFI+n2wZGIgOc1xb1GyNYNNlU48cpZb1Be9OHab8CTo8VL1IIippaRg
         iuN56CtFRB+2DtoS0pSZeOsBpBEl7aj6f4rpNLAImDeGgDH3JzjbmuWzNjLjhYdscTFf
         Q7hTbk4dwCBfoIU3uIv9w0JR7H9A/C2MCU77ddpxyqt+cgWGtm8WnkiU3B4Tn9kprN2G
         hqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XPC5dCUCIaB5TJaXT3hx/Fp53Y9ttvKOw7W3CxEtolg=;
        b=LaEv/YYpWNaO8cRjIcxUH0P3XosfND4oPs3uHtO+Moh36Ra3QdYbDuN64HLaQCNwzr
         sbXDcyf3H5l8SexaITYgjLFFZWC9X9StAuytORd4UIy6bFb1+vqgEDw022gFvhgw5k9B
         RzPhxL2QWVx7F2H2dZVqPEPMxD1D/b/ffrlwEBhUTq7ZaU6gJ5lve3RrRADVjdmBeSHm
         SmbNUYJipy+kzcoIBiAmDExCXVkT7G3ak1W6PvMF48WxuT5nr+fCt0f9y6gSC9+VKaNZ
         aCVJP1cDDigTDSyyrIcbM20g15YkRTFshoObTJJCjGxcAJO0fqV7csPpetGaVnu2ntKn
         Hq0g==
X-Gm-Message-State: AOAM532E0Ad8ETuW6aYQDoNBgBBJ4+5fXZp/DhLhbzWkU0W+QUI+aWhL
        PHv28FHWUF6l0mO/u7Bu0PxjX26LcUo=
X-Google-Smtp-Source: ABdhPJyQ9sj0go7y/pI3+9YdIo/iEDklwd2TgNz87JITRJwvXifFap/yn1INDkiNpBVWf3UXUnAmVw==
X-Received: by 2002:a63:cb05:: with SMTP id p5mr6763026pgg.120.1594788458598;
        Tue, 14 Jul 2020 21:47:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm655511pgk.93.2020.07.14.21.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 21:47:37 -0700 (PDT)
Message-ID: <5f0e8a69.1c69fb81.a1a6.2f06@mx.google.com>
Date:   Tue, 14 Jul 2020 21:47:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.51-110-ge41ac96492ed
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 112 runs,
 3 regressions (v5.4.51-110-ge41ac96492ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 112 runs, 3 regressions (v5.4.51-110-ge41ac=
96492ed)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =

bcm2837-rpi-3-b              | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =

meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.51-110-ge41ac96492ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.51-110-ge41ac96492ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e41ac96492edd546629b9fefe57c4f3c9415643c =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f0e542f851305568185bb2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.51-=
110-ge41ac96492ed/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.51-=
110-ge41ac96492ed/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f0e542f851305568185b=
b2b
      failing since 94 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
bcm2837-rpi-3-b              | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f0e56582f07b4deb985bb37

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.51-=
110-ge41ac96492ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.51-=
110-ge41ac96492ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f0e56582f07b4de=
b985bb3a
      new failure (last pass: v5.4.51)
      1 lines =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f0e5bfa29905d842e85bb2d

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.51-=
110-ge41ac96492ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.51-=
110-ge41ac96492ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f0e5bfa29905d8=
42e85bb32
      new failure (last pass: v5.4.51)
      2 lines =20
