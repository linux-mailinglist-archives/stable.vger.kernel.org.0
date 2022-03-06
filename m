Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B5B4CEC35
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 17:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiCFQSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 11:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiCFQSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 11:18:45 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C9422BC1
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 08:17:53 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id w4so1428841ply.13
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 08:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CLEItjpckwZ9kZPO4Jej8A51s1CPT2mF4opW2wllPoA=;
        b=AstcZOJjizSyRDVqRIVi8Bar/PznMUSRnYq2GkUOh9wcyiNyIWjsZ5/6biGaRLHBOe
         1WHIyIHlhQDiGv8mYbnWF392wqQ7ABpRxq41NKvw0fmnAYQqdWRdzzuuCAHCT+vp4g5x
         7Mvgnq3kB+VzaAG7gsBqoVfk/F71g8+2h9fJYaKLziwU19WymOhrFRe4tB38sWvRfxl0
         AvUPMg/ecioGE1TMOu/WGwcuskbXTbxuZMUXNjzyvjfxqMBYK9/mEQw+SQI76R28mzdT
         qbS4h8dgHD5mTk8j5O5mpBH+Mw+OF4QtI/oXPCvWq7Gb6wu8LrgZliqxTcx0NUjtJH2+
         /cfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CLEItjpckwZ9kZPO4Jej8A51s1CPT2mF4opW2wllPoA=;
        b=HnLbihcVlZT4WTLrvXQrjuKdxQhgYJ+PKgHS5hJP31dbr8A9FdZeeDIZbyabt5TN7h
         vEbes2Py/21q6nZGFGSJzQzeZIXRBvMWy4fA8nFQOyy1eqHxzJWfdLufrXfgZfLrUn8m
         6r8wmJSWl2cbUDSJeUTZX2y1nA+o2/yxNLc1KYD7IGvHShZlaxIaNjp/IGj50uFNTOkl
         wKbayWBZzHvhjjapTuWJ6Vfw+mVTncc0gLFA5HSAmMkvmQD7AX7PcSoNwnWI+GSVAJcU
         +Mc+nsGPK+irflVPZnOtDByCW6OZDILYHfSF2FxPPr+/UhR+j1SDrC0tVgQqn79LoHBs
         +jWg==
X-Gm-Message-State: AOAM532RU3lUWcvGyB1tZgC6Z2zBQiawBBO4yaZn+yVGC/EvROIDP+tz
        cu0TyL+vWcv04cU9iQgN1esThlK6x6wkkpufSog=
X-Google-Smtp-Source: ABdhPJyyx0/IsuX0+t4oPZmt5Nf3xS1Gft7VVO/rrcsaRblarWcZ3+LqyM6A6/aQEzJUTzampJS1qg==
X-Received: by 2002:a17:902:da85:b0:151:ac97:4f74 with SMTP id j5-20020a170902da8500b00151ac974f74mr8299506plx.73.1646583472625;
        Sun, 06 Mar 2022 08:17:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17-20020a63df51000000b0036b9776ae5bsm9565423pgj.85.2022.03.06.08.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 08:17:52 -0800 (PST)
Message-ID: <6224deb0.1c69fb81.5bd20.8968@mx.google.com>
Date:   Sun, 06 Mar 2022 08:17:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.232-45-g5da8d73687e7
Subject: stable-rc/linux-4.19.y baseline: 95 runs,
 1 regressions (v4.19.232-45-g5da8d73687e7)
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

stable-rc/linux-4.19.y baseline: 95 runs, 1 regressions (v4.19.232-45-g5da8=
d73687e7)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.232-45-g5da8d73687e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.232-45-g5da8d73687e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5da8d73687e76689822ac4e6070cb531337ec20a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6224a6b3ba8b345b3dc62968

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
32-45-g5da8d73687e7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
32-45-g5da8d73687e7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6224a6b3ba8b345b3dc6298e
        new failure (last pass: v4.19.232)

    2022-03-06T12:18:50.505485  <8>[   35.858259] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-06T12:18:51.519981  /lava-5825750/1/../bin/lava-test-case
    2022-03-06T12:18:51.527951  <8>[   36.881632] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
