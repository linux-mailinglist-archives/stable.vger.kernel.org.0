Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DDC47A1F6
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 20:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhLSTyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 14:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhLSTyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 14:54:47 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CAEC061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 11:54:47 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so7630580pjp.0
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 11:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/F/AW9TOAcWkC7DbscvYD27WdVm99sIl/MZMAWsmvqk=;
        b=sp9NfopD8s7t30sRXwV76XWmh0q2qM95P/M/2LsRk8YhHPVw2Lb/9roOkKQlVqxcAy
         LuOfQB9y3UpP2kwHT9MBu8hEvfXACMy9ZqPrXQoEL08r632DMc8mozqVfvBRBPFeV8L+
         40dfp6sy6oNukcdzP7CASEUrucnxcL0XxyVRslev1/s++oSME6c9UdXMf8PqZWpX69zt
         3LauySvRnPj80EWYqbzSQpOpW6fgCZ2Tqx269gVDJlxvAy9iXBCSjlE8ZvJPWrnkU6Fe
         4mMi5cvHDZrxb9tT0cGkpHJmvGqTs7iNNP05tciiBGXuQWLYqQ2zLhRWowoN2AuLlIqU
         GV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/F/AW9TOAcWkC7DbscvYD27WdVm99sIl/MZMAWsmvqk=;
        b=1+Z2/wBHiAF7ofPxVCdSh0Mx+cQgI0BvYhWuNG1Gc9J7nChxtm8wZHoMQu6vXtFwVz
         +UsoACmJvA8CrA5lARKvQltUSMO8XMDHn/9rGtHZKRqE88j5nP7+YJAdalQ70jIbVVf0
         /PmW3iAz1nica9VdBe868Wnl8kGvij5KFUgIe1jmKpOUuxXOXqdwJyrc7oo16tuZrFc/
         RorIogN/GoIMBdqSLYOfwqFkB2IhSIrvWCIlQmCmcUzYxOLAMmX7QE1WUQ/7YXGAZ0nE
         78xRTbclJDqNYjHZSkabHYXKAzVjQQRe1TksKHt0e19Pvw/XC5+nB22hJu53bw2UzRzh
         VIBA==
X-Gm-Message-State: AOAM5330LaVv7hmf8ZzwYDtTyHwVS2YMRDE8Bn092FooodkhmXzz7z58
        MW+z0MNkn0kEPOcUVNuQVo+TbA+F7U2wvOaO
X-Google-Smtp-Source: ABdhPJwTQWlAtlcUN/ypVcA0gdl8gJvhs5D7JHGC332V9ES6Q+4ZPnD41+eaNIGOKKNOl/LXKvx0eA==
X-Received: by 2002:a17:90b:234c:: with SMTP id ms12mr16158046pjb.36.1639943685702;
        Sun, 19 Dec 2021 11:54:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6sm12915813pjv.35.2021.12.19.11.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 11:54:45 -0800 (PST)
Message-ID: <61bf8e05.1c69fb81.40c09.53cf@mx.google.com>
Date:   Sun, 19 Dec 2021 11:54:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.10-111-g991fdb79a273
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 158 runs,
 2 regressions (v5.15.10-111-g991fdb79a273)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 158 runs, 2 regressions (v5.15.10-111-g991fd=
b79a273)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.10-111-g991fdb79a273/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.10-111-g991fdb79a273
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      991fdb79a27388fd73f7e2ff10028047c6295803 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf56c0f4944d1f2639711f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
111-g991fdb79a273/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
111-g991fdb79a273/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf56c0f4944d1f26397=
120
        failing since 2 days (last pass: v5.15.8-42-gadd3d697af60, first fa=
il: v5.15.8-42-g0a07fadfda6d) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bf584ff8f149e331397138

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
111-g991fdb79a273/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
111-g991fdb79a273/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf584ff8f149e331397=
139
        new failure (last pass: v5.15.10-112-g7598a4f34463) =

 =20
