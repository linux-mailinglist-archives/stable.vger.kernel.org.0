Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2420376FAD
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 07:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhEHFHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 01:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhEHFHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 01:07:51 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85949C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 22:06:50 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so6705484pjv.1
        for <stable@vger.kernel.org>; Fri, 07 May 2021 22:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kn3pDvHSnUhsis/mh35li5+92iJOtSgL5ix62Rc8Oy8=;
        b=vDDxFytyD5/bTZIHo2MkSd8gF57BVPv6gt8PZtqC1mKOLCIFBxxdRuopcgmSlfwJWj
         qPm223DaNqXpMphIaVGK6gK8/iY0Wu43PTOjMX7GPcsj/VUUIUCpltMhfCTFsI4wzI1M
         /BSy2/MrrKodsskB7b+jza4vNu0GY1YX/my+sFGMbzm1UFHEEt/GNe3bAB0bWN77CovZ
         6nv8C8ayPnMgxHz32og9A4/SMn2vQoMbrYRW7lLvvQ8rYS+iOntSlTHSGYHmyl7cVP7X
         8voRGYXhw2xW0f7/JUmzagGMAe0FSF5HQkfYeT5ZjZvimIPnGMhyyOLuNQ75397ugyPK
         cYJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kn3pDvHSnUhsis/mh35li5+92iJOtSgL5ix62Rc8Oy8=;
        b=puJ3FP7iUy+m5TeeVAWNb8Ym8NaaCbdwY1nzu7QtCvVaSwDr7OavS7ymdulNFcP5b3
         AZ/HEKGYnK4dh6Tc+7iv9FzQax4a9b8Z9rEPVXwIRaoK7Pvrv4EoMRVAUQWSH1nBdq/0
         dGLWywKQUhHFKWfGWAKUKqp62ZobDa8vzvu5EwtyqqM7dN1M8Wd9ERjBcJ9ODR+M+wAU
         A5l3yg38l+IQkshoCPdfxhkh3h+2y8+W3Eo52L0/3W1Uz/is6CVYD7CFNITxWBLW8iHy
         g9ks8se5GjbcIJnuLmGkKqrKBhq3KymDJX/5FLODztW3BI7DupAstS7vsc+T9UhDLa6o
         mlUw==
X-Gm-Message-State: AOAM532h7FE4DC1qOT/g1CaYaSCSuUAbivQHm3hFEi5IIeyBAFREk1kd
        itavbmf22f6GvOKSHJBBUay0bqTbE19NHNK8
X-Google-Smtp-Source: ABdhPJzE1PkZIZvqYUAR+GhKS4TvfFCHw/TxpSG82xknOvTwnTS124Hz+lEBfaldSAHVa8Zz1o37Jg==
X-Received: by 2002:a17:90a:7e92:: with SMTP id j18mr14999831pjl.231.1620450409972;
        Fri, 07 May 2021 22:06:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i24sm5879819pfd.35.2021.05.07.22.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 22:06:49 -0700 (PDT)
Message-ID: <60961c69.1c69fb81.c8bfb.2fea@mx.google.com>
Date:   Fri, 07 May 2021 22:06:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-63-g69ff49c3dfd17
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 147 runs,
 1 regressions (v5.11.19-63-g69ff49c3dfd17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 147 runs, 1 regressions (v5.11.19-63-g69ff49=
c3dfd17)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-63-g69ff49c3dfd17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-63-g69ff49c3dfd17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69ff49c3dfd1786a5e56a2d133ea2ae80abe8b12 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095e8dbe59fdf958d6f5480

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
63-g69ff49c3dfd17/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
63-g69ff49c3dfd17/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095e8dbe59fdf958d6f5=
481
        failing since 0 day (last pass: v5.11.18-29-g6c2ae64a2a728, first f=
ail: v5.11.18-30-g4232ce7a02cc) =

 =20
