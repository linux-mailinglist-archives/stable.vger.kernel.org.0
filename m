Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B2422DC5
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 18:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhJEQWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 12:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhJEQWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 12:22:51 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B3AC061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 09:21:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s75so2220491pgs.5
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 09:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lT2yrNsjv6BfiezesLso3nn++3M2vJAy3XAVP61spDc=;
        b=fT2qo91ENynQnNNrhG1WCU/ME1aCovSw+a73BAs0/WdsL2+wn6891FO2+B3Rd+FFD+
         bsewMFbWeMojDnEVseWa3mwNPUlTOZlM0dbDVBHjTjZF+hvTlCZ9nNBji/2iEej8LhTz
         Twk3IYxUxj7oK7Ok3OIXZoO9TSSEDkuiVu8j0w9TgPbDLBJFZRVmgLPlL3GTFggzjYne
         T+hyfkA8lcrag8IxXyS/eIBsKNbuzEx/qed3NOoNVGKqwgzI+A90sys5XanREO4iNOij
         e1cfvC+z9ccSWucvRWiCjWuVJOE+GyXZ5GJFAdPpiokkm3sn/Yr+LyIyn1lZWOHWLQHD
         73hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lT2yrNsjv6BfiezesLso3nn++3M2vJAy3XAVP61spDc=;
        b=3qESpyv3IvISuzXYG1vNM6raJbGiAMFpJeBdPA7rrZ6DZYWAiBfTqs4uozY2x3FAez
         FPJYu6zlob80q6wovvxbcXb5gSlHSVvqfjDIEe+gmUqUVhkBHsdF0qGym22WmMOaZYm2
         yTyXbPaVr9WZMLFH/VRovHD5Wl/bXCHuiRKlYIhgkCN/BOM/T239epUv47ZWp2N+FcGB
         tWirJ1R33wtTpHxu+UbuM4IjPUcJH5OIZ+yecWw5kwTzVyt9tFvFh+IsJ3yuHgyNHwzY
         MpatDNva4DN5QIsp8P76pAPSxmfQNsDB6Lv3iGxRB8bi+5Qq7mjo3Sfjtr17o+hW8QNe
         SMpQ==
X-Gm-Message-State: AOAM533JKznnwtM/z9CsIpxoJeEF/B2wgRupZW8nh8jx1iFqYT4sMv4W
        AdGxkc1GPqxVn++G2FxkXT4GhAw8PqqgFlNf
X-Google-Smtp-Source: ABdhPJwT7k+ov+wy8ybsVgI6/APP6Ghf/RI9TCMEUvQvdm3bd4xCA/AcgUYzFKbsb8BAqH2GuKC82w==
X-Received: by 2002:a63:d94b:: with SMTP id e11mr6203160pgj.295.1633450860128;
        Tue, 05 Oct 2021 09:21:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m73sm6148516pfd.152.2021.10.05.09.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 09:20:59 -0700 (PDT)
Message-ID: <615c7b6b.1c69fb81.931b6.3bca@mx.google.com>
Date:   Tue, 05 Oct 2021 09:20:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.70-93-g76aee5dfd7ee
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 153 runs,
 3 regressions (v5.10.70-93-g76aee5dfd7ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 153 runs, 3 regressions (v5.10.70-93-g76ae=
e5dfd7ee)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.70-93-g76aee5dfd7ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.70-93-g76aee5dfd7ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76aee5dfd7ee7d3a9f3ba6c98ad0e8526191cd87 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/615c4dc90ae2585e7599a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-93-g76aee5dfd7ee/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-93-g76aee5dfd7ee/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c4dc90ae2585e7599a=
2db
        failing since 95 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/615c4c690db0d2d92c99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-93-g76aee5dfd7ee/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-93-g76aee5dfd7ee/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c4c690db0d2d92c99a=
2de
        new failure (last pass: v5.10.70-94-g02a774174b52) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/615c4b7ea545912be499a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-93-g76aee5dfd7ee/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-93-g76aee5dfd7ee/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c4b7ea545912be499a=
2f3
        failing since 1 day (last pass: v5.10.65-55-g84286fd568e7, first fa=
il: v5.10.70-25-g94756d80f44e) =

 =20
