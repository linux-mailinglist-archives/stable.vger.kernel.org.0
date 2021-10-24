Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E62438B50
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 20:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhJXSRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 14:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhJXSRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Oct 2021 14:17:40 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9074C061745
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 11:15:19 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m14so8571771pfc.9
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 11:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dukAIiOzcSA5AD0pOKnzS7GLFPE36Nv6wjNj1xjNoMI=;
        b=GfPogLbcrLTIR2c2ZjhjaE2MXxpQIMQKevCEDwB/hpxAX5gUwo5M1kHPIdB0B2x4dq
         WLRb8HePZ3XnV6GN3YTNkK+Rh4mvho+mzRbA2Za/ZE/QJYuPhqO9LCsNZWWkYqZt7Gns
         i2v58NQUZzPNclY8KOrcTGGTDJ/NW6zK9sS/C1M0x2xq4BrRMSMs/ajENwYLLwmfajfg
         Ufj/4qjT/S1NUmE4/qyzn36oSlF4urOfBD6WnCFjUXxyxAImvsxhK2AtPK/7mglT6zZ/
         BG6TFItaUi/hcbUUtsdNZ9ytbkxyN8rOC9Jim6ehSayAP1qsHWbXGGt2xOKMbi4lvBS+
         7n5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dukAIiOzcSA5AD0pOKnzS7GLFPE36Nv6wjNj1xjNoMI=;
        b=bz7v5grNEqfkcwvTe4uflpuVeBF32kHKaerwRkdr1kujvA2QTUNjAkFb/d/zrutmcs
         ottCPkIay4ZkmOW2GZ/iW6FFJzoTEVnZRaTa+F4jY7xVS6Kk5UmIKPdi8Nt4Rf4uy/sL
         DuVUZ01JhMQA/VFW4zcC9AmIs+80Bj5tWUco9z9BXdotfKwuVc764dGW7ZRqPs4GO4nI
         OJAxFbjVE+MwP9oj5lJqKuc+yV0ZRibEc8jHWATu+q4FjwYpQJkIj8ac3k4niyAzN0at
         QxO/nFHlutB/Xf2V8jSMnuSM7OzDysmWrHZlYuk8ZYBw44+KalJeMBEf0ILrbg2KQ1vQ
         7REw==
X-Gm-Message-State: AOAM531AwwEVdLKq2rQbOF0RcETQqlXTmOTJeV2X973gFSS2JVwDrND5
        rvPaRtZ7unkQTwyZGT93L49aAz10WAWj4Mjy
X-Google-Smtp-Source: ABdhPJz9cOvrQQNGjnaHH/LFx2TVZnh2sfNJ2K8J6XPMacaiOp9A63VbULzosHmtVB5771ScCTCLEA==
X-Received: by 2002:a63:be4b:: with SMTP id g11mr9991650pgo.46.1635099319187;
        Sun, 24 Oct 2021 11:15:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a11sm17781936pfv.11.2021.10.24.11.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 11:15:18 -0700 (PDT)
Message-ID: <6175a2b6.1c69fb81.183e1.da8c@mx.google.com>
Date:   Sun, 24 Oct 2021 11:15:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-124-g710e5bbf51e3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 184 runs,
 1 regressions (v5.14.14-124-g710e5bbf51e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 184 runs, 1 regressions (v5.14.14-124-g710e5=
bbf51e3)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.14-124-g710e5bbf51e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.14-124-g710e5bbf51e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      710e5bbf51e30d3dc6558a26e9ea5e040bc5033a =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617572b90c1fa8ff673358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
124-g710e5bbf51e3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
124-g710e5bbf51e3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617572b90c1fa8ff67335=
8e0
        new failure (last pass: v5.14.14-64-gb66eb77f69e4) =

 =20
