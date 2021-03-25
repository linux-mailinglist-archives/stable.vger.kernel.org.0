Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2555034923A
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhCYMk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhCYMkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 08:40:33 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC508C06174A
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 05:40:30 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l123so1917917pfl.8
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 05:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5llZnmnJy7bIopj5PvuqqlQOh5l/DPzXiVwtlmrQcLA=;
        b=Jr2ncIlM0AuRxrEW+/8xGPOgSH5szcAsdcySRpIAHAdG1XqJSoLpDwvPlLwSn0sc4f
         lCPKdKQxHUOD41ns9DKqpeyU4KyBfdGBprD2x4O7fUq6Cd8eHueyKZg+D+VcD+46WguC
         5OqiJbbISRUdutMjc6vuTFyEYce85cDStFLQCC5wlP7Bp/Bg/ftMJ2Zjfm0NgMned05a
         IjyYLll0PoN8dspyhl6Z5Ag1s4n40WAiWv9Ru194fJ1q03rUuINV4Ge0Ke639NNHtFJ7
         7OIQzu789UbAwW/fTYUFaR/MRE5iAivLIQHvR36Bvz9pH1mz/Cr2SHcgwi6WYojM9TWw
         7H3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5llZnmnJy7bIopj5PvuqqlQOh5l/DPzXiVwtlmrQcLA=;
        b=fJHJn6VmbEw/n3xTbpqemfyLEjJM782qvTLzo4B77RKhzbGarSmPmZtUVtInY3RwEg
         sSiPE4FIvw+ZM5W8vWg/n3wchDiISIswDBUOVNvbP/dI7rd0tBbLM4ZT+zGwEWEeh0ug
         9H3j6yPj+LMequozLhIDtwiUoGs+pSL6nmOTuah6dhQB9ttoS4Tx4CqF43VpCa4QFT98
         Qj1gGYZxkoA0XUadumQhTbTYBIdLpnJOoJZCpqIe50jySkceMSz1bvbFSLfWBoyQjw5y
         DJj7RO28teG07YnMkzMP8HfwbmEyIps5wonu+RvhWAbGRMciZuGw/KSvorDzht3yRASx
         KM3A==
X-Gm-Message-State: AOAM531ZR0YWho0Wugy8h6O0kJGIuTU4ansfw4PyA7QC81aEh8zRyuF+
        nYuILNVn3/WZOdvEdjYR8DRhW3d/NXZMNA==
X-Google-Smtp-Source: ABdhPJwgciZ//XNIhwC7TAbFrwUVNAltr+V8ZEuCIu/e/2QOM2PFdgmUMrxIYXVzw/noSs2QHwLN6Q==
X-Received: by 2002:a62:f244:0:b029:1f8:40aa:8d64 with SMTP id y4-20020a62f2440000b02901f840aa8d64mr7693175pfl.81.1616676029908;
        Thu, 25 Mar 2021 05:40:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t18sm6141031pgg.33.2021.03.25.05.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:40:29 -0700 (PDT)
Message-ID: <605c84bd.1c69fb81.ca48f.ed01@mx.google.com>
Date:   Thu, 25 Mar 2021 05:40:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.107-63-g4f92f3eed711b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 144 runs,
 1 regressions (v5.4.107-63-g4f92f3eed711b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 144 runs, 1 regressions (v5.4.107-63-g4f92f3e=
ed711b)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.107-63-g4f92f3eed711b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.107-63-g4f92f3eed711b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4f92f3eed711be8bb3e7a8456d49ef01498e7ac4 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/605c4f06178e3b9854af02c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
3-g4f92f3eed711b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
3-g4f92f3eed711b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605c4f06178e3b9854af0=
2c4
        failing since 124 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
