Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2E58579A
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 02:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiG3Aqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 20:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3Aql (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 20:46:41 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E8767CB3
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 17:46:40 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q22so2178073pfn.9
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 17:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C8Kc+RnIzk6tSDCxEqZLtgsM7m0aGzrakhyKoa667ts=;
        b=BCM1UKr4hL9wFWCfCAbNeUmdOjWv2akFqxYomLaNQhY6gy5dh5yI/UpvXHfiLBRMkX
         //X3Kz+i99sCtvZGHjRmbCHUs96uUqCaOy0lTkwx+v4Q725RDQUHVCUAkxs08Wg/n0og
         L4SfmnfzHZS8tVwVgB/ProLbKRldUVTWOwJjv+yIGcmsnUuRjTmD6K23TdFQCSI6zF1d
         0TQcB50/0kgsL028ESYzTbVQ9uBfKDfjnbDRPRQ59OLKmRWGDl9cKP8meb007hwhDszr
         uhzGc1yuBGVbAfN29mRh2EV7RR1l8VCVF1fpCYg2UvJ8QHlmcvCOtaIP4BTzJeozadiO
         N8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C8Kc+RnIzk6tSDCxEqZLtgsM7m0aGzrakhyKoa667ts=;
        b=21gskFW3p8Uz/3F6d3SSt5qG+0TAtcWQ2n0vphZ+1sz0nkBDd/FU5IHkr+mrhYLXgo
         mInBnGMuSe4IZqiTWEujJupcqDFtPlECBlfQcicyogvWZdz+DXLJfRFka28vCrZUHrsX
         QNmo4Ty0M9kB2LkQ9aA11KEOWRfgJ1Zdswfg/kbwntfzC/YuUapu1PULTOulLdxN7SK6
         xymGGSa2wDxIQGsXslit18IPt+CxmlH/5H18NrPJntr+P7jqLHuAmBC9xe/Y/Pb9Nmjd
         awCYxhh4g0qZdj/K3I/acYh7Bm0oa2jOt+M+D+8Xj6oLdIkyUq4ilnUBzXKxweY0q+ew
         hfTQ==
X-Gm-Message-State: AJIora+0FVddNef7oKDgLbAuHuSiqSNf+pWACJIp02Yu6q/JJN/1W67a
        LOu+6zHw39Tn7iNqsAvctAdxOe5rQ+9BRpCveKo=
X-Google-Smtp-Source: AGRyM1sKnD+RKmaE21iUXQCNlRUpOqcrez+UXh1nFCsa3qe2cV9ySEI4xMm+DkqYxnG1hQUkUuGkMg==
X-Received: by 2002:a63:e616:0:b0:41b:8f2c:1065 with SMTP id g22-20020a63e616000000b0041b8f2c1065mr4385675pgh.244.1659141999752;
        Fri, 29 Jul 2022 17:46:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e19-20020a17090ac21300b001f320faea95sm3665645pjt.2.2022.07.29.17.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 17:46:39 -0700 (PDT)
Message-ID: <62e47f6f.170a0220.8acc9.5c68@mx.google.com>
Date:   Fri, 29 Jul 2022 17:46:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.58
Subject: stable/linux-5.15.y baseline: 114 runs, 1 regressions (v5.15.58)
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

stable/linux-5.15.y baseline: 114 runs, 1 regressions (v5.15.58)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.58/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.58
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7d8048d4e064d4ef7719e9520f6c123c051fca99 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e44a49b729cedf43daf080

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.58/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.58/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62e44a49b729cedf43daf0a2
        failing since 142 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-07-29T20:59:35.788939  /lava-6918335/1/../bin/lava-test-case
    2022-07-29T20:59:35.800313  <8>[   33.604601] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
