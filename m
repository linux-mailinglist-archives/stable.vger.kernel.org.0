Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E46129F654
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 21:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgJ2Uk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 16:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgJ2Ukj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 16:40:39 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0E7C0613D4
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 13:40:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p17so1842995pli.13
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 13:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u3f5VqBNcZUy3Hv7HXBCN39rar8AHULI51r5/QXwYf0=;
        b=KY+b9fDWcr7O9DXBQJW+W2tBPTjapS9hRkAUNqp0aUVt2AKzEcAKalal71HWfygRR8
         Cshk5XyR0aAbBsU5YAA+Yr3aPHIMfhIs65luIvq3yNNjfRakNIEmynf52ER1HGJABcGV
         WqzL7BzHYdWyQVKcpIBCvL5Po1+SbKLnT/8ry96Jcg7JM/p9nT8NFfQOnCheKHJ4z1qp
         idMdaaIYDauOmhwwzVLNY5eHgwd1aUVFoEcDSbHGDItoGxignBgHJkpz5O3hqDmxdxkl
         kwBmBItUC49VMOFf6+RWt8w+FzbJvEq1D71tti41rE1p863OfTBwCSVlzXXwKZCsg3ah
         6tUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u3f5VqBNcZUy3Hv7HXBCN39rar8AHULI51r5/QXwYf0=;
        b=rMgWfIvbZlXoNhxIYnUSN+iOlyXygyv2CsSA0OR9wr7vEpaUjXSu0nvkzSdDHEDCjv
         apXs+NppuM+zhLTLtWnAILTWy5CME5f0Zbz9zRAm9dFwr0yaHIEYe8U2n4QJF4PZDyUM
         uXxfXRmzcW/bBRtHcPvJOANQlG36bA5NpQf1LAuMsWyUEttOliBAs/dD0FdImxNYPvJs
         TSMFULu5xd4x8D6MTSpHRV5GjEe+5VQAPoAZUDw2HOv1PjtxiT1Lw8qz3TmfL4mk2FNk
         eb9aDOtnxDIJnquq3BmlT/MI+m8XOnIVI6DMNu2UVbgR3SepfYUwciW7C2PvMY/ymXZV
         w/Lg==
X-Gm-Message-State: AOAM531K07W9V/Z8UWMlJ2QdNHLT5EhTIFpr5PaFYXokI6AW/c8j16XH
        V0V+FD7FEDjqAfSNnt/oY6ihQaJN4/yxeQ==
X-Google-Smtp-Source: ABdhPJwhRbVnpXCKOjq7JJ/i0WEFFWUEifQGzBbNqCYodZZTXttJN28TPjfbwGOBHUuYrvWy0C7RUw==
X-Received: by 2002:a17:902:7c88:b029:d5:cdbc:ce6d with SMTP id y8-20020a1709027c88b02900d5cdbcce6dmr5699956pll.22.1604004039015;
        Thu, 29 Oct 2020 13:40:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 205sm3787309pfy.35.2020.10.29.13.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 13:40:38 -0700 (PDT)
Message-ID: <5f9b28c6.1c69fb81.96d08.91be@mx.google.com>
Date:   Thu, 29 Oct 2020 13:40:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-2-g5cefd4de246a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 145 runs,
 2 regressions (v4.9.241-2-g5cefd4de246a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 145 runs, 2 regressions (v4.9.241-2-g5cefd4de=
246a)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =

qemu_i386-uefi        | i386 | lab-broonie  | gcc-8    | i386_defconfig  | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-2-g5cefd4de246a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-2-g5cefd4de246a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5cefd4de246a7a8d12c2ab8c6d4d02418e3461f4 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9af5c9220aed0f22381049

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-2=
-g5cefd4de246a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-2=
-g5cefd4de246a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9af5c9220aed0f22381=
04a
        failing since 0 day (last pass: v4.9.240-139-gd719c4ad8056, first f=
ail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
qemu_i386-uefi        | i386 | lab-broonie  | gcc-8    | i386_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9af4d73baea8d869381032

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-2=
-g5cefd4de246a/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-2=
-g5cefd4de246a/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9af4d73baea8d869381=
033
        new failure (last pass: v4.9.240-139-gf340d121834f) =

 =20
