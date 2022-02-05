Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16BA4AA9D0
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 17:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358558AbiBEQAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 11:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiBEQAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 11:00:30 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639B6C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 08:00:30 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso1181923pjg.0
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 08:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A6wlfw6vdkgouHAG4E2dd8bAu2eWC1mL9JwGQ1J2Chs=;
        b=7CDly5Pkxrt5EGAS4wFnzqqdEm5Ps8/+y7dPOp992+k2be+N6o3/cL6VmA/lAleQpP
         sZIpo/HgGq9Y9kp1gGZzPElFEs9lyDJKH4sIXaQ4qa8jXmz5gTrsw13U8H+Gawcb4j0E
         OPtofFF4EsKBlEqnZOegA7ZnlKjcI+sphaVze3VCkgnMpjFjA2afWLN/WgrRvY2tSwdZ
         YRD9zqxwrYqZYIVo05LwUbCMFpmor8XA1M4Rwf/DmNfO6j0HJ542TQVXACkOeOcnrKwl
         nGSeTaAKhF7p/mpImk00b0b3Z9kp/dlTl764g3i+iJg2WVJ9SFPTSKPRhvf6UfBBLUIJ
         YVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A6wlfw6vdkgouHAG4E2dd8bAu2eWC1mL9JwGQ1J2Chs=;
        b=StCa9+5rIYHlkcfg1wyuKnTtrsv4aGlPpjAfS5kPp2cE2/IKAzGXurRhc9PeUjtlUr
         Mp6967yFAZEDvBbVwTLoqggzyhG6iHi1/bpobk+vnbo6EPBmsVzlQTD8IKDpfef8chix
         xMa/TqdpzU4XsMi3x+V25WjCmoMh6dkfda++4lqQmmiXtWhC4+b2HIYqKMzB1Ed+cIhU
         ey3gK0hLxwbE+pvqKxOIcLgFI8kUY5XSHAsnS5Ll5qyNq3yFY2Qyy38AQcHnzgyJq41d
         OGlim7pD865nc0WWQ4lz3MfBVd+jBcI1E9Xl7lxyycqiyOhQgBze2/rxlDOGevF3lURI
         T8xw==
X-Gm-Message-State: AOAM533Rdh4txY/w6sZQovdmfC8OCdTmjggSFh80NQp/fxiA1XcmOcKK
        TQrRDwiKAWgQWNZQrphJGtevt2uI5n6c62w2
X-Google-Smtp-Source: ABdhPJyzliM4++Cltm3nXWUXJzQMoSv1e3LzUF8vk/JNjlErUFISFku/QMpoC+rBZZ67qPEpR/hPxQ==
X-Received: by 2002:a17:902:d2d0:: with SMTP id n16mr3557967plc.5.1644076829753;
        Sat, 05 Feb 2022 08:00:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13sm6014869pfh.197.2022.02.05.08.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 08:00:29 -0800 (PST)
Message-ID: <61fe9f1d.1c69fb81.f842a.fa2c@mx.google.com>
Date:   Sat, 05 Feb 2022 08:00:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-32-g4c0dd9831427
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 107 runs,
 1 regressions (v4.9.299-32-g4c0dd9831427)
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

stable-rc/queue/4.9 baseline: 107 runs, 1 regressions (v4.9.299-32-g4c0dd98=
31427)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-32-g4c0dd9831427/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-32-g4c0dd9831427
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4c0dd983142795524fa7403b03e7728172288c3c =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fe6768a66d7160935d6eea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-3=
2-g4c0dd9831427/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-3=
2-g4c0dd9831427/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe6768a66d7160935d6=
eeb
        new failure (last pass: v4.9.299-32-gd7365d857865) =

 =20
