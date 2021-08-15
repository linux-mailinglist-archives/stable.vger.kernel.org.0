Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432F23ECBC8
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 01:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhHOX2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 19:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhHOX2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 19:28:49 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FF5C061764
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 16:28:18 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso24605072pjb.1
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 16:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z5McYaOV8wXzC5xFylrvzWDavERVA6nKlVBHLw0Nzew=;
        b=t5IK+IaMAvzJS4vx4uwqD/Z0xCrh1zM8wY/1E2c0ACPAHrRTQmpmRZq9BSDzQnCiPN
         FLgvQMSXuBzt6MZ4n3Q5AuWngJCjrbICnC19rwvEiTIUeVi7Jy8YroJw5lVh0Awx484a
         CT2dPagi8HbVDWLji0kBe9ckOVMg47WBqisCMLBedypoZ0bmTEWZheCTeLYUAhn8FMmK
         RGTLUnwEdam9CSzGFK1HQum33P9RDeT/ZvsxNvridSWM2WqMXac/Uhy3q1/rP5Ils6g1
         WmCxAuX4XmU+O8AOvQkWG7HEskFXxNuqpu3V1wRcfYRRAPgg9dZPtyCojAJmeWG61Sy1
         lPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z5McYaOV8wXzC5xFylrvzWDavERVA6nKlVBHLw0Nzew=;
        b=bQzZEExVSlskCKgY7fPeDQ3JmC9AB1MdMJC/uwS/AIh1GvZq4s+wBUhIj3QYNsJaNP
         lbGzNlLpmxtY70AFil+6tHs2PGyqJ0GcOs5Ac/Zou29m7bOkJ2A7xQtcUazP4nlckJzi
         k9QlRFFr/JsvVVi775YoalUGbyy1cL1SkJVmrzitx5FOKz9n/HXa6iqz3o76KdOwrcjH
         358vDuFlfo9YglApfTtkWLXBePbUvN3YvUX1BxBe/fpWK90bUi8bupRqCLN6ntDqLkU5
         1glO1fVQv9W791crk6WaDRww3OtmSgAznxyvWQylD6TRp/e/3ZJ0G7oyB68vJqkx2APc
         uhbA==
X-Gm-Message-State: AOAM530ZN5wPpl2f87ClyvRiEbEp+D+PGRqo5xjs8yV2qvUdW22eNi3y
        /CZyXFVNmvlgxOsZ26lQgQjmgeGuPIdDM/A7
X-Google-Smtp-Source: ABdhPJyuepi3l5j1yO/2196gGuNeolTt6V+AzwGmnyI037zonX5C/cgw97oKMACh59RkIIDBkMF+pw==
X-Received: by 2002:a17:90a:8d:: with SMTP id a13mr13641375pja.46.1629070098019;
        Sun, 15 Aug 2021 16:28:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e31sm7662443pjk.19.2021.08.15.16.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 16:28:17 -0700 (PDT)
Message-ID: <6119a311.1c69fb81.a46e5.4997@mx.google.com>
Date:   Sun, 15 Aug 2021 16:28:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.9-296-gfdcb12d6d9d6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 187 runs,
 1 regressions (v5.13.9-296-gfdcb12d6d9d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 187 runs, 1 regressions (v5.13.9-296-gfdcb12=
d6d9d6)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.9-296-gfdcb12d6d9d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.9-296-gfdcb12d6d9d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fdcb12d6d9d6e3ac71b796ae197bcef171cbed1a =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61196e4efb8a12391db13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-2=
96-gfdcb12d6d9d6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-2=
96-gfdcb12d6d9d6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61196e4efb8a12391db13=
664
        failing since 9 days (last pass: v5.13.8-33-gd8a5aa498511, first fa=
il: v5.13.8-35-ge21c26fae3e0) =

 =20
