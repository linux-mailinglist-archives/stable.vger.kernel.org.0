Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C123839DE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244915AbhEQQbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241351AbhEQQbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:31:05 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7C7C0651C9
        for <stable@vger.kernel.org>; Mon, 17 May 2021 08:14:38 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pf4-20020a17090b1d84b029015ccffe0f2eso5752484pjb.0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 08:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qRLsoKw61jm1LVUpJezC9QKg+0T46kZfkuBMGOou6lw=;
        b=BXPRNPAzhGJlk92reHVGQ/Xi1B3jFS6BO/HhuJJafeeU0Sk0Qzer8VabFbCk1Yc568
         d5TGz5OMP2l1TdfVOavjPZ+k1AbtAAqgWlSV9BzzoGE+/oS7b+xjQWMnFaBFqLZx75Mj
         Km9vMtK37uCNmBQyJ0zcHI3OoID2txSJzvGtsZ4j7Yn7wO87QAoIqgcx4spCr5IKBlLz
         Q9iHoWtb6i8XLTz/We2mD4nPfWHfrdUZ8lvPvf4gvaltuRQZBaGIlk+5XsAlyHF6ZT3N
         AJ4+1MzpeFL+70Df7aRQ5GjltWrSCRqJlQYkUe3GbBnCFTScjwfHCW+3bA9Aa/pBpvVX
         CoOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qRLsoKw61jm1LVUpJezC9QKg+0T46kZfkuBMGOou6lw=;
        b=gqwSpbia7vJERLHhOzLU3fKw14VrNZsC0Ri/5hoJSw6WIGsMlbQKhpCEBEYxAQvUBs
         k3HpwdjTeAuQP5UgFX9X8Nbw/Z4L0gJHPPDiQsT2zfI5aOZL71A84PKB2lPuUG9Mcv1p
         cJkmbGNdeQVG0fVTDARRf25/uDiYcTcLpnSiMdozWfrzgWYpW7zi4BV9Rm4vD7TPCPHX
         TEl5bGJp6TyNmOX31r/8Y++Lehv8MjHN57DUEaVKTexePDsLx/nWqIOW9N9jpSxY8SaM
         rM93IgjvL3p853RLWlEdKAYFzhTIX/50WI7E2gSjOWG44SYrubiZeDWHVtqxlGnZMzxi
         BcoQ==
X-Gm-Message-State: AOAM531EUuXX0YS2llOQJK22WVjhrsshZU5Y5YgBWyduvR+IlxlKb5GN
        LMJFk+bppwogsVvdxZWTHtpjqMdN15CJRE9a
X-Google-Smtp-Source: ABdhPJxbL4CO+MahXoQ1g1A8gQI8Ke5BE8RCq7OXCNIp5TrJ5oDDNGhNhWVhpTDQRcfO5qz7AWni2g==
X-Received: by 2002:a17:90b:4ac2:: with SMTP id mh2mr416126pjb.33.1621264478297;
        Mon, 17 May 2021 08:14:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8sm10033625pff.167.2021.05.17.08.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 08:14:38 -0700 (PDT)
Message-ID: <60a2885e.1c69fb81.dbaad.1a01@mx.google.com>
Date:   Mon, 17 May 2021 08:14:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.119-129-g99d6a6936ef9
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 129 runs,
 2 regressions (v5.4.119-129-g99d6a6936ef9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 129 runs, 2 regressions (v5.4.119-129-g99d6a6=
936ef9)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.119-129-g99d6a6936ef9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.119-129-g99d6a6936ef9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99d6a6936ef90567286ea093d46b79a767edc497 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a252ba9ed25d00dcb3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
29-g99d6a6936ef9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
29-g99d6a6936ef9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a252ba9ed25d00dcb3a=
fab
        new failure (last pass: v5.4.119-104-g700d2de76117) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60a25667e6c9ca38e4b3afd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
29-g99d6a6936ef9/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
29-g99d6a6936ef9/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a25667e6c9ca38e4b3a=
fd1
        new failure (last pass: v5.4.119-111-g3e58bdb06633) =

 =20
