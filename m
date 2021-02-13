Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D567E31ADB1
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 20:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBMTPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 14:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBMTPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 14:15:01 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D00DC061574
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 11:14:21 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id k13so1675442pfh.13
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 11:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HATTPmh3oHI7aHHgqWAMbex7h+MrT4SMEiVU6VZqPoE=;
        b=awIjE0Aq5ss1aP2U1B+RUzd6a+m0bRiHNOWwXzouwPOFVUyQKscWMRJZBnpMLksUqt
         EGtw3JEoCiLEc1ClfQ62a3PzxajsYmv1nREYseF78ZUmhq/lkS8HaMAwxdZLkmRdgciJ
         s2QSQAcDOYfvBUeHC4w8FTqsWKps+NduPdGus3IWf2w38A2WUO8In3uKABCKv3rGox6g
         k8BZyWGv4cqjfOGdbaD6cSB8eoRurNWBL6XndMqvzYzBVqOqWYFx1nCD/54pd1p25QqM
         V1QiMyqffoRxMtXdtONRFOzxF6aCWJ3w1LFDao0dR0x0+pG3QpE2ZFxg8ouPTpMnniOq
         brag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HATTPmh3oHI7aHHgqWAMbex7h+MrT4SMEiVU6VZqPoE=;
        b=hE3dz6mKtLZk3FGgTnNlnwjc02/fESFoAJUBqHQ6zj1SdV5bkFLgGE5hY3HzxZ9qlP
         eChONINbBy8N5AyNu78A/CCmeGdf4hgTFppFtgyjtSTA41Q/2acxcvUoS6w5HBzNJr06
         4HOlBDQWvEtLtFTJO4zOrZQK1GS5cYH+lxBFrE8GEbXsPLj3wp5y5oGZKaVO9N2kdCNu
         9HUJGDLRbtfHPbaqBZF5TDWXCcr0E99VmAT87aIBG7Cb289I1wHIen6VFGDHzqgRqJ5a
         qvcvjsqBc7x9tx24NGlqEFCKinqlfT9R35S35pp1dDZb6coM6ZsPntBnfc4mDa7EXKtG
         CuTQ==
X-Gm-Message-State: AOAM533/PvpFmNlKV51583s0kuKYHHVepfAVtHzoYfja3uV3OV+T5R8k
        FaW5uluh/daASq7NXeZPe96riIkGvya+PQ==
X-Google-Smtp-Source: ABdhPJy6MZcqobkOibkn50YzE3zkVzH1wtML68dDoukZy2JFxz+JGcQnfi8GXbk7U0dS5lcDfRiK6w==
X-Received: by 2002:aa7:808c:0:b029:1d5:c9d4:d39a with SMTP id v12-20020aa7808c0000b02901d5c9d4d39amr8503350pff.46.1613243660151;
        Sat, 13 Feb 2021 11:14:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3sm11449763pjs.50.2021.02.13.11.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 11:14:19 -0800 (PST)
Message-ID: <6028250b.1c69fb81.f8ec9.9292@mx.google.com>
Date:   Sat, 13 Feb 2021 11:14:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.176
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 75 runs, 1 regressions (v4.19.176)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 75 runs, 1 regressions (v4.19.176)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.176/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.176
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      255b58a2b3af0baa0ee11507390349217b8b73b0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6027f2dc4aacce17d43abe74

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
76/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
76/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6027f2dc4aacce1=
7d43abe7b
        failing since 4 days (last pass: v4.19.174, first fail: v4.19.174-3=
9-g69312fa72410)
        2 lines

    2021-02-13 15:40:07.664000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/107
    2021-02-13 15:40:07.673000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
