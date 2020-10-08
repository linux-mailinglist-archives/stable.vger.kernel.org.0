Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC65A286DD2
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 06:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgJHEyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 00:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgJHEyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 00:54:17 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B214C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 21:54:17 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g29so3242009pgl.2
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 21:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=weyXZ0u2yd0T1FhJeh9ZoPEz/jPKheLZUYsCgfPRZ3I=;
        b=PUo0HatHdbz8V78QE7z7I/ASXzEal3FvZY2XjVX731YFG9BRJ7cdGC9LxA2pShocUB
         U+rtCfuq/MR0CwLMnWw+0q+7zE+pP1SoUHP0AtFK1n6Sj5sexlaiDdyOiWNcQ3GeMVM/
         LojA1bxe5XWnYxo6omkCzUG+WY0GzvZ/Y/vawvE1YGrIcKM5O0f5DWxmPaYmKJZAvMQq
         bL9EVg9U7rhiU3zxTqOXQR7oNzCypmbeEWjF5WqXoh9N6HSlUcnL0cKqgcHCrFBNbi+S
         mcStEBctQqjokkJ2bsHlrpPgW4dP6BwwvpSniqaxPSvEBanGQOKNYhdKMQPVOxjs4jac
         NlZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=weyXZ0u2yd0T1FhJeh9ZoPEz/jPKheLZUYsCgfPRZ3I=;
        b=A2PcXJgAqMq7fXP/1N75PI6kPbNXy87qU8DMlz9CF9fWps8uX/MzWUuIy8C6ubXU3m
         lFbY3yeuFaNyYtXJhC8TDNrVhdCTbqAA6owLDzXmwM5gYIRuNsL9gehrJi0sJtme3c0Q
         8oZXQdQz5JNYWZfU6MUl5L5qlKvyta4BuBjyotMhXWhKofvC0ujetw+cA9udz3JtF+ZZ
         c1U+RIhkA0Tzoq26pZs9Yfx79UU+hHlKfTjA6RTVbACNdWEZeDSuiotdcugHxXaFIjNS
         NCbwM/fBzGhtz0NYPU4dSZa3pLvOQlobFMbVEXuwhY+0Fttpav/bvfQXbC2KzjMnH4gZ
         T4Ow==
X-Gm-Message-State: AOAM533f3J+Xe3GYY9fTJ/Wrs+rwokY973hEmyJm/+wVnMFvp4qRiwaA
        I/zFacJO9jtLrja031ZZ0DzlAq4ohv7q2g==
X-Google-Smtp-Source: ABdhPJxmnwH5/MpLqLFrjpYkNTg9OMNtMDWYqYiWSonllwawf31zupQZbB5ltfMZYNxtcBXjQsxCRw==
X-Received: by 2002:a17:90a:2ecb:: with SMTP id h11mr5935253pjs.195.1602132856647;
        Wed, 07 Oct 2020 21:54:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2sm4517593pjk.12.2020.10.07.21.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 21:54:15 -0700 (PDT)
Message-ID: <5f7e9b77.1c69fb81.84ba0.8cc5@mx.google.com>
Date:   Wed, 07 Oct 2020 21:54:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-36-g2ae705c76879
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 107 runs,
 2 regressions (v4.14.200-36-g2ae705c76879)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 107 runs, 2 regressions (v4.14.200-36-g2ae=
705c76879)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.200-36-g2ae705c76879/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.200-36-g2ae705c76879
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ae705c76879ed326adc4116bfaa8cdc8da5affb =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7e5a5b0cb1d3b2604ff3ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-36-g2ae705c76879/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-36-g2ae705c76879/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7e5a5b0cb1d3b2604ff=
3f0
      failing since 75 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7e47e172aa915d414ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-36-g2ae705c76879/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-36-g2ae705c76879/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7e47e172aa915d414ff=
3e1
      failing since 190 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
