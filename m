Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2359B500468
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 04:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239430AbiDNCpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 22:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbiDNCpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 22:45:53 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B989333E15
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 19:43:29 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t13so3554759pgn.8
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 19:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2YVWCzyH+jDsiJXseg3SoBRlcGKJBd2L3h/zvW2aFIk=;
        b=XERk6j2CCirZ7Cb0J4eoah0rWEuNniBklmYeStnGXOsmsOOsmE9EPwtgd1jX8tQlWE
         1Z6yIeY5ZtACiJGpnjYO2aQCsZZB5Hob76PWub+6QmJiUKYInlNNHabi1OcZfN5G3/Hx
         EDKemHqNs/diDVqZN4OgLXveJOBdZNWMZY8dV64jSv28K3g+ISUVsMNoQITS1za9Tf/K
         uk4+u9s2OpL2QPuj4mtGJQK1JWySgJwXZRKWAJkcqH13NUdLkPw1UhMtALGWjtGBgC9f
         IfWzw0hK+OCE6Cj85/qAZvewyfUHBSHSexYW7tZp6/Hw0nyDLFr1BRqXcPphJckk0lBB
         fMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2YVWCzyH+jDsiJXseg3SoBRlcGKJBd2L3h/zvW2aFIk=;
        b=cIW7DHgclBYk+X7evvXZjifLPUWOQRDk+WBZVZBpbiEq5LZAgpjn+g8FIALmgBZzOJ
         PBe8J/LFsvTDz0tt5HTMbTIOi764tQRRJHpHTKcZt+W5KTUFTFgaVTN0nfWq0wGQL3gi
         iI6+MHnyVRbo34rXxhC5vyaW61p2jFFOQtF2Xq/208A+EaRz8GPTCJwakujxBgI7arbe
         4fjRnesk02EIsg2cXuZcji9pKwiIdZ2S1pF6Q0MuL8lYjO1RMCp64Otr+izmxflw0UDh
         Kgmkt74EC8v7QLtSt1nf8+gyF6lBvbiJIFHXGFL5R2is4cZ3vVAGoRg911lU/CQRwdBT
         ORpQ==
X-Gm-Message-State: AOAM530KMkByGtJCy09aO4hhPimP1Gfe+kyMPeOJchzqgN1mEqVZQdQd
        6Qe1aItcx6Pw2jg6JXBIrBWeI+RpajGOrUJI
X-Google-Smtp-Source: ABdhPJy75B8OD+wjd88Vh69K+0UzK4WZusECYfwNM/IcOu5AEi7x5o/bl1IKT1rYd7BYqtbUhRb8cA==
X-Received: by 2002:a65:5a8e:0:b0:365:3b6:47fb with SMTP id c14-20020a655a8e000000b0036503b647fbmr537187pgt.147.1649904209151;
        Wed, 13 Apr 2022 19:43:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y26-20020a056a00181a00b004fe3a6f02cesm420481pfa.85.2022.04.13.19.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 19:43:28 -0700 (PDT)
Message-ID: <62578a50.1c69fb81.c1f10.1cd1@mx.google.com>
Date:   Wed, 13 Apr 2022 19:43:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.34
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 77 runs, 3 regressions (v5.15.34)
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

stable-rc/linux-5.15.y baseline: 77 runs, 3 regressions (v5.15.34)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.34/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b86fc15ba6d04e393d6e65753f2013963d407f3 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/625757c90dedc3a79bae0698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625757c90dedc3a79bae0=
699
        failing since 83 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62575b7461779952afae06bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62575b7461779952afae0=
6be
        new failure (last pass: v5.15.33-277-g059c7c9bf722c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62575c284063e66fa4ae06aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62575c284063e66fa4ae0=
6ab
        new failure (last pass: v5.15.33) =

 =20
