Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF48D51A7BE
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiEDRFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354079AbiEDRC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:02:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DBB4D609
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:52:31 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so5676192pjb.5
        for <stable@vger.kernel.org>; Wed, 04 May 2022 09:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tiJ+SMfqmyyUp7EYbFOnxmNEz2WA4WcgOqlubYEF15E=;
        b=ScHVwHEpcXvHaulZpN0fq9fvf+nkpSt9fiiT1lezm0GTbeEFnfzECeLOTEXXyZl3r1
         KCRCq2CqclMYb/Es64lu+Iu3GZRNTq8A7fYfY7VpNLjYNankung6Jxd7YwGFGXzrNHyq
         4hfm+LzkC4w3E4SzstSvo9zxeo4JuNN0ISO0x9iU68gGYcbmUqLh5yEgS9jOFxL1QjSL
         81eCegaeUA5L8XFfu5x2y1iQh2o8gAkFybCrZUnNuO85AsyRbYxtKQd8EEcRL3j9iy1s
         JmrQOFvXKPTvCVqaeBZnbBkI1LXbn9hB1ktew1r7wCBRZL7xkN38m+6feSPKPP+dSATN
         4Krw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tiJ+SMfqmyyUp7EYbFOnxmNEz2WA4WcgOqlubYEF15E=;
        b=Tllpp9igN6OOrL5K9CiH5ihZvBErKe9GSj/WWkLataNo3b+4Z2VtxTcBzx+byFEOsF
         l0HrgFlzCeJF6zMyVlQ/MTrW8ReZ22DOFmnwu5q9pdRgoTDZjsUhe3G+I+xf5EEFgIFG
         pnT5664EZ466cws3fiHZ3hVsZBaxJkZ2w9XJTuCMKHd/VNUWJQVbNKivt24doX0fzBCR
         StC2itaUqmrFp7R7eyNtRjY+BAgUbxGhyBEXTwQC91cVwY6MUy+2ssrmJJn7gtVtOZGW
         DFwmXUhHDnj0IhJhM/MCg15jDLzmVCJHYmylGaF2DMmsVHpeZvzPILev2Ghkck5xGDmI
         z00w==
X-Gm-Message-State: AOAM532P0p4BCuxajID9vt9NR8ISUZ3eCHFWzY7Cs/8BT86KhzeMG7/3
        A7Oyk0FJc9+YUHJwBZllGF7xXrqZ9ll36G2p62E=
X-Google-Smtp-Source: ABdhPJwuuWEGgFwBYKkfQBm4hUTnCvx4eWBy6aaM5v/KxOd3E+CQgPFWrcQV/MOLzNWOkf6tzqyNjQ==
X-Received: by 2002:a17:903:110c:b0:14a:f110:84e1 with SMTP id n12-20020a170903110c00b0014af11084e1mr22515156plh.7.1651683150306;
        Wed, 04 May 2022 09:52:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f2-20020a63de02000000b003c1dc82292csm8255259pgg.48.2022.05.04.09.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:52:29 -0700 (PDT)
Message-ID: <6272af4d.1c69fb81.4d3ec.4b28@mx.google.com>
Date:   Wed, 04 May 2022 09:52:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.312-44-g77a374c13dc5
Subject: stable-rc/linux-4.9.y baseline: 85 runs,
 1 regressions (v4.9.312-44-g77a374c13dc5)
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

stable-rc/linux-4.9.y baseline: 85 runs, 1 regressions (v4.9.312-44-g77a374=
c13dc5)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.312-44-g77a374c13dc5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.312-44-g77a374c13dc5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77a374c13dc5f694b39862386230dc25ebc21312 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62727abcf809bfe92adc7c32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.312=
-44-g77a374c13dc5/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.312=
-44-g77a374c13dc5/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62727abcf809bfe92adc7=
c33
        failing since 28 days (last pass: v4.9.307-12-g40127e05a1b8, first =
fail: v4.9.307-17-g9edf1c247ba2) =

 =20
