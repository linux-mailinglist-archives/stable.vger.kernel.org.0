Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253533AA073
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhFPP5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbhFPPzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 11:55:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082D7C0613A3
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 08:53:11 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o10-20020a17090aac0ab029016e92770073so1994155pjq.5
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 08:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vHYwYQ6LZfpiWVfc6quTh/4SSvAaEcVHdW5iktgWVqY=;
        b=fGf2Iw7gK+C/dpgBadtgpbgeRW/bjB9fGWuq/G04gQQgiD86SAe+qrKR4TiwE3jMNH
         vBDGpmnNCWrA30kpaDmsLHkfIE6QHfl4L6HU+NsL6V+8oJiw+DUD4gqZgYwYHsI7p8/E
         GmMAR3fEsPS1igiodm7TUJc1TNj+Sx5GC6fakFgHJLiu4N1hHZlH1GQHTQQHI04N4oD+
         /aaQkVjDiEAqun/2sZvVxKyNP1L9L3raTNYcZZ2t7U7d1J64qQ37HHcRybdIefR4zMhL
         IwSwrJR6eZVSZeth6c8/cfPKjmWU+WjS2sVztKPqqgj7GlUZ6hx4Nju7SyWWTCQEdc2g
         VOAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vHYwYQ6LZfpiWVfc6quTh/4SSvAaEcVHdW5iktgWVqY=;
        b=A5CrC2Wy6DmTSqLKebEnngoRiugKXkoI2AD3cvCwf/LEdh7IldmcbNBghLADknv0ST
         dXpylJxscsSRlYiIT3vrvhujy4DJtAggrkjQ3lrzCdEoz4PFVjLEOyOC0x+nXuHB27r6
         oIndxxKGl+lvqI1clPaifYpV9PGvnjgpUcgemW47kp65uAQaTkyvjR1TCxbMktuiNpvV
         gsdZMynvkP5ggw3QIWG/pFzg2f6Bzws6ybZayn+ZCo7rvkw/PZD89sZ6ompc4mS9fiv5
         f0eBIU0+pPxUz2HXC1ZKOhnp4GU1zySe8hvlzdmBaICAURtt1X54u176wJZKL1Cwktl/
         YTjQ==
X-Gm-Message-State: AOAM530mAEkgmSygGtvqdtBz3cb68s4MXJ5pf1uPRQYEOZ/TcUoNUNTs
        DGaLZs9aHxIoW4f4kh1L999ibsrd+5NNE7WH
X-Google-Smtp-Source: ABdhPJx6Nn3mEArl7XBqS6yXysb4LmtKxCQeujaeueo2VfkpeyuhhIWyN1ApFPWmMX+ux4JH0v8mIA==
X-Received: by 2002:a17:902:44:b029:ee:9107:4242 with SMTP id 62-20020a1709020044b02900ee91074242mr247568pla.18.1623858790347;
        Wed, 16 Jun 2021 08:53:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15sm5758110pjr.47.2021.06.16.08.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 08:53:09 -0700 (PDT)
Message-ID: <60ca1e65.1c69fb81.a4ca7.06f1@mx.google.com>
Date:   Wed, 16 Jun 2021 08:53:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.11
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.12.y baseline: 154 runs, 4 regressions (v5.12.11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 154 runs, 4 regressions (v5.12.11)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.11/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d7f82a4f24cb99ab82e6782567c87bd14b77d166 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60c9ef98be62b2349341327b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.11/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.11/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9ef98be62b23493413=
27c
        failing since 18 days (last pass: v5.12.7, first fail: v5.12.8) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60ca1d818a911a40a241327a

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.11/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.11/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca1d818a911a40a2413297
        new failure (last pass: v5.12.10)

    2021-06-16T15:49:14.851730  /lava-4036207/1/../bin/lava-test-case
    2021-06-16T15:49:14.857047  <8>[   11.355887] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca1d818a911a40a2413298
        new failure (last pass: v5.12.10)

    2021-06-16T15:49:15.876235  /lava-4036207/1/../bin/lava-test-case<8>[  =
 12.375778] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-16T15:49:15.876752     =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca1d818a911a40a24132b0
        new failure (last pass: v5.12.10)

    2021-06-16T15:49:17.318036  /lava-4036207/1/../bin/lava-test-case<8>[  =
 13.805695] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-16T15:49:17.318580  =

    2021-06-16T15:49:17.318838  /lava-4036207/1/../bin/lava-test-case   =

 =20
