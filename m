Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A0321C0E4
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 01:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgGJXpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 19:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgGJXpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 19:45:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0B2C08C5DC
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 16:45:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g67so3192924pgc.8
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 16:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x9gwoA1rDo6IjaguYswvDL/ATMLon6gpMfYBhPtIQzE=;
        b=fuIAjLj6zno8WRGSYMqRSdgmmX72ZMa1Z5O4rD5LcsEjvSTxA3wOvauHIomf9h/7ad
         QBmUj8ngCHYR5Cx+qDVr9hD4yhiyd6mVQ2rA3e/RCBZndrMEryyRPhFYtdruAVj155A6
         rGBGEeVfCx7gDFMW8BQke3jEP0d9B3isGZe6WuijPBInyKp80NgFVRB+4jKFVrzmK7ru
         KD3YPF7r71tHPS23PS7vlQrVbn4PKAh0Q/a/vpGpopEbNcP/+Yf4LJEiF0Y23XXfzIgD
         uprQalkd7+ILlPawc0kY5bPl9Is8JtVSGcZ3BcGZAqij28CJH6ubgMrbfswumTqNCp4G
         wELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x9gwoA1rDo6IjaguYswvDL/ATMLon6gpMfYBhPtIQzE=;
        b=qqUEmXo26nG/1WOjjosliEyJ0Eo9dFsKQXp4DXUVODCFhHdpTOEFDLDUBglCmmH/n4
         hsfDStXFsP7wgci6q6vaUTq6bfr4+PHW7HKY/eommxJajRebn8KWX5BLHFqjxexWl+U1
         W7VijcBzLp0/Ho3jvj5FV5TMl/Sl/OxLbzVDCPHBT7r3zRe3937+ibatryep/Gb3bZzR
         baBqjjuNqSEhDlmWr/IcjJaNgrHuGN185wJ0THrxQXNvlQQCY8dQxflRoqBu8S8ZKDo1
         CLK6KQtc70Cc5+YwWmIWLwnfoSE64L0ylps39sPQ56lzSsgGO0borpcj6FV0gsIwhtje
         VIyg==
X-Gm-Message-State: AOAM533MLVPlaHXek1rq21NZfqZZBRqD0rEV1bkXkx0zR18YnFY9ocf3
        VLe1yY/4IzikUB3xRPsYG+hYj3iTQGc=
X-Google-Smtp-Source: ABdhPJwuqz0uoOUwY8d1Lb38zLuisNqK3vletn2W0b8s6Fpzv0YyoXTswodtxZysN1ZgYNw8J3Af1w==
X-Received: by 2002:a62:1716:: with SMTP id 22mr61035403pfx.99.1594424747295;
        Fri, 10 Jul 2020 16:45:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bx18sm6814303pjb.49.2020.07.10.16.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 16:45:46 -0700 (PDT)
Message-ID: <5f08fdaa.1c69fb81.33616.058e@mx.google.com>
Date:   Fri, 10 Jul 2020 16:45:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.188
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 93 runs, 2 regressions (v4.14.188)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 93 runs, 2 regressions (v4.14.188)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig      | 0/1    =

qemu_i386       | i386  | lab-baylibre | gcc-8    | i386_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.188/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.188
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      56dfe6252c6823c486ce4b1a922d72abc7e3c6b1 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f08cbfebe02983f9385bb22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.188/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.188/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f08cbfebe02983f9385b=
b23
      failing since 99 days (last pass: v4.14.172, first fail: v4.14.175) =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
qemu_i386       | i386  | lab-baylibre | gcc-8    | i386_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f08cc37600f2eaee185bb25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.188/=
i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.188/=
i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f08cc37600f2eaee185b=
b26
      new failure (last pass: v4.14.187) =20
