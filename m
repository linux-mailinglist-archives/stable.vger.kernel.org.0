Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BAE36A9DB
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 01:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhDYXT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 19:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhDYXT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 19:19:27 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCDCC061574
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 16:18:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so454716pjb.4
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 16:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lkA9rv9IXAPGkEZtN1rHGoHThLqVsAApjf8bOzD1QHs=;
        b=Bq9iCgKEvzEoKouVjrwjWIeoMnOjoiLdmsmW2J9y/XAu9mN4tUu6KB77VrqI6qlHDx
         hibGyJWLfufbXRQcCwYhxk2YbQwTpY8grCpXBDWqx2wpipqt8E1q3gNxXC8XaB133cO5
         EPIqUl3LjkX9QjeVFvzgvNa1meYJOeAryOEdj8tfRaTiGQGOo29USygS0hrUWHS5TqI7
         7B7xcEHnyCvpeouAJ541wWvJRq4essEMEekkTm73LRR2LbhGf4CthMKVae+9UXrsgiVI
         UPw88b6gDk89E4Qy1tWUVTu86Ha1pJVIQRn4dnFY83HTwnXtVMIOHMPSkP65hsZY+yhz
         UoIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lkA9rv9IXAPGkEZtN1rHGoHThLqVsAApjf8bOzD1QHs=;
        b=Zvfxse5jSZo0HTTwvRbyTrEvAFrxwsJtDOfGxEzRDNRcyHFTmKMn431zA8EOZQbgXV
         s7IwtRRk5anKdTjLTITSo11yATohNVi+DdzKn+reLjaW4KFv8TiJ4OtXDc7caMEWlwZI
         9sc3Z/TVvzJQ2A5bEaY1GEoBr+7ZWC3lW3By78OJ2Fcqjzq7uzTFRS0GDTumyFCNwHFe
         F/cCNtSOFRYrsAikbk9w1P2BOEFFgtUv1b+7BToP7s7vcN1iWX9i0WQIJNeIjeQegGDc
         kRMZC2Q/rHoudZ7UbR6Ywz//sa+cFXLsnqixpJtwEzNmNengq2VBorlaeSBhHgpkmh09
         mycg==
X-Gm-Message-State: AOAM531LR6giXKIVDFZ9b1NJkVtRes4R1ylXJh4X2cA1WUFGYJhxhTIZ
        2wre7tkY1d4QYn0FkeZuSDvOCb8u8FkJXDUP
X-Google-Smtp-Source: ABdhPJwoiWHgXFWyRok+uGsQrts9YnwB8CefK2Ttemh1i5rCQ6fKTHONq3Zz/Yz6kkh4R3dXl2BP6w==
X-Received: by 2002:a17:902:7fc9:b029:eb:4828:47e8 with SMTP id t9-20020a1709027fc9b02900eb482847e8mr15929106plb.56.1619392726000;
        Sun, 25 Apr 2021 16:18:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z23sm9475582pgj.56.2021.04.25.16.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 16:18:45 -0700 (PDT)
Message-ID: <6085f8d5.1c69fb81.9d40d.cc4f@mx.google.com>
Date:   Sun, 25 Apr 2021 16:18:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.32-12-gd2a706aabb95
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 169 runs,
 1 regressions (v5.10.32-12-gd2a706aabb95)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 169 runs, 1 regressions (v5.10.32-12-gd2a706=
aabb95)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.32-12-gd2a706aabb95/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.32-12-gd2a706aabb95
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d2a706aabb95902ae659828102af158e99f899a8 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6085c39830756337749b77ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
12-gd2a706aabb95/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
12-gd2a706aabb95/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085c39830756337749b7=
7af
        new failure (last pass: v5.10.32-8-g1d9574aacc92d) =

 =20
