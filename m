Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FB93582A4
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 14:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhDHMCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 08:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhDHMCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 08:02:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEF1C061760
        for <stable@vger.kernel.org>; Thu,  8 Apr 2021 05:01:49 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so1235551pjv.1
        for <stable@vger.kernel.org>; Thu, 08 Apr 2021 05:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LKSdzpib2CnMp1WYw3nhlxLATkQgi4wNFrM/Xf3C5Fs=;
        b=0kDy36vHwnGgFprpYa4r7PHdL3a6Meyf60h8NULhzMUyU+7nRtGsHOi3/6yi3TQ4A0
         J70jKkT8ocD1Jg+VbVFMTqrVC7g2TYuLwdLdysGE/xbd3P6wmzaZ7lWWGnw+anvxO3aj
         WUdgRNzlvOFVYMWJczOQ3jJCR7ZdfJhwtLuLMSKWOneK82CiPUoKTUGCQEWXuW6anjcV
         aKHVg2edD3GKU21RhHV1scBjD4WvHqDObPYrU0fmUD37r1hsRrSc4MGaPuZrhHauuPpL
         KrURtGCgp7/nCmXDzVZHHmW/I/s3bsymmyc3WTJK3QZ4uQPxaQlg4YSliVhAKcX7wzxl
         pxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LKSdzpib2CnMp1WYw3nhlxLATkQgi4wNFrM/Xf3C5Fs=;
        b=HEddpkkpWY2OJaDyUC9bY6AJ39NMc7qGgxAiNhvPvgg1auU+67lrOX6m3WcQ8txzGD
         scc4GCJ2wBdjFw4WhuSHxRnYe4op26/vikIG+pPZCVbLwsEoTiDPOnV600PxJfANBGmx
         vtlB4ibUUjw/NNvFn0qM/1Ju62LhxD7vCE2f+RBV1XN7qw6cwh5catYg5jOZ6wkB+uGi
         WetoH9hqaqjsKNItvTLDWd4IwvJZeN/kqZjeFmafOEwkpR8V3rqB7o2LAHs9M7jS5NF+
         UU2cdH6ghz4qcotcoHVoJ9etc3CUxJ0P0Pe7L8SeW9p5fIVhcMwTP88JQlWgeEn1BPgY
         EavA==
X-Gm-Message-State: AOAM531g0tsho4AQ27LvW0CKYR+5WkcDrAv7gqC3qdzj/oOKm+o9XEk9
        QVLEFC9RXZVM9fr+NZdOxVefm09MqBSzDZNH
X-Google-Smtp-Source: ABdhPJwitLJ5EunEn+BF9JjDrHqWdBludkH8WLeLdfLTSYJlV19ObDWVOzEDFTvV8QjUOTX6b5eOFQ==
X-Received: by 2002:a17:903:4106:b029:e9:244f:9aca with SMTP id r6-20020a1709034106b02900e9244f9acamr7603782pld.58.1617883308496;
        Thu, 08 Apr 2021 05:01:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kk6sm8527749pjb.51.2021.04.08.05.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 05:01:48 -0700 (PDT)
Message-ID: <606ef0ac.1c69fb81.9bd5e.5acc@mx.google.com>
Date:   Thu, 08 Apr 2021 05:01:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.28
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 156 runs, 1 regressions (v5.10.28)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 156 runs, 1 regressions (v5.10.28)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.28/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.28
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ecdfb9d70fb8c4d7dd9a5fa28c675b4ebe705f85 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/606ebb80374a2bfecbdac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.28/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.28/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606ebb80374a2bfecbdac=
6b3
        new failure (last pass: v5.10.27) =

 =20
