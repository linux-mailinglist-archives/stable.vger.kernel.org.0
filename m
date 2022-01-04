Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5331D483AB3
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 03:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbiADCv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 21:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbiADCvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 21:51:25 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96101C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 18:51:25 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id v13so30925010pfi.3
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 18:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wjwVXn5oH4CutSxA1J5p46TcKkv6BaQx/hZiwmjif9s=;
        b=aJZCR66GdIebYb18tUtFA+drBHBXDqfuTsOyJsGnV8GNNOzcWAOcMpxA7FwGO4lrZH
         CMVOwb+EdfljkOoV/nlQwGJJUr3LuOzQSUSQVqBBnvZvDAvNAjKilnxmhJehRMY2h0QN
         tXVRy0AypCiQiB5aSCXl50Sy75eomyoowMPxs/vjaJfw5Ny3LMV8SSNOEJzEYxURwprw
         zt8KihkzOveMr4C3uzKu++50LXK2t0mqR/at/3F7BQNn0xMx9kPF2D71HR8zFyhj7Jie
         +UC+BmNz14f/CVUnjlhrhtB3gtkqF5InFrSV5HPShIfsg6lU7721rDV5ey/5dcWG9Eon
         6Siw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wjwVXn5oH4CutSxA1J5p46TcKkv6BaQx/hZiwmjif9s=;
        b=fFlcqUkdPZHhgKOKJqdXG+oxEF9toBWriZN5cC/XtK21fBRICV6p1nwr8AGM9FKKqM
         e6WThKQV11g2Tjp5D9JsdE1LGj+Yx50oSHyw5y3X9aNGzCnWhLSv4Yi9wOKrSQN/89rn
         OYveleUx62FtSbiuoak6LRnXNeLmaWEUNqpbi87umNemX42QDoI/bJ/wH0+iEXj6ydRR
         6mmnPuKurflwXCUJ7JJtfmGa1gVD24D/IuVqGtGP7VXvRhkPKG/bgPlUw6Kc8iUpkSF3
         zUFQ5UWk/IvPbjN6MqOi299XWM5d12cXL2JnB8EQycV/qOpRIY6fPl/43v1yCD/1EcBg
         xq/A==
X-Gm-Message-State: AOAM532+4PIhLiX9vTd0Khs1SIW3kf/7W8fvqsM+RSrXIb+DqO9lG9n7
        9jmxdMSqMPyBmuHZsPyriIIE00Q2U9ahOmM+
X-Google-Smtp-Source: ABdhPJz85dComuOYHQSt7I3W32T8ULWZvj/CDLW53ccyE6VbayDT88WdiYSYObdfIJPut/ylvYmopg==
X-Received: by 2002:a63:9d42:: with SMTP id i63mr23785539pgd.391.1641264685013;
        Mon, 03 Jan 2022 18:51:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v133sm37530282pfc.172.2022.01.03.18.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 18:51:24 -0800 (PST)
Message-ID: <61d3b62c.1c69fb81.ae0cc.524e@mx.google.com>
Date:   Mon, 03 Jan 2022 18:51:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.12-74-gfbfd9867da50
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 153 runs,
 1 regressions (v5.15.12-74-gfbfd9867da50)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 153 runs, 1 regressions (v5.15.12-74-gfbfd=
9867da50)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.12-74-gfbfd9867da50/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.12-74-gfbfd9867da50
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fbfd9867da50607c6a409bccb822c48823505929 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61d37d016fe0697cf4ef674d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
2-74-gfbfd9867da50/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
2-74-gfbfd9867da50/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d37d016fe0697cf4ef6=
74e
        new failure (last pass: v5.15.11-129-g47b0c2878802) =

 =20
