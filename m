Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BE54F8CD1
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 05:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiDHBub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 21:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbiDHBua (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 21:50:30 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12DB6E365
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 18:48:28 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q19so6503753pgm.6
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 18:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kCjni8jYjPOoULko8yIwrlSFCcH+FYu/F68mdQuoe18=;
        b=AzgoD+IgGmhKp4zGH89SC2AZFqqVz0NaMz6EKaD3UvA+TL5/aUvytvV5hXBH3Ux8vI
         cQUjNjzDDs5DcaqThwr/TGRUwYNg4TRE40sl8usZh87zuwtfTzFmDMo37AV+sHZOCxQc
         +drK7ByTxe0XvYe0mgAgQNy4qBuqP6UdOaVRuZGYCRwAkswR2xVvF3B9uoFTI0NIykT+
         15bHt9bn0iN1fZzhNk9hodrXdcYFGT0hOnAfv96JJtGFYfPMRQ0a+JrbGgkcMDQGmrYR
         vDl4TrpSueutGoN7VvcVD4mNntUUU2JB+OSoRh4h58vTPnyK7Ch1E2gW4na++4kXZoet
         inxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kCjni8jYjPOoULko8yIwrlSFCcH+FYu/F68mdQuoe18=;
        b=gzdZFBzvN0dkl6kQC4iSiTtbkBKO4X6B7ojapW+IEk3k9CjN5PS1QMgPZw8YgENPD1
         XKzRUkhjftK5cUIWIHGsXnOTMYgg1GYM2BCFGHfOzcooQBlJGlPASdS5zlCOajIfXrv6
         V2ne5KNoxPzObWUKaP8uRusvU7BzkhtSGkUwibm9EZ2sFEVDkawv+urlpMdB8qKWXGw4
         Qsl5nvA1ggYQdX9iqSzP5vfvETiMU6faimcPO0Awk9pgOguT8dFDZ65s5weLoZ8iTZSE
         iQLWkRpqxVmuBoK6fnRIuyxFLgZOkoGLc9HL+zG+yF8U1USSopskqAgvY1PtlABcKcTk
         S1Lw==
X-Gm-Message-State: AOAM530LHxG4yH4E1QacoXzW/vKv6VucCOMLhhxUEPQJPcpExsI0miP1
        Lup4L2w2df0/4Vrmvqg8kZdZ69t4J/OYRT9W
X-Google-Smtp-Source: ABdhPJxIEemJwDwHuMsOv9R8Lhi3491WC+QT1V5ZA5jhQlt9G/zdft9coxoH/93NEQKlSXwEdFCgpg==
X-Received: by 2002:a63:445f:0:b0:381:6cef:d841 with SMTP id t31-20020a63445f000000b003816cefd841mr13779006pgk.363.1649382508078;
        Thu, 07 Apr 2022 18:48:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 15-20020a17090a098f00b001cb1d512c5asm2858939pjo.49.2022.04.07.18.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 18:48:27 -0700 (PDT)
Message-ID: <624f946b.1c69fb81.cd32c.78bb@mx.google.com>
Date:   Thu, 07 Apr 2022 18:48:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.109-598-g32dde4a44c8d6
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 90 runs,
 1 regressions (v5.10.109-598-g32dde4a44c8d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 90 runs, 1 regressions (v5.10.109-598-g32d=
de4a44c8d6)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.109-598-g32dde4a44c8d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.109-598-g32dde4a44c8d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      32dde4a44c8d6f6dd9cda13300bfda1468e13ec6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624f65a7c61acd0e41ae068e

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-598-g32dde4a44c8d6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-598-g32dde4a44c8d6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624f65a7c61acd0e41ae06b0
        failing since 31 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-07T22:28:46.035134  <8>[   33.045016] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-07T22:28:47.055092  /lava-6048346/1/../bin/lava-test-case
    2022-04-07T22:28:47.065731  <8>[   34.076976] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
