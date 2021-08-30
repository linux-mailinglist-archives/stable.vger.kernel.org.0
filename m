Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965CE3FB5EE
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhH3MWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhH3MWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 08:22:44 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867FEC061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 05:21:51 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m17so8427118plc.6
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 05:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wfDd6kmfR0ZThk6BKWmf4ZJ5f/WDRVdXu9BZ4EgklUM=;
        b=1hkRYz9Ax5KC7sqD6Mnm9l3eslYzqJO7o3keX+Xaec9onBmjsiQ+roaUfhz827FmSg
         X/wDf95UK0dlqyWBof6kQp2LkmOs8KPaAmLWI3Mhb++tK14ClGRLUDwOKwKOAfoOS18E
         LjOjAGj0CUDkB+LckMFLTCpie3f6nogI1tnQg8lOPJMP0sgVUrkcNpUbGk9RoopXCsiv
         qr6ddK/DEugwq3COt5ZtsnpbviBufAp8h/YwNyTYjL2AcnrMpRw/W+bHZ97apnkVKpjr
         eikrjzeKMe0AOZK/d2a3do12pFQZ4SLEt6iOsLb2FBMkx+MUiv7gRq264Erp5YL+EKeS
         SbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wfDd6kmfR0ZThk6BKWmf4ZJ5f/WDRVdXu9BZ4EgklUM=;
        b=FCM6jAk5OjcsqzW7UYqwYG2DsXaeV9lgeYccBQzWYBORucVrOrW2oHfoVcz4s1KWk2
         bTx31RwrWjZPLo3n2lBk5/fKSaYs7zDq+r2bFNaeFg5WX4VnXF94TAO+2NbaJ56Oryab
         57rERbkBhFrCSmamWAtWs408rdeXojBQr72F84/HjWDfx6MLz6L6xmGjEN2Tw7Nc/C2u
         1BgXRTpjqOvvlPu7B7aKWyM1zfounSsq6TTPJCaYhGWuw6g5uCP5QYYzqL0A1uoQ+v2r
         q+ibrkDnboFzvsoK1XNvLMAzroJXmV0FO29IZa3Po3R6yR83hUnYrx3wh0LfTCnaILnU
         r8hQ==
X-Gm-Message-State: AOAM533RJ8BJL7KtJFS3Jko98BQYp0mkTowx6gvK0KZ2bNK11wMgFhnl
        F5fIf7SpcBzP7tAISu6CA56iI51Dmjm0WFvY
X-Google-Smtp-Source: ABdhPJw3AGzoxF+C45bVjlwPhorSPrAfyQPzWAazl4914UNFSP4mL7un9+c/WN12P/g0NXGBg6nOkQ==
X-Received: by 2002:a17:90a:bb0b:: with SMTP id u11mr39127542pjr.18.1630326110870;
        Mon, 30 Aug 2021 05:21:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 26sm19311951pgx.72.2021.08.30.05.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 05:21:50 -0700 (PDT)
Message-ID: <612ccd5e.1c69fb81.5d7a5.04dd@mx.google.com>
Date:   Mon, 30 Aug 2021 05:21:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.13-74-g5a5b2e290019
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.13.y baseline: 104 runs,
 1 regressions (v5.13.13-74-g5a5b2e290019)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 104 runs, 1 regressions (v5.13.13-74-g5a5b=
2e290019)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.13-74-g5a5b2e290019/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.13-74-g5a5b2e290019
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a5b2e290019c314fb4cdcd15fada7567df1a64a =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/612c9ada5a9bc494de8e2c7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-74-g5a5b2e290019/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3-74-g5a5b2e290019/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c9ada5a9bc494de8e2=
c7e
        failing since 45 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =20
