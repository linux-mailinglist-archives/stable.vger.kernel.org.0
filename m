Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DF23ECD7E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 06:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhHPELu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 00:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhHPELt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 00:11:49 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1183C061764
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 21:11:18 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso25334752pjy.5
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 21:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WqlQobEH+neS8TBQByk04PlcTCpRfZzl1AsmRrqDKuU=;
        b=jYnoun5N09GjI4oKxxPIIJNhLq2v2Htda4on7I+fVUjQAe1tPc+YGv3I9MP702LnaC
         JzQek/PCyTuxVey31xoTuzfn8IiwnLgmEf5n/b3qDnqY/LYaSWqQCdCtQCvwES8aRimz
         k127NHs8VidRxndkh92Z/OQ9nDswSLCkt5L8Xo+9XPN+fOVCF9ArkNYkg5cG6lwcNh9w
         /ShgVeMl0dSM8fstziiaCIsT2CV8O2GGdxFCDFqM+49kkrbbqXMkDLEPafypDW0cVNsj
         nZKNWn05NxiKqOtHl62V4vnV9WVixSvu1QQiRsd4WSaRkQn7NGkK1MT1pW8DR7ZB1TRM
         5EMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WqlQobEH+neS8TBQByk04PlcTCpRfZzl1AsmRrqDKuU=;
        b=XyX8Gz/Idpa0Gs6mnoLuAG39bWVml7cdmP2WqBHhf2Mqx6sWM39VW5Cl94UMGMQDeU
         /oPwFLEX2eSF/zivGsmsDX8siDvShos/4jqFrUZPaZ1UvMGFSG9nRyP/h/y10Qpy/hOw
         /7bo8vF6qK6Oom+YGKxNAojKSEfqRefjA8lH3sUDOCae/MgLWUCDTjJ5HLWCKK4kpg7P
         UwLK0QRspNdxolZFp1SiYVBc96vwYPokv3Cn+8mGrCugANolRnEZcuWoS+2GeF/HShUV
         C7GHpvs3Cz4N3C4b2NsDyPHUj2JC0TAgolaXrdRHe+FhGJE/CDLqDheeajZ+W0Cfi3CY
         MYCw==
X-Gm-Message-State: AOAM532aCGQQtukFpYubq6eF5Shqad7J0txRbh6KF+Kp/y8+SvDH8ARu
        RVvaw5/+gtB/HpPNHBo7nrq1hzidhF0vpAFS
X-Google-Smtp-Source: ABdhPJz2KnNGeyj2Rqf5TLITj+/McMLebu/ml/b0DKMwmauwPNAwyW0fYM8HTTi2GLg18ywkWfLgRw==
X-Received: by 2002:a17:90b:30d0:: with SMTP id hi16mr15194859pjb.154.1629087078344;
        Sun, 15 Aug 2021 21:11:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm7941315pjq.32.2021.08.15.21.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 21:11:18 -0700 (PDT)
Message-ID: <6119e566.1c69fb81.44949.6906@mx.google.com>
Date:   Sun, 15 Aug 2021 21:11:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.13.11
X-Kernelci-Report-Type: test
Subject: stable/linux-5.13.y baseline: 181 runs, 2 regressions (v5.13.11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 181 runs, 2 regressions (v5.13.11)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
imx6ull-14x14-evk | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =

imx7ulp-evk       | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.11/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a3f1a03f54fc08ca86ad0759a46244a771ce6547 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
imx6ull-14x14-evk | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6119b324ab4967e663b13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.11/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.11/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6119b324ab4967e663b13=
667
        new failure (last pass: v5.13.9) =

 =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
imx7ulp-evk       | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6119b3220c9ca68d3db13789

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.11/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.11/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6119b3220c9ca68d3db13=
78a
        new failure (last pass: v5.13.10) =

 =20
