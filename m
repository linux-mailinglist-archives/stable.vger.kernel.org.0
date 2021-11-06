Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E2D447017
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 20:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhKFT2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 15:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhKFT2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 15:28:03 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4066CC061570
        for <stable@vger.kernel.org>; Sat,  6 Nov 2021 12:25:22 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so5713094pjl.2
        for <stable@vger.kernel.org>; Sat, 06 Nov 2021 12:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PhTpfX3NL1GLr87Ct50YJCdTp+wqTKGWVkuZhfCjnRY=;
        b=KQvNYPVpu2/DNJxL0xswkQHpxWV0JcFVEhP1tBKsE5F03YtBQdwRbisGhymHJqTy3y
         vBkoi+++Dz0oeVs7+yKGCyZEafgJkbb5R5S9NaTl73DtpJYRpm6gmuhqs+eazvnkahvi
         3L6kCdq5uq0oMwZX3h2uKg7syL1jx4WcZwr8SguZ3U7FK9JkGowe5oMVETK8bM6XmUsf
         72huVj85i7wXN5yvCf3+Hy6keDoZOUUFeYgkGm+LUwMTAG0WPDyZ7Uj5E6aWNKrknB6u
         jpkoC1pbe2HIri1UGq+xZJt5NRbFMAxZtw8UzOKf7kazH49xpCNVxRAVqGDNvP8kqi2g
         7Uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PhTpfX3NL1GLr87Ct50YJCdTp+wqTKGWVkuZhfCjnRY=;
        b=VJcT5U2NBsAAvk9bT+6cvwKWeH7zIlV2mJYWkyteO9YHyolqOcS6ZNg80KkeLcYY8p
         JU8e7y3wuvBo8b6W6ysT/gqr3VzSXwBHbrarfzpykIp5yGxy+HqeKiR499+pjzKW9AYo
         SeseG7MzokEKWpcRL/tep0GhPFXlEazYhKSVEcQmjo23BB+aHJzLeExDsoI+7jh/whTg
         2nPYYTP46cSdCFaPOaQ4IgocB/Aa0td/1e9Z0Yxw/9vAKy5GVbGER4Kf3wp+iwUlRlGy
         /S/FL6CJ4BEvEkLntJf3FSY0cCIBRnMRXyhHgz/YzodcVsIaj1hhnJlMNNEk3lz/EL6+
         5bow==
X-Gm-Message-State: AOAM531QBq5MOv8aK44lT3kwt3BPZxLhvSY8Gr/X9O6q2xmff60YC2q5
        Zq+AaLF9O2veb+b7kqrySSR6FPaBm0V44slF
X-Google-Smtp-Source: ABdhPJzlEqH2b158AgIOPgut6KTwptb+B3F9e7ZqkB/+f0vOaP4bRbs6B+aK+g+LB/EB0xb1yExVng==
X-Received: by 2002:a17:90b:350b:: with SMTP id ls11mr30102614pjb.227.1636226721482;
        Sat, 06 Nov 2021 12:25:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm11325351pfv.193.2021.11.06.12.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 12:25:21 -0700 (PDT)
Message-ID: <6186d6a1.1c69fb81.d8583.2bf0@mx.google.com>
Date:   Sat, 06 Nov 2021 12:25:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-5-ga04f0d029c20
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 135 runs,
 1 regressions (v4.9.289-5-ga04f0d029c20)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 135 runs, 1 regressions (v4.9.289-5-ga04f0d02=
9c20)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-5-ga04f0d029c20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-5-ga04f0d029c20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a04f0d029c20c3cdbdbcab0c82fb20334facfbff =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61869ec2fc7188aa583358f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-5=
-ga04f0d029c20/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-5=
-ga04f0d029c20/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61869ec2fc7188aa58335=
8f3
        new failure (last pass: v4.9.289-5-gd40c0701ae4c) =

 =20
