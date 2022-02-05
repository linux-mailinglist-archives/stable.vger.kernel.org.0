Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E394AAAA5
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 18:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380759AbiBERhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 12:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351942AbiBERhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 12:37:53 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0480EC061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 09:37:52 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so16123092pju.2
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 09:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GiCsnfVSp7E2pYo4iRtcOKNgeG5U7LHvg6sZQxhy0RY=;
        b=wggHmvV286kL9l5Ho8+qAfoGhs+V4qUIH9GzcIDDQk93kS/3pT3PiEQXc76eLm2UCf
         Ne5MWJix38T5ylvWbvKJs00ReNq+GlK+81Qt9z78q1vhDG9pgEoffuTpTNaLvDYVXflg
         83G9amPQZrhpJTErQKA6xH8tsT9ncLMTtdesnsKeCxRx3uu9+GPXhzzeTrh59zGEnE2I
         T7SlWKOZVbZuTT5XvNIoD0ScpJyc6amBSngw4QLzQSHrBRACh3NJL26NhKlsKVEpjYd4
         RWC/wnIOCEJGypNe2Ec7j8JyEQl7uONTynjrOwGwekhcJqhpg0xZ3ch1C9kpgePVQd5V
         tvrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GiCsnfVSp7E2pYo4iRtcOKNgeG5U7LHvg6sZQxhy0RY=;
        b=pRaL3AfzxfJ3u8wyVEXeN4pcmV3zegF8Gm7sn4TWvM5htO1ocUYKpNfe3u88dBNWt5
         2osL9d/1TP/wA8U+3BuhDLcSG+nDX3zr7xRfd9uMacaUwp0D4Dr34s8G0sOD1BKBzLhu
         J9yhCqLhdTE+Xunzt92fl9jPbLMNQAjt89QdhxZEeiJ4jjiNexVbAjs/zvW6fhaEPnZH
         4HR8/NaFKGbo6kPfEaPjuW1CD4VIx66fjyaON5PLYHE7f+KbYZiJYpalcIxAZV3WTVs0
         dPnse09+10hPNSpL+FNyEZu5zVNR8NeIPwjSYJzzyr5BKOZl9yqOaq37g4bmEG8SbLHU
         aLoA==
X-Gm-Message-State: AOAM530nv8Bkj3xGFgXxS7RwqfZFEWXGemsAXT0E6GRXRfjXSXBV6II8
        kHqfydNrlKJTfeJHvSnVXRLCAkEtTlQpkmA2
X-Google-Smtp-Source: ABdhPJy1fnlCAS/281Q6Z4AoinfTiZbdFxxp6JkpQvagYX3ls30d6pLTX6KPRUscT/wTossz2FSYLw==
X-Received: by 2002:a17:903:2350:: with SMTP id c16mr9174548plh.4.1644082671223;
        Sat, 05 Feb 2022 09:37:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm4420031pgs.31.2022.02.05.09.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 09:37:50 -0800 (PST)
Message-ID: <61feb5ee.1c69fb81.52641.b530@mx.google.com>
Date:   Sat, 05 Feb 2022 09:37:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-45-g6b11d619aed4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 124 runs,
 2 regressions (v4.14.264-45-g6b11d619aed4)
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

stable-rc/queue/4.14 baseline: 124 runs, 2 regressions (v4.14.264-45-g6b11d=
619aed4)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-45-g6b11d619aed4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-45-g6b11d619aed4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b11d619aed45b5a59a155c650ec3441a0f80892 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61fe7a8c1b101adb3f5d6ef1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-45-g6b11d619aed4/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-45-g6b11d619aed4/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe7a8c1b101adb3f5d6=
ef2
        new failure (last pass: v4.14.264-40-g54996bdd9ffc) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61fe7e265288c11bdc5d6ef5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-45-g6b11d619aed4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-45-g6b11d619aed4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fe7e265288c11=
bdc5d6efb
        new failure (last pass: v4.14.264-40-g54996bdd9ffc)
        2 lines

    2022-02-05T13:39:33.608857  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2022-02-05T13:39:33.618153  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
