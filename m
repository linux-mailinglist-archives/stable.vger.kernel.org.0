Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6EB47FC49
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 12:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhL0LnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 06:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbhL0LnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 06:43:17 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2ADC06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 03:43:17 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id mj19so13218727pjb.3
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 03:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZKyuiGHZSxNQKhGojbNOJj8kirutd+NTpE01b0LsP9A=;
        b=yNvrTuSUHNY0Clj7bIFPRbWd61X5AM2CiLEQfcsRdIGIfYTeHMMCDjrhQsGRh+kEzF
         mnEut7yM+Uwfcke99DmBEQ5leghTRh0JTXqXfUiGw1b3Vo2hneIw2LavNjgYJSZHLhhv
         ph8Jr5LDiPzVbJgxcLMTysmsBYerZRvZjpdVzrHqNH0MdrHK5FqiR/b0Hg87OZhHvT+h
         U2/qT4gHQL4lM9f8Af5+qUQO9UzONpvSY/glHLRYC5x9nRuDixs/7E/VE95VcssEPUKU
         mC1dtDpIVg8zZQiqSz7qUlLw0W14LIa0so2gjEzOQiT2prweGh4QeiC9pqBR6auJE7Tw
         XqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZKyuiGHZSxNQKhGojbNOJj8kirutd+NTpE01b0LsP9A=;
        b=ZLLlC9AN/XxF6mh6nibO1KrOwQk5t43d37UOWT9k9lPrPML6OFw2el0tq0rMxjLVG2
         6yRf6EB640ztSO5eVFAACbnQyen2goHfwWMBegNFs40F4z1l3xNVsrKBDPZfhjZiC6Zu
         2pyfqEYXgmWwj+9tzSuRqWbsmrKrGwT+yqARtoCiKVu4hZv335+9KeIDz4J302ffqd6s
         3TUwM1P4+DIGdmnZwEy+4M5bqDZKKcDGMmnxZL5Uzh/54aR/D837MuG/K4+U+NMcmjm+
         PPHLmNCpPTcqHaOhe6v2ajxV8OPU/1PXU2iD3TpVVUHbYkg5hVlwdCf8mOErlNogLItK
         cOZw==
X-Gm-Message-State: AOAM532AVloRgc2ZyLlKvfOoAFvWQAix27fED9nFgw/QQm/Gc6QEm0pQ
        7Tds6+u4h/F7t4UdK7Fm397y6VODZiF3Lkd8
X-Google-Smtp-Source: ABdhPJw/oWUT9bo+ALL9bS0ssv08o1Cc/iypQpxxKGCQNo/SwHCN3bWWDuWXhNSruxtQnzcRr63ZrA==
X-Received: by 2002:a17:90a:e514:: with SMTP id t20mr20423202pjy.5.1640605397086;
        Mon, 27 Dec 2021 03:43:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k6sm17962877pff.17.2021.12.27.03.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 03:43:16 -0800 (PST)
Message-ID: <61c9a6d4.1c69fb81.a959.1a55@mx.google.com>
Date:   Mon, 27 Dec 2021 03:43:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.88-33-g45d03cb9da5c
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 149 runs,
 1 regressions (v5.10.88-33-g45d03cb9da5c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 149 runs, 1 regressions (v5.10.88-33-g45d03c=
b9da5c)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.88-33-g45d03cb9da5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.88-33-g45d03cb9da5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45d03cb9da5c51ef945b276dcca08773ca766822 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61c97164db8b7e5da7397124

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.88-=
33-g45d03cb9da5c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.88-=
33-g45d03cb9da5c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c97164db8b7e5da7397=
125
        new failure (last pass: v5.10.88-27-g01a20d2f2f31) =

 =20
