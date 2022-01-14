Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1140748EA78
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 14:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241156AbiANNTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 08:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiANNTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 08:19:42 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96300C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 05:19:41 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so14151001pjp.0
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 05:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jGzrjEEkLDzVMG1nAIGIIuKGoUeagpT4E9C+/IAiY+A=;
        b=U6RTmGdWfP2/FHt7UWCji3yfLTmoKJWoK1sD8np8VmHNw0OBH72dfkHsmTV429wktp
         w2gMa+WJnHaol21429RRCwV1swjrgd7QLoOxK/0ll5y7hPQiICUgc836XDrbAHetnwzl
         rtbb6BJ/WWb/BrRzNSWsmXqqYZS7sos8vsQuENkJsEmF6bElIrpI1wwxilgeWdsXVnbn
         3n549drYXxU8qg7kJAyPCkXOlES8YfdCtG7VP/kML++x1w29/1JdjO9pV3sdYc219G0h
         8btebhP4aW+HS1/nByjcde5wLSTvIoiDwe6yVoJb9Ib8OkdRBQmE7p3Sp9M8lQCDutdX
         saxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jGzrjEEkLDzVMG1nAIGIIuKGoUeagpT4E9C+/IAiY+A=;
        b=dg9pGvcfTFe+Mtovq3Hg25Da5lyeJ2gNC048JUevV8weT+jxk4yrNwdKSh0GTOyH82
         Gt8sTIyaRvL+LB8Gx0g4W2QGqW6AyvORbKuhE2URY+7TE3FeJC7Btdy6D9WAUfOWne+N
         hwxQ+QOxWxe1gvHp5V6ZrkAxlN7teW2Djb3/Mq0S0jV++dgbcVwG8HOcy6Y3CI9o7urI
         XSAaKyqFEjRebDdaNuV+kwP0WIuWDp7qdGKersj4u8KKBPub6J0FexBlL0pYESQpLMwo
         WdMzKrrllxIxqbsUvtfimRaLHCMQRpBzvRH16zss3TCT5RTCLKYNhJYtE216Z6DvIjjN
         nVGA==
X-Gm-Message-State: AOAM530mKcw5L2+q63mHYn2MnlAlTRgZiRT1o4rdT1lilCwB1ARbGcvF
        94NV/4iS0BaHn4fPjIIlP29ZTGG7G18pJY7jbOM=
X-Google-Smtp-Source: ABdhPJwksJxBLH7ztEhsDL+EaQcbREAvtLZVM7OklkXVcL2JRQx5o7/+JO2Coo6ySL2lkJiMKEdXNg==
X-Received: by 2002:a17:90a:5d13:: with SMTP id s19mr20152475pji.117.1642166380784;
        Fri, 14 Jan 2022 05:19:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m17sm6009879pfk.59.2022.01.14.05.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 05:19:40 -0800 (PST)
Message-ID: <61e1786c.1c69fb81.896a6.11e5@mx.google.com>
Date:   Fri, 14 Jan 2022 05:19:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-11-ga6caa5b54a47
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 82 runs,
 1 regressions (v4.9.297-11-ga6caa5b54a47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 82 runs, 1 regressions (v4.9.297-11-ga6caa5=
b54a47)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.297-11-ga6caa5b54a47/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.297-11-ga6caa5b54a47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6caa5b54a47a5902376fdcf24bee15f02af79e1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e145b3cee389c68eef6752

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-11-ga6caa5b54a47/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-11-ga6caa5b54a47/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e145b3cee389c=
68eef6755
        failing since 10 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-01-14T09:42:58.062342  [   20.698608] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T09:42:58.104900  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2022-01-14T09:42:58.114199  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
