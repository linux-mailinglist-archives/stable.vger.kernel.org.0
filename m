Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C602ABFB2
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbgKIPTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731792AbgKIPS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:18:26 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D118BC0613D3
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 07:18:25 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id q5so5474233pfk.6
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 07:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OE3NpvnKsKu4FBXovUDd+eROvEd3QdbuFWIU1TFZ1xE=;
        b=u3NDoQrylsEZvsV6FY/OdGc4tXYpHo8DUd6Y0yHsHoaKysKKi1NfHAbgUg8iriHhkn
         8RiFNDAHZmg3G90eGEZgvA3FSLlZylyfNUBae2jC5Wff3WYkMZ6HvuvnLJ4vmyXE1OFf
         Yq6h4KqUM/M3at+3fqJbdDEBuyACwN36U6zvZyG4zU8nY52BJVSU5LYKc1aMR0sGH0cp
         zmFNnW0RH/tF6fxVLeEj1HB/+hfow15Odf5MbJG2qYMAV1SJ1/pV6/jP7WAxrorfaz3c
         x44DagWfIryYiaUVpBtagqmJht/5OdWMgopzO4BaW2k2wk70qukMKcRHuqe504KDUrBR
         Nx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OE3NpvnKsKu4FBXovUDd+eROvEd3QdbuFWIU1TFZ1xE=;
        b=lNbUZNXdxUtd1U3YTjRuuZrGrNRzxyqiSHkJXRgRoM+D/jf33C7mDMY+PVA617CgLm
         JU95jg8nK44H0lsYb4Wntm/1TaJAm0i8b9Muemw4uB38vqPntWkgdbLuUExQang2sEyc
         tMK/7XpWBQH42IkT7C2f2eG/xhYDeRx+dPK7jdeAbAy+YQ/nCf1gMAmXhrXElpspEKlk
         MVg8YNqZxS6YwFtagGY+3hEJYWfX0AVlxRYMi+mbyVeu4cm2//tZ1nYBXWnojJ9DvIHH
         QFarfRABk2anGQK2RqU2GFHDfby0ETW95x4dkgxvJeuBti0dE7sYMPaadPqyWiFXhXbB
         w7NA==
X-Gm-Message-State: AOAM5310nyL0agkyWnvqXOnPkKEUandx2bJsigttmCNe8T9mIMMoa3pq
        hOiwfnK2cwtsB3AfHlbGOnpARKNovs5ePA==
X-Google-Smtp-Source: ABdhPJxAu7ebbQE7owRaJ7X2jLUQZbb7//T28fpQIIlAwJSKsi2eRiku3mIW8kGXLgbHZXrVlJg8hg==
X-Received: by 2002:a62:1b58:0:b029:18a:df98:24fa with SMTP id b85-20020a621b580000b029018adf9824famr14050655pfb.25.1604935104765;
        Mon, 09 Nov 2020 07:18:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8sm906426pfn.181.2020.11.09.07.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 07:18:23 -0800 (PST)
Message-ID: <5fa95dbf.1c69fb81.c9531.1a22@mx.google.com>
Date:   Mon, 09 Nov 2020 07:18:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-117-gd02e86942788
Subject: stable-rc/queue/4.9 baseline: 144 runs,
 1 regressions (v4.9.241-117-gd02e86942788)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 144 runs, 1 regressions (v4.9.241-117-gd02e86=
942788)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-117-gd02e86942788/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-117-gd02e86942788
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d02e869427885729986baf3d961edb087480f6fd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa92cf291343082c7db88a7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
17-gd02e86942788/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
17-gd02e86942788/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa92cf29134308=
2c7db88ac
        failing since 0 day (last pass: v4.9.241-98-gbb5ddb48abfd8, first f=
ail: v4.9.241-101-ge8d0a6534ab3)
        2 lines =

 =20
