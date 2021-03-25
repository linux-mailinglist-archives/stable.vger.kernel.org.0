Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BE934860B
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 01:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhCYAt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 20:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbhCYAtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 20:49:24 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC7FC06174A
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 17:49:23 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c204so263335pfc.4
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 17:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=67GGODK6Cc7QEg6ZoRXyeoXRUj9UfagrEpWWdj4kM00=;
        b=Rrf8UVM4+rFX5GSD0t5O04yp4dY58vku76zzFSgg6zRfrQs+idaqcqiUmDzXH14xbq
         odcj4mXUr5HjO3UAPs6u1P9Zw/TtLVGEVnQ/fhHfJCyaRSbmzI6njobBm4loUU5vIYox
         rEiKh8ngtHe9QL32d8M0OIAQ1u5h5hyOH5wzozFnv0m6fS/CmxlZNwWD+/cxQSc8A2St
         nHDlPZa6RMUn3tlSNgfD0nBT9hURz7XK0gRK7kcelpGrMV2tV3BJ2YLCX6RpKXJN31p4
         oL7HIwCQrVE0ThCC7+7rQwraM1xU2r4W/0NzwqWQ6rXUEnGJ9HrNbneAUtYUIlbDRZL7
         DTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=67GGODK6Cc7QEg6ZoRXyeoXRUj9UfagrEpWWdj4kM00=;
        b=ujx1YEipy3X5ZY9TsY9evP0TQsOUBjJXEs+sO/dHG0/tdlO62+2W0MQaixXJCcQY0m
         jyzrWpqM2rdKFyZIi6LT+eIR+wWyaota/gExu2USpF/utBsasaTpiAKH3L+518X5/W19
         ugZnysz8bqgncsrJv6SbLLrppB3Q9Tukdsx++JPfj6jhyPPX90KmkLymRjVmYexBuCYW
         ji6YeGkxpYfr3jqN2a3UL4WxmIq6J6OldP3BC5LBgC5/5DF3P8G5A14NOHEXmq25p7wT
         LdWgCEnAF9IPbmgGR0gUgboICFFCQYoaXPeiSsJhz0DExp55g25u6CC3At2T7bdQfOMl
         ou1A==
X-Gm-Message-State: AOAM532FnsRJL9TMzwRe+t8sC6NslDvEnssXYGocT7+DaTZkg2n0H2LB
        8CCQKU7En5Y2KA9akxvUlZB7oaEBKYpVaw==
X-Google-Smtp-Source: ABdhPJwkYpxjZ0IWJiYKPqkSEGabLCfxFzLHrixHvOl6IYeu0dRgTLzJXo2ONEWI0U4d3ZJW0nTegQ==
X-Received: by 2002:a63:6d4e:: with SMTP id i75mr5121379pgc.97.1616633363331;
        Wed, 24 Mar 2021 17:49:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g21sm3708123pfk.30.2021.03.24.17.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 17:49:23 -0700 (PDT)
Message-ID: <605bde13.1c69fb81.2ee5f.a124@mx.google.com>
Date:   Wed, 24 Mar 2021 17:49:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.107-63-ge1af05b0e5aa
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 1 regressions (v5.4.107-63-ge1af05b0e5aa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 162 runs, 1 regressions (v5.4.107-63-ge1af05b=
0e5aa)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.107-63-ge1af05b0e5aa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.107-63-ge1af05b0e5aa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e1af05b0e5aa73b325c7dfb97cf49a9cd3558ac7 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/605ba8e5046c9cf662af02ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
3-ge1af05b0e5aa/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
3-ge1af05b0e5aa/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605ba8e5046c9cf662af0=
2af
        failing since 124 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
