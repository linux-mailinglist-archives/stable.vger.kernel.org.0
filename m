Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB6024A6F2
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 21:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgHSTdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 15:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHSTdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 15:33:32 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD492C061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 12:33:32 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 189so11240030pgg.13
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 12:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WE3/ANXJA8NFZcvbsAZCo6scJTpL6H0bEcs+oP7ZNkY=;
        b=s/BXZRJMka39wIx1c4FSu4eGp9E6zSdzDltpU7KiyeDx/4K3U66dEjuIgAQNnVf/rI
         atrMKlTha99KiQBapfaGKOAAd1W+xkmxVCWfmn9T4xO/dR6EYtmLbD1t56TB2sMl638B
         n2RGsk+WTon1avEIZqIigfS21kEwJdDG9jLBGxBy7t+3U+LolHm8Q07816fIqq51T7nf
         uJOeSTtsbUr05lvtEh7T93bdt75eXZ8iuMhaQtRa4qb1uLF1+O+mxGhOmPXU7VA/Zy2e
         raV49dWvn7z/kPO4co7GVHEQfaP57mGdJuOr7tOWccfUAiMmuToDS2jjRS+nJjbRoVyC
         Ba1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WE3/ANXJA8NFZcvbsAZCo6scJTpL6H0bEcs+oP7ZNkY=;
        b=Xt+Q59Ash5ETijryaSE2NgLBhF1A39IoZeW5JBlftLQ/J5rFPPrAjnMQQrIx3tsuHA
         ZktA67Uw3cxWSEtY1bSuENAhC9ysHy2yQ02R1iGpF6QJ5PvzBprh+HUYOCK52MmrRiRs
         RaKe0lUvcgZqF+RkMEf0IFgQ3mX9Eoxp4Vh7cRyIJkPaRYrFLD6svBULQUT+/mzvn81n
         /jFlL5FfkXjk72tlaVgYs901kW+bWmE8q6RXP1Sr5Q6D3+D7RwmsYvQzf2/5hePVf8aN
         jM0u3xSUpExlbS4XmYi9E8/zHZ9aTNWNRXh/3TdP+eQzJ7R8cV1B2EK2MxYQkGS4vd8V
         Z5ZQ==
X-Gm-Message-State: AOAM533eqJXDWkpgdZZuivme5a+ZQIvYbz5bndqVjmIYgxevBqxr0cBt
        EuGclRMiB8Wv67YbNqqgqLQZ/5Vb3OyBOA==
X-Google-Smtp-Source: ABdhPJycNW7pPEVOEilqZ5BDoMVJ0PYYPu78IuEyIt8OadaE7ejvO0UF2Ofe+zlaUHoNd1AqA2mHgQ==
X-Received: by 2002:a62:5b07:: with SMTP id p7mr20529778pfb.326.1597865609753;
        Wed, 19 Aug 2020 12:33:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 74sm28406594pfv.191.2020.08.19.12.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 12:33:28 -0700 (PDT)
Message-ID: <5f3d7e88.1c69fb81.c2bb8.1adf@mx.google.com>
Date:   Wed, 19 Aug 2020 12:33:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.193-195-gf27c69846742
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 154 runs,
 2 regressions (v4.14.193-195-gf27c69846742)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 154 runs, 2 regressions (v4.14.193-195-gf2=
7c69846742)

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
nel/v4.14.193-195-gf27c69846742/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.193-195-gf27c69846742
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f27c69846742bc00deca1ed0f6a9d4fb99519149 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3d4bcc3e3bbc2c51d99a5f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-195-gf27c69846742/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-195-gf27c69846742/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3d4bcc3e3bbc2c51d99=
a60
      failing since 26 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3d4bed4a3b68b88ed99a3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-195-gf27c69846742/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-195-gf27c69846742/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3d4bed4a3b68b88ed99=
a3d
      failing since 141 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
