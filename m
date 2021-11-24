Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7731745CE6C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 21:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243574AbhKXUyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 15:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240489AbhKXUyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 15:54:01 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8870AC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 12:50:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so5996009pjb.5
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 12:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/80iOAnIc8S+ciPNuCFZ2a6vZdlyYKshOp0DDgY8mMw=;
        b=GTqr8B7QlpS0BP74V4K5KiPKCg0Dj2h9eCtxZgoR8YYirK5qwZkqfbwbJJIgbcAJv3
         JvoC8nP74M31q2/GdmXNyvV457xwCxjnaIkM5qhltD3QYYjq4i88AchMXtpA1SeA4DAd
         ZkI9VrLrvBfL7x8VHnuYiKIxCQQ6lhiHMcP78r2Nj0vmqJgsITYE38W7qDYFGzumTTez
         rj6b7RWTWGxVwcYjSOMpmzzEdArUPVYF/3c+w6QL6dHInxmO7Ec2vtviJqACaOMAvfJn
         WpmQE6JEXga+B8Z5SQBxDDy0YRb0aR3rHMt3kCmM81Q9wzAiCRajfsYz37Chj8zs4igH
         IX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/80iOAnIc8S+ciPNuCFZ2a6vZdlyYKshOp0DDgY8mMw=;
        b=t3zx386um8NxVV81A1i8c+UrKzNuJ/1N+6u7+EMbCp/d3Bb9IK0bdjgpuESmZtKu1n
         deTJ4sVDQmbfy27QPqOiY4xgK7QfiRds1RJdz5JFzxbyBZLFXwy05VLUJeIdcfgNLqZq
         uWEUTFKAvyPeRWTmMOxNu+LOx7ft1WIPUTUmLIOJoAHq+xX4fu7UGhvQNg8C1wWqlSU+
         oP9DfYM/jGFQ8cJFFBxfWpTeLVdWOAZWY1JXw4szMMQ/w3P7/rFTaoG7U5EGZymgYlNH
         jktTmgMrxOu0Be7rCpScmzlVvZbqElVwj8JrjS/t/Oe+2Akn/MHTtQrt5Wfvh6fDPT2v
         ey8g==
X-Gm-Message-State: AOAM53199d5vwMbFei4c++BbuSXa+ENU2CMgZcta8L3OPvMhGxyAlvRL
        sEzrn7/ldsGOSliGU6XCgui8GafSivrhGKKJ5os=
X-Google-Smtp-Source: ABdhPJzn3QMQkzt6u7mKfO7ekke3YaZN+yovRjr6IP/lf+pDG9GRnWzZ2XU84997NKJjI6JKK7234g==
X-Received: by 2002:a17:903:41c1:b0:141:f28f:729e with SMTP id u1-20020a17090341c100b00141f28f729emr22347028ple.34.1637787050985;
        Wed, 24 Nov 2021 12:50:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1sm639190pfu.33.2021.11.24.12.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:50:50 -0800 (PST)
Message-ID: <619ea5aa.1c69fb81.1d653.26f6@mx.google.com>
Date:   Wed, 24 Nov 2021 12:50:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.4-278-g8bf4b06785fd
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 1 regressions (v5.15.4-278-g8bf4b06785fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 174 runs, 1 regressions (v5.15.4-278-g8bf4b0=
6785fd)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.4-278-g8bf4b06785fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.4-278-g8bf4b06785fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8bf4b06785fdb1e097ada8db9c08171742e3d4f1 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/619e6cc54da432e7eff2efc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.4-2=
78-g8bf4b06785fd/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.4-2=
78-g8bf4b06785fd/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619e6cc54da432e7eff2e=
fc7
        new failure (last pass: v5.15.4-266-g7d1b0014a364d) =

 =20
