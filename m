Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C7C32E77D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 12:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCEL4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 06:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhCEL4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 06:56:35 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EB0C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 03:56:35 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 192so2034338pfv.0
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 03:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C0+3N1CKEsu583e/9vbFiVh2VMzVAsX+iOkij/TLO6g=;
        b=qoNBxnY96kcUVZL6ya255jzLq+Wz6s+w+ddbiXuFbTpCPRf32LI1H+63tPSou9LTYc
         iwcZxiS+4ONAZRUQGrdIL0Lqw0B9Gyn4ZGrP0PfEfGaAF6Bo6oyelO67EBg8iLR1Zcy1
         Unel0I0u2BD/o1yXonaVNx6qmYowoBG9eSdJvd9ppgoz6gCETpCj0V2AFkMRIiq34+Z9
         9congWHM3rWaGw/UWSNjTvl7i2kxrNiONjogO2TmNAcsXPsZpPoVIjQ5eHgR4ZAoHuhF
         9aypT2SwpGlGnju/HxhsDltG+UPa0e5PqQ1fpQvfJarUKQrGu5b0cMrhx+0GMn0Gp6TJ
         fzTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C0+3N1CKEsu583e/9vbFiVh2VMzVAsX+iOkij/TLO6g=;
        b=m/mIlUY1/0lvBcaDMsR4qDrNG4yrIKhpwRQG3AZbm4OFzUI/aiXEV9DwDJYKg0bTD4
         wQPG7i+joqJkKs1GS8+DJ7hqXbUfX9/HLOcIuYbulNUqno29raJICymb2aMHV+01LMPk
         hcJ4xDwiv10ZygWhc4rHWMDcEw9ht/ZvO9nWAoFKPq1U8IZsAVijnVoCQFlnBiyQinYS
         vVOJE1ZL3GvkD3JETSPWB01mKzaNqV0ADZ1S1NJUqr80S8rDOAKG7tvSPabAL3sPQrfg
         iY6gyGONtxN0F+NpJJd8/Zf8tAKLEI3casBTD8BzqKlZ7yx7KYfr3J5r8hl6NkUhYftV
         paww==
X-Gm-Message-State: AOAM530l7okRSSyOBYaol0PDirKfCsmV2m4RwCA3zBfIHjY/qA5KrIf7
        1cmjtiR+0QN4qDxWW8sZ85vJsV3t+d9Dnm0n
X-Google-Smtp-Source: ABdhPJzdw4AY5rkReJJKMimCvN5w5nEmIzweItGW5LMB9IWUkHgTgCc3W7o93e3sO0MnIIsL/39S3w==
X-Received: by 2002:a63:e902:: with SMTP id i2mr332569pgh.45.1614945394958;
        Fri, 05 Mar 2021 03:56:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h8sm2298329pfv.154.2021.03.05.03.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 03:56:34 -0800 (PST)
Message-ID: <60421c72.1c69fb81.f7ab1.65ea@mx.google.com>
Date:   Fri, 05 Mar 2021 03:56:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-82-gf5d33c41c174a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 182 runs,
 1 regressions (v5.10.20-82-gf5d33c41c174a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 182 runs, 1 regressions (v5.10.20-82-gf5d33c=
41c174a)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.20-82-gf5d33c41c174a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.20-82-gf5d33c41c174a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f5d33c41c174af41082feb34fb696cc00661a26c =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041eb04aee0c2b2f7addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
82-gf5d33c41c174a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
82-gf5d33c41c174a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041eb04aee0c2b2f7add=
cc0
        new failure (last pass: v5.10.20-83-g8502fd1696d1) =

 =20
