Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C2323F51F
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 01:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgHGXL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 19:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgHGXL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 19:11:56 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B17CC061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 16:11:56 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id g19so1923509plq.0
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 16:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E+DMSS6bxYanbDs6j85lhEzzi3WlaocbqTmp4ISXv8U=;
        b=qiQ0mUZvUssIDYVZb3/rJ9awigpp8WuoihtPtlChr6p5dbb5FskIW9CAq6ShzIE8Rg
         xepuknU66hQPRh0CR/pC78glNdS0abEntF0RBHy/713m43NBZ+5xBPqzuZ53J6zSeJAb
         qgwIdPPIl6jkVRq4VZAYLxf6I4M/4N7KMu3EF8K+YVKS1CsUp06fHJmQbfVmGM1yASFk
         GpZhtcO4/1c+oLoYcFuLgHxtTVSoGf/UPFIBzeaGdldy3eg519qukLjYL4pcN51Hp6P5
         8lu72I+BBW/p276ZX98Xt5Noi5kpTbvOEcj+rfF5rjHsnBVl7cvdrIwx7lNgHFTNZr37
         aahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E+DMSS6bxYanbDs6j85lhEzzi3WlaocbqTmp4ISXv8U=;
        b=uL8CH4sAYIFNMw+iXvae40dCPEMEx6NeMcIENf5GT26jBtmwP1SZe/Fpt23hnbLv+2
         /K/VUzA0mCUFhAtBP0j1bch4/GqyM/RrK/t3B3gYP3YdN3M+tKaK4BBm3H42VD7K8bWG
         hfUO4uwO9qPRxcrvlXWPniOGEvbQjnMc7OFTQL6pxxw2dtDWsSTcGcNWzE3gg29PhN0b
         m9t3v75BxnRkn5gx9dvw3P2+kmrcQaeYyyoD0IeHUO7TVzbpW6vN9k1OxctSQgiI2Nq0
         dxs/D9oCH2U+0ChBZz+w64XRPWGzTf8YP167ybw4xxVftn0FC5XUHrzJPVV+u0TipIOS
         2B0Q==
X-Gm-Message-State: AOAM532c34avj68jkwniEpKK2LGyi6SCL3y9T9ylhjwGTi8K1ICckzB1
        eGC0upB+kOjb60AfUYcxE134es3OKRs=
X-Google-Smtp-Source: ABdhPJwmDZEGJk05bFYVq7dldofuAD3LqGOC0f665zimWDknMVuEIfvUA8WQ1JMeoiXoBbpadFr7sQ==
X-Received: by 2002:a17:90a:bb81:: with SMTP id v1mr14935588pjr.168.1596841915237;
        Fri, 07 Aug 2020 16:11:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4sm12404791pfo.163.2020.08.07.16.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 16:11:54 -0700 (PDT)
Message-ID: <5f2ddfba.1c69fb81.b7c16.e214@mx.google.com>
Date:   Fri, 07 Aug 2020 16:11:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.57
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 131 runs, 2 regressions (v5.4.57)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 131 runs, 2 regressions (v5.4.57)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | results
----------------------+------+--------------+----------+-------------------=
-+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 0/1    =

omap3-beagle-xm       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.57/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.57
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9939285fc818425ae92bd99f8c97b6b9ef3bb88 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | results
----------------------+------+--------------+----------+-------------------=
-+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2da754fd71c5858352c1c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.57/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.57/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2da754fd71c5858352c=
1c7
      failing since 118 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9) =



platform              | arch | lab          | compiler | defconfig         =
 | results
----------------------+------+--------------+----------+-------------------=
-+--------
omap3-beagle-xm       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2da9803336ddfa4552c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.57/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.57/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2da9803336ddfa4552c=
1a7
      failing since 1 day (last pass: v5.4.55-87-g47b594b8993f, first fail:=
 v5.4.55-97-g1c4819817cd8) =20
