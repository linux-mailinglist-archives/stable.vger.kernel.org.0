Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102DF4D439D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 10:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiCJJhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 04:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiCJJhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 04:37:32 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2287413AA07
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 01:36:32 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 132so4259589pga.5
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 01:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eQWD1SZK9LbGvM/vKqBxg1GGYWHA5BBTxpYXBemrj3E=;
        b=y2PN7jUQg1k7SYckzpaMRWhSKPn2aID0z+eIaVWnVxDA6DSyq5/Re54easoU4UG/qQ
         rZHFjT+2tYB3xm2Bww17lDuqnbbO85OXr4X8XE2Iq6I6cxuf28xYNu/b2xqlZNfmppdM
         fC94OC74RBYi72x5A5FkIthF45SSTLRcM1TRRSIO1N1M4j5W8iDpgM59wNr3AKG/A216
         ivhZAZNkRrUlIiZeCR0VrmgvEssUa5PL5IkqOBDDYOVOh1yRjwxwc0oakVaYu7i0jKH8
         Rr+cWQ/S6SDx0Xf0eVDnmuZ2KgKX7xKrqiEl/1qzRfPrXHqmQoZaxwplmmGJnrXKt3iJ
         cD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eQWD1SZK9LbGvM/vKqBxg1GGYWHA5BBTxpYXBemrj3E=;
        b=cfCxrHpLjWkjBJ1yOb+a9w4Zg8dk14ZZtnwAdpXJX2hzv/AuRLaP+c/u0FAm4Oxb3R
         BhTSs0hAKK7BUU5brjqmH17yRVYLO9eLqyMGvBWYTmE258iaCtklPstWdVsuWIsPtwfJ
         ahAtM77vweFb9IlA9fYyb4vrS6dMwb0ILdYKt0zThYDeJz4js8T0xJ8uPbNOST0w6zKT
         pHJiMtyr0G1nRuTM0G+Ps4BN7ZzHtnyHuDdfOmWTVntFt+4uE1p9TL6HB6PSnGmHBX9e
         MJvbCiE+rAfiX2vDuaNfI8AFKvW5R20GpbTDEbvf3tira7i6ghfpXiKo87Vbbo35cWyw
         QwnA==
X-Gm-Message-State: AOAM5314ioQw62Yv+i26DNlyuCUxZA/CF+c852CuDkA0cFnDJLlKfoMY
        BzO7VsYu7dvlqS/9cp/UXSLv56rupjIffgaLiJ8=
X-Google-Smtp-Source: ABdhPJxhJ93tV9anFPCsf8U9cXDUR+JACS+HbdVXPRF3nRHgE0XjpL5JAiUSrIYP1mb++H02m6DWIA==
X-Received: by 2002:a65:464b:0:b0:36c:58da:5892 with SMTP id k11-20020a65464b000000b0036c58da5892mr3276534pgr.439.1646904991501;
        Thu, 10 Mar 2022 01:36:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ot13-20020a17090b3b4d00b001bf0b8a1ee7sm9647099pjb.11.2022.03.10.01.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 01:36:31 -0800 (PST)
Message-ID: <6229c69f.1c69fb81.24559.8b31@mx.google.com>
Date:   Thu, 10 Mar 2022 01:36:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.27-46-ge7b7e53d8c69
Subject: stable-rc/queue/5.15 baseline: 104 runs,
 1 regressions (v5.15.27-46-ge7b7e53d8c69)
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

stable-rc/queue/5.15 baseline: 104 runs, 1 regressions (v5.15.27-46-ge7b7e5=
3d8c69)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.27-46-ge7b7e53d8c69/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.27-46-ge7b7e53d8c69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7b7e53d8c69be88870e8d476f294c5bec5ba562 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622992ecb50bf65ee9c6296d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
46-ge7b7e53d8c69/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
46-ge7b7e53d8c69/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622992ecb50bf65ee9c62993
        failing since 2 days (last pass: v5.15.26-42-gc89c0807b943, first f=
ail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-10T05:55:49.163830  /lava-5849719/1/../bin/lava-test-case   =

 =20
