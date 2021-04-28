Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6E436DCC7
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 18:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbhD1QPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 12:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbhD1QPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 12:15:39 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4BEC061573
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 09:14:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id lp8so3014684pjb.1
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 09:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b0ns1JhHP79I39HacYp8rKKTLfjr1W+YrAHEoMqZcaI=;
        b=DJ+fVg6mtkG0w0E0HZ0rXY0Uk67vybaBlIzla/Fx8g8CNn+xZBYIVKK64E1ILoqQ7M
         7SFtUl1RTBpfFLvpptfWz31tLqIwX4UKaWp5rtgzgguiz07MCS6blkXgburVPWG8sXwv
         sURV5rqOf0TE1RPYiqy9cznH87bDroWHJ8MwkYtuGQhidk3uysS5M9+FbFUUkA0GaH2R
         1iucauOvzu/nOEcVeE/gS0eL39rMwqa+4WXpTU3nfLabtzpBGP3mrHxjOGw/Y5TXFqzv
         ims0BF3kDrJY+5p0bfnxY3GQx7wnK6rAhkmcKZWm4jJNm8dq1wf4AM073mIOvAlymsQr
         Ni2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b0ns1JhHP79I39HacYp8rKKTLfjr1W+YrAHEoMqZcaI=;
        b=PE4wwF/qWu9LRii0t+hcn0rwfsWqduxLUNa8GjZiJymuxXGTYZNmndwgLg/kLMoF1q
         iFnK8+92aAYM7KMOD2RYTWVxK8t3JY1lb4gdfjL6cEVCzOz+2FQmsTPvDICt1p/0VinR
         UGUukv/oQXxdG0NXrnoP1sl36OSl7UzYjzluUHeYxSqZTfT/z6FaT+TERY0CogJTqp5z
         gSkgkYaJaP2XDJtYe/gmrASa92pi5oEzfDgmfiSACaDTaDvJ0A4MVRELb4gLEdCkXIX9
         2ApAyFlBMGgUbjiusL5BIyCQ+vpvXEs/H9RyeY8WMTgSfEvgy7vNENVY4+QtNKpmPV7v
         KDNA==
X-Gm-Message-State: AOAM532grRxcf9pVZeqRJXpRExBu37frVPOD8CtNCiRDXRxjJ+U+48p/
        LNTbbu2dPvqJRWOLiGXFubcDc80qnYxB4Om5
X-Google-Smtp-Source: ABdhPJy+F48By1iXIwZaospwOVEJFEvMuypKrP7dUQYcM5ZcupG5BTLYP/FBEKGdd3e2z8DGM7D1gg==
X-Received: by 2002:a17:90a:150e:: with SMTP id l14mr4920494pja.208.1619626492248;
        Wed, 28 Apr 2021 09:14:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 31sm191168pgw.3.2021.04.28.09.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 09:14:51 -0700 (PDT)
Message-ID: <608989fb.1c69fb81.6297c.0a4f@mx.google.com>
Date:   Wed, 28 Apr 2021 09:14:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.114-22-gafdc03cb7f7ce
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 123 runs,
 1 regressions (v5.4.114-22-gafdc03cb7f7ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 123 runs, 1 regressions (v5.4.114-22-gafdc03c=
b7f7ce)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.114-22-gafdc03cb7f7ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.114-22-gafdc03cb7f7ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      afdc03cb7f7cee49a59df261fc7599da6cc7c36c =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6089575e1d4ea861a89b779a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-2=
2-gafdc03cb7f7ce/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-2=
2-gafdc03cb7f7ce/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089575e1d4ea861a89b7=
79b
        new failure (last pass: v5.4.114-22-g6eaa1578d5444) =

 =20
