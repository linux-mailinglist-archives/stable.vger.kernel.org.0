Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B762E339675
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 19:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhCLS2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 13:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbhCLS2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 13:28:07 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F17C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 10:28:07 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id x7so2423481pfi.7
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 10:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EBDaMdilSLnsjmaOMaBnK/tcubuGVfbuxO1u8JVxaOE=;
        b=jFEcCAtuMLai9VdECshKVX4EDhcdIri1DvBhMM409DbdSa5kwdDNxD+0w9Pxz1ETJq
         ft+3GzsFUcOjdh+0F7HnSrQjl/tLJeUk0JPXcMl7vg607ZdXBP1LHUxfj76/GNgvdD9l
         dwe31tS5E/EX9Nf+uDH8Wg7fMo+CzvMpyp8bixOKJXoNOE8ydML9FaoeiCQSLgdAgcMJ
         VGtx14eB6DnZ79a2KAwc+1lyU8W9OzQ+Iyzg3rt1epSZ6PQzv9dhkCTNr9hnY4QpJBre
         AU7Rr7fy8DqiFdfikduc4ensNdDzAj99QludVCkOWxolxuyUL0RFqxd8e2sHDuK7QMqa
         WkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EBDaMdilSLnsjmaOMaBnK/tcubuGVfbuxO1u8JVxaOE=;
        b=ff+6Y4eqzG53cb9jitMainW4p6XsxD6x7U8fIvP/8RLR4iVgamXezo6DRFqgoj5fx+
         CdM01Wku+0ZfMJKizRkziivmI3Uy+jVPkEv7s5RvO3thFaFW3LUomC4IjEOH2zz0/yDK
         QyyQMZu0PgfZHRGP6mkZD+rIYLunszmk/0wwYo5wTDdy85h2hLOkrrrzLanMMCaq30IV
         ALymW6eif38Pv6JalR789GE/onaXGhEqbkFsUOKT6pZIK+SQBXpu2KT8iWhsGmoDAn7N
         uXKJe68FOR73rWqrZZVYslWHq4b6sp3e5gALVlV9ZCyetVwGb3JjzlALu+LfxVSV5zSC
         CozA==
X-Gm-Message-State: AOAM533AlZYRr2f9HAzVFsDhgsOU3n1gKuGtDc+tJsQ4NqOBOHHAJGht
        Fu/kIdCMK2s98i+IJcJanmEOmceop9JhRw==
X-Google-Smtp-Source: ABdhPJz/r/IX9R/BaYUVgxEdddnc6GGXsf4f2Sm35iWWnZNFz1mBZMRqwpXPYNSZ/ZTVJDRDj5+lkA==
X-Received: by 2002:aa7:81cd:0:b029:1ee:db83:c852 with SMTP id c13-20020aa781cd0000b02901eedb83c852mr13677899pfn.49.1615573686601;
        Fri, 12 Mar 2021 10:28:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 15sm5997147pfx.167.2021.03.12.10.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 10:28:06 -0800 (PST)
Message-ID: <604bb2b6.1c69fb81.2293f.f9da@mx.google.com>
Date:   Fri, 12 Mar 2021 10:28:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-109-ge725551e82d7d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 100 runs,
 1 regressions (v5.10.23-109-ge725551e82d7d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 100 runs, 1 regressions (v5.10.23-109-ge72=
5551e82d7d)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.23-109-ge725551e82d7d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.23-109-ge725551e82d7d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e725551e82d7dce92673b0bef6430fc8e903fb72 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b8281ae6a2c2de2addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
3-109-ge725551e82d7d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
3-109-ge725551e82d7d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b8281ae6a2c2de2add=
cbf
        new failure (last pass: v5.10.23-38-g281dd5c7c4f97) =

 =20
