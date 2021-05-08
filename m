Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4103772BB
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 17:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhEHPsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 11:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhEHPsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 11:48:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87163C061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 08:47:08 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id v191so10013944pfc.8
        for <stable@vger.kernel.org>; Sat, 08 May 2021 08:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dinzjg0unMhfC/kgZnTbjFT+pU3gZs2wYy+wwgOz0Kg=;
        b=a60dzfxZFaSw0tkcjUlb8rMnAU5YZleBUNu5xz8tjRi95FmX28JHmjfchWAwUCK5c7
         rbIwqDqOOCPG88Vs8veAOl+PxRU4uzxJB80x0E47fHtRyFnOkxuWozsWN3UAVe8jb2KH
         aurIOKti2HvZN2lHIWfI/rGEqPZw47HzFvT1+p701WWOYVxXVk3+RnlKneVd5gk9OROg
         pdZV4R6aVFYyEIUkbve+ZUaYlXXvsLXk3pI7SgdDarngxVb6Y5Gf/5g3f80BuXFNJYil
         yPqKm7mbsW/+zCCm5Htw0lC/cCBQAxeAninLQMfMS0Z5M+gBxJ0SsjVmtG4Sz1SMjIb0
         npTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dinzjg0unMhfC/kgZnTbjFT+pU3gZs2wYy+wwgOz0Kg=;
        b=PYALD+upq1Nrj7Bm8UVHYuKM+7YHHVP2+rSxcGQdA19SZkPxTqgNmE45dK7Q8k7IjM
         3z0taJJNtW660RePP3aJ00xe7r4DN6AmzWAdzowcmXdu/RGoalkYbFPz/iJWy/u0ssTc
         gVDnQhR17MiWq5irHuoPkZDGFxiEZKHZBeVamuDXfhGRJ9s55HaKUka3Kel/2fB6f7pr
         ID+fNE3P594CPQgmGjqpVfvfCYdFgky4CMzuZsh8MaKSo9aACeI8ql/ab1pf31EvVQFo
         7bhHt3jwSEmTvHS2cj0tq9MnZsOGATyum1Q3ogET1fX26+/6tQDEYXAptxRrQJIn9sFj
         lvwQ==
X-Gm-Message-State: AOAM531524Oz0HKonj1NoDPuSBX6TUJsw5fdZqEjBe93NaAAfDVHIo3r
        MjIBcNLfiv6B/vpGG0fbxqJbEpijuJUJlA0k
X-Google-Smtp-Source: ABdhPJxbIKus0c/bSgjZ04E9Jk31fsidGWugklnHsDoy5E7o92WnoB6PxZb4MvNsZXtgL3Nw1XpODg==
X-Received: by 2002:a63:d74e:: with SMTP id w14mr7916924pgi.344.1620488827966;
        Sat, 08 May 2021 08:47:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nh10sm6832796pjb.49.2021.05.08.08.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 08:47:07 -0700 (PDT)
Message-ID: <6096b27b.1c69fb81.4b003.4d01@mx.google.com>
Date:   Sat, 08 May 2021 08:47:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-241-gd2a431e33c45
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 147 runs,
 1 regressions (v5.11.19-241-gd2a431e33c45)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 147 runs, 1 regressions (v5.11.19-241-gd2a43=
1e33c45)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-241-gd2a431e33c45/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-241-gd2a431e33c45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d2a431e33c4558f10388f6d3067330717ac652df =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6096827edaf273b6b26f5481

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
241-gd2a431e33c45/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
241-gd2a431e33c45/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6096827edaf273b6b26f5=
482
        failing since 1 day (last pass: v5.11.18-29-g6c2ae64a2a728, first f=
ail: v5.11.18-30-g4232ce7a02cc) =

 =20
