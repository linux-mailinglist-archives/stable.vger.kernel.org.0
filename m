Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E613E4039FC
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 14:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbhIHMhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 08:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbhIHMhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 08:37:50 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538B2C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 05:36:43 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id c6so1575371pjv.1
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 05:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eD+9nHdAxLxVzm8ftz+dP8IfcZjMkxEhjctYeJ/Ooo0=;
        b=JKxmD9QFvMnHi7wvr+cFfXji5A7EO+VVXDqPXxnvSdZtGdYfKHAXZhRYtyXWAntWss
         nEEvbC7Y8d1ZGuLKKc7dd3AM6HnGbY36MG6Rho+aoEdmO6h23GEHazWOQ3m7rOAjcAac
         C5oZMJEP3AM/ZDuQqO2I8+GXeUc0gJqDDqZc+I8pIB3f5ShVvXxBBa9kGJy8iPWiXfAx
         /94jaCHNa5evYd3mbnq4eV9Df/9k/E3EFPQB0Dz19v7hjLzeoTDpYpiZd2+aDNFt3+0c
         C1FSS74rRYGFb2gUYJ2hsb53oK6+BIyzg4NzUFp+VH8tw1ft1LgKxb2MBhkxPJcg0Gsm
         DBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eD+9nHdAxLxVzm8ftz+dP8IfcZjMkxEhjctYeJ/Ooo0=;
        b=LqI8W/POvExUqSx/WFsn93gbl2p200LCy1NGbFpXv8WKlAgw2L3qiM4MasoON20yvz
         lv7PsAtVHFtYvXZVBK4Nr8TW7eYBSN61vLZkniB+9D0ZaeEqOKI6rUqLVp3gRuNbr/QZ
         MfXdN3II0zvl6TGWlBchjQ+LUCtr9WqyFqbeVe7hgACy2c7mafqMGoZibq6c7ojVWLMg
         V/S6CrUifFdicb0ZpfgyR02OYCG2VF+42FVLNGjuMRvZ7yOU3ZTpppRdof9s3nPLkwpm
         POO2xefgLDEwdUoi41ytTrB6FR3qz63FXoYfZ0cm6xRikoOc6ZtStQQEaCWpsRcVbAkM
         M+Tw==
X-Gm-Message-State: AOAM533t+pWp6dT+70Hq7YV7jeND8+XoT7G2pyohIGRa/6ZCTnyIK+N8
        Oxv9fYO25jDl+cx9/xMY9zk9flnyvY4Ph+MN
X-Google-Smtp-Source: ABdhPJwND3Q4lC1e65KkFqmmN7J4Pyu8Dm41MTq1lUONwQFjTTZx9u1dN+dz4nfRJwuSrYfuUbOe/w==
X-Received: by 2002:a17:90a:4812:: with SMTP id a18mr4000505pjh.40.1631104602632;
        Wed, 08 Sep 2021 05:36:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4sm2225834pji.51.2021.09.08.05.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 05:36:42 -0700 (PDT)
Message-ID: <6138ae5a.1c69fb81.fd8a4.5d8f@mx.google.com>
Date:   Wed, 08 Sep 2021 05:36:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.13.y
Subject: stable/linux-5.13.y baseline: 209 runs, 2 regressions (v5.13.15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 209 runs, 2 regressions (v5.13.15)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.15/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b8c3cc76091b35ad6a3d31cfe152870a6467611f =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/613875e8543bceeca8d5967a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.15/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.15/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613875e8543bceeca8d59=
67b
        failing since 38 days (last pass: v5.13.6, first fail: v5.13.7) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61387baefd54b4a66dd59669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.15/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.15/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61387baefd54b4a66dd59=
66a
        failing since 20 days (last pass: v5.13.7, first fail: v5.13.12) =

 =20
