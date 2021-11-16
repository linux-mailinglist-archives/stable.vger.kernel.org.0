Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEE5453924
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbhKPSHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbhKPSHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 13:07:33 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9600CC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:04:36 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id b68so94493pfg.11
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C4iDp++Q57Jo9mIUlq9CNmeZlQbDcLVc07qD3SmNh+E=;
        b=ovFLAFehDfhtVmmrw866qqCACMJv6hPOFSwson5EieL0glLdAYQW6ublCz0+L+5ZGe
         WSENBtALvXWYWqKtD/VXK3iOiwFN9Sq6PuJoABe8gmfoMrk9L/ZdbmHfvytouPmTqMzs
         W8IBBFcJGzXlDSJqYX0dIBIxth52azholCgJC0npOJTGqZR5FywYcHzgHf+juTioFbeF
         QIARRsfGHhb+jNY9PzayTdSrVm3OlxzbK3hnkRNWR+pK3+0jDyN8YY1CUi3z+r6VH2pn
         DmRJPcqRo9Y4S/+KDYgP91ACqbC2nY3/cmarhIyn9xEsX9Zw0+ChfBcR/QniZYO7nMnH
         G99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C4iDp++Q57Jo9mIUlq9CNmeZlQbDcLVc07qD3SmNh+E=;
        b=7ffX3oPEWWONzW7rQnMzzb56sBcqkVFWlghMf74zsIKdswRFGi2dLwcD4WIf0ycr7c
         kIdLmbrzFoOeRNp/Qx0OAKkYZUri+RSTHpb1P9CcFdeKsvvsNRYGHZV072YpSem6mzth
         j29sJNZJS4aOQniv0bD2cr8TQn20SN3ynrQzF7BPR7vD2P61sQGsxnx+8/CkRPLkRzru
         iDK0AZtXzDT7Vhq/tEaSTBCOt9siQ+W9YHnFRyF2wq24++2+mGFNI/vOQygyZN548DAp
         gkqlU1HIbD6QfhNL7vyY+5tjSs5C1h31I0DQH1IQ5q8Yntpd1OJ1X7QajtbkqaXmROzS
         LQYw==
X-Gm-Message-State: AOAM5313PWvgr/Xvdqbb9SBrOYBcDNawFBoB+jzkv3ryGzq+V/ZemP9D
        IN2b9k6Qp+44B5bU8zm45hpe5n++Lzp4Ts1i
X-Google-Smtp-Source: ABdhPJzIuKOzHz5HnOSRLodL3L44DnCg5eGEfv+jBnVwPzOKzul9LdZZ5LsPjmF0Bq/nb93CxXK/Ag==
X-Received: by 2002:a62:b606:0:b0:47b:e32f:9ca with SMTP id j6-20020a62b606000000b0047be32f09camr41557826pff.57.1637085873962;
        Tue, 16 Nov 2021 10:04:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v14sm18934667pff.199.2021.11.16.10.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 10:04:33 -0800 (PST)
Message-ID: <6193f2b1.1c69fb81.6858c.6f33@mx.google.com>
Date:   Tue, 16 Nov 2021 10:04:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-854-gdcb732e73327
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 133 runs,
 1 regressions (v5.14.18-854-gdcb732e73327)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 133 runs, 1 regressions (v5.14.18-854-gdcb73=
2e73327)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.18-854-gdcb732e73327/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.18-854-gdcb732e73327
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dcb732e733274da1ff7568d0563edd229b26b404 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6193bec642866b8dfc3358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
854-gdcb732e73327/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
854-gdcb732e73327/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193bec742866b8dfc335=
8f4
        failing since 22 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
