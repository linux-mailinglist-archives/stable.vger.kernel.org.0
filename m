Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3AC4DB936
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 21:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbiCPUOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 16:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbiCPUOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 16:14:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BA52C131
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 13:13:29 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so3548189pju.2
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 13:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j0AvlZDHL7aI8kCpSa++rd6zJs8BApy2rmE2qZh0C8U=;
        b=m/DX8cAwPYX2i01q5Lvkb6MTzJ4VBtsKPMzVJMun5JXNHhIs6sxPfuWFJWzpX57/Zc
         fBqSJ7AE69QCDWupREIRZ7WgWbjkbhW/jtReDxZLuwvbdxGoIb8ntL5kApzxRhw9XpsI
         cbgggdI5bRtVA4jHHfzlxjMa7HO0mQpI6oXSOU6NOdT0eV1/xscB25dz4U58hf/FcLk7
         ijB8bgud8eGZjsgUE7WTCaKFttbVyN5EGfTbFfY4U9Dh2ugs3aMcOw66GZuyYFldBmdD
         i/Jc26DAI+xonie3nc1Cee99Fes8XymXv+2U1RBddZyqQIQHnCk7zjbcCOybHZK4nAST
         xszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j0AvlZDHL7aI8kCpSa++rd6zJs8BApy2rmE2qZh0C8U=;
        b=K71e4t1xh3ZgkuYv1Mnva/nNgFqqTcIwSpwbxDMcBTm14d5aFi22KNaN4rhRaEnwoF
         njfMmKkq/UGAy1hJcz2T/CdsCNQTUnUZ0h1mejMrwRBgW6TThjJdMjV9qzWUfYoUywge
         pg8VEyLtD4YD0xPqiygZTExpRHU+By6yBY2WIwPZ0RM/DN9gTaT6lPRzHEv4npNYBGM7
         gnnyKgFNnFF5UQkCcOZzq4FvV6h+3cfLzNfD+Fp24KEDPhJof4qEWsS8Hc0PVC7ZWCMp
         o1WpHbaRiTsvoyvOOCeGCHNX9rVdZ3v0WkDPHNu42jc37zXRl1OdqY6gU7QZEVKaEqQu
         a8bQ==
X-Gm-Message-State: AOAM530qM1R/fL21CZhecgZDJaRxJM7DXvd90qOlRMUkjEeYllgvBVNS
        4flgdFQtKiqcwwVDwhdjqWCdA8WsMuI0Tbl7vJE=
X-Google-Smtp-Source: ABdhPJwuGq7jXTnIvWDoR9E4TQMWqjaqfFgUsiARxz3sIk10e8q22WlKVrh/UOMMsWxOMwcsfNGdHQ==
X-Received: by 2002:a17:90a:a58e:b0:1bd:4752:90cf with SMTP id b14-20020a17090aa58e00b001bd475290cfmr1516387pjq.54.1647461609161;
        Wed, 16 Mar 2022 13:13:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l13-20020a056a00140d00b004e13da93eaasm4113802pfu.62.2022.03.16.13.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 13:13:28 -0700 (PDT)
Message-ID: <623244e8.1c69fb81.662fb.9eed@mx.google.com>
Date:   Wed, 16 Mar 2022 13:13:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.14-124-g185a62c72e45
Subject: stable-rc/queue/5.16 baseline: 103 runs,
 1 regressions (v5.16.14-124-g185a62c72e45)
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

stable-rc/queue/5.16 baseline: 103 runs, 1 regressions (v5.16.14-124-g185a6=
2c72e45)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.14-124-g185a62c72e45/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.14-124-g185a62c72e45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      185a62c72e45eaa5493de923f7dc4281316039fd =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6232157d1318f17109c62a2b

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
124-g185a62c72e45/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
124-g185a62c72e45/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6232157d1318f17109c62a51
        failing since 8 days (last pass: v5.16.12-85-g060a81f57a12, first f=
ail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-16T16:50:47.587489  <8>[   32.373809] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T16:50:48.609440  /lava-5891800/1/../bin/lava-test-case
    2022-03-16T16:50:48.622024  <8>[   33.410052] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
