Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6022B31D2C2
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 23:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhBPWn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 17:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhBPWn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 17:43:27 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51617C061574
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 14:42:47 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 189so7117485pfy.6
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 14:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JB/Gw4d+ZB8Fy6/4p3TkUfJuv9DiL0Vo4NGFHGsNxdo=;
        b=ie2ydUJAPq5j9m8xoZOYHJEZwKfpD07qTfxJ9KguEW0a0WPC0DjRFBTFnxgiqB2pOO
         Fx2dc02I+8neiaXd6xJY2i9rJEktgmrmBNb7T5qreB/up4NqC9T6kOj3JS1YHG8tRqBg
         xxgcJCsH6LEBbUl7Xiwqq3ToeE48SaWVlPExQP5FxJXMVZTw0znh9owKUBnFkn4xmmLX
         0+yFnvLGTE6kgbXqQyffiVePg1bMdjbdXCUZHiEMfsEa9OnR4n/tLRG6G80H4VGL1e7j
         Ux18o3peUt1BOXU7i80JcskK6BnrdQ6vqRdp667x/grggXhbbqwRUx0rM0Gn/lbldIfz
         lFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JB/Gw4d+ZB8Fy6/4p3TkUfJuv9DiL0Vo4NGFHGsNxdo=;
        b=kx5UnG2Dq5xv0eVYbtlsMF9Kpg+xntxMjEM9XHW07wfY4nZrEZtxq7IGnnDG6Vm9WP
         l7stlNpCkRoReKfUqSnue47JNKo56g018gWxwFVGzhPT0OE9vvBCq3gWHapVsBnrG4g8
         Q0HtYReAsY7+dm5+lPqYnBLza262SJH7lsbpP0UTDppabdMCoPnAePrKlHjj5qliBpHS
         LsaQ8+URIlEwhiFVOcHiKXID0/2D613IfOhxAcfG9WHzWUZVYUsi72oKNvKdOUv2OgPe
         e0b1eX4olNgwFLfMaBDrQv1bwcy79XECihu6xUDB65rVjG8R/5Svhq7NPJuYx4I7yRb8
         s4oQ==
X-Gm-Message-State: AOAM532xSmt7sk9Ru3FVomFWi6bVhBGS6m40WFQoSNfo+eZsMquUQff7
        ogUwr9WQg1xYGtIlZB8t3MbBkKGm8PxSsg==
X-Google-Smtp-Source: ABdhPJyBcxZSxawVhktj+EMaSmi8dSuaHJRWfjpmyAb5VYOJCiflgRQddkdLom2nHBkGvE5sGEdc9g==
X-Received: by 2002:aa7:961b:0:b029:1db:532c:9030 with SMTP id q27-20020aa7961b0000b02901db532c9030mr22147348pfg.30.1613515366318;
        Tue, 16 Feb 2021 14:42:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cm7sm13308pjb.43.2021.02.16.14.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 14:42:45 -0800 (PST)
Message-ID: <602c4a65.1c69fb81.a530.011c@mx.google.com>
Date:   Tue, 16 Feb 2021 14:42:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.257-24-g7f32e1cdee52
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 34 runs,
 1 regressions (v4.4.257-24-g7f32e1cdee52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 34 runs, 1 regressions (v4.4.257-24-g7f32e1cd=
ee52)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.257-24-g7f32e1cdee52/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.257-24-g7f32e1cdee52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f32e1cdee52c5db46b3b814b1d05f6966db18a8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602c185efd294b17dcaddcd0

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-2=
4-g7f32e1cdee52/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-2=
4-g7f32e1cdee52/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602c185efd294b1=
7dcaddcd5
        new failure (last pass: v4.4.257-20-gefab6e77247e)
        2 lines

    2021-02-16 19:09:13.680000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-16 19:09:13.698000+00:00  [   19.530853] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
