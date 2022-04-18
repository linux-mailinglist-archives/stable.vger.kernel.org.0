Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAA2504F91
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 13:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiDRLvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 07:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiDRLvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 07:51:36 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D16719028
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 04:48:57 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t12so12139273pll.7
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 04:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=amNtr9ocslKEFG5zHNz5DAKNmfmq081nXUN0cZb3WwU=;
        b=oy9KhzToPZStOuD87N1Fs/d5lIIigyzfsv9LJ8gEfRUNBEOn/tqch8uLb1wPvA5eBw
         BIaYXbrlAuMUwomv+KlO5LBDnJV6Z6+x3FxWRrr6r05Gat5O4iUzO0eyWDamlVqOgbZM
         S2JKXUrxFvLXEF4qCzR6IzHDMaQAp1CGbH/gwfqNyK9iZWzU4P+5HZ2//ZhDiKAM/uFG
         pfdpPXzLVv1JZJbhbYfbmfTXLCbFVrO/iQXM3d1GG+xVawLG6KZcIcOxRVCtdkYjR0OZ
         ZWQkcEXhaIGgD0EbFGqHi7IZ2wtA/MIoBuYpPRQ4k4edxZzO4RFlSpE/AKD0O3zTw5l4
         OrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=amNtr9ocslKEFG5zHNz5DAKNmfmq081nXUN0cZb3WwU=;
        b=L4ygXLlKTIMWhbKIS6SC+b4Fsx4+opmnTThJlz9eOo2xVS+hOMI/Ik565mfPxbn2Bw
         qEgB8X3vRESAKEDBYywlDOPwpbjexVwlHJl/VK1BKeaOMBy3KdoCHP8ySz0u65JWcnAG
         gMml6/TLHbdZ7/Ra/ZsW8mqt4wsmp3vtjbV9xGggEyaCau9qtHQ7JNI0anUYwI6kKttt
         MM1rnLwxFmFFDpzdTc3dBRTebUUkTmB4ussnRigddHB4UL7TCWeConIXFN+DnPU7B30Q
         OM6Q2PnjZhHtYI1C90Lf2nWoR2fuY9pNGxw32I4Fy07XKHDYXE/rdPJ8wC+HDT6zRcCZ
         PYqQ==
X-Gm-Message-State: AOAM531uQGOWYxrlhnHyE0fLA9GQjjahsmVeljbzTCtk4kWdIYSJg/xh
        5Elf3DfY0J2Hw0yWoJspD3Ya6dW6I4frxcXw
X-Google-Smtp-Source: ABdhPJy1zN31pDNc0vdmtiqdb+fpBtRb/t+OU59+Ma0dFOb5uVEQhD5G5qTKvOXsccfwdJ1matHKUA==
X-Received: by 2002:a17:90b:4c12:b0:1cb:4b66:2dc6 with SMTP id na18-20020a17090b4c1200b001cb4b662dc6mr12548843pjb.140.1650282536546;
        Mon, 18 Apr 2022 04:48:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l22-20020a17090aaa9600b001ca7a005620sm12603061pjq.49.2022.04.18.04.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 04:48:56 -0700 (PDT)
Message-ID: <625d5028.1c69fb81.a2e20.e399@mx.google.com>
Date:   Mon, 18 Apr 2022 04:48:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.238-22-gb215381f8cf05
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 105 runs,
 5 regressions (v4.19.238-22-gb215381f8cf05)
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

stable-rc/queue/4.19 baseline: 105 runs, 5 regressions (v4.19.238-22-gb2153=
81f8cf05)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
    | regressions
---------------------+-------+--------------+----------+-------------------=
----+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g   | 1          =

da850-lcdk           | arm   | lab-baylibre | gcc-10   | davinci_all_defcon=
fig | 2          =

meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig         =
    | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.238-22-gb215381f8cf05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.238-22-gb215381f8cf05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b215381f8cf05a2661880f13e11321d475848592 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
    | regressions
---------------------+-------+--------------+----------+-------------------=
----+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/625d2106b13a1ad519ae0686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-22-gb215381f8cf05/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-22-gb215381f8cf05/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d2106b13a1ad519ae0=
687
        new failure (last pass: v4.19.237-335-g5bcecb0e64a0a) =

 =



platform             | arch  | lab          | compiler | defconfig         =
    | regressions
---------------------+-------+--------------+----------+-------------------=
----+------------
da850-lcdk           | arm   | lab-baylibre | gcc-10   | davinci_all_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/625d1c69d5df025c39ae0681

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-22-gb215381f8cf05/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-d=
a850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-22-gb215381f8cf05/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-d=
a850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/625d1c69d5df025=
c39ae0688
        new failure (last pass: v4.19.237-335-g5bcecb0e64a0a)
        4 lines

    2022-04-18T08:07:43.656833  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-04-18T08:07:43.657110  kern  :emerg : flags: 0x0()
    2022-04-18T08:07:43.657278  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-04-18T08:07:43.657431  kern  :emerg : flags: 0x0()
    2022-04-18T08:07:43.726715  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-04-18T08:07:43.726917  + set +x
    2022-04-18T08:07:43.727080  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1832115_1.5.=
2.4.1>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/625d1c69d5df025=
c39ae0689
        new failure (last pass: v4.19.237-335-g5bcecb0e64a0a)
        6 lines

    2022-04-18T08:07:43.481617  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-04-18T08:07:43.481916  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-04-18T08:07:43.482088  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-04-18T08:07:43.482242  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-04-18T08:07:43.482391  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-04-18T08:07:43.482537  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-04-18T08:07:43.519059  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =

 =



platform             | arch  | lab          | compiler | defconfig         =
    | regressions
---------------------+-------+--------------+----------+-------------------=
----+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig         =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/625d20c83ec82d1bedae0695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-22-gb215381f8cf05/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-22-gb215381f8cf05/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d20c83ec82d1bedae0=
696
        failing since 17 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform             | arch  | lab          | compiler | defconfig         =
    | regressions
---------------------+-------+--------------+----------+-------------------=
----+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/625d20c9f3a724c8bdae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-22-gb215381f8cf05/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-22-gb215381f8cf05/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d20c9f3a724c8bdae0=
67d
        failing since 12 days (last pass: v4.19.237-15-g3c6b80cc3200, first=
 fail: v4.19.237-256-ge149a8f3cb39) =

 =20
