Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100DE4F1B0F
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379437AbiDDVTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380282AbiDDT3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 15:29:31 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEF026AD7
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 12:27:34 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w7so9875535pfu.11
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 12:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ETopXykvSm5fKA3wPhxN0bS3voGecvAc4Md/5c+Gh5Y=;
        b=BKcvexZXtVzvVLj11qhPAipdf0p5aLZjwPUzoZk9L3nSFa4BZTWyvbETS/D2uGXXIg
         v2RICPIes7DMGn2c9oqxljLyar/yx/jW6pvmEN/zB9TaMjmjNg8s7Dgj57mD6ax/CUON
         St91poIXYSk8GncVfedTLSXn6CIaRqANxpV8KgSwMbkycDjGRM1w8V8qyyOgGpcZVLu7
         yJLB1jWMfGcQSyNYP9t3MdDa2Q1MwUEmwW04P/S52QF47tj2BcTKBZu98dgmKkBTjoZC
         AEuu/v3pUZ7HlRLG5Xt+FSWSRQK8Y3hyv8uB47GEt1MjafRG+G132SP2VH18dcNOGWDf
         Dlvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ETopXykvSm5fKA3wPhxN0bS3voGecvAc4Md/5c+Gh5Y=;
        b=WAQa1msLcWyWDn1ZVy7l0gO5Eox/dQIwRFMxwkMENRLhk7oLE0mDyGK0BHv/ZAsKTJ
         34VUU2HY2uc39FGC0+fbwzaJMp1tjK4UxB4eMdC53p04wkIik97SbreMBhO8yTZL+pIl
         liu47sYkdNXFecMlBz/zOo7d4KjlC75TEEAjZWsSdFmiNN8BQbumv+0L2AE2iFsIJ2NX
         2aqw1G+PIjlfGrZk/SoyufzDaJRlGzjyu9xbz96wjqWnXILaOWFloOFg29/xw3W7JLeR
         w14NExa3wQl4L/ib7cDrzpksvS7DJvTa2EAbDD0uthURtSbW6Q2L6M0qRP++YLjYf1mu
         t77Q==
X-Gm-Message-State: AOAM5319k+avhm7yZINZTw99zW5Qti18OASMH6Dl15i1e+489W5JUNSH
        RqEOImunU+kXt5Fmn6mfHObWHJ+FVvJing4HEWg=
X-Google-Smtp-Source: ABdhPJwAUbCtz7uedQYq1myxp3i2bQgOA9JlUPOl0n4pHPVlMWkJXnkk5PTFwDbnCzZ0KbGPWRqhQg==
X-Received: by 2002:aa7:88c2:0:b0:4fa:ba98:4f6f with SMTP id k2-20020aa788c2000000b004faba984f6fmr1062608pff.41.1649100453742;
        Mon, 04 Apr 2022 12:27:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a708300b001c7e8ae7637sm227519pjk.8.2022.04.04.12.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 12:27:33 -0700 (PDT)
Message-ID: <624b46a5.1c69fb81.296c6.1005@mx.google.com>
Date:   Mon, 04 Apr 2022 12:27:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.18-1014-g5e405d759c5da
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.16.y baseline: 55 runs,
 1 regressions (v5.16.18-1014-g5e405d759c5da)
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

stable-rc/linux-5.16.y baseline: 55 runs, 1 regressions (v5.16.18-1014-g5e4=
05d759c5da)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.18-1014-g5e405d759c5da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.18-1014-g5e405d759c5da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e405d759c5dacbc99e6f5740f17ef44c83c0c82 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624b1eb65b477e42beae06a8

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8-1014-g5e405d759c5da/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8-1014-g5e405d759c5da/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624b1eb65b477e42beae06c9
        failing since 29 days (last pass: v5.16.12, first fail: v5.16.12-16=
6-g373826da847f)

    2022-04-04T16:36:49.119431  <8>[   32.233056] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-04T16:36:50.145849  /lava-6018339/1/../bin/lava-test-case
    2022-04-04T16:36:50.157043  <8>[   33.271162] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
