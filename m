Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D9950766B
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 19:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbiDSRX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 13:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348515AbiDSRX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 13:23:56 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6B937BE5
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:21:13 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so2480897pjb.2
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lBqkmY1TlRpBRJcJRn2WmgzJODN7vJCx2lpi1eDmAT0=;
        b=joiE3BRW2VWdd2RPxEN0i+wfwQJI0P0umMvYsNmzc4qnANhb07SqMB+wCaiDdfrLHW
         iIrCkTx1n92E6U0bVb1mNK4HG+94hkQtOVRliMPt0pwCZc19RFoIFRWfkvUM5n6kLXA1
         9rfY4vq+15123lgV+vl/weN9+31p+L2QawYXqg7n6YQ6nO6Sb/A7V6YMeOAH8agZOfkZ
         B3202EpiFC3Ls/uUrJwG+ZzuaYUSxx/d9jak8OSN7WRGFwmcCYozexuQow6/7sG1OzrH
         ceSZ+fmdkLoU5bu8IXmRO1MsvIvgvW4imW+qmzC9SvfoUKw3TZy/3nZbftpWBk7e3F6m
         7uCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lBqkmY1TlRpBRJcJRn2WmgzJODN7vJCx2lpi1eDmAT0=;
        b=w11VJtlz3y5sn8Yknd1SqZk0ifbr6qHXnVp+/Kt+7//HwApJkg+7+8XibpcpKyi7Fs
         VWVjeYOIk41osv6VcCtrKyKzMAKQhl1tBocbSke86Jwwd+rl1t4+9rQu3vwA0IiRh1sD
         Lc/XN/v79ojYntCMS9ihmHsGn9oTXr1jYwHITraAbXHznNP0fEKGzq7jO4sA7EkpaLxq
         v5MxBmwVrtk3aPl3wa0sUrAnTRO6vdI5KL4czvPoW8bCdSERYei/qlGdOoSip0RtqjP4
         PZYV0debsxQxAZrLplC3MiULI3WJ7IHNpfZa8qifwrf9Y0xDVSDoXjNfQxBWL6d2OT0I
         2ZOw==
X-Gm-Message-State: AOAM531VfHUrMqBF9rGGqAOxQBczC9efVJ/BCc7KlRfTiHTu3i+5F3hS
        LmuKMr6A2LYfHvhCeuD39L+dko4KDDLfmVDK
X-Google-Smtp-Source: ABdhPJyWP/pq2VRRWTNTBvFOR8PUQlGsE50BYI7FqpOEpuRzVsWeJ9djlzLBUH/ToKCEpoJly9BASA==
X-Received: by 2002:a17:902:edd1:b0:158:8318:b51e with SMTP id q17-20020a170902edd100b001588318b51emr16819551plk.89.1650388873380;
        Tue, 19 Apr 2022 10:21:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c25-20020a62e819000000b0050a442a510bsm15436818pfi.31.2022.04.19.10.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 10:21:13 -0700 (PDT)
Message-ID: <625eef89.1c69fb81.8744a.2ae5@mx.google.com>
Date:   Tue, 19 Apr 2022 10:21:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.310-218-g718de3a161dbf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 63 runs,
 1 regressions (v4.9.310-218-g718de3a161dbf)
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

stable-rc/queue/4.9 baseline: 63 runs, 1 regressions (v4.9.310-218-g718de3a=
161dbf)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.310-218-g718de3a161dbf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.310-218-g718de3a161dbf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      718de3a161dbf90231d1b0a6ac8d77cceabcc03d =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec667ca227eaa62ae0688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
18-g718de3a161dbf/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
18-g718de3a161dbf/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ec667ca227eaa62ae0=
689
        failing since 13 days (last pass: v4.9.306-19-g53cdf8047e71, first =
fail: v4.9.307-10-g6fa56dc70baa) =

 =20
