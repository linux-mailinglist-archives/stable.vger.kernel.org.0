Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DACE504EE4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 12:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbiDRKmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 06:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237719AbiDRKmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 06:42:06 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FE215A32
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:39:27 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t4so18188050pgc.1
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uH6R+rtJOHQXFUA4R2a9xFNeFL22zfftC3NrNwbOaLw=;
        b=tLPYUGWK80s6n13L5hRf76zo4IH9TDy94ERxf5DB05ZShDnQSGszzsT3tfvrpaaZl6
         SxxXQrzisVkOtz9o5Ft6jk6aTpZMzOELt35QKFH/bDOjJdBn22OHks2YJfv4npkOawyp
         4tl6l7horRoQ9XEDSHsXFUlEz1QnevY5S7e6gMoEZXVNhN0JSAl6iXLLf2BzXU2I0G1/
         BrtCo5WfcDa0vgzyTaYNGh6orzk5iSKPKUSKd1Ehvka30Px/Lar3BR/oDQ0LxOIq9VjP
         H7toCABBy86DijqiZud6vx0OObxtFnLNzGlT6jA23Nbx1Brv8cQDL5G3jqUm9N4iQK0b
         dCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uH6R+rtJOHQXFUA4R2a9xFNeFL22zfftC3NrNwbOaLw=;
        b=24RzLmtGQFtHnG4d5NWljffAa/bRY8uoCiR7ezW8piqXbzHzhlnEn4OEkn8NyHD8/I
         L4rHolEcbojUyuwKPW9loRCDQBqcV22jOwx5YdItL2yhMfltqRWEneXoP79+FLtDuH3j
         jZY2XS4pVohkU2RAEGQ8v3kQkpWaZbkB5n+grb178xbTVpupVPk+HeHdZD8woMuhUS3M
         4mJqvKJHnGODVq7u95rzGHkvbBe9WoJshuRNrmKYTWiHWXvx7gmZLu/eJ8zuqtnhUsjJ
         A1Fb38latzmoVXYZjJZFLV17hRc10ScX5kcXqb/ayfjvZo3ORVaHLA5FH4X0PaM0NYfF
         vqCA==
X-Gm-Message-State: AOAM5324v/EgPuAbO0j/84B8V48+cCcGVpfa+WX9JWjImvsVKaeGnL88
        or1LvfZYritJRB+QLu2LeAiUMYJAwyEXjLUY
X-Google-Smtp-Source: ABdhPJzGDOTnLdbxuuZGha2tPx4Stlf2618u0tICm4h+u7rtCX+pdJ0a+MOyDZs6fsHZ83X1kpPfag==
X-Received: by 2002:a63:f743:0:b0:3a6:6786:30b1 with SMTP id f3-20020a63f743000000b003a6678630b1mr8028179pgk.243.1650278367355;
        Mon, 18 Apr 2022 03:39:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14-20020aa78c4e000000b00506475da4cesm12046528pfd.49.2022.04.18.03.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 03:39:27 -0700 (PDT)
Message-ID: <625d3fdf.1c69fb81.e0674.c372@mx.google.com>
Date:   Mon, 18 Apr 2022 03:39:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.111-6-g7cadc9e27fbc0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 146 runs,
 2 regressions (v5.10.111-6-g7cadc9e27fbc0)
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

stable-rc/queue/5.10 baseline: 146 runs, 2 regressions (v5.10.111-6-g7cadc9=
e27fbc0)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.111-6-g7cadc9e27fbc0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.111-6-g7cadc9e27fbc0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7cadc9e27fbc0d0d6c276a4138280cd205e5e0fb =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62596791cd2d5f1242ae068b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-6-g7cadc9e27fbc0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-6-g7cadc9e27fbc0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62596791cd2d5f1242ae0=
68c
        new failure (last pass: v5.10.111-6-gc2210c2901b40) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62596e88ef7b815613ae0685

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-6-g7cadc9e27fbc0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-6-g7cadc9e27fbc0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62596e88ef7b815613ae06a7
        failing since 38 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-15T13:09:01.164750  /lava-6098398/1/../bin/lava-test-case
    2022-04-15T13:09:01.175090  <8>[   61.060800] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
