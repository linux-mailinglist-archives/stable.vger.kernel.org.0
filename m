Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E808B426228
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 03:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhJHBvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 21:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhJHBvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 21:51:46 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60248C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 18:49:52 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h3so1599389pgb.7
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 18:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TASK6w7eIqebyK/GOxnq/ilKZiPRooAtElDmCjywVuA=;
        b=HXROrO1n7TfxfBNRNVcXQ2OsnYjbweSo/qHzCyUbrlwUZTnYBpD7VLQ9e7lUcFkMeY
         kteACSKKFsQ1aknmTqlS2OdoywhxVxlgKcQgfjOdrwGk8y84zkr8vJ3efMgRpJeBv9BE
         /53bOed2CDaX5yT6i4tZc4/sRoI3Qngibbi7LwILf00RVWJu427POEdQ0gvYZam1d1WF
         uH2nvnwjCGqXKXj5anSG5uy4ijF5HerrZLtVH9mAIj2OLndu/agwag2qKDzWv16eHlFC
         dqlwKAqwJLXSBOuR5oW6FPfjqWuZTSL9bjMTs29hgC+JaKjSiJXPTENsI2QG+nbHpZ5E
         yyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TASK6w7eIqebyK/GOxnq/ilKZiPRooAtElDmCjywVuA=;
        b=1WifucGQHmCw5kg9O1cGkXaony03Nkw5qCPCqS2FZB7BZHnOoIdg4b1tYWt+dPZFrE
         o2BChbHaSq0zixTP3GKVpl0hX9pChfACMrnCKcCNt62u31iHxBGk9iQSDlO8dYS9siBG
         8ESV3pifnKjtiXhUHvQT1dRgC0Fgs76c38GceJsPrxz7EG6thXwr0UE+YXAOum8U0gyG
         AWI6V5f+IB4JRXB9lGUyh/G3cMjSkIG0Y8G9YNU7pHtHryBnQretjw1LseP7fh+X3FAL
         BjI/vKTw/lDvKQjOPgxwh00QODW1t3EGPtKdffD9ZPQytBPOnmAnw2NMn7m2OYVUrzBy
         W2nA==
X-Gm-Message-State: AOAM531+tif7ODjyheWBz060aGij7iVr8h43R3wtyRpX8ZLgcSdh3Ob0
        8eVXACB/u0SK5B/WVsiU8UAAoGgRnampBP7p
X-Google-Smtp-Source: ABdhPJxHVlL4eWWGHSGTZN11Fq5lAQDhEZ0YQbUkViMzsMROjmn+WM3OW5THciFhR6zQUT0PEf6Szg==
X-Received: by 2002:a62:3802:0:b0:44c:776b:f555 with SMTP id f2-20020a623802000000b0044c776bf555mr7547343pfa.82.1633657791508;
        Thu, 07 Oct 2021 18:49:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w8sm625256pfd.4.2021.10.07.18.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 18:49:51 -0700 (PDT)
Message-ID: <615fa3bf.1c69fb81.441da.2dea@mx.google.com>
Date:   Thu, 07 Oct 2021 18:49:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.285-9-g226ada71ac1e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 66 runs,
 2 regressions (v4.9.285-9-g226ada71ac1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 66 runs, 2 regressions (v4.9.285-9-g226ada71a=
c1e)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.285-9-g226ada71ac1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.285-9-g226ada71ac1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      226ada71ac1ebe9b6d5191a6f9e7a3aa82a97c9e =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f692ff3cf7202f899a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-9=
-g226ada71ac1e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-9=
-g226ada71ac1e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f692ff3cf7202f899a=
2e1
        failing since 327 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f692af3cf7202f899a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-9=
-g226ada71ac1e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-9=
-g226ada71ac1e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f692af3cf7202f899a=
2db
        failing since 327 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
