Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D9A3149F9
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 09:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhBIIId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 03:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhBIIIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 03:08:31 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC00C061786
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 00:07:51 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k13so4939074pfh.13
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 00:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nqSanvVXG6QZ9vlAS/m4whgcygmWqIbPgxFj3xOUd6E=;
        b=OKF9Zw8bE/WNFVYBrNOnNESd1zMdwu7vBt2f3mX1xFZj/b+qfUoKbtKQTwEKk5pWcN
         ZZXlWghK45PeuTubuyQ7TOSaiuXFsfU59cDGU7nggcUa0ljd+U7HxIbVv+10p5RZpCeW
         V7sg+FKGImixD5F8A1THk6uYQ4Hns//sHt7V38oMrYKO8Mu9agRZ7kVZ2y6LlRlTQmR3
         aVkdUAmZPrqZgiW7xDqEccCKcWoQoh/o6O/YTTz5BQP/Gu7Ix6k9yKes5br4BtDCy75I
         4Jt3loLKTgq5JrqHNWJ9Fh1MB1uM59bS34mliTbLARXUzvpXDFHbyOHGVhYltZZPtYO+
         cEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nqSanvVXG6QZ9vlAS/m4whgcygmWqIbPgxFj3xOUd6E=;
        b=Ur5TZAOWykjDeEelhktA2w+tQDD/+9YUJ/6gasNEia2rkE1ptcDSyVIuGtEfSB+2aQ
         ZSps9mAtFjsWFUQEeGS//zxYMcEqHhivdPQqrcW2CT3OyIve9NxIqv7qsoIXag9BfbxX
         9Y/TLjXhoA80/+QbIhELAWAdIgml3xXUVKu/MXPbR3nJhIavKoukN9UKrmRdS+zkLDo/
         8+oQB+Sd5oMMczCnX6tHdN9Kemi6Gx8aN0L484gk+Qpkql0sp3Oc2ACvBwNrvPJK3X7S
         mZqa42wSBzU39IkfaAo+PHPZ93L+CMbvQx9OmkN6pDQ3suwsVhE2pwe2VOFmOCtm5+l2
         Dhuw==
X-Gm-Message-State: AOAM532RpoHFoq7yEWkyTHgISyzJWvcL5IQVaL9u6yJJ8TRHj7piATqv
        VGCyqiGJzs+tY60hnsgq8B8zMOozhQS+RQ==
X-Google-Smtp-Source: ABdhPJwVB8EOifk8da8K7BZHcsUTQ+/fqZMB1kqsYiiuwjzTw4FkhRrP0SUQYtCGwle9VbyFlt/Zlw==
X-Received: by 2002:a63:5f15:: with SMTP id t21mr16848925pgb.402.1612858070839;
        Tue, 09 Feb 2021 00:07:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p19sm1623317pjo.7.2021.02.09.00.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 00:07:50 -0800 (PST)
Message-ID: <602242d6.1c69fb81.3d08c.4780@mx.google.com>
Date:   Tue, 09 Feb 2021 00:07:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.14-120-g09da6c497f8e5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 109 runs,
 2 regressions (v5.10.14-120-g09da6c497f8e5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 109 runs, 2 regressions (v5.10.14-120-g09da6=
c497f8e5)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
imx8mp-evk     | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.14-120-g09da6c497f8e5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.14-120-g09da6c497f8e5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      09da6c497f8e5d640180188f23faf203c0c472d9 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
imx8mp-evk     | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6022105ec437c942393abe63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
120-g09da6c497f8e5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
120-g09da6c497f8e5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6022105ec437c942393ab=
e64
        failing since 1 day (last pass: v5.10.13-57-gadb6856092da6, first f=
ail: v5.10.14-4-g5bf21c370d20) =

 =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60220f18a8ff786c733abe67

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
120-g09da6c497f8e5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
120-g09da6c497f8e5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60220f18a8ff786c733ab=
e68
        new failure (last pass: v5.10.14-4-ge86cf3211995) =

 =20
