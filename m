Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4319320F2A
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 02:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhBVBfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 20:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhBVBfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 20:35:23 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8693AC06178B
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 17:34:42 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o7so9266867pgl.1
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 17:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BaK0Zwi1TyzbYMvoTc8ajhNooX3vGY2fCboUBok0zkk=;
        b=pssDlEtIJbDgn7FTh0rn/OP2d4OTcKQHruwuUt9NuwdscDxDVhQu0BNtctXSOiHH/d
         BRPrS61DdWeg1xl9ddK0UbHXiPVcA4S2d2KtIyPejM1EWa3JotIJ6IivJkbJPx8r5b3E
         rdl79dq56jPWGzaq6u08floA230b9/HNXEwmZWRzLdeWlj2HpjVkfKLYBhTtx385AxBW
         rX0jEMapf+ZBCZ2bAwqC9DZmGTPSvvGbvYMWZWEJQbT2dsI22KwMNAFXLcx97E7kdL+k
         acIyerWgHUIrMZ0Dihpq/530Eu1cLpD8J4WZwMklcsgYb1pS9KP5VVsKz6PHTihx81VC
         ATTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BaK0Zwi1TyzbYMvoTc8ajhNooX3vGY2fCboUBok0zkk=;
        b=dfKrY7XugN/sa9NGsPbUaZUIrqk0BS0e/mzg9iuPtpelE/+D6vEc2Y4nqL7VBZZsyH
         Xh1BJStzgQSFD+8H10EJOOr5L/4b8XeMMV26+JrUzrQZ56S4gXlSGp2Y6uNyWwjZuxnK
         wh5jez/x5KLFAXn5jaeiKMputIMkG5tPltgFva+zAvw/YnttJK+Vh0hFR9PiM5CqFNCw
         T1HH3cX80jxU3b4KlhbQuRKAsu8gfUOKHflodjY2Uo8xdDvmC3KchxukFi2lCrz7I+Tm
         n77v5MHW6E3df1ias8N6Tk7P3T5E8CCLZjndutSteGVGlnZalGp6+ZKP5OW3JtYpIpLh
         v9rg==
X-Gm-Message-State: AOAM531Y84nWPbIdYoZ0QLmZwqdrD5rFSGQbzFyWdJvtdBrxSpGT/p7V
        bZOVTuqnWp22RktW4CAbzMxvnt7OrRMCgQ==
X-Google-Smtp-Source: ABdhPJzwasm8bSKcRjTSFyeycEv+zykW0trrmfnXB/CTt4TzLCqpmfhL/lARWvt/VOsk8oXf0Y/q8w==
X-Received: by 2002:a63:d304:: with SMTP id b4mr17978035pgg.299.1613957681841;
        Sun, 21 Feb 2021 17:34:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w3sm15825045pjt.4.2021.02.21.17.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 17:34:41 -0800 (PST)
Message-ID: <60330a31.1c69fb81.c73c9.2ec2@mx.google.com>
Date:   Sun, 21 Feb 2021 17:34:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257-38-g1731f253f5cd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 54 runs,
 1 regressions (v4.9.257-38-g1731f253f5cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 54 runs, 1 regressions (v4.9.257-38-g1731f253=
f5cd)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-38-g1731f253f5cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-38-g1731f253f5cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1731f253f5cd3f5e69559a140a9de549f54f29ba =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6032e75938200aeb9daddcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-3=
8-g1731f253f5cd/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-beagle=
bone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-3=
8-g1731f253f5cd/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-beagle=
bone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6032e75938200aeb9dadd=
cbf
        new failure (last pass: v4.9.257-38-g75122d114f4f7) =

 =20
