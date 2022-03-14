Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD4C4D8F34
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 23:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbiCNWC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 18:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiCNWCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 18:02:55 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCC63BFB4
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 15:01:45 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p17so14683728plo.9
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 15:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4tn+VK8ggDzoXltIIL5MwUUUnbmf0H9I0nz+SMN6Lo4=;
        b=fvV/FbxjG62iEfFHd8cBLvjHlSzRi+akALtJSYy1liSruOsFk+FlAZcazGugWmXJXI
         d/PiMx50UOztGIeO9q4ey2NqfmPdD+aYehZJxfpfY3SWV/iZMLhdTh3Sqcj7bocYlsGH
         r4ZeI4qyWmsQeGL9WROb1ImsXDo60rU1qiAmBtME2q7RpNlL8ZhicT/J9GUfmTCI5dUh
         aMEdFyDpJZk/GJ5b8ztXWrqnFYvDvQY7Uo+gChWKwSgIMAZUP2ZoCUUSeXTvHEKaV0D0
         /zNxOo1Yc0O5LB8soOtUuZ5XN6fS725eYMe7GBZeSxPoOMMc/4ZcrMklE+c0aRn7zoKL
         6muw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4tn+VK8ggDzoXltIIL5MwUUUnbmf0H9I0nz+SMN6Lo4=;
        b=InbfV8uyWxK4x75LJVAtFRWWR5rQr8+Fi8AmGYRhViUIZYtDPm4gEGya9y9OQBHcif
         fnGSvR4dEJ2i96m/5mSmqLALSsguAFthGiO7/9j+3spHZCo+T30KIOLZS+aTL5R01NYr
         jSMBWMr/ICTn+DKAKjW8KmM+FdaI53+IjWa+Ax4vJiucs1Dd/B8nhbaGsvRAUW73UxJU
         OOavPp9qXgRhirFTvh7C7ikejVoI76pKfqsrrs5R4EjB3KxCRMIaATgt8Q3LB09+cFWj
         i5CE9r58DFmmvQTN+5Du+EdnxGQsjabV7cfIbcxGuYu2CPRCWudCFCKxuJxFucDXcknL
         NkoA==
X-Gm-Message-State: AOAM533/AT43f+QlwgMe7Z44Onj8+rIlVxBJvDxJX+P7joJGS5uS4l3V
        LZIKYnTRZuh4ElG7piw3TtpWI++hfZu6tQa4nh0=
X-Google-Smtp-Source: ABdhPJyvXoW1GruABXzsZXS9/SHt+rp+fBTyBxOYgs9UybtDGUlXOOUkWHiNP8zRqAaRZ8Q/OP0iTw==
X-Received: by 2002:a17:90a:9106:b0:1b9:115a:a2c1 with SMTP id k6-20020a17090a910600b001b9115aa2c1mr1277162pjo.80.1647295304583;
        Mon, 14 Mar 2022 15:01:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r1-20020a63b101000000b00380989bcb1bsm18521703pgf.5.2022.03.14.15.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 15:01:44 -0700 (PDT)
Message-ID: <622fbb48.1c69fb81.bf7ec.f487@mx.google.com>
Date:   Mon, 14 Mar 2022 15:01:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.14-122-gb2a408c85a22
Subject: stable-rc/linux-5.16.y baseline: 116 runs,
 1 regressions (v5.16.14-122-gb2a408c85a22)
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

stable-rc/linux-5.16.y baseline: 116 runs, 1 regressions (v5.16.14-122-gb2a=
408c85a22)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.14-122-gb2a408c85a22/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.14-122-gb2a408c85a22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2a408c85a229c023493aced7ac25f71e2f61107 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622f88e3025ce7f475c62981

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
4-122-gb2a408c85a22/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
4-122-gb2a408c85a22/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622f88e3025ce7f475c629a6
        failing since 8 days (last pass: v5.16.12, first fail: v5.16.12-166=
-g373826da847f)

    2022-03-14T18:26:17.725043  <8>[   32.274375] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-14T18:26:18.748960  /lava-5877361/1/../bin/lava-test-case
    2022-03-14T18:26:18.759737  <8>[   33.309090] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
