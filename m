Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB8B5BA138
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 21:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiIOTaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 15:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIOTaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 15:30:11 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4689957887
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 12:30:09 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id e5so19052981pfl.2
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 12:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=JsBb0Jh5d4lLevdDx6EEPE+jZDgUEzIRlt1m3AINPH0=;
        b=nF8I1UxeToIFMQcTBKofOQReYjyefET3h/87wKsR3mdzhhspfGIshV+2pCON9Ja2/b
         ++MAt51SlXpYCdLWxoLFp5bQMcOKi+shprNaTUE6/7OsUmy2fW+Ehj7AXgBzBt6LraOG
         eAPrvCbX9AReg2AuhdmHNiPVXigcKkgdKfWNfzBdqc3J0V4E3HN5zhAnTHFt8h6Wp7tE
         1Rz4M6FUu3aCHigqwg1ufCw1bFoefgUSQuJYWOd9x0OuxfiaE+Cez3zfH+aDUpknE0Mu
         tUDRdqW2DAdSV5n/pjUAGZC+tqPSdW/VtQ5j/QpxmTFcWE1o2/g6kRDrIKIJ4kCBfC81
         a9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=JsBb0Jh5d4lLevdDx6EEPE+jZDgUEzIRlt1m3AINPH0=;
        b=Hl/CK5W4ceEfgTtQwxKfiiMcmZ87hwPrr2bJ5JE4V7wL0obg6xolpiSt+Qr22DGZ4c
         TCXFqSvTpsrum92lOGjpfxPTvBf7f7FFhGfv+rFpd1lSVr2N7GfBSYYmTmHfpNvxfcZE
         gVy5meHeyvTlvlY4X2pCUyDFJJI2SvxWTsKpVqoCXw+vzEQpc3A3YU8IrT+vXJ0X4YQl
         O0VELcw27LGnDAs8dFRWBZwSinjuy3P9u+bpmFfuJ4zxabmHjuWJAsYLRtY6Qfrtea0e
         t4zqlk2+hwxoAa3OTMnKJOSngFarEchFzUru4rjzp3IF0w36LKBQySC7rprCYVf6d1FX
         QAWw==
X-Gm-Message-State: ACrzQf3efL9oRyttbgS9jTPGz2sP1JKGYhMQfrfedwEcm1jEgYs5lTev
        koLnwBXvPHQPsxJ1p+KuwHZMi7L1GEPVMoLM+ig=
X-Google-Smtp-Source: AMsMyM4YkM6cJ2hf4lbmfBjJaRC/UI3bcSGejTnD6I+t2pf5nGnU2YCyMbXotPoP1C4zGInXciUSZw==
X-Received: by 2002:a05:6a00:1342:b0:545:4d30:eecb with SMTP id k2-20020a056a00134200b005454d30eecbmr1315063pfu.69.1663270208634;
        Thu, 15 Sep 2022 12:30:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a184-20020a621ac1000000b00543780ba513sm10107823pfa.218.2022.09.15.12.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 12:30:08 -0700 (PDT)
Message-ID: <63237d40.620a0220.b5967.2590@mx.google.com>
Date:   Thu, 15 Sep 2022 12:30:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.9-35-gde5881df904b
Subject: stable-rc/queue/5.19 baseline: 183 runs,
 1 regressions (v5.19.9-35-gde5881df904b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 183 runs, 1 regressions (v5.19.9-35-gde5881d=
f904b)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.9-35-gde5881df904b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.9-35-gde5881df904b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de5881df904bff21d085c621bd4e9c2623ed289a =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/632351ccdcce6187a335564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
5-gde5881df904b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
5-gde5881df904b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632351ccdcce6187a3355=
64c
        failing since 29 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =20
