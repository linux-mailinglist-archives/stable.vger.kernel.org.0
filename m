Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A043E82CA
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbhHJSRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbhHJSRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 14:17:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9298C05937F
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 10:58:49 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so266212pjl.4
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 10:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RLfeoHGyC76QA/MQoAcxRmoYEe3MR1nRQ8E7AzhdK0Y=;
        b=1zme5bF+jDOtmHBo9RAR2ruwb5JMOaoqVKid0PSpKj9v+K2oHMN2eGCLyGWYhf4NH0
         2urbjld0d55e7FVgHnCUGPBNiufGxUtE2walMHu3ReBVYwZVu7CJrPaHUEdLluuma4cy
         8kJQ0qFFcvaUtc/pk2v/kEDbyW5QgD2leTSAraGHyMvlli2+KxMULlhZMgGOycFGiZNA
         2aBG9JUbIUmyECeuDs3xJ+bz/22+KPN3Q9uX3NDA6XIwQJGKSgZljBBw60RAzB8gBwMR
         UNfixIG48OKQ+0w04H9Smi29Btc1jEqucfUyNTIDXcQ/ogqRYcCZ5Cr/49H7ALbTGPOV
         0eYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RLfeoHGyC76QA/MQoAcxRmoYEe3MR1nRQ8E7AzhdK0Y=;
        b=V0KVCMlTsPrE9wQhDFnJi/dujFTbH2kVpIEExiyOfx1DEGowhzi6kBr0nRZFJRFid9
         i/zi1bZfnsdDRGHvuINgVAACE17eGpqrTqDLAQiNwNHi6xCt9ZkM4DR9w+edb/HXTWcg
         DqqRDhBZeATfF9cql4RTMHeoB9gBewcJ+Dsi5R7ZH1oGp1eM0KNjIRp2JD2qi4eNUxsM
         vxWNJCTOItwvpekUeIGNh+AX8hQS9Cgi48LKrm1/OVQNJCqPxl2LIL1o36PCMEaKoHCk
         B1/pHkgpaqbdnRR5C9g1W5guHM2FReLv8ESfjxzQLVrOYL0h3jPhpCQiet773USRh4tL
         g6JQ==
X-Gm-Message-State: AOAM533I1BQMQyELh/vp0vM7wNaCFSDu+4C3jGlQaIQQwyF03O7DWpdI
        DCynhCZYcKhBitQXiQIarox1F32mQCqmI5HF
X-Google-Smtp-Source: ABdhPJw1jKNOi1OkzcGMFGeCk2Bkssd00DoPblIIWhUau63QXT7iDsRFz/vE4ae0sIhQEfwV+6qXPg==
X-Received: by 2002:a17:90a:d991:: with SMTP id d17mr4404083pjv.54.1628618329241;
        Tue, 10 Aug 2021 10:58:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y12sm30389578pgk.7.2021.08.10.10.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 10:58:48 -0700 (PDT)
Message-ID: <6112be58.1c69fb81.9226b.6892@mx.google.com>
Date:   Tue, 10 Aug 2021 10:58:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.279-21-g0de8bf990a6c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 73 runs,
 1 regressions (v4.4.279-21-g0de8bf990a6c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 73 runs, 1 regressions (v4.4.279-21-g0de8bf99=
0a6c)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.279-21-g0de8bf990a6c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.279-21-g0de8bf990a6c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0de8bf990a6c2cf19e3716f184c7a778f2df52a7 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61128507f8b52df984b136a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-2=
1-g0de8bf990a6c/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-2=
1-g0de8bf990a6c/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61128507f8b52df984b13=
6a6
        new failure (last pass: v4.4.279-17-g21c299919e47) =

 =20
