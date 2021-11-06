Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D036B44709E
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 22:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhKFVPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 17:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbhKFVPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 17:15:51 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B9DC061570
        for <stable@vger.kernel.org>; Sat,  6 Nov 2021 14:13:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gn3so5356418pjb.0
        for <stable@vger.kernel.org>; Sat, 06 Nov 2021 14:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KIxZvEz3a9WUnQccEgZ6kaag4LP1yC1xxgsNGL4ri+o=;
        b=F5NLA6mMyaCryAG3F+23oqaha3BqGZYPsCLpKBJty7spQADtOCHGNFAPqgWnGHR+TO
         OQ8ne0RuWsD3jIiNIn+tPK3L+GuuGHGPoZA3PiPkE0IePgqSycvNjhRWPMxepxb4KHpG
         NqeMJkVQF69tnim31dt37XH7rBWEn5dCjwpjUR7cP77LaeJ1UBHaUpXhL8SkYRR4I3KM
         GiLHXlSzHMiXaxSKPpYhD7B7A9QePTbvbLTgb28pn94EAf8UIGLzy/DHAg7RQRsXqOGr
         o+FQJaRcuUqiiQ8Ivl9dih1xmnNUB+liUbW+5Zyx+FvuF2VGgSSqwehZmL5+KFkLIbbv
         sTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KIxZvEz3a9WUnQccEgZ6kaag4LP1yC1xxgsNGL4ri+o=;
        b=M7kd7KFXBOUiJeKV8U1LCE8Uuc6WLYsTrh2uytbHBNDU1njCKoCCrHKFhiyjAcf0rK
         72RkEOmkTsjsp2VCYvNOszBrDcHXVZjtbbEMIkAsjPlVU65g/Jna0EE1TuKKIGXXrYiy
         stvg3zQ2gbIFJmLA0uy8rUfnBmqrtONpoBleCtzl6HZu5NPOH3OBKKmoe/61CfAC80c9
         6BbQokbLWJfRk+VvNAWe4/nM4fWnIEvn31nLvEzJNo4zQ3esCj2el/ZPuzBtzou7Fa0I
         NSR1G1pEY95o2YEM+qv4BhgN1Butbvaw0tqEP74quseXGekbW0AA83BNzvN+wsdOgr7c
         D8ew==
X-Gm-Message-State: AOAM532OAw5b8cboNcK/01ccwEwePmSKX4X/KdlS5cPj/Bruj/JVHUpV
        l4BwGE35RS8nQySc06v+2QynfZm6JhFkOS4h
X-Google-Smtp-Source: ABdhPJw7uY8CQlLbfMJI34zlaV0BRlYKT3TfGPMIoFKQnCijxMDwvPBsdKhdRU2XPUPOmTvv7qvtFg==
X-Received: by 2002:a17:903:1111:b0:13f:d1d7:fb67 with SMTP id n17-20020a170903111100b0013fd1d7fb67mr59211867plh.85.1636233189620;
        Sat, 06 Nov 2021 14:13:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d24sm10684364pfn.62.2021.11.06.14.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 14:13:09 -0700 (PDT)
Message-ID: <6186efe5.1c69fb81.65a0c.2604@mx.google.com>
Date:   Sat, 06 Nov 2021 14:13:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16-16-ga123603c0195
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 176 runs,
 1 regressions (v5.14.16-16-ga123603c0195)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 176 runs, 1 regressions (v5.14.16-16-ga12360=
3c0195)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.16-16-ga123603c0195/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.16-16-ga123603c0195
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a123603c0195a08ae1a68f63b2cf23e9ee2532d9 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6186bb9e3fb24a2b473358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
16-ga123603c0195/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
16-ga123603c0195/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6186bb9e3fb24a2b47335=
8e2
        failing since 13 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
