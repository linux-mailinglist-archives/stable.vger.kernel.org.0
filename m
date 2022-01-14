Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E58848E6CA
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiANIrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237173AbiANIrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:47:21 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAA5C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 00:47:21 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo13528806pjb.2
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 00:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=41jGen8GVr8o6/6n+srry8PpaDEKXzzan5lUvnG5A2E=;
        b=1svRA5yUQW9BBtW6PJcivrUSIGuZA0yBOoIAEy8sNRx/MuSx/A1zyWXTJRsd7pteLC
         ihfjg8M5Vz5gbX+QlNlzNLfyi2tUE2CYa6TyqiyiGx19H1qudaNAJ1ulwIss5F0yhzjC
         UzjPqRpOc+Ni2SfmpMsjyu5cdIOp13nNrUhJ2/og/xyCNoC35ZOpa12Qh0XH6xTtD3Uf
         mQet3yLjslybaQ70pm7oIOCporRvZbObmeto//UspHNifbdGYcwEEmI6NpM+gR8gWNKJ
         1kwduzfztbX7RyWfogBjsbwIkmdMLqI+BkclXbipR2T63scnKjoUe2zMbxtVoD/Q/C+X
         rbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=41jGen8GVr8o6/6n+srry8PpaDEKXzzan5lUvnG5A2E=;
        b=n7O/eUJ57YKRTdzuXJG9Tl2qNJu/L0vpONmc5Dx1BzXWOIgGZOwZsN+RNauug3RiVY
         tky5oFnB+pO9Xn8knCosAnvC2Kj4xWlXuZ9tzqDIiLPu+r0Gt/+TOOJn6Ffm+kS+gFnY
         Sa95MOhnPZdDhQo256nbSfzC0jIiG3yDtCWl9+iSttBp8UQYN52QCVK4T5EXepLHFAXX
         8HLG8e/MS2oZL9wCr5lclopzEpxzokEbO/EeHo5l8CnNMhmcv+b36ttj4zK4qSnCrF5Z
         pEpE9n6CmPUzf63A3Le0EwQMd+MPo64hO7fyTwnPBbietQFZ+UIGVss8SB4tThBE2+4n
         is+A==
X-Gm-Message-State: AOAM532MCKmF3E4WDTC9dHNV9D3IbrE92nTDKZdT1ctAfAJ8ZdvDy79r
        FcuhgCU1Zhj/QM2+JZQ9CXZgn5te6J3Ck2kun3A=
X-Google-Smtp-Source: ABdhPJynwp0HgWn0dD7OCc0Que0Hbt8wAR03m17dcCL2fuiRpGZGvfcA9420lwsI099myDez4ix3bA==
X-Received: by 2002:a17:90b:4f4d:: with SMTP id pj13mr14053867pjb.30.1642150040755;
        Fri, 14 Jan 2022 00:47:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p15sm4936459pfh.86.2022.01.14.00.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 00:47:20 -0800 (PST)
Message-ID: <61e13898.1c69fb81.b769f.e2b4@mx.google.com>
Date:   Fri, 14 Jan 2022 00:47:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.14-39-gc9df4d832e20
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 154 runs,
 1 regressions (v5.15.14-39-gc9df4d832e20)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 154 runs, 1 regressions (v5.15.14-39-gc9df=
4d832e20)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.14-39-gc9df4d832e20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.14-39-gc9df4d832e20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9df4d832e2087ba1ddcdb5c8ea4857d1a89588f =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61e1045de2fe79f67eef674c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
4-39-gc9df4d832e20/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
4-39-gc9df4d832e20/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e1045de2fe79f67eef6=
74d
        new failure (last pass: v5.15.13-73-ge8d40b0a7738) =

 =20
