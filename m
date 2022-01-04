Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8087D484738
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 18:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbiADRvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 12:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbiADRvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 12:51:04 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5883EC061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 09:51:04 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 8so33330470pgc.10
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 09:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ia9ZmRi/BefmkvpS4DcgBZJrrO8BW3qy05dI6U2R32Q=;
        b=GgTurskPmDxSHJvi57Ogm3kGZekCFUzn2Xw4cpoj5uIcrJJXmRsoVlQ9NzKf4dS6zk
         2h/OJis7snMuXm/xZrK1NGfuY6MhGJxUKjDivp80a/g9Ccre/H1at7sGbr6N7/4+Yam4
         MENX6AdlvrBvEzHriIWiro85lK6KzhkRHgGUHQDQRQsSYO/hTaHieWSkpmrjS1KMEoDO
         oZnlDRvLliCROq/AsNQ+OooHAsZ0voIB/U6Gbh8vFJ/1A0zZlC2DjQ+qIqDyHisSbd1e
         pTCXxKHA2PsK52c7qnbVRKMh/twl71TfLwjYz4xG5pAsPJf2DsrF5bgCgmnK6pYIme3Y
         eeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ia9ZmRi/BefmkvpS4DcgBZJrrO8BW3qy05dI6U2R32Q=;
        b=a3UbjPoRLoNPNRnbc8axvGuSSHXSbeoszHt07gasOZe5fuWyOI/US5O5LjdZM1wRtj
         3JysWzySVnWiXEo3Bm8oJXh8d4jMKoeCa+EyUrvDn9+MI8HfXV/uMd2S3iESIHcD9Lct
         SxSKNIb9yoRl4slpC9R/dK6V0M+HOY+SDMhKN2Mq33br+Xfiracz2mBc/0JL4O33my0T
         /H+Ed0r3+lMc2vBxGupyScYbXVjVXnWmfE7LYmpD+o383WsEdcOkTK0wQkkysQ5Sdt/n
         Pir9FFhFULfwh/MMw4i9VKYXVf5Qvzm30JDxH1Lr6QhV4Vf6MjkijlRh7H4E03M//GkX
         h39A==
X-Gm-Message-State: AOAM531FFM+pDukjPmIS/8qZREqLFgzFmzB1jF6r6bQ9uRgMpCeCbf1V
        zUbHY1CABl9dbnGEHr8W+RhY+dL3HKcVHxzE
X-Google-Smtp-Source: ABdhPJy13GjOWhpOOPyNuwoJ/GvG58SgFHkBDjb86uGsEPe5qqjaQep49mV09BvOJIKE2ETePv3NyQ==
X-Received: by 2002:a63:af07:: with SMTP id w7mr19251163pge.209.1641318663687;
        Tue, 04 Jan 2022 09:51:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19sm41727351pfh.30.2022.01.04.09.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 09:51:03 -0800 (PST)
Message-ID: <61d48907.1c69fb81.d7fea.fa14@mx.google.com>
Date:   Tue, 04 Jan 2022 09:51:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.12-73-g2e05ea9d1c9a
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 118 runs,
 2 regressions (v5.15.12-73-g2e05ea9d1c9a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 118 runs, 2 regressions (v5.15.12-73-g2e05=
ea9d1c9a)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
meson-gxbb-p200     | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.12-73-g2e05ea9d1c9a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.12-73-g2e05ea9d1c9a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e05ea9d1c9a321bc00be4d8bd8ebbd58e5421e4 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
meson-gxbb-p200     | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d457512fe8a33c14ef6762

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
2-73-g2e05ea9d1c9a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
2-73-g2e05ea9d1c9a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d457512fe8a33c14ef6=
763
        new failure (last pass: v5.15.12-74-gfbfd9867da50) =

 =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d456698f2c5af1d7ef674e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
2-73-g2e05ea9d1c9a/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
2-73-g2e05ea9d1c9a/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d456698f2c5af1d7ef6=
74f
        new failure (last pass: v5.15.12-74-gfbfd9867da50) =

 =20
