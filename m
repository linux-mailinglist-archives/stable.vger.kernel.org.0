Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321065252A5
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 18:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356068AbiELQeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 12:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356300AbiELQeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 12:34:23 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D7C1F63AB
        for <stable@vger.kernel.org>; Thu, 12 May 2022 09:34:21 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id a191so5098801pge.2
        for <stable@vger.kernel.org>; Thu, 12 May 2022 09:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GS/urxl4nYhvm14aPG8IEEOyy5NoGeVQrrbrWs82JqY=;
        b=rT5hJvGuBQFcwhpC56AIh04ZWJ4lcQABpcMTCghLfZi30+AxPHst0RC1kGx1jozTD+
         yyRvIE+XeHeOhVfiDFvqYZOQIZiO/FgIGJEWWoahDKIH/1ifctl4ObLWPUMoqhLCby2L
         dU8dAra6ZwMw++oUxzBYFLc2WqNIGWn0i6Kvrb187vARfPrexx/Nm8wTavNhvgwH24QX
         8Fn1is1YtbrjHQGJQunqwJy+/RHxf+kbZszCqO05ETcbzsaFYpyoWwFDm+sfuHSPPOm4
         JXTokEhU0YfpPtbU/TjPOgFbCt8C3tUak24rMa//jOFqrHx657ufwYx9SHEqjyTtCzBv
         5WOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GS/urxl4nYhvm14aPG8IEEOyy5NoGeVQrrbrWs82JqY=;
        b=B6nmDdH3SPh4qTXdPFscd76QfwucTZPC9nGDcHl4VKWn5PFpA6vLsxn91sr6mau/96
         VcctXgBBYRe0k4hEDkx8BiDnYk6iVtcnF+dAeKM+2c3xOAHINCpaTJ8tZRXFlTeq8aLG
         cOHbvQiVELCRiAWNB0MbdT5SDaRX/kbagl+dXVW1YzXaGXKb1/KzCsOR5hsoxYT+CLYp
         lZCsFcl04BXf+AxPzD39wtu4Gde+MCKUNM2Iybj1GJjvhSSQ97aqbIUrkTO5RfiPrk5M
         orMkz3hwyMo6jfLdnx8TAaa9H4J2GIasvn4pE4uelqeRwt4iBQXwY0hJqLOLysk9XGg2
         ouFg==
X-Gm-Message-State: AOAM5322MPp1SXbdkjnxqW90cD43OzT8G64eTAiN51G2dVIvfCBgJ+uv
        D3u8Ibg//gKZa+L5/iIjWbSyr14PyPPcQpf47iM=
X-Google-Smtp-Source: ABdhPJwiUIRXviWmu8+OJyNI/qyit4cHHvLlqfaeekbcLm+PwLuYME86AXkRFkOqESa2XTB07RYEFA==
X-Received: by 2002:a63:954e:0:b0:3c5:fc06:307f with SMTP id t14-20020a63954e000000b003c5fc06307fmr382832pgn.287.1652373260971;
        Thu, 12 May 2022 09:34:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2-20020a62c102000000b0050dc7628163sm57728pfg.61.2022.05.12.09.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 09:34:20 -0700 (PDT)
Message-ID: <627d370c.1c69fb81.9e6ee.02e9@mx.google.com>
Date:   Thu, 12 May 2022 09:34:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.39
Subject: stable/linux-5.15.y baseline: 161 runs, 2 regressions (v5.15.39)
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

stable/linux-5.15.y baseline: 161 runs, 2 regressions (v5.15.39)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | multi_v5_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.39/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.39
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c9e18547cc55752d0ff283cfeb47d2c556560b17 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | multi_v5_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/627d0345721431637b8f573b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.39/a=
rm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.39/a=
rm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d0345721431637b8f5=
73c
        new failure (last pass: v5.15.38) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627d1f325fb1414a638f5735

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.39/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.39/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627d1f325fb1414a638f5757
        failing since 64 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-05-12T14:52:13.393366  /lava-6352770/1/../bin/lava-test-case
    2022-05-12T14:52:13.404050  <8>[   33.645845] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
