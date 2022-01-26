Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9CD49C05D
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 01:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbiAZAzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 19:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbiAZAzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 19:55:55 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C22C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 16:55:55 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so3269105pjj.4
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 16:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xdAPUy6h2vQgIA2DOApOK3hp8QWHgkNRl2njLgciRlA=;
        b=GzS5owf3t1Bq9ngY8pgBrnCLbmY02y7gQNGIpjsZl4JDgkHOD4TppndXiZnezhlrCX
         TToZCg5CHfJ/bBvU37/gWk6hBDYqywcBeLvDdv2PxAYOQBE3TiLZsr73tkvpRrUo3jUv
         gcc+Nr5/BeD6v1I1Zq01zS7/vn4krQswrA6sz2+NkoSgGYkosNiDtMJfd9ONK0g+Jq7E
         OwoIFLCGdccuVgriYvaRuDwFf6uNFxVx9pnhCN3oz2k2OZIiXEJubIMMMtj+K7k9S3Qx
         NoRHlGuraBMSS0RQTNII+QK8zNfh8XnYZYRk5A+40VcQ4ZqZ7Yqf2fzlrf+6aaxvQUoA
         Z5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xdAPUy6h2vQgIA2DOApOK3hp8QWHgkNRl2njLgciRlA=;
        b=3SvEJvkMxCENJ2wcyo9O4qLkk7Srf/ryBBJG+L7QgSpGECzfuj/4DghJJhNWvyCqm3
         O0t8dEx38y7m5n/HXmS/M68S9oYeJ3bCH/gCQmreuPKUX+oUBpqKu8iCQfwVKxr4qqDl
         syYXFkVsLRMoA0XFleYI2F4YXacF3BK5QASGM54lH9c9tk8EuhNhSXO4w7jt+iIu+4BN
         Sm3wKRY4V63MsSEzE9Diqlz8Pzz2A8IPuz8J9DI5v/S9Yc+lEWHT/98Y+qZ6zv6v9L12
         eH3bCRxWNlTLTX8oz7RpNwHBvVJ+k5xcWsXL8dSwpcDLEeaikwU2RfrWoQRs9jjATgK9
         f6qg==
X-Gm-Message-State: AOAM5329+BJswbBNioKYCwtS2mFik509YdolGQz9D5H0IoZx793GaRbX
        KFdk7jGhggmEQQXfC4lEGeTyGFYO9wXs+aYI
X-Google-Smtp-Source: ABdhPJyI1CIsfQ+rgBTqEvdK1dWw77/wE47tv7LtwKkNPiyBR6M0UtLrHI8L/BJT2gCoE9J53DpygA==
X-Received: by 2002:a17:902:8544:b0:14a:bea3:1899 with SMTP id d4-20020a170902854400b0014abea31899mr21163947plo.143.1643158554671;
        Tue, 25 Jan 2022 16:55:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e3sm830788pgc.41.2022.01.25.16.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 16:55:54 -0800 (PST)
Message-ID: <61f09c1a.1c69fb81.e38f8.324a@mx.google.com>
Date:   Tue, 25 Jan 2022 16:55:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-185-g1cb564222633
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 71 runs,
 1 regressions (v4.14.262-185-g1cb564222633)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 71 runs, 1 regressions (v4.14.262-185-g1cb=
564222633)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.262-185-g1cb564222633/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.262-185-g1cb564222633
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cb56422263318b84ec74390135d405f17a73e5c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f060662f413b309dabbd14

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-185-g1cb564222633/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-185-g1cb564222633/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f060662f413b3=
09dabbd1a
        failing since 11 days (last pass: v4.14.262, first fail: v4.14.262-=
9-gcd595a3cc321)
        2 lines

    2022-01-25T20:40:53.140450  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2022-01-25T20:40:53.147804  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
