Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49F930CBA0
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhBBTbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239793AbhBBT3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 14:29:12 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D9DC0613ED
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 11:28:31 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id 8so7721618plc.10
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 11:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jb9fafr8UlBksV4GvogXW2zkziqvhIXcOHKkKQn6b2Q=;
        b=NyQnu7SkmKOKCGK02Zc5nUQd7y983EQb2ohywvcNdQT0oy0yUtRBClJtxB3ntEiGKc
         4X0hJnEtGzOj9fdwZwI3aHwxCFBxcvNVAGDA1ps35+EK7cMhYqltfCT0BF8Fkt+3OiBX
         m3QSRncwKgJjpAtaptpO5tmH94DKWL8ceiE03HNdV3gB0ffzS3t1paveUi2R+fjzQ4NX
         i8EDjvu9NjyGZ3sn/fprGQEATUlInP0P9G/lf0wgOLTZwop87uPJAj2OoDNgTT6RY853
         Z+RWDDaouwTYWJylgVN6dGiHxCFJD6v3K+rDxYWRfoP4zVr6gMaDKBro94UZ/mXhSrak
         +sUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jb9fafr8UlBksV4GvogXW2zkziqvhIXcOHKkKQn6b2Q=;
        b=W7K+v90K9zpBvYcVLwUE7UxKsIleAFpmtyFIt10cey4f9cri7vdViFFEFfTKfpT56G
         37hPvIWKB54K3Ce+ZXOjUYdHVzxAJ8miEQg254/4ZmsbNvuTdjcyM3NwcAIxanko7P3U
         cPwg5MZpraAFywVb9OIfihkdaz8REQXwEvGW9l5ydAtwZZ1XnakvCzLm6i0lfRQoCV0A
         /7FZUuEJbA03JF9gYf7+T0Bx6kjzhsg13OZukIseJcr7P2nm/Ijp0SUEVSbrf39agfNu
         g53eDzXGIM+4ypueBZIREOjMNZEkifwRzzGaMOpdR9DWINsL3N99bUfZAVHeVrW8KnPB
         5pGQ==
X-Gm-Message-State: AOAM531bZDtlKgjxVG8c+9LY9MC3V9ZW+raW8lqi+s7kCLcXctDip2o4
        F15vNMKJ3sjrtqz+EbmoNT8XTzgE0dR/lg==
X-Google-Smtp-Source: ABdhPJxuafUEx6ybXivD5eeGreoxDtQHIOMdmo3vctQ1Z6iU9ZH/8fQSU2iayRXUNDAPR+GmcErkFw==
X-Received: by 2002:a17:90a:f0c1:: with SMTP id fa1mr5976751pjb.3.1612294110709;
        Tue, 02 Feb 2021 11:28:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n128sm23831257pga.55.2021.02.02.11.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 11:28:30 -0800 (PST)
Message-ID: <6019a7de.1c69fb81.6ebaa.7c88@mx.google.com>
Date:   Tue, 02 Feb 2021 11:28:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.12-143-gb34e59747fbb
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 176 runs,
 1 regressions (v5.10.12-143-gb34e59747fbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 176 runs, 1 regressions (v5.10.12-143-gb34=
e59747fbb)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.12-143-gb34e59747fbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.12-143-gb34e59747fbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b34e59747fbb2a46f329a8562d3fd5ec6e24b2a1 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601977394c69a0b4f83abe64

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
2-143-gb34e59747fbb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
2-143-gb34e59747fbb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601977394c69a0b4f83ab=
e65
        new failure (last pass: v5.10.12-78-g6ce52453eaf7) =

 =20
