Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD014391F2
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 11:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhJYJIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 05:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbhJYJIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 05:08:21 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E8DC061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 02:05:59 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y1so7453781plk.10
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 02:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ipMfkw/ZXfZIYCBN7rvm7iV6v3yehuT0mcKesYpygf8=;
        b=VVppArO8y4Afs7iVt4jkJroF9WwTNr319dpR7xpRaCLM1c2qsvT4EHjU39027W7xQv
         cJoysWNTKH2laKUbnlBx3PwZISCalYm5n1GAiIVAoyVXqjDYn1/+TYiZXhNuJOBki9MX
         vNkKn9glfzdjENuS3+Y/BgLH0kUwHdgOM/bW0py+ywUCeJeqrd1WdCJ1+fXtqCudei9e
         RLbZrSCD0pPvplpGhokHt/p6TYRMOc3VpmUgxrv6/hDGys4xem4dNdD2hIdVGLp7ia7l
         SsMzXg9d/3R/U1IzOcK9P3fAEZfNMNtO30UfoNR21NcS99O53aCGQCXDFMHMQRnVsjtk
         ABXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ipMfkw/ZXfZIYCBN7rvm7iV6v3yehuT0mcKesYpygf8=;
        b=SxrfJVaaCqqU7TfVpLrlJn0jA09X+krhF3gjdH43343gGSujzZ2CsfdNnpvqmPpi9S
         cob06rttnufsGYI1anz+x4AKLeUwR+W5oTDGp3ri6I6tImmHNIuM+b854kZGUD4yD7jw
         1cZufHI37oHuSOv26EyP4FGsILAvIzGERPbSwy0Hkhbz4ORBcNcA+xE3lpyINnOtAvtf
         JEJtx6yNJWN4RkVireXyckPV4d7ke5supcJiA8ysXAYs9CP6q/Zwqp6QOFrJVRpEmkyk
         wxjrWi1ioZdE8+jKveRvli+injaeTNuDWND096y5yiplcxOWeVP57MV1e56UPSxc4u6D
         VVFQ==
X-Gm-Message-State: AOAM532lgl9cGzFpdzxTcwBwU/2D975sdNU7+gfrcvGJMbfiMTk1mMCX
        3+glqtadC6fI0vv4GOa5ZiX73hmAXBh3tg==
X-Google-Smtp-Source: ABdhPJwZ7c20RMcdysKxKYeV+pFtloYLDrPb1ATd6fYgabt4K6wBdjwBXAUDGwn5nBAovO9XW+QZAg==
X-Received: by 2002:a17:903:189:b0:140:5f35:437 with SMTP id z9-20020a170903018900b001405f350437mr2169534plg.56.1635152759348;
        Mon, 25 Oct 2021 02:05:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l14sm21453936pjq.13.2021.10.25.02.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 02:05:59 -0700 (PDT)
Message-ID: <61767377.1c69fb81.6ab0e.9dd5@mx.google.com>
Date:   Mon, 25 Oct 2021 02:05:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-159-g1edf0cf850d7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 168 runs,
 1 regressions (v5.14.14-159-g1edf0cf850d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 168 runs, 1 regressions (v5.14.14-159-g1edf0=
cf850d7)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.14-159-g1edf0cf850d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.14-159-g1edf0cf850d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1edf0cf850d73a4ca01c16192bd82a43e478f027 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61763f9a6c5f087a473358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
159-g1edf0cf850d7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
159-g1edf0cf850d7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61763f9a6c5f087a47335=
8dd
        failing since 0 day (last pass: v5.14.14-64-gb66eb77f69e4, first fa=
il: v5.14.14-124-g710e5bbf51e3) =

 =20
