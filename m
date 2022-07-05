Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9730956780B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 21:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbiGETvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 15:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiGETvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 15:51:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6982C1CB10
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 12:51:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so9149176pjf.2
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 12:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D0V3xGTAUV69Bje5DC1liC9aNj5JN8ZFgMOL7a7eWsI=;
        b=SNdAm6JofQZNI1buvnByFnOg99U/57bUwhQvyKBvFW4DtgfcSk4uA4R2CdLRZQjcg4
         9Wm9SGD+gtPJHwxPwE+uBP1XGbBbfipgbi1tSn4lnHJdnWypwD8ETE01tbv3XLPK8fpx
         8Y7JNp0mfXLTNRKVl/in1EmtJPD7NiYWD6u8Misz3PbTv4uBAaJb971NmBEQpnc/Nvlr
         UfxfNLx4nbzb1BKNWqY+QgPGzokyzM9Tk+HmevgCPucqxFmArrT+P3i5uCpT2PLqM8nd
         vlXt2BeUjrcCmMw3zsHKPhd8ESGZsum/i3pNkMDZa6kZdaY68dNCJIgIW67CaB+R9Tgh
         gZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D0V3xGTAUV69Bje5DC1liC9aNj5JN8ZFgMOL7a7eWsI=;
        b=Z/P7b+aPrELGnBjm6hwRGsLbtmFEQiK2EoWusxIF3iDcXzk3U08VFrXBm1ipQhHm/f
         wAYdnmZz/LNCZ5GtIYF6/tWyXiUoiAhGpMMPKW0p3HRRl67up0aKjHCHVNjCpYW0d4/M
         DmtevEZMhmKOOLx7fWrFlH97SCq7NlIQSlLV/oq0z2xX9UuNbStqwyNVT4DcOcRQb8EU
         1pGfYN2q7p/X9QvugzDzcpoqsdn7oohm+IWOQ04ziy5DoQ2ZX0dkJKvmlt8S9OWgTUS8
         abiPfhajbcf4viCdmEt2nU8q5diyzP8qOkjkPzcoXKoEwJCkGGkGjo0plhBBs9Z4eTNQ
         umSg==
X-Gm-Message-State: AJIora9ta3+4sD1UpjKXa6+KG91aMbuWIdzeSvgVmzzFo2rotDSPkFEF
        ubDw/IjPb+Q9amuz+CyRwiVqV8mZ+hDz5sS4
X-Google-Smtp-Source: AGRyM1usuO20OCaqI9gHIUIBQYk8GOux0KSKlgzNUTU9AURP15Tc2UgoBq7l7iSdfw8FA0axPwAzKg==
X-Received: by 2002:a17:902:8645:b0:16b:dbe2:111f with SMTP id y5-20020a170902864500b0016bdbe2111fmr15526618plt.145.1657050664723;
        Tue, 05 Jul 2022 12:51:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j11-20020a170902da8b00b0016bff65d5cbsm25234plx.194.2022.07.05.12.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 12:51:04 -0700 (PDT)
Message-ID: <62c49628.1c69fb81.a482f.00b3@mx.google.com>
Date:   Tue, 05 Jul 2022 12:51:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.52-98-gc89c3559309a
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 194 runs,
 6 regressions (v5.15.52-98-gc89c3559309a)
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

stable-rc/queue/5.15 baseline: 194 runs, 6 regressions (v5.15.52-98-gc89c35=
59309a)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.52-98-gc89c3559309a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.52-98-gc89c3559309a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c89c3559309a77317e258dac15b09ceb6a15de13 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c460d081911bebfea39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c460d081911bebfea39=
bd6
        failing since 96 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4642d329bbb9737a39be3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4642d329bbb9737a39=
be4
        failing since 24 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c46261e62ac6f117a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c46261e62ac6f117a39=
bd1
        failing since 1 day (last pass: v5.15.51-43-gad3bd1f3e86e, first fa=
il: v5.15.51-60-g300ca5992dde) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62c45ee8e18a315d11a39be2

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62c45ee8e18a315d11a39c08
        failing since 119 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-07-05T15:55:08.088587  /lava-6755389/1/../bin/lava-test-case
    2022-07-05T15:55:08.099644  <8>[   33.549710] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c486731756bfcd1aa39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c486731756bfcd1aa39=
bce
        failing since 27 days (last pass: v5.15.45-652-g938d073d082af, firs=
t fail: v5.15.45-667-g6f48aa0f6b54d) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c483ca24fee4edd5a39fac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-gc89c3559309a/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c483ca24fee4edd5a39=
fad
        failing since 16 days (last pass: v5.15.45-915-gfe83bcae3c626, firs=
t fail: v5.15.48-44-gaa2f7b1f36db5) =

 =20
