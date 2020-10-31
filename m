Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6782A1781
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 13:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgJaM7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 08:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgJaM7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 08:59:19 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0ABC0613D5
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 05:59:17 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g12so7250884pgm.8
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 05:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EkAPoCedA2qPkJXh+FENN3i0Fy1Ifs8bDk+nvsTDph0=;
        b=meglJxuCmIZDd3uXNizBXWv4Uj9NSIvvwtPozFVCezaRUSwpeORs947NhF9W8mc7H4
         Pq5f5ng8+vtos1KLL/Hnqiv2AVhNUSgA5Yb2ZYErXYY+Sexx5SZKEHNFil9/qVrXgehc
         /GPsmXMCBMHqUeeAyuFoCS69TyX3vEad0KOijCstpxY/9wQ0po1zOXSZ2jDlMMTDEpX7
         kZoicp+AplxxxqvPqUJ3vEQtk/+LdQLgLG5jjEtXsTD8UBIlAdK+9c/Pr/77iQt2OUf0
         Bn7gWYXcb/UPXS8rQ0eT8/7yLgHPd4lfqscNwznjBnrSt1ImdDzw2Qw3Fw11YgNzOCko
         Uz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EkAPoCedA2qPkJXh+FENN3i0Fy1Ifs8bDk+nvsTDph0=;
        b=t4n1SQyv8oiijP14FEAZ8965lkLQ59sX9R9OY2CH6sXDs/UvBv2eLEhit7M5q7D88H
         Gb7m6jWXhfjCsAwUTdG7g0XzqztYB9qXmJbWV0hDnZK2c5X14m6HJeYm0dzFuruRze1s
         BcVV+4tR5vH7BJTEAH2yliewDJfQb+RbGbRnx/Pjw+feW+EmInduXCacvfmoCK5BV3CK
         U3saEpKuCzYQLka2ncfGwpOnqWDbMH6E/svJAUlMJnuK9pcbb2IYwzIUsbDQMUrc7SxY
         T9zZbRtZji4MlvYhKgsalBPjhBkVuLL3p4ViiiKsqDppffDWqiqDYb1cZex8ku3ZC7hZ
         822w==
X-Gm-Message-State: AOAM533YILp6tgwacuDifv2mgJXlusqn2vIn+dPcsZOsJ1e289gP1x2w
        d4gx7tQHpWGDT3Kp4Ntwr4kzDkD6EEVD1w==
X-Google-Smtp-Source: ABdhPJwQV+6G14/qGIlZfERtVSfagZ8wtW85+p4mup9YGNRGYC8bCwjuIYtSfMGJpnbtqrLmwi4chQ==
X-Received: by 2002:a05:6a00:2cf:b029:160:c0c:a95c with SMTP id b15-20020a056a0002cfb02901600c0ca95cmr13374018pft.76.1604149156791;
        Sat, 31 Oct 2020 05:59:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm8656024pfc.47.2020.10.31.05.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 05:59:16 -0700 (PDT)
Message-ID: <5f9d5fa4.1c69fb81.98f1.528d@mx.google.com>
Date:   Sat, 31 Oct 2020 05:59:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-3-g5f7b19c77be8
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 173 runs,
 1 regressions (v4.14.203-3-g5f7b19c77be8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 173 runs, 1 regressions (v4.14.203-3-g5f7b19=
c77be8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-3-g5f7b19c77be8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-3-g5f7b19c77be8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f7b19c77be8a0db3bcd582ef0b595a6ea6a4782 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9d2ec91e3d1077883fe7d5

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-g5f7b19c77be8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-g5f7b19c77be8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d2ec91e3d107=
7883fe7dc
        failing since 0 day (last pass: v4.14.203-3-gd24321bfc541, first fa=
il: v4.14.203-3-gad7f808825a3)
        2 lines

    2020-10-31 09:30:46.162000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/97
    2020-10-31 09:30:46.171000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
