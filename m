Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA616B5FD9
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 19:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjCKStj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 13:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCKSth (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 13:49:37 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF6D856B2
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 10:49:34 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id cp12so5516389pfb.5
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 10:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678560574;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QyXQF1olTrCviT/r5IUYxkGgVcTlcXRxot3HeFFz5mc=;
        b=iA7L6w7gEdDe3VyGlkZc02Lc9tZpuJztOJfEQx3c8WWbAt8u4++ItTnCuTbSp8x/lR
         XSgygbeDTRNJNyWMNOZbBBeitr5N3jzcahYgpfGKzDnkwbsZujYajT7sCNnQ6uHOfDQE
         GFo99QXtCoS3rTcONwuA9X2kELbSoQVRt07eh1Jg8hjRd8/TopLBpI1NM/TBqnWerDYn
         +MGUcOO9a6UO978n/ivRJ0xGQDw7fa9Q4CL41H/VLI11nnVLMwtwYQFKywqrl6hhgZrK
         KtPX9gYe13gGLuMa8Kf0FW2dX6sehV8wY5oHJNj75OwN5IKBomgu0GtF7WW9AOQfTnJC
         4b/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678560574;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QyXQF1olTrCviT/r5IUYxkGgVcTlcXRxot3HeFFz5mc=;
        b=fuftXqOSkhm24bMyYoGJoqPC/cxlJCOLLnTk1tlKIpPLAd725yT4Tg+hSJ3YTCpewM
         R555Tq2HMA2thjmpNdrFJSsvoFitOmqf1nB/kZtYT4lVrHPyxnEtm15CM8EUhCUOvUHq
         BHoalWfzp6dq2uoF+AFb5AkU5cfvEjiuIYnS+S4wkkluSCiA3LnD/9pCuDdNdYHgjTab
         oLhVX827JCt9BHWYYLIYEw/118B4E4ix12+lxbl9V4IKhVvXOZEqwa+UMKwo0meqxtN7
         esyr6ZjcXMYoepWAYaA0u+EFbaHZyW6FdgBEUWTIm3Qdm6k2hla6SpIfzZy3qgSl2dR6
         WbPA==
X-Gm-Message-State: AO0yUKUvIDYXvBck6qvOmGJUcbRZVFNWQOGjFSHyC1+SUnRR7ad2aRKY
        41XsNXWf0JT5+NSf47mJwi0fn3nrL/QFA7G0FBw6sQ==
X-Google-Smtp-Source: AK7set+ryye1+HZFyr4dn37LKlELcOjOYnB2iMTW7yWmLeuvJjdYD7RlYtTjjg9LV8PEUPLOGi8QeQ==
X-Received: by 2002:a62:3285:0:b0:5cd:229e:f1d8 with SMTP id y127-20020a623285000000b005cd229ef1d8mr20043862pfy.4.1678560574034;
        Sat, 11 Mar 2023 10:49:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q26-20020a62ae1a000000b005d663989ccfsm1761227pff.200.2023.03.11.10.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 10:49:33 -0800 (PST)
Message-ID: <640ccd3d.620a0220.579e2.300f@mx.google.com>
Date:   Sat, 11 Mar 2023 10:49:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.17-200-g45d6ef55e66a7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 181 runs,
 4 regressions (v6.1.17-200-g45d6ef55e66a7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 181 runs, 4 regressions (v6.1.17-200-g45d6ef5=
5e66a7)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
mt8183-kukui-...uniper-sku16 | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig           | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig           | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.17-200-g45d6ef55e66a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.17-200-g45d6ef55e66a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45d6ef55e66a77fbdbf3be804783d2ac51ae1657 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
mt8183-kukui-...uniper-sku16 | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640c9d6ef0111990978c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.17-20=
0-g45d6ef55e66a7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.17-20=
0-g45d6ef55e66a7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640c9d6ef0111990978c8=
630
        new failure (last pass: v6.1.16-200-gf1fc28d9870a) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640c97d3ba6d0eb12a8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.17-20=
0-g45d6ef55e66a7/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.17-20=
0-g45d6ef55e66a7/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640c97d3ba6d0eb12a8c8=
631
        failing since 6 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640c989652746505c98c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.17-20=
0-g45d6ef55e66a7/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.17-20=
0-g45d6ef55e66a7/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640c989652746505c98c8=
635
        failing since 6 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640c97b706782e95ac8c869f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.17-20=
0-g45d6ef55e66a7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.17-20=
0-g45d6ef55e66a7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640c97b706782e95ac8c8=
6a0
        failing since 6 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =20
