Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D583327576
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 01:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhCAAG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 19:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhCAAG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 19:06:58 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927AAC06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 16:06:18 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id b21so10397397pgk.7
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 16:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gIsKUUDWtLSvqFhfLbKY9HZ1KyRGaQkmVNlaJMvJ8bU=;
        b=T6fdjYixM8Dl64DEUnBvcmSgXeQh4XYxWyL8BONlN8nb+mSwdQdMw0wTLn9Nh5gfaS
         yTB4M3dP3YeFsGa7eW/TZdnD56mCSvVoogtVCh7PT7fpyQo75am55EynsqxMboETKDeC
         AAl19nflOIcadEstpD5EzCEaaWTStg7fbSptX99rypDWVmYokHBWM0MUh3W8g5ozKacG
         1vNiUNjbw5i3hssSId03DKihbo37d0c4+NbBmjqVKN0i0sOEG404BAbfm+qz5rlnxPC6
         ZRPq08iOlaDMicRbqjgH/SKQ9bTyA2zCzkTCYGTPDbW264FGVEB5JwvUR+bJ+z+JmRA6
         IqJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gIsKUUDWtLSvqFhfLbKY9HZ1KyRGaQkmVNlaJMvJ8bU=;
        b=IY7A/GRBNDHbipyN/y+N+cHyP+NRcDybef5IovpBVYWC09fuLv7etoHtiv7prSdB1U
         hzWlPk08MTokJZtPI8UbuMuBELvMsvFbI07a+kqOMWhrRUznYZokbsAhxNo4tfpvDx/7
         GoKjdc+jUwk2EqCHBM7usUzjCL0k1HXfgu2ifSC+K/Fom0cPusY5PgNsUQi2DqSK+/9Q
         fE51stDpkhVdwq+tsNKhsfXN5lOLupdu21RZL1Ma2IfgSiP6HrWTVZPC6lQq1tDqQn/r
         fW6OtAcgtDuBdolbzR00j/ay+VjrGaLhc8HG6o1h+OCn04CPxQQ2pY6dMJvFdDkCh9Yo
         O5KA==
X-Gm-Message-State: AOAM5322jLIa5x84xW2XsSdDFfoqRbu2pqCvKa6eU2JHlNyE+Y9BcomO
        aJb0+Cct6/LsNnQOdi8T5ivkpII+hpHLYQ==
X-Google-Smtp-Source: ABdhPJwXpF2yoDe3M/4oYxRZYU/4Ted51DH48x4AaDUwlvd2QgvE8qgBiRpkcWAhq3ROFi2cS1Kcww==
X-Received: by 2002:a65:50c8:: with SMTP id s8mr11534748pgp.68.1614557178001;
        Sun, 28 Feb 2021 16:06:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm10701753pfq.167.2021.02.28.16.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 16:06:17 -0800 (PST)
Message-ID: <603c2ff9.1c69fb81.98635.9814@mx.google.com>
Date:   Sun, 28 Feb 2021 16:06:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-13-ga67538ea49977
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 46 runs,
 1 regressions (v4.9.258-13-ga67538ea49977)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 46 runs, 1 regressions (v4.9.258-13-ga67538=
ea49977)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.258-13-ga67538ea49977/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.258-13-ga67538ea49977
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a67538ea49977fb4499d59178b42243a53a6d1e2 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/603bf55b7bc07c8d1caddcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-13-ga67538ea49977/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-13-ga67538ea49977/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bf55b7bc07c8d1cadd=
cbf
        failing since 102 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
