Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F60C3240B4
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 16:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhBXPVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 10:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbhBXOcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 09:32:32 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E729C06174A
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 06:20:07 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u11so1259509plg.13
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 06:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zcAbHaEIKbKr5R2ui5jF3XEwY0hUBnusubvSSFeh4AY=;
        b=LWCB+2RihMlld0kcvLC/QyioC2xDmvFjJMgGITPhWFoEcHigpl/jp8jWWdDdGNA0EC
         34lxLO2CCvPg5g8nOluouSVSC+L2oo3IjF/I9SkGcTO3F90yEe0CeuReVXurzfCni0Q9
         R9JqJLAcplWN4qqpynfG+0dXy/IzCA0iZhJf0CeXoo/eRUfNaORHWbYV7SOWNWc5QlQh
         FIhtUuTaFd/8hU2DmxQ/1dSIoTPAuYg6AjRrVwRoe16bniVIaFBfFEiTBAYZNVf9WuDE
         /XGcsW38UN8Do3JQ+BH73QAg6akCwdByac2k3b3kkf3nWEWw9zDqB0o/97qgWDY5VtXX
         jfjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zcAbHaEIKbKr5R2ui5jF3XEwY0hUBnusubvSSFeh4AY=;
        b=DgEPR7OSafKSXgqzsvKXK9R1Se7JsEHWcsdlizxHrLet/2LLrFus4KMZ55xQjMubSY
         QSc/nJ6NfZkfBE0EyJXJGjVgvNQqDNVWt/yZ9E8kXt+qJGColiWafDJRxjC7+SUEsLEs
         412M/YimLpy3LWsBtlEITATo+DzPv7KUmT1ORFUjuvGqHorkMPKyXprgQyaN4e+19jR2
         csQ+R9F20KIaFdlMk2wriWphihwtrEVkK0ZVLfbZnTeVOvV8RXURfUOsnXVrnpoeC9Mh
         rU+QY07po8ELw//P2TvroHdZUuLWJWRyZvW1owaP4XCJAw7npGamonfRsW+NngumZJ7k
         9+tA==
X-Gm-Message-State: AOAM533h7w/juD85uWMGbbbtBXC+rDn2jeIfH6XHprmoPP4HntDOUD2O
        sR23yi++//2O8K7KS5wZQkCR50V1T068lA==
X-Google-Smtp-Source: ABdhPJzYX1mp481WGKbruXrWu3cXSaUWfBcVMNs0nBmwGOgtMR5bViU4KfY1Vm0+tptPjhwTDnuycw==
X-Received: by 2002:a17:90a:778a:: with SMTP id v10mr4657319pjk.229.1614176406496;
        Wed, 24 Feb 2021 06:20:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w200sm3107526pfc.200.2021.02.24.06.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 06:20:06 -0800 (PST)
Message-ID: <60366096.1c69fb81.32572.655e@mx.google.com>
Date:   Wed, 24 Feb 2021 06:20:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.100-4-g0b4ea10e3213b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 106 runs,
 1 regressions (v5.4.100-4-g0b4ea10e3213b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 106 runs, 1 regressions (v5.4.100-4-g0b4ea10e=
3213b)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.100-4-g0b4ea10e3213b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.100-4-g0b4ea10e3213b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b4ea10e3213b5171131907c7987731edca03dcf =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60362c1a50de91890faddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.100-4=
-g0b4ea10e3213b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.100-4=
-g0b4ea10e3213b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60362c1a50de91890fadd=
cb2
        new failure (last pass: v5.4.99-14-g6f0ef837e9bd) =

 =20
