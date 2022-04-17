Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5978504974
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 22:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbiDQUdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 16:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiDQUdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 16:33:03 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0926B7E3
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 13:30:26 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s137so15386172pgs.5
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 13:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0jvyGNK6zOxZq/R8LQWQQ3b2IwcU3x5jjEK634e/gRs=;
        b=sKL527GLE6EnJWOBcklSIkkGuiz9K8hMa2zfvffx+CoyT+IM6sNU08ViHlSe2kLyCf
         tNjXN0jM3xjwT7euNd0f/F081/zpB6y9FDdcPzwT4LJugJOv3I4oF+oPDv8g3Cwr/IaE
         HRlRK2kPfLJ8qZ8w5L7nm7VWrgAFYbxk1fiTE3eg57zx+KAIpdK/tJ4Bz4IqY5qSptq4
         i0EMzDxRlNe0nwI3VWOii5KnvN446mnePIhpS8RRc8Ez0IrqALc64XuAXCHqWXekPwd4
         RgXPFsG9dCASpoZ/Qjz+3FOfbHdJMpw1bhEs8MJEa/UEjLHoIVq4aPWRfd2Dew6PSGdF
         IPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0jvyGNK6zOxZq/R8LQWQQ3b2IwcU3x5jjEK634e/gRs=;
        b=kNjUFCJAGFpJnkQDzUWXl/UDpuSeBcAXPLys2fQ72SVuVYneEx0i0WN23wyf/gS9e4
         YT5FU1Rapunyd4FiBGRcht/Fk+pJpVoJCWWiS7QRKFLINmy9aJIG0lsVefC1AAkNL3r7
         Dl8UmXeuLsSKNn1AMdcPnq4+vjNIK/2+u5B3Xk5ax0y5mHJMy5q6djDjq5UPkKo05wkx
         DhMc/Hv5A4W8BxPKZF0DQCem/EDo0gSsFKa1QePRV8Yn94jbQMWdCbiD+SEoQ2k6x6WK
         jocTe9glbt61IYumxo7hK8hBppOX14E2gFgb2M74LseJznCCSsEe5gKLQtFM0Yw4a0wg
         7Xsw==
X-Gm-Message-State: AOAM533wKJF8q77qiS0Dz0H0KX49YfTLPykPz0JEuminY3TjstxRdGGR
        NjN9q6blWGrxJWccJ7aLD0g+ksEOo6Hsqfv5
X-Google-Smtp-Source: ABdhPJz99Mmjfj0f76cr7s9ydZgPTgr3TXP20UYZ0M6zccXA2geJeqOlaaXVaI9iwpQYynXPvvrdXw==
X-Received: by 2002:a05:6a00:b52:b0:508:31e1:7d35 with SMTP id p18-20020a056a000b5200b0050831e17d35mr8858567pfo.33.1650227426080;
        Sun, 17 Apr 2022 13:30:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a00239000b004fa7103e13csm9996597pfc.41.2022.04.17.13.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 13:30:25 -0700 (PDT)
Message-ID: <625c78e1.1c69fb81.c97e4.7c32@mx.google.com>
Date:   Sun, 17 Apr 2022 13:30:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.275
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 107 runs, 2 regressions (v4.14.275)
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

stable-rc/linux-4.14.y baseline: 107 runs, 2 regressions (v4.14.275)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.275/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.275
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74766a973637a02c32c04c1c6496e114e4855239 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62545fd051def9d07aae06cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62545fd051def9d07aae0=
6cc
        failing since 4 days (last pass: v4.14.271-23-ge991f498ccbf, first =
fail: v4.14.275-206-ge3a5894d7697d) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6254608dab94aa7d06ae06d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6254608dab94aa7d06ae0=
6d6
        failing since 56 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
