Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718A148BC0B
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 01:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347425AbiALAw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 19:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343866AbiALAw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 19:52:56 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1852C06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 16:52:55 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo1809788pjb.2
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 16:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ck+Jj4KnV7l/wl6xMbe2SrMa9QbrXB/0dDi3YM6438o=;
        b=5ESHKLVbFViOC4lRHLpq6S9V2gpoPlU8AxHfwoJn89TJPNCJsoKfCnzIEnYGb73DL7
         zbjXirfjWizMhKD875xGbPPJa4+LtMto+oyO9IWMP5QC2NUP21pnRGwhDJE6dva9+5iW
         movluTl4Ak0geHJxB8NtU3XI146PVzQYjHUrpduIXScKhw9U/aUsE9VHRY9l33jDFstv
         6vPtbKdcheP1QLjM/u6hUMbkVSfJM/G9I7Xh0q0km6wZOFbjqDAXUnHrR5+gJm5MVIlA
         G/QQQTaaaOuJCsR9CKSB3eO1KMLSesgG/RN2vXyemkcXZcNu1kDdm2rTjYCuLU1zlrZW
         ziEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ck+Jj4KnV7l/wl6xMbe2SrMa9QbrXB/0dDi3YM6438o=;
        b=h1WhYfswGjoaSL7PLAvTo4wyKBr4BkRkOj4iwpYyn+WRanNqnh0s/VUCgQVbE5YkQl
         cL4Pde2OrNFrFYfGv1H53mkke9fm+qHGTtV7JbfwortWMepjWoS0mBd94zR84hXlIYiY
         L67K4UgZX/2FmNklnf5GirXEP7pf/92nSG1kndO5+dVvXrzByDQCu67pCC9XnzPnLjgl
         gYRWdnB9K/swn82YMO27ftJuy3fZFEgeoResA7jr8ApikL0kcTESJjwjjZlD2AfRY1+K
         JZbUHgraT4G0DlIbWGZoSESU9CMX+9QtRq2KXO0QLiGlu2VUoHuNuwdvLaMPhZ9lxEMe
         l2hQ==
X-Gm-Message-State: AOAM530gJcglLzkTjcR8Sl83tLrQwpEk06taVzxpQd1MkITTEQUCBxQF
        qTC6yNEgfJdeDf26rzw/OgY4e4zIrNgW1P+A
X-Google-Smtp-Source: ABdhPJy/AP2SwSTpORUXajxcNT4mWwvPuNo+oP+FJ4apQewABS3UYcuPgIyXWunSxyrKbORGgSXSng==
X-Received: by 2002:a63:7f55:: with SMTP id p21mr5317501pgn.338.1641948775154;
        Tue, 11 Jan 2022 16:52:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h26sm11186766pfn.213.2022.01.11.16.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 16:52:54 -0800 (PST)
Message-ID: <61de2666.1c69fb81.3b2ee.d029@mx.google.com>
Date:   Tue, 11 Jan 2022 16:52:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 115 runs, 2 regressions (v4.9.297)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 115 runs, 2 regressions (v4.9.297)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  | 1       =
   =

panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.297/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.297
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d58193689d0deecd834a254892b4df49a723d54 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ddf121d35abb6801ef6765

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ddf121d35abb6801ef6=
766
        new failure (last pass: v4.9.296-22-g166c7a334704) =

 =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ddf260b155c4e407ef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ddf261b155c4e=
407ef6740
        failing since 8 days (last pass: v4.9.295, first fail: v4.9.295-14-=
g584e15b1cb05)
        2 lines

    2022-01-11T21:10:41.193568  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2022-01-11T21:10:41.202939  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
