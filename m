Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4254A915E
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 01:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbiBDACv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 19:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiBDACu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 19:02:50 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0948C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 16:02:50 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id v3so3652785pgc.1
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 16:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SrssV0NoUBQ/nojnyHZtHBGHUSluP2j0g0Tr80DCdMQ=;
        b=GBYfDUt48RDRlNgYIJlxk5Qz+G1q3nZcURY5dJpCa7UsPBiiwXGWub5PaM7/8GIUWu
         MtCXen14iFIgc9qA20N5PLKBOJ/8Uo8cRo39NFPZr5ugqD/+zZdJ/1o8esEXt4tnn8Bd
         zotAgPYZ10lpo+Uuq/FYkkEhgP24qnZsTFBTBPxEROaXZlvodi1C7jGOfbPyVZ3MtAGj
         QZ+WdQHG39wR8K2e/zA3bwqSvQOgl72FmCsC6wCOJ2xalXheN+Svp0qtCwQQE4/8ZHdR
         z8T6ZrXrPI3U1mG3NSBYyjizfsR/GgW/hs4cI3tVwbdvIzwT0PMoAqkLko9VzFvXnL6d
         vZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SrssV0NoUBQ/nojnyHZtHBGHUSluP2j0g0Tr80DCdMQ=;
        b=DkcDRpeVv/Bzv3NI8MqcAPmZLDY7+CObikksxWXPjkBrK0tKYJY1UtJe+xdw3Ld3z3
         5W6eJJLu/h3HT//jDy05MTkv2Mqx7OSqiOHlmYQ2rdZrilDc/70H8BQsmbi071vpfLla
         xuHnBMkqM8j8A4YV4dPij4NxjzmlyEb7sQjUKC1SnkCdQ6oi5AtCrtxxYwpmmJrakeC/
         0k2Ld00l+bzZslnMED/AnnN9FDq/YDaUQ09ccBYryhGXWdRScT1K2SHJLSb2y+T9hUrg
         2D8rjlohY+OCys77i58vHbp9H4KNsNyML25qGdXekLjDQ9cOsDcjIUrUhR7jw3YdF9rx
         FCjw==
X-Gm-Message-State: AOAM5313Pyha1rAyMFO7j+ouJKZSm7yvtGTRD2eVSPoT2l7NwyIlOpEn
        Dc7BX4BaonkbkE6hLhYlHjQlRsxG/7Pf04iC
X-Google-Smtp-Source: ABdhPJxAN9Do7srsrIITFive4xR8ea6CdWY/IkmckHONVELfeiLvrixihqklVqNo444F82fQayfpfg==
X-Received: by 2002:a05:6a00:2386:: with SMTP id f6mr483015pfc.37.1643932969988;
        Thu, 03 Feb 2022 16:02:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12sm134788pgp.25.2022.02.03.16.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 16:02:49 -0800 (PST)
Message-ID: <61fc6d29.1c69fb81.5264b.09d3@mx.google.com>
Date:   Thu, 03 Feb 2022 16:02:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.19-5-g71c43a5f536b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 122 runs,
 1 regressions (v5.15.19-5-g71c43a5f536b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 122 runs, 1 regressions (v5.15.19-5-g71c43a5=
f536b)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.19-5-g71c43a5f536b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.19-5-g71c43a5f536b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71c43a5f536b432e25fd2576234dfbb0d5cb2a46 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61fc394f22f5fb4fc75d6ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.19-=
5-g71c43a5f536b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.19-=
5-g71c43a5f536b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fc394f22f5fb4fc75d6=
ee9
        new failure (last pass: v5.15.18-171-gdc96588f50a2) =

 =20
