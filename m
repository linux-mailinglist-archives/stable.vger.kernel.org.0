Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B96319488
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 21:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhBKUc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 15:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhBKUcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 15:32:12 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B30AC061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 12:31:32 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l18so4093504pji.3
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 12:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M8rdn0tRQJc+4L3FejQUTwDmR/N+TuGZjwKWbKTCrow=;
        b=PhRr9ce5yWsnIGKXpugQQZdty2t2QuKrlI9J34e+UEFfkfI025FpDWhMgs+bLIecy+
         1/SOE3bUOCeUCY70XLC5tlYFvOrcQXpfdTWrJC3GAx7vj1HuCBJtpvz0QQ+7+6i6/lHR
         Q8pv0+z0l7i1jtuJzHXDZYflvDb3L9+5GIAK6pfjaX7kaSTmEfKE0tLgSc1eM053wphr
         sHEk1skyP8YmsguT63FPgzQrULPpwv71qBVRv22LGTbeWU2kkqLvf7ULwtOMjQadeHF0
         stNRfBbHm4sfVVZpyN6TE+xxCsRf5bS64OmhzFQzyfjrvkrcf8VArvf3pU8fkGwAP2MX
         mSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M8rdn0tRQJc+4L3FejQUTwDmR/N+TuGZjwKWbKTCrow=;
        b=VWY4s0UsuYI6yXEkzzRSpERN3gITYtb1tdhaECUYak6GOMr3qcBH0cuJfjkD8mxfUi
         n21mLEN40ddRD3Q4sUWrtd00RLab+m9OZvV+bOurYKpEhpnZ6bdGGwEqv2E+GjITJDDR
         ynQbIhFjuJrhSLD2JBCddWlk/wSSG+4ub+IsiDkcKYB3xyW6SbIwte4E1PQo8zZu1OBA
         4ZXBpGk83FSUVronfiQ4nKc2xFppB6/g5lQkVJS3qkZL12bB0NY0kLG8KaE6rKn7gGhB
         wXzTgwoEigQ/igbHF16NEnjT0TtTm2A0NxLMqK8oyxUnVPFLD4QFYVm22K6nLrInF5zP
         lvCQ==
X-Gm-Message-State: AOAM532j7A5GQ3JyIxaDNeAuC9y20SAsxQ37Ld6f3KDGpxhBh/W9qfcz
        CzWBPfWtkOTotsCoTIawNoXj1NBzI6EjHg==
X-Google-Smtp-Source: ABdhPJwd7NbmMGYN9ajEIr4cNprAIwpOaR24dTcv5LTIupCAkE11A3YNwpv6WaOXXDaH6U3imSKHhQ==
X-Received: by 2002:a17:90a:5914:: with SMTP id k20mr5473618pji.199.1613075491420;
        Thu, 11 Feb 2021 12:31:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5sm6594973pfb.11.2021.02.11.12.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:31:30 -0800 (PST)
Message-ID: <60259422.1c69fb81.6e215.eada@mx.google.com>
Date:   Thu, 11 Feb 2021 12:31:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257-19-gb6978209a21b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 43 runs,
 1 regressions (v4.9.257-19-gb6978209a21b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 43 runs, 1 regressions (v4.9.257-19-gb69782=
09a21b)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.257-19-gb6978209a21b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.257-19-gb6978209a21b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6978209a21b7a0815c777761505fa29161308f7 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602564e48b8ed4c2cb3abe86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-19-gb6978209a21b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-19-gb6978209a21b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602564e48b8ed4c2cb3ab=
e87
        failing since 85 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
