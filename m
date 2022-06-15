Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E1554C816
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 14:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347417AbiFOMEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 08:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245324AbiFOMEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 08:04:43 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17B019285
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 05:04:42 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h192so11193535pgc.4
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 05:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YesflcJYsWBOzCND56/Lvvn1Y9qifX2GU6PjqnSYcFI=;
        b=Pnc8iAGpDQwt/0fGXEegBX9iwrnzAuyu3nHbNYAmx0UF+ZDaFrqBB1ICIWdal3V7vu
         EQXT7PwXyTpcdLAaDuG5HCFh75MHuQdIWuCR380POLXNKCRrJt/rtrMk1rEOGJyFRn9d
         C6aYoNVW3VZZkExMb7m2kq0z5unVx01NuSJCBsWf7wSrsChDoHHSAThfWoyYeUfxInQz
         fBDaW9W702u2oSSL85tbH7Zxku+FkfMxC2JgD5a2qfuH4ciT+WXodlIDF0J6yEDl3g7/
         IYhlHuHU8YAMUyqRAoFKjEnBsBalfuB2G8/xUlBCzTJ85kjT++y88P2u3vpK6duGIScf
         6yRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YesflcJYsWBOzCND56/Lvvn1Y9qifX2GU6PjqnSYcFI=;
        b=3/UUMWGeamzWFNW1RcBxn/o0Y7mf1EKmxhdcWZXs4+qOcz7NR1s4lxmBCqyn0SSnx/
         86BXhUXS/4SHbARPHQ5eJZhhJSRKT18DSCQQ8Hlqt1PU5K4hNiBa4X5tfwP7HderEbLm
         MaHjaQE7IHs7PQu1p82eP+lUfWJAgiqZR2aUBlwVmFVe7qUXb4SQi8zaDSy6fJKuVYO9
         uxtd9vJ+MJBvjLjWbNeO3cWHqPqq7inpEX969uz/bHqLV/TROCChhFEMufxiiFIGWOnO
         eFT+wBH9OzENFLaCDT91EsVOmQIDZIPO1n6scfjG3VPsbKVfYG4q+0oaDtUaHiKuD7dM
         7JeQ==
X-Gm-Message-State: AOAM532xeBQcuWD7926yhgZpQc33x8HkI1zcchiRP/oMzWZIP9oiE3EX
        a/lM4rG+oD8YctUJjDJkcoNjHtsyBRWsKaJlMwI=
X-Google-Smtp-Source: ABdhPJxjkGyB/mWiwq3BbYKPiDwO+vzX1TaefbdQZq+ICyN9s2B3vj9IBNSsiNDMFyt0OjFQ99OX8w==
X-Received: by 2002:a63:6806:0:b0:3fc:3b43:52d5 with SMTP id d6-20020a636806000000b003fc3b4352d5mr8662101pgc.319.1655294682195;
        Wed, 15 Jun 2022 05:04:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7-20020a637d07000000b003fdef4f7447sm9718857pgc.6.2022.06.15.05.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 05:04:41 -0700 (PDT)
Message-ID: <62a9cad9.1c69fb81.769f9.b80a@mx.google.com>
Date:   Wed, 15 Jun 2022 05:04:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.282-218-gf105a730fc00e
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 91 runs,
 4 regressions (v4.14.282-218-gf105a730fc00e)
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

stable-rc/queue/4.14 baseline: 91 runs, 4 regressions (v4.14.282-218-gf105a=
730fc00e)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.282-218-gf105a730fc00e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.282-218-gf105a730fc00e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f105a730fc00ea32f8570b9a9a2b9e99b7d18361 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a74baa6cb2ef32d7a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-218-gf105a730fc00e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-218-gf105a730fc00e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a74baa6cb2ef32d7a39=
be3
        failing since 20 days (last pass: v4.14.278-4-g95c4f04a529a, first =
fail: v4.14.280-33-gfbdef5eaf17e4) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a74b1e45508ea4b1a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-218-gf105a730fc00e/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-218-gf105a730fc00e/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a74b1e45508ea4b1a39=
bdb
        failing since 8 days (last pass: v4.14.281-23-ga0c33ef6408ce, first=
 fail: v4.14.281-23-g903e234594714) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a76e7727435ea8fda39bfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-218-gf105a730fc00e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-te=
gra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-218-gf105a730fc00e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-te=
gra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a76e7727435ea8fda39=
bff
        new failure (last pass: v4.14.282-216-g5d7ca74b4bbf5) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a76beb310dbd7d3ba39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-218-gf105a730fc00e/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.282=
-218-gf105a730fc00e/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a76beb310dbd7d3ba39=
bdb
        failing since 9 days (last pass: v4.14.281-6-gec5e3fd5e6c8b, first =
fail: v4.14.281-23-ga0c33ef6408ce) =

 =20
