Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520545F4AD2
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 23:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiJDVUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 17:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJDVT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 17:19:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378AC1116F
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 14:19:57 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i6so14219781pfb.2
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 14:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=tcT/JD/7HyFtGR8TTinHAztVcULc5v2ugRG6yMsCKos=;
        b=RaKCeMjPtldCw4pDGrNxIbxX6y1Yn4vmddcsDfcImxFreSTXMRvslSDq3aept12SGj
         bEL1uAXF4sMH3YTjKbzUas/97m2TLqEkkPr+AmpQmlQEoMspGZMv9WIJs5WHBtLHa9Ez
         Cc3w4Q8dMztbFgmuFmw1A+J9aCGQq9Hguk6Z81vroVZtknakLE91uC5Q/+DFE6lqtoJR
         mP5+rCi8B3wE/dFvu8sxHCd3ZMVU6oDoKHokkXL7eBsM7qTHW2C5eGJ5PTDR5U7bys9v
         9BMo0tePMP0ok4I82TVyO1Yag8z84R8Jfkyl5PN88EuKr0zjMtAvRzauF6rsOcavrlun
         1HEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=tcT/JD/7HyFtGR8TTinHAztVcULc5v2ugRG6yMsCKos=;
        b=ZbAyPfeqm8iz+RiA8XeSROiBQXPJ+otqF3Gquk9EPbqHXQu69BexyH2xpd5u4N4N9g
         tdtgTezQX8IF9QhdisPqGY+MHUF9bkcCvWnZ1SCAs6GkedhT815kO6w7+5JVAJC7/dOg
         8hQODFByTEktO6ddczmaSdIO9w+Keng1ZxprkDnLpVKMr4lTC6XcslB/NJTorzBef3SZ
         /maxvPUazCERUiTTQx1f9d7qgYuTaORTcRjmsprnc9kSSH5oZBUKDf6MneZ1vgMLd33T
         AK9lJgi92/DAxKSLspffP3L8K5h80cD6WSn6FXRCrKULR2vZsqGJq4I79X8EsbyMkrTg
         j/DA==
X-Gm-Message-State: ACrzQf2f9A9ct2dbVOUlNrE3LBVKqfmBGdmv9WnphA/3fXepf+XxqTcd
        HETGp32zLB8Dz30QS0aQQYcChazAw1JPK61tL0A=
X-Google-Smtp-Source: AMsMyM4WgLGPrd8FCr33WhWTko6ux47+1kor0ATSv7dCcfUOTohGc5fdkwLCqdchPA339XVgCNu8vg==
X-Received: by 2002:a63:4e16:0:b0:43f:3554:ff9c with SMTP id c22-20020a634e16000000b0043f3554ff9cmr25160157pgb.578.1664918397218;
        Tue, 04 Oct 2022 14:19:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3-20020aa79d03000000b0055b674dd134sm3436440pfp.29.2022.10.04.14.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 14:19:56 -0700 (PDT)
Message-ID: <633ca37c.a70a0220.32e38.626f@mx.google.com>
Date:   Tue, 04 Oct 2022 14:19:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.295-19-g14a826f46e651
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 36 runs,
 3 regressions (v4.14.295-19-g14a826f46e651)
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

stable-rc/queue/4.14 baseline: 36 runs, 3 regressions (v4.14.295-19-g14a826=
f46e651)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre  | gcc-10   | defconfig=
 | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
 | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.295-19-g14a826f46e651/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.295-19-g14a826f46e651
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      14a826f46e65185c2f6407b7d3c2ac8d209ec7a3 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre  | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/633c71135e4005e1ffcab608

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g14a826f46e651/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g14a826f46e651/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c71135e4005e1ffcab=
609
        failing since 91 days (last pass: v4.14.285-35-g61a723f50c9f, first=
 fail: v4.14.285-46-ga87318551bac) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/633c719165f127c4fdcab618

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g14a826f46e651/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g14a826f46e651/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c719165f127c4fdcab=
619
        failing since 168 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fi=
rst fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/633c710ba4ca2455b0cab606

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g14a826f46e651/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g14a826f46e651/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c710ba4ca2455b0cab=
607
        failing since 70 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =20
