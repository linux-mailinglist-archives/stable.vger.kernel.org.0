Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE94752547D
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 20:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357497AbiELSKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 14:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357333AbiELSKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 14:10:24 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D8326FA4F
        for <stable@vger.kernel.org>; Thu, 12 May 2022 11:10:23 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id v10so5274188pgl.11
        for <stable@vger.kernel.org>; Thu, 12 May 2022 11:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G2Id9NlCEmZnWieSNFrNFx442secgjvwbceODXLluBA=;
        b=qFDAYF0GRUw8+ywtuL3VACDYllcyaRfDys7BS3+yGDrB7apGGJGtgDRCDAGy2QPGeB
         SfStY+fEdAhHp7osdkMERApY5rWcstgqE9evvsKYP+HMuHSl5mZvYLkuVZ+1D40hCURK
         Xftwc0T3q8LGAwmI79km+CUoYy4t4SR26NSuYV8Jlj3QfwxC9kmh6wVMN6J5tu+ScaQo
         t7O3EHK5E9XRnuAcxzKB3UHpX2r6PnzBQoERUbyEJ1F+frNoVDxtUL9n1rZOQqzsAnHk
         dwPfmUggQxXDpSVtZy5FldUzUQ+exvNT+966W1emZerQ065hRYGLEf3owXSS4L8rQQLD
         /Whg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G2Id9NlCEmZnWieSNFrNFx442secgjvwbceODXLluBA=;
        b=QAb66ag4tYxSjFvwhaQzYYcxkHz+dTJEjLuP/hvvl7TEOyPWFv2uExQIWmw/MYhDPG
         rB0eVQCzDAjgWZ4YpVkGrQRTZnvGrlPoj93IsSJnaUkBiLvBUe84hSdWk4I7+KyAZ5Uk
         riVfAOiAJjvJvllpklM5u/ZPb82PDCeZ2yvOebgSVZNHPgsIPIC75Mv1FxCKsKyultfa
         wWPTzwb9JNPTkHxYDumVGfUSdMa7zwcd7Vcv4UXcfOle/+K+ElQST5N3ofIhLYIdimpd
         x/Ephti7aD06ec6TPy387Og1M+GR9qfvPRQyw6QK5qdfXkT/Bg+Kq2Tr8Km92uBzuipm
         5j3Q==
X-Gm-Message-State: AOAM531LESC6mNm5+ULQC+BBgBnJdgYTrCbWNRabePisamHXwM6SEAof
        JJVS+eOOeGirzHUo7cc0rbJ7ygzCl9b0BtwpqU0=
X-Google-Smtp-Source: ABdhPJyg7Oybk0W/F+J0lA8/r6++/pglS5EePiu+qkRIKLj6did+AZiKgyH0MOyFdiH3tGaRUCpjzg==
X-Received: by 2002:a63:e16:0:b0:3c6:12b1:ce15 with SMTP id d22-20020a630e16000000b003c612b1ce15mr687557pgl.37.1652379022884;
        Thu, 12 May 2022 11:10:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902d10200b0015e8d4eb258sm197587plw.162.2022.05.12.11.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 11:10:22 -0700 (PDT)
Message-ID: <627d4d8e.1c69fb81.b122e.0961@mx.google.com>
Date:   Thu, 12 May 2022 11:10:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.39
Subject: stable-rc/linux-5.15.y baseline: 158 runs, 2 regressions (v5.15.39)
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

stable-rc/linux-5.15.y baseline: 158 runs, 2 regressions (v5.15.39)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.39/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.39
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9e18547cc55752d0ff283cfeb47d2c556560b17 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/627d1dfdea8cd4bfea8f5752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d1dfdea8cd4bfea8f5=
753
        new failure (last pass: v5.15.37-259-gab77581473a3) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627d37fbb49ee8ba1a8f5731

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627d37fbb49ee8ba1a8f5753
        failing since 65 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-12T16:38:04.893622  <8>[   59.833884] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-12T16:38:05.922701  /lava-6353794/1/../bin/lava-test-case   =

 =20
