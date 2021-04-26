Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7217036B289
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 13:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhDZLxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 07:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhDZLxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 07:53:17 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911E5C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 04:52:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s20so12957209plr.13
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 04:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GPGUyHLf+j8tnLnRg8k5a5SzJPWwHlJpf+E1DeUi+QY=;
        b=EWO0iuJaZQ80feUKzWul3z8w/UHzbJ8NhZ+zpBATLNOVCEYLoc0NJ9OZ9+GPFGf1yB
         DL2fItItRtez7pbiaO45oMsP46KtzTiI9Rak0/UU0cp7CMSwnmcUbIPmp7nvGhx7FU1k
         xVRxA7/KzH3WH+X0Mzs/TC/D4sts4zn3Ue1ytSLf2j7FYrNexLtZEEQ80lmV/yaqVIRf
         qMjDkM17/djeoYMB/0bWJIhqaXGAwCP7zWb3MrsOuKHMCobGGreYo1y4KESdxlTtgkP2
         Jp3BzevDboMTjrRmg+F6I/gedJ35C/6lr7ZgbiNFL7wXyACzNWZpTZtL9w8sf66zTe02
         LTZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GPGUyHLf+j8tnLnRg8k5a5SzJPWwHlJpf+E1DeUi+QY=;
        b=K9YeyqCQ7F7qVsw5MwtIdNZCjBgmg7De6ruHnVJyPqQKnW94AsNAK5GUVl1VZIL8aQ
         b3Yq590i0jk4Klf8UUL1dw3eJQ/cra6pQnQLt2o628tejGSpa5Far6jWjRXGyPp/B366
         xkD3dPp8KXeD6r18r3SRXVRkp1RSt4gb/ZX7ElJ8SZbGUPryXOyFLSnYLNZhwFEczrcp
         XJBU8s5ZDso8W35wwyLS9QRjpZQzLbX3NTK2s3WVF/Q07paWC2KNcuj+YXL2iFzV0GhL
         pwGvrZAI1kcWwL2Hw19SI55+O9e752ryvo0E5FLpiLTqF5IQGFbHRojQgImFgljeES/n
         39FA==
X-Gm-Message-State: AOAM530cJxp7APUGspmiFJWZqNWgjzkC3DkCgHWSsAbtNBWmy9dBKFKp
        w5bWsie1+aehxKcnZhCb/1nTitnwl/+kkL6B
X-Google-Smtp-Source: ABdhPJx1a811/MHHH0wtsa3qVD1oNI9emJuQC4ASkFFJB8BCLJ5/LlKFePcUxxW1jkmRWjutDtS2Ow==
X-Received: by 2002:a17:90a:ac0b:: with SMTP id o11mr6370148pjq.159.1619437951976;
        Mon, 26 Apr 2021 04:52:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g185sm10943908pfb.120.2021.04.26.04.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 04:52:31 -0700 (PDT)
Message-ID: <6086a97f.1c69fb81.fa5ef.fb10@mx.google.com>
Date:   Mon, 26 Apr 2021 04:52:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.114-20-g2a748f05731fc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 142 runs,
 2 regressions (v5.4.114-20-g2a748f05731fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 142 runs, 2 regressions (v5.4.114-20-g2a748f0=
5731fc)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.114-20-g2a748f05731fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.114-20-g2a748f05731fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a748f05731fc11cb013d41b36d8733e11d8e531 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/608672e0463c4dcdae9b77a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-2=
0-g2a748f05731fc/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-2=
0-g2a748f05731fc/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608672e0463c4dcdae9b7=
7aa
        new failure (last pass: v5.4.114-19-g418f75ba54e71) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60867350607cbfd0e19b77ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-2=
0-g2a748f05731fc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-2=
0-g2a748f05731fc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60867350607cbfd0e19b7=
7af
        new failure (last pass: v5.4.114-19-g418f75ba54e71) =

 =20
