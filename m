Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102054F7682
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 08:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiDGGqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 02:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241317AbiDGGqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 02:46:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8DF100A53
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 23:44:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id kw18so4712915pjb.5
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 23:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V6IYfquQ4BCyl/d//EyLTFKIsvBfz6pJT0t49N6QPK8=;
        b=lr0L8aSMBmqLHuS8OVENVwyhMdomIxU/UgTOlGnaEm0iAWdEf8CJ8tU6ONnQ4Rx7hj
         5Hl9ucVcUPVlTWU9WngdpBTDgnpf8DYKmvQwIG5pjr9APqZjCpfLPDm5ZbiuTd8fzAnn
         g6+7i5bMpUwwTJY2Aii/F4V3PD6o4FT4H7Q4PYH+Pfxnj4LH/bz1J07w8CzMCmVnsXYo
         jFm9DXd7Z3fOgXr18C2cTWjPiMLBoH3++nbQ56ZTMcjCsDhQ/E3IQOuBiEqvnChcP1lr
         mBjYYmHcwO4XsFjqffp+ASfgAePRutGvTYLQxFUTjbo1ccxWiK3+T/7pqINJIvDL8/eL
         jCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V6IYfquQ4BCyl/d//EyLTFKIsvBfz6pJT0t49N6QPK8=;
        b=gChZdaxEKs4erdxhVaBGWd/4LV4VhPFiMqlRQX+li5BnA2gUDWwyT3UfewvUEnM02e
         PyEmLjsgfUHbZ1CKC7UHKWRj7aIJZfwn8mLcLbhnqb2aXcknOKqD9yUd5bNKjof1yzOG
         ynIWo1VpUEz6W7PF7yYJVMDVh0BzKB1Dc2B3UQ13Mx+3y/ynnC7HsQgytHYs0TFGLoBz
         80Cn+Qka8DA7el90IFiBH+a0IJC6/Khs2Eu6gjGHxg510x60b5oqDCzfrWeYE5QxjMCR
         0hK81/YIU4cr3Bk7HfDrm2H34ziYewLaG9GOUUFLPh1sav0XAyJ46U0TlcH0Rnbrf164
         MRNw==
X-Gm-Message-State: AOAM531Dp1/H1pPRZFqXHESHOleu5H041nsMulvtpx2PKpq67HKlE1yF
        dIyXUfHepoUH2/C3jsdXuLLGX67Oj3v/5Aktx90=
X-Google-Smtp-Source: ABdhPJwGFWiUsPVxzy2QStlaFdVwg/EGlrewAT4G/3u/xFfYw1WaNcYDoA96BDn3elEJGHuEHPCL+Q==
X-Received: by 2002:a17:902:ce81:b0:156:ad26:78b1 with SMTP id f1-20020a170902ce8100b00156ad2678b1mr12553023plg.144.1649313853113;
        Wed, 06 Apr 2022 23:44:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9-20020a056a00248900b004fb05c0f32bsm22182788pfv.185.2022.04.06.23.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 23:44:12 -0700 (PDT)
Message-ID: <624e883c.1c69fb81.99591.adbf@mx.google.com>
Date:   Wed, 06 Apr 2022 23:44:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.1-1123-g788cd6072fa15
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 75 runs,
 1 regressions (v5.17.1-1123-g788cd6072fa15)
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

stable-rc/queue/5.17 baseline: 75 runs, 1 regressions (v5.17.1-1123-g788cd6=
072fa15)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.1-1123-g788cd6072fa15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.1-1123-g788cd6072fa15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      788cd6072fa15b0b6e0a73269fda3d714c1e97d6 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/624e5566f24784261aae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.1-1=
123-g788cd6072fa15/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.1-1=
123-g788cd6072fa15/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624e5566f24784261aae0=
67d
        new failure (last pass: v5.17.1-1123-ge757891cb39a3) =

 =20
