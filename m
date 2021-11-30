Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05ED462919
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 01:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhK3Aad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 19:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhK3Aac (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 19:30:32 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F18EC061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 16:27:14 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so12752808pjj.0
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 16:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fd3o29lF2YfeH6YTmaexwfW1h6mz1x5AQhEBFHyPe7Y=;
        b=U6Xli+ByO0MA3zVJQWcqTJ/qFciwZAyb9nRpfzzUqIO16paZZVwQ/ZlJZvjQCkLvVp
         ktybjz/hzWeeiY6AoZpozWX2EjU9XAWZHrsQWLjy4rTY97vDVZaCmKCBO2fhhjqAveN3
         CHt+4ex4oAWXhrhFNe/apbtQbO2pziCY/04T0UJ0hlPTBuZIyt6NuMAjgqel/bMoDeCH
         srF1BRZRBQGEkxhJW2Shg7famFJ6mZvRe4ZcwC2WpMHc1xB+mdRDvTi8KfuzyDQe+HJJ
         Fk4fBWngQrwnYatFtyXDjkvFqQI6iO7CpMtgEUqB05hgGvceITYEZJVPMgNXJcFZcnfv
         dxLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fd3o29lF2YfeH6YTmaexwfW1h6mz1x5AQhEBFHyPe7Y=;
        b=hkYmL/wzlT/zao4Vj9z/6HjtviefgjgjAw24AWPZNu7fmP1KfcTO1cHTMozDquNlod
         qF18zI4xVQFxkN9H352Pzncvb8aZpZezXQdMp1Ret/Gm7m3kNewyDmaqg9YqTv5Vp0rd
         8PnHlsaBuxIW1FRIS3YSfGGCmxoq8rC6R2AldZVvTgOmETbIQePc8Eo5MB0k0ApPtiAH
         jY1D+IFifOD+y3LUlGO+hm7fIP1rAAGrXLKXo9PpdmoG+5TRRie2g+yw7EM66SHajwgm
         EqWwtw0UM5rJNRyk9rri5Avcp5pBqMN52/t/tkult0GX5150e+Ibx6wOlCqF/UemDeVv
         zbBQ==
X-Gm-Message-State: AOAM532iCL1hm/v8M9BM3UYMupCmQ7rKknagOZF2dGtFpkRfoNDqI9y9
        CIIYSogo8WkKFcpxI7qxsOm7TYph5iB/nygp
X-Google-Smtp-Source: ABdhPJwy9bPf+T35mIeM5wjvlNq5gBMfGfKnkYdPTWvDU7bssb4Xj/n/mX1kCo3cajuj3JvkXJb70A==
X-Received: by 2002:a17:90b:1d90:: with SMTP id pf16mr1731882pjb.93.1638232034021;
        Mon, 29 Nov 2021 16:27:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm19490867pfi.154.2021.11.29.16.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 16:27:13 -0800 (PST)
Message-ID: <61a56fe1.1c69fb81.37587.4b35@mx.google.com>
Date:   Mon, 29 Nov 2021 16:27:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-31-g052eaf60dbd3d
Subject: stable-rc/queue/4.4 baseline: 67 runs,
 1 regressions (v4.4.293-31-g052eaf60dbd3d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 67 runs, 1 regressions (v4.4.293-31-g052eaf60=
dbd3d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-31-g052eaf60dbd3d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-31-g052eaf60dbd3d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      052eaf60dbd3d77bfccf330c6f6a8b18ed82985f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a53a23043e8371da18f701

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
1-g052eaf60dbd3d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
1-g052eaf60dbd3d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a53a23043e837=
1da18f707
        new failure (last pass: v4.4.293-21-gba114a7ef1f9d)
        2 lines

    2021-11-29T20:37:44.133168  [   19.144622] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T20:37:44.183128  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2021-11-29T20:37:44.192633  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
