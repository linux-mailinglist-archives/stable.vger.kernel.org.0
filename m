Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BCA31ADA5
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 20:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBMTBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 14:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMTBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 14:01:45 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2CAC061756
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 11:01:05 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id m6so1703713pfk.1
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 11:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X/08WExSAsRvi34PHbcwHuxPbDSwdJz3S8HRC6hMyx0=;
        b=L8l8zkw0iWuAMrV6OS3i1Tk3sEIGl/5kgwfhNtEc6B149Dci/ZyG4mY3OAVDcBLgYa
         lnnMARXjNMqbKGpHLP8ZQHWSmIN3RmdfvKVfEq4VXz8GcPfxntlpedlhIfyf07PdCNbI
         xp1h8knlDGofCPVovT4l4enQks7P5wehxrqOQoZn6IvbC4jhw1Tzz3mnJV5PO/dmGupW
         aUV9oWlHbNerDNXba96RQ5CDmFKj1fi8pY9RE8jxASxgAnK/GNPzeYaggDTV2ENJrEcK
         W4DZlUnGm3yFkHHL53gwWhg6ehq/aytnAXYgVDAlUWywfCsCQjsIO9g1LilhbQjtJNqM
         PxAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X/08WExSAsRvi34PHbcwHuxPbDSwdJz3S8HRC6hMyx0=;
        b=b5ARMjKqyeeTrwFfICm6fsox1BoqcfbYQJlacukpmnzSytuJBuc3w9qnR2kxNyps78
         byKtFBJNggc5eqHU4LgQ7BeECSDiU/EGJn+KHCQ3+sECzTiP9fcSo//8llf86MUqf0Bv
         1r5Ofa3pjZwYCKUA5vj6Quqg3d6UHZ04DKA8/lqtybAqzizu/4JkWdVDq9Kn44JikWsy
         EfUHMzxCWhAWNS9h1YsKzehp0QbqiWh6Wrx3wNQheoD/1+yEsij/OIXoY8910AtC/DF+
         rcJcYqQ1LSn0EPwDvx/r6TfI0iWP5XaS1oxGAs0VIaSVDIm+LCgnGBVvBWg5HpaTBenI
         7kTw==
X-Gm-Message-State: AOAM533NLuT70jgtnoxV4VqtjzQv09dFFHCzSMh7KeRW8rflSqDyBijq
        V6y/AqgSpzMQ/gG18pwCCsEpq6EdYSahHg==
X-Google-Smtp-Source: ABdhPJwxNKmaJ2bX1g1sST9Vz/Xp8wi5w0/eTYOJ01z2lrkZSWzguFt51eoN5Pat+Jdimk947fnzwA==
X-Received: by 2002:a63:38c:: with SMTP id 134mr8446851pgd.302.1613242864646;
        Sat, 13 Feb 2021 11:01:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18sm6203359pgm.88.2021.02.13.11.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 11:01:04 -0800 (PST)
Message-ID: <602821f0.1c69fb81.95f78.d6ba@mx.google.com>
Date:   Sat, 13 Feb 2021 11:01:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 76 runs, 2 regressions (v4.14.221)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 76 runs, 2 regressions (v4.14.221)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.221/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.221
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29c52025152bab4c557d8174da58f1a4c8e70438 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602470901bc2f79dd43abe8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602470901bc2f79dd43ab=
e8e
        failing since 316 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60249a3b3fff1404873abed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60249a3b3fff1404873ab=
ed6
        new failure (last pass: v4.14.220-31-gc7c1196add208) =

 =20
