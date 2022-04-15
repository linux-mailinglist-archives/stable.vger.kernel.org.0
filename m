Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE9F502A84
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 14:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349811AbiDOMrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 08:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353800AbiDOMri (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 08:47:38 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FBC366BA
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 05:45:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id p10so7047432plf.9
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 05:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IjB/1QJO1rzPovxMfmT+5/tRrx8kqP9bZFSuxQE7ouY=;
        b=0kG9SViBd4iMCmAJNrYBOWBlE3pWX4Ij4UMOod9O37hPykgpCeEdU98nJ7W09HWm5n
         E4wPKDdIt1PvsW09XCKwvfJrmII/GHnohL7m+UJo8e2XF3GruNcRETqjSjie2Kj1zDDd
         gWKDMPnwy6/YNamfRBjozQpGK+o9VNMnkKsfiVbdes6DdmJqeYLkIAAWNy0IEbS/LEtP
         jHLVrf/BzWfx5RrUAqWWB651VBolq3z///jYMYY5Rqpi+94NpEb7fOCcBUZNPiEQ763C
         sXCkhDITfCmugAvEQi8lMaKdLdphXcEuXvjl/1uNFEp1GOzVoTj8z944xTgVqDAbsMLW
         J1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IjB/1QJO1rzPovxMfmT+5/tRrx8kqP9bZFSuxQE7ouY=;
        b=2VpzsKaW7Jj9wgNwypOk2O3Q9KLodtVlwmHlQFHtWLP9EmLKHZawaV2Hc8Sx4L/dmj
         h4n2tm9Ts0XheDwJaaOWhheh3HX1rhXnXU2TTkMMIacNiGkK2Oh3wtUUF+NcWQSFcuVQ
         s2g2IwMpxrwAtTVHv4Od0ieELUjGEsy/BVQL93WDdvVZB04SSH/pAjxme7aBgCzFyh1j
         EEBqbZdCL/YpBaB2yF8XJSIhooH939MKnkSbv555KL5WpA9z1VUPcVd/KSxSvZ8yyV0v
         PesMD4OsYZdUpBTnb7R97RhG40Ql8aNIQEtAlGykdzUUOJT5fHv2SaVy6Mk8w/+5nuzu
         ZGbA==
X-Gm-Message-State: AOAM5309YoTkR079qz3xZcxmMD8DhQwxCJ267CoW7+0kA3j8JtHQBvAe
        lU21J4GNTOaqEgvhCumg8rBuVlIvqrtnylsU
X-Google-Smtp-Source: ABdhPJyAWxKiEss7qHgbL4fRQ5HnGN7/nq4x3kulG6Z9ZLkkefm75F61xegXeGGjFNjhONXuqT8eLw==
X-Received: by 2002:a17:902:7045:b0:157:144:57c5 with SMTP id h5-20020a170902704500b00157014457c5mr42141059plt.86.1650026709407;
        Fri, 15 Apr 2022 05:45:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a00239000b004fa7103e13csm2943866pfc.41.2022.04.15.05.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:45:09 -0700 (PDT)
Message-ID: <625968d5.1c69fb81.c97e4.821f@mx.google.com>
Date:   Fri, 15 Apr 2022 05:45:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.310-201-g666ee4eb9e4bd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 90 runs,
 1 regressions (v4.9.310-201-g666ee4eb9e4bd)
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

stable-rc/queue/4.9 baseline: 90 runs, 1 regressions (v4.9.310-201-g666ee4e=
b9e4bd)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.310-201-g666ee4eb9e4bd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.310-201-g666ee4eb9e4bd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      666ee4eb9e4bd09a6577e7f1a88a67102b265505 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/625942baaa49929dd8ae06ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
01-g666ee4eb9e4bd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
01-g666ee4eb9e4bd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625942baaa49929dd8ae0=
6ae
        failing since 9 days (last pass: v4.9.306-19-g53cdf8047e71, first f=
ail: v4.9.307-10-g6fa56dc70baa) =

 =20
