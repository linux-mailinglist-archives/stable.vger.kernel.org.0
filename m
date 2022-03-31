Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0304A4EDA42
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 15:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbiCaNLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 09:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiCaNLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 09:11:46 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6ED1BE130
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 06:09:59 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bx5so23988532pjb.3
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 06:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vkndecjXwo0Rp+4j4F3IXB3tTm939b/9SD2HAsOQcIM=;
        b=1iothNc55wtZJIyScSLxkatJEeA0z3j0HsoZkBvFhMJjMjZsQUdpXEajkmwtOaDvNQ
         9X6jlIe2AQNSZ/pejcQC8Ys1UBTDS4eOF8rgorzA6s62auD4V67R6oOaAN7+/hKornfi
         qIv1ziK0egknYGEhu0UFlQGnmkEe5B0nkmjIfpcCDXdbgV1qzbWWbjS/YzbJkyuySoj6
         gILtiDl3MCcG0XSZPn69vzC84fgI+zuvKacRhEI6B1Yutg7zQbWy9o3JvcW3XE8+vACL
         ooxz3fLCFFdGbF9sOA3nLbMBWDrXLmFSDMHburBozKGz2mi031z8VgQR/VOnkttq1/n2
         /H0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vkndecjXwo0Rp+4j4F3IXB3tTm939b/9SD2HAsOQcIM=;
        b=tYqgP6EU8v0sDE2irQg2MgUerNUQt/jJ+x95jSBM+LzWv4u5zxqnNDZ1mPmCnH6qM5
         SgTZfoc3gnJGssQrPIygBZkVNg+A/+hKwJvvo1fxfL8wMFBso/s26Jl7fNWwpXSWh+5m
         Z8H0NUF1Jtpga9bLdJVIK4gIne27E/rjridlup8/hbiSFK8Rwy+U0rBbBSvnbGPm7LfY
         KgCf0efWJL2FYdBsKkv3MglC2nG0Xd5BSNiP+FkASLtoW2hwyi6PqvGw+VfFAoylXrvv
         ExDLAJzaBUVZMUCST4/LyctjfRPeqCSwRKSMWDu7s392eZJV/p3tyWcM6B5jnStjFQXM
         Qggg==
X-Gm-Message-State: AOAM533gfSpMw0uGp+85C16+zzMjDVmPRfIFIoXlS1Cw0P/2ba0Yrx3h
        sNGl+9vmRi72zOMI1a4ymrykodXkg92ErNqpK8M=
X-Google-Smtp-Source: ABdhPJw1LJNllysU890Y9QX/OnnAIQw2yYeJ6suYmNk1yC5H3lAOXuehUFNKdYD17mr/BmHMh6ov5w==
X-Received: by 2002:a17:902:8f94:b0:14f:d9b3:52c2 with SMTP id z20-20020a1709028f9400b0014fd9b352c2mr5197785plo.103.1648732198345;
        Thu, 31 Mar 2022 06:09:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020a056a00241000b004f3a647ae89sm29058140pfh.174.2022.03.31.06.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 06:09:57 -0700 (PDT)
Message-ID: <6245a825.1c69fb81.349a1.9c67@mx.google.com>
Date:   Thu, 31 Mar 2022 06:09:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-15-g3b9421ab0f46
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 97 runs,
 1 regressions (v4.19.237-15-g3b9421ab0f46)
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

stable-rc/queue/4.19 baseline: 97 runs, 1 regressions (v4.19.237-15-g3b9421=
ab0f46)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-15-g3b9421ab0f46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-15-g3b9421ab0f46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b9421ab0f46f51a243f9b9d0e7f44674e9c5b1c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6245767d22e35c4d1eae067c

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-15-g3b9421ab0f46/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-15-g3b9421ab0f46/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6245767d22e35c4d1eae069d
        failing since 24 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-31T09:37:43.440824  /lava-5987598/1/../bin/lava-test-case   =

 =20
