Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760AF3251CF
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 16:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhBYO5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 09:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhBYO5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 09:57:52 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9C4C061574
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 06:57:12 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id e9so984450pjs.2
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 06:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qi7MUCVwtRWmrjfsWF5/1LMREgn3iexM/I5RxMKF0eM=;
        b=dZ+wAQ4TMw/dZla5fE9L8TQOSdXHWhczvSflQQJdV9qLrgGVCUhxXIErlzdDsL1Bq2
         Nl10P/IThgNMfkSmsRVIlrQYBMViLBdheAY79s7M4RUQWYXQRndgfWtZRzcDVxlYvHIH
         MHGUaHFntIwka+7E9kzAZ4VwK+MhMRZBYViQ0IfIzfQAYMTbGtsqtoslO/73EPi/MdCn
         NTGnwt1gE2+QfT6YinsB4kfTfJ1+Qsy7NzrSnrVe0og2A5uU8DA9Hr4OTDHxIIj00CnC
         0WGtnQ8qvH9G49Pv0BDS6IAXxpJOgeepR5K3rOuZyJmtavDjF1r/GDBvrS4N0mXkyzPA
         v6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qi7MUCVwtRWmrjfsWF5/1LMREgn3iexM/I5RxMKF0eM=;
        b=ImF506b7B3lzHT2Lqja6NvEGpy2e9djipeHhA2BogXzbiqnBqyVGj36wprH1Mljs3w
         CaCCWcgCkJDLpE+sWB3fbCm+pIvPpT3JEB3DjJbR0/w6UcVjy0G3WZXONVsu5l+82uSR
         /hiJbiVmE212yiNcNTaCTx8QICtHBGRbK3d53xuxz2RT5tb7CPBpJK35NZ9KD2aC5rHN
         c8rXtvvzwxyohPDwDiQobA2YA+R1f8uomTkdhbx7ko4RppJSdQE/nByTCMyue+S6UyS/
         DsaiYK1C7/DrVtr7vAa2qkh3gJLDGBcY2Jmn5C7MV3G+ErUnCiSQSDEoicmJ/nlG0YQl
         3+tg==
X-Gm-Message-State: AOAM533ngVAsS8t7awJA0qodnNEJMPNXRn7IaLR9F2hmP10FA7l226+q
        vxE/SEswb/7+2B0EDD9Fid/MX13XWttulw==
X-Google-Smtp-Source: ABdhPJxd+VyAYJ22ZbkxW5bOTjGhYgXQMagvSqBddVyruQSmCZBJNJOZE4JL2xgQNJgollAAxkFkag==
X-Received: by 2002:a17:90a:1f86:: with SMTP id x6mr3566229pja.135.1614265031549;
        Thu, 25 Feb 2021 06:57:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm6555992pff.133.2021.02.25.06.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 06:57:11 -0800 (PST)
Message-ID: <6037bac7.1c69fb81.5cf5d.e5da@mx.google.com>
Date:   Thu, 25 Feb 2021 06:57:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-7-g869c5f42a7d3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 43 runs,
 1 regressions (v4.14.222-7-g869c5f42a7d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 43 runs, 1 regressions (v4.14.222-7-g869c5f4=
2a7d3)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-7-g869c5f42a7d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-7-g869c5f42a7d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      869c5f42a7d305e7be5507e04dc3ac31e2e1950d =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60378b7cd5a2644044addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-7-g869c5f42a7d3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-7-g869c5f42a7d3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60378b7cd5a2644044add=
cba
        failing since 78 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
