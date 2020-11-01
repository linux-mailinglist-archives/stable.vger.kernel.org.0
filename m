Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230AF2A209F
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 18:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgKARrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 12:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgKARrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 12:47:17 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBDBC0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 09:47:17 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id z3so2643639pfz.6
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 09:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tJjOkmzLVVWTCeKt7XWfnopuefddq+gT8SJhLnc54Us=;
        b=AlJsYGxVb4+XM0f7491hvZcGgKEv7i6OVhC8i3fdoe16jWQGc4IuVkiY4hqBp1o1Qg
         etKWhb7qFPJAebcGfQ4EOwuqLiRiA4pYagShy3/EdmOqwY4tReLJ5MeSSvmTNvrPcHRE
         QTXBkFVi3ufRDJ7b8w26ytBkztqwrIG2XUpxPKoss/KEuM1icpyIMO6PPYPzCIr8Sscf
         qJFJB6P9dZXCndhiqQqosXkmeyed6x62CsS6hhx5BUdLQQz132ZbDqZnmAvACboy0tVo
         m2vAcqQ4nPDnlc1X//pQz6WLFyLqq3sMuw+E06qmJp+ImPkFeooQDS265KjPFjV+XzKp
         q1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tJjOkmzLVVWTCeKt7XWfnopuefddq+gT8SJhLnc54Us=;
        b=LC7L0xk2BaVu4P0J/fw9O3q4+sl0Aut+6Wo7FGVeL/J9fo9BKlA3bA3lznLfAc5UFO
         7fQOzkoTIvisUYDimuBFia8HQ54oDG3NSwoY3JUNsbnBc6bF/2p7mtCNGxkwnInE+oAV
         ZvuSAlw6pn0h0ed6GqC+4AGMERUq0Lj/qbO2Geosc7+dVdz/cJ7gNr2pysH1+awto0b9
         wO9PIspCKGdnMBjZrcv9ypjFl56mRJC3ftlvZMHnhYY3xUE9XDLVW87ZsLbL/gbYbkUA
         0L0PjxEWrP8ZT3Hl4ViiXatqcY3POu9EyqUshDGN8iL1BrBqkdsL7J/5UA9ij0AriOX+
         v5Kw==
X-Gm-Message-State: AOAM533i21HXgPjv7xTEin5yUlN8JiW1m74Kmc+xdBKQOYbolu2p6p/L
        k6SHr/UzvsgGO7OhFS5ki903R+DuaqgPJQ==
X-Google-Smtp-Source: ABdhPJxN3fqkXCbEnIs9Ed3P3oCDdYFyk9YrEroc1MfBQtyl2LMqKkTi78SBlgfjtW4pZeQWgafi3Q==
X-Received: by 2002:a63:34c:: with SMTP id 73mr6499182pgd.172.1604252836526;
        Sun, 01 Nov 2020 09:47:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm9597419pjk.20.2020.11.01.09.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 09:47:15 -0800 (PST)
Message-ID: <5f9ef4a3.1c69fb81.b8466.983b@mx.google.com>
Date:   Sun, 01 Nov 2020 09:47:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.17-70-gaad856e7dc92
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 212 runs,
 2 regressions (v5.8.17-70-gaad856e7dc92)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 212 runs, 2 regressions (v5.8.17-70-gaad856e7=
dc92)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =

stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.17-70-gaad856e7dc92/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.17-70-gaad856e7dc92
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aad856e7dc92c341458e47ccc2344a30dde84264 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9eb9817d1dbeabdb3fe7f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-70=
-gaad856e7dc92/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-70=
-gaad856e7dc92/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9eb9817d1dbeabdb3fe=
7f7
        new failure (last pass: v5.8.17-49-g114a0c1f9474) =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9ebde1d469ee51c23fe7d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-70=
-gaad856e7dc92/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-70=
-gaad856e7dc92/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ebde1d469ee51c23fe=
7da
        failing since 6 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
