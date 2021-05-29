Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFE8394B21
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 10:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhE2IxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 04:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2IxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 04:53:12 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A31C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 01:51:37 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f22so5099403pfn.0
        for <stable@vger.kernel.org>; Sat, 29 May 2021 01:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kbBkkW4COsu6W/BtEkX6ZrD3gGqMw8WZ5UvRChKkNYY=;
        b=QUn7CN61C8Y2fChEn9UHo7Rx9G4ngGMsw6+GgQp5EEGIlcHIkK4UenjwL2nUNhHFvC
         Ak6tyH9In+E+Dz54hV3jFbe56fIRaUAX2jERQdsDXwxQ3oDKBiYIBjVTYMyc3jY62g6r
         ClMejtrwBugXjGzlpLdQOt6I/glesZ6vh8w3d7VKpmTZKjkrTHoXKhS5/fLIs4FU0mD6
         KB/CgBOobkDywMpce4EwmBDl03lpOCkemP1V0op0u6AgOxnj19MJm1fczCfmIBRVYh7Z
         +cjXhdiTFOmq16hG/ixNkh6YnrypgjvW2gjSzYYQt0eLw8wVk7TyIte/TkUVhqnLsHGH
         OPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kbBkkW4COsu6W/BtEkX6ZrD3gGqMw8WZ5UvRChKkNYY=;
        b=sGhnxziGO3uWsB9godPN9PWRaK+KnU6AYkXNkj6l94ovLtFFMBOYtToTKqLlFI67c/
         v39hOw0BSw7w5NJbijwt9plKL1TnsY1bjZ4ROqJ0VPZjxvbsj9EtYOqutXRxSweX1Q/r
         7WL5jkd/TxJu8Y0vAvTobhuO3Id6pjJCiOFvEKHpNrSqcCUKbqIJJZWxBq3N6k4ErfnF
         PU4wz5j/+zUu/7Q9eZlb7eyPkhm5cDntGR7/uxFTIxAwleKiCWCJN2xCuiFvEGW5zJln
         oZ1+3Kcr9lXA6h9m2xSGi1A+QQ+m9wtVhUWYDDfaGN3Mq1ugB7uo2couseK+yCZVubei
         945w==
X-Gm-Message-State: AOAM531jW4+UUxkusmBxw0HRSk2a2GzyJWifZS7RMm/R4BVGlwOJzpR8
        4BHd2GkIRe/RZOHM1vM0raVH529icU1NJ4xd
X-Google-Smtp-Source: ABdhPJxRFQefOC3CDsyyRB1iuc2NBd6FWtrdNGJehULnixHgVL/wdwrc/Z5m54DOV69wEk1sOKrZXg==
X-Received: by 2002:a63:231a:: with SMTP id j26mr13152883pgj.77.1622278296405;
        Sat, 29 May 2021 01:51:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s9sm6100410pfm.120.2021.05.29.01.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 01:51:36 -0700 (PDT)
Message-ID: <60b20098.1c69fb81.428c5.4c99@mx.google.com>
Date:   Sat, 29 May 2021 01:51:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.122-11-g827e3688620b
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 187 runs,
 1 regressions (v5.4.122-11-g827e3688620b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 187 runs, 1 regressions (v5.4.122-11-g827e368=
8620b)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.122-11-g827e3688620b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.122-11-g827e3688620b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      827e3688620bad3955f3b84b32e1cef2a0863eb5 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60b1c77612a75d2289b3afee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-1=
1-g827e3688620b/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-1=
1-g827e3688620b/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1c77612a75d2289b3a=
fef
        new failure (last pass: v5.4.122-6-g26e200440e10) =

 =20
