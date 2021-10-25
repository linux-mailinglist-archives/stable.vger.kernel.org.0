Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78030439E8B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhJYSeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 14:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhJYSeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 14:34:05 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5C9C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 11:31:42 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id k26so11550306pfi.5
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 11:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YeRWz/aOUbyqe3/uy80WfguqR8yHn0tRDg1YCFvICCQ=;
        b=Pg2AtUUd9yCwsZLBatxUQrEEJhSSUrGusF4xX1foWCPL/Z63R1MDDk3BrFXFDoJH3G
         fuOVNTZUF8jdQ3FEmeBv89EvQuJJL8NemIU1eYAtTcWX4lhWGs8FkO2vevrU0TvdXOqM
         djy9GBM4M+9FGGtCBn40ZNBuWQ1VZpXahw6b/QpkHSznjrgVki/j5wOYM9hwBNuhnT38
         iMCppZjZ596QepH4RvFZZ68yo4ZWQcRID4QK8b+KTAdpIP1LqIWnWVRA+W9Aqrkxv+eD
         dVkT76P+Tf9I6bert436c0QgM4yqMtVLzO1j/Czg7CxT9+iJy900GIaNnNhEGK78LUd5
         pNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YeRWz/aOUbyqe3/uy80WfguqR8yHn0tRDg1YCFvICCQ=;
        b=Gw8ZIGGV6LBLUvywDlKr1ILoib8N2W+8UJ752upwNuA3nJQgdoZpsfqfmnXMKFCMB5
         fgmpXYYzdlP7EJU+MWffseZeOCYHR8271jKrfVAXbFsF9N2iYq+nDm8sa7knemBJTJUj
         JJMzDjsVShbXojPmf4iLaqeitakNIWwrAdFkT2IBNfnMVvjumXpUlM73+PVy6VW2BVzg
         jvYhXwOOEKfvDRXIHD4hZ8AHOoiOPdN7qYRoiNs/yiY6HDPn95UUqJpeD89b2KQHK9mU
         WNhfKcMV4AyR8i168tdxwIVu7UdsqZiWnbVcgM0fPlrVlQgKLfnuomylxnRJYDuuVwdt
         ajJA==
X-Gm-Message-State: AOAM530Nq75bOajmfSXtxxEmYvn8ZAZjKIhCNfkHcHCIkElSb4ocEV8G
        HQ1ZZRe72ICvjDdTOf79k4xruCq4nyrPm+4b
X-Google-Smtp-Source: ABdhPJw25QaP2BvZY3Bn5Hrt76/eUmyqlOBJSn2gaXHMYnFsYc1Z2D1CDK+KaUv96vEvoW9PZfc96A==
X-Received: by 2002:a63:7:: with SMTP id 7mr15089386pga.127.1635186702214;
        Mon, 25 Oct 2021 11:31:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9sm6465066pfv.158.2021.10.25.11.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 11:31:41 -0700 (PDT)
Message-ID: <6176f80d.1c69fb81.d7aa5.087c@mx.google.com>
Date:   Mon, 25 Oct 2021 11:31:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-163-gcb95282425cc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 149 runs,
 1 regressions (v5.14.14-163-gcb95282425cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 149 runs, 1 regressions (v5.14.14-163-gcb952=
82425cc)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.14-163-gcb95282425cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.14-163-gcb95282425cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb95282425ccb549d6fb14ee1017aeaa9cce4f48 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6176c61c8d832573eb3358f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
163-gcb95282425cc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
163-gcb95282425cc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6176c61c8d832573eb335=
8f2
        failing since 1 day (last pass: v5.14.14-64-gb66eb77f69e4, first fa=
il: v5.14.14-124-g710e5bbf51e3) =

 =20
