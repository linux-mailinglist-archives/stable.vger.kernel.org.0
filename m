Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04D63F0F6B
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 02:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbhHSA00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 20:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbhHSA0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 20:26:20 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2904AC0613CF
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 17:25:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c4so2894375plh.7
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 17:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jgy6XEsas4XuaC0Rbez/yP5mkBGfBcokfuvp1Kmg2bo=;
        b=rWcIPGN3DjWNVZ1vNEyv7AonmI70i7UW7mPLlgl9bSnEiOwEXkDXMsSYhywOx5L4F9
         YjamK/I6fN8MNbtY7s6mUCL+tuwaRfdC06oIQRRKZF7eL1XELxhdmrDIw26Bn171UT/D
         Z/ZrvdA8OyaoyiSWXVvRG0mnSRIUVIJyQoofgjxYluDITh+pzismsZYh57/LpshYBukg
         lrI8m5dSWLq0Ad2n+8KGpOzWQ5zNwg22fZ7wMlSYbIBAqShchDoIDMkEC828k+xRP8CK
         ScXJiVDcknw33Wk/vxxhkd8QMXKEY12Gv80xbjji664NoayOKxT9lC9kgRxnj8ZpQFUy
         n0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jgy6XEsas4XuaC0Rbez/yP5mkBGfBcokfuvp1Kmg2bo=;
        b=CNERWA4NuJOC0r/OwX2qyQEmpq1IjmsvVvSJYkXfT3OQ72m1XLOzGtG4QfPOjjLUaK
         WLSFd+lg50P8eEpcy50PjLwedBhzLr7Ob+L5QXH5+JQRYEKf6YPnSAuDZNkLYteHV/IB
         dUeeuNZt8aTWQMsp6ssRa+Zx95DXSqzZF0T5OrY6ku0sGvi8l5Lwi8WJ1wDKtm1OwnAB
         iDbXTmrHRykdeRzjDGcE6j+8Z/2cIfEpAgBteaU6XdbVXoqb0D41ZFWEr9UscOAXca3f
         pFsMhRPKRVyVz5i1S8xDc/pAxmzVsQfUrTozYgYqT2VQWNSPzjy27TJ42xNjofcqUESb
         eRxw==
X-Gm-Message-State: AOAM530+bO7hxKzUSv/4A3KJkQ4Tmn9hXLUmplADuLFQigDCmQbdalBj
        6RDhGPtGhqDgE3EGKI1K73UKzEqkwll1ZbEj
X-Google-Smtp-Source: ABdhPJwszM8Z+AvNbg8N6qikKccOR5JHf9qiZfotDxitsuAuTTH5JJOKsmXU1CY8l0hQLSgCQEg/ww==
X-Received: by 2002:a17:90a:6303:: with SMTP id e3mr12161289pjj.190.1629332744413;
        Wed, 18 Aug 2021 17:25:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o10sm1025108pgp.68.2021.08.18.17.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 17:25:44 -0700 (PDT)
Message-ID: <611da508.1c69fb81.f491e.50d6@mx.google.com>
Date:   Wed, 18 Aug 2021 17:25:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.13.12
X-Kernelci-Report-Type: test
Subject: stable/linux-5.13.y baseline: 106 runs, 1 regressions (v5.13.12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 106 runs, 1 regressions (v5.13.12)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.12/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/611d6e9746b993a75cb13678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.12/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.12/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d6e9746b993a75cb13=
679
        new failure (last pass: v5.13.7) =

 =20
