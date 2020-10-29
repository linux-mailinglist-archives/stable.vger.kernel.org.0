Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A1429EE1F
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 15:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJ2OZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 10:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgJ2OYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 10:24:14 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD46C0613D2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 07:24:13 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b19so1383657pld.0
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 07:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+WhFNjtrh3rDSNEWcOClGPkw1ypjzoaDHvQfQ1vHhjU=;
        b=GSHBNUGjRDSbo3br65XTCiZevPMre5W2TGDd7E5LdCVn5lnzOUdcXEFb8IWy3w6pT+
         b2C42EvH8MpV9Ok3DGvTFk/ilvjIVa31GMoRSx2622zTxvxzrQeji5XQCZkeLcR7CmIZ
         BINQ+VFOiz9DraznV6V3zmtm8yW/Qtw+LQYkPoEQBykzuWF2/o2BQvpfBq0D4sf4ghYT
         N6g8Ziw+gLsSDT6H705XpQy/3hOpboLPtFUi1Sx9nOio7lQzWY1mZUpRAu66Qn/MYZOj
         oO4Vcw1Fb1DoT6GexpHxXBUvwrRRKOnxcgFXINNS+W3PGqmImqW8K7jGuDLKUwDCofRb
         7kVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+WhFNjtrh3rDSNEWcOClGPkw1ypjzoaDHvQfQ1vHhjU=;
        b=USECR3v1ZL5u3tdrSrVZdxBEsOy8wFdms8ysvpzR2GFweH9JjnLK65ZCuQHjkICw+N
         b/9qMGDYu+Z+Q2TXevPx0J1jUghvfOu6e49wqxeRopmfu+zGXHDmPBJeniv2PaFoOHuH
         EuYzEQMVRAHbygr2F8QvCGLvKD2rho/wQT81WQmp3IcjxX6MnKWvhdSXkasXW9ONvf7v
         N3r4L5GyrubWT/rlYg/00RvrMeYuDqFUkvv9rFgeTsv3zl/pKvI2UV7dKl4G3PAgz+5J
         eX33EODZTvWB5c2r/Ql8kURMG6X+Wz90uRzYqeBTbSCEnHm5CUmwfRVaReWjiR0nzZ+x
         UJnA==
X-Gm-Message-State: AOAM533V2/fXXMuxrs7mqsr7kQzhA5bdENYZM174Hh7DJTN1O9qFuRkk
        +tZCXGe81abrzjLqwGX9II8eeTSpx1JUlw==
X-Google-Smtp-Source: ABdhPJy0+yJCQ4igl09tsoXJkh2JfV6L61kBvJLakCJFKHfCVkDndqEH41dqidZIaLpkh5KtqVeBsQ==
X-Received: by 2002:a17:902:74cc:b029:d6:488:e5f2 with SMTP id f12-20020a17090274ccb02900d60488e5f2mr4512253plt.62.1603981453069;
        Thu, 29 Oct 2020 07:24:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4sm3195727pfc.63.2020.10.29.07.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 07:24:12 -0700 (PDT)
Message-ID: <5f9ad08c.1c69fb81.3b6bc.7ada@mx.google.com>
Date:   Thu, 29 Oct 2020 07:24:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-112-g1a1bb4139b4c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 127 runs,
 1 regressions (v4.4.240-112-g1a1bb4139b4c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 127 runs, 1 regressions (v4.4.240-112-g1a1bb4=
139b4c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-112-g1a1bb4139b4c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-112-g1a1bb4139b4c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a1bb4139b4c785288e81800e888cc65c8973a64 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9a9fa5695ae1cbb2381027

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-g1a1bb4139b4c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-g1a1bb4139b4c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9a9fa5695ae1c=
bb238102e
        new failure (last pass: v4.4.240-112-g4dcf57ce1d3e)
        2 lines =

 =20
