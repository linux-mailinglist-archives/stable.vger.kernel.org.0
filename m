Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D28B508BB6
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380037AbiDTPNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 11:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380140AbiDTPND (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 11:13:03 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1CE3E5F7
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 08:10:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso5212076pjb.5
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 08:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/vp1h9aLeNJHYpmudM0EIkzowhYJBcwAsrI5CXMbpfM=;
        b=IrGcy/EboD36iKmqhwDeAycXqHldHnVKxUZ2iaWg8jmdvHKOkqLy89IETPucVoChRy
         gh9F5lACMEaJ5x+N6vn/oYKBWC2nNm/4CW/akuD3jz/vTM76fRsSX1M+WDP68RPM1emx
         xO4QvZNdfh7s+n8+ZuOkKfqhIP3di07omksFjr1e18zMFLe2eHwD+dU5O6dbbq1hUHB4
         oY7iLemF8n+ZxovzcKzLUbyJPbpLoUhx6dgOGMf6u6YTmIkTbdX8D9KdO1arHnWAz+Y8
         4r5rq+9bAue2Z0w5v/h9ooqrrF0rQzAgx+PIO+qiC7I1COZyBzMDEzND+VIRNUuxgkK5
         9Kqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/vp1h9aLeNJHYpmudM0EIkzowhYJBcwAsrI5CXMbpfM=;
        b=6/JWFMlMPWHMmpePjOe0Futvj3Xd9E5sI6WEDpoSuZEii3MB/CfPZ0MkCZA0F2CH1Z
         yODZbTUray81hkm/fk9orNsWCFVxvM2bSyTMGNuB2YD/uE3Hb1dEGvZCk4wuX7Y8/j0Q
         Uo8lMk4FtK66I3mpmyRnfuQJXVF/1jxZUzKTmaZHszZOYaUs+u3k9xTqPLoAlT7ZMJCl
         cyyVS0VAiRVNh2u+39uK5S9sPeupOTVh7urw3ubWbEZb/1kxf0EewkRuAJ7tjIKSWwm9
         18hwVowsnz3SxjdkF1DsTus5ITQPh0GPdAh8iXfTHASrx3tW6/ePtO03ECeXRIaZXZmd
         WcYg==
X-Gm-Message-State: AOAM531zPIcv2saWMnVgRXVRig1fvWTbHCAQ8tXxippE7f/udDa51HxZ
        6zhzDFmoBHA6HhJBOAr1od69YJZ4zbWB6Fqkw2o=
X-Google-Smtp-Source: ABdhPJz1gc2yR8mlVy3mOzX750+ZQygd32T0paXroKPXm3UmS9naaBMuXORwAjrMfULxSDxrcCBLWw==
X-Received: by 2002:a17:90a:f3d6:b0:1cb:a0aa:5e60 with SMTP id ha22-20020a17090af3d600b001cba0aa5e60mr5005814pjb.161.1650467416465;
        Wed, 20 Apr 2022 08:10:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2-20020a6541c2000000b0039d1280084asm19383958pgq.26.2022.04.20.08.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 08:10:16 -0700 (PDT)
Message-ID: <62602258.1c69fb81.aefb0.e430@mx.google.com>
Date:   Wed, 20 Apr 2022 08:10:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.35
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 74 runs, 1 regressions (v5.15.35)
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

stable/linux-5.15.y baseline: 74 runs, 1 regressions (v5.15.35)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.35/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      81d8d30c35edf29c5c70186ccb14dac4a5ca38a8 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625fefdc1dea4c6901ae06a3

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.35/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.35/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625fefdc1dea4c6901ae06c5
        failing since 42 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-04-20T11:34:32.483694  <8>[   32.655242] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-20T11:34:33.506352  /lava-6130575/1/../bin/lava-test-case
    2022-04-20T11:34:33.517678  <8>[   33.689738] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
