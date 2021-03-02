Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172E832AECB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbhCCAGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347806AbhCBGAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 01:00:13 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F886C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 21:59:25 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p5so11396997plo.4
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 21:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/t4sk5qgGDT+y4AdQFOuOQdLtio3MVaLzsscW6rv/j4=;
        b=dxwjzS5sbDO/L6X+pTw5qzigODsBNzc/pG2yoTxYzvunLWU8tlgzgV5SUd0idlvGS9
         Ri3TXX6wF/lL773ddD9+7OmWSJvHZwvxiZgdSlewxYKvPEkt9/d/KCC0vAoBuHCgtdEZ
         9et2SCBbng17lhLTF8sPL/IyMKerzKWUkZzQUCv+N4s0U/7FFRErOGiR3P9acJlGQiRX
         lHhVzlqXdI0GBwc8Mya7ypDGujMfzCZ5M5IOurcl5OA9ZWFym77FcN1uERPyfi5z8o7x
         TLNyO0sLX94B34F3FiQy2udRbv3UohCAvIjQOyuZiT1Xdgw9GRRet6jZ+QpWiU1vCt7v
         Jipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/t4sk5qgGDT+y4AdQFOuOQdLtio3MVaLzsscW6rv/j4=;
        b=VtoiYef2hXEOwcSuXoqwhGc7iQ0SDf/iSbK+6VyF66Gq9aOaU7eVsfeFpQpbUd97wT
         xzBbNCcIQsfz5T89uEj6Kac4bFJRHnlzgN32l4e7BPm2jzlpIiDaeKlkAUx/byfdM6iz
         opVjZ49Sv3Y+7QX+7e6c7OAfiqFUpg7CDHy4+0NIC79VA2DkExB3kD/5tb5QAyidLBWB
         3mbFqcd4cK0xm5lVyLeAD/lgtbVewvYDyuEMLyPCCt4JHQ+m/w5mCggyQihWaKzab9K0
         m1YWWOB9cS3TMh/e1OSRWaYy1WsPZw3nLwQ0yEmWn5sRSDKgZdia+HU1ema2ZxUQueV/
         1kgQ==
X-Gm-Message-State: AOAM531Q51AtnfXfreUfK5ZsS5BQJtuJFU7GgCHEk/zaKafXGdvQlWbr
        VniFuSpLFniaHleQZIvWsssLUPUxq5MiYg==
X-Google-Smtp-Source: ABdhPJwlboEEfwuFJCs9t1Ld3ClvySEtUehhu7fTgnhEQm5E7tmEeoQRknTXdqefZswESknjFtzMpg==
X-Received: by 2002:a17:90a:c20a:: with SMTP id e10mr2526733pjt.221.1614664765088;
        Mon, 01 Mar 2021 21:59:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cv3sm1597973pjb.9.2021.03.01.21.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 21:59:24 -0800 (PST)
Message-ID: <603dd43c.1c69fb81.e4224.483f@mx.google.com>
Date:   Mon, 01 Mar 2021 21:59:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-135-g5d97ed0c85ad7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 66 runs,
 1 regressions (v4.9.258-135-g5d97ed0c85ad7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 66 runs, 1 regressions (v4.9.258-135-g5d97e=
d0c85ad7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.258-135-g5d97ed0c85ad7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.258-135-g5d97ed0c85ad7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d97ed0c85ad7f9cb87101e10de6dee9c51672dc =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/603d9c2c5a2fb872f7addcc1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-135-g5d97ed0c85ad7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-135-g5d97ed0c85ad7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603d9c2c5a2fb87=
2f7addcc6
        new failure (last pass: v4.9.258-13-ga67538ea49977)
        2 lines

    2021-03-02 01:59:46.419000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/119
    2021-03-02 01:59:46.428000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
