Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCEF5A5378
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 19:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiH2RrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 13:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiH2RrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 13:47:02 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEE27CB4C
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:47:00 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y127so8918098pfy.5
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=W6akrOF/cgBO1SnuFJUCZSJjCvubJltM1N1gK+TzZJ8=;
        b=RYpYWqD7hc3cwVYbHDXln6RV2cKOc9SnZFQ/ZlGmxh9AIPW1cYyJQOksxVtyqhDtTT
         j9cCORMC+MZ1DtMz5wEqnO5KXsV1rJiS0TGJHphy0IutAH56NCwDgnlhyirWCqa0uOSk
         pUJo741gHGBYtjJOBAIBJYReSVIXPHoZTvwMWIk3kIlIl0iG9SzPlNudiyP+mtDutP1A
         ra+66e8muTMp03+BbQoFB38gbyIZZ8iVsAxEs/zXTkc/j0S+vYOUdyf9J/82EZB1Mn+Z
         mc0bdzzbShMmZhPAyX4kHT4trc3R3sre0I6dMc8LLZ9UEuZn8lQLp4aYw8vi5kRTeW/5
         NKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=W6akrOF/cgBO1SnuFJUCZSJjCvubJltM1N1gK+TzZJ8=;
        b=Hn8Tt9vHrpyqHa3bzzseLdXK6vl8PZgrFj/ofjfVfiSelmKFJaruOdkCp16ZlWgwTH
         /PsFbe1eWARCel/kDzNUwXY+jIwQ/HvAI5UxV6FsGap02IDmcXOk3wejpvb1MOG85yYl
         0NAODEcsp2vwwI55cFAMLSGWq2eLNYBJfuGjsJ/1FFJM4h17OLzAqYsRy7esLipnW91q
         3mVEpD3fqDWMat2PZMjZ7Ajt/P3ObN+92iaHC37Z1ziJBj58gkFSeXhx1uJ+qWiWtP6T
         nTW0XFICXmJqpXfmTUK7tabMOWLqSm7tOT6X7rRJ5zH/qVd++TovJex5HRKVqcBzoH/Q
         0IcA==
X-Gm-Message-State: ACgBeo3L96NibNfpQcjoG3Avxuk/c2k/al0hG7sk/lkOLxPrRjEAgDFI
        bqKxMtR2LOdP+e1+CBPTU1LqSQFIW0XD3Q7naeg=
X-Google-Smtp-Source: AA6agR53472+67bbGeIqI+A+qURPGZSgBC1rmzfg/L5xEq3NQqaD8MYOG8wmBolGhTL40h7lXV6DmQ==
X-Received: by 2002:a05:6a00:2395:b0:52f:723c:363 with SMTP id f21-20020a056a00239500b0052f723c0363mr17442765pfc.21.1661795220122;
        Mon, 29 Aug 2022 10:47:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902b70e00b0017495461db7sm4149214pls.190.2022.08.29.10.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 10:46:59 -0700 (PDT)
Message-ID: <630cfb93.170a0220.d1f3c.724e@mx.google.com>
Date:   Mon, 29 Aug 2022 10:46:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.63-137-g881ab4a7404d
Subject: stable-rc/linux-5.15.y baseline: 137 runs,
 4 regressions (v5.15.63-137-g881ab4a7404d)
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

stable-rc/linux-5.15.y baseline: 137 runs, 4 regressions (v5.15.63-137-g881=
ab4a7404d)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
beagle-xm             | arm   | lab-baylibre  | gcc-10   | omap2plus_defcon=
fig        | 1          =

meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-10   | defconfig       =
           | 1          =

panda                 | arm   | lab-baylibre  | gcc-10   | omap2plus_defcon=
fig        | 1          =

rk3399-gru-kevin      | arm64 | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.63-137-g881ab4a7404d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.63-137-g881ab4a7404d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      881ab4a7404df537a02c17ade40cb8c7510b5ff0 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
beagle-xm             | arm   | lab-baylibre  | gcc-10   | omap2plus_defcon=
fig        | 1          =


  Details:     https://kernelci.org/test/plan/id/630ccb1e8da8b4a836355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-137-g881ab4a7404d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-137-g881ab4a7404d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630ccb1e8da8b4a836355=
643
        failing since 108 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-10   | defconfig       =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/630ccb9ea1e10c6e17355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-137-g881ab4a7404d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-137-g881ab4a7404d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630ccb9ea1e10c6e17355=
644
        new failure (last pass: v5.15.63-136-g30057c8a3a38) =

 =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
panda                 | arm   | lab-baylibre  | gcc-10   | omap2plus_defcon=
fig        | 1          =


  Details:     https://kernelci.org/test/plan/id/630ccb55a28511d78f355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-137-g881ab4a7404d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-137-g881ab4a7404d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630ccb55a28511d78f355=
645
        failing since 5 days (last pass: v5.15.60-779-g8c2db2eab58f3, first=
 fail: v5.15.62-245-g1450c8b12181) =

 =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/630cc8b77a5333f075355677

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-137-g881ab4a7404d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-137-g881ab4a7404d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/630cc8b77a5333f075355699
        failing since 174 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-08-29T14:09:41.223808  /lava-7126695/1/../bin/lava-test-case
    2022-08-29T14:09:41.233895  <8>[   60.891306] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
