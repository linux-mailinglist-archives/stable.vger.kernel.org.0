Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD651508845
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242473AbiDTMjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 08:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359377AbiDTMjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 08:39:16 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFEC13FB3
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:36:31 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s14so1647994plk.8
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0d43GRhpVUiRoXkfwQCMX78+NTHP5weVT4fF4eWf2yM=;
        b=ZHfX28/Astzt6AztvR26eFJ1nqvc5rV/k3+CY0cKtXhCViu7K9rataEo6zq+l8QuJc
         1ZCs/DMOmLwiqC2qqTmLnh0zt+rqJ5liKqWQZJMIqi1E8zQN4ODWVwdmvHstfy0LTLzX
         MgnLGa4XyZkRMMqQMuxafIBUCflGrLRcJSuxrQupXL8gQThWF035Y0bIg9I2auQ4x+2d
         Gbs/A/ftaZLQBC3YPIQMhrHsZnQVdHiBp8eRR9GHN+o8lIFvS29XefQ3BygP9k7rHNxQ
         gJuVWHFkK2s7e+nWVdLO0UBF3jgyvlRPvlVH0+B9zOEofqmCZL/8CTi0NqhrUGZNsRo2
         XTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0d43GRhpVUiRoXkfwQCMX78+NTHP5weVT4fF4eWf2yM=;
        b=fNqqwAC7cLNv5i9QI5Jex9e4c/iIPv1odn+1Eek5r9wSgzQTml75/tVHfDjVp08w56
         pTdpaKz9uGTvOtTMPU/fGc8QdwI6jD093QZtUtrcMUfgA9xLwS5o8m3/t+24iC8Pau9f
         BZga5mLWzjQGbGvcEwXd1ajvInRk7Woyz2sUT+W47ZOUDKRx5q1JjkFSUZuJR6Jm6/6T
         L9r1+MG7u36YBCE21Ki5y7egCL92mlyP2igGIZGdPYuS1pkFT7EDqg0FPnWl5Zhy948m
         aNAmKeYE0BUADVmiW9D29GW0czmnSbs2sTlKcwjDql/HbRm3PSJd9EHYRkokSCHrXZm6
         u3VA==
X-Gm-Message-State: AOAM532tjumu8VYQZptg1I/rJuXhY6aU0YfaflPkkMEZ+yH/RSCfZXYy
        oFLRXoIA+iSbBOi9zR3SexGjpLpae7cmqf5H
X-Google-Smtp-Source: ABdhPJy1NCludtduwzLRbEB+NDZRNOPUkoTGaATObGudYozSqAkwY0EtBWTssqDbLFM/s2hwTQnH3w==
X-Received: by 2002:a17:90b:17c6:b0:1d2:fa2d:bb7c with SMTP id me6-20020a17090b17c600b001d2fa2dbb7cmr4278505pjb.22.1650458190460;
        Wed, 20 Apr 2022 05:36:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020a056a00241000b004f3a647ae89sm20350002pfh.174.2022.04.20.05.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 05:36:30 -0700 (PDT)
Message-ID: <625ffe4e.1c69fb81.19537.fc6c@mx.google.com>
Date:   Wed, 20 Apr 2022 05:36:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.311
X-Kernelci-Report-Type: test
Subject: stable/linux-4.9.y baseline: 74 runs, 1 regressions (v4.9.311)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 74 runs, 1 regressions (v4.9.311)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.311/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.311
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7eb61afe0cb414664c5944ddc98087c6a37cbd34 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/625fcd3a38ef7649cbae067f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.311/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.311/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fcd3a38ef7649cbae0=
680
        failing since 13 days (last pass: v4.9.307, first fail: v4.9.308) =

 =20
