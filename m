Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CEB4E388B
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 06:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbiCVFju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 01:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiCVFjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 01:39:46 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5761737A2E
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 22:38:20 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q5so5331701plg.3
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 22:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z4YCCL1LPnHOzXwP3bnu88d5CnE0dJ5cFjZZBF8cRbg=;
        b=SM1GkAc8gp+axzLpAa6ZShUarP0CqxNqEs9UWR4lYNEoE7jCYskPQDY/kyYglPm1Z9
         soARGpUypX92uo+amn/yKjhrccy7cVraQv8cvufHeBNqJJLhYhTfM90J71TGmOQ/6hrd
         SNFAhkOboIFu9Nu52A6nOrXR5rYr2ccyFGpDgtkge8mCt+x9Oah4aw1/v5xZBuqFMpu1
         x+Hv1pJ7sF+m5OLR9Zi0KYUZieBu47NCwV6Ba7BJDJkeBp0GCkOVnEyuWb1J1ffYA/6l
         E+6KVzww1vFKILGTbbYZX5+IXwHuMqEsSJx+MFigkuh/guFdEsaklmACH4I3EXRrphTm
         ui5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z4YCCL1LPnHOzXwP3bnu88d5CnE0dJ5cFjZZBF8cRbg=;
        b=JY4zAoRSp/9DyKpQTWfZK4pft+KOp9CKABwbwOuEopLm3pU15n45g+r0NhgV8lyF5P
         MCf1ABC5Oe62IgEfkqUOvNjzFrdDxEe8pxsrHB7esWzZvQbMQaN2cGDJ/pvWjug9CkDo
         pLqMBAyWrLvNhCIwIIuVToUnYvV5WQwEsPNWIK7cT0YavnFufhnuE1gg8X9mBenITs8K
         js2jeg6koeP8e3DQEa4YMssXD2oWVL3sEypaWWOm577aKp5KzEvGkU2ZgHertoWLX/VM
         IzSZf+Ng0wsQ4VAHt70bWAxUMTurITi0DQ5BGRrsS+5JYSq2E0hPgCvtEeEjnhkxyAlQ
         n3tQ==
X-Gm-Message-State: AOAM530NSBvLEb4UiYNViTt3gIxFtBPQmG/LzSgVcj+5fTJ3+r6C+bRM
        EFjlWGrVhIWIbopFClPK9EG+/H4xTDm5kIP/Ldk=
X-Google-Smtp-Source: ABdhPJxpG3qU2hKooys36x5VkjZc+p/Af/rzGM5Hf2KG8IkSwgzd2eTkcoDGOmnLV2CP19qGbNui+g==
X-Received: by 2002:a17:90b:4c86:b0:1c2:5a5c:9149 with SMTP id my6-20020a17090b4c8600b001c25a5c9149mr2937110pjb.241.1647927499577;
        Mon, 21 Mar 2022 22:38:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m8-20020a056a00080800b004faa4e113bfsm5706521pfk.154.2022.03.21.22.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 22:38:19 -0700 (PDT)
Message-ID: <623960cb.1c69fb81.61da5.0654@mx.google.com>
Date:   Mon, 21 Mar 2022 22:38:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.107-30-g6aadca3f97b23
Subject: stable-rc/queue/5.10 baseline: 87 runs,
 1 regressions (v5.10.107-30-g6aadca3f97b23)
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

stable-rc/queue/5.10 baseline: 87 runs, 1 regressions (v5.10.107-30-g6aadca=
3f97b23)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.107-30-g6aadca3f97b23/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.107-30-g6aadca3f97b23
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6aadca3f97b2326c4f268d60dd5813d9180af454 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62392f53ae379353912172d3

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.107=
-30-g6aadca3f97b23/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.107=
-30-g6aadca3f97b23/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62392f53ae379353912172f5
        failing since 14 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-22T02:07:06.446297  /lava-5919805/1/../bin/lava-test-case   =

 =20
