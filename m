Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A050B3CF2F2
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 05:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbhGTDQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 23:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349220AbhGTDOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 23:14:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B13C061766
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 20:55:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gp5-20020a17090adf05b0290175c085e7a5so1177205pjb.0
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 20:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZzGdn95NN96yACey+M1yPbZGcMuqY+uWldofw5CTeK8=;
        b=j3MCxYrgQkJ4+0JCS3cOpCSZ6wFCrHTyXf5ANwPf5fna3cdBmJpm5DwZK5Q+A1jkye
         NRSR+gXmmS1YKt118wFNTif+dVuJqt9QnoYtBOamTvzVp57+evfTU+RPfZLrP3yl0sSU
         gSoBVQdeVPTWWJH34x9ARrWhpwh/KnXRa6rGnks7wM59nsiNqYGruwhI1gRnR5D1o9iL
         4qXtQYoQHHVT++R57ysmTuGA0Xoayi3kDZxmtu2i7CbCVxFQOsTZ6gxE3SH5o/+6rsCo
         DUrVbUpBIABXZPJEDgFjQ5TwpLfOuqzVh1rUlt54oSZ4Er3lkcuZpSLQwF5oZg9re2Ww
         cfjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZzGdn95NN96yACey+M1yPbZGcMuqY+uWldofw5CTeK8=;
        b=mGAichKGklKY3+ATbCjFrcdHhD5KnboJwTI96OiJOF8sU1I3gXiCF5C8iGJj7gAqSL
         X5sphshcSD3eI8OULwXrz/cgWb9bpodvZs0xT9avA7AxbxsnQ4Xw4wR9qweXeSDuGc+u
         OE+CDOoNqw2lQIZy+EVLEzEkagKWBPPrj5clKisfs5haKLMRJXUbObrZoduqtGbOJtyx
         q1fdh8uu5nqwcQrH2j2hK1ZOnwWwzrFXoLggcw2l9NVXvHUZCPjhPPTWC6CcAM9o/gjW
         QTSJ5LsPC4AU70JyUFGj3vWd0ge07brflLpLU3UR8H4WjTuleE2NYsUyVuJ4HiR2qexO
         Thzg==
X-Gm-Message-State: AOAM530azwBqC4RxFnHnaifx/GO1ipjV58YlvKvbuQ3a16YS1CBwMJ2m
        J9pONJWz+313lslBt+EOpLlMac3EI4e53w==
X-Google-Smtp-Source: ABdhPJw4XFimLPe5BVRJdTv5+UKXXANko78RiwaApwFJIRfH44g7doRJLAA1ZhVUf957i5j9YDIUVA==
X-Received: by 2002:a17:903:22d0:b029:12b:1215:5e73 with SMTP id y16-20020a17090322d0b029012b12155e73mr21979788plg.60.1626753300778;
        Mon, 19 Jul 2021 20:55:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5sm21385784pfb.114.2021.07.19.20.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 20:55:00 -0700 (PDT)
Message-ID: <60f64914.1c69fb81.dd988.0800@mx.google.com>
Date:   Mon, 19 Jul 2021 20:55:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.51-240-g665c847fa9b6d
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 189 runs,
 4 regressions (v5.10.51-240-g665c847fa9b6d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 189 runs, 4 regressions (v5.10.51-240-g665=
c847fa9b6d)

Regressions Summary
-------------------

platform                | arch   | lab             | compiler | defconfig  =
                  | regressions
------------------------+--------+-----------------+----------+------------=
------------------+------------
d2500cc                 | x86_64 | lab-clabbe      | gcc-8    | x86_64_defc=
on...6-chromebook | 1          =

d2500cc                 | x86_64 | lab-clabbe      | gcc-8    | x86_64_defc=
onfig             | 1          =

qcom-qdf2400            | arm64  | lab-linaro-lkft | gcc-8    | defconfig  =
                  | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe      | gcc-8    | defconfig  =
                  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.51-240-g665c847fa9b6d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.51-240-g665c847fa9b6d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      665c847fa9b6d58f543e0fb13cc7b95ddba7cccd =



Test Regressions
---------------- =



platform                | arch   | lab             | compiler | defconfig  =
                  | regressions
------------------------+--------+-----------------+----------+------------=
------------------+------------
d2500cc                 | x86_64 | lab-clabbe      | gcc-8    | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6110c280a6e55e0116103

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-240-g665c847fa9b6d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-240-g665c847fa9b6d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6110c280a6e55e0116=
104
        failing since 8 days (last pass: v5.10.49, first fail: v5.10.49-581=
-g85a3429452df0) =

 =



platform                | arch   | lab             | compiler | defconfig  =
                  | regressions
------------------------+--------+-----------------+----------+------------=
------------------+------------
d2500cc                 | x86_64 | lab-clabbe      | gcc-8    | x86_64_defc=
onfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60f61260579403d1731160d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-240-g665c847fa9b6d/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-240-g665c847fa9b6d/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f61260579403d173116=
0d4
        failing since 8 days (last pass: v5.10.49, first fail: v5.10.49-581=
-g85a3429452df0) =

 =



platform                | arch   | lab             | compiler | defconfig  =
                  | regressions
------------------------+--------+-----------------+----------+------------=
------------------+------------
qcom-qdf2400            | arm64  | lab-linaro-lkft | gcc-8    | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6153dce40cf17c511609a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-240-g665c847fa9b6d/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qd=
f2400.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-240-g665c847fa9b6d/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qd=
f2400.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6153dce40cf17c5116=
09b
        new failure (last pass: v5.10.50-216-g36558b9a3bb7) =

 =



platform                | arch   | lab             | compiler | defconfig  =
                  | regressions
------------------------+--------+-----------------+----------+------------=
------------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe      | gcc-8    | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f615924c6f97685f11609b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-240-g665c847fa9b6d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-240-g665c847fa9b6d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f615924c6f97685f116=
09c
        new failure (last pass: v5.10.50-216-g36558b9a3bb7) =

 =20
