Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C432964E4
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 20:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369774AbgJVSw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 14:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369772AbgJVSw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 14:52:57 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5877BC0613CE
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 11:52:57 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r10so1472384pgb.10
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 11:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RGuJAwveMM80beIaEvIesw37dJc2cYgzhoOLYdKWqFo=;
        b=an4BXy4rR4SCHTuQ81s/dQ9oZiG9ImV/Z+C7fZyxUKGKPZChBWu78iFGLQEr1JrKwK
         T5mVyPy4nbuJFYAoHMzFT6n+I4eaNYmQ/LGZhFVaVS05KgNsgD2/ER/2HDHvBQbp9rLe
         v/CJDuzCSpaqP19qXOP9oP8qoVYAGMhbgMK72JlrWaRGg2AUpnfK2zagOydJrN/zWx1Z
         ATvIeI2qCPuKQHhvsgRFCJ+oSIWFHWtyHmekUftZH9pKebsRQCF3h1rVxO47sSTqjOH2
         g9IWc0F2St8rJwdwMpjhq5gRBcROqXO+JdSJpHY10B4BjbKHKIqW47WoaIvGOWhx8nLm
         wvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RGuJAwveMM80beIaEvIesw37dJc2cYgzhoOLYdKWqFo=;
        b=EEqDtX5eXRrGvQlAwuQIpZyKZU0A6IovZONPOU4BYC9pn+A1+t4jKrR3NVv1QRS2YV
         KzVK+8Bw1UB52ecWrEVp0SyqK9DfGocw5IbzrloMSweMQjDzfIzcJlOqCpf8N8We9yCS
         9JZmhfv+c9YEyQbE3yU7W3/wHLO++f1vt6htxG0y5DtcN8Zp0HoPrMJJU+TqZ20+fGil
         9PVK02RHndjCqFFvX+W1NVce/AKS7v/0PQKl0FyRVLWEUy17I+B898M+dqRo1T/Ib5p1
         JGfC+0H0GfeJUaluAXMO0rRO44zkggvTe6h89Zflkbo+ftQ050UZH8G9Fg1mirQrLTNE
         aYxA==
X-Gm-Message-State: AOAM533elf995ZOm8xdb7CfqG+9C4/uuHLsW0eV8Wtjpu30syRZNHmMB
        qNnLb1rLl5LIWFNGzoa0pBRzv76Yrdjaow==
X-Google-Smtp-Source: ABdhPJzu1uC5LqnUla7e2nyWvTDKFAPWfNh86ttUDRX83C2ggJsSlDj1cfY3t+1WaLwsF2jp+Nz0pw==
X-Received: by 2002:a17:90a:aa18:: with SMTP id k24mr3499121pjq.231.1603392776563;
        Thu, 22 Oct 2020 11:52:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z3sm2874085pga.48.2020.10.22.11.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 11:52:55 -0700 (PDT)
Message-ID: <5f91d507.1c69fb81.3daf2.5b32@mx.google.com>
Date:   Thu, 22 Oct 2020 11:52:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-15-gc47f727e21ba
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 153 runs,
 1 regressions (v4.19.152-15-gc47f727e21ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 153 runs, 1 regressions (v4.19.152-15-gc47f7=
27e21ba)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-15-gc47f727e21ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-15-gc47f727e21ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c47f727e21ba96c0e5e395e6e28d26fc708137bf =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f91a19d6e487bc993110954

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-15-gc47f727e21ba/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-15-gc47f727e21ba/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f91a19d6e487bc9=
93110959
        new failure (last pass: v4.19.152-15-g0ea747efc059)
        2 lines =

 =20
