Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E975D430B5F
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343973AbhJQSKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 14:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhJQSKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 14:10:34 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656FFC06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 11:08:24 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e65so11283134pgc.5
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 11:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dXrPxnPIzMVr9sRI2WNYJnI4iTNBNlh/0HZqq40M8+E=;
        b=scqfhbDSGZ1BkZ+UmSxKaq9BhyYtJySWBsej46iaB3bbcXpTPVMIDsmaquVC2gj50K
         aTi5fGyJ/1wRbnqMrwj6ThbaTMOgActzfsNS7r2r8x/Ow1zXwwBdQ7GRbAwO/AomjNni
         6HKtULrNr3n2NQAa4pgaX+axl4koSKeb+/EPXa175V8pmSMfBpjipAGpoCTE7ZQmxvH2
         ibgj/vQvqS+bk6OAMu66B6Q95MDLtV+D6Da0djcJ4C4vHhG3ej7c7Tb9MtvTMg5xysM5
         bjodw3kCCspaQbJXkMQQiZXhyZqoWnk8OxdGnF9vWBTyM/uk+WNnAs7yIL/eyJsFIbrM
         tDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dXrPxnPIzMVr9sRI2WNYJnI4iTNBNlh/0HZqq40M8+E=;
        b=6i5KrRYMWNGNaOQZp/NcnuwOeNZhiiDNU98/XG/6BdvCZkDX/B2aEBS/QyeAfgX1Wa
         xtz2KxSLi0Leij282ePI1nsSH187VlH+ca0onbKAH55yCS51E3R5jvYJKw+/Q3ZQRkL8
         Z+BoL7gJKRY6/OQdCdExX4dnQbK08ij124PUr+/iaWYrncRnf3hiAw3VI6UqpMLb4jwx
         yxeQU4rHH6MZ1f8301CBI/T365AiY/xJWq+PiHhetG7WEkvBNu08qX/OdY0ZJIjis2Rw
         viaeKkJiO+HzjSfENaagKjmqk/MHaZ/QsxDsGE3Tmtc6Ot/wcLE2qQo9Iss8wbccG3e0
         IIMA==
X-Gm-Message-State: AOAM533qNc9+NqM2dJX2k5y4cUrcR25gdFbWBkEcqyN0wIsegCjBsjbp
        Vzq7R0qS/MAEJN/PYKJ3UF9ihNc2yXnrp9So
X-Google-Smtp-Source: ABdhPJy1Y0cNblUuugETxDHLUAFTxkIP56wf2122UlLafF5FdqRu5tOyla9Do6iNqRzN4/MSv+kdpg==
X-Received: by 2002:a63:d30e:: with SMTP id b14mr19169121pgg.454.1634494103801;
        Sun, 17 Oct 2021 11:08:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2sm17240652pjg.48.2021.10.17.11.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 11:08:23 -0700 (PDT)
Message-ID: <616c6697.1c69fb81.646de.1183@mx.google.com>
Date:   Sun, 17 Oct 2021 11:08:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.154
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 99 runs, 1 regressions (v5.4.154)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 99 runs, 1 regressions (v5.4.154)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.154/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.154
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ce061ef43f1dede7ee2bd907d2bf38402831e30d =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/616c29ab8962b385853358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.154/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.154/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c29ab8962b38585335=
8e9
        failing since 65 days (last pass: v5.4.139, first fail: v5.4.140) =

 =20
