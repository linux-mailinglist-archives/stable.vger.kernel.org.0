Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3EF471CCA
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 20:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhLLTsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 14:48:01 -0500
Received: from mail-pj1-f42.google.com ([209.85.216.42]:56248 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhLLTsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 14:48:01 -0500
Received: by mail-pj1-f42.google.com with SMTP id v23so10416023pjr.5
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 11:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DdHk0Pm/5y4yquBTriMCviqBn/vAHZRkrSSmhie2yis=;
        b=DKjlTqvMDxoxLmj5wTJYGmL3e5G4K3hbe6yk5NK2DYTL9ULEZnFBX2YuHRhctK9/V+
         liFNWUxVpaxEO6Pa1+cesg4YmNr1osqdpXNLH2cVWuAEXM0S4AydIrCWTzdDR7eHKD6x
         +p9Xi4BxYNe/NIQqOMPS0CRSNSmkJjEntoeE2mEV6u2i6dObv3g0u7EZ5g1vHW56tind
         /ttgtxx1+IoiYimvySfnNDsgPMeSZlh9Lazqz0KbRx2UGKJFC6Izug9UnJa/vOYd+8uD
         HGhVXpleem8f0lgcF3lVZgDjfgdvKtbTXDMGTkyLka6pmVgDSY7Zo/GSB3hrLHKEMJtL
         K0LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DdHk0Pm/5y4yquBTriMCviqBn/vAHZRkrSSmhie2yis=;
        b=cPxqOmoMvX4qvk5/KFIG1HZd46WxA4FxTxh5FU6APl2ihOvdSm5YF/sxbK2DWqVysU
         XGBwY9Rd5gSEMEFgCLZizTnxJ1SXxpUlqjRyciepMwULtQC2eqgW3acaqQn//O5bm8J9
         z+Bvr0RiD5zV/ueeTbM+Tm1e1Sr1kxSWVFYqoj7+xDy82rp7aoxO1oXJALMA+b08l5vH
         nolM8EkucWeghy+n+nawxIG9koWIr8QHaUriG9ivDLvY8CGBPNNOvizaMC/T8mz3PNiP
         4yV2+pSvCTVnn971dOtMNSNgQ6gJQJaTvdl/RII+B9rRdk+4Nm5NaINGFfaxaKE8Hoe8
         le0Q==
X-Gm-Message-State: AOAM532kQpIXxSjNPwCMgreaayeZM6mZPETz1kVKOf4AigJvLnXiWyQN
        I8In+bA9+avVh4gedMI44DZ6pdZhNe7Z51we
X-Google-Smtp-Source: ABdhPJyt5KezM9/RepIc479Hj7sKEUvBK8/+ylikm9QEsqnaKaSXMwSZvTEbO6YBuquvjHUyjBfAWw==
X-Received: by 2002:a17:90a:be0f:: with SMTP id a15mr38794788pjs.243.1639338420971;
        Sun, 12 Dec 2021 11:47:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm10138870pfi.178.2021.12.12.11.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 11:47:00 -0800 (PST)
Message-ID: <61b651b4.1c69fb81.8879e.cb4d@mx.google.com>
Date:   Sun, 12 Dec 2021 11:47:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.7-135-ga62a1a0c8493
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 180 runs,
 2 regressions (v5.15.7-135-ga62a1a0c8493)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 180 runs, 2 regressions (v5.15.7-135-ga62a1a=
0c8493)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

rk3399-gru-kevin         | arm64  | lab-collabora | gcc-10   | defconfig   =
                 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.7-135-ga62a1a0c8493/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.7-135-ga62a1a0c8493
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a62a1a0c8493dedc2c9ff63c4d8a783b4298a877 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b616fe9668f453b6397136

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.7-1=
35-ga62a1a0c8493/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.7-1=
35-ga62a1a0c8493/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b616fe9668f453b6397=
137
        new failure (last pass: v5.15.7-56-g43f366b5107c) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
rk3399-gru-kevin         | arm64  | lab-collabora | gcc-10   | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/61b617da7a75bf6639397137

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.7-1=
35-ga62a1a0c8493/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.7-1=
35-ga62a1a0c8493/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b617da7a75bf6639397=
138
        new failure (last pass: v5.15.7-56-g43f366b5107c) =

 =20
