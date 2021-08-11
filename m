Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86123E876B
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 02:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbhHKAqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 20:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235662AbhHKAqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 20:46:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34278C061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 17:45:50 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a8so732822pjk.4
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 17:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+RzP1jSdNyRoGYcATwjMmLEJbuVgpBKB6la1yR5Woz4=;
        b=gl2C37eqxLH4NoY1VyoXrBC4pImgqVgn8Ud29k8fNqI5ZXU3SfaT/hCNHzQzGSi/U5
         XrU8Z3NS5FOfwP1MkCX6Z+fyUzDHagtKJtFi5SVCxIXGaUKBAu5EULEgo8yU1PjRu+yE
         DozfKysiRNScp0PAmmXD3/mpjOgY9YnbhdFDLKISaWmPV02PCvYH14aWJNytYQw+FFsQ
         LbuY37Oz+Q316A6yc9WZCrx4zlXpVsCH4P8gtnmICnIRIlm5IXRQKrTfaDnzO//oUY8S
         0kSHKbWHZYlvLiP4DmRSVZMGUQGB03soU5Ze2hxiGaxbWl6Xf98TsJYTl3FX4/ArgnHp
         YX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+RzP1jSdNyRoGYcATwjMmLEJbuVgpBKB6la1yR5Woz4=;
        b=rdCjGZJLRrrg0yaeKSWAoFxMbWuc9uP5ndPRsftoj/i4yvyibqhF5jEtoC7aKoAxS1
         fwHFh21lI2sROeNBnK3pJPfJuD1fyM7CTanMAmoUv3YUslbRam/1RPh7f9MXnMEKCUCy
         e8XWC2QFRttbkUowJ+xdM+uEzpnMylXSwuPsgzVTHrWacT7hfeIeQFPUQaWNeD0KfQNu
         enU4qGRAx9X9hXefzdvHGkYr81TxCkMzq7gBo8rlNln/ZmghbVJTVjmiyCHtgY0opENE
         We6/Dl9dzUi8v0C0J133wsuy6oJkPQZsjVurNDcgGEPTYD03KJhgXAt+DaCipEjZDmr9
         OqQA==
X-Gm-Message-State: AOAM532eI6T+yHrHQpty+SHbJrnt7d8NDkn24QoZQDMjidQCD78BFhb9
        dUuEvNvNKya+V6c0TmGHI1IL6HN9i++dSJqS
X-Google-Smtp-Source: ABdhPJx3Y+NjpJ/yzMye83OMMdJoY76UTq9+uLbgy+OmKohJtgvn+oTo5g04oLQ3Q0vBGsNW3Kwtyw==
X-Received: by 2002:a17:90b:297:: with SMTP id az23mr6510620pjb.17.1628642749611;
        Tue, 10 Aug 2021 17:45:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a2sm13527521pgb.19.2021.08.10.17.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 17:45:49 -0700 (PDT)
Message-ID: <61131dbd.1c69fb81.594cb.7cc9@mx.google.com>
Date:   Tue, 10 Aug 2021 17:45:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.9-175-gb24f24a201cb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 156 runs,
 2 regressions (v5.13.9-175-gb24f24a201cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 156 runs, 2 regressions (v5.13.9-175-gb24f24=
a201cb)

Regressions Summary
-------------------

platform    | arch  | lab     | compiler | defconfig          | regressions
------------+-------+---------+----------+--------------------+------------
imx6sll-evk | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =

imx8mp-evk  | arm64 | lab-nxp | gcc-8    | defconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.9-175-gb24f24a201cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.9-175-gb24f24a201cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b24f24a201cb2cd94374cc73d4b48903302a2c72 =



Test Regressions
---------------- =



platform    | arch  | lab     | compiler | defconfig          | regressions
------------+-------+---------+----------+--------------------+------------
imx6sll-evk | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6112e99aec04790e95b1366b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
75-gb24f24a201cb/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
75-gb24f24a201cb/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112e99aec04790e95b13=
66c
        new failure (last pass: v5.13.9-175-gb1f8c3465c52) =

 =



platform    | arch  | lab     | compiler | defconfig          | regressions
------------+-------+---------+----------+--------------------+------------
imx8mp-evk  | arm64 | lab-nxp | gcc-8    | defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6112ea8c8549720e22b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
75-gb24f24a201cb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
75-gb24f24a201cb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112ea8c8549720e22b13=
663
        failing since 4 days (last pass: v5.13.8-33-gd8a5aa498511, first fa=
il: v5.13.8-35-ge21c26fae3e0) =

 =20
