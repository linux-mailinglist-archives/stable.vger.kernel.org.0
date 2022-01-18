Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51144493139
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 00:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbiARXLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 18:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238145AbiARXLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 18:11:53 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C45C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 15:11:52 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d1so360520plh.10
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 15:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/jtQgMm7rhF89QazDpwgpEDRo1oqyozVHvkIN11oThE=;
        b=EXLb9tfmm62gcw8L7IDgtJFDu+znTUmaQ2Ou1PKhSY+oxzc+5zDQqtXxBxHsZa10PD
         pMoCfY2Mo/USE3pRi60/BaU0XVUyw+OVLqC6EUuz29w3I147R7HEKHfTJT7Go2Mcq+xI
         EnRnrAlAZhhKqIus/BsyE9UGpHiQ+NMKuwCVRYGksXg/UoE89FF0QNoSBghpoxpcOjRF
         zaX8OQef3c36FOVNn6Yz3gAmbD50nxrQ3djTcyaY7slZG8W8QXKC8gpaaJ5Vofzcg3hr
         zRjdFprmNg7xqf8UbhYho1byV2SEQx5kIlKeNQLJKfKUhaU79DILvDy6wPhoUmleuLlE
         LspQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/jtQgMm7rhF89QazDpwgpEDRo1oqyozVHvkIN11oThE=;
        b=1Ck4P9/oOmxR88IapYR2QpZiLE2t48lZI6NaT7xCeBIgPtHK5wgAawpsVFsmXTeWDO
         XOdFwaPVI8i3xJjvDaRuZ7lvdCWpZAEn2DQVmAK8XPSxcl3zCHVdPdWp3kElWhH9IBj4
         5Odz5oKnc55szvD+nhb2D3xMT+J3gifkCICUMKYYOc6vBJXHNuL7RozDc+8A4T4KyEPG
         Y8tCdgmyF0UYVFrJ7mOvgUHXuy5V/PTLh/WDwTrcAIHA3gWgPEBowWkGRi2xrHpQsMVZ
         aj6t+h5/nEvwBkEzCI6Xz1G5lBIXnaUYLH4hmv3yqWTDOaG3vC4SwaYNBXvl5ZbzB5Oe
         dOCA==
X-Gm-Message-State: AOAM532jfp0dCT6QPXoLZ2P8VWLGr2LIqBdkG0NJI0kTI0Ipwvgt0Rjg
        xmzc0gljAhqQwSLnj+0u8/qTho+RoiGNyiUL
X-Google-Smtp-Source: ABdhPJwTgMPcMWEvZXVAfUtnQHML2qHcbNxXtiokZNFu/bmG+EPoGGP0Ezry12EjqgIT4kMup38sPQ==
X-Received: by 2002:a17:902:7c89:b0:14a:a76f:78d2 with SMTP id y9-20020a1709027c8900b0014aa76f78d2mr16179696pll.166.1642547512249;
        Tue, 18 Jan 2022 15:11:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa14sm3897638pjb.31.2022.01.18.15.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 15:11:52 -0800 (PST)
Message-ID: <61e74938.1c69fb81.d2d3.a929@mx.google.com>
Date:   Tue, 18 Jan 2022 15:11:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16-67-g979dd812ffb5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
Subject: stable-rc/linux-5.16.y baseline: 154 runs,
 1 regressions (v5.16-67-g979dd812ffb5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 154 runs, 1 regressions (v5.16-67-g979dd81=
2ffb5)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16-67-g979dd812ffb5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16-67-g979dd812ffb5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      979dd812ffb543a3f6218868a26a701054ba3b8c =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61e718ca6e8b20ab96abbd25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16-6=
7-g979dd812ffb5/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16-6=
7-g979dd812ffb5/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e718ca6e8b20ab96abb=
d26
        new failure (last pass: v5.16-38-g677615cd2689) =

 =20
