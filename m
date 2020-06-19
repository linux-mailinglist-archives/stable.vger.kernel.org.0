Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637CE201B5C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 21:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389083AbgFSTfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 15:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389057AbgFSTfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 15:35:22 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68C1C06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 12:35:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a45so4700219pje.1
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 12:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7yrmHOrvYTUqrs5U3B1pkN5gwmVXp4feRcs2NDxqEAM=;
        b=p/q6TfHa1fFHvGiNQQM9PWOd+knrUyVNb0vw3QLiZ6+wRgS3ZTkKWZOVFqe9o3WpNx
         u/97vqyxJwNzUqnj8IC6jDAb0LSJAzjRg9Zgb0YWcM6KuyKdFpgBOKAD3h7RTlpF/7s0
         7HHBHQR+wnBgxW1AIGHYa7bLP+8QywISN2xVo3v/tQnHsoW8Taq/pXabUlgWMNjK23ME
         NC5UcedNhv3i82hyMJKkaAAd/iWGJ2gaxmJacN1sDsPbZsQr+DdqrUP3IsTUCB2wEs9e
         frs3QklAdPprRmsgxFzDaBckiIuKxXpLaKmSME/PBe6eYGSD9Y1IQ1g1UmvTbW0ZMVxP
         p6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7yrmHOrvYTUqrs5U3B1pkN5gwmVXp4feRcs2NDxqEAM=;
        b=YV8PEOZ6tLtUCDETztW5XoZp6Z6I+A9eFgdTH/v8tLKcPy58wKKrI4NZDJQtgTmBoJ
         uMDUNNW1VvQbE2RgLc7OMdgg14EeV4yazdapKz0KGJh6xv+rK0JZ11uq8g1Q5Uh0uJ5x
         35IE3iK2jIXsdGaKkhBXP+0uEwQxpc8wwwVX/M2sI4Lyh2/Y5Yh0M9f0WkIts5rpw9sq
         Sc3D1MgZfSAYKM7xRkXr4Y98tnDTUWnm6ALGmsPuJtH3ha+oEAPKcxKddrEY9KpHs2cg
         P2peVE82nlNo6wwgxaBr+K+LKSWzoCNIJFm/n+0nNLa/wa01+NC6+GJzrDEpnfSQgepC
         GgOQ==
X-Gm-Message-State: AOAM531H9FYsmvS6f/UWii+Mknn8yUUUOnFkbptDf8G9jFXblYkwVXK/
        7P3F4zjyy8R3kZRqt9+es+NVWwybgmo=
X-Google-Smtp-Source: ABdhPJw56EXax14pJG/q3t2pdRW67WeG4qjBXj5KH/EePguKkRn3wo4vRv3cmpf/OAnWn6+EttVkJg==
X-Received: by 2002:a17:90b:2042:: with SMTP id ji2mr5148187pjb.68.1592595321729;
        Fri, 19 Jun 2020 12:35:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a19sm6507949pfd.165.2020.06.19.12.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 12:35:20 -0700 (PDT)
Message-ID: <5eed1378.1c69fb81.43f4e.3eb2@mx.google.com>
Date:   Fri, 19 Jun 2020 12:35:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-323-ga00c59b63756
Subject: stable-rc/linux-4.19.y baseline: 81 runs,
 1 regressions (v4.19.126-323-ga00c59b63756)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 81 runs, 1 regressions (v4.19.126-323-ga00=
c59b63756)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.126-323-ga00c59b63756/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.126-323-ga00c59b63756
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a00c59b6375644f707a3554536d03d4ecaf17c05 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5eece19ba93156be8097bf32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-323-ga00c59b63756/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-323-ga00c59b63756/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eece19ba93156be8097b=
f33
      failing since 3 days (last pass: v4.19.126-55-gf6c346f2d42d, first fa=
il: v4.19.126-113-gd694d4388e88) =20
