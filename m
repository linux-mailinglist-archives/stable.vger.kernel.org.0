Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6B255238A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242638AbiFTSHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 14:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238373AbiFTSHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 14:07:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A2C1AF12
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 11:07:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g10-20020a17090a708a00b001ea8aadd42bso11051689pjk.0
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 11:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zV1PDWCKobC15aezIYP9Hdv9Kz2NAfpHsQoKl/DLM0k=;
        b=aJMtP3ietqXkLvFXT3CxAu35auSdm+camblWajbXfsqhjcs+snCWDTSrtpAVdHgc47
         EMVkDaiNxMZmweTRr4qUdK3wKw4ldFrx7CejAHKefygtEcGruCevAjnEIWsUAt2ktJCK
         r1+bhC7fp8pu3c8LBjx8wssCVwBTNdrL4/5CjdV0CBwhYEuybJqK1O91R7BecN5duNd0
         PWU/DvL7qFz5tE6amqeBORjEpoeyuWxpihJcEJijrGT2jq+2uUUpPktXEU7HTlEpqLc+
         kw0uQIvEW29+9oE/ngViEeuGLgIfOADfsWXwoAxF4bsSmGojdKgxjRa4YF//i/pc8fEV
         MY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zV1PDWCKobC15aezIYP9Hdv9Kz2NAfpHsQoKl/DLM0k=;
        b=1FBAPvWeCzk+FbUH6YhORDSJ06XeEUdZw9cXX3ImfJZ9Ra76QO8ptieWIoBF1ONTZk
         mFTV4gTrf9dnPWKdqodBpkl/EaYnSZ30UbAiSVd+MjOdshD5VTVLIqmKQjWJVekAVZCI
         y10JLDSNWZV03v7vp21h5aRbNyjevIxhBXKHjepMiVoaw5LTcafQoKLa5XQajuC/KJMC
         a86U8WjZ7DTDX581jYhQk9qlKqVjiSRiU9+KSdsmclbhre69FRusEfKmHz/Ohc+Dxy7n
         s/6x9xRD32UZIDUjdMqXAHNrKoWjUXlk6nKAnepy1rjsavbhFK5TjtHFqQG334uRO0VS
         IuTA==
X-Gm-Message-State: AJIora/Zye0Wm3bCg0AYfxhfO4WCLBz/dvubzde4ydQ7SZwyuFr7V75U
        nlwyAKrrekGLRP/brSF/NwCIQ/pUMi9Gkaxigeg=
X-Google-Smtp-Source: AGRyM1sm467/xGL6jfngbbKqepkrpdk85FNLhPopkzqEofZqvc9hqMjmNxMaUp25jAPXIGPO2dvr5g==
X-Received: by 2002:a17:90b:4b48:b0:1ec:9d77:8bbd with SMTP id mi8-20020a17090b4b4800b001ec9d778bbdmr9448931pjb.178.1655748419430;
        Mon, 20 Jun 2022 11:06:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o22-20020a17090ab89600b001ec2b1b7d8asm7051108pjr.10.2022.06.20.11.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 11:06:59 -0700 (PDT)
Message-ID: <62b0b743.1c69fb81.a38b.a2f3@mx.google.com>
Date:   Mon, 20 Jun 2022 11:06:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48-106-gb427064694eef
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 182 runs,
 4 regressions (v5.15.48-106-gb427064694eef)
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

stable-rc/queue/5.15 baseline: 182 runs, 4 regressions (v5.15.48-106-gb4270=
64694eef)

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

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.48-106-gb427064694eef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.48-106-gb427064694eef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b427064694eefd8e9c43ea146be70cba877816bf =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
beagle-xm         | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62b082b3dc641c229ea39c01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
106-gb427064694eef/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
106-gb427064694eef/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b082b3dc641c229ea39=
c02
        failing since 81 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62b08dbde738dcd4e5a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
106-gb427064694eef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
106-gb427064694eef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b08dbde738dcd4e5a39=
bdb
        failing since 9 days (last pass: v5.15.45-667-g99a55c4a9ecc0, first=
 fail: v5.15.45-798-g69fa874c62551) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig     |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62b08ac1d219c8a9bca39c05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
106-gb427064694eef/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
106-gb427064694eef/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b08ac1d219c8a9bca39=
c06
        failing since 7 days (last pass: v5.15.45-833-g04983d84c84ee, first=
 fail: v5.15.45-880-g694575c32c9b2) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62b0b5656f7cabb01fa39bff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
106-gb427064694eef/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
106-gb427064694eef/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0b5656f7cabb01fa39=
c00
        failing since 1 day (last pass: v5.15.45-915-gfe83bcae3c626, first =
fail: v5.15.48-44-gaa2f7b1f36db5) =

 =20
