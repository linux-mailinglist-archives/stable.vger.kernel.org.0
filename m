Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37C0370338
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 23:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhD3VuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 17:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhD3VuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 17:50:13 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1F0C06174A
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 14:49:25 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so2463894pjh.1
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 14:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LJScIrxuiIK+AbtR0SYpWaJlo/AB1xn4BZxbc19JTzc=;
        b=v4FU6XtAF0HDHtH+5zBqr34HCMldvplQpa/JvqXuSePXnhXoqIOH2AnJ7EqARcqByo
         0quEDicrvazjfaWqkyCH5ogQS6Dk5i8tFd8EeQSde8ZddTPxWXi9mH+h1nURbFVml5eh
         BQb9/0Vn3WkbapGH4iN+ijmnF9ca6zit+KGVYcf1FTK1xOa2g9/duoRTYC54faSZZYRt
         WU469TP9v9s3JKxGIecZ2mwQ1i2UOVVuqnQejjkcHf8oVm8GMdQdw7SdyN8rhei3VpmX
         msfMW/0qvqWNWohXiHPmuErmKH+7AOo/OqmxVLx6fTRgX9g9v8SG030E7YWonv4w62CP
         S0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LJScIrxuiIK+AbtR0SYpWaJlo/AB1xn4BZxbc19JTzc=;
        b=QB98ZSEirWgMc3h9F2g7Ue4topy1TPhPBKpTI3uClsy1OH6wTbiAorJq7Oz4ka5/Gl
         3Lt0LT7LeTIF8wJvG7HLDLouy69dsPWUFYy98+pRh9qlL8eyBzRigrumNICYnv0UltjM
         uwbrxJjD2kUp1S8T4fuynRuhq7ncGwNO9KejY1Ci7NbT9kNXxMIehpFqGGV11HbYDVN8
         LmamDnVbPrX3fqr1xC0/tvBnk6v6YQQqD9thdn8ITKtk75z/fGo/ZjE96CHHx+HVK1hR
         yxRDuUonwEGJLcGOyg8057iWVNyr63Gm2P4AGZBuPsGNYIpvPl50ICbkZpeGyBu7IHok
         ZbWw==
X-Gm-Message-State: AOAM532FFZyQ4gTzHftdBP9KuXuzmro2RJ9/mFCtcWPRBr9d57/ZzsaJ
        tZtdNECiLcE5yxXYwyGxIw5jrb70ThO3gS18
X-Google-Smtp-Source: ABdhPJxWhUJpzKxNef+9zuZ61US3rYsGfvG4P/xJzooHR1/5/F6zpMSnjoRf2atjXqvGeyghip0eKg==
X-Received: by 2002:a17:902:7205:b029:ed:6fc0:bbd4 with SMTP id ba5-20020a1709027205b02900ed6fc0bbd4mr7707466plb.4.1619819364773;
        Fri, 30 Apr 2021 14:49:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mr3sm11442220pjb.20.2021.04.30.14.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 14:49:24 -0700 (PDT)
Message-ID: <608c7b64.1c69fb81.a060b.0a26@mx.google.com>
Date:   Fri, 30 Apr 2021 14:49:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.33-2-g5543059a29e2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 159 runs,
 1 regressions (v5.10.33-2-g5543059a29e2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 159 runs, 1 regressions (v5.10.33-2-g5543059=
a29e2)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.33-2-g5543059a29e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.33-2-g5543059a29e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5543059a29e29c34b081a8a2656f573036e9d9d6 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/608c472ac2cbe7aed19b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.33-=
2-g5543059a29e2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.33-=
2-g5543059a29e2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608c472ac2cbe7aed19b7=
796
        new failure (last pass: v5.10.33-1-gab3a0ce18e9e0) =

 =20
