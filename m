Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEEE4ED26F
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 06:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiCaEHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 00:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiCaEHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 00:07:46 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A3120A959
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 20:42:19 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k14so19033991pga.0
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 20:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HU/iuTHfYvXLNC12AZwe8T2PDgMMFFTE0QSxa8EMkvw=;
        b=1IuQQmF4dNCtyR+LM/O7AmK/7J6/MJ5fLS69aJJGkGFk1eD7nHuLoR8X7pdP4N1bA6
         TZTaMB5Dlp58yBTmDDkACgu6bKm1yeHxeHj1+JL8B4uOBx3Q/U8rsR+VDU2p06YJsY0L
         OCGKOHHxSZy7H8dGckJ01E/hMaFFu54YNxoMjKQ39Kki1N2ZWXDSRtuYDrC6MyAnpGLL
         di3kQwN69kLs4Plf4+rfRR1ufKi4uoRZqIUhNGGHVnCZyNoW2xBN4Ps/0umgthZEAIN8
         +13WWyzkQwvfvuBA1+M9gEf6PStdNsdaF+LPaFJnDFUjJhEBKZMlf+WfC+WvTP/0O2er
         xukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HU/iuTHfYvXLNC12AZwe8T2PDgMMFFTE0QSxa8EMkvw=;
        b=5D/9MzNO8uBBJjbvdSsI48yLniVnL7sHFjAAoB+ArkSt2kJCWCE7fmj2dSJTyfKZ7V
         MjCbM+2lL7izJtADOwFeJQGLRpbKpRXlJU0rM1KX+mQ5fGWkAqAfR29BEJ8EvcBCF99n
         o96+/GQ/bkVbdf8BpJF9zkrID2qmoQu9oeD7g9Ft6xAUjPEomuiIO2yH413+4/VFYz/3
         TgiU1b/IWHHC1cE1hVAFH4KBr2XKGvPDvprR8DagdqRsQgzXNiurZguWAix0zmx87N1K
         x80Qg99sCfThIlE2KwuDoApe5bhFzi8DhSR7ijEDuqc+8mP/NaGwPRSiTrBGE1bKrM3p
         mREg==
X-Gm-Message-State: AOAM532jqEFLCZigLnm2gDpT4rYsuZtrhEWv2Uf9F4Ymt742CvQ3paea
        Om3JOmyAZWcBAbqS7/mNvjm2s4/Cjc840VHWIvs=
X-Google-Smtp-Source: ABdhPJyVDTqcFhOnIWqBMcZaybsabSx+KuzQt8GHuztjngFeT3Rk62fBNaW6NxW/pzig61+CdmDRVA==
X-Received: by 2002:a63:f642:0:b0:386:53e:9cd4 with SMTP id u2-20020a63f642000000b00386053e9cd4mr8834178pgj.265.1648698101499;
        Wed, 30 Mar 2022 20:41:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cn9-20020a056a00340900b004fad845e9besm23393162pfb.57.2022.03.30.20.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 20:41:41 -0700 (PDT)
Message-ID: <624522f5.1c69fb81.b27a8.ef52@mx.google.com>
Date:   Wed, 30 Mar 2022 20:41:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-12-gaeadc134c12f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 90 runs,
 1 regressions (v4.19.237-12-gaeadc134c12f)
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

stable-rc/queue/4.19 baseline: 90 runs, 1 regressions (v4.19.237-12-gaeadc1=
34c12f)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-12-gaeadc134c12f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-12-gaeadc134c12f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aeadc134c12f0f84a6b8d01403f37c20699fbc20 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6244f230d50394da92ae06b1

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-12-gaeadc134c12f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-12-gaeadc134c12f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6244f230d50394da92ae06d3
        failing since 24 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-31T00:13:13.154820  <8>[   35.700398] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-31T00:13:14.165645  /lava-5983682/1/../bin/lava-test-case
    2022-03-31T00:13:14.174287  <8>[   36.720853] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
