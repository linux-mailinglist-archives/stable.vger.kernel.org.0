Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEE7418007
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 08:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245608AbhIYGjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 02:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhIYGjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 02:39:46 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C6BC08E8A3
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 23:38:12 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t1so12124900pgv.3
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 23:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TSvYhpDoSuGcxvtMgPril3hpvXRJXdFVTaKXXs2+VkY=;
        b=YFyArPWN2h010BndXU739utSmMInx8WlWNaD1O1kutLk+ThcIEgXdoAjpU2cueG6Zp
         aE12LRlpIJrgYSdan3mkcZTDjd/pVfUoYRpj9IyIX/2w2vlMNZcjMzcgyhc4unRicWBt
         3qxiuxfXgOhWuQrQOHaVv7/up2A0qKDnyv4YGAaI42vt3ZkhrETquYQCcEagqXuqU+Cg
         07YMjZokScrmiSLUi4ZQXFqpc3msbMOY2wSpiXiLI0I4MUxkp6pj/3F/HbWYP50BLK2k
         daDez2w80D871/HU8IEbgyjhhT22dcAFVwq95U8qaF7qXKYk3cZcvTC5Vae7IgR6zrsj
         D/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TSvYhpDoSuGcxvtMgPril3hpvXRJXdFVTaKXXs2+VkY=;
        b=5FYHOVxjEucYnW8tT0ZwAtyAKyHkR7iDnMLGEIAAArEhKkrsBSBYjhvpInTZicbMfK
         KTLBE7vNL7sBDZV7/ztD3/95/6jytroo1Uu7Ufw1rxU5IsXX7vjZ8N1AzsCnM5he5zX9
         wrfv1Ek4EpG8w+nj6afqzw3WPlmo+ACTlxLZ51P/XaL6yPtvI3neDjiz/iKvM95+eow9
         hGFO+uMm3XB8FaVMkVlpZyP0a3EOcBs3ETFO/kG77BHhqbMmCV1aYou2j4ugx9+BcPGM
         gtUgPuT+xwLRw5asLTkk01/rCncVoO7W2sY8nbRaoWNXWouIiEIyzR7JXxu4nyHe4ULi
         HlPg==
X-Gm-Message-State: AOAM531EiUq2qoXppVoUO2tHc33dedsz5kjFYiMzJhaNDH6w77Qo608x
        rWMMUAI627ml8rWIkYI4s2GQ0e3ua2N0tMOr
X-Google-Smtp-Source: ABdhPJzcqjRhMjJ58V9NlTNI7KSY1irJsf2fdyTYsGveKxP4hUibUhVEN4MRTcZQgXrYGva2hXaSnA==
X-Received: by 2002:a63:aa4c:: with SMTP id x12mr7265303pgo.211.1632551891706;
        Fri, 24 Sep 2021 23:38:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u194sm11112700pfc.177.2021.09.24.23.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 23:38:11 -0700 (PDT)
Message-ID: <614ec3d3.1c69fb81.eb8e0.455b@mx.google.com>
Date:   Fri, 24 Sep 2021 23:38:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.7-101-g565376331ac7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 66 runs,
 1 regressions (v5.14.7-101-g565376331ac7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 66 runs, 1 regressions (v5.14.7-101-g56537=
6331ac7)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.7-101-g565376331ac7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.7-101-g565376331ac7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      565376331ac7733d73f664f53e578545694ea328 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614e857b93520782b899a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.7=
-101-g565376331ac7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.7=
-101-g565376331ac7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e857b93520782b899a=
303
        failing since 2 days (last pass: v5.14.6-169-g2f7b80d27451, first f=
ail: v5.14.6-171-gc25893599ebc) =

 =20
