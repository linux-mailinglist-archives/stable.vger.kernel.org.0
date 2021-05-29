Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48215394DF7
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 21:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhE2T5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 15:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhE2T5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 15:57:31 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62479C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 12:55:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k5so4413703pjj.1
        for <stable@vger.kernel.org>; Sat, 29 May 2021 12:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=teT1WXaePGyR+UjBDpj0I0VeNjyF0U/q8Tb+c6xyK0w=;
        b=lm27ezoGvkpVYyc+lGsLmMxZkkl+TpK2QG1kcwyMyAAuRuHhU6Q46mmYo6TX/MUbwk
         OeS/WHphXyPc7KLaXfaKa5R5xZcrz7E5I8yNHjL5g2njQNOfkBqHk37Fw4xjIhi0RKjm
         +y1bdy0If2A2VR+NRe8/rlnhTadeS29y3LTMQN7hHJ13R+mRU0DOo66unt3bl0Pkqwlt
         dhH/dj4AAovEh8NeDhB8XjKRB0i3cZVO/zw7voIt7mcpASnoryqJ107ckKscaFFzzHEU
         GYqkiP9pnrfIrfACb3QrOfWAiJK2zTd1BJmLL4JJusXxRId9Bh4/T6aqRceFrKzkipFl
         cahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=teT1WXaePGyR+UjBDpj0I0VeNjyF0U/q8Tb+c6xyK0w=;
        b=hrroPkQR3BOGdYSXbwaggovCjvKKALDskz2iZLuw5aolcAGFFd9kHHuSxTl7jUiX5L
         32B5+/VgQ35NtYGP5D5fgTsS8G5TmhnMeFfVdWWyxdZTvupe0GYBCCPiNZ3TmUhc1QQp
         cM37f1nhRq4KkNVgRMbebkHbbMUdnJ7mnLLwS/0W7fxXtBjHbiwtk46ycwhHaX4sjoao
         lDG0i9f8yaZYA4775z7bPufTu+W4beCXenFlzxCSxzaGYmBSMlb19gF46G3T81yTkTgl
         EYFQB/SMH9rqTHJJO+Y04f5wPEsvzDBWjvNuDjWWcu3D4OEAk83zYl+NgkayW9iMGB8M
         bahQ==
X-Gm-Message-State: AOAM533OhwIn8Y2rIsvYt5pOVVCJWpj+3qc48v1rOd4UWGV8cObHMQ44
        gsFGVlf/HWSefoxsWBdwPDzxhg/ibw/V3Qc6
X-Google-Smtp-Source: ABdhPJyroHSaSP9HBOW319g6/LtYUJ+YY9nFkvMHxGiv0VPPH93njV5fjOvgyIKcrQoC1xpvextdhw==
X-Received: by 2002:a17:90a:fe84:: with SMTP id co4mr10895106pjb.0.1622318151040;
        Sat, 29 May 2021 12:55:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g141sm7168472pfb.210.2021.05.29.12.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 12:55:50 -0700 (PDT)
Message-ID: <60b29c46.1c69fb81.38a45.7726@mx.google.com>
Date:   Sat, 29 May 2021 12:55:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-31-gdd60917b7d06
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 184 runs,
 1 regressions (v5.12.7-31-gdd60917b7d06)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 184 runs, 1 regressions (v5.12.7-31-gdd60917=
b7d06)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.7-31-gdd60917b7d06/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.7-31-gdd60917b7d06
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd60917b7d060fd8064c02dcd71596783ed98e75 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b26642b770d2ebd3b3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-3=
1-gdd60917b7d06/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-3=
1-gdd60917b7d06/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b26642b770d2ebd3b3a=
fad
        failing since 3 days (last pass: v5.12.6-124-ga642885de2c1, first f=
ail: v5.12.6-127-g3e985cc005fd) =

 =20
