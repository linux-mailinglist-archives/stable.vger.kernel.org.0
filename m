Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFB54D909C
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 00:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240148AbiCNXua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 19:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiCNXu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 19:50:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7C6286F9
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 16:49:18 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id a5so16743549pfv.2
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 16:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1j5D87Vu4GXUWPoRuraZy8AnwFCnQbp995LXrErmIvY=;
        b=k/NDTN8uNglzK3mvCxXSgNO3ZQ2L9G9WWWNVVIbXD6+n1equTqa5eF5OrY6jPIH6NC
         ia9ikPRc+HNCFtuqmMD1mDGow9eL7MP9NyDeiZO2gr6ZW6gjEKptkDLn8viPVi5hADI1
         7DzPjsQw+A6AxcKzt4lETJPIi+RuRZQj+9Rqb1mW8bF4tUPDOKTmEMbLhIEnTY1adqHm
         TGgqoz5J4Jl50k0sNIJR0Ekjs/ul0VtKh07ZCvBho77GLf8UQgJgS3hTWmvyPZICzqDZ
         l2D2o2pKRWP+nAzh/h6m7kAfabhzeV8TecVvz7+clRIPUcLdHim6ltt8uqEeer8pL1/5
         MOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1j5D87Vu4GXUWPoRuraZy8AnwFCnQbp995LXrErmIvY=;
        b=4mcayWvU09LQ3k6FQ15b2Hda9PNJPRxnZZvrWl/4cC4aryD6nIhSSIGft5Pg6sN+uf
         tJuiQwhJUX4X4r5B82ccOruVDQm9frMyf1MkGKGqlW46dRT33JEdDWriZh0bm8XqDAP+
         RiAMc5TWdJQxMxgX/rMaPtezJLijoJflwvn3UwOnoL94RKWCaZDph6247qBh28px5EhG
         5D7KkHtWCeEpnuVxgb1Ry4gbVJwVEiMUT5MC4MXP09q+jwkJP1AGqtKl1hqxIqHI/+GW
         MKq1p9JQtdjEofXROOVLk49FCDBxgBdGHNx9nMYBPtoH3hb+0+VqI65gC1GA1+gF2NYU
         BYaA==
X-Gm-Message-State: AOAM533IDJrTO7zJoK685te2kLYgs4+lZv2HuUgIyrLsMgUSadoe6+ZG
        9MikF/yVjQ7hGLmlaosnJo9RoWpp2+sVwRcoCEw=
X-Google-Smtp-Source: ABdhPJzDAG1szD/LCGR5NYQIVQobOjbYIZXJgpLFhdMYXIy1eHZjtTLmR3NsA/lFnLb8mxftX4p7uQ==
X-Received: by 2002:a62:7a10:0:b0:4f6:9396:ddde with SMTP id v16-20020a627a10000000b004f69396dddemr25671483pfc.82.1647301757804;
        Mon, 14 Mar 2022 16:49:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11-20020a17090a280b00b001bf23a472c7sm621232pjd.17.2022.03.14.16.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 16:49:17 -0700 (PDT)
Message-ID: <622fd47d.1c69fb81.ac994.2518@mx.google.com>
Date:   Mon, 14 Mar 2022 16:49:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.234-30-g4401d649cac2
Subject: stable-rc/linux-4.19.y baseline: 94 runs,
 3 regressions (v4.19.234-30-g4401d649cac2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 94 runs, 3 regressions (v4.19.234-30-g4401=
d649cac2)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
hp-x360-14-G1-sona   | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =

meson-gxbb-nanopi-k2 | arm64  | lab-baylibre  | gcc-10   | defconfig       =
             | 1          =

rk3399-gru-kevin     | arm64  | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.234-30-g4401d649cac2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.234-30-g4401d649cac2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4401d649cac2c3bf2cca0caf51a27f17b4f8bc26 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
hp-x360-14-G1-sona   | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622fa15b2b0d591672c62995

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34-30-g4401d649cac2/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34-30-g4401d649cac2/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622fa15b2b0d591672c62=
996
        new failure (last pass: v4.19.233-34-g7603caa5cc11) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
meson-gxbb-nanopi-k2 | arm64  | lab-baylibre  | gcc-10   | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/622fa492253c98839ec62976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34-30-g4401d649cac2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-nanopi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34-30-g4401d649cac2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-nanopi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622fa492253c98839ec62=
977
        new failure (last pass: v4.19.234) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
rk3399-gru-kevin     | arm64  | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/622fa029d59881cc6cc629d8

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34-30-g4401d649cac2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34-30-g4401d649cac2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622fa029d59881cc6cc629fe
        failing since 8 days (last pass: v4.19.232, first fail: v4.19.232-4=
5-g5da8d73687e7)

    2022-03-14T20:05:49.046116  /lava-5878105/1/../bin/lava-test-case   =

 =20
