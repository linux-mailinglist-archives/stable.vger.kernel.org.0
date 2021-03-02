Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65EE32AED1
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhCCAGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344971AbhCBGvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 01:51:09 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3207C061788
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 22:40:37 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id e9so1271542pjs.2
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 22:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bmezMI3OzdtTj+dJDPBIAJAha3+kczEm2iCciFAQxPY=;
        b=ybG+UNOWb4QVKM3W6bj63DAh83II0Kwcft8xJ+kOW+wTIoiOQ83pmxqQ8mcEN5QAw3
         Ofly10hfxF8GHT04aCYYcs80csZIEjL7/TKqKbLVZzPds5h7bbCVynQbryWBEJakgWnR
         P90lD62NkA7BQsNrDL8jEou4GBLPOuSHet8PTdYf7ZEMFpeeGnANlgB8Yc1kkF01sXH1
         0qzKzsiPuCFwgZK8ga9HO/1TM+ZtIUjweQGxN3RGuYxpzPZf0kjfaqx2w3bqGt+qJSQr
         sUE5cwd5ZqW1mhiS/kOfOut/gHVkjTJVm67adWbJihEHW12y1uxZMRKGUC3brPp03UiI
         kOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bmezMI3OzdtTj+dJDPBIAJAha3+kczEm2iCciFAQxPY=;
        b=VVe/QgllCJOkS53dkkFP6TLZOHFehhdfuz1MKEMg0I3HZ7xuaqwtGlpDDyN7o0S6/P
         zvisECpp9XIfqKfHJKpPCt5AM9MAolPxCznsMQzWTZAF9L7oheqK+Cx8l2fe5WHhbSIB
         95yjrcF10w7XslCOIcHkMx85CwE5ZjxE4iggZmNqtILJ0hBHUBm5LUEDxBO6egWgnSlG
         kvyCZR/yl9acemJ1Edgzwefq08EA9dw4gDKmnY2TQn/JoDletm2tJYiwITlqO+NTa9hj
         LufpXiLAo1PvGCJ3PVmnwo9kEFavCpsmdPgTBtOWGRFIDs+OpjFhMvRMzfmsjdtpY9Po
         IQiA==
X-Gm-Message-State: AOAM531CXtcfhZpMwNVoG2DTfWSZDZk0YvgMKsD8ImAVaY2rEeXDShi5
        50riFSzkn+YkOHLDvND6vdt5tZ/6yTHR+g==
X-Google-Smtp-Source: ABdhPJzqX7TleT/15baaAcZ6Q5obapZMktLSytUUz5Jl9n4XG9e1yV4cjKla1awPdtHTgDtHeO+Psg==
X-Received: by 2002:a17:902:9304:b029:e4:12f4:bdb0 with SMTP id bc4-20020a1709029304b02900e412f4bdb0mr2147911plb.55.1614667236994;
        Mon, 01 Mar 2021 22:40:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y72sm19988246pfg.126.2021.03.01.22.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 22:40:36 -0800 (PST)
Message-ID: <603ddde4.1c69fb81.4f007.f11e@mx.google.com>
Date:   Mon, 01 Mar 2021 22:40:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-661-g7350d511d78a8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 189 runs,
 2 regressions (v5.10.19-661-g7350d511d78a8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 189 runs, 2 regressions (v5.10.19-661-g7350d=
511d78a8)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
imx8mp-evk     | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.19-661-g7350d511d78a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.19-661-g7350d511d78a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7350d511d78a8c41a633f5b5017e9b2203addbef =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
imx8mp-evk     | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603dae45d707a9a70faddcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
661-g7350d511d78a8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
661-g7350d511d78a8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603dae45d707a9a70fadd=
cc8
        failing since 1 day (last pass: v5.10.19-1-gd1c42444d513, first fai=
l: v5.10.19-19-ged89ece04062) =

 =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603dad45529f300658addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
661-g7350d511d78a8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
661-g7350d511d78a8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603dad45529f300658add=
cd1
        new failure (last pass: v5.10.19-20-g26d442e567cc2) =

 =20
