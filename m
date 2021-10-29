Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28874440446
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 22:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhJ2Uq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 16:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbhJ2Uq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 16:46:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F34DC061570
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 13:43:59 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gn3so8003924pjb.0
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 13:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NmTYahDdOAGelK+kmLFaY/nBngEnTpTTrzhv7eDrneI=;
        b=3n6mExHN1yVwK1hXXT5ZWlv4TYO9tkykIY+gZdzJalJrBVEmWGCssRCr1ED78u64PP
         xCletv1Q7y7YQrjYEWnPoX9LJdA1Ce/jco9P9UbYRw9Tz/rVqJ+dhJ8Ib0ux0SgVj/Sn
         XKyVOjl4Qt3NoQXKNFqoV1rHSCxhlxcv2iA/Gyj/L97cej4q7WQ43o9RjtQWcy3zDssk
         mZzzv21dz0J4x+gd5isDzTY8zBhyb7pEMo+t8UuNgLqMcGxEOHvXmkuaHlIIjPbvd3K4
         avHdqDB0oQh3WCuEezAYM6rnr5DQUs6DODxkzB0z8ZeIX1JSHK9f+ZRaRM5Kfjw3DHON
         yGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NmTYahDdOAGelK+kmLFaY/nBngEnTpTTrzhv7eDrneI=;
        b=xMyquR/O1WgfkhzwwSNfO4sHrUExjDqe+ZKVe7HEcJGGC5zDDbK/lrExkESjo7c/xx
         R9Akla+bKkLh7qOUvFxBB/i1lnUzUUB6jGdkVsj1eDQjukxO/Q7IavkagGFGlcT3oHlA
         wlMPWTbVxOEetWGP8Q7cb7ByX4I57zh1991EqYoJJKflwWLNNUM5kS3SOkKpRCody9Ei
         k/F+Olpfv6HsyJjqG1FWQDl+NGQA6BcPHI1WUrnzvv8i8xI2noCksnYQg7vmTnqzwQTx
         b7UptJt3YLbIW0O05gE6t5bKF5SjEyHJ70Grv4aEQjQiaB9R/1J8zD+OBTpzqDroOlys
         JdzQ==
X-Gm-Message-State: AOAM530HNtYQMJa8PNPc+WCd3FKo+Vom+ETb4KB3Y5ejI3ZwR0kdn/W1
        Tpc8nBihPasDwjghsu3UD5mdqFvuDbO2JffP
X-Google-Smtp-Source: ABdhPJyFtbq1jlPvyxUa2AWD31Ujk5Z3zfDYEezL/ncuxzdm4D1Bd4Pijan+ht6UavJoL63jKp8ozA==
X-Received: by 2002:a17:90b:4c02:: with SMTP id na2mr14243651pjb.105.1635540238853;
        Fri, 29 Oct 2021 13:43:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa4sm7127942pjb.13.2021.10.29.13.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 13:43:58 -0700 (PDT)
Message-ID: <617c5d0e.1c69fb81.beb64.52c5@mx.google.com>
Date:   Fri, 29 Oct 2021 13:43:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.15-16-g9d1df96acad4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 166 runs,
 1 regressions (v5.14.15-16-g9d1df96acad4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 166 runs, 1 regressions (v5.14.15-16-g9d1df9=
6acad4)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.15-16-g9d1df96acad4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.15-16-g9d1df96acad4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d1df96acad407bb3b57b9825b464f40b8c926fc =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617c2935c766e072723358fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
16-g9d1df96acad4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
16-g9d1df96acad4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617c2935c766e07272335=
8fc
        failing since 5 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =20
