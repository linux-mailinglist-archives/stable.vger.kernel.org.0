Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5A53AD48E
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 23:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhFRVtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 17:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFRVtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 17:49:02 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BFFC061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 14:46:52 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id z26so8746666pfj.5
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 14:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qLa/ZXYpin1R5z8WmZpVQuyO3K1vRbMyfM+hEUQ1uW8=;
        b=Oo91FoEBmy7ebtWp6XpHO/gxRe9y4sKZUndBHr0M8VvTLASdf+8kNGzMUWowxZquhv
         84xjJF202PfzfcL/ihbw1bUhLpECfXv87XU8xv56s/vfQAPWDolaFQKQSOvFUYV39V52
         6XEng1HeDJbZiff2EpTuIq2J6+yyovffoepcoxXdumVOcOv+BGf8fpQqkEwD/y857d6F
         qUt/qHZf+K80iwPJUpMe4oo4/9Ngkf+jg8PFJLWwSKFT3g/kicAgNaK0l4tJNA7t1eA5
         r7sIZJN6J/BL5VAn2cuC6QRh7eY7CoEnfzijyfFL63CuSSC1R0Xwbd2wZwSsRjmkHbWT
         Rv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qLa/ZXYpin1R5z8WmZpVQuyO3K1vRbMyfM+hEUQ1uW8=;
        b=ohLxbAQEeKO6XZg7utqPoLOYyPkfL7RVIl7RWAzLZg1pXvkg3y4Q/uHKDl35cBLPVD
         bj+Zg9WREYVmWWTMzwa5XfcvZ4TutAMz7Hh6OkvF5lS4jnLPnniYuvoFFhiVY8ZnLLeq
         ojC/5EM0YWdwbot4YvbQ+MFQSnS+/BoUF+Ko3u7PfQC3ZWrmYCO2+/gez5khBNPyMgTF
         TagukxPkxHb2NG+k261A6wI84QG62q2pemyeZx9Z+snpN/ztZcbUtnM/xvTNfzSiigQN
         nAp9mLljD6tZd4YprMOcOIOvzBxB0SfXOqtdZxEuy6ZuC8s7ZH97wP3HAycDnk6TsX1q
         LZlA==
X-Gm-Message-State: AOAM531xIERveTpHQVv8hruL41sR1eLDKkSSMbgDmRCI0+0ByfVHx1Jd
        5f6KnA5KDGfhtpeAxysnVu2xBP4ea9lxrNal
X-Google-Smtp-Source: ABdhPJx9dAlehsQvxgpSzj28uyJPbZ3aFrpjiPlb/9JCGAeUkKN/rw4HVaPuX6yN4wfQsjvXWzjgxg==
X-Received: by 2002:aa7:8b4f:0:b029:2bd:ea13:c4b4 with SMTP id i15-20020aa78b4f0000b02902bdea13c4b4mr7145675pfd.48.1624052811316;
        Fri, 18 Jun 2021 14:46:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u1sm9955725pgh.80.2021.06.18.14.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 14:46:51 -0700 (PDT)
Message-ID: <60cd144b.1c69fb81.7e950.c090@mx.google.com>
Date:   Fri, 18 Jun 2021 14:46:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.45-9-gd13f3e69eae0
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 140 runs,
 1 regressions (v5.10.45-9-gd13f3e69eae0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 140 runs, 1 regressions (v5.10.45-9-gd13f3e6=
9eae0)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.45-9-gd13f3e69eae0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.45-9-gd13f3e69eae0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d13f3e69eae0779f121f9eb942544bbfff236dbd =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60cce2c522bc94a3f1413299

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
9-gd13f3e69eae0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
9-gd13f3e69eae0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cce2c522bc94a3f1413=
29a
        failing since 1 day (last pass: v5.10.44-38-g409534680574, first fa=
il: v5.10.44-37-g06c9df4e43ff) =

 =20
