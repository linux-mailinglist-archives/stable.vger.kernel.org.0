Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C192637EFA0
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242656AbhELXOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444044AbhELWxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 18:53:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FDCC061349
        for <stable@vger.kernel.org>; Wed, 12 May 2021 15:46:19 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h127so19855128pfe.9
        for <stable@vger.kernel.org>; Wed, 12 May 2021 15:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MEPxTzMsrULN0+PJwWELs+wC6YOGbdONfdA2lMLNigE=;
        b=E/MUGeTQSjx4SSP0of6Cmit/1lU0jQlzGpqIqtxYtUccTKohYDmV9jbtkRfq/euCPx
         SWFw+CKX+5VV6bIzP4LDVsnQMnk6FcnzveFIjv68zYrutoU3B9TYojwG1p3v2Hwz/jeK
         yUR2Mh5pZ0tDYF5xOhCnR9aS0Q3DeyLAB6ZIfla96ta+Sb0Re3vPvoDFRzPiMKPCpWNw
         PyBIA6yW8JQFqGRr+Qe15VFv2Q/Vczc0QhoRt1Ht68IJ07GWunsHxGJ2C50V6+Qm9xqD
         3RHkuDS2QE/T6Xn1+XXVBx9V2MFhT5o0GYv6LeTwQiqIcG9jGi6ei+d9cp3MYWcHwJ6w
         papg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MEPxTzMsrULN0+PJwWELs+wC6YOGbdONfdA2lMLNigE=;
        b=ohcQtV5/bxy8vCYwFIUk3Xz167V9SsHIb2140ckvVm/ujIaxUueRQKkSJ+sxSdjbj9
         naW1xqeBQN6C3OkbxgJ4tpHnl79P9b02/vNpk0dvAux0KwEBdM7MykjwixaGMcmVss/8
         PfFb+lgj/vJVTZNj+EBZ7LaK6lJAiq0s9QTuVm4poCsI4IQx0yFnvD2FDU7YO66FEKwq
         Hh+R+qBfBEFqgeq0XkCJHuU8AsrmX0TstreO3a9wRoNCrHeztlFaS2snZR3Np38/j8rq
         lXy66rIqgEjJB7jKSnPNNrlBr2pxI/YRAz01HOFUK3ekBYky6sm81MxMJcP3Zf93HvPr
         tgMA==
X-Gm-Message-State: AOAM533qBY0BcqIuCiIMOGNUjiQVIbriQf0X7tnpGi0F80/IL62CM9cg
        LDUp7JtpvUgOYcj1AMaikKe61+XV8molmVzS
X-Google-Smtp-Source: ABdhPJwYQs+A4QefgQT8+7a0MjwT5X/KYGQwr9IZvWmfDKtKDQ4rctXoFTyMJcFEmpnwpwA2ddKYZA==
X-Received: by 2002:a17:90b:184:: with SMTP id t4mr924879pjs.223.1620859579270;
        Wed, 12 May 2021 15:46:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e9sm631836pfv.87.2021.05.12.15.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 15:46:18 -0700 (PDT)
Message-ID: <609c5aba.1c69fb81.8bb6e.3015@mx.google.com>
Date:   Wed, 12 May 2021 15:46:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.11.19-944-g1ec08480ab87
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.11.y
Subject: stable-rc/linux-5.11.y baseline: 163 runs,
 1 regressions (v5.11.19-944-g1ec08480ab87)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.11.y baseline: 163 runs, 1 regressions (v5.11.19-944-g1ec=
08480ab87)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.11.y/ker=
nel/v5.11.19-944-g1ec08480ab87/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.11.y
  Describe: v5.11.19-944-g1ec08480ab87
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ec08480ab8706a140351f1c2e58d1624a1e0942 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c284a6da0281ccb199287

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
9-944-g1ec08480ab87/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
9-944-g1ec08480ab87/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c284a6da0281ccb199=
288
        new failure (last pass: v5.11.19-342-g601189766731e) =

 =20
