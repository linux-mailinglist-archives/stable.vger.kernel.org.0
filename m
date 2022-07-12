Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5FA571AE3
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 15:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiGLNN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 09:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiGLNN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 09:13:28 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D678B418B
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 06:13:23 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 5so7208214plk.9
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 06:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G/A1BbQfC+dLWxDlr3oB7+qwB19f8kXA6yWF8I9ZRJo=;
        b=h6N4DCt4IWHoLnyRAFjF+ikfxZmDz8ZroqgIh+zTuryYI/9UZAG1fa1b/kYn+HPajq
         p8WwFZwaMNVhSxhHKwp+5RvQhnZry/m7k+4xav4ELERP2TPBdHu1jwdxkR5P62XHWTaj
         SSf0tBXNmWwoL/vQBJmUua94eVauIGFcn9qeZ+5rt2/ECwapy5e1sJ8K5vmTe/uzBtT3
         Iaobe+7WIyGolY5sVaRA1H3mZUSQ0LzeJyCBv1G+iaaUAIwRMjkXj03gnK2nvCpAMoBj
         c6P8UD0MCnpqI90IF1TcWhHr4jER2JS0f87s7c2Uq2CGsiq86/qAJEr3Y2AemRJOBagK
         00Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G/A1BbQfC+dLWxDlr3oB7+qwB19f8kXA6yWF8I9ZRJo=;
        b=q47gtuTCdx04XBvMTC+6ZIY6mIHnpcuNFDAQmI/B4ft6itf8sKnGMX2IUfYwiH/DBh
         WVh2ASN4i+NPLZ57YLNvtusG4qk65daq/X2i44/qHOJ8pmALhwehNH6kQTqRBRGwAZE/
         Njb2SxUWGvXHvjARUgVY1Azk7Sil3225F+evA76OTfdXX8tpgDsuw8G1y8ugUHMgPLuh
         10Eqsgv6oesEWEQbqVHw+4n4fBKXtdSNhUdrjw8RT04ceS24RvkfDcrM+UtDlR3xdD7I
         mScncpecMXoqBpBhos74uD3pQYSBy1Ew8z6m/OhHKMc2cyeOVUDcqzxoxppx+wg3Dyhj
         l+kA==
X-Gm-Message-State: AJIora9NhYbD/7HZD25u3EMgOhRt5hjxUVdojrytVyV7llId4088pqtT
        KycTUmrllmnJ6whfNVIvJfCuNu6LstwgW4y9
X-Google-Smtp-Source: AGRyM1sGLQgcrNf10VtU4duwDxQFTE94UbY9XachM4zOJbWLK0MHHvyhM3KkPVWEPHWwmvad659PbA==
X-Received: by 2002:a17:902:aa82:b0:16c:4bee:1f90 with SMTP id d2-20020a170902aa8200b0016c4bee1f90mr10220103plr.69.1657631602827;
        Tue, 12 Jul 2022 06:13:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x5-20020a623105000000b005289ef6db79sm6752314pfx.32.2022.07.12.06.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 06:13:22 -0700 (PDT)
Message-ID: <62cd7372.1c69fb81.b200b.9b07@mx.google.com>
Date:   Tue, 12 Jul 2022 06:13:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.53-229-g4db18200a074
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 177 runs,
 6 regressions (v5.15.53-229-g4db18200a074)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 177 runs, 6 regressions (v5.15.53-229-g4db18=
200a074)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
beagle-xm         | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig |=
 1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  |=
 1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig     |=
 1          =

odroid-xu3        | arm  | lab-collabora | gcc-10   | exynos_defconfig    |=
 1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  |=
 1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.53-229-g4db18200a074/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.53-229-g4db18200a074
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4db18200a074112c9ac281d94c2946645f91ea31 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
beagle-xm         | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd403851bf30c683a39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd403851bf30c683a39=
be1
        failing since 103 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd4d46c5d9fdcae2a39bf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd4d46c5d9fdcae2a39=
bf7
        failing since 31 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig     |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd485b65b3f2947da39c02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd485b65b3f2947da39=
c03
        failing since 7 days (last pass: v5.15.51-43-gad3bd1f3e86e, first f=
ail: v5.15.51-60-g300ca5992dde) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
odroid-xu3        | arm  | lab-collabora | gcc-10   | exynos_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd4fbc94eecafc4ea39be9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd4fbc94eecafc4ea39=
bea
        new failure (last pass: v5.15.53-19-g8d59fcccbb45) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd6090fdc94c0fe2a39c09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd6090fdc94c0fe2a39=
c0a
        failing since 34 days (last pass: v5.15.45-652-g938d073d082af, firs=
t fail: v5.15.45-667-g6f48aa0f6b54d) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd5a7b3ec48d1e22a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
229-g4db18200a074/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd5a7b3ec48d1e22a39=
bd5
        failing since 23 days (last pass: v5.15.45-915-gfe83bcae3c626, firs=
t fail: v5.15.48-44-gaa2f7b1f36db5) =

 =20
