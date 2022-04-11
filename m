Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793DD4FC646
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 23:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345823AbiDKVDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 17:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239690AbiDKVDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 17:03:48 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E32D6149
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 14:01:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c23so14972286plo.0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 14:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/kk9/0XEWFiRqfi5V84ef35P4c4tzoLInq5h6smYfDg=;
        b=fIg5bLHpLAs1qjpKqCww4YkaSnXZAVHIBFAWFviQZyYAu5gbS+fndGu6PQCmrpesBo
         Nz8amfqygGyYAFysx1i4P70c7VSV1D06wBiLxjjYLwVPUie8tsFeTCWZiIXdShYJEcLQ
         HdVwJ0cLWfpYOz9QB3ibt9uXP9NiR5VcOwWBra4wkjLy/d6CXp7LURfd6gtoQT3peRyf
         WchvO4E9RwOfiyVBnrJOlGHu5B2FtGXESTktArAPKr68yxMwL4Wr9EuSYCwMauH246x2
         OaLIbWVWsKo+wt3CrXRStIGuoofxLchHIxEc39vnsoUcbFmK7mBofc3BAT/jcc0bgAnj
         QZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/kk9/0XEWFiRqfi5V84ef35P4c4tzoLInq5h6smYfDg=;
        b=AnbO76fNTvwvZY97/amSwzHCslyIPOiOYstla7VE1BjwWpyCDh+muFPZVcVkKLjy7p
         vDsGz664xxybwTpoCVG/Qz8up5ow5yXsnJ06BacrXm/M3aXU+/vzelqUWtklq5MLWFm7
         EINFjxGUoHieHH0yKbFTS0KACiU1ZzUI4b812vC1XlbY5D81Ju5hCOcyAdEXew6onteD
         rWwWpeTiH0q/9hTGpp7e7rGtFxXIAeE/IJ78ouOdxGFCroedB0cus6KSbZjBZ4ifOPH+
         M9a7xcTFLSN2T7LXN8Edtdr7PNfV/cqqM17xr8xMU1KkoscRqOD7DOGyZ2F9pM1v0k4y
         JAEQ==
X-Gm-Message-State: AOAM531sdzhcFSWiCUDeWJUcUI7AXi5fFmg/4JWUy8xo4CRKs9EpGiXT
        /jpL/Eog/uHMN67MLv0E21aaKFOiZVLyuUwz
X-Google-Smtp-Source: ABdhPJwHR8/LN6WUOsHHmTp/qkt1+q+us49bDou2DvqoEmwb46fgu1gDjzoLtMaLxXdZ+beT1AIBqw==
X-Received: by 2002:a17:902:8ec8:b0:156:847b:a8f8 with SMTP id x8-20020a1709028ec800b00156847ba8f8mr34915072plo.121.1649710891425;
        Mon, 11 Apr 2022 14:01:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y16-20020a637d10000000b00381268f2c6fsm598168pgc.4.2022.04.11.14.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 14:01:30 -0700 (PDT)
Message-ID: <6254972a.1c69fb81.5932f.223b@mx.google.com>
Date:   Mon, 11 Apr 2022 14:01:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.33
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 128 runs, 1 regressions (v5.15.33)
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

stable-rc/linux-5.15.y baseline: 128 runs, 1 regressions (v5.15.33)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06f50ca83ace219cb72213369d2be05bb0dd337e =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625466690d42289f07ae0680

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625466690d42289f07ae06a2
        failing since 34 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-04-11T17:33:06.508608  /lava-6064397/1/../bin/lava-test-case
    2022-04-11T17:33:06.518873  <8>[   33.485844] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
