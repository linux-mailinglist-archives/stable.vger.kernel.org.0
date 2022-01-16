Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BEB48FEF8
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 22:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiAPVFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 16:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiAPVFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 16:05:52 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A11C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 13:05:51 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u11so13198592plh.13
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 13:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zkhc7Mm+kHoQScg1AlhSJ/e+Trs4WLxuBPXTQE/DLTU=;
        b=fmcrot+8qyFWt5JXBS77tW7utdkzOB+QcosZJZrZjn2zp3WlA19s5ZuGUbSaeOpjoK
         gOKtdFZOxUpFnQzUYVMHxHBtN4w1nP7zgqa9cC9KMIaWr8SOpVYXOS4OzLLQOyitVCRm
         BE7wPQFdj6mL2O+4lv7Vl6uTN0cQMlaZHiTRLm2TNfAXa1tXSRz+Be7Y27NpgKog99lJ
         Xsyt28FxLJzumNMc6oEJglBrlQQqFA4dDqQAaNnWgPmvzowQ0PLcRfH7pVjOwR3qb8qS
         gsz3OOJSMbOsyWIj3QYRedm/y1txTzjPzM/4t7+ad4yrjb4BQqpxuAZfSeiU3muObjwC
         0jMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zkhc7Mm+kHoQScg1AlhSJ/e+Trs4WLxuBPXTQE/DLTU=;
        b=YF6VP9Pc7Zjii04QXnGXCz0E5ACtcdiy/PfgdZUhG9W/RbEpCXUBqrSb3ZSTLNacqC
         c6luaL2dxt3TOdQweXRKuNGK62yQVPqCvwHZghyYGxsxhjuzOSziMs/gWWhncQGSpPWn
         VdmLrCSC85bhASrLi7Y1Q5G+XznWzVwABi1ngQmzrKz7RmI8NXdhWQHf8BJMQWCYMNeR
         bQJbR+M6GKKc+sOcnuWDYttvyazW1fJ+f9+aUraMHYA0frRro19x2w8LShyCXKE9c2Q9
         b5ShPF+seu2bRUBo4ralcs3EIBhikPdg7TMzOQh9uoUMgf7bA6kgAfQi4+iZ+dgbzayz
         tTVg==
X-Gm-Message-State: AOAM531plrYz5UQ5DY2j7L+R2poDZ6m9HMGx7KHZJlLJL2jjXyMW/Iqx
        FQdMoecXF91Y7mq0W7oihJiRDNj1QAIjj/Bn
X-Google-Smtp-Source: ABdhPJzAwGK5IdBiYRE5d6CPzBe3MMYNgotD0MuMkCGI7TSXOY2pLtpTmEVGdqmXmyT+84NOyJa/IQ==
X-Received: by 2002:a17:90a:8808:: with SMTP id s8mr30965822pjn.9.1642367150787;
        Sun, 16 Jan 2022 13:05:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 24sm9683311pgv.60.2022.01.16.13.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 13:05:50 -0800 (PST)
Message-ID: <61e488ae.1c69fb81.d0f39.a8ef@mx.google.com>
Date:   Sun, 16 Jan 2022 13:05:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.91-27-gf01179c14c07
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 179 runs,
 1 regressions (v5.10.91-27-gf01179c14c07)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 179 runs, 1 regressions (v5.10.91-27-gf01179=
c14c07)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.91-27-gf01179c14c07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.91-27-gf01179c14c07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f01179c14c0717f1fc4d3ef0dd96d45bc8130567 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e45555021891c8d9ef674e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
27-gf01179c14c07/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
27-gf01179c14c07/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e45555021891c8d9ef6=
74f
        new failure (last pass: v5.10.91-25-g3eccd3159d8f) =

 =20
