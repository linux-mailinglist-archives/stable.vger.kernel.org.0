Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711C73265FE
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 18:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhBZRAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 12:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhBZQ7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 11:59:43 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE7DC06174A
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 08:59:01 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u11so5588034plg.13
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 08:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2rXzmwbQ3VqFPCLv8L9jc4F0FqXzKCN87PCs3gd0IrI=;
        b=SGzh+kJlYIe0KEF5GIOK7e/uh98b7BAqCubLI+6PfZENfvcLwlZEIZcuhFIS0qIjDR
         bHPmX+aWR/43lemJ6T4kyn0L4MdzWn+F77WnZYDNLOF0Nwhe7h1vObT0RAECtVDrqHOw
         ZYXWe/EXUdgs0tU6jPng0x/vU6LCE9J9bFMW4yKKnx2eGIkPTMzrAHpHJmb4Bo1viXpN
         iqxzQ8X6e0nmqRaGdQDe97oVxs8qMQQWnZcnI4Jrm+VNtTIROD3PGNtVz3/5+NnFxp5x
         /Xjst1CStKGFkT4xR2d3Op5qiciSxiZu3VCM6RgsvbJBKpSUNU56rW1V3Da5FWu8uQjX
         Gl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2rXzmwbQ3VqFPCLv8L9jc4F0FqXzKCN87PCs3gd0IrI=;
        b=Op11SG/qyuJneuedakuEut4rqZYINNSqqyrqeJu0ja6qaOSp3GVr1do0Uaz6uyIsNn
         A3UrQlVz6mpZHcjPsHCKJ+KN7imkrqE+BsQrdmOlOEgzLQSREdhCtogReTDTVLN6rHpB
         fNVveaQzRBXewbLaAt8A30JLqIKuQMb3bMAkAUrDOTmS/3gJgSkNBmt5TssAYOivWfPM
         3gmQp8ZlkGotTooJ7X/4fC0CYUApArAI9iA66u79nIOWDuVXru+gmXClcQgK7kRZXuOU
         oKnD0ue58/JQTynvWcqnt5pPk1e1vf3h9ENKKlgy1DPjrgdFAQyIhb6ysL9bZPznTGV9
         VmAw==
X-Gm-Message-State: AOAM530tjyX6eBC1Wx5tevDyn8cjZldNhgqcCmjnONF4EGtYo/NUzzUI
        2HWkn0cqkIB7O4U5+3KekshN7cvUeP3TGQ==
X-Google-Smtp-Source: ABdhPJyIx/RdZO6uM9VRHL+dPRfiBDaJAnlozbIpPUDFKuhn0BP/kjCG1ME9cedJm93bcx6MpHU+fg==
X-Received: by 2002:a17:902:968e:b029:e3:a9b8:60b4 with SMTP id n14-20020a170902968eb02900e3a9b860b4mr4044014plp.61.1614358741230;
        Fri, 26 Feb 2021 08:59:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15sm9889146pfb.30.2021.02.26.08.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 08:59:01 -0800 (PST)
Message-ID: <603928d5.1c69fb81.92b10.66d3@mx.google.com>
Date:   Fri, 26 Feb 2021 08:59:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 101 runs, 1 regressions (v5.4.101)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 101 runs, 1 regressions (v5.4.101)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.101/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.101
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef1fcccf6e5fe3aabe7c3590964efac6d5220c43 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6038f3cafd3d3be7bbaddcea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6038f3cafd3d3be7bbadd=
ceb
        failing since 98 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =20
