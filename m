Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E714C590538
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbiHKQ5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235151AbiHKQ4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:56:55 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE5ED7CE1
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 09:28:54 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 17so7996527pli.0
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 09:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=I/UG6PkXMaxPaE+l06NML6Y4EHf1XvaYOIdlHLMC28Y=;
        b=myI0QqBN511zBF0XSmk01Tkr1yBGHqTeEQWjmK/U8HwZ9QdyIZYu1FbSW8/kQM/emd
         Id3hFAUKkbJmCjmCCVnI3QU/kRzCk7WUFjPwPJ7hY2sbdaPMetLAwPgk1/HKLx9vTRkl
         8gZkHSEH48wR2mL2gRi+X0R7T91W3op9TzrVr6fxDO8ardyP36IIazQ2hDDyai6uTGsj
         Cu83iRdI78aLyu6pLwVwGR6GpvFMipPeKW7Kyoq0hoirE18yGO1lQNAMoKcE7tc8UA6N
         NLWaFibVp2w3A1Wmv/Z+f6zzlrcq1sW5MtzwL0ND3bXhENyLa6J50YooypEEyNW+C9Gz
         ObFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=I/UG6PkXMaxPaE+l06NML6Y4EHf1XvaYOIdlHLMC28Y=;
        b=0lwbfKtca2foUNBUaDq/X2Dhzf8fzJquhKw2OtApoy0KWUu3dKmy6wiPyAQHiXzm7u
         9Anfa2wcPNeyQEsUDM5L8gzYXjQ3MuKK3Q4iQnjKjVjiUe7yI0poi2u14ybS+77wgyWF
         TeEPV0C/oGktKU0RIB4OmYUls3G/QOxVRPFytQYOBZ5xMfI5hJEpe+Xt4/jGwOGNxExf
         JPdlESbYRoQ6tXdCz0GEfxHCrSqYlnR9NwqTL8iMjxZoCKcg2Q3HP41KfQzCscN93MOM
         TDp6+hdUtibIr7NJ0Rkwau0gEOlJQDoVgsRsH+eddrFRbskxD+IfcNdPr1W4zFH5zEau
         07/w==
X-Gm-Message-State: ACgBeo0DSnR77+VsIE0KYXhC+bNQEbKYcQAifwg8meEN3r/1q5Gr4mB0
        MJxWcQg/gUUSjVmN3xY0TCEprwVn3l+oGko+2fk=
X-Google-Smtp-Source: AA6agR6G4KTPhWewR5dyv/+L2rGW8dGXMLBYuNVy2nnBklhvJbgMPmqbw6EOwD86Pa9+UEgvDeCgug==
X-Received: by 2002:a17:90b:3b85:b0:1f4:f595:b0fe with SMTP id pc5-20020a17090b3b8500b001f4f595b0femr9415185pjb.61.1660235331113;
        Thu, 11 Aug 2022 09:28:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902e5c800b00170a359eb0esm9620775plf.63.2022.08.11.09.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 09:28:50 -0700 (PDT)
Message-ID: <62f52e42.170a0220.8e151.04a6@mx.google.com>
Date:   Thu, 11 Aug 2022 09:28:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60
Subject: stable/linux-5.15.y baseline: 132 runs, 1 regressions (v5.15.60)
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

stable/linux-5.15.y baseline: 132 runs, 1 regressions (v5.15.60)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.60/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7217df81279835a7aee62a07aabb7b8fb8c766f2 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f4fa3a6d43be8a2bdaf069

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.60/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.60/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62f4fa3a6d43be8a2bdaf08b
        failing since 155 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-08-11T12:46:43.469173  <8>[   32.598881] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-08-11T12:46:44.492874  /lava-7014139/1/../bin/lava-test-case   =

 =20
