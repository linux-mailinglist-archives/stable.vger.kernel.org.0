Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD546ACF4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 23:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343795AbhLFWtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 17:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343791AbhLFWtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 17:49:45 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C43C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 14:46:15 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gt5so8858800pjb.1
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 14:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VAPROEvDTuEue41ZyLRXAr8lkPZvrIaw01pIjEaLCw4=;
        b=DNswFvj4mX6vV3z2lha/ypQBwre12Wau4NTRY1rjbmFG9WEpvunuIDjXEnat8z0WaD
         AcD+aUzBPB7TOmT7nWLAKARWCG2fUK/n1qz7gkrFDLiyWCoEFBSPJfUBKRkl2NR54E9h
         5a8KybKoy3A0qTvnOamqzT6NICF72e5t6gigDKUnAmxxRoHNFA9V+5vGjc68p22YaOvr
         iGYLsBA5MamQGv8vefYW4gUKXBPjAT94Fz7Mpu6lJarLx2n98HJujl/3LQlv1WSg7W3a
         O/iI/tgcQGYc7d9r86htCk/jmviGmg9qptP7XNiQP0ZQgjE1srs6+XrmhuCvJtscTahw
         ATDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VAPROEvDTuEue41ZyLRXAr8lkPZvrIaw01pIjEaLCw4=;
        b=gA9s7FJosihWRjsxdHHrnr+6XfnZqbGiH/e80l8FcjpUDbKr5KX441S19sNK59tNB+
         nX5WYp5Vgu2Qz0ohO4tbUiKGMvZyUQXpKmQMZt/fWIbI6OIg8wwl9DqmKMHCi7kkH5xl
         PYoLtw4UkO0xkUsNv1nwvw7s5aNFkK/i/rex+56b8hWWpVaO6pcAgYWI8D4dPuHmpEGT
         x6XN6SeMokm76lgII1KF+swFxzmdzS5h6IfX1+wkiRrbzvGuh27hfKE3dv8ayyKf6vQV
         q+8m0m5jQpUuyxeB6nUk7Hx7NysdtxqKEv4+QDslNXc+0AjqA6qPkfVNzKanNdc/WB8k
         qB+w==
X-Gm-Message-State: AOAM530Qfak5YrXQJahdxAFI0I3NTwQc1rzvvrYniP8YlXlvJiPBRXI/
        oOrlHcYBE79BjcJQi0RjgcPxtxRfnQw1WpCa
X-Google-Smtp-Source: ABdhPJz31YEx0btY9x73o3X3heSzNXkTGZ59hTkqaMI7q5XFwAY1EVNC9Lzrf8d2GpGAbgkn1WMtxg==
X-Received: by 2002:a17:903:4043:b0:142:4f21:6976 with SMTP id n3-20020a170903404300b001424f216976mr47118895pla.62.1638830774821;
        Mon, 06 Dec 2021 14:46:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e29sm10502542pge.17.2021.12.06.14.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 14:46:14 -0800 (PST)
Message-ID: <61ae92b6.1c69fb81.f9e9.e4ec@mx.google.com>
Date:   Mon, 06 Dec 2021 14:46:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.6-208-g47c02c404f4a
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 211 runs,
 1 regressions (v5.15.6-208-g47c02c404f4a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 211 runs, 1 regressions (v5.15.6-208-g47c0=
2c404f4a)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.6-208-g47c02c404f4a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.6-208-g47c02c404f4a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47c02c404f4a01320618263ee704576959e3de43 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61ae57c6bc6a2080931a9485

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
-208-g47c02c404f4a/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
-208-g47c02c404f4a/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ae57c6bc6a2080931a9=
486
        new failure (last pass: v5.15.6-152-g371980b01e8f8) =

 =20
