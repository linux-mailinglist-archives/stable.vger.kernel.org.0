Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0DD2FC2A0
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 22:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbhASVmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 16:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728536AbhASVil (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 16:38:41 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92561C061573
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 13:38:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j12so777776pjy.5
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 13:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZbbyGs7iIoJS/k7h0H2Fc3qVc6tOSgghNCz3g81begE=;
        b=K/Dq/EGYUdkC7J2oHzJP8jGtcvtUa01ESKwl5rvjNUG1FM8m2atgg93A46Fu9Y3KZ+
         BGp8hCB7gSBadiDGIegUdFVwAcsNpRuoUGBj3l+IsTQvztjmP2OclA6RpEEtEQd6h887
         3oimJzRkLzSG4Y9bJ1YHPmLmHDaKU3gylnvEZeVtF5kCss/wo8EOU0BkFPxflKboqkYa
         sPiElNdIbhoOgLhirq11jaGnp63iWH4eH1YdMGgy9J2vOitusjWhHFqVCvvs4yOz+ILf
         VS5neH8/pRcC5OKSJQTqXAUAIpRkf2Gs+70l6Do+zK3ukM3AePRmeXIBGSwj3xvBVqGx
         q/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZbbyGs7iIoJS/k7h0H2Fc3qVc6tOSgghNCz3g81begE=;
        b=qwLsVJCFl6S047yBhVux/aiTN05zKT8P5nDbEEO0IkD6XCTucAMAP0Y5ces8WmxIpn
         ZiArjpoY7vWSl2s1lq67qGaJWk4grocstFIS0xkTf+s6at4HR2aQvGhcwqcs6n/+5nXy
         thexZk5OZoo83h3bKwMdXnlniay03rpCiAMhxtuYJsBGmOazltPFbcZAAfcM5fRHUmrl
         Nw5Gh1HG0VTyHZWePnp+bZQSTMozInqrx6a8kcvgcn+NrRDeZ/LEXXNE1PR+SjYHn0bp
         LAg1ciRh3vCO6W84IO8r/pEQrO8Mr1K4fJuO2HPW511Tv1VEmzi9wh1bU/nvRkdzD034
         32GA==
X-Gm-Message-State: AOAM5336SQZNVYi7fhfIBQZlvpwhao834lulWNtLC6iTtuQZSS1wXcqP
        +AMSH1tJDMR+9mseCXGMjtCxASYtZiHMpg==
X-Google-Smtp-Source: ABdhPJziv89LRmlxMpwBdpcO0QXic9i7vgRyafndKqLOOvzc/5wfKhiDBRbdmmA3lrE8xGx+IxA+Kw==
X-Received: by 2002:a17:90b:3284:: with SMTP id ks4mr1851187pjb.216.1611092280840;
        Tue, 19 Jan 2021 13:38:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x28sm58638pff.182.2021.01.19.13.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 13:38:00 -0800 (PST)
Message-ID: <60075138.1c69fb81.afac.03d6@mx.google.com>
Date:   Tue, 19 Jan 2021 13:38:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.90-75-g5e19c52a8c0a
Subject: stable-rc/queue/5.4 baseline: 183 runs,
 5 regressions (v5.4.90-75-g5e19c52a8c0a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 183 runs, 5 regressions (v5.4.90-75-g5e19c52a=
8c0a)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.90-75-g5e19c52a8c0a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.90-75-g5e19c52a8c0a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e19c52a8c0a3fa633d6a061e52fcbe61bfc8e69 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600718d17525725ccfbb5d0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600718d17525725ccfbb5=
d0c
        failing since 66 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600718d9965bff061dbb5d0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600718d9965bff061dbb5=
d10
        failing since 66 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600718b9657fe1afc7bb5d32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600718b9657fe1afc7bb5=
d33
        failing since 66 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6007189e647d2c082abb5d25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6007189e647d2c082abb5=
d26
        failing since 66 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60071884b7d18f6b64bb5d15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.90-75=
-g5e19c52a8c0a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60071884b7d18f6b64bb5=
d16
        failing since 66 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
