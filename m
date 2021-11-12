Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5F044EFB9
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 23:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhKLWuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 17:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbhKLWub (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 17:50:31 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49802C061767
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 14:47:40 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c126so9731307pfb.0
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 14:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QEHAe5mCeo60NNdlCNyhwfCEKbhN5Z7Bn7vfQf1WkG4=;
        b=jtCxE/GaZeAyV7rAyBURcnHhAplyS9igWReyQf1cFsuD7pOzoG6FIC5pt+mTgFQaUn
         x9dcEPg1QBQ+LkWo+l7JqkrN64sTZK7nTHbZiXv+5nuTtyK3qDgZBZt0EB62mVV/ydwN
         tWunajbnSjaC7ypAXWsbwuJiTMTgg6g2VjOt9vVEPIJq35/8/rZt+Q7NEN9z1ljjtVVK
         OEsuVv8abqOD3Oki/W5bEIZnPtMtU6wY2sp2X4mq++xZKLMu8xTPK/5Tr0rl8PPxH/+F
         BEbHbSnVOI2f3pYCJ5eCDIjbeLXuXNwPn4nuT7u2J/CfHESNG8NqQcr7r2iRM6lX91jU
         wG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QEHAe5mCeo60NNdlCNyhwfCEKbhN5Z7Bn7vfQf1WkG4=;
        b=QGjin7EvAkGNB34Pqaa9OxMTChM1XO87w87IF6w8ml45kmpXjgXA25JlpberBLPOuD
         BgB8i+TBf9NbRTaWOghi2u5nsWblcZpu3STbs4PAdQua3ewUtracyK0OfVrnFN+nqmRN
         /Hc3BHiE/e4oBQ2MjRLcDr3sX2XVR9rQ8KepxH8MeF/r8Bo2PDxWCl5DJxOyzCjpGQfW
         Sv4ldd1j6ZyJKdzwXH4BDJGyP8w2XZXToOrHXm90lk1qbrE1NXVbw6/6beOF96xl5zPC
         QCG9QWOvfKyCD/Axs7gm720gue6njyIk3IXTnjag6a6SAUM01UppelwzxlzV1nPmEEoi
         lu+A==
X-Gm-Message-State: AOAM5336qNZ5OONtwlRG2VPiw1y06R9+QIyXU212ZzfqO/lDFbul3JgL
        pPQWJzsSElVKsPNaEHWne7OA14ZswYMGs8fP
X-Google-Smtp-Source: ABdhPJyQeDUvXwa4BkNuW/UkrZTb+tSXnDReFnmqLzSoT05g/T53fC+bWX7XWdBAuYFVFLifimCa/Q==
X-Received: by 2002:a63:1b44:: with SMTP id b4mr12309280pgm.246.1636757257626;
        Fri, 12 Nov 2021 14:47:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w129sm7186084pfd.61.2021.11.12.14.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 14:47:37 -0800 (PST)
Message-ID: <618eef09.1c69fb81.7ea81.5762@mx.google.com>
Date:   Fri, 12 Nov 2021 14:47:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-27-g96c5ecb36d38
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 210 runs,
 1 regressions (v5.14.17-27-g96c5ecb36d38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 210 runs, 1 regressions (v5.14.17-27-g96c5ec=
b36d38)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-27-g96c5ecb36d38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-27-g96c5ecb36d38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96c5ecb36d381e0fa1ee629dd51171da1cacb6a0 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618eb962c0d7f1c66c3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
27-g96c5ecb36d38/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
27-g96c5ecb36d38/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618eb962c0d7f1c66c335=
8dd
        failing since 19 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
