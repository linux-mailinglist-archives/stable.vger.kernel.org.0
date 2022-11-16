Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F7562C1B4
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 16:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiKPPBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 10:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiKPPB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 10:01:29 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F92B22
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 07:01:27 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id v3so16895315pgh.4
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 07:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/KsDJd1QNaHa2LUJ79lhmmiYoU1ga9i/DExwOkCvsFU=;
        b=yQIuAMgDQdaoTt8ZE2VJ2AjQMJ7uOU9dH+cETgkWTDsC01TXSQA7S1tkCv1fPJrvaq
         Dv+vLEpb5e+QXToeRUqdeVpZZbFVg56msVtLqx0RwmhLmR0n44qcGZQXkgkRK0fxItdh
         P9yt+mr+hFp/TlunVnqa4ckIyYeYsS31mSdUOxA/k2PPdXW6eGzRxU+VLCWskJminLmT
         ANLG5j2fES6bVqjB8YVG3ZjnRHV8Z5cY3UmWX0ufDKxpqKh6weVfBmksWRnn0DdlmGDE
         aI34+MLgWAfAMbvGHUeh/p5mFjZBnc54LaYzqooIKUf/Jcv6cmLK0s6QQauj6gZHRZNJ
         v4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/KsDJd1QNaHa2LUJ79lhmmiYoU1ga9i/DExwOkCvsFU=;
        b=TyG//xNO+E8QFVdmo4mV3NhUBkZOZ0lqG7JRTuKG9tA5ETnYF0ihg6EZue5e9qJ3iZ
         Mdom7rSVc8tNBCfISF27pXfjGk7LZFipVqKTcTaxvTovA65FyjGppSmPfXjkFJQl8nyk
         squgvHYOxBshdZ0qmU6US/fAOUz99/XGPLVd/OkY1L36IUNsRdvPhaI5rUteeIMuTLrg
         gwVJc9jIYack+xnq0Jn1NG3PoiO/lMU8q1wDLBxYiArLCfuKUIZQX7kmMwxGM/azx9wG
         M6QR8Bpu7WSgbHkt4WFepfgUTLEvaaYi4mwTlWwVcopO0xAygPlEU9kJ2D8648zSgYN7
         yzdA==
X-Gm-Message-State: ANoB5pnM16l0lThCKrKrs8jl12fwaD++OkTtFzV3yejKMF7JVORH33HZ
        XqIuOZvmzaPczB1XiybbmIavna90cVHP6+yb1e4=
X-Google-Smtp-Source: AA0mqf5F+UqdfdUbrWDyTAMC0yGKRYcdi6l2bsxWrjvsFDh0LAN4CuYFoIurRoMcHcrCeE+XREB9lA==
X-Received: by 2002:a62:58c4:0:b0:572:2189:84ef with SMTP id m187-20020a6258c4000000b00572218984efmr13944561pfb.28.1668610886851;
        Wed, 16 Nov 2022 07:01:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6-20020a655786000000b0043a0de69c94sm9590912pgr.14.2022.11.16.07.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 07:01:26 -0800 (PST)
Message-ID: <6374fb46.650a0220.ea163.eb3f@mx.google.com>
Date:   Wed, 16 Nov 2022 07:01:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.155
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 147 runs, 1 regressions (v5.10.155)
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

stable/linux-5.10.y baseline: 147 runs, 1 regressions (v5.10.155)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.155/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.155
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      41217963b1d97ec170f24fc4155953a2b0835191 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6374d0209530a1b49e2abd21

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.155/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.155/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6374d0209530a1b49e2abd43
        failing since 252 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-11-16T11:57:03.835254  =

    2022-11-16T11:57:04.859170  /lava-7998605/1/../bin/lava-test-case
    2022-11-16T11:57:04.869737  <8>[   60.668047] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
