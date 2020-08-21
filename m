Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D4D24DF19
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 20:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgHUSIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 14:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgHUSIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 14:08:40 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF90C061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 11:08:40 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s15so1361593pgc.8
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 11:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xqy2bBzWnKre4Txf6gA2w0BsGH49JKjetzK+FvuG0A0=;
        b=Nyv6KY5afzHUqinUN7LWOFXKLAfXB5aNaHPPNbBuXPXjH2RiBDashbzoeI6ymGAhvW
         60PT47mHMClDQTXR2nAqtmPfuxESnxEFVHgTaO12rGZuju2Fa0NIWBnXtDm5akBi2u9d
         XJ/TeUe7m9U3gxNkzLz1KK46q8Yjs8G9NmfDcVlXVU7ah6HVIGs5OocS5OA4XG5nim+a
         VUFuuCsPRKgfMHJGzIHHNAo7/IJuo1w9SUyhXON8xS7/jYdhcNxNUBJcbWSc4mYYIBbQ
         Rq7Dr84B4/hYIMm8LhPak5pz59NiJE2UgXl1SjMt+vZt6+uxZLiHGQVFPYuLyD55+gDK
         l0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xqy2bBzWnKre4Txf6gA2w0BsGH49JKjetzK+FvuG0A0=;
        b=IMidCTVEz0P9T2c+dMouNeXWpnVm89dt+BTMNLJj9iB9eEbP4fACU//mUa93F8o10X
         OzC8QN52Q8Jb3TC8f+tGHG1ZY19X+cFmjBuP8vsreodjymRQSkaQ1Gag7pZsB2e6i6d/
         cge/rQ2y1kXV3HFo8XOrnGGppXoxpW2ZBqGtFtti/TpnCjFeCOXzpyO3X0GegZ1lkpuU
         yOJjzqA2lVqrhLWOIeiM7p+qXwphRSPn2i4dLYME6Xa7bzKdGf1KI73JYYjVK05hdnVj
         3Rk4EoydsqiQ3z0RZzAN29q/JRkv6fXiATNI0pgXoZpHny0sCsVsKNAK52QScgsMAQHC
         wSWA==
X-Gm-Message-State: AOAM532lXf+HN9srC7/XwxprBRjtOUa+Ch4+PfVosCEKqZdR6EzI9aSL
        imNDJZEw6liPsXNbQJ6ufFfO2kekpfX/eA==
X-Google-Smtp-Source: ABdhPJy5lqM+Blg+ePdlEwSeoochwYu/WthqeFTSJ0A5GwyviztYGlNOl1zwI8YECK5geE+Y3yCdsw==
X-Received: by 2002:a65:4bcf:: with SMTP id p15mr3002425pgr.81.1598033318775;
        Fri, 21 Aug 2020 11:08:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b26sm3481691pff.54.2020.08.21.11.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 11:08:38 -0700 (PDT)
Message-ID: <5f400da6.1c69fb81.6aa60.8f9a@mx.google.com>
Date:   Fri, 21 Aug 2020 11:08:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.233
Subject: stable/linux-4.4.y baseline: 111 runs, 2 regressions (v4.4.233)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 111 runs, 2 regressions (v4.4.233)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.233/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.233
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5c1073c66666838dcd7ca81cd83b442ed4844c1f =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f3fd94797fb0a28d69fb43b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.233/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.233/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3fd94797fb0a28d69fb=
43c
      new failure (last pass: v4.4.232)  =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f3fd95fcddee7af5e9fb46e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.233/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.233/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3fd95fcddee7af5e9fb=
46f
      new failure (last pass: v4.4.232)  =20
