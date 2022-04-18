Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA55505F71
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 23:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiDRVjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 17:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiDRVjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 17:39:32 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DF52E9FB
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 14:36:52 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id k14so21212414pga.0
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 14:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6i4b7qifUtfRUdKABaytQPYOppmk5e4gwIQKX129jCI=;
        b=npUnpXZBtdJVCxtZYUJSRc/cnowB9I9iGWRLeJ0zqWcg03/LUX3oGJg3tpeeHSXpEw
         NouobMZU+53Pko5OZDmfcwOg9SY4fCikj21fWCH9KrNRH/WnF/qRnKEnkEvGOBq4A7TL
         SQr73YsTkcqIES2rTCvrgqCaZb0430Z4+TaEBOf1qumoypBHe5WaNOe5DzQ3+ju2jORm
         Q6tZVf3XCHfrStZv1OyuiXWVu2RLBNjup+hXaZgtZ1lh3ukWwmEKVg//Xd81ajB8HiAB
         OyO4RC5IkBfCPEmQKXL7k60z6p9Mt0JVa3Ym4oZ5to2rod/STsYHmgPOSqPGlenkclhx
         wnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6i4b7qifUtfRUdKABaytQPYOppmk5e4gwIQKX129jCI=;
        b=7TDzQZSaWX/pRTSsZBelOoDK0oZvNM2Pb/Myq4BwLI8jYNWU0XONiClPcp8IOBUQqY
         ehvrgHH5R2sXfLPA2ruK92EqeS8KB8uHm4zqCxIk7kQyDP6Ij9emtETCSQRYtHQuqEgK
         nas4J4szbXHZUrB6G7Vq75XXng2/LSb5Vo6UCQ0ES8VzcutY/v5ucXk7Jag8XKX8wF9c
         eypyeBfdWYCC3E5QRhOVG7jEO3IUixY7UZcb7PmO9YZQE4EkAi7i7tqG0DnGSYtEpSv/
         ymtHlei3WsjSPEhfNjiUDexC1oRQmbHzXVc0gYr65GJFaG4kgf908a3kRXLhi+Rks5UI
         6kQQ==
X-Gm-Message-State: AOAM533/1zQfGca1lgXJJ61hGBQwxp8g6BvFm/l4G/1CCI1uUaX/r0Mg
        f/RoLvsKpDmUh5zht22UhUTj4p0DIqPDNKTG
X-Google-Smtp-Source: ABdhPJwI2YjjHkzALlHTZdGcEbTZhx/TOjjIbRznWzLYClw2CIqAqdSdHKaSGFTZKt2263aZSDKFQg==
X-Received: by 2002:a65:4947:0:b0:3a4:dd71:be90 with SMTP id q7-20020a654947000000b003a4dd71be90mr10798209pgs.449.1650317812073;
        Mon, 18 Apr 2022 14:36:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79574000000b005061f4782c5sm13430420pfq.183.2022.04.18.14.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 14:36:51 -0700 (PDT)
Message-ID: <625dd9f3.1c69fb81.97fcf.fdb0@mx.google.com>
Date:   Mon, 18 Apr 2022 14:36:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.310-219-g6c5f018242b95
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 60 runs,
 1 regressions (v4.9.310-219-g6c5f018242b95)
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

stable-rc/linux-4.9.y baseline: 60 runs, 1 regressions (v4.9.310-219-g6c5f0=
18242b95)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.310-219-g6c5f018242b95/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.310-219-g6c5f018242b95
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c5f018242b95dfc19fc76393fd4a89a2be197eb =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/625da880d30ee89f48ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.310=
-219-g6c5f018242b95/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.310=
-219-g6c5f018242b95/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625da880d30ee89f48ae0=
67d
        failing since 12 days (last pass: v4.9.307-12-g40127e05a1b8, first =
fail: v4.9.307-17-g9edf1c247ba2) =

 =20
