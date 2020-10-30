Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8052A0A9C
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgJ3QBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgJ3QBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 12:01:15 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA120C0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:01:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id 1so3171345ple.2
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zyWIDyshEK8DeuCu7LaaIxDbSMh2iXgQGLBiHEJBINc=;
        b=D3lcbAVqO5cP+OJ/mBT0V8aZTFCpAppGrxxrUkceavd+FLK4kf30XG1uBFL5q1km4M
         FJT5f+BAX9cMOVX1zoBxg15GiOQZamVRS78m2GSp6S0te2w81Lwp5vhcPdcLuddQwcew
         Bjy+MbLfwweLOSDq+KzDDtxArbJmattT5MW7RbXauk75d4yyIh9h84k9sEyCvrkVWijR
         8uNjuXj5M3TyHgzDXVGm4w2Aq+EeY1KmzIbPBeWJcDQbI+sLsh4MXnFCBia0cej6CSaW
         Ph6pm7aBothmZ6YjgfgpefbAphDwgJc63PU7JSdFCbITEeE7rkWDB5doGN4B99RJFuwI
         LqWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zyWIDyshEK8DeuCu7LaaIxDbSMh2iXgQGLBiHEJBINc=;
        b=gUbUHKcxEhsxukR93HeifJFkH8l4bixwxPAsilmF3SSR4P8bHua8todf/4nALqJkOY
         gnTIJHHdJV4v0b9bdNZ295o1dx2NKt9J9qOpSHXJvf7xi9y00CMk0QGjWUz86masNR+z
         hZWQ82h6TzWC/w3MdR8W2dCQETo7cGE4lX9ppTnRUJsw8eLGc0nXol0FybRGqgIp5ifq
         Zq82gwgow/MDGNr04p6ZBWdUUYLuBgIzDTKxmmo7r9UNEjgycVdLtEZIjUxIOdwrxdNM
         HTwjvQC1kRq6Ktti0QYAhT0VVXz8wrBL+ccHRTfEA4CWiCRNx83wAzLE8jOVdeYpRtrZ
         FjHQ==
X-Gm-Message-State: AOAM530U2Y6hX+dymsDuCi5H9jduYcarMci6kho7PNePuPs3DDj7a+ci
        nemKC7QHmwa++vawyEff35IlO23EqXQjbA==
X-Google-Smtp-Source: ABdhPJzCFDZrOlMVefk5AtI3orkPim5n+vOsF22siy5Mov+FyQImvp1Mu5O2Gcjg80S1I9wg3ItqWw==
X-Received: by 2002:a17:902:778d:b029:d6:489c:67ee with SMTP id o13-20020a170902778db02900d6489c67eemr9640557pll.52.1604073672981;
        Fri, 30 Oct 2020 09:01:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t15sm6367715pfq.201.2020.10.30.09.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 09:01:12 -0700 (PDT)
Message-ID: <5f9c38c8.1c69fb81.4256b.f4ee@mx.google.com>
Date:   Fri, 30 Oct 2020 09:01:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-4-g8d9cc85ab09b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 139 runs,
 1 regressions (v4.9.241-4-g8d9cc85ab09b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 139 runs, 1 regressions (v4.9.241-4-g8d9cc85a=
b09b)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-4-g8d9cc85ab09b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-4-g8d9cc85ab09b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d9cc85ab09bb9655da3317cef0e26a6522fb7de =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9c06a25140bbd831381046

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-g8d9cc85ab09b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-g8d9cc85ab09b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9c06a25140bbd831381=
047
        failing since 1 day (last pass: v4.9.240-139-gd719c4ad8056, first f=
ail: v4.9.240-139-g65bd9a74252c) =

 =20
