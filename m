Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6C341538B
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 00:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbhIVWmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 18:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhIVWmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 18:42:03 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1BDC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 15:40:33 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id e16so3983559pfc.6
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 15:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U8XN3+C8nyJriD0dTHPeChd4irhBM2M8UTdsDdCY8zs=;
        b=qwZhAKsZ78xpXRYGWBLtPlgahd7Mu9CfqofbOZP4ZZXVtd3pKHt3ujxoY0ZZClCBMc
         xLRXsv1oWeDrpC0v77dplNejdBP5n7w1OHRO+nXxUxmcw8Kzk2IepGqbdJdk+60JBVE3
         hiuC4Iczb71DRwXNJ4/NaKxuCxDHX/a+JsHuYhya4ZopIcKtLeP/Y3WJF9sn1CkmIupA
         OOxVDEgHKpAVz6dqr7OZ0ziNKZwsoDqayRWuLHodJGvXozf20xm60ASlRlh/LluUW3OJ
         2HJnSGMHHk7fugG9hStAWrhWZcc8hnpFR+wL/JOty10qOxsAjXruzFPVJtvlcBZAW6XL
         4isQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U8XN3+C8nyJriD0dTHPeChd4irhBM2M8UTdsDdCY8zs=;
        b=3Qr/tgcY7/EKXjo2Cjr9VL7W6nTIdPKIRniLDP6oZjlcjtABCaO5yZxWfkp5omU3He
         99OXOOKVKEeKF9whFDPpmeEa+U3+1FCdVpVgNE2zIAhsSEf1vWVM5gXOpEkYbFHH0eO0
         NOZYyhTtJWwuLb3v1AV7nRz8WjKjAOxypih3zqwDFz767m2ZiyLcjmkEGZ0nKBpIjMsI
         8fWVzxGSD9LkFhRVtyryPnCE0/r06nOtIukPk3oKuBEVZQcwUKp2bn3AySjbseVEjkgi
         cNAlBV9rLed8wG30XSWx2DBMCIzh1/yDsHR53AKTZ5tw309w+x/ZifduWejwXkuLFcb3
         BMMw==
X-Gm-Message-State: AOAM533jetnMHVKE9c3dINXxEnNCFZ66SCDmqCbcvD4SoEciINWsS1I0
        CiRPopAUU5DbIs99mDKiBwjbSVFSr0DIolQM
X-Google-Smtp-Source: ABdhPJwe/dxIGyk7aafkW6ZGyrFs+cgyqF001tFNV1mPZw7WI1sxGMPQeHzJ08PfcXZ5hqfsp6mv4Q==
X-Received: by 2002:a63:b252:: with SMTP id t18mr1237307pgo.14.1632350432670;
        Wed, 22 Sep 2021 15:40:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm3803072pga.23.2021.09.22.15.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 15:40:32 -0700 (PDT)
Message-ID: <614bb0e0.1c69fb81.fa308.b2c2@mx.google.com>
Date:   Wed, 22 Sep 2021 15:40:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-177-g6b230604d6e1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 76 runs,
 3 regressions (v4.9.282-177-g6b230604d6e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 76 runs, 3 regressions (v4.9.282-177-g6b23060=
4d6e1)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-177-g6b230604d6e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-177-g6b230604d6e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b230604d6e1cb8c60d8f4b053bf9b89d8aff294 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b8b11b083cd3d0399a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
77-g6b230604d6e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
77-g6b230604d6e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b8b11b083cd3d0399a=
2eb
        failing since 312 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b78804b03e0db6d99a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
77-g6b230604d6e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
77-g6b230604d6e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b78804b03e0db6d99a=
2ee
        failing since 312 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b786d84e28d57d799a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
77-g6b230604d6e1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
77-g6b230604d6e1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b786d84e28d57d799a=
2db
        failing since 312 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
