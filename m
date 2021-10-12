Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1908E42A170
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 11:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbhJLJ5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 05:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhJLJ5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 05:57:47 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C90C061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 02:55:46 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q19so16691053pfl.4
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 02:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=16cv3m+x5jIRdcVlu61EPbc54laQulyW/ryGagqIp9k=;
        b=B40Z3VGMsH2FMhr/eUFIwROZ7+CECqjHpk9l3Es9bySRBCUr5x7kjZgbuYZTPdIcXB
         FFAncDvoq8kEzTBePUEUYAeilJ+G6u3oH3Z5XNz3oq3jGvdDyDuJ8hWykf+gLDWG9Veh
         3sqKkxj0tQS1/Vl4SEmFeGQaxdUsjBcWO1tpE2MZCzZ6TI99P0u76ypH4Vg0slIN/e4y
         cXX37+RXiNhYfWpOTrLw4M0bsuZlL7yRf3jNRxMch9im0Snv4kayaDcvMYLisGMEqJ1q
         Fwc/eqSxnIgQjctcwkikDnTv8cUulpuw2REG85lPiASy6JlMl0GlfK4UB+n5LywwBxIG
         s6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=16cv3m+x5jIRdcVlu61EPbc54laQulyW/ryGagqIp9k=;
        b=CU03/KVrAWBZjEtaPAPHjm7PaIqmHxuxux4B9mB4RN2pWCBNyE4EyRBkPGlyRWwv8R
         BpSldp93CeRyG52dNdqBoRn0xUjPillQ1kS9Knrr9S6RNPR96ZbVmb12GElFi7D+HGNW
         /5nkBfmF9a1FBAyNSypwLdDDlrQkaYgugY5+ibCmDQCWHkCay12t4BMYodvc2GIE7V63
         0Rrm+8U6frU6t4b5MPwor/Gh0x4kaETOZQ75wEeUSrT8D1ZdIDfbftDWSveLiwqrRVRM
         RN+5aXTzN9TFrp2eiusw33qJbVCnPPbRE3pvJZRPnemLAVHR8TlUNlthxlmp8vxwZD7S
         2I+g==
X-Gm-Message-State: AOAM533Of2NXtJJZSgA4cba8PnwcWSUK0wR2S9FeutA04fInE2tFM3hF
        GOu4nG5ezYUlQN+8O2Y8DnK3OmapuDu3kHwV
X-Google-Smtp-Source: ABdhPJxiAVex3DC3Ltru6SA5zSUmAwE240u8Ngu+tmK+qX8YTdFTgCVSoNj4gchl0hzE9vLnlROc/g==
X-Received: by 2002:a62:3287:0:b0:439:bfec:8374 with SMTP id y129-20020a623287000000b00439bfec8374mr30448273pfy.15.1634032545608;
        Tue, 12 Oct 2021 02:55:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2sm1981549pja.51.2021.10.12.02.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 02:55:45 -0700 (PDT)
Message-ID: <61655ba1.1c69fb81.1979a.64ad@mx.google.com>
Date:   Tue, 12 Oct 2021 02:55:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.11-151-gbc5a3fbd8294
Subject: stable-rc/queue/5.14 baseline: 103 runs,
 1 regressions (v5.14.11-151-gbc5a3fbd8294)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 103 runs, 1 regressions (v5.14.11-151-gbc5a3=
fbd8294)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.11-151-gbc5a3fbd8294/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.11-151-gbc5a3fbd8294
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc5a3fbd8294c3ee0bd908f6e35589ec54d70a6f =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61652456c8e78fb3f808fab8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.11-=
151-gbc5a3fbd8294/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.11-=
151-gbc5a3fbd8294/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61652456c8e78fb3f808f=
ab9
        failing since 3 days (last pass: v5.14.10-44-gcee0088c496d, first f=
ail: v5.14.10-48-g292b9f8998a9) =

 =20
