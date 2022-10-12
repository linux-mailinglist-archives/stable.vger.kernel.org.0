Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA275FC12D
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 09:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJLHVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 03:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJLHVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 03:21:18 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3DAA8CF2
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 00:21:15 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bh13so14862608pgb.4
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 00:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Itte3CQLZ7TYsdt1XanqnQFPGE3e+OL4xuDZzkBcd5s=;
        b=J5eElxRRHmjutJBtatN2Ne+Aoy99XYqppK/PL990mUbAQJWrpT0gkY6hw2UKvSrJur
         RkW7xjmnAojf9vNQDU9YxV+C0zgA24T34n+RYpfNNBXZIhn+sD6cQZRdOOGQUNsWRFUK
         oZml95q9S+hZwIPBiPjiNMu1bvXfYZtLnhF2Cw8upXlq3CNSQEPNsPk0YzsPdk6imaoy
         KDz9fYe1FRjrffjrrFe2nO7ZWIsCZTxGnXD8aY0zllzvsbnYiLn4s/fTbUTL2jbfwz+b
         gDtl1qMybgTHcvAwLl8WfCz/igp49QVyeTFcxQn8OSQfGPNzblHDISz3WDUgFh7ueIME
         9ZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Itte3CQLZ7TYsdt1XanqnQFPGE3e+OL4xuDZzkBcd5s=;
        b=vN2t6sB/SFIeWxwFEaQBVH/okhgH0Ztu927gBC1SHpCq0W8f7/KBVJYu/XSDmLf2pK
         G3RcHScX/hTd3hxuc2nx3PnmxcKxQwbT1yoTeJIDV6dm0glQKWa74qYJq8ADrmF7+EAT
         kAN3EzkJdWAhOu93gOB/XTrLMIrGzD0J9F2R13d0sOEu+YrycVMWKCZE0+Ci5x/FBCiP
         8IMK6QJb9MpiPlx2rZ/krVmIKguD5m7DHXSw63EdFoVZjG8tNSFTBLZrdQh8L9zH4Ryu
         vW9LLJJAAyq6mjwNuM5nn0NapCacMEaOVwiKsCakF/xU8NuL/guv6OfTmHH/UOxJN+tE
         Kweg==
X-Gm-Message-State: ACrzQf1Gxvunqyh99045VeAh7JBu4NtBQfOOXdlvhB5ryU57tfon0ReW
        fLkflrICOMbNq4nCZo7v8ZVXXPUI0bdssC0bpLc=
X-Google-Smtp-Source: AMsMyM6OXwNhy/SLTW77xa4tQRdBq5poTk1Ygr8ucvF8/K6Zb/Ttq70C9gcIDcm5EEULej8pKwDy7Q==
X-Received: by 2002:a05:6a00:1390:b0:562:e518:9920 with SMTP id t16-20020a056a00139000b00562e5189920mr23452817pfg.54.1665559275213;
        Wed, 12 Oct 2022 00:21:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y198-20020a62cecf000000b005627868e27esm10203058pfg.127.2022.10.12.00.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 00:21:14 -0700 (PDT)
Message-ID: <63466aea.620a0220.885cf.1d66@mx.google.com>
Date:   Wed, 12 Oct 2022 00:21:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.72-36-g40cafafcdb983
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 163 runs,
 4 regressions (v5.15.72-36-g40cafafcdb983)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 163 runs, 4 regressions (v5.15.72-36-g40cafa=
fcdb983)

Regressions Summary
-------------------

platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
beagle-xm   | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1    =
      =

imx7ulp-evk | arm  | lab-nxp       | gcc-10   | imx_v6_v7_defconfig | 1    =
      =

imx7ulp-evk | arm  | lab-nxp       | gcc-10   | multi_v7_defconfig  | 1    =
      =

odroid-xu3  | arm  | lab-collabora | gcc-10   | exynos_defconfig    | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.72-36-g40cafafcdb983/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.72-36-g40cafafcdb983
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      40cafafcdb98351ccaa30949bf26b25b19c757eb =



Test Regressions
---------------- =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
beagle-xm   | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/634638a42bca4f9032cab608

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g40cafafcdb983/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g40cafafcdb983/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634638a42bca4f9032cab=
609
        failing since 20 days (last pass: v5.15.69-17-g7d846e6eef7f, first =
fail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
imx7ulp-evk | arm  | lab-nxp       | gcc-10   | imx_v6_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63463f46c0837db3accab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g40cafafcdb983/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g40cafafcdb983/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63463f46c0837db3accab=
5ed
        failing since 16 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
imx7ulp-evk | arm  | lab-nxp       | gcc-10   | multi_v7_defconfig  | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/634640aef4bcfc0f64cab622

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g40cafafcdb983/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g40cafafcdb983/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634640aef4bcfc0f64cab=
623
        failing since 16 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
odroid-xu3  | arm  | lab-collabora | gcc-10   | exynos_defconfig    | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63465a0bf86e43b6d2cab673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g40cafafcdb983/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g40cafafcdb983/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63465a0bf86e43b6d2cab=
674
        new failure (last pass: v5.15.72-36-g1dafe9f099a1) =

 =20
