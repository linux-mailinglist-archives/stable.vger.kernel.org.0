Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA314391971
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 16:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhEZODh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 10:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbhEZODg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 10:03:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FA9C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 07:02:04 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ne24-20020a17090b3758b029015f2dafecb0so394019pjb.4
        for <stable@vger.kernel.org>; Wed, 26 May 2021 07:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C+z8opNWgzYMNIHDvUdQlrp1mnv4UXWq7zRbUFb47wQ=;
        b=iJMqk64hHayKpc7Sx9O9oeQJOSqiGG7jgTWh7FKh639OxRRdMuZzH9e6+tO8UbH5r1
         se1nTJ3KrFEAMkVabP7inOdy+pSfYzsqldkNLonw3jJ4Bil2/etVCfmj/QOb7efCJ3FW
         OS+TwtqpW9oXUc+KJQCb06E9eEp3BSweEAn//T2hUNNEa2q2Fue8ML636UTKIOHPkUcn
         FDV+jnx+J3TxOywxvxxwsHuYYYSTAA/LcA/WsBTRrl6WNBlvVEGpMPyOumk1sDK4vIQb
         ohZu/uNa7RLk0+1sJd0vKALD1vxUjQAxmDM1bqRHCLRY1RacO04A+HqmfsptkdTf7dDd
         1EKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C+z8opNWgzYMNIHDvUdQlrp1mnv4UXWq7zRbUFb47wQ=;
        b=Fx3rUy1lfQMSOgbwkqyXzOoeaHadkmk9NgEOz31zPvWhZu8oJUI2raZsU+/5blQOtv
         dPEaM2xkb6N2dhB0anVGAXSVi0kFB/E3IbbKSNiBnKJNWB3/gafXmJs/k70JREKp5gHa
         Txu8GKzabMIBbJAHw0Li+RV7GyPZtHu6b8uF4tCXV5OGRCuQvu7RXPLpqtXe4/yFPI64
         J+ZRH1jXNyJ51fTMhER3/w1zPaBmNOffio4/jsGcNvLXbbu9xvGgW6lTpXlxTHib5Gcx
         kKV8vB+8W+W+CXsPn0BAvNZRMeWjkIXUgiEWDFLQOGf9LsX4woDBtVw6Qm7TYW234Bdm
         8a/g==
X-Gm-Message-State: AOAM530l8yRQ4ktE45h958iqeKLTooXuE9TIiHULcauRIiaoiBkzB5v5
        esT/Jcst5mq4ITf/qZAMrEvk4bmYlGjZ+2NK
X-Google-Smtp-Source: ABdhPJy11iF1U5Gg31PJTjzzWsMNeJJQM03EwsvI5ddw9kolKkv9L/HWcPGuBagxjqLN6BWNwzPnrg==
X-Received: by 2002:a17:90a:2aca:: with SMTP id i10mr36640840pjg.110.1622037723549;
        Wed, 26 May 2021 07:02:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 15sm15084458pjt.17.2021.05.26.07.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 07:02:03 -0700 (PDT)
Message-ID: <60ae54db.1c69fb81.eedce.145d@mx.google.com>
Date:   Wed, 26 May 2021 07:02:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.39-106-g0f7327dbee2b
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 116 runs,
 1 regressions (v5.10.39-106-g0f7327dbee2b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 116 runs, 1 regressions (v5.10.39-106-g0f732=
7dbee2b)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.39-106-g0f7327dbee2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.39-106-g0f7327dbee2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f7327dbee2b8d63bf4a4d7dfebf0c1116c54a70 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60ae24d96f4a5e22f1b3afae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.39-=
106-g0f7327dbee2b/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.39-=
106-g0f7327dbee2b/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae24d96f4a5e22f1b3a=
faf
        failing since 0 day (last pass: v5.10.39-104-g15b194ce40af, first f=
ail: v5.10.39-103-g5d71e5f41792) =

 =20
