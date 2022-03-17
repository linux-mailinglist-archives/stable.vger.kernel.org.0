Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C64DBE72
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 06:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiCQFgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 01:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiCQFgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 01:36:02 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB84324D985
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:04:16 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id u30-20020a4a6c5e000000b00320d8dc2438so5185640oof.12
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gpuptqu7IBeM5Uz/2p++wtUUfc4io3pMUAWYDGlB6Ro=;
        b=KxIsRql6xzQfLvzMScqB9Gj+45+Av+6GUwIQpXpTMeEZID7POsW+pEjwMzn133fvOE
         yr4N2vXPHtw8bxZkQF19d7TGxv2UKkvCHhDfZ3lpgF3N3Cfv6a2bmDoFVZBLUvFi2qjo
         wS9eRGainTGXiSPSkMdPvA2SVi87qL1mZhS8bvogg6lZyjBAwYGnQSVLtMpcShf0zsGp
         c0kguWfTa0AEC6+hP+Knwy8nNkV9v6aNv9tjB8cL7WCFJMteDa0sn/S4/+J5Wdn3yft7
         A1R86FAmy1UAZM45+zf6jNud/VJeC4geqVxbFHkxE3aQ39EW+oaxBvL9h/xr5woJGy22
         MHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gpuptqu7IBeM5Uz/2p++wtUUfc4io3pMUAWYDGlB6Ro=;
        b=tKDqlIgsS5rsSyoJmZZz4hP1zyaBYKSKvo6gleyioZM4gXBkiw+ZqIdcMXmaz2hajl
         r4FNJ7aNenjHlmlnETQioEYoo8wpDFInLZ0dPVPeYITUrREiyRFW1vgu4uy5CygZEPAV
         s7fb+t5mmCwe9pP9xburpwuABAFWl5gSuiFNcL4TRZSfKyGeegbuia0QbF6WPAsvOq/j
         UJ1mFz+tHozUjKavR9LDScEqHFhWNPd1yvtrLitD3sFYD8EeXsUfUX3B3hoChKy3mSJV
         RFCsBng3E3HZ4EqpNmfkkVqFwcVoLHTitx8FhXzSGjMQnwNZ5IfOpyREMo+/SuY62FLg
         8jkg==
X-Gm-Message-State: AOAM530yRCXacA/jYPR+AJVmUcXaZqL/2RajC1IK9D3VXKfCyRJ5Wu6n
        JzC2haWX834Zl7ppVvGoDlrs/iAmWys2+lN8FmM=
X-Google-Smtp-Source: ABdhPJzazPGZaYiYGyd4fvA49tx/fJ+eqlas567ocwF1DuiblhJr372muCCds8OPAtz7enm73bfKUQ==
X-Received: by 2002:a17:90b:906:b0:1be:e765:882 with SMTP id bo6-20020a17090b090600b001bee7650882mr3116212pjb.152.1647488979085;
        Wed, 16 Mar 2022 20:49:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9-20020a056a0023c900b004f736d081d9sm5167734pfc.64.2022.03.16.20.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:49:38 -0700 (PDT)
Message-ID: <6232afd2.1c69fb81.a5bbe.e066@mx.google.com>
Date:   Wed, 16 Mar 2022 20:49:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.235
Subject: stable-rc/linux-4.19.y baseline: 76 runs, 1 regressions (v4.19.235)
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

stable-rc/linux-4.19.y baseline: 76 runs, 1 regressions (v4.19.235)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.235/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.235
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b481672f19259632a852d013cacd5655e8d7da8 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6232762a50d0166ebdc6296f

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
35/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
35/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6232762a50d0166ebdc62995
        failing since 10 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-03-16T23:43:28.832235  /lava-5894341/1/../bin/lava-test-case
    2022-03-16T23:43:28.841292  <8>[   36.805011] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
