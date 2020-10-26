Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98997299753
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 20:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgJZTsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 15:48:50 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:45588 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728136AbgJZTsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 15:48:50 -0400
Received: by mail-pl1-f175.google.com with SMTP id v22so5222563ply.12
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 12:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8hOgnUKg/ahH2qw/6xu1ybMJEoDh9+XGrg7ba3ellNY=;
        b=SoHB+4yktQowkbwRPM1wBXEBZe3lOqAK2oJTGv1FVE1dv5M86FxGJVIXix0cbw9kKd
         7WMFW9OP1dIn3alJ0u+Wcdl4ZlfQ2ivjjA785hx9t45ukbBtYkVi5FNQ5qb07/SrysQ4
         s/fZueXLCdNJczRkMCN12wVFaayv0Cq/6S6ihQYRTD2i+4q3IC1BXV42ic9icihRiP2Z
         Oub/gJip+9K/CHkT7fr8jxsPGKn9BPa9srMzxKVW2eUAt4xsMAIXb39X9NRLLWgARQub
         H1Rbvg7Da5m3fSr6N6Kd/81n/wsnH0wtume9Eji6/nd894BLslLS1XPOSPd0vq+XMQzi
         aNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8hOgnUKg/ahH2qw/6xu1ybMJEoDh9+XGrg7ba3ellNY=;
        b=F5+Xa0y9e2Gako6+71ISwUMv0QDCD9eOTyGcWHrJDZ4Zd3BiCeuz9A+i80z/ACtuUP
         MX3cAfx75q3rdagSsD6awrVVanFBcz7CFYHdXa3qfmsokjo2uj+9mrUEWESnMgtV68/H
         GDIrJHT2an0pmjpKYXamv11Y/V9QECw2sLE4VNn7yX5FayRiDazYCcbBrHNJzahUdD52
         sND8q1se/xr+EnLEtyoh1gwRXKltbIJQZ0swgsziOXSV6p2O88A6z9Yfzm1yVXLwuF1W
         VbvJnd84g/JsS1pFW69EtfZ1wK2brfZ0eEfRJfLse33M7XeMj9+vi4R5JaMDhEDI6RWK
         uH7Q==
X-Gm-Message-State: AOAM533sCBBSlRKWFngXZpNCYlH/4fH2nFUcSjbemVegjRCR4BQkrye8
        akd2s9NIOTUKc+AJ9SHtpSQiComxdYlnsA==
X-Google-Smtp-Source: ABdhPJwniVRER7LsI09YqvgM9yAv+fkEYh01FsHXSAwMehpBOiT6CpnzJZk/f4EvMBvFC9GYeUS4OQ==
X-Received: by 2002:a17:90a:de5:: with SMTP id 92mr17924982pjv.179.1603741729494;
        Mon, 26 Oct 2020 12:48:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e2sm13434537pjw.13.2020.10.26.12.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 12:48:48 -0700 (PDT)
Message-ID: <5f972820.1c69fb81.363dd.b736@mx.google.com>
Date:   Mon, 26 Oct 2020 12:48:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-110-g3f6f806e2524
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 110 runs,
 1 regressions (v4.4.240-110-g3f6f806e2524)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 110 runs, 1 regressions (v4.4.240-110-g3f6f80=
6e2524)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-110-g3f6f806e2524/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-110-g3f6f806e2524
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f6f806e2524fb49417edec4fc8ef4abb15e7550 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f96f05ba4315ebb9438104b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g3f6f806e2524/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g3f6f806e2524/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f96f05ba4315eb=
b94381052
        failing since 2 days (last pass: v4.4.240-11-g59c7a4fa128e, first f=
ail: v4.4.240-18-ge29a79b89605)
        2 lines =

 =20
