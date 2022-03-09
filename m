Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323154D2977
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 08:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiCIHar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 02:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiCIHar (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 02:30:47 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7C022B00
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 23:29:48 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t187so1275213pgb.1
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 23:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u2K0Q0znKaCfLDQQR1o0zuXZM4VIqm8LUZ7jKeN29yk=;
        b=b882Pz2grD9JRbUaF3QX8o4PDnoX2DxZdNGibuXmD0oT+mqG0lkSlOMvOq9cxxzBKd
         xdUEJyOSvYKAaddgE2lfN6XKe5O368NixUptgktvCN3uthh3WrAOr1MfjeuwpxXN/U+3
         Guui9Ro896hv163FbAgQfO4YN+w4+kmF0or/L2RkAyugqZbd8MV1xF/vsyK0y8t+xOhO
         7632zCTGs5Mr/afZ271QplAkh9QWqVDIji+mZqXaAZO5P9hEf6xrQDQ8GduE/ynUrg4L
         2vtPNs+f8K6djmJgIXlwjGL4w5TJJaMsvOdjhO5wJ8JW58p92+iI5jIwf2L6eJ+F8c8B
         OVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u2K0Q0znKaCfLDQQR1o0zuXZM4VIqm8LUZ7jKeN29yk=;
        b=miPreza54VTauDSXHlfz9sIBqnnpYOrNkpm3i4x4A0CJS1vKv4zysA6JlMx6JiXpTw
         ZPgxHI3lNETE5rR8Wye5IYN/QkXDmfDit02uZBg/N0csX3uvRjZLNTEecGWIzkdLmZb8
         PV7VXIlqBC3bKi7y6AIEoNFwufusb3tc6T6YhnOVTXHCn2JqUcTORySv3pyP2tjkDRdg
         uOE//UPc/3wvdbD32a2hZwpJUBNM4Wm5H4z9KeRewdd2SOqk7X8iBsiWM7b1Xu3qwuyw
         y+L5jFArqX5tKaRm0ViaaIx3Hq0V77PAw9rDi2S5dicVRiZFTzCiUKbw84nUtp0YYTCM
         gVhg==
X-Gm-Message-State: AOAM533nZtggsKzc786cd6+vDz0UcTP6+RnwAmIC0eixYWWxXaM8fWhF
        ISzUAkiJulJePGMjad2+B0KEcjnxNO/tIoasHBM=
X-Google-Smtp-Source: ABdhPJzulQ9uugEMr5KKaz8lSggvpVbrrxw7rhvl27+yBGl/NyJFiTnrM0pFGiaCyovbhUmD3kT7/Q==
X-Received: by 2002:a63:2c91:0:b0:373:7200:d079 with SMTP id s139-20020a632c91000000b003737200d079mr17505836pgs.65.1646810988059;
        Tue, 08 Mar 2022 23:29:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090ad99000b001bcbc4247a0sm1378996pjv.57.2022.03.08.23.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:29:47 -0800 (PST)
Message-ID: <6228576b.1c69fb81.a6534.3bc9@mx.google.com>
Date:   Tue, 08 Mar 2022 23:29:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.233-19-g83f8068e02bc
Subject: stable-rc/linux-4.19.y baseline: 9 runs,
 1 regressions (v4.19.233-19-g83f8068e02bc)
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

stable-rc/linux-4.19.y baseline: 9 runs, 1 regressions (v4.19.233-19-g83f80=
68e02bc)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.233-19-g83f8068e02bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.233-19-g83f8068e02bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      83f8068e02bc15b911fdb0c23b1f6a3f3575670a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622820409b9f34e393c629d8

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
33-19-g83f8068e02bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
33-19-g83f8068e02bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622820409b9f34e393c629fd
        failing since 2 days (last pass: v4.19.232, first fail: v4.19.232-4=
5-g5da8d73687e7)

    2022-03-09T03:34:11.432300  /lava-5842885/1/../bin/lava-test-case<8>[  =
 35.603807] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s0-probed RESUL=
T=3Dpass>
    2022-03-09T03:34:11.432372  =

    2022-03-09T03:34:12.447849  /lava-5842885/1/../bin/lava-test-case
    2022-03-09T03:34:12.456507  <8>[   36.627646] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
