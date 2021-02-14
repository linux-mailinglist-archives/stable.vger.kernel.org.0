Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529E231B0AA
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 15:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhBNOI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 09:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhBNOI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 09:08:58 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83241C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 06:08:18 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id a9so155932plh.8
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 06:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6IvClYLi2EXnS9prJe3pMWBylwTbjOGSyKyzaMr8fnQ=;
        b=n1tBDzQWBkLUvMJ+vwqrQ/9o5VoAars4RC1ijswAzgG3PMhm3eOOPhz/yEFQ2db9kH
         vZN0/9BC8RPH2MBXluEv3LBHWNUrnIcJ+m3H60XHFl5YcVNXG0xmUHOSU7op+BBKUlgI
         64SOmi7RI9CNhH3IiFomElYhqppEfSGFKQ2NZslUzDP/uje5ShTg/Vhz1Wyx+RLo5cUh
         FC7LsjAzkr+H2AOtm56IiMulcADIkHOYYD8qBtmfRI1DHrknQV4CedN6/aiH5PG6No4v
         PgFGm0p1kJowc7F6OdLwONY2ligUhXS9qZyuuVZ15lH3eQaGnUtkRpyIi1yyxX+24dws
         TiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6IvClYLi2EXnS9prJe3pMWBylwTbjOGSyKyzaMr8fnQ=;
        b=m5ITHZh4nfIYHc9XOPEqz+gIqYRFykXOxqAKMrBI5AjE/1ekWiQdt4RQr1LbSdlD4K
         YSzrGm+Chh3NO8HOIaPTVnfhZE54J9m1Lbg72naRSHQ/39fyT/cLRwvJWXi+YADLw4bt
         JEO5jcMEupT0ZZsPUsDjvhEOvEZjuq3mS7uJKLz9C9Ew/eG8bWVg6SOPxlLV3kskzDOH
         p7Zx3zsiCJgHz2dZ+7AxEFgMMuHDX+0dg86SxUTbEJwm5vSD/zrt4eSqu8aNPct9kVaV
         xHFCM22rifeM6OCuupGw+YHsCmNsdXLTjlyXQLmjXbmQkbjFuAAbeu41gFLuLq98TP7b
         c+nA==
X-Gm-Message-State: AOAM530G9spZ1Wo6MkNXdUKYY1cL52ZLusJRSfTheTr6UENFU2TS28wQ
        Mc/cDQuf6KSKpFZo1/0/NjTSNQFLrGccRw==
X-Google-Smtp-Source: ABdhPJwsdipY3UYKcwjkqqx7DYOAVdY2DrwZsej3ZQnU5M8418W/AbhAeny/M+UwVbmIJQAvVpOq/Q==
X-Received: by 2002:a17:90b:104a:: with SMTP id gq10mr11064968pjb.112.1613311697627;
        Sun, 14 Feb 2021 06:08:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ms24sm2094487pjb.18.2021.02.14.06.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 06:08:17 -0800 (PST)
Message-ID: <60292ed1.1c69fb81.a2376.3f78@mx.google.com>
Date:   Sun, 14 Feb 2021 06:08:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257-21-gbf5bea27bd35
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 41 runs,
 1 regressions (v4.9.257-21-gbf5bea27bd35)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 41 runs, 1 regressions (v4.9.257-21-gbf5bea=
27bd35)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.257-21-gbf5bea27bd35/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.257-21-gbf5bea27bd35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf5bea27bd35ef48be9e1f611fcaa78d9ddf4b27 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6028fc4509d65474843abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-21-gbf5bea27bd35/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-21-gbf5bea27bd35/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6028fc4509d65474843ab=
e63
        failing since 88 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
