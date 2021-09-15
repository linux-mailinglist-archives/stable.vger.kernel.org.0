Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B18D40CF20
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 23:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhIOWBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 18:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhIOWBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 18:01:14 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586FAC061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 14:59:55 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c4so2505800pls.6
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 14:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RxYUnoIy9sM+yeG/0XLoVaHLr6inqndJRU9WjxQcFfU=;
        b=B6BC8t1q3BwFlFxy3036b8ZhWxUo+wSGaLJUHzcslxoRuk0o70fq93l8ZpSrCb2WPV
         yVN++3oZ2ZiMAaDFWZPNY5MArgfkKu+hE1oDKg6vF9+hOMK4B1bMYCyeuj2viSwT0mQt
         FXZPkxL/8WFR9dayjilNOFvd7IRTFaOjeBjUbQL6ZyjXLsTDTjelgmsp33G29/8d9gQO
         NH4IfVEv9ZrlPqyoliLOOzzq7V4SXnoHOA+Ts60yRUgrPq89RvRIYNCZN814GgmD1KTD
         NTLX3EQpaal2KJ9Lmu6IWr1DF/fE44tSK9/1SPlmGw4BUeR2i9N3398kO9Fzc8jEYNJq
         VS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RxYUnoIy9sM+yeG/0XLoVaHLr6inqndJRU9WjxQcFfU=;
        b=tY5WMdSfxS1dMdWdrACtuZbrl/zv0e/uYTzBOPfwaqdrJsMvjACj144IJhtL6bpqsf
         HcLoe+xoLA3yclWEScn4NNH3FLhpmgGmUXUdQi75QlD0Ev43iUY/A6M7TnY96O5kCmsu
         pedY+oZuTPYHp/PwXroX1f+cjS5lQB0zGwTQW8LtQu19aSZrhZf1+I1dywP8UhnWlUad
         kzo9fw/Z6qwmHKp/47m36hOlM7Yp0aqbESVf6bUi2Zs+MBwq6v/GPVdagBXuEz7bQbUL
         3uxfWKnPsX6ycUH//+tZIlJi21yeHUKTuAnlGvv49vhAUl3JC7voJtKI+rNmhrBMaTQF
         f6jw==
X-Gm-Message-State: AOAM531Ua58KtbaLGRMYd/YlZjz7tSPmAPV3dPdYIDjYtWxx7DeQseau
        FJxBc1MLVQAXw2iE5YlCTOeZe/AbnWWnnmiS
X-Google-Smtp-Source: ABdhPJznJqqK6rmVKxZ0NELI1BaGcRpKB+kjqxpwL9apECfqT+MVz6NdevugAOuVhrIH3fADQ3NUkA==
X-Received: by 2002:a17:90a:4d4e:: with SMTP id l14mr2135023pjh.4.1631743194675;
        Wed, 15 Sep 2021 14:59:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10sm889328pge.10.2021.09.15.14.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 14:59:54 -0700 (PDT)
Message-ID: <61426cda.1c69fb81.7f192.4207@mx.google.com>
Date:   Wed, 15 Sep 2021 14:59:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.65
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 135 runs, 3 regressions (v5.10.65)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 135 runs, 3 regressions (v5.10.65)

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
nel/v5.10.65/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.65
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c31c2cca229aa5280d108618bb264c713840a4c2 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/614239d5ae556c575d99a32d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614239d5ae556c575d99a=
32e
        failing since 76 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/614239488d4b980a4599a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614239488d4b980a4599a=
2fc
        failing since 2 days (last pass: v5.10.64, first fail: v5.10.64-215=
-g5352b1865825) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6142386fc07e70fac799a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142386fc07e70fac799a=
2e5
        failing since 2 days (last pass: v5.10.64, first fail: v5.10.64-215=
-g5352b1865825) =

 =20
