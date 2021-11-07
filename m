Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F178447339
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 15:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhKGOPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 09:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbhKGOPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 09:15:43 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F315C061570
        for <stable@vger.kernel.org>; Sun,  7 Nov 2021 06:13:00 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id m14so13541452pfc.9
        for <stable@vger.kernel.org>; Sun, 07 Nov 2021 06:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ej001lKp83ZmemmVoKzyVQKv+LtcpBgRRUmzjoMNK4g=;
        b=JAM38pLNWp1KQr3P0vewkGBfkO8zK2s574T98q9oCR9K3YueOencWm3Hm7AeNG5v9h
         2SVogA0ypYhfLnmReUAGL8mMRILl0LfMVWwsaNbyV9d0MPT98pPZ8RmcVnZ9cGn3xVJc
         h1YWf+dcQzo0osqECjtxr0sXCY7Bxg8WVDTr/gKZ3iX+AAR2v875F28PgI3Wyj3qCwW4
         jdFR0vInskOpM5ZEoN67O9mzCffvc/DG/2cYXbREEa4tL38xRSeaBpQiJHkUdU//3Y3U
         Mqj8DWqi5Mg+r7xPmvkHCdcfiJPZJr8L/P1OM2jWsP/tBar3dL+n/4wiqvN1kELSo0mM
         E1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ej001lKp83ZmemmVoKzyVQKv+LtcpBgRRUmzjoMNK4g=;
        b=FQEOBWEZx77m9Ppj2LA3YUJmNPyOSUddW2Fqp/tXeew1hBDCY0/ZYEOoFuk++9kSEP
         T+UL+0hyTB7r1FWcdCN0fWWYFrl/edI0ZpwQ+W0jIdF/Cm1h5oxwX2Le4zTd4gMmsQLQ
         875tfPQ2psA7HzLfsdgIuWGWQhk3aIa8Vw+soIy0bd7Z5JDxoF3D5tSszEVKe67ZzvPu
         KEjcL/Fi4pE2U0SutqGZ8DlVZFGiJ3ycSp9W+KUqt9XzG/aMWeCPkW1nO3u+CwJEzZEt
         5i6RBVxhnx4s+6G53UOQgQ5f3gMWmjtkVsfqjpa1mQVV6ZbIj0Y5qV60lfwkqXJAAL5U
         1C2g==
X-Gm-Message-State: AOAM5318Kj+RNwWDhVwT7udH8+UAPkgKu1Z7FiDhW1Nq01lE7KBAMNJW
        ynYqGaO/VIcw0v7RN1jEc40PHnHvRZ6jJIOw
X-Google-Smtp-Source: ABdhPJyjaUfHEIjyMXu6i0lC4sXDTqG/NXjH+DVIWUaPaJYG8DTtTp4nxK0F4WcVwAwNUhyRP0liWA==
X-Received: by 2002:a05:6a00:7d7:b0:494:729c:b58f with SMTP id n23-20020a056a0007d700b00494729cb58fmr23130799pfu.33.1636294379907;
        Sun, 07 Nov 2021 06:12:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x21sm12869732pfh.169.2021.11.07.06.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 06:12:59 -0800 (PST)
Message-ID: <6187deeb.1c69fb81.66bcc.6e67@mx.google.com>
Date:   Sun, 07 Nov 2021 06:12:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 147 runs, 1 regressions (v4.14.254)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 147 runs, 1 regressions (v4.14.254)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.254/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.254
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0447aa205abe1c0c016b4f7fa9d7c08d920b5c8e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6181c0acd8ddb89fc33358eb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
54/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
54/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6181c0acd8ddb89=
fc33358ee
        new failure (last pass: v4.14.253-26-g64fad352ab39)
        2 lines

    2021-11-07T10:08:26.972380  [   19.924804] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-07T10:08:27.015551  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-11-07T10:08:27.024898  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
