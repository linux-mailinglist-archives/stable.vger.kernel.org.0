Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16EA46D4B9
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 14:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhLHNvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 08:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhLHNvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 08:51:06 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149EAC061746
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 05:47:35 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so4363864pjc.4
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 05:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7TyQJj82qAvzDwGZyeiykx3xK8rO/Q/NLQTqOsQKoQk=;
        b=kYIqYMymtmm1ehB3WEWbZxBHfF3J74k613AdixqhgNZQwVGn9K8cF22EQBA/VAArQb
         wfg0JxzG22XzrKxwDU55ohVTZ7r8ArKfhuxOsLOnhNmuiUMedN6w97uf9D0JR0uKHdyZ
         Bd9/8UvMiNiWPFDvCmkZnLWazHr8Iz4eCdV0+562Lv3uvRwWN1EPKmyLtbCMEsqloBDX
         O63WtwIudNFYPq64BG/aQHvArGOleAG0YlVZErgVHCKZS7RPnxqxAcUECIT+Bb6LUHie
         4kNU+VAEp19LOENqArpEmha8UJAlEP9QohRztoCNM5fh4OhQUESvv/QjbEyklf3PTS/3
         AUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7TyQJj82qAvzDwGZyeiykx3xK8rO/Q/NLQTqOsQKoQk=;
        b=q852aSeqtWkuCQYPzjo6vs9fV0rr2dNVfYAqh5GGjeXffdh3fVXeqK7qip4L0FvOGP
         7+PH78nTRf4w4Mia7XciwP3A/FfzIcEhI5b168pShVbLBqebfSqJdKkoEQle+zSg/jR7
         JnXluQ7zsra78M0x3A5MJIhg/pLAeosArp15hjzz8VHNcrq8WjVzuT5wU6Q+vj+Yxd7D
         R0YQ1Rnw5zNNAYgwBqicQj3v8rVS1I5FC3sNmFdIItJT/0Kl0AZzsrLTvrRUcgFhf15d
         m3csE7/2bi0obDsfJNaHyFZ/76B9cF3Oejd/da2PZlkemJlrMbG1fdoG8LcASYDM6QLD
         sLTQ==
X-Gm-Message-State: AOAM530wYntBx/iuaJlpkaFwvu+whqBgB1nTlrNYic9g3bmoxyScGp8L
        j1oS77543WK9pOVNCPgSJv3jZd9LEKuTlLCx
X-Google-Smtp-Source: ABdhPJxAZIyWdQepFZ5tr6xzee1o1iwl1ZmICkM94cfUdNF+FbmJGgDycZyOcc/I7TiiRYGqvbQvmQ==
X-Received: by 2002:a17:90b:4c0d:: with SMTP id na13mr7111666pjb.206.1638971254537;
        Wed, 08 Dec 2021 05:47:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id hg4sm6162452pjb.1.2021.12.08.05.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 05:47:34 -0800 (PST)
Message-ID: <61b0b776.1c69fb81.e8bf3.1e9d@mx.google.com>
Date:   Wed, 08 Dec 2021 05:47:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-48-g71a810a2459e
Subject: stable-rc/queue/4.19 baseline: 117 runs,
 1 regressions (v4.19.219-48-g71a810a2459e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 117 runs, 1 regressions (v4.19.219-48-g71a81=
0a2459e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-48-g71a810a2459e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-48-g71a810a2459e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71a810a2459ea6ded97611b5a5be5c68ef930c92 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b080e7746e6a95b31a9482

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-48-g71a810a2459e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-48-g71a810a2459e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b080e7746e6a9=
5b31a9485
        failing since 0 day (last pass: v4.19.219-48-g6cc188def9f7, first f=
ail: v4.19.219-48-g68edce585def)
        2 lines

    2021-12-08T09:54:34.271314  <8>[   21.691101] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-08T09:54:34.316885  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-12-08T09:54:34.327043  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
