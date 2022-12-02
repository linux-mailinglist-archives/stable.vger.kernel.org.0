Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAD664104B
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 23:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiLBWAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 17:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiLBWAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 17:00:54 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCE2F8889
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 14:00:53 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so6312461pjm.2
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 14:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UAfIuWvGGN0IluXri0qHDVGJ6hTkZa6hFK5YUVTQ9e8=;
        b=HFiF3xue9AMeSGLa42412zy5rnWbxa6jrhh4N00vJQ9Mnq5Tx/QUZR02U6pmBXm64m
         xsxn2sNLauFZyWunw5CffCozvq/FyiMtLEIcVuJFqh7SwjZZeJqPLAPuLECbsz9ks/Xz
         6ndnZia6dxzFu96AVJdZ/BmAmaRAJI9RKwwl73+LvsC3guQqGlQn90rEHPg8EdmeWKjF
         ipnUO9/EcqiUD61DVj2AgAYuNYGj8bie6/nrn/d+3I6Df8mDdWK5rM68q/oxMHxCNhyh
         G5LQaDxlnEXdGy+BLPsP9uSQzOFzgWH+8hF+r3aRynQ/WXn5CN9n/YWAcTMyiSZFjeIj
         CWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UAfIuWvGGN0IluXri0qHDVGJ6hTkZa6hFK5YUVTQ9e8=;
        b=FX9xdDCx0OiwCeWMo85sIc64SA2ewZpzbazNoPAl+uRKfYYgyDewL2AiTIGkjuqX5S
         cbCwrZRD4OcWCviAhiltRaobpx1M2Glnne9mhMAG0aTrP3a9RBxuGkJ3eY6B5B9ea1qq
         MxSuH3x4MoWCIkzVEJoyaSpX0KbRpEn1Qxf7loqU+X9I1YFWsix1g3P/J1j7vyQp1S9M
         4PjgE/rBTb/I7hDiIoLhFxYkcQj/EgreGqQPZtB7rWixdoHruepMNQyabAq8Y2fWL/Uv
         aKUmykYUDk9d7PNQhBOMFLxDgeliyZOE4iomXNs26waypM28niFdRokBWUafuEG+juW5
         55Cg==
X-Gm-Message-State: ANoB5pncYSjStWpXiCEICMdrhF7r8Sq1c1cAqxtrxDo4zK/YbBpUjjy4
        ukZlpwjjUkxTus9uBUz8tcIOYBc0Fx1DNdOb/dS6MQ==
X-Google-Smtp-Source: AA0mqf4QTTUNIyP9rW7kMdxmBhxoV2svqcJ7J9W8j8j6mFXoEFsUcArD+CnMM2sGchQza47EOo9c1Q==
X-Received: by 2002:a17:90b:3944:b0:214:1df0:fe53 with SMTP id oe4-20020a17090b394400b002141df0fe53mr82194015pjb.214.1670018452432;
        Fri, 02 Dec 2022 14:00:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a6-20020a621a06000000b00575caf8478dsm5540904pfa.41.2022.12.02.14.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 14:00:51 -0800 (PST)
Message-ID: <638a7593.620a0220.7adf4.b4f3@mx.google.com>
Date:   Fri, 02 Dec 2022 14:00:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.81
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 128 runs, 1 regressions (v5.15.81)
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

stable/linux-5.15.y baseline: 128 runs, 1 regressions (v5.15.81)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.81/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e4a7232c917cd1b56d5b4fa9d7a23e3eabfecba0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/638a410c6b432744852abd0b

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.81/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.81/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/638a410c6b432744852abd2d
        failing since 268 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-12-02T18:16:23.157134  =

    2022-12-02T18:16:24.179388  /lava-8212267/1/../bin/lava-test-case
    2022-12-02T18:16:24.189711  <8>[   33.690010] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
