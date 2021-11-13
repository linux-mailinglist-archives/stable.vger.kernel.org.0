Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ED244F595
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 22:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhKMVxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 16:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbhKMVxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 16:53:13 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF6BC061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 13:50:20 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z6so11509148pfe.7
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 13:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U+kDk2vjB0UA6KzifWH93gu90sOXpyneauibhJFIHI8=;
        b=0txlUahOEDvqk8obOeU+Sjv1TDZn2Mg/DTSmCQS6HkkDw1jMJ7U4mk7RyV+KA/Kkti
         /xr0f+dI6lP4RrNA4Z5q6r3A1mESdsx5Acxa8OohoPJ/2vhKnkRYCpczlzG/hbTiuSWg
         rGa98SfGMMamy40IXYWJC20mRWaDgxh0Aa0bOfdrR4Le7sZDLoeSkRtGdcHdaKUF0Rp2
         d+RJ+19fhKpQNsr180ZyXVb5sXOgdqnL662sVhiBEHUmAh3BUnzpj8UfMRSiakmT50ij
         bToa4Me82oGiA6FoSu+wn/KjxngeteqmF8wIh9oec8RRhzt6xrof47ivV/52b2n+Ve0t
         k8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U+kDk2vjB0UA6KzifWH93gu90sOXpyneauibhJFIHI8=;
        b=f5EoIj0yYmXTJgxZbg/iAhJQPZryAKWrGu0skfNEmgPLTwL/WcdEFPu0S5jio4fWvP
         WNsLaSEzVQMPyiDzJl33wqoCc96SbX0jEQUEwfFqCTCXgenB7u0I+YLuR84TIiEKoy1c
         ak2lMXnEFQjlF7TyZ3s8KvmSo62l2eqIE26W6BIh40EyVqQ649xH9cFQRfCzcoPrCoak
         3dbtFz2vIzPeqatHja3bYUJp1NC7z6IITA86nFgn+IoS/sXyaYZJN4PrVT/jNJbzEfi4
         6Mg1xty+SVd7A4YgvrvX4F8IZzKMg/HQdd3/J87Ta7iQZAC6+3bSG+JIeY9IuAl0MvdB
         NLDQ==
X-Gm-Message-State: AOAM530jFDNHPNAh+DDkp3rAgiGNVvOskzX1VJsRfPXLFaDNemJp3crJ
        xvtB2mY+sB0XNCqJO3OKm1aQjTV/TH7WM2iw
X-Google-Smtp-Source: ABdhPJwagnndMyHdfF+58WNvYhEXPbAXFRKFruC3knGCJSMNuFNBEjzjbFsNXdAjKH0F1EMDTaHpaA==
X-Received: by 2002:a05:6a00:a94:b0:44c:ecb2:6018 with SMTP id b20-20020a056a000a9400b0044cecb26018mr22978520pfl.57.1636840219944;
        Sat, 13 Nov 2021 13:50:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j62sm7928780pgc.62.2021.11.13.13.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 13:50:19 -0800 (PST)
Message-ID: <6190331b.1c69fb81.83762.6b09@mx.google.com>
Date:   Sat, 13 Nov 2021 13:50:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-153-gccfa8ca2aded
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 210 runs,
 1 regressions (v5.14.18-153-gccfa8ca2aded)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 210 runs, 1 regressions (v5.14.18-153-gccfa8=
ca2aded)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.18-153-gccfa8ca2aded/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.18-153-gccfa8ca2aded
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ccfa8ca2aded0d98129cb4a575c334d0752a773c =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618ffe1a5b6f87dc2b335909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
153-gccfa8ca2aded/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
153-gccfa8ca2aded/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618ffe1a5b6f87dc2b335=
90a
        failing since 20 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
