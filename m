Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A168442E52D
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 02:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhJOAWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 20:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhJOAWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 20:22:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7011CC061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 17:20:32 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id 21so5261201plo.13
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 17:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6H92Jzl6QuhOiwTnrHXWAwbb9arAW4FMKE/ThiLI8DY=;
        b=oaES0ox5NpNm+3sHo25RhiOhJfB01HCc8Yc8JfRr+TGuew2nYAxk7Ky2gAwVxor8Do
         udXuhjWhWr7RAI8+DmQJ4CZgWZkxdegRbYvnpQgJppdTnoNHGc91kYfQg7b6IMer/naY
         LxwmL4hqgiC3BdYWucJNHTLkqnpn0dpSQlzdyYximrRZrFjli51hHvU6Q1bpJjrir0Dd
         ejpGnmauYkRTLOmlV3NCBbMCtM4Sg3GcEseYhmnhOTpVJV8Pu6p1e+YPQd3C+wceGQzJ
         SOU4Ex0tLb1AxUVRHUguh17uMqOE/sczXRICFYklcxDxyGrpZqOG8gduH/o2Tu+idDCm
         uBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6H92Jzl6QuhOiwTnrHXWAwbb9arAW4FMKE/ThiLI8DY=;
        b=HLNs0/Yua7mpOC4PD/S3qDUJfrwGSRJW1oJi0ToSbs6oZjRh08KtlEP0ZG9MXURCNT
         3Z7tRfPAc7NXxMNNeiiHfVpHhHygoYCNOHF69i5M2lWSgVM+EtQyrrNLFjTMNtXZCQbl
         xv3h7f+4nx1cOyX2DICX1mCXfffUagTax5YXMZkk+89tztck6XDCWn4CDVIiJJXwUcj8
         YWdNGHmqRT0KyA4q2UzRI/+F4MWtwPotmw7loQadU3rvvPpFMv6LuVI5cmEpQ0w/x1AF
         x+Ja+cKO1yizNWHisJH7j+09XkWa0e7O61lD/d8IOSrKDtxy+bLY9jdB7yQ+ufl/e1d2
         1LRg==
X-Gm-Message-State: AOAM531gvdhy6+iX0SsnbiZrNdR75i8xHQ4/fgKHu7aJ7H17wbCpLCtF
        cbqmCi2a8Ylbj/pIqc9/RLyW2ji08n9hPMe4fZs=
X-Google-Smtp-Source: ABdhPJwY0V7GI6qOx2vK6dSR71xhG7Y0OAQvAUAldZySlqpqZidUCPLPZraUBSImgGnJQInshI82jg==
X-Received: by 2002:a17:903:4049:b0:13d:a58a:e9ce with SMTP id n9-20020a170903404900b0013da58ae9cemr1350799pla.21.1634257231802;
        Thu, 14 Oct 2021 17:20:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d24sm3437710pfn.62.2021.10.14.17.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 17:20:31 -0700 (PDT)
Message-ID: <6168c94f.1c69fb81.df66a.b191@mx.google.com>
Date:   Thu, 14 Oct 2021 17:20:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.12-31-gc19d5ea47e55
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.14.y baseline: 83 runs,
 1 regressions (v5.14.12-31-gc19d5ea47e55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 83 runs, 1 regressions (v5.14.12-31-gc19d5=
ea47e55)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.12-31-gc19d5ea47e55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.12-31-gc19d5ea47e55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c19d5ea47e557f382c94a1b21faf3d9eb9f60b5c =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6168934a94ae7db0283358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
2-31-gc19d5ea47e55/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
2-31-gc19d5ea47e55/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168934a94ae7db028335=
8e9
        new failure (last pass: v5.14.12-31-g6aca54ba7654) =

 =20
