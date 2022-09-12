Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392E15B5D9D
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 17:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiILPsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 11:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiILPsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 11:48:35 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E88F31EEA
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 08:48:34 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so12741536pja.5
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 08:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=cHx9mKI4SwMUFeDJnmO6FDeTX8xlckFn+nMY52mxBzY=;
        b=ZurE+gVUgVm9xxvJwyOzYImB5zFGuSFYNu6Fm1L5SZyj9gDOxF2ny0U4p8zHveUXXS
         J84y2WPECwd6CY+QbFioAd2F6whULoUIK+fd8sCgUKHf9a0SvJpnf1HrBSimhecV5Y/e
         I7IXNCDB+Wsp3cvSF6X3FBL/5b3RyJjzse0OoELVeUsgqCm6oopYkv8HjDRgw2Y0stbm
         fB1PKBvp8r/7dUFGWw/fghMdxBlR1esNZUMhSmkv3M7UjMLxKDrOKyCjiZobg/BezMXZ
         PTIJdV7qXPGySxfY62emZu/FO2i/3rrfzbW6WtxhQMhGpNqfuzz1PCrTmMQwPRv1UnkB
         Tqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=cHx9mKI4SwMUFeDJnmO6FDeTX8xlckFn+nMY52mxBzY=;
        b=Ky7jf5i+Mr8MF53rOkUAgoLCigw1ox0PhUJXpDd4bvPXWbpJUgJ0jlmmTP+M2oPSgW
         4ArjtB5BwL6EoGgg/039HE30Z+DD+LIoExUzQvi2ABmF4yFm6TqFkoKsVWVIsyQC6wdy
         1DmWIjXc8C4sMfZxKxEGDC0Hpjv7L5dD832IoqhuTIe/rHaSovpllspyLfnnWod2AvPh
         HLl46MxsnuDIcig27nryWIAmysYWCxd+DVP/6sC/mDqGk5yW0cdZAzsWMQ1hjkVazarX
         q3Gp3E9OpgCgm88aG2Ab1H6D+z4Toq97nM4USmQQYlVUpBvd8FfNUM1q5Z1ULlo2qjfG
         NAqw==
X-Gm-Message-State: ACgBeo1o5DAwqoomAikpPkjVRJX31pI5ePwwSgTy5p/lUy/mfIavKXrB
        6uKwU5O9Ee9tH8nKj02qaTWXgUdiLeHK33Wbnak=
X-Google-Smtp-Source: AA6agR6McXA/XwjBBm6LigieUD1hL65lNXKyB/XDDeVfBVjlvmbnzpI68276wS8HdaDA0bekjkL/4Q==
X-Received: by 2002:a17:902:ce12:b0:172:9512:595d with SMTP id k18-20020a170902ce1200b001729512595dmr28162854plg.101.1662997713363;
        Mon, 12 Sep 2022 08:48:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b3-20020a656683000000b0042bea8405a3sm5711562pgw.14.2022.09.12.08.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 08:48:32 -0700 (PDT)
Message-ID: <631f54d0.650a0220.c299b.910c@mx.google.com>
Date:   Mon, 12 Sep 2022 08:48:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.8-181-gaa55d426b3c1
Subject: stable-rc/queue/5.19 baseline: 137 runs,
 1 regressions (v5.19.8-181-gaa55d426b3c1)
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

stable-rc/queue/5.19 baseline: 137 runs, 1 regressions (v5.19.8-181-gaa55d4=
26b3c1)

Regressions Summary
-------------------

platform      | arch  | lab        | compiler | defconfig | regressions
--------------+-------+------------+----------+-----------+------------
rk3399-roc-pc | arm64 | lab-clabbe | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.8-181-gaa55d426b3c1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.8-181-gaa55d426b3c1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa55d426b3c1398049a8e993b5306e99d6bab20c =



Test Regressions
---------------- =



platform      | arch  | lab        | compiler | defconfig | regressions
--------------+-------+------------+----------+-----------+------------
rk3399-roc-pc | arm64 | lab-clabbe | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/631f21c592bfa2dcf035565e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
81-gaa55d426b3c1/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
81-gaa55d426b3c1/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f21c592bfa2dcf0355=
65f
        new failure (last pass: v5.19.4-389-gf2d8facb7bd4) =

 =20
