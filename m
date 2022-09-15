Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFBF5B9A5F
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 14:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiIOMIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 08:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiIOMIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 08:08:07 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506997549E
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 05:08:05 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w20so6068527ply.12
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 05:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=qfLwhO3BRzWWrRufJ1gWLfT+gYvjH7oGnwjStWFwlwM=;
        b=pRzlO7/VBXzbmRMbwyCk7R8luNixPSF99UzRJZXlYN6FaKXqmMuAai42E5tNn4Ru94
         g2KN3e3VQVxO/04Q87D/cDyVK17GtvzMzLaKq9KKyGtYGQedVrc2hBMWz4PWk+zX1lOl
         xNIdiBUUIVZs6F4Gb1hBr28tnC8f6epd2kGv/YkHORarcMOA+jd0/m56odtZMonTYr5T
         OkyTtc1DdD+sUVtf8eu0CdivlTeUi+vbD3pn0fFNpMlfPKvYEMUWxbbJnnUORKjo4JeL
         PV8G7zQdtHZFWrW+TtWJ9hbZo0rVca9b2PYKEcK8enol05+rLkuTLBJwSkIaLEyjWlyX
         ZaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=qfLwhO3BRzWWrRufJ1gWLfT+gYvjH7oGnwjStWFwlwM=;
        b=4Sae83iqd2qgyZQ0B920+MrERoCNHNKVT1ZOVP0CsnBiFlb4+oOy/lyHbGibkthR2k
         McQgfQUBAXy8KT4p5Ftk/YPdN4hjTAxmPWEGWOxoJvdroqrt/A2I/Nmat+czcMA5/mnh
         l9F6ww3dJqHuSp1ZUkPstVwBMBoA7Vx4sUgGJkNx3TxuAMfep6wUzPk103M0uVpkpxy2
         6yJgNYdf5DLdGoZer9UIbPnmIShlMj3BdaWI5g9BVRaZuUAW2oXLGthaFttKZUInglLR
         gC6/XTEMg3yPWLFbhKhTe1jTvWzMWt8osrHnFWXHNEUTkgxmvDyd419nNqGuNyvv7+X/
         D9MQ==
X-Gm-Message-State: ACrzQf3gcQpp2LxYbrMUKzE8k3XsLEK9iQ7uvtmPcI2ZKZAwIhHYnvKU
        t4bL/vNSG0KesJMd+aLcZw9D2ZCEKQg6kb9bw6Q=
X-Google-Smtp-Source: AMsMyM79PvUHYdt829G9Lmh0LKaj66MTtVYfEp7+SjZ23m86DVbKcL/1e/6n2TSEBtqj3KT7U3EsxA==
X-Received: by 2002:a17:902:f70f:b0:171:2572:4f5e with SMTP id h15-20020a170902f70f00b0017125724f5emr3915769plo.40.1663243684589;
        Thu, 15 Sep 2022 05:08:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m127-20020a625885000000b00546d875a944sm5122025pfb.214.2022.09.15.05.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 05:08:03 -0700 (PDT)
Message-ID: <632315a3.620a0220.23a66.9b4e@mx.google.com>
Date:   Thu, 15 Sep 2022 05:08:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.66-118-gc5dc57eebeef
Subject: stable-rc/queue/5.15 baseline: 203 runs,
 2 regressions (v5.15.66-118-gc5dc57eebeef)
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

stable-rc/queue/5.15 baseline: 203 runs, 2 regressions (v5.15.66-118-gc5dc5=
7eebeef)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
beagle-xm           | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig=
 | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.66-118-gc5dc57eebeef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.66-118-gc5dc57eebeef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5dc57eebeefe027f8c3073b5c94eab9c765dd48 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
beagle-xm           | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6322df579faa84370435564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
118-gc5dc57eebeef/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
118-gc5dc57eebeef/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6322df579faa843704355=
64e
        failing since 168 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6322ef645dec7b4d13355717

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
118-gc5dc57eebeef/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
118-gc5dc57eebeef/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6322ef645dec7b4d13355=
718
        new failure (last pass: v5.15.66-119-g781f01e9677c) =

 =20
