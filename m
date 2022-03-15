Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043E54D9251
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 02:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241305AbiCOBus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 21:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiCOBus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 21:50:48 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3BE10FFB
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:49:37 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n2so15052688plf.4
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7pUDiQt+R9v+bnX7Z5EGLUEipKbLvHoaUjioM+3XCDo=;
        b=d2dltg2nX2CyH7TiMbXnveNkZaTLgeMVgucot34fxLe6L9rOiW5miTjiekAW72Clj7
         wHwjVvXY25M16eCl5zh4JCHjEY/fIm/6m5ZtttZrDJmIN6cbNZYMDXvHw0lUmNwLl9Y4
         y01vKMSy5wKsGjxTyN43cUSCaCfxm5a4YlAzF+XF8vakObbV6ct85521p1+5xPeAuPhz
         YONV/WvUXuvtoYWCC/UnM+LOa90KqcV8JcNIvQ1/nkutK7TWnUFfB+FWFLv5b/OrRhPu
         sJyUR9x0DH3l4EYGLQf+u5uUxKCCBFJscwhcgV9Yj/COGmziQ1UP9zZLmY6Q7/YWKEha
         sPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7pUDiQt+R9v+bnX7Z5EGLUEipKbLvHoaUjioM+3XCDo=;
        b=YKNGzKCvg04z8opbeOcr8iFeb2iPFI7A2iV0PgPmRmuofgki6xMWxgo+9zLVKzRt+4
         kzvTddybIHrjAFvG5RsCVw9fBTmuxvG85YqXK5yb1Ggb9gOp8anb5SZ9Fen6XB/C1/z1
         7fCbjKJcPrZpYo0JsrsbX6gYpAGlxMncLnFAL9mDL5HkClFlJGnHvY00PcxcC/KC16aj
         bU2ygCeVH3/6rvntzxf3YSjj+hIJRhuYZgcIHBFzMZf65lGm1OYx0decdrGOVv+eYyaI
         gDtQIOG7KvzpBrCGY2eJ3bRGGG+eV7HTntBvhkkr3clt8fPNUjl5lyAzGK72DmaBjWuU
         Fuig==
X-Gm-Message-State: AOAM532fqhqfLN+0AYB5IIWOlyjcLJzkMDMFd/3XH4WHFjolRmVu3MCu
        F1u2ihoLAppmWkCq4/8rC6mc+N6xem6e1NQAFtE=
X-Google-Smtp-Source: ABdhPJyOeiDaqF5NoEHurcSqrnwYh2q5FTL7EJaIk4l1bqCAEHJ1AMpEwDCvSBW6+Zrw27AJ8OGTdQ==
X-Received: by 2002:a17:90a:4289:b0:1bc:275b:8986 with SMTP id p9-20020a17090a428900b001bc275b8986mr1899594pjg.153.1647308976673;
        Mon, 14 Mar 2022 18:49:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c5-20020a056a00248500b004f6b5ddcc65sm22615079pfv.199.2022.03.14.18.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 18:49:36 -0700 (PDT)
Message-ID: <622ff0b0.1c69fb81.8c2e.956e@mx.google.com>
Date:   Mon, 14 Mar 2022 18:49:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.105-71-g8a072a7bbdc4
Subject: stable-rc/queue/5.10 baseline: 70 runs,
 1 regressions (v5.10.105-71-g8a072a7bbdc4)
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

stable-rc/queue/5.10 baseline: 70 runs, 1 regressions (v5.10.105-71-g8a072a=
7bbdc4)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.105-71-g8a072a7bbdc4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.105-71-g8a072a7bbdc4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a072a7bbdc40ebeaba398d5b9f81a410265fc91 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622fb95ed702453fefc62976

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.105=
-71-g8a072a7bbdc4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.105=
-71-g8a072a7bbdc4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622fb95ed702453fefc6299c
        failing since 7 days (last pass: v5.10.103-56-ge5a40f18f4ce, first =
fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-14T21:53:26.918906  <8>[   60.054536] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-14T21:53:27.942055  /lava-5879164/1/../bin/lava-test-case   =

 =20
