Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1512157F09A
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 19:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbiGWR3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 13:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiGWR3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 13:29:10 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0215F18E3D
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 10:29:09 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c139so6948821pfc.2
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 10:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SBuEa/lhXgxkUW2FhBnzM7bNvNwDios8eFrJxnH0Y9Q=;
        b=YaX+KVYu6bDlJWUY70Jb99rifLMgDQPHQ2RcJ3YELYl6QkyL+XmKvsuJxx6gkwrrN+
         snz3Y4uVQ37uchlINZX2Axslc3wvIolTEFLS3id9X0TEUNBGa1LGRH+ZJL44NTYJeNGv
         MmEsjR6YzxTfm1SblqBhG10aLFokIAra0xwlqMWSpNeSkm1aqtNoNPZbUutw2+AZ7yn2
         oFEQ0dJvoNdPd+x2kDj8yx9A+GbxAMdCduHdFMiXbUYv0KfXX/BH/un1sQU/dDfCAomH
         tGQ8DynhENHqhY+WaDHqBXWmjenRnQSp9AEDcsZ7XU8ZYr+ymFFjOBoC/UVZxRPAeGLV
         TXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SBuEa/lhXgxkUW2FhBnzM7bNvNwDios8eFrJxnH0Y9Q=;
        b=uoljR1fhaJwhIFlBOqDo1kTiL/sw+LIFyTHXWN1ecek+Lj6vq34pSwAV/8wFOOCuWL
         RI68g++n5e6gTBOLFqNHh+81AdS1iASRaAaG6ZWU0Y+hJn3+JBvjceugSyZFAKJW/wPm
         sTLVezQzFIzXdwr4WJVTgc9FWd9lyRs8+jvoEju9rhW/A8gQNo34O2cGyo0dGzwoRzP1
         YEzwIWJJh++G6vHiULWRqjOehOS0fRmjv6ilO3WtaxzEweeCoB5V2mnYPPSSAc4CrG9B
         WXjzhke6Elge5QBEYAiDdw/F9u9K4gdTnIAJQy0FoRO/RRa96e7SwhQPhFkyS8jBwrEg
         wXNw==
X-Gm-Message-State: AJIora+UjnZBCn5dS9fj8Q6dplcSgwkxwcLTh6j9DxuiCBpjj9gfz28+
        xQbwR0VTdrlYW0FlT/BtK0GYGF7aEeJurejX
X-Google-Smtp-Source: AGRyM1sSDAUpinVQ+XjlNy4uMhhcQT+Y60Ia3WiNaMjgl7EpdFE7hgjnTjjmtozXoHROhyDViTPJGg==
X-Received: by 2002:a63:4a12:0:b0:419:9ede:b7a0 with SMTP id x18-20020a634a12000000b004199edeb7a0mr4512943pga.167.1658597349231;
        Sat, 23 Jul 2022 10:29:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a139-20020a621a91000000b005290553d343sm6196998pfa.193.2022.07.23.10.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 10:29:08 -0700 (PDT)
Message-ID: <62dc2fe4.1c69fb81.9218b.9831@mx.google.com>
Date:   Sat, 23 Jul 2022 10:29:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57
Subject: stable-rc/linux-5.15.y baseline: 173 runs, 2 regressions (v5.15.57)
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

stable-rc/linux-5.15.y baseline: 173 runs, 2 regressions (v5.15.57)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.57/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.57
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a9e2d8e52e1c0d87c0fa4f9d2d38e210aabed515 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62dbfe0d3af2862b2ddaf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62dbfe0d3af2862b2ddaf=
066
        failing since 71 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62dbfa3e175b20dcd0daf0ec

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62dbfa3e175b20dcd0daf10e
        failing since 137 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-07-23T13:40:05.157940  /lava-6877437/1/../bin/lava-test-case
    2022-07-23T13:40:05.169195  <8>[   33.379878] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
