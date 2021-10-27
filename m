Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDE843CCBE
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 16:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbhJ0Oyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 10:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbhJ0Oya (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 10:54:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F65C061570
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 07:52:05 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u6-20020a17090a3fc600b001a00250584aso5328292pjm.4
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 07:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KyZEHAIx/edlKikc5zPn9jo7qChpQGSVlglVEYcIlKs=;
        b=yddnNaSJERQi0SsoF4PaG5ZUGg3+J5lDAml6KP23sfOQOdyrYvWVSQ8zzDW76XEye/
         dM8Cn1exf3BDj1XSSRicLgOyuwiUhXJ3aWljqungUxW8LEm6WPJuBKbMUE495eaKHs+G
         NjKRgGBOYIAtvfOhcY6OffZwTHgPYlWPBs6nAnTSB35VnqE7D/ecKEqqxFTGMshoKiF5
         osCo09WB3C0tJFaCqT/Dvlc2vEWX6aTNJnTyUPHM/3x9/VUQcJl5Yh0ugE3e58vsKlbp
         Id+Ot87aPYXHs2YNgCncsd5vLF7ZCnq1PZAeAfpDkgQInRMYsmNSwPKYM/CoeoHjCOnl
         Kbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KyZEHAIx/edlKikc5zPn9jo7qChpQGSVlglVEYcIlKs=;
        b=JozcYdfq7iRb8ASREv66WxDYoO/znBoE7ArzGNBKlRdLx+L9Mnifzm+lbaEzMNkvjW
         F/4sWplsJIm2FL62cNfsdXcu8aC5nlM+4U8cxfOxPxHZKryyQBo4xmq4GTG0j5l+NH3a
         oqcSRO7Jb9QHBuLYrkosj/Uie/v5+muBI0Lcnqh0b/JxLqHrHWWBffVq7vFcx8iCHf3o
         K1i/rLaePiFJjFHYIsEHdhQWL5ZU9my35vyojrbaz8kDJ1Yknx8k0t4qh4YtiCsfeBo/
         zzAdJCbfkqmybSvbx+LXoWGEzch+zw4+BBUEskq82BJ6tt4GndcqMqkcbjaXN4cCKiTG
         5T7w==
X-Gm-Message-State: AOAM530MlLwQO/D68NY2kGb6o8808suDeBZ9zNULbuxYPtSyCdgYYOOC
        u1mBU3FzJfI3tm/jwMj7rBAF3IPq5xhEufwufYE=
X-Google-Smtp-Source: ABdhPJwsaJfce+sXpNNAmlbfema0VfIuEo+DjxhiP18FrpXqfNhwmITgGipKavSrHy/uOqvq1SoUQA==
X-Received: by 2002:a17:90a:5b0c:: with SMTP id o12mr6299291pji.11.1635346324954;
        Wed, 27 Oct 2021 07:52:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e8sm271608pfn.45.2021.10.27.07.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 07:52:04 -0700 (PDT)
Message-ID: <61796794.1c69fb81.5d086.0acf@mx.google.com>
Date:   Wed, 27 Oct 2021 07:52:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-168-gab2e382f7329
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 138 runs,
 1 regressions (v5.14.14-168-gab2e382f7329)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 138 runs, 1 regressions (v5.14.14-168-gab2e3=
82f7329)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.14-168-gab2e382f7329/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.14-168-gab2e382f7329
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab2e382f73296a8c0f50824458a015dadef245d7 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6179337486e1ffce6a3358ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
168-gab2e382f7329/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
168-gab2e382f7329/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6179337486e1ffce6a335=
8f0
        failing since 2 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =20
