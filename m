Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7C638B976
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhETW3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhETW3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:29:00 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF3CC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 15:27:38 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso4469789pjb.0
        for <stable@vger.kernel.org>; Thu, 20 May 2021 15:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZlTPf3o3Lt/tLG1Z05F+A/bblZqg9r53fNA4oAbm5kI=;
        b=LxzeNNxQGL/UDeVuk0YsTfoUrZJhIgJnnygkJo5qgNTVLZ9fm3a/2lI9e7T5WGb/rv
         JkHNj915ESveL4x8/0cggDwCxB6XwUoHdGQelHNd6Ry0NHfqqh3qVwhq2Tv/+GaAN1bn
         MokafwCRaMJ55Rfy0EMk8TB3M9isF6TB8ZYM8eUnmpphI61UsZQ6FqFdA7CQoWPMjsf8
         jZWjRx0ZepHv4QkbA1+97yb7k38LOaxmS6intDbYfzaUs0MjOIYDQ+qYyc4rJqxCpnpC
         vHWPrK3WxF2JEEIuQ5Icv0LSLHcEkVA0mG2f33VG/VBCLw8mjQWeLeIx40cDhOAlzwVF
         IcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZlTPf3o3Lt/tLG1Z05F+A/bblZqg9r53fNA4oAbm5kI=;
        b=RfKNL0xHrf0zP/C8hq4ltRBL9RF0gfBD5MdANxJKFrAL1ofoHK8xNm+4ZpEw8rwDe2
         GGRb/JrQhLbj0WC9hABYxjfo0AJAJmnYEmoDYB5IHBM5Bx5qYCzaLykk13UJD9LW1G33
         S4vyY0EBUQ6ndGoI7dBYwqb7knN+DEHcIsnbw1Eb5KnwoOzna+jOwoHx8Vuu47cu9Upj
         8pDHycPg5I/bOkz/R7QKKrspW2gcFbyRV0OxJBue2YtliKcMOzVjMsSz55lu3bsUitGu
         gxZD0Xrqdle1TRedruy8ItdD/n+kWLtak9j5AyIKB1ooQqjmXzYrlQ7pZhY/0V/wcD+w
         3Uzg==
X-Gm-Message-State: AOAM530TbpWPFt8mN/upm9EtBU2hq259z7w++0K4Cbnvd7kaTqqgDn+E
        FjZfgNSTDUfjLVbDYU0css3wh1oC2j/wuAIJ
X-Google-Smtp-Source: ABdhPJwLMVH9a/rne4OPjh2+MzGmzAljx/2QIvkEzHomN9xWDRUBeJcu+TFar0HsugbkasUIPCkjNg==
X-Received: by 2002:a17:90a:1150:: with SMTP id d16mr7100540pje.180.1621549657913;
        Thu, 20 May 2021 15:27:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b199sm2628610pfb.181.2021.05.20.15.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:27:37 -0700 (PDT)
Message-ID: <60a6e259.1c69fb81.eda20.984e@mx.google.com>
Date:   Thu, 20 May 2021 15:27:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.38-46-g4313768a0a3e
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 154 runs,
 1 regressions (v5.10.38-46-g4313768a0a3e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 154 runs, 1 regressions (v5.10.38-46-g4313=
768a0a3e)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.38-46-g4313768a0a3e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.38-46-g4313768a0a3e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4313768a0a3ef0847c2ca31ca95acbe4727fba10 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6b090a86182cc2cb3afe5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
8-46-g4313768a0a3e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
8-46-g4313768a0a3e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6b090a86182cc2cb3a=
fe6
        failing since 0 day (last pass: v5.10.37-290-g7ba05b4014e8, first f=
ail: v5.10.38) =

 =20
