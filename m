Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960CE3274D7
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 23:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhB1W3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 17:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbhB1W3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 17:29:15 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFD2C061756
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 14:28:35 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 192so3214955pfv.0
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 14:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ayAGTWJlPytwkJEM7WGQkJda5Trxiljmk+mzbvPCnAc=;
        b=JcGXvjJOnzBf3nMhmOYdk2cefP7HRvd8cPx33yVCG0tYYaJJX0QrbL9fnivVOlNTkn
         B+Vkcmj90i4REhXd9lrt8iTJF0W7mIT+iLeXVdCkuBB+wTbtt46ks0wkPAklsKsbYC93
         PsAvoDfdDuAjcZ0/Mgv9dY0xc9DVXvBUukJn9/g4+CdISN5Dvxyd3Li5M+x8K9L/IE+i
         Uf7sg2pw6vTnp8gkZHhSoihEi+c7Ski4oTfIbGLmJgc4LQGScszUCtUsQm3zo3TULMr/
         54W9lgll003ULIUJfPSKcxIJ4KV0RA0ATES4ceAHOoLob0lYkLUkb7gqHa+W7JVPUffo
         2zsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ayAGTWJlPytwkJEM7WGQkJda5Trxiljmk+mzbvPCnAc=;
        b=NdHDw3J+Z92N/akog9gyJ1oN9eyHgqYB/bm3PH7y0JcN0mhilIAMBbmduUhl3TGQBS
         TJq/pEEHyBxwx9ohANmCBgV/5Kr+vvaEPv4WGywM0FyYncPw4OUXnQEwg2Kiaw+2U9US
         Ie6B/iQH/r2evRyEMxfWYsm/dKJEyvm8ZUZ1tDtfSR40sh2A+KqcfULOJpuNjHzCfAkI
         ARKb7+pvMAfo0V7/cy8dV+aUe1gS+Xt0h6b0J9R/wnnhP8c3ppLPhBX/L8tc2BFqOTfX
         NqYvEKi3wtLUkDFv1QlBs9YofioVZ+3eLWRioJybE7oUSnvj+X1+UDXHW2HCbgaxTcVF
         HVRA==
X-Gm-Message-State: AOAM530c1NIK2OoE0W3VJtYTPP7xJ29gKCuFBPNaQNksxb/Yw2T+/ULO
        +VHWI9Q6a6n264NE/zMZ5gQlWB2UlUJLUA==
X-Google-Smtp-Source: ABdhPJxHpVAyI2Lbzj1koaEd9mYFGjOGxWG4BN3WY/8c4miiQUHq6TWmbeRi5FNVeK/i1yeZI4XAgA==
X-Received: by 2002:a63:da03:: with SMTP id c3mr10927918pgh.176.1614551314769;
        Sun, 28 Feb 2021 14:28:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm8149141pjv.49.2021.02.28.14.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:28:34 -0800 (PST)
Message-ID: <603c1912.1c69fb81.4c56c.4006@mx.google.com>
Date:   Sun, 28 Feb 2021 14:28:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-20-g26d442e567cc2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 108 runs,
 1 regressions (v5.10.19-20-g26d442e567cc2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 108 runs, 1 regressions (v5.10.19-20-g26d442=
e567cc2)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.19-20-g26d442e567cc2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.19-20-g26d442e567cc2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      26d442e567cc2de14d4ebd52beb5890d59cf64c3 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603be74faf4724d9d3addcd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
20-g26d442e567cc2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
20-g26d442e567cc2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603be74faf4724d9d3add=
cd8
        failing since 0 day (last pass: v5.10.19-1-gd1c42444d513, first fai=
l: v5.10.19-19-ged89ece04062) =

 =20
