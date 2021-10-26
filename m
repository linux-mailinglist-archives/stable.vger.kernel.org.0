Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3390B43BD32
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 00:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbhJZW3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 18:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhJZW3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 18:29:16 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7372FC061570
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 15:26:52 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so627841pjb.0
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 15:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nshdh8Zkk4wBtAZfWo6bALeU+heFK0wYrlOTkPSl0e0=;
        b=Y0JF+wi45a7ZdMoMg2dnVsdYXqB4Ciw8H1UIpCTiPhs0wLlGZ6axvUBCEjztuGcW+n
         b+7qjyITjZXNhANrGzi1brpR+x4d4FTq/4Fm45Sdrpin4QUu4nNAwbP4GScH0r6RjEwl
         R8xh0bSGSdtVEgfefISM8fDHeRRvptf5BYOwfUSO6uDG3TPX4npwbtyhk9bKrvbl5H5J
         +1G2clGgzCgRM2WNMNSX794CoXo/WtCuvQNK1lvwoZYUXFvO1WNjTrXx7u+W/2V14/RN
         Vxd2KxrnTmnHZbwKuOzFFbvrbzT5CkMTDMpjH15OsBNe4Fm9Ze+DQNKOwpJhtavgmSwh
         H6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nshdh8Zkk4wBtAZfWo6bALeU+heFK0wYrlOTkPSl0e0=;
        b=StoI+aHePdi8IaKKZeszLgT8522n9J5IOeOAC3wk4ZTkncYIDs7wDWnakB4gabxfzQ
         dTUUOUsBPUGkBE14iDpniDYaTPWDrQ6jzNMS644H/KUPSIlesikYJtUOIBK15wEsC+Vm
         7CKlVt0qY2wOcgVaQPNQ93CXxqg+vhZZcIGqiDgZ0/zARXOag5+gvI6gdGOU0qzkLEOe
         UVBwkOmfzw81pWKfIVsk85aEPPJomDXaT4NwpYwPFshkbEfYvaeseJwnf4w/72kxd/i1
         bFB5gkYPl2a7mdehS9v3zfzX398hVgdVfjVtu9nxO86Y5Dxw/ph/h6XEI3l5uysPx5v+
         OCvw==
X-Gm-Message-State: AOAM530IQCbibNZiTOD64ZAQRDiy7pOZbnK/GyEciEBSQJAXwmUydkWL
        JRcoORLK2uhT3D4LF+sKXzHgZfe/0F9i1RYh
X-Google-Smtp-Source: ABdhPJx9jnS94VbAQ1rcj0oRS11A0iSuODneKVw3VCdE4hscpiSSMIBx+ROxF9HRkKtXu9kqU3YQiQ==
X-Received: by 2002:a17:90b:2514:: with SMTP id ns20mr1711903pjb.210.1635287211708;
        Tue, 26 Oct 2021 15:26:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p16sm27230082pfh.97.2021.10.26.15.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 15:26:51 -0700 (PDT)
Message-ID: <617880ab.1c69fb81.627f3.59b0@mx.google.com>
Date:   Tue, 26 Oct 2021 15:26:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-168-g0a80e96e759b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 140 runs,
 1 regressions (v5.14.14-168-g0a80e96e759b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 140 runs, 1 regressions (v5.14.14-168-g0a80e=
96e759b)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.14-168-g0a80e96e759b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.14-168-g0a80e96e759b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a80e96e759b96303788627aa5bcbc2443e7c8c7 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61784e43705cd7664133590b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
168-g0a80e96e759b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
168-g0a80e96e759b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61784e43705cd76641335=
90c
        failing since 2 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =20
