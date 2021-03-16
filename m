Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128E733CC74
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 05:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhCPEPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 00:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbhCPEPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 00:15:44 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E741C06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 21:15:44 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d23so13120515plq.2
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 21:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=56M+9iP6S+8IslOzP0BsDFNZBagYglbsGktwuAkGM98=;
        b=MmIJHBq9uHHE+EU4PM2WAW+afmQaUs9D08U5w2OxhF/EmRc4vQAQNtilUxrN4zy7Rn
         Mm7QeN8ujsK++7FPZsLvcSzfZMIDNuEh0X+R0Fj22PkB59PqwTAJ9/DRcn1kDi5qVK6s
         3HSsNDANFQaNaZTq+IujD8Jhsgd08GGKlOS9Xryir6PozyGl2Eax7+mJWDQcPGsNL4wK
         99xrvIhAPpTXeyehNpdaVjwDofA5RDgzdmFyOI2PE5USmRMj8yoHPuFhmungKkSD3Tqo
         omuKR9xMSTAV+Ec7x8R1rV5+8xLu1YxNfRM9bgBqJ1Mi2AtM3GCA9wDy+P1R7P1vltOh
         qyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=56M+9iP6S+8IslOzP0BsDFNZBagYglbsGktwuAkGM98=;
        b=iMEN1/cgArvzSQy98HhlQRlhI6GyBtFEOcEcvb7AGGPPeq5pIZOk8vFlJAChKDWk8e
         z6pSt7x9N2LiMYY1EhzjgDYPTigMm3krRuvTNkZVElqgpCZLyssdNSUYpmWM2+WqEcg7
         Uc6t+YztetxZiIQowUIL5JEUB9EMdXdTFnyu3RcJ95XB0KShA4ivHCgTHPheZSzkcTsu
         nh8dMhwb9cyKrdzd/Qc2L60ekGaUjey2aF/guOs3n8hE6rNcVVP5lHdpOekZmB3/XEqR
         q2j22e7ZSSVu8m0aL3LS+//85fYr0kPy9zQghOyQdKKLQ/hsbcgGxaWRsph8R0ljMbd/
         U/RQ==
X-Gm-Message-State: AOAM533vbpVbqSFGSOoDg2DqlrysfAwuAfBrgFHNEMf6UanJgQo8pOWS
        7KZvThCd8yKtYFPGIjtRzNclml/TACl8gw==
X-Google-Smtp-Source: ABdhPJyFHPlwuMR9mDoXm+84rMc6gmO4Xb6DumDSytcPIm6KL5CUKicSyvFiBrFUWd3KqjtcisXzEw==
X-Received: by 2002:a17:90b:4017:: with SMTP id ie23mr2770557pjb.118.1615868143182;
        Mon, 15 Mar 2021 21:15:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm1103823pjv.49.2021.03.15.21.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 21:15:42 -0700 (PDT)
Message-ID: <605030ee.1c69fb81.1d602.42ba@mx.google.com>
Date:   Mon, 15 Mar 2021 21:15:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-289-gb6c4038ab5994
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 177 runs,
 1 regressions (v5.10.23-289-gb6c4038ab5994)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 177 runs, 1 regressions (v5.10.23-289-gb6c40=
38ab5994)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.23-289-gb6c4038ab5994/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.23-289-gb6c4038ab5994
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6c4038ab599429cb8ed7f8b6274adc09ca23b80 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/604ffa0d91fce9d7abaddcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
289-gb6c4038ab5994/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
289-gb6c4038ab5994/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ffa0d91fce9d7abadd=
cd9
        new failure (last pass: v5.10.23-262-g1eb3b9211edf9) =

 =20
