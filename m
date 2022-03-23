Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9994E5427
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 15:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiCWOWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 10:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiCWOWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 10:22:17 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA14A7520B
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 07:20:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mz9-20020a17090b378900b001c657559290so6557198pjb.2
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 07:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vNEgN6IAMwGa6EKwF4tL8HzAsV17fepg+pe7Sr/0X4o=;
        b=OJwKC41dgEfrAUjrwz3+aMejCSoekrws3SjQMpgoYZQTiB1/u8z4YJpnW582iK6kSa
         eM9Z79bk214Ug/6vQrjtDAA0Oyq20QfMq3L8TPZaxTnJ8ejyA63ipaSRi7MLGcxmE8Rk
         eSMWbXsW6YCcxKe9lHvkwn48fU8czX880GKKQnnqTYDEmeulZVvfi+p++eeCAOcf7BGj
         q6gQmj5k1KKouGH/UgaX4UsLt+1gSA6CNzSynhtUurunQssidO8p9/WUDLi6VDfoodJS
         Vuf23XSqO2Bf4cflUmw5ssbm23xTpVuTUguUwEmjO5DZBlYMmvQlHqjvHukdbPGy4lu2
         a/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vNEgN6IAMwGa6EKwF4tL8HzAsV17fepg+pe7Sr/0X4o=;
        b=JnGAHap0SLoj8D/53sp5XKg/ZX3CK6lXCC5ykZzonFzpmYTXxOwpsMHh1gPATtOJfs
         F4Z8SZe//DRSTZ+MqAscqfxHSfD+jg+7RS7/KJA/rWdj22MedqCludJQ3VFy5tV+uETr
         FkUsDJJl0QtSpvvocl4Gfb2m3Gqu015azqK+6AQnN4pNFpBhsPqWuMzdR6Tk9cBv7rLZ
         kgTGzm2G5Av7oNoQdyEsQFSmomvBGsJbX63xvi8P88l3SxsNpwTl2ASFYj7VCYH21432
         GJsfJHagkNlGQI1/xDsEK15bqKVaXSHIc6sBcR6OrplS9+w+Eq6tafZRB8gP+tOOiruY
         QlVA==
X-Gm-Message-State: AOAM530az5bWnEpHOuDunFl7HFJdx6qLv8S4dwAZT7ewEuTw9p+sp/cV
        a4fqNYTc4QiLTfaBsTzROKiztHsYlH8iAFoC8tg=
X-Google-Smtp-Source: ABdhPJwLe+HI2LLNBMSSA6Z1DxD7z3X7/WZ0yvobDt/yI3lM/rfdrUm8wi5ULVcuQiczDtSsLGgljA==
X-Received: by 2002:a17:903:183:b0:154:61ec:74a3 with SMTP id z3-20020a170903018300b0015461ec74a3mr58037plg.69.1648045246945;
        Wed, 23 Mar 2022 07:20:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020aa78890000000b004fad8469f88sm144497pfe.38.2022.03.23.07.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 07:20:46 -0700 (PDT)
Message-ID: <623b2cbe.1c69fb81.bdff8.05e5@mx.google.com>
Date:   Wed, 23 Mar 2022 07:20:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.30-32-g81ad8a2efaa5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 76 runs,
 1 regressions (v5.15.30-32-g81ad8a2efaa5)
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

stable-rc/queue/5.15 baseline: 76 runs, 1 regressions (v5.15.30-32-g81ad8a2=
efaa5)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.30-32-g81ad8a2efaa5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.30-32-g81ad8a2efaa5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      81ad8a2efaa532ae584cae2951656f1fc8e031e0 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/623afbca67a7397fabbd91a9

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.30-=
32-g81ad8a2efaa5/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.30-=
32-g81ad8a2efaa5/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/623afbca67a7397=
fabbd91df
        new failure (last pass: v5.15.30-32-g3c6a43a3a1de)
        2 lines

    2022-03-23T10:51:34.115072  kern  :emerg : Internal error: synchronous =
external abort: 96000210 [#1] PREEMPT SMP
    2022-03-23T10:51:34.115378  kern  :em<8>[    8.701622] <LAVA_SIGNAL_TES=
TCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2022-03-23T10:51:34.115542  erg : Code: a90153f3 aa0003f4 2a0<8>[    8.=
714483] <LAVA_SIGNAL_ENDRUN 0_dmesg 102173_1.5.2.4.1>
    2022-03-23T10:51:34.115697  103f3 f941ac00 (b9400000)    =

 =20
