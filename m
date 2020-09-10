Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA552639D9
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 04:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbgIJCHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 22:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730423AbgIJCDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 22:03:51 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CFBC0617A2
        for <stable@vger.kernel.org>; Wed,  9 Sep 2020 19:03:49 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 67so3370873pgd.12
        for <stable@vger.kernel.org>; Wed, 09 Sep 2020 19:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/yPI8VL7bGbbnk36rkQ5JhczpBqwBfUQEjN7SSFGabI=;
        b=tVTMCQTj6+Z47dSpFubfbEmUNrZ7E6t5mzzbxzdX0eq42KhwPaShGzgs/o3Z7uFYJI
         zGFWVD9udNAVVT1DEbipFqkuehpFsNJQTbyiLq8VHgmZA0BB7djvqFj67cHIu6Z4WdgV
         g/JojPg2rpOyXp2p+vmeTA55SsS7J8Tuf6lRwfSVWz36PeBLGf0xWAcdwaYcCSDJhxzH
         hFYPhoFSAALAArtq5US9uqqqoO+/+Qh8oSdxf82VbHOfryLtr58sGG2flGM4/i93Apty
         nIAQh3Q2Szda3SIS84N3A9ksq0uqIaH0ZVYeawVx7B024mdYM5TtY2CCOgiKHZxvTdBo
         uByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/yPI8VL7bGbbnk36rkQ5JhczpBqwBfUQEjN7SSFGabI=;
        b=oIS1wrfLwPLTofBg3jJYrnoCvFGfLU+JCwTmlTgAcqvTYYnMtwJDZvQHEWksKGWRCd
         71X9qxt9k10TJt+j4rllPzC0W542IXl5ckG5OJUJtN0kFrSDKdpLC5tikur6V7kIHvzS
         TXzF4IEjVbD8ef1eKJiiNlV9k2buFq4+qCB0gp072vYKBoZo6R0uCfnHjYnvo0VCXJsQ
         CEhHdKVkkDX7TXYWAIOsA7cJw7yQc26C082tGeEqZQ3SVVzOQvfdbsAT/zdk3hUI7lKs
         DoXeAuMeOBezow19iM+r+Fu4hCGHof5Q4mon4UssKB4+tW79uH0JvLpEeXyNKWy4wZBw
         mk1Q==
X-Gm-Message-State: AOAM533MOklBcFdCGlqRl1Hrd+cWMMKf68lzhpNH/xrLBJj9CPCJuZDP
        qDn7mRsZLeafZiwwv8AHKtWeRpctFY/6BA==
X-Google-Smtp-Source: ABdhPJwyYAFQlqObmUBUvYMu1nHpGrSXnXyquD7xFPYPyn74+E4X+FmRJiUz4dacsifo2HfsEE7xlg==
X-Received: by 2002:aa7:8ec7:0:b029:13e:d13d:a137 with SMTP id b7-20020aa78ec70000b029013ed13da137mr3187648pfr.31.1599703426803;
        Wed, 09 Sep 2020 19:03:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m7sm3861105pfm.31.2020.09.09.19.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 19:03:46 -0700 (PDT)
Message-ID: <5f598982.1c69fb81.70608.bd1b@mx.google.com>
Date:   Wed, 09 Sep 2020 19:03:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.197
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 147 runs, 1 regressions (v4.14.197)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 147 runs, 1 regressions (v4.14.197)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.197/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.197
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      458a534cac0c808fce164cc961f8384ffc8c455e =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f595502e0bde478ced35395

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
97/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
97/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f595502e0bde478ced35=
396
      failing since 162 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
